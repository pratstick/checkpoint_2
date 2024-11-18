import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../pages/face_verification.dart';
import 'face_recognition.dart';

Future<void> markAttendance(BuildContext context, LocalAuthentication auth, String action) async {
  String actionText = action == 'checkin' ? 'Checking In...' : 'Checking Out...';
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(actionText),
            CircularProgressIndicator(),
          ],
        ),
      );
    },
  );

  try {
    // Request location permissions
    var locationStatus = await Permission.location.request();
    if (!locationStatus.isGranted) {
      throw 'Location permission is required to fetch location information';
    }

    // Check connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.wifi) {
      throw 'Not connected to a WiFi network';
    }

    // Fetch settings from Firestore
    DocumentSnapshot settingsSnapshot = await FirebaseFirestore.instance.collection('settings').doc('attendance').get();
    if (!settingsSnapshot.exists) {
      throw 'Attendance settings not found in the database';
    }

    Map<String, dynamic>? settings = settingsSnapshot.data() as Map<String, dynamic>?;

    if (settings == null) {
      throw 'Settings data is null';
    }

    String ssid = settings['ssid'] ?? '';
    String bssid = settings['bssid'] ?? '';

    // For check-out, we can be more flexible with time restrictions
    if (action == 'checkin') {
      // Parse startTime and endTime for check-in
      TimeOfDay startTime = TimeOfDay(
        hour: int.parse(settings['startTime']?.split(":")[0] ?? '0'),
        minute: int.parse(settings['startTime']?.split(":")[1] ?? '0'),
      );
      TimeOfDay endTime = TimeOfDay(
        hour: int.parse(settings['endTime']?.split(":")[0] ?? '23'),
        minute: int.parse(settings['endTime']?.split(":")[1] ?? '59'),
      );

      TimeOfDay now = TimeOfDay.now();
      if (!(now.hour > startTime.hour || (now.hour == startTime.hour && now.minute >= startTime.minute)) ||
          !(now.hour < endTime.hour || (now.hour == endTime.hour && now.minute <= endTime.minute))) {
        throw 'Current time is not within the office hours for check-in';
      }
    }

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String currentDeviceId = androidInfo.id;

    WifiInfo wifiInfo = WifiInfo();
    String currentSsid = await wifiInfo.getWifiName() ?? '';
    String currentBssid = await wifiInfo.getWifiBSSID() ?? '';

    print('Current DeviceId: $currentDeviceId');
    print('Current SSID: $currentSsid');
    print('Current BSSID: $currentBssid');

    if (currentSsid != ssid || currentBssid != bssid) {
      // For check-out, we might be more lenient with WiFi validation
      if (action == 'checkin') {
        throw 'Connected to incorrect WiFi network for check-in';
      }
      // For check-out, we could allow it even if not on office WiFi
      print('Warning: Not on office WiFi for check-out, but allowing...');
    }

    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw 'User not found in the database';
    }

    String registeredDeviceId = userDoc['deviceId'] ?? '';
    print('Registered DeviceId: $registeredDeviceId');
    if (registeredDeviceId != currentDeviceId) {
      throw 'Device ID does not match the registered device';
    }

    // Geofencing
    GeoPoint? geofenceCenter = settings['geofenceCenter'] as GeoPoint?;
    if (geofenceCenter == null) {
      throw 'Geofence center is not defined in the settings';
    }

    double geofenceCenterLat = geofenceCenter.latitude.toDouble();
    double geofenceCenterLng = geofenceCenter.longitude.toDouble();

    print('Geofence Center -> Lat: $geofenceCenterLat, Lng: $geofenceCenterLng');

// Ensure geofenceRadius is parsed correctly from the settings
    String? geofenceRadiusStr = settings['geofenceRadius'] as String?;
    if (geofenceRadiusStr == null || geofenceRadiusStr.isEmpty) {
      throw 'Geofence radius is not defined or invalid in the settings';
    }

    double geofenceRadius = double.tryParse(geofenceRadiusStr) ?? 0;
    if (geofenceRadius == 0) {
      throw 'Geofence radius is invalid or set to 0';
    }

    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      geofenceCenterLat,
      geofenceCenterLng,
    );

    print('Distance: $distance');


    if (distance > geofenceRadius) {
      // For check-out, we might be more lenient with geofence
      if (action == 'checkin') {
        throw 'Outside the office area for check-in';
      }
      // For check-out, we could allow it even if outside geofence
      print('Warning: Outside geofence for check-out, but allowing...');
    } else {
      print('Inside the office area');
    }

    // For check-in, we require face verification. For check-out, it's optional
    if (action == 'checkin') {
      // Navigate to FaceVerificationPage for face recognition
      bool isFaceVerified = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FaceVerificationPage(userId: userId),
        ),
      );

      if (!isFaceVerified) {
        throw 'Face verification failed for check-in';
      }
    }

    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

    // Get existing attendance data for today
    DocumentSnapshot attendanceDoc = await FirebaseFirestore.instance.collection('attendance').doc(userId).get();
    Map<String, dynamic> existingData = {};
    
    if (attendanceDoc.exists) {
      existingData = attendanceDoc.data() as Map<String, dynamic>;
    }

    Map<String, dynamic> todayData = existingData[todayDate] ?? {};

    if (action == 'checkin') {
      if (todayData['checkInTime'] != null) {
        throw 'Already checked in today';
      }
      todayData['checkInTime'] = currentTime;
      todayData['checkInLocation'] = {
        'latitude': currentPosition.latitude,
        'longitude': currentPosition.longitude,
      };
    } else { // checkout
      if (todayData['checkInTime'] == null) {
        throw 'Cannot check out without checking in first';
      }
      if (todayData['checkOutTime'] != null) {
        throw 'Already checked out today';
      }
      todayData['checkOutTime'] = currentTime;
      todayData['checkOutLocation'] = {
        'latitude': currentPosition.latitude,
        'longitude': currentPosition.longitude,
      };
    }

    existingData[todayDate] = todayData;

    await FirebaseFirestore.instance.collection('attendance').doc(userId).set(existingData, SetOptions(merge: true));

    Navigator.pop(context); // Close the checking dialog

    String successMessage = action == 'checkin' 
        ? 'Successfully checked in at $currentTime!' 
        : 'Successfully checked out at $currentTime!';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(successMessage)),
              Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        );
      },
    );

  } catch (e) {
    Navigator.pop(context); // Close the checking dialog

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text('Error: $e')),
              Icon(Icons.error, color: Colors.red),
            ],
          ),
        );
      },
    );
  }
}

// Attendance optimization
// Attendance optimization
// Attendance optimization
