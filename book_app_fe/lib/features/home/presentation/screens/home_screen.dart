import 'package:book_app/core/constants/colors.dart';
import 'package:book_app/features/auth/presentation/viewmodels/auth_provider.dart';
import 'package:book_app/features/books/domain/models/book.dart';
import 'package:book_app/features/books/presentation/viewmodels/book_provider.dart';
import 'package:book_app/features/books/presentation/widgets/book_fan.dart';
import 'package:book_app/features/books/presentation/widgets/book_list.dart';
import 'package:book_app/features/home/presentation/widgets/welcome_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_app/core/providers/route_observer_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final observer = ref.read(routeObserverProvider);
    observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    final observer = ref.read(routeObserverProvider);
    observer.unsubscribe(this);
    super.dispose();
  }

  // Se cheamă când revii din BookDetails/Reader etc
  @override
  void didPopNext() async {
    ref.invalidate(startedBooksProvider);
    ref.invalidate(booksProvider);
    await Future.delayed(const Duration(milliseconds: 10));
    setState(() {});
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(currentUserProvider);

    return authAsync.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (err, _) => Scaffold(body: Center(child: Text('Auth error: $err'))),
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Please log in to see your books.')),
          );
        }

        final booksAsync = ref.watch(booksProvider);
        final startedBooksAsync = ref.watch(startedBooksProvider);

        return booksAsync.when(
          loading:
              () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
          error:
              (err, _) => Scaffold(
                body: Center(child: Text('Error loading books: $err')),
              ),
          data: (allBooks) {
            final fanBooks = (allBooks.toList()..shuffle()).take(3).toList();

            return startedBooksAsync.when(
              loading:
                  () => const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
              error: (err, _) {
                print(">> startedBooksAsync error: $err");
                return _buildScaffold(fanBooks, []);
              },
              data: (startedBooks) {
                print(">> startedBooks.length = ${startedBooks.length}");
                return _buildScaffold(fanBooks, startedBooks);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildScaffold(List<Book> fanBooks, List<Book> startedBooks) {
    final hasStartedBooks = startedBooks.isNotEmpty;
    final sectionBooks = hasStartedBooks ? startedBooks : fanBooks;

    print(
      ">> buildScaffold: hasStartedBooks=$hasStartedBooks, sectionBooks=${sectionBooks.length}",
    );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(startedBooksProvider);
          ref.invalidate(booksProvider);
          await Future.delayed(const Duration(milliseconds: 5));
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeHeader(),
              const SizedBox(height: 24),
              BookFan(books: fanBooks),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      hasStartedBooks ? 'Continue reading' : 'Start reading',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ).copyWith(color: AppColors.darkPurple),
                    ),
                    if (hasStartedBooks) ...[
                      const SizedBox(width: 10),
                      // Bulina gri
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.lightPurple,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Numărul de cărți
                      Text(
                        '${startedBooks.length} ${startedBooks.length == 1 ? 'book' : 'books'}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.lightPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Divider(
                  thickness: 1,
                  height: 1,
                  color: AppColors.darkPurple.withAlpha(51),
                ),
              ),
              BookList(books: sectionBooks),
            ],
          ),
        ),
      ),
    );
  }
}
