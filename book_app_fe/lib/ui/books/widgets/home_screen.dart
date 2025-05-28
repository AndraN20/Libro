import 'package:book_app/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:book_app/domain/models/book.dart';
import 'package:book_app/domain/models/user.dart';
import 'package:book_app/providers/auth_provider.dart';
import 'package:book_app/providers/book_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static const _navItems = [
    {
      'label': 'Home',
      'active': 'assets/icons/home_color.svg',
      'inactive': 'assets/icons/home_grey.svg',
    },
    {
      'label': 'Library',
      'active': 'assets/icons/library_color.svg',
      'inactive': 'assets/icons/library_grey.svg',
    },
    {
      'label': 'Search',
      'active': 'assets/icons/search_color.svg',
      'inactive': 'assets/icons/search_grey.svg',
    },
    {
      'label': 'Profile',
      'active': 'assets/icons/profile_color.svg',
      'inactive': 'assets/icons/profile_grey.svg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(currentUserProvider);

    return authAsync.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (err, _) => Scaffold(body: Center(child: Text('Auth error: \$err'))),
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Please log in to see your books.')),
          );
        }
        return _buildScaffold(context, user);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, User user) {
    final userBooksAsync = ref.watch(userBooksProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 40.0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ).copyWith(color: AppColors.darkBlue1),
              ),
              const SizedBox(height: 8),
              SvgPicture.asset('ui/assets/home_screen_welcome.svg'),
            ],
          ),
        ),
      ),
      body: userBooksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) {
          return _buildBody(context, hasBooks: false, books: null);
        },
        data: (userBooks) {
          final hasBooks = userBooks.isNotEmpty;
          return _buildBody(
            context,
            hasBooks: hasBooks,
            books: hasBooks ? userBooks : null,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items:
            _navItems.map((item) {
              final isActive = _navItems.indexOf(item) == _selectedIndex;
              final assetPath = isActive ? item['active']! : item['inactive']!;
              return BottomNavigationBarItem(
                icon: SvgPicture.asset(assetPath, width: 24, height: 24),
                label: item['label'],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required bool hasBooks,
    List<Book>? books,
  }) {
    final future =
        hasBooks
            ? Future<List<Book>>.value(books!)
            : ref.read(libraryBooksProvider.future);

    return FutureBuilder<List<Book>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final list = snapshot.data ?? [];
        if (list.isEmpty) {
          return const Center(child: Text('No books available'));
        }
        // Take 5 random books for the vertical list
        final randomBooks = List<Book>.from(list)..shuffle();
        final displayBooks = randomBooks.take(5).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCoverFan(list),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  hasBooks ? 'Continue reading' : 'Explore our library',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ).copyWith(color: AppColors.darkBlue1),
                ),
              ),
              const Divider(thickness: 1, height: 16),
              const SizedBox(height: 12),
              // Vertical list of cards
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayBooks.length,
                itemBuilder: (_, i) {
                  final book = displayBooks[i];
                  final coverData = book.decodedCover;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    width: 370,
                    height: 170,
                    decoration: BoxDecoration(
                      color: const Color(0xFF747474),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child:
                              coverData != null
                                  ? Image.memory(
                                    coverData,
                                    width: 77,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                  : const SizedBox(
                                    width: 77,
                                    height: 120,
                                    child: Icon(Icons.book),
                                  ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.author,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, right: 8),
                          child: SvgPicture.asset(
                            'ui/assets/play_button.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCoverFan(List<Book> books) {
    final covers = books.take(3).toList();
    // Order so that center item is drawn last (on top)
    final order = [0, 2, 1];
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children:
            order.map((i) {
              final book = covers[i];
              final coverData = book.decodedCover;
              final angle = (i - 1) * 0.26;
              final offset = (i - 1) * 30.0;
              return Positioned(
                left: MediaQuery.of(context).size.width / 2 - 60 + offset,
                child: Transform.rotate(
                  angle: angle,
                  child: Card(
                    elevation: 4,
                    child:
                        coverData != null
                            ? Image.memory(
                              coverData,
                              width: 120,
                              height: 160,
                              fit: BoxFit.cover,
                            )
                            : const SizedBox(
                              width: 120,
                              height: 160,
                              child: Icon(Icons.book, size: 48),
                            ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
