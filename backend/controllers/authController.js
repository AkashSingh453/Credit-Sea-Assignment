const jwt = require('jsonwebtoken');
const { validationResult } = require('express-validator');
const User = require('../models/User');
const Otp = require('../models/Otp');

/**
 * Generate a random 4-digit OTP
 */
const generateOTP = () => {
  return Math.floor(1000 + Math.random() * 9000).toString();
};

/**
 * Generate JWT token
 */
const generateToken = (userId) => {
  return jwt.sign({ id: userId }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || '30d',
  });
};

/**
 * @route   POST /api/auth/send-otp
 * @desc    Generate and send mock OTP to phone number
 * @access  Public
 */
const sendOtp = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array(),
      });
    }

    const { phone } = req.body;

    // Delete any existing OTPs for this phone
    await Otp.deleteMany({ phone });

    // Generate new 4-digit OTP
    const otpCode = generateOTP();

    // Set expiry (default 5 minutes)
    const expiryMinutes = parseInt(process.env.OTP_EXPIRY_MINUTES) || 5;
    const expiresAt = new Date(Date.now() + expiryMinutes * 60 * 1000);

    // Save OTP to database
    await Otp.create({
      phone,
      otp: otpCode,
      expiresAt,
    });

    // ========================================
    // 🔥 MOCK OTP — Printed to server console
    // ========================================
    console.log('\n' + '='.repeat(50));
    console.log(`📱 OTP for +91 ${phone}: [ ${otpCode} ]`);
    console.log(`⏰ Expires at: ${expiresAt.toLocaleTimeString()}`);
    console.log('='.repeat(50) + '\n');

    res.status(200).json({
      success: true,
      message: 'OTP sent successfully. Check the server console.',
      data: {
        phone,
        expiresInMinutes: expiryMinutes,
        // In development, we also return OTP in response for easy testing
        ...(process.env.NODE_ENV !== 'production' && { otp: otpCode }),
      },
    });
  } catch (error) {
    console.error('Send OTP Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to send OTP. Please try again.',
    });
  }
};

/**
 * @route   POST /api/auth/verify-otp
 * @desc    Verify OTP and return JWT token
 * @access  Public
 */
const verifyOtp = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array(),
      });
    }

    const { phone, otp } = req.body;

    // Find the latest OTP for this phone
    const otpRecord = await Otp.findOne({
      phone,
      otp,
      isVerified: false,
    }).sort({ createdAt: -1 });

    if (!otpRecord) {
      return res.status(400).json({
        success: false,
        message: 'Invalid OTP. Please try again.',
      });
    }

    // Check if OTP has expired
    if (new Date() > otpRecord.expiresAt) {
      await Otp.deleteOne({ _id: otpRecord._id });
      return res.status(400).json({
        success: false,
        message: 'OTP has expired. Please request a new one.',
      });
    }

    // Mark OTP as verified
    otpRecord.isVerified = true;
    await otpRecord.save();

    // Find or create user
    let user = await User.findOne({ phone });
    let isNewUser = false;

    if (!user) {
      user = await User.create({ phone });
      isNewUser = true;
    }

    // Generate JWT token
    const token = generateToken(user._id);

    // Cleanup: delete used OTPs for this phone
    await Otp.deleteMany({ phone });

    console.log(`✅ User ${phone} authenticated successfully. New user: ${isNewUser}`);

    res.status(200).json({
      success: true,
      message: isNewUser
        ? 'Account created and verified successfully!'
        : 'Login successful!',
      data: {
        token,
        isNewUser,
        user: {
          id: user._id,
          phone: user.phone,
          name: user.name,
          email: user.email,
          isProfileComplete: user.isProfileComplete,
          isKycVerified: user.isKycVerified,
          creditScore: user.creditScore,
        },
      },
    });
  } catch (error) {
    console.error('Verify OTP Error:', error);
    res.status(500).json({
      success: false,
      message: 'OTP verification failed. Please try again.',
    });
  }
};

/**
 * @route   GET /api/auth/profile
 * @desc    Get current user profile
 * @access  Private
 */
const getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).select('-__v');

    res.status(200).json({
      success: true,
      data: user,
    });
  } catch (error) {
    console.error('Get Profile Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch profile.',
    });
  }
};

/**
 * @route   PUT /api/auth/profile
 * @desc    Update user profile
 * @access  Private
 */
const updateProfile = async (req, res) => {
  try {
    const allowedFields = [
      'name',
      'email',
      'dateOfBirth',
      'gender',
      'panNumber',
      'employmentType',
      'monthlyIncome',
      'address',
      'bankAccountNumber',
      'ifscCode',
      'bankName',
    ];

    // Only pick allowed fields
    const updates = {};
    allowedFields.forEach((field) => {
      if (req.body[field] !== undefined) {
        updates[field] = req.body[field];
      }
    });

    const user = await User.findById(req.user._id);
    Object.assign(user, updates);
    await user.save(); // Triggers pre-save hook for isProfileComplete

    res.status(200).json({
      success: true,
      message: 'Profile updated successfully.',
      data: user,
    });
  } catch (error) {
    console.error('Update Profile Error:', error);
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
      message: 'Failed to update profile.',
    });
  }
};

module.exports = {
  sendOtp,
  verifyOtp,
  getProfile,
  updateProfile,
};
