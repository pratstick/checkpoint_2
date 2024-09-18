import mongoose from "mongoose";
import User from "./attendance_backend_api/Models/UserModel.js"; 
import Attendance from "./attendance_backend_api/Models/AttendanceModel.js";  // Adjust the path to your model
import VerifyDetails from "./attendance_backend_api/Models/VerifyDetailsModel.js";  // Adjust the path to your model

const MONGO_URI = process.env.MONGO_URI;  // Make sure you have your MongoDB URI in your environment variables

// Dummy Data
const dummyUsers = [
  {
    EmployeeID: "emp001",
    EmployeeName: "Alice Smith",
    mobileNo: 1234567890,
    email: "alice.smith@example.com",
    password: "password123",
    isAdmin: true
  },
  {
    EmployeeID: "emp002",
    EmployeeName: "Bob Johnson",
    mobileNo: 9876543210,
    email: "bob.johnson@example.com",
    password: "password123",
    isAdmin: false
  }
];

const dummyAttendances = [
  {
    EmployeeID: "emp001",
    EmployeeName: "Alice Smith",
    Date: "2024-09-19",
    CheckIn: "09:00",
    CheckOut: "17:00"
  },
  {
    EmployeeID: "emp002",
    EmployeeName: "Bob Johnson",
    Date: "2024-09-19",
    CheckIn: "09:30",
    CheckOut: "17:30"
  }
];

const dummyVerifyDetails = [
  {
    WiFi_IP: "192.168.0.1",
    radius: 100,
    latitude: 40.7128,
    longitude: -74.0060
  },
  {
    WiFi_IP: "192.168.0.2",
    radius: 200,
    latitude: 34.0522,
    longitude: -118.2437
  }
];

const seedDB = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    console.log("Connected to MongoDB");

    // Clear existing data
    await User.deleteMany({});
    await Attendance.deleteMany({});
    await VerifyDetails.deleteMany({});

    // Insert dummy data
    await User.insertMany(dummyUsers);
    await Attendance.insertMany(dummyAttendances);
    await VerifyDetails.insertMany(dummyVerifyDetails);

    console.log("Dummy data seeded successfully");
  } catch (error) {
    console.error("Error seeding data:", error);
  } finally {
    // Close the connection
    mongoose.connection.close();
  }
};

// Run the seeding function
seedDB();
