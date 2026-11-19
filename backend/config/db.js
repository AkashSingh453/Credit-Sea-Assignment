const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGODB_URI);
    console.log(`\n✅ MongoDB Connected: ${conn.connection.host}`);
    console.log(`📦 Database: ${conn.connection.name}\n`);
  } catch (error) {
    console.error(`\n❌ MongoDB Connection Error: ${error.message}`);
    console.error(`⚠️  Please ensure MongoDB is running (e.g., 'brew services start mongodb-community' or run with Docker: 'docker run -d -p 27017:27017 --name creditsea-mongo mongo')\n`);
    if (process.env.NODE_ENV === 'production') {
      process.exit(1);
    }
  }
};

module.exports = connectDB;
