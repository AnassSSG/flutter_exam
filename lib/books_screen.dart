import 'package:flutter/material.dart';
import 'Model/book.dart';
import 'book_details_screen.dart';

class BooksScreen extends StatefulWidget {
  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  List<Book> books = [];
  List<Book> filteredBooks = [];
  TextEditingController searchController = TextEditingController();

  void initState() {
    super.initState();
    books = [
      Book(
        title: 'Book 1',
        author: 'Author 1',
        imageUrl: 'https://img.freepik.com/free-vector/text-books-library-isolated-icon_24877-83372.jpg',
        // URL de l'image
        description: 'Description of Book 1',
      ),
      Book(
        title: 'Book 2',
        author: 'Author 2',
        imageUrl: 'https://img.freepik.com/free-vector/text-books-library-isolated-icon_24877-83372.jpg',
        // URL de l'image
        description: 'Description of Book 2',
      ),
      Book(
        title: 'Book 3',
        author: 'Author 3',
        imageUrl: 'https://img.freepik.com/free-vector/text-books-library-isolated-icon_24877-83372.jpg',
        // URL de l'image
        description: 'Description of Book 3',
      ),
      Book(
        title: 'Book 4',
        author: 'Author 4',
        imageUrl: 'https://img.freepik.com/free-vector/text-books-library-isolated-icon_24877-83372.jpg',
        // URL de l'image
        description: 'Description of Book 4',
      ),
      Book(
        title: 'Book 5',
        author: 'Author 5',
        imageUrl: 'https://img.freepik.com/free-vector/text-books-library-isolated-icon_24877-83372.jpg',
        // URL de l'image
        description: 'Description of Book 5',
      ),
      Book(
        title: 'Book 6',
        author: 'Author 6',
        imageUrl: 'https://img.freepik.com/free-vector/text-books-library-isolated-icon_24877-83372.jpg',
        // URL de l'image
        description: 'Description of Book 6',
      ),
    ];
    filteredBooks.addAll(books);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livres'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Rechercher',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                filteredBooks = books.where((book) =>
                    book.title.toLowerCase().contains(value.toLowerCase())).toList();
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                final book = filteredBooks[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailsScreen(book: book),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.network(
                            book.imageUrl,
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  book.title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  book.author,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteBook(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBookDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _deleteBook(int index) {
    setState(() {
      filteredBooks.removeAt(index);
    });
  }


  void _showAddBookDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController authorController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un livre'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Titre'),
                ),
                TextField(
                  controller: authorController,
                  decoration: InputDecoration(labelText: 'Auteur'),
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: InputDecoration(labelText: 'URL de l\'image'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                final newBook = Book(
                  title: titleController.text,
                  author: authorController.text,
                  imageUrl: imageUrlController.text,
                  description: descriptionController.text,
                );
                setState(() {
                  books.add(newBook);
                  filteredBooks.add(newBook); // Add to filteredBooks as well
                });
                Navigator.of(context).pop();
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }
}

class BookSearchDelegate extends SearchDelegate<Book> {
  final List<Book> books;

  BookSearchDelegate(this.books);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        final book = books.isNotEmpty ? books.first : null;
        close(context, book!);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = books.where((book) => book.title.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            close(context, book);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = books.where((book) => book.title.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            close(context, book);
          },
        );
      },
    );
  }
}