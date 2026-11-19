const mongoose = require('mongoose');

const otpSchema = new mongoose.Schema(
  {
    phone: {
      type: String,
      required: true,
      trim: true,
    },
    otp: {
      type: String,
      required: true,
    },
    isVerified: {
      type: Boolean,
      default: false,
    },
    expiresAt: {
      type: Date,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

// Auto-delete expired OTPs using TTL index
otpSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });

// Index for quick lookup
otpSchema.index({ phone: 1, otp: 1 });

module.exports = mongoose.model('Otp', otpSchema);
