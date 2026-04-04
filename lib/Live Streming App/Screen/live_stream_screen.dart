import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ui_design/Live%20Streming%20App/Model/model.dart';
import 'package:flutter_ui_design/Live%20Streming%20App/Screen/profile_detail_screen.dart';

class LiveStreamScreen extends StatefulWidget {
  final StreamItems streamItems;
  const LiveStreamScreen({super.key, required this.streamItems});

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  bool _isFollowing = false;
  bool _isLiked = false;
  int _likeCount = 0;
  final TextEditingController _commentCtrl = TextEditingController();
  final List<_Comment> _comments = [
    _Comment(user: "Sample User", text: "Welcome", avatarUrl: "https://symbl-cdn.com/i/webp/9c/4628a5e254c186333877e3449d1caf.webp"),
    _Comment(user: "Fan123", text: "Good Game!", avatarUrl: "https://symbl-cdn.com/i/webp/ef/717de6be0d2c9eb4d9d91521542da2.webp"),
    _Comment(user: "Viewer", text: "I love you", avatarUrl: "https://symbl-cdn.com/i/webp/9c/4628a5e254c186333877e3449d1caf.webp"),
    _Comment(user: "SportsFan", text: "What is your favorite sports?", avatarUrl: "https://symbl-cdn.com/i/webp/ef/717de6be0d2c9eb4d9d91521542da2.webp"),
  ];
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _likeCount = int.tryParse(widget.streamItems.viewer.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _sendComment() {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.add(_Comment(
        user: "You",
        text: text,
        avatarUrl: widget.streamItems.url,
        isMe: true,
      ));
      _commentCtrl.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background image
          Hero(
            tag: widget.streamItems.image,
            child: Image.network(
              widget.streamItems.image,
              fit: BoxFit.cover,
              width: size.width,
              height: size.height,
            ),
          ),
          // Dark overlay
          Container(
            color: Colors.black26,
            width: size.width,
            height: size.height,
          ),
          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileDetailScreen(stream: widget.streamItems),
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.streamItems.url),
                      radius: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.streamItems.name,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${widget.streamItems.followers} Followers",
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _isFollowing = !_isFollowing),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: _isFollowing ? Colors.grey.shade700 : Colors.blueAccent,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      child: Text(
                        _isFollowing ? "Following" : "Follow",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Viewers + Live badge
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        color: Colors.black12,
                        child: Row(
                          children: [
                            const Icon(Icons.visibility_outlined, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              widget.streamItems.viewer,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Text(
                                "Live",
                                style: TextStyle(color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Chat area
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Comment list
                SizedBox(
                  height: size.height * 0.38,
                  child: ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _comments.length,
                    itemBuilder: (_, i) {
                      final c = _comments[i];
                      return _commentCard(c);
                    },
                  ),
                ),
                // Comment input bar
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                    left: 12,
                    right: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withAlpha(150),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentCtrl,
                                  style: const TextStyle(color: Colors.white),
                                  onSubmitted: (_) => _sendComment(),
                                  decoration: const InputDecoration(
                                    hintText: "Comment...",
                                    hintStyle: TextStyle(color: Colors.white70),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _sendComment,
                                child: CircleAvatar(
                                  backgroundColor: Colors.purpleAccent,
                                  radius: 18,
                                  child: Transform.rotate(
                                    angle: 5.5,
                                    child: const Icon(Icons.send_outlined, color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // Share
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Link copied to clipboard!")),
                          );
                        },
                        child: CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.grey.withAlpha(150),
                          child: const Icon(Icons.share_outlined, size: 26, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLiked = !_isLiked;
                            _isLiked ? _likeCount++ : _likeCount--;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.grey.withAlpha(150),
                              child: Icon(
                                _isLiked ? Icons.favorite : Icons.favorite_border,
                                size: 26,
                                color: _isLiked ? Colors.red : Colors.white,
                              ),
                            ),
                            if (_isLiked)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.add, size: 8, color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _commentCard(_Comment c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: c.isMe ? Colors.purpleAccent.withAlpha(80) : Colors.grey.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(c.avatarUrl),
            radius: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  c.user,
                  style: TextStyle(
                    color: c.isMe ? Colors.purpleAccent : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  c.text,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Comment {
  final String user;
  final String text;
  final String avatarUrl;
  final bool isMe;

  _Comment({
    required this.user,
    required this.text,
    required this.avatarUrl,
    this.isMe = false,
  });
}
