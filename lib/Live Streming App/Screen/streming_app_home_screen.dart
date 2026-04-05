import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ui_design/Live%20Streming%20App/Constants/colors.dart';
import 'package:flutter_ui_design/Live%20Streming%20App/Model/model.dart';
import 'package:flutter_ui_design/Live%20Streming%20App/Model/stream_category.dart';
import 'package:flutter_ui_design/Live%20Streming%20App/Screen/live_stream_screen.dart';
import 'package:flutter_ui_design/Live%20Streming%20App/Screen/profile_detail_screen.dart';
import 'package:iconsax/iconsax.dart';

class StremingAppHomeScreen extends StatefulWidget {
  const StremingAppHomeScreen({super.key});

  @override
  State<StremingAppHomeScreen> createState() => _StremingAppHomeScreenState();
}

class _StremingAppHomeScreenState extends State<StremingAppHomeScreen> {
  int _currentTab = 0;
  String _selectedCategory = 'Gaming';
  List<StreamItems> _filteredStreams = [];

  @override
  void initState() {
    super.initState();
    _filterStreams('Gaming');
  }

  void _filterStreams(String category) {
    setState(() {
      _selectedCategory = category;
      _filteredStreams = streamItems
          .where((e) => e.category.toLowerCase() == category.toLowerCase())
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            IndexedStack(
              index: _currentTab,
              children: [
                _HomeTab(
                  size: size,
                  selectedCategory: _selectedCategory,
                  filteredStreams: _filteredStreams,
                  onCategoryTap: _filterStreams,
                ),
                const _StatsTab(),
                const _MessagesTab(),
                const _ProfileTab(),
              ],
            ),
            // Bottom nav bar
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 80,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      color: Colors.black.withAlpha(80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _NavItem(
                            icon: Iconsax.home5,
                            isActive: _currentTab == 0,
                            onTap: () => setState(() => _currentTab = 0),
                          ),
                          _NavItem(
                            icon: Iconsax.chart,
                            isActive: _currentTab == 1,
                            onTap: () => setState(() => _currentTab = 1),
                          ),
                          const SizedBox(width: 56), // FAB space
                          _NavItem(
                            icon: Iconsax.message,
                            isActive: _currentTab == 2,
                            onTap: () => setState(() => _currentTab = 2),
                          ),
                          _NavItem(
                            icon: Icons.person_2_outlined,
                            isActive: _currentTab == 3,
                            onTap: () => setState(() => _currentTab = 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton(
          backgroundColor: Colors.purpleAccent,
          onPressed: () => _showGoLiveSheet(context),
          shape: const CircleBorder(),
          elevation: 6,
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
    );
  }

  void _showGoLiveSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _GoLiveSheet(),
    );
  }
}

// ── Nav Item ──────────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Icon(icon, color: isActive ? Colors.white : Colors.white54, size: 30),
          if (isActive)
            Positioned(
              bottom: -12,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.purpleAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Home Tab ──────────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  final Size size;
  final String selectedCategory;
  final List<StreamItems> filteredStreams;
  final ValueChanged<String> onCategoryTap;

  const _HomeTab({
    required this.size,
    required this.selectedCategory,
    required this.filteredStreams,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderBar(),
          const SizedBox(height: 24),
          _ProfileRow(size: size),
          const SizedBox(height: 20),
          // Categories header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Categories",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showViewAllCategories(context),
                  child: const Text(
                    "View All",
                    style: TextStyle(fontSize: 16, color: Colors.pinkAccent),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Category chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 15),
              itemCount: streamCategory.length,
              itemBuilder: (context, index) {
                final cat = streamCategory[index];
                final isSelected = selectedCategory == cat.title;
                return GestureDetector(
                  onTap: () => onCategoryTap(cat.title),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.purpleAccent : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(cat.icon, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          cat.title,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Stream grid
          if (filteredStreams.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: Text(
                  "No streams in this category",
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredStreams.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final item = filteredStreams[index];
                  return _StreamCard(item: item, size: size);
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showViewAllCategories(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "All Categories",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: streamCategory.map((cat) {
                final isSelected = selectedCategory == cat.title;
                return GestureDetector(
                  onTap: () {
                    onCategoryTap(cat.title);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.purpleAccent : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(cat.icon, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(cat.title, style: const TextStyle(color: Colors.white, fontSize: 15)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Header bar ────────────────────────────────────────────────────────────────
class _HeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "GoLive",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ),
          _iconButton(context, Icons.nightlight_outlined, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Dark mode is already on")),
            );
          }),
          const SizedBox(width: 12),
          _iconButton(context, Icons.notifications_outlined, () {
            showModalBottomSheet(
              context: context,
              backgroundColor: const Color(0xFF1A1A1A),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (_) => const _NotificationsSheet(),
            );
          }),
          const SizedBox(width: 12),
          _iconButton(context, Icons.search, () {
            showSearch(context: context, delegate: _StreamSearchDelegate());
          }),
        ],
      ),
    );
  }

  Widget _iconButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: kSecondarybgColor,
        child: Icon(icon, size: 24, color: Colors.white),
      ),
    );
  }
}

// ── Profile row (horizontal avatars) ─────────────────────────────────────────
class _ProfileRow extends StatelessWidget {
  final Size size;
  const _ProfileRow({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.15,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 10),
        itemCount: streamItems.length,
        itemBuilder: (context, index) {
          final item = streamItems[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileDetailScreen(stream: item)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: item.isLiveNow ? Colors.red : Colors.white38,
                            width: item.isLiveNow ? 3 : 1,
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: item.color),
                          child: Image.network(item.url, width: 52, height: 52, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.name.split(' ').first,
                        style: TextStyle(
                          color: item.isLiveNow ? Colors.white : Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (item.isLiveNow)
                    Positioned(
                      top: 0,
                      right: -12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Live",
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Stream Card ───────────────────────────────────────────────────────────────
class _StreamCard extends StatelessWidget {
  final StreamItems item;
  final Size size;
  const _StreamCard({required this.item, required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LiveStreamScreen(streamItems: item)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Hero(
                  tag: item.image,
                  child: Image.network(
                    item.image,
                    width: double.infinity,
                    height: size.height * 0.22,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Viewer count
              Positioned(
                left: 8,
                top: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Colors.black26,
                      child: Row(
                        children: [
                          const Icon(Icons.visibility_outlined, color: Colors.white, size: 14),
                          const SizedBox(width: 3),
                          Text(item.viewer, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Live badge
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("Live", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ),
              // Stream title
              Positioned(
                bottom: 8,
                left: 10,
                right: 8,
                child: Text(
                  item.streamTitle,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [
                    Shadow(blurRadius: 4, color: Colors.black87),
                  ]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // Info row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProfileDetailScreen(stream: item)),
                  ),
                  child: CircleAvatar(backgroundImage: NetworkImage(item.url), radius: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                      Text("${item.followers} Followers", style: const TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showStreamOptions(context, item),
                  child: const Icon(Icons.more_vert, color: Colors.white54, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showStreamOptions(BuildContext context, StreamItems item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _StreamOptionsSheet(item: item),
    );
  }
}

// ── Stream options sheet ──────────────────────────────────────────────────────
class _StreamOptionsSheet extends StatelessWidget {
  final StreamItems item;
  const _StreamOptionsSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.white),
            title: Text("View ${item.name}'s Profile", style: const TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileDetailScreen(stream: item)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_outlined, color: Colors.white),
            title: const Text("Share Stream", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Link copied!")));
            },
          ),
          ListTile(
            leading: const Icon(Icons.block_outlined, color: Colors.redAccent),
            title: const Text("Report Stream", style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Stream reported.")));
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// ── Go Live Sheet ─────────────────────────────────────────────────────────────
class _GoLiveSheet extends StatefulWidget {
  const _GoLiveSheet();

  @override
  State<_GoLiveSheet> createState() => _GoLiveSheetState();
}

class _GoLiveSheetState extends State<_GoLiveSheet> {
  String _selectedCategory = 'Gaming';
  final TextEditingController _titleCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      maxChildSize: 0.85,
      minChildSize: 0.4,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: ListView(
          controller: scrollCtrl,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade600, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Start a Live Stream", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Stream Title", style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "What are you streaming?",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.grey.shade800,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Category", style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: streamCategory.map((cat) {
                final isSelected = _selectedCategory == cat.title;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat.title),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.purpleAccent : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(cat.icon, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(cat.title, style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  if (_titleCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a stream title")),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("🔴 Going live: ${_titleCtrl.text.trim()}"),
                      backgroundColor: Colors.purpleAccent,
                    ),
                  );
                },
                child: const Text("Go Live 🔴", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Notifications Sheet ───────────────────────────────────────────────────────
class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet();

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _NotifData(avatar: streamItems[0].url, title: "${streamItems[0].name} went Live!", subtitle: "Tap to join now", time: "2m ago"),
      _NotifData(avatar: streamItems[1].url, title: "${streamItems[1].name} followed you", subtitle: "Check out their profile", time: "10m ago"),
      _NotifData(avatar: streamItems[2].url, title: "${streamItems[2].name} started streaming", subtitle: "Fun with followers is live", time: "1h ago"),
      _NotifData(avatar: streamItems[3].url, title: "New comment on your post", subtitle: "Someone liked your stream", time: "3h ago"),
    ];
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      maxChildSize: 0.85,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ListView(
          controller: ctrl,
          padding: const EdgeInsets.all(20),
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade600, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            const Text("Notifications", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...notifications.map((n) => ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(n.avatar)),
              title: Text(n.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: Text(n.subtitle, style: const TextStyle(color: Colors.white54)),
              trailing: Text(n.time, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              contentPadding: EdgeInsets.zero,
            )),
          ],
        ),
      ),
    );
  }
}

class _NotifData {
  final String avatar, title, subtitle, time;
  _NotifData({required this.avatar, required this.title, required this.subtitle, required this.time});
}

// ── Search Delegate ───────────────────────────────────────────────────────────
class _StreamSearchDelegate extends SearchDelegate<StreamItems?> {
  @override
  String get searchFieldLabel => "Search streams or creators...";

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1A1A1A)),
      inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget buildLeading(BuildContext context) =>
    IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final results = query.isEmpty
        ? streamItems
        : streamItems.where((s) =>
            s.name.toLowerCase().contains(query.toLowerCase()) ||
            s.streamTitle.toLowerCase().contains(query.toLowerCase()) ||
            s.category.toLowerCase().contains(query.toLowerCase())).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No results found", style: TextStyle(color: Colors.white54)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: results.length,
      itemBuilder: (_, i) {
        final item = results[i];
        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(item.url), backgroundColor: item.color),
          title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          subtitle: Text("${item.streamTitle} · ${item.category}", style: const TextStyle(color: Colors.white54)),
          trailing: item.isLiveNow
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                  child: const Text("LIVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                )
              : null,
          onTap: () {
            close(context, item);
            Navigator.push(context, MaterialPageRoute(builder: (_) => LiveStreamScreen(streamItems: item)));
          },
        );
      },
    );
  }
}

// ── Stats Tab ─────────────────────────────────────────────────────────────────
class _StatsTab extends StatelessWidget {
  const _StatsTab();

  @override
  Widget build(BuildContext context) {
    final totalViewers = streamItems.fold<int>(0, (sum, s) {
      final v = s.viewer.toLowerCase().contains('k')
          ? (double.tryParse(s.viewer.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0) * 1000
          : double.tryParse(s.viewer.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      return sum + v.toInt();
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Your Stats", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              _StatCard(title: "Total Viewers", value: _fmt(totalViewers), icon: Icons.visibility_outlined, color: Colors.purpleAccent),
              const SizedBox(width: 12),
              _StatCard(title: "Live Streams", value: streamItems.where((s) => s.isLiveNow).length.toString(), icon: Icons.videocam_outlined, color: Colors.redAccent),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatCard(title: "Creators", value: streamItems.length.toString(), icon: Icons.people_outline, color: Colors.blueAccent),
              const SizedBox(width: 12),
              _StatCard(title: "Categories", value: streamCategory.length.toString(), icon: Icons.category_outlined, color: Colors.orangeAccent),
            ],
          ),
          const SizedBox(height: 28),
          const Text("Top Streams", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          ...streamItems.take(5).map((item) => ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(item.url), backgroundColor: item.color),
            title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: Text(item.streamTitle, style: const TextStyle(color: Colors.white54)),
            trailing: Text(item.viewer, style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveStreamScreen(streamItems: item))),
          )),
        ],
      ),
    );
  }

  String _fmt(int n) {
    if (n >= 1000000) return "${(n / 1000000).toStringAsFixed(1)}M";
    if (n >= 1000) return "${(n / 1000).toStringAsFixed(1)}k";
    return n.toString();
  }
}

class _StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ── Messages Tab ──────────────────────────────────────────────────────────────
class _MessagesTab extends StatelessWidget {
  const _MessagesTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Messages", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(14)),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.white38),
                SizedBox(width: 10),
                Expanded(child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search messages...",
                    hintStyle: TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...streamItems.take(6).map((item) => _MessageTile(item: item)),
        ],
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  final StreamItems item;
  const _MessageTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openChat(context, item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: Stack(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(item.url), backgroundColor: item.color, radius: 26),
              if (item.isLiveNow)
                Positioned(
                  right: 0, bottom: 0,
                  child: Container(
                    width: 14, height: 14,
                    decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2)),
                  ),
                ),
            ],
          ),
          title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          subtitle: Text(item.streamTitle, style: const TextStyle(color: Colors.white54), overflow: TextOverflow.ellipsis),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(item.followers, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              if (item.isLiveNow)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.red.withAlpha(60), borderRadius: BorderRadius.circular(6)),
                  child: const Text("Live", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openChat(BuildContext context, StreamItems item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _ChatScreen(item: item)),
    );
  }
}

class _ChatScreen extends StatefulWidget {
  final StreamItems item;
  const _ChatScreen({required this.item});

  @override
  State<_ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<_ChatScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {"from": "them", "text": "Hey! Great stream!"},
    {"from": "them", "text": "When is your next live?"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.item.url), backgroundColor: widget.item.color, radius: 18),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.item.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                Text(widget.item.isLiveNow ? "🔴 Live now" : "Offline", style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          if (widget.item.isLiveNow)
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveStreamScreen(streamItems: widget.item))),
              child: const Text("Watch Live", style: TextStyle(color: Colors.purpleAccent)),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[i];
                final isMe = msg["from"] == "me";
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.purpleAccent : const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(msg["text"]!, style: const TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 12, left: 12, right: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(30)),
                    child: TextField(
                      controller: _ctrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(hintText: "Message...", hintStyle: TextStyle(color: Colors.white38), border: InputBorder.none),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    if (_ctrl.text.trim().isEmpty) return;
                    setState(() {
                      _messages.add({"from": "me", "text": _ctrl.text.trim()});
                      _ctrl.clear();
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.purpleAccent,
                    child: Transform.rotate(angle: 5.5, child: const Icon(Icons.send_outlined, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile Tab ───────────────────────────────────────────────────────────────
class _ProfileTab extends StatefulWidget {
  const _ProfileTab();

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  // Use the first stream item as "me"
  final StreamItems me = streamItems[0];
  bool _notificationsOn = true;
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
      child: Column(
        children: [
          // Cover + avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(me.coverImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                  child: CircleAvatar(backgroundImage: NetworkImage(me.url), radius: 48),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(me.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        Text("@${me.name.toLowerCase().replaceAll(' ', '_')}", style: const TextStyle(color: Colors.white54)),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Edit profile coming soon"))),
                      child: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(me.description, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.left),
                const SizedBox(height: 20),
                // Stats
                Row(
                  children: [
                    _ProfileStat(label: "Posts", value: me.post),
                    _divider(),
                    _ProfileStat(label: "Following", value: me.following),
                    _divider(),
                    _ProfileStat(label: "Followers", value: me.followers),
                  ],
                ),
                const SizedBox(height: 28),
                // Settings
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: "Notifications",
                  trailing: Switch(
                    value: _notificationsOn,
                    activeColor: Colors.purpleAccent,
                    onChanged: (v) => setState(() => _notificationsOn = v),
                  ),
                ),
                _SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: "Dark Mode",
                  trailing: Switch(
                    value: _darkMode,
                    activeColor: Colors.purpleAccent,
                    onChanged: (v) => setState(() => _darkMode = v),
                  ),
                ),
                _SettingsTile(
                  icon: Icons.help_outline,
                  title: "Help & Support",
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening Help Center..."))),
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening Privacy Policy..."))),
                ),
                _SettingsTile(
                  icon: Icons.logout,
                  title: "Log Out",
                  color: Colors.redAccent,
                  onTap: () => _confirmLogout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 40, color: Colors.grey.shade800, margin: const EdgeInsets.symmetric(horizontal: 12));

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text("Log Out?", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure you want to log out?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.white54))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Logged out")));
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label, value;
  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? color;
  const _SettingsTile({required this.icon, required this.title, this.trailing, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2),
      leading: Icon(icon, color: color ?? Colors.white70),
      title: Text(title, style: TextStyle(color: color ?? Colors.white, fontWeight: FontWeight.w500)),
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, color: Colors.white38) : null),
      onTap: onTap,
    );
  }
}
