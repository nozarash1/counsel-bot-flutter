import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Note: Ensure you have your login.dart imported correctly
import '../login.dart';

class AdvocateRegistration extends StatefulWidget {
  const AdvocateRegistration({super.key});

  @override
  State<AdvocateRegistration> createState() => _AdvocateRegistrationState();
}

class _AdvocateRegistrationState extends State<AdvocateRegistration> {
  File? _image;
  File? _proof;
  final ImagePicker _picker = ImagePicker();

  TextEditingController nameController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController expController = TextEditingController();
  TextEditingController feeController = TextEditingController();
  String? selectedQualification;
  final List<String> qualifications = [
    'BA LLB',
    'BBA LLB',
    'BTech LLB',
    'LLM',
  ];

  // NEW FIELDS
  TextEditingController dobController = TextEditingController();
  String gender = "Male"; // default

  // --- THEME COLORS ---
  final Color _coffeeDark = const Color(0xFF3E2723); // Dark Brown
  final Color _coffeeMedium = const Color(0xFF5D4037); // Medium Brown
  final Color _paperCream = const Color(0xFFFFF3E0); // Light Cream
  final Color _goldAccent = const Color(0xFFFFB300); // Muted Gold

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _coffeeDark,
      appBar: AppBar(
        backgroundColor: _coffeeDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _paperCream),
        title: Text(
          'ADVOCATE REGISTRATION',
          style: TextStyle(
            color: _paperCream,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif', // Formal font style
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Decoration
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: _coffeeDark,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- SECTION 1: PERSONAL DETAILS ---
                      _buildSectionHeader("Personal Details"),

                      // Profile Image Picker
                      Center(
                        child: GestureDetector(
                          onTap: () => _showImageSourceDialog(isProof: false),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: _coffeeMedium.withOpacity(0.1),
                            backgroundImage: _image != null ? FileImage(_image!) : null,
                            child: _image == null
                                ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_add, size: 40, color: _coffeeMedium),
                                const SizedBox(height: 5),
                                Text("Upload Photo", style: TextStyle(color: _coffeeMedium, fontSize: 10)),
                              ],
                            )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(nameController, 'Full Name', Icons.person),
                      _buildTextField(dobController, 'Date of Birth', Icons.calendar_month, isReadOnly: true, onTap: _pickDOB),

                      const SizedBox(height: 15),
                      const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildRadio("Male"),
                          _buildRadio("Female"),
                          _buildRadio("Other"),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // --- SECTION 2: CONTACT INFORMATION ---
                      _buildSectionHeader("Contact Information"),
                      _buildTextField(emailController, 'Email Address', Icons.email, inputType: TextInputType.emailAddress),
                      _buildTextField(phoneController, 'Phone Number', Icons.phone, inputType: TextInputType.phone),
                      Row(
                        children: [
                          Expanded(child: _buildTextField(placeController, 'City/Place', Icons.location_city)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildTextField(pinController, 'PIN Code', Icons.pin_drop, inputType: TextInputType.number)),
                        ],
                      ),
                      _buildTextField(postController, 'Post Office', Icons.local_post_office),
                      const SizedBox(height: 20),

                      // --- SECTION 3: PROFESSIONAL INFO ---
                      _buildSectionHeader("Professional Profile"),

                      // Qualification Dropdown
                      DropdownButtonFormField<String>(
                        decoration: _inputDecoration('Qualification', Icons.school),
                        value: selectedQualification,
                        items: qualifications.map((q) {
                          return DropdownMenuItem(value: q, child: Text(q));
                        }).toList(),
                        onChanged: (value) => setState(() => selectedQualification = value),
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(child: _buildTextField(expController, 'Exp (Yrs)', Icons.work_history, inputType: TextInputType.number)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildTextField(feeController, 'Consultation Fee', Icons.currency_rupee, inputType: TextInputType.number)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ID Proof Upload
                      const Text("Identity Proof (Bar Council ID)", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _proof != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_proof!, fit: BoxFit.cover),
                        )
                            : Center(
                          child: TextButton.icon(
                            onPressed: () => _showImageSourceDialog(isProof: true),
                            icon: Icon(Icons.upload_file, color: _coffeeMedium),
                            label: Text("Tap to upload Proof", style: TextStyle(color: _coffeeMedium)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- SECTION 4: SECURITY ---
                      _buildSectionHeader("Account Security"),
                      _buildTextField(usernameController, 'Create Username', Icons.alternate_email),
                      _buildTextField(passwordController, 'Create Password', Icons.lock, isObscure: true),

                      const SizedBox(height: 30),

                      // SUBMIT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: sendData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _coffeeDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'REGISTER ADVOCATE',
                            style: TextStyle(
                              color: _goldAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: _coffeeMedium,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
        Divider(color: _coffeeMedium, thickness: 1),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool isObscure = false, bool isReadOnly = false, VoidCallback? onTap, TextInputType? inputType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        readOnly: isReadOnly,
        onTap: onTap,
        keyboardType: inputType,
        decoration: _inputDecoration(label, icon),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(icon, color: _coffeeMedium),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: _coffeeDark, width: 2),
      ),
    );
  }

  Widget _buildRadio(String value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: gender,
          activeColor: _coffeeDark,
          onChanged: (val) {
            setState(() {
              gender = val.toString();
            });
          },
        ),
        Text(value),
        const SizedBox(width: 10),
      ],
    );
  }

  void _showImageSourceDialog({required bool isProof}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIconBtn(Icons.camera_alt, "Camera", () {
              Navigator.pop(context);
              isProof ? _pickProof(ImageSource.camera) : _pickImage(ImageSource.camera);
            }),
            _buildIconBtn(Icons.photo_library, "Gallery", () {
              Navigator.pop(context);
              isProof ? _pickProof(ImageSource.gallery) : _pickImage(ImageSource.gallery);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBtn(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: _coffeeMedium.withOpacity(0.1),
            child: Icon(icon, color: _coffeeDark, size: 30),
          ),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(color: _coffeeDark)),
        ],
      ),
    );
  }

  // --- LOGIC FUNCTIONS (Unchanged) ---

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
              primary: _coffeeDark,
              onPrimary: Colors.white,
              onSurface: _coffeeDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        dobController.text =
        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }

  Future<void> sendData() async {
    String name = nameController.text.trim();
    String place = placeController.text.trim();
    String password = passwordController.text.trim();
    String username = usernameController.text.trim();
    String dob = dobController.text.trim();
    String post = postController.text.trim();
    String pin = pinController.text.trim();
    String phone = phoneController.text.trim();
    String exp = expController.text.trim();
    String fee = feeController.text.trim();
    String email = emailController.text.trim();

    if (name.isEmpty ||
        password.isEmpty ||
        place.isEmpty ||
        username.isEmpty ||
        dob.isEmpty ||
        post.isEmpty ||
        pin.isEmpty ||
        phone.isEmpty ||
        exp.isEmpty ||
        fee.isEmpty ||
        email.isEmpty) {
      Fluttertoast.showToast(msg: 'Fill out all the fields');
      return;
    }

    if (_image == null) {
      Fluttertoast.showToast(msg: 'Select an image');
      return;
    }

    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    final api = Uri.parse('$url/adv_reg/');

    try {
      final request = http.MultipartRequest('POST', api);

      request.fields['name'] = name;
      request.fields['place'] = place;
      request.fields['username'] = username;
      request.fields['password'] = password;
      request.fields['dob'] = dob;
      request.fields['gender'] = gender;
      request.fields['post'] = post;
      request.fields['pin'] = pin;
      request.fields['phone'] = phone;
      request.fields['email'] = email;
      request.fields['fees'] = fee;
      request.fields['experience'] = exp;
      request.fields['qualification'] = selectedQualification ?? "";

      request.files.add(await http.MultipartFile.fromPath(
        'photo',
        _image!.path,
      ));
      if (_proof != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'proof',
          _proof!.path,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var data = jsonDecode(responseData);

        if (data['status'] == 'ok') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          Fluttertoast.showToast(msg: 'Error Occurred');
        }
      } else {
        Fluttertoast.showToast(msg: 'Server Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickProof(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _proof = File(pickedFile.path);
      });
    }
  }
}