import 'package:counsel/user/advocate_request.dart';
import 'package:counsel/user/check_case.dart';
import 'package:counsel/user/feedback.dart';
import 'package:counsel/user/view_complaint.dart';
import 'package:flutter/material.dart';
import 'notification.dart';

// Imports for Logout
import 'package:shared_preferences/shared_preferences.dart';
import '../login.dart'; // Ensure this points to your actual login page file

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  // Color Palette based on "The Chambers" image
  final Color _primaryBrown = const Color(0xFF4E342E); // Dark Coffee
  final Color _accentBrown = const Color(0xFF8D6E63); // Light Coffee
  final Color _bgCream = const Color(0xFFFDFBF7); // Paper/Legal pad
  final Color _cardBg = const Color(0xFFFFFFFF); // White cards
  final Color _subText = const Color(0xFF757575); // Grey for subtitles
  final Color _textOnBrown = const Color(0xFFFDFBF7); // Cream text for the dark header

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgCream,
      // Remove standard SafeArea to let the header color extend to the top
      body: Column(
        children: [
          // --- Header Section with Coffee Brown Background ---
          Container(
            color: _primaryBrown,
            padding: EdgeInsets.only(
              // Add padding for status bar manually since we are outside SafeArea
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 24,
              left: 24,
              right: 24,
            ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "The Counsel Bot",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _textOnBrown,
                        fontFamily: 'Serif',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Welcome back, User.",
                      style: TextStyle(
                        fontSize: 14,
                        color: _textOnBrown.withOpacity(0.8), // Slightly dimmed cream
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Serif',
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    // Darker brown for the badge background
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _accentBrown),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shield_outlined, size: 14, color: _textOnBrown),
                      const SizedBox(width: 4),
                      Text(
                        "Secure",
                        style: TextStyle(fontSize: 10, color: _textOnBrown),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // --- Body Section (Grid) ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      padding: EdgeInsets.zero,
                      children: [

                        // Button 1: Check Case
                        _buildMenuCard(
                          title: "Check Case",
                          subtitle: "Track status",
                          icon: Icons.gavel,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CheckCase()));
                          },
                        ),

                        // Button 2: History
                        _buildMenuCard(
                          title: "History",
                          subtitle: "Past records",
                          icon: Icons.history_edu,
                          onTap: () {},
                        ),

                        // Button 3: Advocates
                        _buildMenuCard(
                          title: "Advocates",
                          subtitle: "Find counsel",
                          icon: Icons.person_search_outlined,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => view_advocate()));
                          },
                        ),

                        // Button 4: Notification
                        _buildMenuCard(
                          title: "Notification",
                          subtitle: "Updates & Alerts",
                          icon: Icons.notifications_none_outlined,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UserNotification()));
                          },
                        ),

                        // Button 5: View Complaints
                        _buildMenuCard(
                          title: "Complaints",
                          subtitle: "Review filings",
                          icon: Icons.folder_open_outlined,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ComplaintPage()));
                          },
                        ),

                        // Button 6: Feedback
                        _buildMenuCard(
                          title: "Feedback",
                          subtitle: "System review",
                          icon: Icons.chat_bubble_outline,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => feedback()));
                          },
                        ),
                      ],
                    ),
                  ),

                  // --- Footer Section (Logout) ---
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();

                        // 1. Save the server URLs so we don't lose connection
                        String? serverUrl = prefs.getString('url');
                        String? imgUrl = prefs.getString('img_url');

                        // 2. Clear all user session data (logs them out safely)
                        await prefs.clear();

                        // 3. Put the URLs back into storage
                        if (serverUrl != null) {
                          await prefs.setString('url', serverUrl);
                        }
                        if (imgUrl != null) {
                          await prefs.setString('img_url', imgUrl);
                        }

                        // Navigate back to Login and clear the stack
                        if (mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                                (Route<dynamic> route) => false,
                          );
                        }
                      },
                      icon: Icon(Icons.logout, size: 18, color: _primaryBrown),
                      label: Text(
                        "Recess (Logout)",
                        style: TextStyle(color: _primaryBrown, fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _primaryBrown.withOpacity(0.5)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "© 2024 Judiciary System User v1.0",
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: _primaryBrown),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _primaryBrown,
                fontFamily: 'Serif',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: _subText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}