// import 'dart:convert';
// import 'package:counsel/user/view_adv_details.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// class view_advocate extends StatefulWidget {
//   const view_advocate({super.key});
//
//   @override
//   State<view_advocate> createState() => _view_advocateState();
// }
//
// class _view_advocateState extends State<view_advocate> {
//
//   // _view_advocateState(){
//   //   fetchUsers();
//   // }
//
//   Future<List<Map<String, dynamic>>> fetchUsers() async {
//     final pref = await SharedPreferences.getInstance();
//     final ip = pref.getString('url') ?? "";
//     final imgUrl = pref.getString('img_url') ?? "";
//     final response = await http.post(Uri.parse("$ip/user_view_adv/"));
//     final jsonData = json.decode(response.body);
//
//     if (jsonData['status'] == 'ok') {
//       // Attach full image URL to each user
//       return List<Map<String, dynamic>>.from(jsonData['data']).map((user) {
//         user['Photo'] = user['Photo'] != null ? imgUrl + user['Photo'] : null;
//         return user;
//       }).toList();
//     } else {
//       return [];
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("View All Advocates")),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: fetchUsers(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No Advocate found"));
//           }
//
//           final users = snapshot.data!;
//
//           return ListView.builder(
//             physics: const BouncingScrollPhysics(),
//             itemCount: users.length,
//
//             itemBuilder: (context, index) {
//
//               final user = users[index];
//               return Card(
//                 margin: const EdgeInsets.all(8),
//
//                 child: ListTile(
//                   onTap:() async {
//                     SharedPreferences sh= await SharedPreferences.getInstance();
//                     sh.setString("aid",  user['id'].toString());
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAdvDetails()));
//                   },
//                   leading: CircleAvatar(
//                     radius: 30,
//                     backgroundImage: user['Photo'] != null
//                         ? NetworkImage(user['Photo'])
//                         : const AssetImage('assets/default_user.png')
//                     as ImageProvider,
//                   ),
//                   title: Text(
//                     user['Name'],
//                     style: const TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(user['Place']),
//
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:counsel/user/view_adv_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ---------------------------------------------------------------------------
// THEME CONSTANTS (Coffee Palette)
// ---------------------------------------------------------------------------
const Color kCoffeeDark = Color(0xFF4E342E);    // Espresso
const Color kCoffeeMedium = Color(0xFF795548);  // Medium Brown
const Color kCoffeeLight = Color(0xFFD7CCC8);   // Latte
const Color kCreamBg = Color(0xFFFAF8F5);       // Cream Background
const Color kGoldStar = Color(0xFFFFB300);      // Amber

class view_advocate extends StatefulWidget {
  const view_advocate({super.key});

  @override
  State<view_advocate> createState() => _view_advocateState();
}

class _view_advocateState extends State<view_advocate> {

  // ---------------------------------------------------------------------------
  // BACKEND CONNECTION (UNCHANGED)
  // ---------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final pref = await SharedPreferences.getInstance();
    final ip = pref.getString('url') ?? "";
    final imgUrl = pref.getString('img_url') ?? "";
    final response = await http.post(Uri.parse("$ip/user_view_adv/"));
    final jsonData = json.decode(response.body);

    if (jsonData['status'] == 'ok') {
      // Attach full image URL to each user
      return List<Map<String, dynamic>>.from(jsonData['data']).map((user) {
        user['Photo'] = user['Photo'] != null ? imgUrl + user['Photo'] : null;
        return user;
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCreamBg, // Theme Background
      appBar: AppBar(
        title: const Text(
          "View All Advocates",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: kCoffeeDark, // Theme AppBar
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: kCoffeeDark));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Advocate found"));
          }

          final users = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            physics: const BouncingScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              // Extracting data with safe fallbacks for the UI layout
              final String name = user['Name']?.toString() ?? "Unknown";
              final String photoUrl = user['Photo'];
              final String place = user['Place']?.toString() ?? "";
              // Assuming these keys might exist in your backend later, or using placeholders
              final String qualification = user['Qualification']?.toString() ?? "Not Specified";
              final String experience = user['Experience']?.toString() ?? "N/A";
              final String phone = user['Phone']?.toString() ?? "Hidden";
              final String fee = user['Fee']?.toString() ?? "Consultation Fee";
              // Default rating to 4 if not provided
              final int rating = int.tryParse(user['rating']?.toString() ?? "4") ?? 4;

              // -------------------------------------------------------
              // CUSTOM CARD DESIGN IMPLEMENTATION
              // -------------------------------------------------------
              return Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: kCoffeeLight.withOpacity(0.5), width: 1.0),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: kCoffeeDark.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // UPPER SECTION: Image + Text
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Circular Image
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kCreamBg,
                            border: Border.all(color: kCoffeeLight),
                            image: photoUrl != null
                                ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover)
                                : null,
                          ),
                          child: photoUrl == null
                              ? const Icon(Icons.person, size: 32, color: kCoffeeMedium)
                              : null,
                        ),

                        const SizedBox(width: 16),

                        // 2. Text Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: kCoffeeDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (place.isNotEmpty)
                                Text(
                                  place,
                                  style: const TextStyle(color: kCoffeeMedium, fontStyle: FontStyle.italic, fontSize: 12),
                                ),
                              const SizedBox(height: 6),
                              _buildInfoRow("Qual:", qualification),
                              _buildInfoRow("Exp:", experience),
                              _buildInfoRow("Ph:", phone),
                              const SizedBox(height: 4),
                              Text(
                                '₹ ${user['Fee'] ?? '2500'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: kCoffeeDark,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Divider(height: 1, color: kCoffeeLight.withOpacity(0.5)),
                    const SizedBox(height: 12),

                    // LOWER SECTION: Ratings + Request Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 1. Ratings
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              starIndex < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                              size: 20,
                              color: kGoldStar,
                            );
                          }),
                        ),

                        // 2. Request Button (Triggers your Logic)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            // -----------------------------------------------------
                            // EXACT NAVIGATION LOGIC FROM YOUR SNIPPET
                            // -----------------------------------------------------
                            onTap: () async {
                              SharedPreferences sh = await SharedPreferences.getInstance();
                              sh.setString("aid", user['id'].toString());
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAdvDetails()));
                            },
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: const Text(
                                "View Details",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: kCoffeeDark,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Helper widget for consistent text styling
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: kCoffeeMedium, height: 1.3),
          children: [
            TextSpan(
              text: "$label ",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: kCoffeeMedium.withOpacity(0.8)
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}