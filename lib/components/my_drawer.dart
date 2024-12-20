import 'package:flutter/material.dart';
import '../pages/heatmap.dart';
import '../pages/location_management.dart';

class MyDrawer extends StatelessWidget {
  final String role; // Add a parameter for the user's role

  const MyDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  size: 35,
                ),
                const SizedBox(height: 8),
                Text(
                  'CheckPoint',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Smart Attendance',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.home),
              title: Text(
                "H O M E",
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(
                "P R O F I L E",
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.analytics),
              title: Text(
                "A T T E N D A N C E",
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              ),
              onTap: () {
                if (role == 'Employee') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AttendanceHeatmap()),
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.location_on),
              title: Text(
                "L O C A T I O N S",
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                if (role == 'Admin' || role == 'Manager') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LocationManagementPage()),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
// Holiday fix
// Holiday fix
// Holiday fix
