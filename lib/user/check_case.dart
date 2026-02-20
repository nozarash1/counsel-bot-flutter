import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ---------------------------------------------------------------------------
// THEME CONSTANTS (Counsel Bot Branding)
// ---------------------------------------------------------------------------
const Color kCounselDark = Color(0xFF422E2A); // Dark maroon-brown
const Color kCounselHeading = Color(0xFFE8DAC5); // Cream/Off-white
const Color kCreamBg = Color(0xFFFDFBF9); // Paper background
const Color kUserBubble = Color(0xFF795548); // User chat bubble
const Color kAiBubble = Color(0xFFEFEBE9); // AI chat bubble
const Color kCoffeeMedium = Color(0xFF5D4037);

class CheckCase extends StatefulWidget {
  const CheckCase({super.key});

  @override
  State<CheckCase> createState() => _CheckCaseState();
}

class _CheckCaseState extends State<CheckCase> {
  final TextEditingController _caseController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  // State management: 0 = Landing, 1 = Chat, 2 = Results
  int _currentStep = 0;
  bool _isLoading = false;
  bool _isAiTyping = false;

  // Data from API
  List<Map<String, dynamic>> _allQuestions = [];
  final List<ChatMessageModel> _chatMessages = [];
  final Map<int, String> _responses = {};
  Map<String, dynamic>? _caseResult;

  int _nextQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentStep == 0 ? kCounselDark : kCreamBg,
      appBar: AppBar(
        title: const Text(
          'THE CHAMBERS',
          style: TextStyle(
            fontFamily: 'serif',
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            color: kCounselHeading,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: kCounselDark,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kCounselHeading),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
                if (_currentStep == 0) {
                  _chatMessages.clear();
                  _responses.clear();
                  _nextQuestionIndex = 0;
                }
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentStep) {
      case 0: return _buildLandingInterface();
      case 1: return _buildChatInterface();
      case 2: return _buildResultInterface();
      default: return _buildLandingInterface();
    }
  }

  // ---------------- STEP 0: LANDING (CASE LOOKUP) ----------------
  Widget _buildLandingInterface() {
    return Center(
      key: const ValueKey('landing'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.gavel_rounded, size: 80, color: kCounselHeading),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "CASE LOOKUP",
                    style: TextStyle(fontSize: 22, fontFamily: 'serif', fontWeight: FontWeight.bold, color: kCounselDark, letterSpacing: 2.0),
                  ),
                  const SizedBox(height: 8),
                  Container(width: 50, height: 2, color: kCounselDark),
                  const SizedBox(height: 40),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("CASE IDENTIFIER", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: kCoffeeMedium, letterSpacing: 1.0)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _caseController,
                    decoration: InputDecoration(
                      hintText: "Enter Case Number",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : sendData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kCounselDark,
                        foregroundColor: kCounselHeading,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: kCounselHeading, strokeWidth: 2))
                          : const Text("SEARCH CASES", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text("Secure System Access", style: TextStyle(color: kCounselHeading.withOpacity(0.5), fontSize: 11, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }

  // ---------------- STEP 1: CHAT INTERFACE ----------------
  Widget _buildChatInterface() {
    return Column(
      key: const ValueKey('chat'),
      children: [
        Expanded(
          child: ListView.builder(
            controller: _chatScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: _chatMessages.length + (_isAiTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _chatMessages.length && _isAiTyping) {
                return _buildAiTypingIndicator();
              }
              final msg = _chatMessages[index];
              return _buildChatBubble(msg);
            },
          ),
        ),
        _buildChatFooter(),
      ],
    );
  }

  Widget _buildChatBubble(ChatMessageModel msg) {
    bool isAi = msg.isAi;
    return Column(
      crossAxisAlignment: isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isAi) _buildAiAvatar(),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(14),
                margin: EdgeInsets.only(left: isAi ? 8 : 50, right: isAi ? 50 : 8, bottom: 4),
                decoration: BoxDecoration(
                  color: isAi ? kAiBubble : kUserBubble,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isAi ? 0 : 16),
                    bottomRight: Radius.circular(isAi ? 16 : 0),
                  ),
                ),
                child: Text(
                  msg.text,
                  style: TextStyle(color: isAi ? kCounselDark : Colors.white, fontSize: 15, height: 1.4),
                ),
              ),
            ),
          ],
        ),
        if (isAi && msg.showOptions)
          Padding(
            padding: const EdgeInsets.only(left: 44, top: 8, bottom: 16),
            child: Row(
              children: [
                _buildOptionButton(msg.questionId!, "Yes"),
                const SizedBox(width: 12),
                _buildOptionButton(msg.questionId!, "No"),
              ],
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildOptionButton(int qId, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: kCounselDark,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: kCounselDark, width: 0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      ),
      onPressed: () => _handleUserResponse(qId, label),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAiAvatar() {
    return Container(
      width: 32, height: 32,
      decoration: const BoxDecoration(color: kCounselDark, shape: BoxShape.circle),
      child: const Icon(Icons.smart_toy_outlined, color: kCounselHeading, size: 18),
    );
  }

  Widget _buildAiTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _buildAiAvatar(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: kAiBubble, borderRadius: BorderRadius.circular(16)),
            child: const Text("Typing...", style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)),
          ),
        ],
      ),
    );
  }

  Widget _buildChatFooter() {
    // Show the final search button only when all questions are answered
    bool allAnswered = _responses.length == _allQuestions.length && _allQuestions.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      color: kCounselDark,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: (allAnswered && !_isLoading) ? fetchResults : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: kCounselHeading,
            foregroundColor: kCounselDark,
            disabledBackgroundColor: kCounselHeading.withOpacity(0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: kCounselDark)
              : Text(allAnswered ? "SEARCH SECTION" : "ANSWER ALL QUESTIONS",
              style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ),
      ),
    );
  }

  // ---------------- STEP 2: RESULT INTERFACE ----------------
  Widget _buildResultInterface() {
    if (_caseResult == null) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      key: const ValueKey('result'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Text("LEGAL ANALYSIS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kCoffeeMedium, letterSpacing: 1.5))),
                const Divider(height: 32),
                Text(_caseResult!['section'] ?? "Section Details", style: const TextStyle(fontSize: 24, fontFamily: 'serif', fontWeight: FontWeight.bold, color: kCounselDark)),
                const SizedBox(height: 20),
                _buildInfoLabel("DESCRIPTION"),
                Text(_caseResult!['details'] ?? "N/A", style: const TextStyle(color: Colors.black87, fontSize: 15, height: 1.5)),
                const SizedBox(height: 20),
                _buildInfoLabel("GENERAL PUNISHMENT"),
                Text(_caseResult!['punishment'] ?? "N/A", style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.w600, fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          if (_caseResult!['data'] != null && (_caseResult!['data'] as List).isNotEmpty) ...[
            const Text("APPLICABLE SUBSECTIONS", style: TextStyle(color: kCounselDark, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 13)),
            const SizedBox(height: 16),
            ...(_caseResult!['data'] as List).map((clause) => _buildSubsectionCard(clause)),
          ],
          const SizedBox(height: 40),
          Center(
            child: OutlinedButton(
              onPressed: () => setState(() { _currentStep = 0; _caseController.clear(); }),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: kCounselDark)),
              child: const Text("START NEW SEARCH", style: TextStyle(color: kCounselDark)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubsectionCard(dynamic clause) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: kCounselDark.withOpacity(0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.article_rounded, color: kCounselDark, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(clause['Subsection'] ?? "", style: const TextStyle(color: kCounselDark, fontWeight: FontWeight.bold, fontSize: 16))),
            ],
          ),
          const SizedBox(height: 12),
          Text(clause['Details'] ?? "", style: const TextStyle(color: Colors.black54, fontSize: 14)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4)),
            child: Text("Penalty: ${clause['Punishment']}", style: TextStyle(color: Colors.red.shade800, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kCoffeeMedium, letterSpacing: 0.5)),
    );
  }

  // ---------------- LOGIC & API CALLS ----------------

  void sendData() async {
    String ccase = _caseController.text.trim();
    if (ccase.isEmpty) {
      Fluttertoast.showToast(msg: 'Enter Case ID', backgroundColor: kCounselDark, textColor: Colors.white);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final sh = await SharedPreferences.getInstance();
      String? url = sh.getString('url');
      final request = await http.post(Uri.parse('$url/fetch_case/'), body: {'case': ccase});

      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data['status'] == 'ok') {
          if (data['sid'] != null) sh.setString("sid", data['sid'].toString());

          setState(() {
            _allQuestions = List<Map<String, dynamic>>.from(data["data"]);
            _currentStep = 1;
            _chatMessages.clear();
            _nextQuestionIndex = 0;
          });
          _addNextAiQuestion();
        } else {
          Fluttertoast.showToast(msg: 'Case not found');
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _addNextAiQuestion() async {
    if (_nextQuestionIndex >= _allQuestions.length) return;

    setState(() => _isAiTyping = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final question = _allQuestions[_nextQuestionIndex];
    setState(() {
      _isAiTyping = false;
      _chatMessages.add(ChatMessageModel(
        text: question['text'] ?? "",
        isAi: true,
        showOptions: true,
        questionId: question['id'],
      ));
    });
    _scrollToBottom();
  }

  void _handleUserResponse(int qId, String label) {
    setState(() {
      // Hide options on current question
      int idx = _chatMessages.indexWhere((m) => m.questionId == qId && m.isAi);
      if (idx != -1) _chatMessages[idx] = _chatMessages[idx].copyWith(showOptions: false);

      _chatMessages.add(ChatMessageModel(text: label, isAi: false));
      _responses[qId] = label;
    });

    _scrollToBottom();
    _nextQuestionIndex++;
    if (_nextQuestionIndex < _allQuestions.length) {
      _addNextAiQuestion();
    } else {
      _finishAiSequence();
    }
  }

  void _finishAiSequence() async {
    setState(() => _isAiTyping = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _isAiTyping = false;
      _chatMessages.add(ChatMessageModel(text: "Thank you. I have all the details. Click below to view the legal analysis.", isAi: true));
    });
    _scrollToBottom();
  }

  void fetchResults() async {
    setState(() => _isLoading = true);
    try {
      final sh = await SharedPreferences.getInstance();
      String? url = sh.getString('url');
      String? sid = sh.getString('sid');

      final request = await http.post(Uri.parse('$url/fetch_case_details/'), body: {
        'sid': sid.toString(),
        "qa": _responses.toString() // Python backend parses this string format
      });

      if (request.statusCode == 200) {
        var data = jsonDecode(request.body);
        if (data['status'] == 'ok') {
          setState(() { _caseResult = data; _currentStep = 2; });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Analysis failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(_chatScrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }
}

class ChatMessageModel {
  final String text;
  final bool isAi;
  final bool showOptions;
  final int? questionId;

  ChatMessageModel({required this.text, required this.isAi, this.showOptions = false, this.questionId});

  ChatMessageModel copyWith({bool? showOptions}) {
    return ChatMessageModel(text: text, isAi: isAi, showOptions: showOptions ?? this.showOptions, questionId: questionId);
  }
}