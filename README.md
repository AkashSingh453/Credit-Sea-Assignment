# 🌊 CreditSea — Loan Application Mobile App & Backend

A full-stack, production-grade Loan Application mobile solution built for the CreditSea Flutter Developer assignment. Designed to match the provided Figma specifications with pixel-perfection, featuring real-time EMI calculation, 3-step KYC onboarding, interactive status tracking, dynamic credit scoring, and a complete Node.js/Express + MongoDB backend with mock OTP authentication.

---

## 📱 App Overview & Screenshots

| 1. Splash & Auth | 2. Profile Setup (KYC) | 3. Loan Calculator | 4. Offer & Tracking |
|:---:|:---:|:---:|:---:|
| Animated Splash, Carousel & OTP | Personal, Email & PAN verification | Sliders, Daily Rate & Live EMI | Gold Coin Offer & Status Stepper |

---

## 🛠️ Tech Stack & Architecture

### **Frontend (Mobile App)**
- **Framework**: Flutter (Dart 3.x)
- **State Management & Routing**: Strictly **GetX** (`GetxController`, `GetView`, `Bindings`, `GetPage` routes)
- **Typography**: Google Fonts (Inter)
- **Persistence**: `get_storage` (Session tokens & user metadata)
- **Networking**: `http` package with centralized `ApiService`
- **Design Tokens**: Custom `AppColors`, `AppTheme` aligned with Figma brand guidelines

### **Backend (REST API)**
- **Runtime**: Node.js & Express.js
- **Database**: MongoDB with Mongoose ORM
- **Authentication**: JWT (JSON Web Tokens) with 30-day persistence
- **Validation**: `express-validator` & Mongoose schema constraints
- **Security**: `helmet`, `cors`, parameterized query safety
- **Mock OTP Engine**: 4-digit OTP generated in-memory & stored with MongoDB TTL indexes (auto-expired in 5 min); printed to server console for frictionless testing without third-party SMS costs

---

## 📂 Project Architecture

```
credit sea/
├── backend/
│   ├── config/
│   │   └── db.js                 # MongoDB connection & resilience
│   ├── controllers/
│   │   ├── authController.js     # Send/Verify OTP, user profile endpoints
│   │   └── loanController.js     # Calculate EMI, eligibility, application & status
│   ├── middleware/
│   │   └── auth.js               # JWT Bearer authentication guard
│   ├── models/
│   │   ├── User.js               # User schema with creditScore & KYC flags
│   │   ├── Otp.js                # OTP schema with TTL auto-cleanup
│   │   └── LoanApplication.js    # Loan schema with status history & referenceId
│   ├── routes/
│   │   ├── authRoutes.js         # /api/auth routes
│   │   └── loanRoutes.js         # /api/loans routes
│   ├── .env                      # Environment config (Port, Mongo, JWT)
│   ├── package.json
│   └── server.js                 # Express server bootstrap
│
└── frontend/
    ├── lib/
    │   ├── app/
    │   │   ├── data/services/
    │   │   │   ├── api_service.dart      # Centralized HTTP API client
    │   │   │   └── storage_service.dart  # GetStorage wrapper
    │   │   ├── modules/
    │   │   │   ├── splash/               # Splash screen with animation
    │   │   │   ├── auth/                 # Login & 4-digit OTP screens
    │   │   │   ├── profile_setup/        # Personal Details, Email, PAN screens
    │   │   │   ├── home/                 # Dashboard with credit card & recent loans
    │   │   │   ├── loan/                 # Loan Calculator, Offerings, Status screens
    │   │   │   └── profile/              # User Profile, Bank Details & Settings
    │   │   ├── routes/
    │   │   │   ├── app_routes.dart       # Named route constants
    │   │   │   └── app_pages.dart        # GetPage declarations with bindings
    │   │   ├── theme/
    │   │   │   ├── app_colors.dart       # Figma color palette tokens
    │   │   │   └── app_theme.dart        # Material 3 light theme definition
    │   │   └── widgets/
    │   │       ├── credit_sea_logo.dart  # Brand swoosh logo & header
    │   │       ├── custom_button.dart    # Primary & outlined button styles
    │   │       ├── custom_text_field.dart# Form inputs with floating labels
    │   │       └── step_indicator.dart   # 1 Register -> 2 Offer -> 3 Approval stepper
    │   └── main.dart                     # App entry point
    └── pubspec.yaml
```

---

## ⚡ Quick Start Guide

### 1. Prerequisites
- **Node.js**: v18+ installed
- **MongoDB**: Running locally on port `27017` or a MongoDB Atlas URI
- **Flutter SDK**: 3.x+ installed with Android/iOS toolchains

### 2. Backend Setup
```bash
cd "backend"

# Install dependencies
npm install

# Start development server
npm run dev
# Or standard start
node server.js
```
The server will start on `http://localhost:5000`.

### 3. Frontend Setup
```bash
cd "frontend"

# Get Flutter packages
flutter pub get

# Run on Android Emulator or iOS Simulator
flutter run
```

> **Note on Emulator IP Configuration:**
> In `frontend/lib/app/data/services/api_service.dart`:
> - Android Emulator: uses `http://10.0.2.2:5000/api` (default)
> - iOS Simulator: change to `http://localhost:5000/api`
> - Physical Device: change to your machine's local IP (e.g., `http://192.168.1.100:5000/api`)

---

## 🔐 Mock OTP Authentication Flow

```
1. Mobile App: User enters 10-digit mobile number (+91)
2. Backend (POST /api/auth/send-otp):
   ├── Generates random 4-digit code (e.g., 4821)
   ├── Saves to MongoDB with 5-minute TTL
   ├── Prints OTP to the terminal console:
   │   "📱 [MOCK OTP] Phone: 9876543210 | OTP: 4821"
   └── Returns OTP in JSON response in development mode
3. Mobile App: User types the 4-digit code into the PinField
4. Backend (POST /api/auth/verify-otp):
   ├── Validates code against database
   ├── Marks OTP as verified
   └── Signs and returns JWT Bearer token
5. Mobile App: Saves JWT to GetStorage & routes:
   ├── New User → 3-Step Profile Setup (Personal → Email → PAN)
   └── Existing User → Home Dashboard
```

---

## 📊 REST API Reference

### Authentication (`/api/auth`)
| Method | Endpoint | Auth | Description |
|:---|:---|:---:|:---|
| `POST` | `/send-otp` | ❌ | Generate and log mock 4-digit OTP |
| `POST` | `/verify-otp` | ❌ | Validate OTP, returns JWT token & user status |
| `GET` | `/profile` | ✅ | Retrieve authenticated user profile |
| `PUT` | `/profile` | ✅ | Update profile details (Name, DOB, PAN, Income, Bank) |

### Loan Management (`/api/loans`)
| Method | Endpoint | Auth | Description |
|:---|:---|:---:|:---|
| `POST` | `/calculate` | ✅ | Calculate EMI, total interest, and processing fee |
| `GET` | `/check-eligibility` | ✅ | Underwriting check (income ≥ ₹10K, score ≥ 500) |
| `POST` | `/apply` | ✅ | Submit loan application with purpose & tenure |
| `GET` | `/` | ✅ | List user loans with pagination & status filters |
| `GET` | `/:id` | ✅ | Single loan application details & audit history |
| `PATCH`| `/:id/status` | ✅ | Update loan status (Submitted → Under Review → Approved → Disbursed) |
| `GET` | `/stats/summary` | ✅ | Aggregated user stats (total loans, active, approved amount) |

---

## 🌟 Key Features & Bonus Implementations

1. **Pixel-Perfect Figma Adherence**:
   - Splash Screen with elastic scale-in logo animation
   - Login carousel showcasing Flexible Loans, Instant Approval, 24x7 Support
   - 3-Step Registration Stepper:
     - Step 1: Personal Details (First Name, Last Name, Gender, Date Picker, Marital Status)
     - Step 2: Personal Email ID Verification
     - Step 3: PAN Card Verification, Employment Type & Monthly Income
   - Interactive Loan Calculator:
     - Real-time Sliders for Principal Amount (₹5,000 – ₹1,00,000) & Tenure (20 – 90 Days)
     - Dynamic Summary Card with live calculated interest & total payable
     - Dotted badge chips ("Interest Per Day 1%", "Processing Fee 10%")
   - Our Offerings Screen:
     - Custom Gold Coin graphic with radial gradient & 3D shadow
     - Congratulatory offer card matching exact Figma copy
   - Application Status Tracking:
     - 6-stage vertical pipeline (`Submitted` → `Under Review` → `E-KYC` → `E-Nach` → `E-Sign` → `Disbursement`)
     - Border highlight cards (Green completed, Blue active in-progress)

2. **Interactive Demo Status Controller (Bonus Feature)**:
   - On the `Application Status` screen, an interactive toolbar allows the evaluator to test status changes in real-time (`Submitted` → `Under Review` → `Approved` → `Disbursed` → `Rejected`).
   - Each transition triggers actual API updates, logs status audit history, and updates the user's Credit Score!

3. **Dynamic Credit Health Engine (Bonus Feature)**:
   - Users start with a base Credit Score of 650 (range: 300 – 900).
   - Approvals increase score by +5 points.
   - Successful disbursements increase score by +10 points.
   - Real-time visual progress gauge in Dashboard & Profile screen.

4. **Robust Error Handling & Resilience**:
   - Backend auto-detects and logs database connectivity status with actionable hints.
   - Form validation on PAN (`ABCDE1234F`), Indian phone numbers (`10 digits starting with 6-9`), and email addresses.
   - Session tokens persisted via GetStorage for automatic login resumption.

---

## 📬 Submission Checklist

- [x] **State Management**: Strictly GetX (Controllers, Bindings, GetView, Rx observables)
- [x] **Backend**: Node.js, Express, MongoDB, Mongoose schemas, JWT
- [x] **Mock OTP**: Self-contained in Node.js backend, logged to console, zero 3rd-party dependencies
- [x] **Figma UI/UX**: All screens matching layouts, icons, typography, and spacing
- [x] **Deliverables**: Codebase organized with clear modular separation
