import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book List Demo',
      home: BooksListScreen(),
    );
  }
}

class BooksListScreen extends StatefulWidget {
  @override
  _BooksListScreenState createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  List books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  void fetchBooks() async {
    const url = 'http://nael-mobile-project-book.free.nf/index.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the plain text response
      final lines = response.body.split('\n');
      final parsedBooks =
          lines.where((line) => line.trim().isNotEmpty).map((line) {
        final fields = line.split('|');
        return {
          'id': fields[0],
          'title': fields[1],
          'author': fields[2],
          'subject': fields[3],
          'availability': fields[4],
        };
      }).toList();

      setState(() {
        books = parsedBooks;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Books'),
      ),
      body: books.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(book['title'] ?? 'No Title'),
                  subtitle: Text('Author: ${book['author'] ?? 'Unknown'}'),
                  trailing: Text(book['availability'] == "1"
                      ? "Available"
                      : "Not Available"),
                );
              },
            ),
    );
  }
}
