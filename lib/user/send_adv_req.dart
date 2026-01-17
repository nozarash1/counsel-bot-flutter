// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AddCaseSe extends StatefulWidget {
//   const AddCaseSe({super.key});
//
//   @override
//   State<AddCaseSe> createState() => _AddCaseSeState();
// }
//
// class _AddCaseSeState extends State<AddCaseSe> {
//
//   String Case="";
//   String Date="";
//   String Time="";
//   String Type="";
//   TextEditingController caseController=new TextEditingController();
//   TextEditingController dateController=new TextEditingController();
//   TextEditingController timeController=new TextEditingController();
//   TextEditingController typeController=new TextEditingController();
//
//
//   void sendData() async {
//     String Case = caseController.text.trim();
//     String Date = dateController.text.trim();
//     String Time = timeController.text.trim();
//     String Type = typeController.text.trim();
//
//     if (Case.isEmpty || Date.isEmpty || Time.isEmpty || Type.isEmpty) {
//       Fluttertoast.showToast(msg: 'fill the fields');
//       return;
//     }
//
//     final sh = await SharedPreferences.getInstance();
//     String? url = sh.getString('url');
//     String? lid = sh.getString('lid');
//     String? aid = sh.getString('aid').toString();
//
//     // Safety check if URL is null
//     if (url == null) {
//       Fluttertoast.showToast(msg: 'Server URL not found in preferences');
//       return;
//     }
//
//     final api = Uri.parse('$url/send_adv_req/');
//
//     try {
//       final request = await http.post(api, body: {
//         'lid': lid,
//         'Case': Case,
//         'Date': Date,
//         'Time': Time,
//         'Type': Type,
//         'aid': aid,
//       });
//
//       if (request.statusCode == 200) {
//         var data = jsonDecode(request.body);
//         if (data['status'] == 'ok') {
//           Fluttertoast.showToast(msg: 'Request sent successfully');
//
//         } else {
//           Fluttertoast.showToast(msg: 'Request didnt send');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Connection Error');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'error:$e');
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return
//       Scaffold(appBar: AppBar(title: Text("Case"),),
//         body: Center(child: Column(children: [
//           Text("Case: "),
//           TextFormField(
//             controller: caseController,
//             decoration: InputDecoration(labelText: 'case')
//           ),
//           Text("Date: "),
//           TextFormField(
//               controller: dateController,
//               decoration: InputDecoration(labelText: 'date')
//           ),
//           Text("Time: "),
//           TextFormField(
//               controller: timeController,
//               decoration: InputDecoration(labelText: 'time')
//           ),
//           Text("Type: "),
//           TextFormField(
//               controller: typeController,
//               decoration: InputDecoration(labelText: 'Type')
//           ),
//
// ElevatedButton(onPressed: (){
//   sendData();
// }, child: Text("Send"))
//
//
//         ],),),
//
//         );
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// THEME CONSTANTS
// ---------------------------------------------------------------------------
const Color kCoffeeDark = Color(0xFF4E342E);
const Color kCoffeeMedium = Color(0xFF795548);
const Color kCoffeeLight = Color(0xFFD7CCC8);
const Color kCreamBg = Color(0xFFFAF8F5);

class AddCaseSe extends StatefulWidget {
  final String advocateName;

  // The advocateName is passed from the previous screen here
  const AddCaseSe({super.key, required this.advocateName});

  @override
  State<AddCaseSe> createState() => _AddCaseSeState();
}

class _AddCaseSeState extends State<AddCaseSe> {
  TextEditingController caseController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  // ---------------------------------------------------------------------------
  // BACKEND LOGIC
  // ---------------------------------------------------------------------------
  void sendData() async {
    String Case = caseController.text.trim();
    String Date = dateController.text.trim();
    String Time = timeController.text.trim();
    String Type = typeController.text.trim();

    if (Case.isEmpty || Date.isEmpty || Time.isEmpty || Type.isEmpty) {
      Fluttertoast.showToast(msg: 'Fill the fields');
      return;
    }

    final sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? lid = sh.getString('lid');
    String? aid = sh.getString('aid').toString();

    if (url == null) {
      Fluttertoast.showToast(msg: 'Server URL not found in preferences');
      return;
    }

    final api = Uri.parse('$url/send_adv_req/');

    try {
      final request = await http.post(api, body: {
        'lid': lid,
        'Case': Case,
        'Date': Date,
        'Time': Time,
        'Type': Type,
        'aid': aid,
      });

      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data['status'] == 'ok') {
          Fluttertoast.showToast(msg: 'Request sent successfully');
        } else {
          Fluttertoast.showToast(msg: 'Request didnt send');
        }
      } else {
        Fluttertoast.showToast(msg: 'Connection Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'error:$e');
    }
  }

  // ---------------------------------------------------------------------------
  // DATE PICKER LOGIC
  // ---------------------------------------------------------------------------
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        // Theme customization for the DatePicker to match Coffee Theme
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kCoffeeDark,
              onPrimary: Colors.white,
              onSurface: kCoffeeDark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: kCoffeeDark),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Format: YYYY/MM/DD
        dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // ---------------------------------------------------------------------------
  // UI BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCreamBg,
      appBar: AppBar(
        title: const Text("Case Details", style: TextStyle(color: Colors.white)),
        backgroundColor: kCoffeeDark,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Tell us about your case",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kCoffeeDark),
            ),
            const SizedBox(height: 8),

            // DYNAMIC ADVOCATE NAME DISPLAY
            // This widget uses `widget.advocateName` to display the name passed from the previous page
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: kCoffeeMedium.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kCoffeeMedium.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 20, color: kCoffeeMedium),
                  const SizedBox(width: 10),
                  Text(
                    "Requesting: ",
                    style: TextStyle(color: kCoffeeMedium.withOpacity(0.8), fontSize: 14),
                  ),
                  Expanded(
                    child: Text(
                      widget.advocateName,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: kCoffeeDark, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildLabel("Case Name / Title"),
            _buildTextField(
                controller: caseController,
                hint: "e.g., Property Dispute"
            ),
            const SizedBox(height: 16),

            _buildLabel("Date"),
            // Using the specialized Date Picker Widget here
            _buildDatePicker(context),
            const SizedBox(height: 16),

            _buildLabel("Time"),
            _buildTextField(
                controller: timeController,
                hint: "e.g., 10:00 AM"
            ),
            const SizedBox(height: 16),

            _buildLabel("Case Type"),
            _buildTextField(
                controller: typeController,
                hint: "e.g., Civil, Criminal"
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: sendData,
              style: ElevatedButton.styleFrom(
                backgroundColor: kCoffeeDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
              ),
              child: const Text(
                  "Send Request",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, color: kCoffeeDark, fontSize: 14),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: kCoffeeDark.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: kCoffeeMedium.withOpacity(0.5)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.all(16),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  // Specialized Widget for Date Picking
  Widget _buildDatePicker(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: kCoffeeDark.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: TextFormField(
        controller: dateController,
        readOnly: true, // Prevents manual typing
        onTap: () => _selectDate(context), // Opens the date picker
        decoration: InputDecoration(
          hintText: "YYYY-MM-DD",
          hintStyle: TextStyle(color: kCoffeeMedium.withOpacity(0.5)),
          suffixIcon: const Icon(Icons.calendar_today, color: kCoffeeMedium),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.all(16),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}