import 'package:book_app/core/constants/colors.dart';
import 'package:book_app/features/auth/presentation/viewmodels/auth_provider.dart';
import 'package:book_app/features/books/domain/entities/book.dart';
import 'package:book_app/features/books/presentation/viewmodels/book_provider.dart';
import 'package:book_app/features/books/presentation/widgets/book_fan.dart';
import 'package:book_app/features/books/presentation/widgets/book_list.dart';
import 'package:book_app/features/home/presentation/widgets/welcome_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
        final startedBooksAsync = ref.watch(startedBooksProvider(user.id));

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
              error: (err, _) => _buildScaffold(fanBooks, []),
              data: (startedBooks) => _buildScaffold(fanBooks, startedBooks),
            );
          },
        );
      },
    );
  }

  Widget _buildScaffold(List<Book> fanBooks, List<Book> startedBooks) {
    final hasStartedBooks = startedBooks.isNotEmpty;
    final sectionBooks = hasStartedBooks ? startedBooks : fanBooks;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WelcomeHeader(),
            const SizedBox(height: 24),
            BookFan(books: fanBooks),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Text(
                hasStartedBooks ? 'Continue reading' : 'Start reading',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ).copyWith(color: AppColors.darkPurple),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Divider(
                thickness: 1,
                height: 4,
                color: AppColors.darkPurple.withAlpha(51),
              ),
            ),
            BookList(books: sectionBooks),
          ],
        ),
      ),
    );
  }
}
