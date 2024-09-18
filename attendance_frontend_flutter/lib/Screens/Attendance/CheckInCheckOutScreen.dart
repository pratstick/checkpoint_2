import 'package:attendance_frontend_flutter/NodeJS_Api/Api.dart';
import 'package:attendance_frontend_flutter/NodeJS_Models/AttendanceModel.dart';
import 'package:attendance_frontend_flutter/NodeJS_Models/VerifyDetailModel.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CheckIn_Out extends StatefulWidget {
  const CheckIn_Out({super.key});

  @override
  State<CheckIn_Out> createState() => _CheckIn_OutState();
}

class _CheckIn_OutState extends State<CheckIn_Out> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Position? _currentPosition;

  double screenHeight = 0;
  double screenWidth = 0;

  var EmployeeID = "";

  String checkIn = "--/--";
  String checkOut = "--/--";

  Color primary = const Color(0xffeef444c);

  @override
  void initState() {
    super.initState();
    loadSettings();
    _getRecord();
    _postEmptydata();
    _getCurrentPosition();
  }

  loadSettings() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      EmployeeID = (prefs.getString("EmployeeID"))!;
    });
  }

  Future<void> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled.');
      return;
    }

    // Check for permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied, cannot request permissions.');
      return;
    }

    // If permissions are granted, get the current position
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      // Optionally get the address from lat/long
      // _getAddressFromLatLng(_currentPosition!);
    } catch (e) {
      debugPrint('Error getting current position: $e');
    }
  }

  void _getRecord() async {
    // Your existing code here...
  }

  Future<void> _postEmptydata() async {
    // Your existing code here...
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Your existing UI code here...
          ],
        ),
      ),
    );
  }
}
