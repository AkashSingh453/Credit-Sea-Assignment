const mongoose = require('mongoose');

const loanApplicationSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    // Loan Details
    loanAmount: {
      type: Number,
      required: [true, 'Loan amount is required'],
      min: [1000, 'Minimum loan amount is ₹1,000'],
      max: [1000000, 'Maximum loan amount is ₹10,00,000'],
    },
    tenure: {
      type: Number,
      required: [true, 'Tenure is required'],
      min: [1, 'Tenure must be at least 1'],
    },
    tenureUnit: {
      type: String,
      enum: ['days', 'months'],
      default: 'days',
    },
    interestRate: {
      type: Number,
      default: 14, // 14% per annum
    },
    monthlyEmi: {
      type: Number,
      default: 0,
    },
    totalPayable: {
      type: Number,
      default: 0,
    },
    processingFee: {
      type: Number,
      default: 0,
    },
    // Purpose
    purpose: {
      type: String,
      enum: [
        'Personal',
        'Education',
        'Medical',
        'Home Improvement',
        'Business',
        'Debt Consolidation',
        'Travel',
        'Other',
      ],
      default: 'Personal',
    },
    // Application Status Flow: Submitted → Under Review → Approved/Rejected → Disbursed
    status: {
      type: String,
      enum: ['Submitted', 'Under Review', 'Approved', 'Rejected', 'Disbursed'],
      default: 'Submitted',
    },
    statusHistory: [
      {
        status: {
          type: String,
          enum: ['Submitted', 'Under Review', 'Approved', 'Rejected', 'Disbursed'],
        },
        timestamp: {
          type: Date,
          default: Date.now,
        },
        remarks: {
          type: String,
          default: '',
        },
      },
    ],
    // Rejection reason (if rejected)
    rejectionReason: {
      type: String,
      default: '',
    },
    // Reference ID for tracking
    referenceId: {
      type: String,
      unique: true,
    },
    // Disbursement details
    disbursedAmount: {
      type: Number,
      default: 0,
    },
    disbursedAt: {
      type: Date,
      default: null,
    },
  },
  {
    timestamps: true,
  }
);

// Generate unique reference ID before saving
loanApplicationSchema.pre('save', function (next) {
  if (!this.referenceId) {
    const prefix = 'CS';
    const timestamp = Date.now().toString(36).toUpperCase();
    const random = Math.random().toString(36).substring(2, 6).toUpperCase();
    this.referenceId = `${prefix}${timestamp}${random}`;
  }

  // Calculate EMI / total payable
  if (this.loanAmount && this.tenure) {
    const principal = this.loanAmount;

    if (this.tenureUnit === 'months') {
      const rate = this.interestRate || 14;
      const monthlyRate = rate / 12 / 100;
      const n = this.tenure;

      if (monthlyRate > 0) {
        this.monthlyEmi = Math.round(
          (principal * monthlyRate * Math.pow(1 + monthlyRate, n)) /
            (Math.pow(1 + monthlyRate, n) - 1)
        );
      } else {
        this.monthlyEmi = Math.round(principal / n);
      }

      this.totalPayable = this.monthlyEmi * n;
    } else {
      // Days-based loan (Figma design: 1% per day, e.g. 20-90 days)
      const dailyRate = 0.01;
      const totalInterest = Math.round(principal * dailyRate * this.tenure);
      this.totalPayable = principal + totalInterest;
      this.monthlyEmi = this.totalPayable;
    }

    this.processingFee = Math.round(principal * 0.02); // 2% processing fee
  }

  next();
});

// Index for user loan queries
loanApplicationSchema.index({ user: 1, status: 1 });

module.exports = mongoose.model('LoanApplication', loanApplicationSchema);
