import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  TextEditingController complaintController = TextEditingController();

  List<dynamic> complaintList = [];
  List<dynamic> advocatesList = [];
  String? selectedAdvocateId;

  bool isLoading = true;
  bool isLoadingAdvocates = true;

  final Color _coffeeDark = const Color(0xFF3E2723);
  final Color _coffeeMedium = const Color(0xFF5D4037);
  final Color _creamBackground = const Color(0xFFFDFBF7);
  final Color _textDark = const Color(0xFF2D1E1B);

  @override
  void initState() {
    super.initState();
    fetchAdvocates(); // Fetch advocates for the dropdown
    fetchComplaints(); // Fetch existing complaints
  }

  Future<void> fetchAdvocates() async {
    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');

    if (url == null) {
      setState(() { isLoadingAdvocates = false; });
      return;
    }

    // Assuming you create a simple endpoint to fetch advocates
    final api = Uri.parse('$url/view_advocates/');

    try {
      final response = await http.get(api);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            advocatesList = data['data'];
            isLoadingAdvocates = false;
          });
        } else {
          setState(() { isLoadingAdvocates = false; });
        }
      } else {
        setState(() { isLoadingAdvocates = false; });
      }
    } catch (e) {
      setState(() { isLoadingAdvocates = false; });
      Fluttertoast.showToast(msg: 'Error loading advocates: $e');
    }
  }

  Future<void> fetchComplaints() async {
    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? lid = sh.getString('lid');

    if (url == null || lid == null) {
      setState(() { isLoading = false; });
      return;
    }

    final api = Uri.parse('$url/View_User_adv_comp/');

    try {
      final response = await http.post(api, body: {
        'lid': lid
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            complaintList = data['data'];
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
      Fluttertoast.showToast(msg: 'Error loading complaints: $e');
    }
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
                Icons.gavel_rounded,
                size: 60,
                color: _creamBackground.withOpacity(0.8),
              ),
              const SizedBox(height: 20),
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
                            Text(
                              "FILE A COMPLAINT",
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'serif',
                                fontWeight: FontWeight.bold,
                                color: _textDark,
                                letterSpacing: 1.2,
                              ),
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
                      Text(
                        "SELECT ADVOCATE",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _coffeeMedium,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Loading indicator or Dropdown for Advocates
                      isLoadingAdvocates
                          ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                          : DropdownButtonFormField<String>(
                        value: selectedAdvocateId,
                        icon: Icon(Icons.keyboard_arrow_down, color: _coffeeDark),
                        decoration: InputDecoration(
                          hintText: 'Choose an Advocate...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: _coffeeDark, width: 2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        items: advocatesList.map<DropdownMenuItem<String>>((adv) {
                          return DropdownMenuItem<String>(
                            value: adv['id'].toString(), // Uses the advocate's DB ID as value
                            child: Text(
                              adv['Name'].toString(),
                              style: TextStyle(color: _textDark, fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedAdvocateId = newValue;
                          });
                        },
                      ),

                      const SizedBox(height: 20),
                      Text(
                        "COMPLAINT DETAILS",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _coffeeMedium,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: complaintController,
                        maxLines: 5,
                        style: TextStyle(color: _textDark, fontWeight: FontWeight.w500),
                        cursorColor: _coffeeDark,
                        decoration: InputDecoration(
                          hintText: 'Please describe your issue in detail...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
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
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: sendData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _coffeeDark,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'SUBMIT COMPLAINT',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "We take all grievances seriously.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 40),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "YOUR COMPLAINTS",
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
                  : complaintList.isEmpty
                  ? const Center(
                child: Text(
                  "No complaints filed yet.",
                  style: TextStyle(color: Colors.white70),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: complaintList.length,
                itemBuilder: (context, index) {
                  var item = complaintList[index];
                  bool hasReply = item['Reply'] != null &&
                      item['Reply'].toString().trim().isNotEmpty &&
                      item['Reply'].toString().toLowerCase() != 'pending';

                  return Card(
                    elevation: 2,
                    color: _creamBackground,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "ADV: ${item['Advocate']?.toString().toUpperCase() ?? 'UNKNOWN'}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _coffeeDark,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                item['Date']?.toString() ?? '',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _coffeeMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['Complaint']?.toString() ?? '',
                            style: TextStyle(
                              color: _textDark,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                          // Display the reply box if a reply exists
                          if (hasReply) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _coffeeMedium.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: _coffeeMedium.withOpacity(0.2)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.reply_rounded, size: 18, color: _coffeeMedium),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item['Reply'].toString(),
                                      style: TextStyle(
                                          color: _coffeeDark,
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                          height: 1.3
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ],
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

  void sendData() async {
    String complaintText = complaintController.text.trim();

    if (selectedAdvocateId == null || selectedAdvocateId!.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please select an Advocate',
        backgroundColor: _coffeeDark,
        textColor: Colors.white,
      );
      return;
    }

    if (complaintText.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please describe your complaint',
        backgroundColor: _coffeeDark,
        textColor: Colors.white,
      );
      return;
    }

    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? lid = sh.getString('lid');

    final api = Uri.parse('$url/Send_User_adv_comp/');

    try {
      final request = await http.post(api, body: {
        'lid': lid ?? "",
        'Advocate': selectedAdvocateId!, // Sending the selected ID
        'Complaint': complaintText,
        'Reply': 'pending',
      });

      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(
              msg: 'Complaint submitted successfully',
              backgroundColor: Colors.green.shade800,
              textColor: Colors.white
          );

          setState(() {
            selectedAdvocateId = null; // Reset dropdown
            complaintController.clear(); // Clear text
          });

          fetchComplaints(); // Refresh the list
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