class Menu {
  String name;
  String imageURL;
  double price;
  String category;

  Menu({
    required this.name,
    required this.imageURL,
    required this.price,
    required this.category,
  });

  Menu.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        imageURL = json['image_url'],
        price = json['price'],
        category = json['category'];

  // Map<String, dynamic> toJson() => {
  //       'name': name,
  //       'imageURL': imageURL,
  //       'price': price,
  //       'category': category,
  //     };

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  Menu copyWith({
    String? name,
    String? imageURL,
    double? price,
    String? category,
  }) {
    return Menu(
      name: name ?? this.name,
      imageURL: imageURL ?? this.imageURL,
      price: price ?? this.price,
      category: category ?? this.category,
    );
  }
}
