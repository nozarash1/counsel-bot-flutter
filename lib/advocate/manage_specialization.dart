import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ManageSpecializationPage extends StatefulWidget {
  const ManageSpecializationPage({super.key});

  @override
  State<ManageSpecializationPage> createState() => _ManageSpecializationPageState();
}

class _ManageSpecializationPageState extends State<ManageSpecializationPage> {
  TextEditingController specializationController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  List<dynamic> specializationList = [];
  bool isLoading = true;

  // NEW: Tracks the ID of the specialization we are editing. Null means we are Adding.
  String? editingId;

  // --- THEME COLORS ---
  final Color _coffeeDark = const Color(0xFF3E2723);
  final Color _coffeeMedium = const Color(0xFF5D4037);
  final Color _creamBackground = const Color(0xFFFDFBF7);
  final Color _textDark = const Color(0xFF2D1E1B);
  final Color _goldAccent = const Color(0xFFFFB300);

  @override
  void initState() {
    super.initState();
    fetchSpecializations();
  }

  // Fetch existing specializations from the backend
  Future<void> fetchSpecializations() async {
    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');

    if (url == null) {
      setState(() { isLoading = false; });
      return;
    }

    final api = Uri.parse('$url/view_specialization/');

    try {
      final response = await http.get(api);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            specializationList = data['data'];
            isLoading = false;
          });
        } else {
          setState(() { isLoading = false; });
        }
      } else {
        setState(() { isLoading = false; });
      }
    } catch (e) {
      setState(() { isLoading = false; });
      Fluttertoast.showToast(msg: 'Error loading specializations: $e');
    }
  }

  // NEW: Populates the form fields when you tap the "Edit" icon
  void startEditing(Map<String, dynamic> item) {
    setState(() {
      specializationController.text = item['Specialization'].toString();
      detailsController.text = item['Details'].toString();
      editingId = item['id'].toString(); // Save the ID so the backend knows what to update
    });
  }

  // NEW: Clears the form and cancels editing mode
  void clearForm() {
    setState(() {
      specializationController.clear();
      detailsController.clear();
      editingId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _coffeeDark,
      appBar: AppBar(
        title: const Text(
          'THE CHAMBERS',
          style: TextStyle(
              fontFamily: 'serif',
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(
                Icons.account_balance_rounded,
                size: 60,
                color: _creamBackground.withOpacity(0.8),
              ),
              const SizedBox(height: 20),

              // --- FORM SECTION ---
              Card(
                elevation: 8,
                color: _creamBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            // Smart Title changes based on editing mode
                            Text(
                              editingId == null ? "MANAGE SPECIALIZATION" : "EDIT SPECIALIZATION",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'serif',
                                fontWeight: FontWeight.bold,
                                color: _textDark,
                                letterSpacing: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 60,
                              height: 3,
                              color: _coffeeMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Specialization Title Field
                      Text(
                        "SPECIALIZATION TITLE",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _coffeeMedium,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: specializationController,
                        style: TextStyle(color: _textDark, fontWeight: FontWeight.w500),
                        cursorColor: _coffeeDark,
                        decoration: _inputDecoration('e.g. Criminal Law, Corporate Law', Icons.bookmark),
                      ),
                      const SizedBox(height: 20),

                      // Details / Description Field
                      Text(
                        "OTHER DETAILS / DESCRIPTION",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _coffeeMedium,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: detailsController,
                        maxLines: 4,
                        style: TextStyle(color: _textDark, fontWeight: FontWeight.w500),
                        cursorColor: _coffeeDark,
                        decoration: _inputDecoration('Brief description of this area of practice...', null),
                      ),
                      const SizedBox(height: 30),

                      // Submit & Cancel Buttons
                      Row(
                        children: [
                          // Only show Cancel button if we are in Edit mode
                          if (editingId != null) ...[
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 50,
                                child: OutlinedButton(
                                  onPressed: clearForm,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: _coffeeDark,
                                    side: BorderSide(color: _coffeeDark),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  ),
                                  child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],

                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: sendData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _coffeeDark,
                                  foregroundColor: _goldAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  // Smart Button Text
                                  editingId == null ? 'ADD SPECIALIZATION' : 'UPDATE RECORD',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // --- LIST SECTION ---
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "ACTIVE SPECIALIZATIONS",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : specializationList.isEmpty
                  ? const Center(
                child: Text(
                  "No specializations added yet.",
                  style: TextStyle(color: Colors.white70),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: specializationList.length,
                itemBuilder: (context, index) {
                  var item = specializationList[index];

                  return Card(
                    elevation: 2,
                    color: _creamBackground,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      leading: CircleAvatar(
                        backgroundColor: _coffeeMedium.withOpacity(0.1),
                        child: Icon(Icons.gavel, color: _coffeeDark, size: 20),
                      ),
                      title: Text(
                        item['Specialization']?.toString().toUpperCase() ?? 'UNKNOWN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _coffeeDark,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          item['Details']?.toString() ?? 'No description provided.',
                          style: TextStyle(
                            color: _textDark,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                      // NEW: Edit Button
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueGrey),
                        onPressed: () {
                          // Triggers the form to fill with this item's data
                          startEditing(item);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData? icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
      prefixIcon: icon != null ? Icon(icon, color: _coffeeMedium) : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _coffeeDark, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // Smart sendData checks if it should Add or Update
  void sendData() async {
    String specialization = specializationController.text.trim();
    String details = detailsController.text.trim();

    if (specialization.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter a Specialization Title',
        backgroundColor: _coffeeDark,
        textColor: Colors.white,
      );
      return;
    }

    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');

    // Determine the correct API endpoint based on editing mode
    String endpoint = editingId == null ? '/add_specialization/' : '/update_specialization/';
    final api = Uri.parse('$url$endpoint');

    try {
      // Prepare the data to send
      Map<String, String> requestBody = {
        'Specialization': specialization,
        'Details': details,
      };

      // If we are editing, we MUST send the ID to the backend
      if (editingId != null) {
        requestBody['id'] = editingId!;
      }

      final request = await http.post(api, body: requestBody);

      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(
              msg: editingId == null ? 'Specialization Added' : 'Specialization Updated',
              backgroundColor: Colors.green.shade800,
              textColor: Colors.white
          );

          clearForm(); // Reset the form after success
          fetchSpecializations(); // Refresh the list
        } else {
          Fluttertoast.showToast(msg: 'Submission failed');
        }
      } else {
        Fluttertoast.showToast(msg: 'Connection error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }
}