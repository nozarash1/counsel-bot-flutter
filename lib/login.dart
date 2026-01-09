import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Keeping your project imports
import 'package:counsel/user/home.dart';
import 'package:counsel/user/registration.dart';
import 'advocate/home.dart';
import 'advocate/registration.dart';

void main() {
  runApp(const myapp());
}

class myapp extends StatelessWidget {
  const myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CounselBot',
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // UI State
  bool _showPassword = false;

  // Colors
  static const Color colBackground = Color(0xFF3E2723);
  static const Color colCard = Color(0xFF5D4037);
  static const Color colGold = Color(0xFFD4AF37);
  static const Color colTextMain = Color(0xFFFFFFFF);
  static const Color colTextSub = Color(0xB3FFFFFF);
  static const Color colInputBorder = Color(0xFF8D6E63);
  static const Color colInputFill = Color(0x1F000000);
  static const Color colCreamText = Color(0xFFFFECB3);
  static const Color colButtonText = Color(0xFF3E2723);

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Logo
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Icon(
                  Icons.gavel,
                  size: 80,
                  color: colGold,
                ),
              ),

              // 2. Title
              const Text(
                "COUNSELBOT",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3.0,
                  color: colTextMain,
                  fontFamily: 'Serif',
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Legal Access Simplified",
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: colTextSub,
                ),
              ),
              const SizedBox(height: 40),

              // 3. Login Card
              Container(
                constraints: const BoxConstraints(maxWidth: 384),
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: colCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colGold, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Username
                    _buildTextField(
                      controller: userController,
                      hintText: "Username",
                      icon: Icons.person,
                      isPassword: false,
                    ),

                    const SizedBox(height: 24),

                    // Password
                    _buildTextField(
                      controller: passwordController,
                      hintText: "Password",
                      icon: Icons.lock,
                      isPassword: true,
                    ),

                    const SizedBox(height: 16),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: sendData, // Calls your logic function
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colGold,
                          foregroundColor: colButtonText,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 4. Registration Links
              Container(
                constraints: const BoxConstraints(maxWidth: 384),
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildFooterLink(
                        "User\nRegistration",
                        Icons.person_add_alt_1,
                            () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>UserRegistration()));
                        }
                    ),

                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withOpacity(0.3),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),

                    _buildFooterLink(
                        "Advocate\nRegistration",
                        Icons.assignment_ind,
                            () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AdvocateRegistration()));
                        }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !_showPassword : false,
      style: const TextStyle(color: colTextMain),
      cursorColor: colGold,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: colInputFill,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        prefixIcon: Icon(icon, color: colGold, size: 20),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _showPassword ? Icons.visibility_off : Icons.visibility,
            size: 20,
            color: Colors.white54,
          ),
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: colInputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: colInputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: colGold),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text, IconData icon, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colCreamText, size: 24),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: colCreamText,
              fontSize: 14,
              height: 1.2,
              decoration: TextDecoration.underline,
              decorationColor: colCreamText,
            ),
          ),
        ],
      ),
    );
  }

  // --- Logic ---

  void sendData() async {
    String username = userController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'fill the fields');
      return;
    }

    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');

    // Safety check if URL is null
    if (url == null) {
      Fluttertoast.showToast(msg: 'Server URL not found in preferences');
      return;
    }

    final api = Uri.parse('$url/flutter_login_post/');

    try {
      final request = await http.post(api, body: {
        'username': username,
        'password': password,
      });

      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data['status'] == 'ok') {
          if (data['type'] == 'advocate') {
            final sh = await SharedPreferences.getInstance();
            await sh.setString('lid', data['lid'].toString());
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AdvocateHome()));
          } else if (data['type'] == 'user') {
            final sh = await SharedPreferences.getInstance();
            await sh.setString('lid', data['lid'].toString());
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => UserHome()));
          }
        } else {
          Fluttertoast.showToast(msg: 'invalid username or password');
        }
      } else {
        Fluttertoast.showToast(msg: 'connection error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'error:$e');
    }
  }
}