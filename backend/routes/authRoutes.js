const express = require('express');
const { body } = require('express-validator');
const { sendOtp, verifyOtp, getProfile, updateProfile } = require('../controllers/authController');
const { protect } = require('../middleware/auth');

const router = express.Router();

// ========================
// PUBLIC ROUTES
// ========================

/**
 * POST /api/auth/send-otp
 * Send a mock 4-digit OTP to the given phone number
 */
router.post(
  '/send-otp',
  [
    body('phone')
      .notEmpty()
      .withMessage('Phone number is required')
      .matches(/^[6-9]\d{9}$/)
      .withMessage('Enter a valid 10-digit Indian mobile number'),
  ],
  sendOtp
);

/**
 * POST /api/auth/verify-otp
 * Verify OTP and get JWT token
 */
router.post(
  '/verify-otp',
  [
    body('phone')
      .notEmpty()
      .withMessage('Phone number is required')
      .matches(/^[6-9]\d{9}$/)
      .withMessage('Enter a valid 10-digit Indian mobile number'),
    body('otp')
      .notEmpty()
      .withMessage('OTP is required')
      .isLength({ min: 4, max: 4 })
      .withMessage('OTP must be exactly 4 digits')
      .isNumeric()
      .withMessage('OTP must contain only numbers'),
  ],
  verifyOtp
);

// ========================
// PROTECTED ROUTES
// ========================

/**
 * GET /api/auth/profile
 * Get authenticated user's profile
 */
router.get('/profile', protect, getProfile);

/**
 * PUT /api/auth/profile
 * Update authenticated user's profile
 */
router.put('/profile', protect, updateProfile);

module.exports = router;
