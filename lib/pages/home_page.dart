import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:checkpoint_attendance/auth/login_or_register.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/my_drawer.dart';
import '../helper/markAttendance.dart';

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({super.key});

  @override
  _EmployeeHomePageState createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> with SingleTickerProviderStateMixin {
  bool _checkedIn = false;
  final LocalAuthentication auth = LocalAuthentication();
  late AnimationController _controller;
  String? _attendanceStatus;
  String? _checkInTime;
  String? _checkOutTime;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
    _fetchAttendanceStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginOrRegister()),
      );
    }
  }

  Future<void> _fetchAttendanceStatus() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String todayDate = DateFormat('y-MM-dd').format(DateTime.now());

      DocumentSnapshot attendanceSnapshot = await FirebaseFirestore.instance.collection('attendance').doc(userId).get();

      if (attendanceSnapshot.exists) {
        Map<String, dynamic> attendanceData = attendanceSnapshot.data() as Map<String, dynamic>;
        
        // Check for today's attendance data
        Map<String, dynamic>? todayData = attendanceData[todayDate];
        
        if (todayData != null) {
          setState(() {
            _checkInTime = todayData['checkInTime'];
            _checkOutTime = todayData['checkOutTime'];
            _checkedIn = _checkInTime != null && _checkOutTime == null;
            
            if (_checkInTime != null && _checkOutTime != null) {
              _attendanceStatus = 'Complete (In: $_checkInTime, Out: $_checkOutTime)';
            } else if (_checkInTime != null) {
              _attendanceStatus = 'Checked In at $_checkInTime';
            } else {
              _attendanceStatus = 'Not Checked In';
            }
          });
        } else {
          setState(() {
            _attendanceStatus = 'Not Checked In';
            _checkedIn = false;
            _checkInTime = null;
            _checkOutTime = null;
          });
        }
      } else {
        setState(() {
          _attendanceStatus = 'Not Checked In';
          _checkedIn = false;
          _checkInTime = null;
          _checkOutTime = null;
        });
      }
    } catch (e) {
      setState(() {
        _attendanceStatus = 'Error fetching attendance';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('yMMMd').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text("CheckPoint - Employee"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      drawer: MyDrawer(role: 'Employee'),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).secondaryHeaderColor, Theme.of(context).primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 40,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "CheckPoint",
                    style: TextStyle(
                      fontSize: 32, 
                      fontWeight: FontWeight.bold, 
                      color: Theme.of(context).colorScheme.inversePrimary
                    ),
                  ),
                  Text(
                    "Smart Attendance Tracking",
                    style: TextStyle(
                      fontSize: 16, 
                      color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8)
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "TODAY: $todayDate",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  const SizedBox(height: 40),
                  
                  // Check In/Out Button
                  ElevatedButton.icon(
                    onPressed: (_checkInTime != null && _checkOutTime != null) ? null : () async {
                      await markAttendance(context, auth, _checkedIn ? 'checkout' : 'checkin');
                      _fetchAttendanceStatus();
                    },
                    icon: Icon(_checkedIn ? Icons.exit_to_app : Icons.location_on, size: 28),
                    label: Text(
                      _checkedIn ? 'Check Out' : 'Check In', 
                      style: const TextStyle(fontSize: 18)
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _checkedIn ? Colors.orange : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Status Display
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Today\'s Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _attendanceStatus ?? 'Loading...',
                          style: TextStyle(
                            fontSize: 14,
                            color: _checkedIn ? Colors.green : (_checkOutTime != null ? Colors.blue : Colors.orange),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 5),
            top: 100 + (10 * _controller.value),
            left: 20 + (20 * _controller.value),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 5),
            top: 600 + (20 * _controller.value),
            left: 150 + (15 * _controller.value),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 5),
            top: 100 + (20 * _controller.value),
            left: 250 + (15 * _controller.value),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 5),
            top: 400 + (30 * _controller.value),
            left: 150 + (10 * _controller.value),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(75),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 5),
            bottom: 600 + (10 * _controller.value),
            right: 250 + (20 * _controller.value),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(150),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 5),
            bottom: 400 + (25 * _controller.value),
            left: 500 + (30 * _controller.value),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// Performance optimization
// Performance optimization
// Performance optimization
