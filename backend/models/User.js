const mongoose = require('mongoose');

const userSchema = new mongoose.Schema(
  {
    phone: {
      type: String,
      required: [true, 'Phone number is required'],
      unique: true,
      trim: true,
      match: [/^[6-9]\d{9}$/, 'Please enter a valid 10-digit Indian mobile number'],
    },
    name: {
      type: String,
      trim: true,
      default: '',
    },
    email: {
      type: String,
      trim: true,
      lowercase: true,
      default: '',
    },
    dateOfBirth: {
      type: Date,
      default: null,
    },
    gender: {
      type: String,
      enum: ['Male', 'Female', 'Other', ''],
      default: '',
    },
    panNumber: {
      type: String,
      trim: true,
      uppercase: true,
      default: '',
      match: [/^$|^[A-Z]{5}[0-9]{4}[A-Z]{1}$/, 'Invalid PAN format'],
    },
    employmentType: {
      type: String,
      enum: ['Salaried', 'Self-Employed', 'Business', 'Student', 'Other', ''],
      default: '',
    },
    monthlyIncome: {
      type: Number,
      default: 0,
      min: 0,
    },
    address: {
      type: String,
      trim: true,
      default: '',
    },
    bankAccountNumber: {
      type: String,
      trim: true,
      default: '',
    },
    ifscCode: {
      type: String,
      trim: true,
      uppercase: true,
      default: '',
    },
    bankName: {
      type: String,
      trim: true,
      default: '',
    },
    isProfileComplete: {
      type: Boolean,
      default: false,
    },
    isKycVerified: {
      type: Boolean,
      default: false,
    },
    creditScore: {
      type: Number,
      default: 650,
      min: 300,
      max: 900,
    },
  },
  {
    timestamps: true,
  }
);

// Virtual: check if profile is complete enough to apply for loans
userSchema.pre('save', function (next) {
  this.isProfileComplete = !!(
    this.name &&
    this.email &&
    this.dateOfBirth &&
    this.gender &&
    this.panNumber &&
    this.employmentType &&
    this.monthlyIncome > 0
  );
  next();
});

module.exports = mongoose.model('User', userSchema);
