import 'package:flutter/material.dart';
import 'package:attendance_frontend_flutter/Screens/DashBoard/HomeScreen.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attendance_frontend_flutter/NodeJS_Models/LoginModel.dart'; 
import 'package:attendance_frontend_flutter/NodeJS_Api/Api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffeef444c);

  void LoginEmployee() async {
    final SharedPreferences prefs = await _prefs;

    FocusScope.of(context).unfocus();

    String employeeID = idController.text.trim();
    String password = passController.text.trim();

    // Hardcoded test credentials
    const String testUsername = "testUser";
    const String testPassword = "testPass";

    if (employeeID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Please Enter Employee ID !!!",
          style: TextStyle(
            color: Color(0xffeef444c),
            fontFamily: "NexaBold",
          ),
        ),
      ));
    } else if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Please Enter Password !!!",
          style: TextStyle(
            color: Color(0xffeef444c),
            fontFamily: "NexaBold",
          ),
        ),
      ));
    } else if (employeeID == testUsername && password == testPassword) {
      // Simulate a successful login
      var token = "dummy_token"; // Simulated token
      var employeeName = "Test User"; // Simulated employee name

      prefs.setString("Token", token);
      prefs.setString("EmployeeID", employeeID);
      prefs.setString("EmployeeName", employeeName);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Employee Logged In Successfully !",
          style: TextStyle(
            color: Color(0xffeef444c),
            fontFamily: "NexaBold",
          ),
        ),
      ));
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    } else {
      // Call your API for real authentication
      LoginModel data = await LogIN().Log_In(employeeID, password);

      if (data.status.toString() == "404") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("User Not Found !!!",
              style: TextStyle(
                color: Color(0xffeef444c),
                fontFamily: "NexaBold",
              )),
        ));
      } else if (data.status.toString() == "405") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Password is Wrong and Please Try Again !!!",
            style: TextStyle(
              color: Color(0xffeef444c),
              fontFamily: "NexaBold",
            ),
          ),
        ));
      } 
      // Handle other statuses as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          isKeyboardVisible
              ? SizedBox(
                  height: screenHeight / 16,
                )
              : Container(
                  height: screenHeight / 2.5,
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    color: Color(0xff3f51b5),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(70),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: screenWidth / 5,
                    ),
                  ),
                ),
          Container(
            margin: EdgeInsets.only(
              top: screenHeight / 15,
              bottom: screenHeight / 20,
            ),
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: screenWidth / 18,
                fontFamily: "NexaBold",
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth / 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fieldTitle("Employee ID"),
                customField("Enter Your EmployeeID", idController, false, Icons.person),
                fieldTitle("Password"),
                customField("Enter Your password", passController, true, Icons.password_sharp),
                GestureDetector(
                  onTap: LoginEmployee,
                  child: Container(
                    height: 60,
                    width: screenWidth,
                    margin: EdgeInsets.only(top: screenHeight / 40),
                    decoration: const BoxDecoration(
                      color: Color(0xff3f51b5),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Center(
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: screenWidth / 26,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth / 26,
          fontFamily: "NexaBold",
        ),
      ),
    );
  }

  Widget customField(String hint, TextEditingController controller,
      bool obscure, IconData icon) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth / 6,
            child: Icon(
              icon,
              color: const Color(0xff3f51b5),
              size: screenWidth / 15,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 12),
              child: TextFormField(
                controller: controller,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 35,
                  ),
                  border: InputBorder.none,
                  hintText: hint,
                ),
                maxLines: 1,
                obscureText: obscure,
              ),
            ),
          )
        ],
      ),
    );
  }
}
