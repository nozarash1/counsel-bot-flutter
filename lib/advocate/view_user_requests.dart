import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// THEME CONSTANTS
// ---------------------------------------------------------------------------
const Color kCoffeeDark = Color(0xFF3E2723);
const Color kCoffeeMedium = Color(0xFF5D4037);
const Color kCoffeeLight = Color(0xFF8D6E63);
const Color kCreamBg = Color(0xFFFDFBF9);

class ViewUserRequest extends StatefulWidget {
  const ViewUserRequest({super.key});

  @override
  State<ViewUserRequest> createState() => _ViewUserRequestState();
}

class _ViewUserRequestState extends State<ViewUserRequest> {
  List<dynamic> requestList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  // ---------------------------------------------------------------------------
  // FETCH USER REQUESTS
  // ---------------------------------------------------------------------------
  Future<void> fetchRequests() async {
    final pref = await SharedPreferences.getInstance();
    final ip = pref.getString('url') ?? "";
    final lid = pref.getString('lid') ?? "";

    try {
      final response = await http.post(
        Uri.parse("$ip/advocate_view_user/"),
        body: {"lid": lid},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'ok') {
          setState(() {
            requestList = jsonData['data'];
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // ACCEPT REQUEST
  // ---------------------------------------------------------------------------
  Future<void> acceptRequest(String requestId) async {
    final pref = await SharedPreferences.getInstance();
    final ip = pref.getString('url') ?? "";

    await http.post(
      Uri.parse("$ip/Accept_Users_request/"),
      body: {"rid": requestId},
    );

    fetchRequests();
  }

  // ---------------------------------------------------------------------------
  // REJECT REQUEST
  // ---------------------------------------------------------------------------
  Future<void> rejectRequest(String requestId) async {
    final pref = await SharedPreferences.getInstance();
    final ip = pref.getString('url') ?? "";

    await http.post(
      Uri.parse("$ip/Reject_Users_request/"),
      body: {"rid": requestId},
    );

    fetchRequests();
  }

  // Helper to determine status color based on string content
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green.shade700;
      case 'rejected':
        return Colors.red.shade700;
      default:
        return Colors.orange.shade800;
    }
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCreamBg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "User Requests",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: kCoffeeDark,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: kCoffeeDark))
          : requestList.isEmpty
          ? const Center(
        child: Text(
          "No Requests Found",
          style: TextStyle(color: kCoffeeMedium),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requestList.length,
        itemBuilder: (context, index) {
          final item = requestList[index];
          // Ensure the status is handled as a string
          final status = (item['rstatus'] ?? "pending").toString();

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: kCoffeeDark.withOpacity(0.03),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          (item['Casename']?.toString() ?? "Untitled").toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kCoffeeDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(status),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Card Details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.gavel, "Type", item['Casetype']),
                      _buildInfoRow(Icons.person, "Client", item['name']),
                      _buildInfoRow(Icons.email, "Email", item['email']),
                      _buildInfoRow(Icons.phone, "Phone", item['phno']),
                      _buildInfoRow(Icons.location_on, "Place", item['place']),
                      _buildInfoRow(Icons.calendar_today, "Date", item['date']),
                    ],
                  ),
                ),

                // Action Buttons (Only for Pending)
                if (status.toLowerCase() == 'pending') ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red.shade700,
                              side: BorderSide(color: Colors.red.shade200),
                            ),
                            onPressed: () => rejectRequest(item['id'].toString()),
                            child: const Text("Reject"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => acceptRequest(item['id'].toString()),
                            child: const Text("Accept"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // Custom Info Row Widget to handle potential 'int' to 'String' errors
  Widget _buildInfoRow(IconData icon, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: kCoffeeMedium),
          const SizedBox(width: 10),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          Expanded(
            child: Text(
              value?.toString() ?? "N/A",
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}