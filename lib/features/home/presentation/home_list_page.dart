import 'package:flutter/material.dart';
import 'home_controller.dart';

class HomeListPage extends StatefulWidget {
  const HomeListPage({super.key});

  @override
  State<HomeListPage> createState() => _HomeListPageState();
}

class _HomeListPageState extends State<HomeListPage> {
  final HomeController _controller = HomeController();

  @override
  void initState() {
    super.initState();
    _controller.loadTrending();
    _controller.loadNews();
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===================== BODY =====================
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 425),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNavbar(),

                  // 🔍 SEARCH
                  _buildSearch(),

                  const SizedBox(height: 24),

                  // 🔥 TRENDING
                  _buildSectionHeader(title: 'Trending'),
                  const SizedBox(height: 12),
                  _buildTrendingCard(),

                  const SizedBox(height: 24),

                  // 📰 LATEST
                  _buildSectionHeader(title: 'Latest'),
                  const SizedBox(height: 12),
                  _buildCategoryTabs(),

                  const SizedBox(height: 16),
                  _buildNewsList(),
                ],
              ),
            ),
          ),
        ),
      ),

      // ===================== BOTTOM NAV =====================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ===================== WIDGETS =====================
  Widget _buildNavbar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.tune, color: Colors.grey.shade600),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See all',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color.fromRGBO(78, 75, 102, 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingCard() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        if (_controller.isLoadingTrending) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Column(
          children: _controller.trending.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildNewsTrendingCard(
                image: item.imageUrl,
                category: item.category,
                title: item.title,
                source: item.source,
                time: _timeAgo(item.publishedAt),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildNewsTrendingCard({
    required String image,
    required String category,
    required String title,
    required String source,
    required String time,
  }) {
    return Container(
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
              bottom: Radius.circular(8),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.black45,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No Image',
                          style: TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            category,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.3,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'BBC',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Text(
                source,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(width: 8),

              const Icon(Icons.access_time, size: 14, color: Colors.black45),

              const SizedBox(width: 4),

              Text(
                time,
                style: const TextStyle(fontSize: 13, color: Colors.black45),
              ),

              const Spacer(),

              const Icon(Icons.more_horiz, color: Colors.black45),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = [
      'All',
      'Sports',
      'Politics',
      'Business',
      'Health',
      'Travel',
      'Science',
    ];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, index) {
          final selected = index == 0;
          return Text(
            categories[index],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected ? Colors.blue : Colors.grey,
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewsList() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        if (_controller.isLoadingNews) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Column(
          children: _controller.news.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildNewsTile(
                image: item.imageUrl,
                category: item.category,
                title: item.title,
                source: item.source,
                time: _timeAgo(item.publishedAt),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildNewsTile({
    required String image,
    required String category,
    required String title,
    required String source,
    required String time,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.image_not_supported,
                        size: 30,
                        color: Colors.black45,
                      ),
                      SizedBox(height: 8),
                      Text('No Image', style: TextStyle(color: Colors.black45)),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(source),
                    const SizedBox(width: 12),
                    const Icon(Icons.schedule, size: 14),
                    const SizedBox(width: 4),
                    Text(time),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
