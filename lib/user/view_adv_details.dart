// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ViewAdvDetails extends StatefulWidget {
//   const ViewAdvDetails({super.key});
//
//   @override
//   State<ViewAdvDetails> createState() => _ViewAdvDetailsState();
// }
// String Name="";
// String Photo="";
// String Place="";
// String Post="";
// String Pin="";
// String Phone="";
// String Email="";
// String Gender="";
// String Qualification="";
// String Experience="";
// String Fee="";
//
// class _ViewAdvDetailsState extends State<ViewAdvDetails> {
//   _ViewAdvDetailsState()
//   {
//     fetchUsers();
//   }
//   void fetchUsers() async {
//     final pref = await SharedPreferences.getInstance();
//     final ip = pref.getString('url') ?? "";
//     final aid = pref.getString('aid') ?? "";
//     final imgUrl = pref.getString('img_url') ?? "";
//     final response = await http.post(Uri.parse("$ip/user_view_adv1/"),
//       body: {"aid":aid}
//
//
//     );
//     final jsonData = json.decode(response.body);
//
//     if (jsonData['status'] == 'ok') {
//       Name=jsonData['Name'];
//       Photo=imgUrl+jsonData['Photo'];
//       Place=jsonData['Place'];
//       Post=jsonData['Post'];
//       Pin=jsonData['Pin'].toString();
//       Phone=jsonData['Phone'].toString();
//       Email=jsonData['Email'];
//       Gender=jsonData['Gender'];
//       Qualification=jsonData['Qualification'];
//       Experience=jsonData['Experience'].toString();
//       Fee=jsonData['Fee'].toString();
//       // Attach full image URL to each user
//       // return List<Map<String, dynamic>>.from(jsonData['data']).map((user) {
//       //   user['Photo'] = user['Photo'] != null ? imgUrl + user['Photo'] : null;
//       //   return user;
//       // }).toList();
//       setState(() {
//
//       });
//     } else {
//
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text("View Advocate"),),
//     body: Center(child: Column(children: [
//
//       CircleAvatar(
//         radius: 30,
//         backgroundImage: Photo != null
//             ? NetworkImage(Photo)
//             : const AssetImage('assets/default_user.png')
//         as ImageProvider,
//       ),
//       Text("Name: "+Name),
//       Text("Place: "+Place),
//       Text("Post: "+Post),
//       Text("Pin: "+Pin.toString()),
//       Text("Phone: "+Phone.toString()),
//       Text("Email: "+Email),
//       Text("Gender: "+Gender),
//       Text("Qualification: "+Qualification),
//       Text("Experience: "+Experience.toString()),
//       Text("Fee: "+Fee),
//     ])));
//   }
// }
import 'dart:convert';
import 'package:counsel/user/send_adv_req.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// THEME CONSTANTS (Coffee Palette)
// ---------------------------------------------------------------------------
const Color kCoffeeDark = Color(0xFF4E342E);    // Espresso
const Color kCoffeeMedium = Color(0xFF795548);  // Medium Brown
const Color kCoffeeLight = Color(0xFFD7CCC8);   // Latte
const Color kCreamBg = Color(0xFFFAF8F5);       // Cream Background
const Color kGoldStar = Color(0xFFFFB300);      // Amber

class ViewAdvDetails extends StatefulWidget {
  const ViewAdvDetails({super.key});

  @override
  State<ViewAdvDetails> createState() => _ViewAdvDetailsState();
}

class _ViewAdvDetailsState extends State<ViewAdvDetails> {
  // Moved variables inside state for proper refreshing
  String name = "";
  String photo = "";
  String place = "";
  String post = "";
  String pin = "";
  String phone = "";
  String email = "";
  String gender = "";
  String qualification = "";
  String experience = "";
  String fee = "";
  String id = "";

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    final pref = await SharedPreferences.getInstance();
    final ip = pref.getString('url') ?? "";
    final aid = pref.getString('aid') ?? "";
    final imgUrl = pref.getString('img_url') ?? "";

    // Keeping your exact connection logic
    final response = await http.post(
      Uri.parse("$ip/user_view_adv1/"),
      body: {"aid": aid},
    );

    final jsonData = json.decode(response.body);

    if (jsonData['status'] == 'ok') {
      if (mounted) {
        setState(() {
          name = jsonData['Name'] ?? "";
          // Handle photo URL construction safely
          photo = (jsonData['Photo'] != null && jsonData['Photo'].toString().isNotEmpty)
              ? imgUrl + jsonData['Photo']
              : "";
          place = jsonData['Place'] ?? "";
          id = jsonData['id'].toString() ?? "";
          post = jsonData['Post'] ?? "";
          pin = jsonData['Pin'].toString();
          phone = jsonData['Phone'].toString();
          email = jsonData['Email'] ?? "";
          gender = jsonData['Gender'] ?? "";
          qualification = jsonData['Qualification'] ?? "";
          experience = jsonData['Experience'].toString();
          fee = jsonData['Fee'].toString();
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCreamBg,
      appBar: AppBar(
        title: const Text("Advocate Details", style: TextStyle(color: Colors.white)),
        backgroundColor: kCoffeeDark,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: kCoffeeDark))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // -------------------------------------------------------
            // HEADER SECTION (Image + Name)
            // -------------------------------------------------------
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: kCoffeeLight.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: kCoffeeDark.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: kCoffeeLight.withOpacity(0.3),
                    backgroundImage: (photo.isNotEmpty)
                        ? NetworkImage(photo)
                        : const AssetImage('assets/default_user.png') as ImageProvider,
                    child: (photo.isEmpty)
                        ? const Icon(Icons.person, size: 50, color: kCoffeeMedium)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: kCoffeeDark
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, size: 16, color: kCoffeeMedium),
                      const SizedBox(width: 4),
                      Text(
                        place,
                        style: const TextStyle(color: kCoffeeMedium, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // -------------------------------------------------------
            // PROFESSIONAL INFO SECTION
            // -------------------------------------------------------
            _buildSectionTitle("Professional Details"),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _boxDecoration(),
              child: Column(
                children: [
                  _buildInfoRow(Icons.school, "Qualification", qualification),
                  _buildDivider(),
                  _buildInfoRow(Icons.work_history, "Experience", "$experience Years"),
                  _buildDivider(),
                  _buildInfoRow(Icons.payments, "Consultation Fee", "₹$fee"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // -------------------------------------------------------
            // CONTACT & PERSONAL INFO SECTION
            // -------------------------------------------------------
            _buildSectionTitle("Contact & Personal"),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _boxDecoration(),
              child: Column(
                children: [
                  _buildInfoRow(Icons.phone, "Phone", phone),
                  _buildDivider(),
                  _buildInfoRow(Icons.email, "Email", email),
                  _buildDivider(),
                  _buildInfoRow(Icons.person, "Gender", gender),
                  _buildDivider(),
                  _buildInfoRow(Icons.map, "Address Info", "$place, $post\nPIN: $pin"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // -------------------------------------------------------
            // ACTION BUTTON
            // -------------------------------------------------------
            ElevatedButton(
              onPressed: ()  async {

                final sh = await  SharedPreferences.getInstance();
                sh.setString('aid', id);
                sh.setString('name', name);

            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddCaseSe(advocateName:name,)));

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kCoffeeDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              child: const Text(
                  "Send Request",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPER WIDGETS FOR STYLING
  // ---------------------------------------------------------------------------

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: kCoffeeLight.withOpacity(0.5)),
      boxShadow: [
        BoxShadow(
          color: kCoffeeDark.withOpacity(0.02),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: kCoffeeDark,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: kCoffeeMedium),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: kCoffeeMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty ? value : "N/A",
                style: const TextStyle(
                  fontSize: 15,
                  color: kCoffeeDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Divider(height: 1, color: kCoffeeLight.withOpacity(0.4)),
    );
  }
}