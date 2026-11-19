require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const connectDB = require('./config/db');

// Route imports
const authRoutes = require('./routes/authRoutes');
const loanRoutes = require('./routes/loanRoutes');

const app = express();

// ========================
// MIDDLEWARE
// ========================
app.use(helmet()); // Security headers
app.use(cors()); // Enable CORS for Flutter app
app.use(express.json({ limit: '10mb' })); // Parse JSON bodies
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev')); // Request logging

// ========================
// ROUTES
// ========================
app.use('/api/auth', authRoutes);
app.use('/api/loans', loanRoutes);

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'CreditSea API is running 🚀',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development',
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Welcome to CreditSea API',
    version: '1.0.0',
    endpoints: {
      auth: {
        sendOtp: 'POST /api/auth/send-otp',
        verifyOtp: 'POST /api/auth/verify-otp',
        getProfile: 'GET /api/auth/profile',
        updateProfile: 'PUT /api/auth/profile',
      },
      loans: {
        calculateEmi: 'POST /api/loans/calculate',
        checkEligibility: 'GET /api/loans/check-eligibility',
        apply: 'POST /api/loans/apply',
        getMyLoans: 'GET /api/loans',
        getLoanById: 'GET /api/loans/:id',
        updateStatus: 'PATCH /api/loans/:id/status',
        stats: 'GET /api/loans/stats/summary',
      },
    },
  });
});

// ========================
// 404 HANDLER
// ========================
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: `Route ${req.originalUrl} not found`,
  });
});

// ========================
// GLOBAL ERROR HANDLER
// ========================
app.use((err, req, res, next) => {
  console.error('Unhandled Error:', err);
  res.status(500).json({
    success: false,
    message: 'Internal server error',
    ...(process.env.NODE_ENV !== 'production' && { error: err.message }),
  });
});

// ========================
// START SERVER
// ========================
const PORT = process.env.PORT || 5000;

const startServer = async () => {
  await connectDB();

  app.listen(PORT, () => {
    console.log('\n' + '🌊'.repeat(25));
    console.log(`\n  🚀 CreditSea API Server`);
    console.log(`  📡 Running on: http://localhost:${PORT}`);
    console.log(`  🔧 Environment: ${process.env.NODE_ENV || 'development'}`);
    console.log(`\n  📚 API Endpoints:`);
    console.log(`  ├─ Auth:  http://localhost:${PORT}/api/auth`);
    console.log(`  ├─ Loans: http://localhost:${PORT}/api/loans`);
    console.log(`  └─ Health: http://localhost:${PORT}/api/health`);
    console.log('\n' + '🌊'.repeat(25) + '\n');
  });
};

startServer();
