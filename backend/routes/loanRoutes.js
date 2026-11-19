const express = require('express');
const { body } = require('express-validator');
const {
  calculateEmi,
  checkEligibility,
  applyLoan,
  getMyLoans,
  getLoanById,
  updateLoanStatus,
  getLoanStats,
} = require('../controllers/loanController');
const { protect } = require('../middleware/auth');

const router = express.Router();

// All loan routes require authentication
router.use(protect);

/**
 * POST /api/loans/calculate
 * Calculate EMI (no application created)
 */
router.post('/calculate', calculateEmi);

/**
 * GET /api/loans/check-eligibility
 * Check if user is eligible for a loan
 */
router.get('/check-eligibility', checkEligibility);

/**
 * GET /api/loans/stats/summary
 * Get loan statistics for dashboard
 */
router.get('/stats/summary', getLoanStats);

/**
 * POST /api/loans/apply
 * Submit a new loan application
 */
router.post(
  '/apply',
  [
    body('loanAmount')
      .notEmpty()
      .withMessage('Loan amount is required')
      .isFloat({ min: 1000, max: 1000000 })
      .withMessage('Loan amount must be between ₹1,000 and ₹10,00,000'),
    body('tenure')
      .notEmpty()
      .withMessage('Tenure is required')
      .isFloat({ min: 1 })
      .withMessage('Tenure must be a valid positive number'),
  ],
  applyLoan
);

/**
 * GET /api/loans
 * Get all loan applications for current user
 */
router.get('/', getMyLoans);

/**
 * GET /api/loans/:id
 * Get single loan application details
 */
router.get('/:id', getLoanById);

/**
 * PATCH /api/loans/:id/status
 * Update loan application status (for demo/testing)
 */
router.patch('/:id/status', updateLoanStatus);

module.exports = router;
