import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../login.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // --- CONTROLLERS ---
  TextEditingController nameController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  String gender = "Male";

  // --- COLOR PALETTE (Dark Coffee Theme) ---
  final Color _bgCoffeeDark = const Color(0xFF3E2723);  // Deep Espresso Background
  final Color _cardCream = const Color(0xFFEFEBE9);     // Light Cream for readability
  final Color _textBrown = const Color(0xFF4E342E);     // Dark text for inside cards
  final Color _goldAccent = const Color(0xFFC5A059);    // Legal Gold styling

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgCoffeeDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: _goldAccent),
        title: Text(
          'REGISTRY',
          style: TextStyle(
            color: _goldAccent,
            fontFamily: 'Serif',
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // --- PROFILE IMAGE SECTION ---
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _goldAccent, width: 3),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5))
                            ]
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: _cardCream,
                          backgroundImage: _image != null ? FileImage(_image!) : null,
                          child: _image == null
                              ? Icon(Icons.person, size: 60, color: _bgCoffeeDark)
                              : null,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showImageSourceSheet(),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: _goldAccent,
                          child: Icon(Icons.camera_alt, color: _bgCoffeeDark, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // --- FORM CONTAINER ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _cardCream,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border(top: BorderSide(color: _goldAccent, width: 4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Personal Details"),
                        _buildTextField(nameController, 'Full Name', Icons.person),
                        const SizedBox(height: 15),
                        _buildTextField(dobController, 'Date of Birth', Icons.calendar_month, isReadOnly: true, onTap: _pickDOB),
                        const SizedBox(height: 15),

                        // Gender Section
                        Text("Gender Identity", style: TextStyle(color: _textBrown.withOpacity(0.7), fontSize: 12)),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _textBrown.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildRadio("Male"),
                              _buildRadio("Female"),
                              _buildRadio("Other"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),

                        _buildSectionHeader("Contact & Address"),
                        _buildTextField(emailController, 'Email Address', Icons.email, inputType: TextInputType.emailAddress),
                        const SizedBox(height: 15),
                        _buildTextField(phoneController, 'Phone Number', Icons.phone, inputType: TextInputType.phone),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(child: _buildTextField(placeController, 'Place/City', Icons.location_on)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildTextField(postController, 'Post Office', Icons.local_post_office)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(pinController, 'PIN Code', Icons.pin_drop, inputType: TextInputType.number),

                        const SizedBox(height: 25),

                        _buildSectionHeader("Account Security"),
                        _buildTextField(usernameController, 'Username', Icons.alternate_email),
                        const SizedBox(height: 15),
                        _buildTextField(passwordController, 'Password', Icons.lock, isObscure: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- SUBMIT BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: sendData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _goldAccent,
                        foregroundColor: _bgCoffeeDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'COMPLETE REGISTRATION',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: _textBrown,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              fontSize: 12,
            ),
          ),
          Divider(color: _textBrown.withOpacity(0.3), thickness: 1),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool isObscure = false, bool isReadOnly = false, VoidCallback? onTap, TextInputType? inputType}) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      readOnly: isReadOnly,
      onTap: onTap,
      keyboardType: inputType,
      cursorColor: _bgCoffeeDark,
      style: TextStyle(color: _textBrown, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: _textBrown.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: _bgCoffeeDark),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _textBrown.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _bgCoffeeDark, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      ),
    );
  }

  Widget _buildRadio(String value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: gender,
          activeColor: _bgCoffeeDark,
          onChanged: (val) {
            setState(() {
              gender = val.toString();
            });
          },
        ),
        Text(value, style: TextStyle(color: _textBrown, fontWeight: FontWeight.w600)),
      ],
    );
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardCream,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: _textBrown),
              title: Text('Gallery', style: TextStyle(color: _textBrown)),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: _textBrown),
              title: Text('Camera', style: TextStyle(color: _textBrown)),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIC ---

  Future<void> _pickDOB() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _bgCoffeeDark,
              onPrimary: Colors.white,
              onSurface: _textBrown,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        dobController.text = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }

  Future<void> sendData() async {
    print("--- STARTING REGISTRATION ---");

    // 1. TRIM INPUTS
    String name = nameController.text.trim();
    String place = placeController.text.trim();
    String password = passwordController.text.trim();
    String username = usernameController.text.trim();
    String dob = dobController.text.trim();
    String post = postController.text.trim();
    String pin = pinController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();

    // 2. CHECK EMPTY
    if (name.isEmpty ||
        password.isEmpty ||
        place.isEmpty ||
        username.isEmpty ||
        dob.isEmpty ||
        pin.isEmpty ||
        post.isEmpty ||
        email.isEmpty ||
        phone.isEmpty) {
      _showMessage('Please fill out all fields');
      print("Validation Error: Missing fields");
      return;
    }

    if (_image == null) {
      _showMessage('Please select a profile image');
      print("Validation Error: No image selected");
      return;
    }

    // 3. GET URL
    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');

    // DEBUG PRINT
    print("Found URL in Storage: $url");

    if (url == null) {
      _showMessage('System Error: IP Address not found. Go back and Login.');
      return;
    }

    final api = Uri.parse('$url/user_reg/');

    try {
      final request = http.MultipartRequest('POST', api);

      request.fields['name'] = name;
      request.fields['place'] = place;
      request.fields['username'] = username;
      request.fields['password'] = password;
      request.fields['dob'] = dob;
      request.fields['gender'] = gender;
      request.fields['pin'] = pin;
      request.fields['post'] = post;
      request.fields['email'] = email;
      request.fields['phone'] = phone;

      request.files.add(await http.MultipartFile.fromPath(
        'photo',
        _image!.path,
      ));

      print("Sending Request to: $api");
      var response = await request.send();
      print("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var data = jsonDecode(responseData);

        if (data['status'] == 'ok') {
          _showMessage('Registration Successful!');
          if (mounted) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        } else {
          _showMessage('Error: ${data['message'] ?? 'Unknown Error'}');
        }
      } else {
        _showMessage('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print("EXCEPTION OCCURRED: $e");
      _showMessage('Connection Error: $e');
    }
  }

  // Helper for Snackbars (Replaces Toast)
  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _goldAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}