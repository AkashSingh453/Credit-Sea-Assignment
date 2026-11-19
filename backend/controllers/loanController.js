const { validationResult } = require('express-validator');
const LoanApplication = require('../models/LoanApplication');
const User = require('../models/User');

/**
 * @route   POST /api/loans/calculate
 * @desc    Calculate EMI without creating application
 * @access  Private
 */
const calculateEmi = async (req, res) => {
  try {
    const { loanAmount, tenure, interestRate = 14 } = req.body;

    if (!loanAmount || !tenure) {
      return res.status(400).json({
        success: false,
        message: 'Loan amount and tenure are required.',
      });
    }

    const principal = parseFloat(loanAmount);
    const monthlyRate = interestRate / 12 / 100;
    const n = parseInt(tenure);

    let emi;
    if (monthlyRate > 0) {
      emi = Math.round(
        (principal * monthlyRate * Math.pow(1 + monthlyRate, n)) /
          (Math.pow(1 + monthlyRate, n) - 1)
      );
    } else {
      emi = Math.round(principal / n);
    }

    const totalPayable = emi * n;
    const totalInterest = totalPayable - principal;
    const processingFee = Math.round(principal * 0.02);

    res.status(200).json({
      success: true,
      data: {
        loanAmount: principal,
        tenure: n,
        interestRate,
        monthlyEmi: emi,
        totalPayable,
        totalInterest,
        processingFee,
      },
    });
  } catch (error) {
    console.error('Calculate EMI Error:', error);
    res.status(500).json({
      success: false,
      message: 'EMI calculation failed.',
    });
  }
};

/**
 * @route   POST /api/loans/check-eligibility
 * @desc    Check loan eligibility based on user profile
 * @access  Private
 */
const checkEligibility = async (req, res) => {
  try {
    const user = await User.findById(req.user._id);

    const eligibility = {
      isEligible: false,
      maxLoanAmount: 0,
      reasons: [],
      creditScore: user.creditScore,
    };

    // Check profile completeness
    if (!user.isProfileComplete) {
      eligibility.reasons.push('Profile is incomplete. Please fill all required details.');
      return res.status(200).json({ success: true, data: eligibility });
    }

    // Check minimum income (₹10,000/month)
    if (user.monthlyIncome < 10000) {
      eligibility.reasons.push('Minimum monthly income of ₹10,000 is required.');
    }

    // Check credit score (minimum 500)
    if (user.creditScore < 500) {
      eligibility.reasons.push('Credit score is below the minimum requirement of 500.');
    }

    // Check employment type
    if (user.employmentType === 'Student') {
      eligibility.reasons.push('Students are not eligible for loans at this time.');
    }

    // Check PAN
    if (!user.panNumber) {
      eligibility.reasons.push('PAN card details are required.');
    }

    // If no disqualifying reasons, user is eligible
    if (eligibility.reasons.length === 0) {
      eligibility.isEligible = true;

      // Calculate max loan amount based on income and credit score
      let multiplier = 5; // Default: 5x monthly income

      if (user.creditScore >= 800) multiplier = 10;
      else if (user.creditScore >= 750) multiplier = 8;
      else if (user.creditScore >= 700) multiplier = 7;
      else if (user.creditScore >= 650) multiplier = 6;

      eligibility.maxLoanAmount = Math.min(
        user.monthlyIncome * multiplier,
        1000000 // Cap at ₹10 Lakhs
      );

      eligibility.reasons.push('You are eligible for a loan!');
    }

    res.status(200).json({
      success: true,
      data: eligibility,
    });
  } catch (error) {
    console.error('Check Eligibility Error:', error);
    res.status(500).json({
      success: false,
      message: 'Eligibility check failed.',
    });
  }
};

/**
 * @route   POST /api/loans/apply
 * @desc    Submit a new loan application
 * @access  Private
 */
const applyLoan = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array(),
      });
    }

    const user = await User.findById(req.user._id);

    // Verify profile is complete
    if (!user.isProfileComplete) {
      return res.status(400).json({
        success: false,
        message: 'Please complete your profile before applying for a loan.',
      });
    }

    // Verify basic eligibility
    if (user.monthlyIncome < 10000) {
      return res.status(400).json({
        success: false,
        message: 'Minimum monthly income of ₹10,000 is required.',
      });
    }

    if (user.creditScore < 500) {
      return res.status(400).json({
        success: false,
        message: 'Your credit score is too low to apply for a loan.',
      });
    }

    const { loanAmount, tenure, tenureUnit, purpose } = req.body;

    // Create loan application
    const loanApplication = await LoanApplication.create({
      user: req.user._id,
      loanAmount,
      tenure,
      tenureUnit: tenureUnit || 'days',
      purpose: purpose || 'Personal',
      status: 'Submitted',
      statusHistory: [
        {
          status: 'Submitted',
          timestamp: new Date(),
          remarks: 'Application submitted successfully.',
        },
      ],
    });

    console.log(
      `📋 New Loan Application: ${loanApplication.referenceId} | ₹${loanAmount} | ${tenure} months | User: ${user.phone}`
    );

    // Auto-advance to "Under Review" after 5 seconds (simulate processing)
    setTimeout(async () => {
      try {
        const loan = await LoanApplication.findById(loanApplication._id);
        if (loan && loan.status === 'Submitted') {
          loan.status = 'Under Review';
          loan.statusHistory.push({
            status: 'Under Review',
            timestamp: new Date(),
            remarks: 'Application is being reviewed by our team.',
          });
          await loan.save();
          console.log(`🔍 Loan ${loan.referenceId} moved to Under Review`);
        }
      } catch (err) {
        console.error('Auto-review error:', err);
      }
    }, 5000);

    res.status(201).json({
      success: true,
      message: 'Loan application submitted successfully!',
      data: loanApplication,
    });
  } catch (error) {
    console.error('Apply Loan Error:', error);
    if (error.name === 'ValidationError') {
      const messages = Object.values(error.errors).map((e) => e.message);
      return res.status(400).json({
        success: false,
        message: 'Validation failed.',
        errors: messages,
      });
    }
    res.status(500).json({
      success: false,
      message: 'Loan application failed.',
    });
  }
};

/**
 * @route   GET /api/loans
 * @desc    Get all loan applications for current user
 * @access  Private
 */
const getMyLoans = async (req, res) => {
  try {
    const { status, page = 1, limit = 10 } = req.query;

    const query = { user: req.user._id };
    if (status) {
      query.status = status;
    }

    const loans = await LoanApplication.find(query)
      .sort({ createdAt: -1 })
      .skip((page - 1) * limit)
      .limit(parseInt(limit));

    const total = await LoanApplication.countDocuments(query);

    res.status(200).json({
      success: true,
      data: {
        loans,
        pagination: {
          total,
          page: parseInt(page),
          pages: Math.ceil(total / limit),
        },
      },
    });
  } catch (error) {
    console.error('Get Loans Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch loans.',
    });
  }
};

/**
 * @route   GET /api/loans/:id
 * @desc    Get single loan application details
 * @access  Private
 */
const getLoanById = async (req, res) => {
  try {
    const loan = await LoanApplication.findOne({
      _id: req.params.id,
      user: req.user._id,
    });

    if (!loan) {
      return res.status(404).json({
        success: false,
        message: 'Loan application not found.',
      });
    }

    res.status(200).json({
      success: true,
      data: loan,
    });
  } catch (error) {
    console.error('Get Loan Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch loan details.',
    });
  }
};

/**
 * @route   PATCH /api/loans/:id/status
 * @desc    Update loan status (admin/demo endpoint)
 * @access  Private
 */
const updateLoanStatus = async (req, res) => {
  try {
    const { status, remarks } = req.body;
    const validStatuses = ['Submitted', 'Under Review', 'Approved', 'Rejected', 'Disbursed'];

    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        message: `Invalid status. Must be one of: ${validStatuses.join(', ')}`,
      });
    }

    const loan = await LoanApplication.findOne({
      _id: req.params.id,
      user: req.user._id,
    });

    if (!loan) {
      return res.status(404).json({
        success: false,
        message: 'Loan application not found.',
      });
    }

    // Update status
    loan.status = status;
    loan.statusHistory.push({
      status,
      timestamp: new Date(),
      remarks: remarks || `Status updated to ${status}`,
    });

    // Handle specific status updates
    if (status === 'Rejected' && req.body.rejectionReason) {
      loan.rejectionReason = req.body.rejectionReason;
    }

    if (status === 'Disbursed') {
      loan.disbursedAmount = loan.loanAmount;
      loan.disbursedAt = new Date();

      // Bonus: Increase credit score on disbursement
      const user = await User.findById(req.user._id);
      user.creditScore = Math.min(900, user.creditScore + 10);
      await user.save();
    }

    if (status === 'Approved') {
      // Bonus: Slight credit score bump on approval
      const user = await User.findById(req.user._id);
      user.creditScore = Math.min(900, user.creditScore + 5);
      await user.save();
    }

    await loan.save();

    console.log(`📝 Loan ${loan.referenceId} status updated to: ${status}`);

    res.status(200).json({
      success: true,
      message: `Loan status updated to ${status}.`,
      data: loan,
    });
  } catch (error) {
    console.error('Update Loan Status Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to update loan status.',
    });
  }
};

/**
 * @route   GET /api/loans/stats/summary
 * @desc    Get loan statistics summary for dashboard
 * @access  Private
 */
const getLoanStats = async (req, res) => {
  try {
    const userId = req.user._id;

    const [totalLoans, activeLoans, approvedAmount, stats] = await Promise.all([
      LoanApplication.countDocuments({ user: userId }),
      LoanApplication.countDocuments({
        user: userId,
        status: { $in: ['Submitted', 'Under Review', 'Approved'] },
      }),
      LoanApplication.aggregate([
        { $match: { user: userId, status: { $in: ['Approved', 'Disbursed'] } } },
        { $group: { _id: null, total: { $sum: '$loanAmount' } } },
      ]),
      LoanApplication.aggregate([
        { $match: { user: userId } },
        { $group: { _id: '$status', count: { $sum: 1 } } },
      ]),
    ]);

    res.status(200).json({
      success: true,
      data: {
        totalLoans,
        activeLoans,
        totalApprovedAmount: approvedAmount[0]?.total || 0,
        statusBreakdown: stats.reduce((acc, s) => {
          acc[s._id] = s.count;
          return acc;
        }, {}),
        creditScore: req.user.creditScore,
      },
    });
  } catch (error) {
    console.error('Get Loan Stats Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch loan statistics.',
    });
  }
};

module.exports = {
  calculateEmi,
  checkEligibility,
  applyLoan,
  getMyLoans,
  getLoanById,
  updateLoanStatus,
  getLoanStats,
};
