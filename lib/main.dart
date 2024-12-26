import 'package:flutter/material.dart';

void main() {
  runApp(const ChatGPTClone());
}

class ChatGPTClone extends StatelessWidget {
  const ChatGPTClone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF343541),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF343541),
          elevation: 0,
        ),
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isDrawerOpen = true;
  bool _isTyping = false; // Typing indicator flag
  late AnimationController _animationController;
  late Animation<double> _drawerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _drawerAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true; // Show typing indicator
    });
    _controller.clear();
    _scrollToBottom();

    // Simulate AI thinking and typing
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _messages.add(ChatMessage(
          text: _getAIResponse(text),
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isTyping = false; // Remove typing indicator
      });
      _scrollToBottom();
    });
  }

  String _getAIResponse(String input) {
    input = input.toLowerCase();
    if (input.contains('flutter')) {
      return 'Flutter is an open-source UI software development toolkit created by Google for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase. It uses the Dart programming language and provides a rich set of pre-built widgets and tools.';
    } else if (input.contains('hello') || input.contains('hi')) {
      return 'Hello! I\'m your AI assistant. How can I help you today? Feel free to ask me any questions about programming, technology, or other topics.';
    } else if (input.contains('features') || input.contains('what can you do')) {
      return 'I can help you with:\n\n• Programming and technical questions\n• Explanations and tutorials\n• Code reviews and debugging\n• Best practices and design patterns\n• General knowledge and discussions';
    } else if (input.contains('dart')) {
      return 'Dart is a client-optimized programming language for apps on multiple platforms. It is developed by Google and is used to build mobile, desktop, server, and web applications. Dart is the language behind Flutter.';
    } else if (input.contains('javascript')) {
      return 'JavaScript is a versatile, high-level programming language primarily used for creating interactive effects within web browsers. It is an essential technology alongside HTML and CSS for web development.';
    } else if (input.contains('machine learning')) {
      return 'Machine Learning is a subset of artificial intelligence that focuses on building systems that can learn from and make decisions based on data. It includes techniques like supervised learning, unsupervised learning, and reinforcement learning.';
    } else if (input.contains('help with code') || input.contains('debug')) {
      return 'Sure! Please share the code you need help with, and let me know what issues you are encountering. I\'ll do my best to assist you in debugging and improving your code.';
    } else if (input.contains('best practices')) {
      return 'Best practices include writing clean and readable code, following consistent naming conventions, documenting your code, writing unit tests, and regularly refactoring to improve code quality and maintainability.';
    } else if (input.contains('design patterns')) {
      return 'Design patterns are typical solutions to common problems in software design. They are templates designed to help write code that is easier to understand and reuse. Examples include Singleton, Observer, Factory, and Strategy patterns.';
    } else if (input.contains('what is ai') || input.contains('artificial intelligence')) {
      return 'Artificial Intelligence (AI) is the simulation of human intelligence processes by machines, especially computer systems. It encompasses areas like machine learning, natural language processing, robotics, and computer vision.';
    } else if (input.contains('thank you') || input.contains('thanks')) {
      return 'You\'re welcome! If you have any more questions, feel free to ask.';
    } else if (input.contains('bye') || input.contains('goodbye')) {
      return 'Goodbye! Have a great day. If you need assistance in the future, don\'t hesitate to reach out.';
    } else {
      return 'I understand your question. Could you please provide more context or rephrase it? I\'m here to help with programming, technical topics, and general knowledge.';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      if (_isDrawerOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildAnimatedDrawer(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Container(
                    color: const Color(0xFF343541),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: _messages.length + (_isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length && _isTyping) {
                          return const TypingIndicator();
                        }
                        return _messages[index];
                      },
                    ),
                  ),
                ),
                _buildInputArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDrawer() {
    return AnimatedBuilder(
      animation: _drawerAnimation,
      builder: (context, child) {
        return SizeTransition(
          axis: Axis.horizontal,
          sizeFactor: _drawerAnimation,
          child: SizedBox(
            width: 260,
            child: _buildDrawer(),
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Container(
      color: const Color(0xFF202123),
      child: Column(
        children: [
          const SizedBox(height: 12),
          _buildNewChatButton(),
          const Divider(height: 32, color: Colors.white24),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length ~/ 2,
              itemBuilder: (context, index) {
                return _buildChatHistoryItem(index);
              },
            ),
          ),
          const Divider(color: Colors.white24),
          _buildDrawerFooter(),
        ],
      ),
    );
  }

  Widget _buildNewChatButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(12),
        ),
        onPressed: () {
          setState(() {
            _messages.clear();
          });
        },
        child: const Row(
          children: [
            Icon(Icons.add, size: 16),
            SizedBox(width: 8),
            Text('New chat'),
          ],
        ),
      ),
    );
  }

  Widget _buildChatHistoryItem(int index) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.chat_bubble_outline, size: 18),
      title: Text(
        'Chat ${index + 1}',
        style: const TextStyle(fontSize: 14),
      ),
      onTap: () {},
    );
  }

  Widget _buildDrawerFooter() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, size: 20),
          ),
          SizedBox(width: 12),
          Text('User Settings'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white10),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isDrawerOpen ? Icons.menu_open : Icons.menu,
              color: Colors.white70,
            ),
            onPressed: _toggleDrawer,
          ),
          const Expanded(
            child: Text(
              'ChatGPT',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF343541),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF40414F),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Send a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                maxLines: null,
                textInputAction: TextInputAction.newline,
                style: const TextStyle(fontSize: 16),
                onSubmitted: _handleSubmitted,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.send_rounded),
                onPressed: () => _handleSubmitted(_controller.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isUser ? Colors.transparent : const Color(0xFF444654),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: isUser ? const Color(0xFF343541) : const Color(0xFF10A37F),
              child: Icon(
                isUser ? Icons.person : Icons.assistant,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isUser ? 'You' : 'ChatGPT',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    text,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 32),
          ],
        ),
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF444654),
      padding: const EdgeInsets.all(16),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFF10A37F),
            child: Icon(
              Icons.assistant,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Text(
            'ChatGPT is typing...',
            style: TextStyle(
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
