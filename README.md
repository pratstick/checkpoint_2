# Smart Attendance Tracking System

## Overview
The **Smart Attendance Tracking System** is a mobile application designed to automate employee attendance tracking using geolocation technology. The app streamlines the process of check-ins and check-outs by logging attendance when employees enter and leave the designated office premises or offsite work locations. This solution aims to enhance operational efficiency, reduce manual attendance tracking errors, and provide employees with a seamless experience for managing their work-related movements.

## Key Features
- **Geolocation-Based Check-In/Out**: Automatically logs check-in when an employee enters a 200-meter radius of the office and logs check-out when they leave the radius.
- **Manual Check-In/Out for Offsite Work**: Allows employees to manually log their attendance when working offsite, with real-time location suggestions based on GPS data.
- **Total Working Hours Calculation**: Automatically calculates the total working hours based on check-in and check-out times.
- **Admin Dashboard**: Web-based UI for admins to manage employee data and attendance records.
- **Data Integrity**: Real-time data synchronization and secure storage ensure accurate and tamper-proof attendance records.

## Table of Contents
- [Overview](#overview)
- [Key Features](#key-features)
- [Technologies Used](#technologies-used)
- [System Architecture](#system-architecture)
- [Installation](#installation)
- [Usage](#usage)
- [Screenshots](#screenshots)
- [Admin Dashboard](#admin-dashboard)
- [Future Enhancements](#future-enhancements)
- [License](#license)

## Technologies Used
### Frontend:
- **Flutter**: Cross-platform framework for building the mobile app (Android/iOS).
  
### Backend:
- **Node.js**: API services for handling requests and processing attendance data.
- **Firebase**: Backend services for authentication and data storage.

### Database:
- **MongoDB**: NoSQL database for storing employee details, attendance logs, and reports.

### Admin Panel:
- **React.js**: Web-based UI for administrators to monitor attendance and manage employee data.

## System Architecture
1. **Mobile App (Flutter)**: Employees interact with the mobile app to check in/out. The app uses geolocation to track employee movements.
2. **Backend (Node.js)**: Processes the attendance data and communicates with the database to log and retrieve attendance records.
3. **Database (MongoDB)**: Stores all attendance data, including timestamps, locations, and employee details.
4. **Admin Dashboard (React.js)**: Provides admins with a web interface to view attendance data and manage employee profiles.

![System Architecture Diagram](URL to Architecture Diagram Image)

## Installation
### Prerequisites:
- Node.js and npm installed
- Flutter SDK installed
- MongoDB setup

### Backend Setup (Node.js):
1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/smart-attendance-system.git
    ```
2. Navigate to the backend directory:
    ```bash
    cd smart-attendance-system/backend
    ```
3. Install the dependencies:
    ```bash
    npm install
    ```
4. Set up the environment variables in a `.env` file:
    ```bash
    MONGO_URI=your_mongodb_uri
    PORT=5000
    ```
5. Run the backend server:
    ```bash
    npm start
    ```

### Mobile App Setup (Flutter):
1. Navigate to the Flutter app directory:
    ```bash
    cd smart-attendance-system/app
    ```
2. Install Flutter dependencies:
    ```bash
    flutter pub get
    ```
3. Run the mobile app:
    ```bash
    flutter run
    ```

### Admin Dashboard Setup (React.js):
1. Navigate to the admin dashboard directory:
    ```bash
    cd smart-attendance-system/admin
    ```
2. Install the dependencies:
    ```bash
    npm install
    ```
3. Run the React app:
    ```bash
    npm start
    ```

## Usage
1. **Employee Login**: Employees log in to the mobile app using their credentials.
2. **Geolocation Check-In/Out**: When an employee enters or exits the office radius, their attendance is automatically logged.
3. **Manual Check-In/Out**: Employees working offsite can manually log their attendance using the app's interface.
4. **Admin Dashboard**: Admins can view attendance reports, add/edit employees, and generate attendance summaries via the web interface.

## Screenshots
- **Employee Check-In/Out Screen**:
  ![Check-In/Out Screenshot](https://imgur.com/a/DGVKb8A)
  
- **Admin Dashboard**:
  ![Admin Dashboard Screenshot](URL to Admin Dashboard Screenshot)

## Admin Dashboard
The admin dashboard provides a web-based interface for administrators to:
- View live attendance data.
- Monitor employee attendance history.
- Manage employee profiles (add, edit, delete employees).
- Generate attendance reports.

## Future Enhancements
- **Face Recognition Integration**: Add facial recognition for additional security during check-in.
- **Machine Learning**: Use machine learning algorithms to predict employee attendance patterns and alert admins of irregularities.
- **Push Notifications**: Notify employees of check-in or check-out status in real time.
- **Leave Management**: Implement leave request and approval functionality within the app.

## License
This project is licensed under the MIT License - see the [LICENSE](https://raw.githubusercontent.com/pratstick/checkpoint_2/refs/heads/main/LICENSE) file for details.
