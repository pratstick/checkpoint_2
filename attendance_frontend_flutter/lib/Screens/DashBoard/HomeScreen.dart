import 'package:attendance_frontend_flutter/NodeJS_Models/LoginModel.dart';
import 'package:attendance_frontend_flutter/Screens/Attendance/AttendaceHistory.dart';
import 'package:attendance_frontend_flutter/Screens/Attendance/CheckInCheckOutScreen.dart';
import 'package:attendance_frontend_flutter/Screens/EmployeeDetail/Profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffeef444c);

  int currentIndex = 1;

  List<IconData> navigationIcons = [
    FontAwesomeIcons.calendarAlt,
    FontAwesomeIcons.check,
    FontAwesomeIcons.user,
  ];

  @override
  void initState() {
    super.initState();

    _startLocationService();
    // getId().then((value) {
    //   _getCredentials();
    //   _getProfilePic();
    // });
  }

  // void _getCredentials() async {
  //   try {
  //     DocumentSnapshot doc = await FirebaseFirestore.instance
  //         .collection("Employee")
  //         .doc(User.id)
  //         .get();
  //     setState(() {
  //       User.canEdit = doc['canEdit'];
  //       User.firstName = doc['firstName'];
  //       User.lastName = doc['lastName'];
  //       User.birthDate = doc['birthDate'];
  //       User.address = doc['address'];
  //     });
  //   } catch (e) {
  //     return;
  //   }
  // }
  //
  // void _getProfilePic() async {
  //   DocumentSnapshot doc = await FirebaseFirestore.instance
  //       .collection("Employee")
  //       .doc(User.id)
  //       .get();
  //   setState(() {
  //     User.profilePicLink = doc['profilePic'];
  //   });
  // }
  //

  Future<bool> _startLocationService() async {
    //Enabled Location Permission From the device
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
  //
  // Future<void> getId() async {
  //   QuerySnapshot snap = await FirebaseFirestore.instance
  //       .collection("Employee")
  //       .where('id', isEqualTo: User.employeeId)
  //       .get();
  //
  //   setState(() {
  //     User.id = snap.docs[0].id;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          const AttendanceHistory(),
          const CheckIn_Out(),
          const Profile(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < navigationIcons.length; i++) ...<Expanded>{
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = i;
                      });
                    },
                    child: Container(
                      height: screenHeight,
                      width: screenWidth,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              navigationIcons[i],
                              color:
                                  i == currentIndex ? primary : Colors.black54,
                              size: i == currentIndex ? 30 : 26,
                            ),
                            i == currentIndex
                                ? Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    height: 3,
                                    width: 22,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(40)),
                                      color: primary,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              }
            ],
          ),
        ),
      ),
    );
  }
}
