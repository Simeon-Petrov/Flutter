class Book {
  String title;
  String author;
  double price;

  Book(this.title, this.author, this.price);

  void displayDetails() {
    print("Title: $title");
    print("Author: $author");
    print("Price: \$${price.toStringAsFixed(2)}");
  }
}

void main() {
  var myBook = Book("Harry Poter", "J.K.Rowling", 29.99);

  myBook.displayDetails();
}
