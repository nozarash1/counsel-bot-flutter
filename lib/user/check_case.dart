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
const Color kUserBubble = Color(0xFFF3F0EA); // Lighter cream for user bubble
const Color kAiBubble = Colors.transparent; // AI has no background in modern UI
const Color kCoffeeMedium = Color(0xFF5D4037);

class CheckCase extends StatefulWidget {
  const CheckCase({super.key});

  @override
  State<CheckCase> createState() => _CheckCaseState();
}

class _CheckCaseState extends State<CheckCase> with TickerProviderStateMixin {
  final TextEditingController _caseController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

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
      backgroundColor: kCreamBg,
      appBar: AppBar(
        title: const Text(
          'THE CHAMBERS',
          style: TextStyle(
            fontFamily: 'serif',
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            color: kCounselDark,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: kCreamBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kCounselDark),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
                if (_currentStep == 0) {
                  _chatMessages.clear();
                  _responses.clear();
                  _nextQuestionIndex = 0;
                  _caseController.clear();
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
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentStep) {
      case 0:
        return _buildLandingInterface();
      case 1:
        return _buildChatInterface();
      case 2:
        return _buildResultInterface();
      default:
        return _buildLandingInterface();
    }
  }

  // ---------------- STEP 0: LANDING (CASE LOOKUP) ----------------
  Widget _buildLandingInterface() {
    return Center(
      key: const ValueKey('landing'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kCounselDark.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.gavel_rounded, size: 64, color: kCounselDark),
            ),
            const SizedBox(height: 32),
            const Text(
              "How can I assist with your case today?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontFamily: 'serif',
                fontWeight: FontWeight.w600,
                color: kCounselDark,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 48),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  )
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _caseController,
                      decoration: InputDecoration(
                        hintText: "Enter Case Number or Identifier...",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _isLoading ? null : sendData(),
                    ),
                  ),
                  _isLoading
                      ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: kCounselDark, strokeWidth: 2),
                    ),
                  )
                      : Container(
                    decoration: const BoxDecoration(
                      color: kCounselDark,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward_rounded, color: kCounselHeading),
                      onPressed: sendData,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Secure System Access • Counsel Bot",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12, letterSpacing: 0.5),
            ),
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
          child: Stack(
            children: [
              AnimatedList(
                key: _listKey,
                controller: _chatScrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                initialItemCount: _chatMessages.length,
                itemBuilder: (context, index, animation) {
                  return _buildAnimatedBubble(_chatMessages[index], animation);
                },
              ),
              if (_isAiTyping)
                Positioned(
                  bottom: 20,
                  left: 24,
                  child: _buildAiTypingIndicator(),
                ),
            ],
          ),
        ),
        _buildChatFooter(),
      ],
    );
  }

  Widget _buildAnimatedBubble(ChatMessageModel msg, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: animation.drive(
            Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeOutQuart)),
          ),
          child: _buildChatBubble(msg),
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessageModel msg) {
    bool isAi = msg.isAi;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: isAi
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAiAvatar(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg.text,
                  style: const TextStyle(
                    color: kCounselDark,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                if (msg.showOptions)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildOptionChip(msg.questionId!, "Yes", Icons.check_circle_outline),
                        _buildOptionChip(msg.questionId!, "No", Icons.cancel_outlined),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: kUserBubble,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                msg.text,
                style: const TextStyle(
                  color: kCounselDark,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionChip(int qId, String label, IconData icon) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(scale: 0.9 + (0.1 * value), child: child),
        );
      },
      child: ActionChip(
        label: Text(label),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, color: kCounselDark),
        avatar: Icon(icon, color: kCounselDark, size: 18),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        elevation: 0,
        pressElevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        onPressed: () => _handleUserResponse(qId, label),
      ),
    );
  }

  Widget _buildAiAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: kCounselDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.gavel_rounded, color: kCounselHeading, size: 20),
    );
  }

  Widget _buildAiTypingIndicator() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAiAvatar(),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) => _buildTypingDot(i)),
          ),
        ),
      ],
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 200)),
      tween: Tween(begin: 0.3, end: 1.0),
      builder: (context, value, child) {
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: kCounselDark.withOpacity(value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildChatFooter() {
    bool allAnswered = _responses.length == _allQuestions.length && _allQuestions.isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: BoxDecoration(
        color: kCreamBg,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: allAnswered ? kCounselDark : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(28),
          boxShadow: allAnswered
              ? [BoxShadow(color: kCounselDark.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: (allAnswered && !_isLoading) ? fetchResults : null,
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: kCounselHeading, strokeWidth: 2),
              )
                  : Text(
                allAnswered ? "GENERATE LEGAL ANALYSIS" : "AWAITING INTERVIEW COMPLETION...",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  fontSize: 14,
                  color: allAnswered ? kCounselHeading : Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- STEP 2: RESULT INTERFACE ----------------
  Widget _buildResultInterface() {
    if (_caseResult == null) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      key: const ValueKey('result'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAiAvatar(),
              const SizedBox(width: 16),
              const Text(
                "Analysis Complete",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kCounselDark),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Hero(
            tag: 'result_card',
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _caseResult!['section'] ?? "Section Details",
                      style: const TextStyle(fontSize: 26, fontFamily: 'serif', fontWeight: FontWeight.bold, color: kCounselDark),
                    ),
                    const SizedBox(height: 24),
                    _buildInfoLabel("DESCRIPTION"),
                    Text(
                      _caseResult!['details'] ?? "N/A",
                      style: const TextStyle(color: Colors.black87, fontSize: 16, height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    _buildInfoLabel("GENERAL PUNISHMENT"),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.red.shade800, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _caseResult!['punishment'] ?? "N/A",
                              style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (_caseResult!['data'] != null && (_caseResult!['data'] as List).isNotEmpty) ...[
            const Text("Applicable Subsections", style: TextStyle(color: kCounselDark, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            ...(_caseResult!['data'] as List).map((clause) => _buildSubsectionCard(clause)),
          ],
          const SizedBox(height: 40),
          Center(
            child: TextButton.icon(
              onPressed: () => setState(() {
                _currentStep = 0;
                _caseController.clear();
                _chatMessages.clear();
                _responses.clear();
                _nextQuestionIndex = 0;
              }),
              icon: const Icon(Icons.refresh, color: kCounselDark),
              label: const Text("Start New Inquiry", style: TextStyle(color: kCounselDark, fontWeight: FontWeight.bold, fontSize: 16)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubsectionCard(dynamic clause) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: kCreamBg, borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.article_outlined, color: kCounselDark, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(clause['Subsection'] ?? "", style: const TextStyle(color: kCounselDark, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(clause['Details'] ?? "", style: const TextStyle(color: Colors.black87, fontSize: 15, height: 1.5)),
          const SizedBox(height: 16),
          Text("Penalty: ${clause['Punishment']}", style: TextStyle(color: Colors.red.shade800, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildInfoLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0)),
    );
  }

  // ---------------- LOGIC & API CALLS (Original implementation restored) ----------------

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
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final question = _allQuestions[_nextQuestionIndex];
    setState(() {
      _isAiTyping = false;
      final newMsg = ChatMessageModel(
        text: question['text'] ?? "",
        isAi: true,
        showOptions: true,
        questionId: question['id'],
      );
      _chatMessages.add(newMsg);
      _listKey.currentState?.insertItem(_chatMessages.length - 1, duration: const Duration(milliseconds: 400));
    });
    _scrollToBottom();
  }

  void _handleUserResponse(int qId, String label) {
    setState(() {
      int idx = _chatMessages.indexWhere((m) => m.questionId == qId && m.isAi);
      if (idx != -1) _chatMessages[idx] = _chatMessages[idx].copyWith(showOptions: false);

      final userMsg = ChatMessageModel(text: label, isAi: false);
      _chatMessages.add(userMsg);
      _listKey.currentState?.insertItem(_chatMessages.length - 1, duration: const Duration(milliseconds: 400));
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
    if (!mounted) return;
    setState(() {
      _isAiTyping = false;
      final finalMsg = ChatMessageModel(text: "Interview complete. I'm finalizing your legal analysis now. Please press 'Generate Legal Analysis' below.", isAi: true);
      _chatMessages.add(finalMsg);
      _listKey.currentState?.insertItem(_chatMessages.length - 1, duration: const Duration(milliseconds: 400));
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
        "qa": _responses.toString()
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
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutQuart,
        );
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