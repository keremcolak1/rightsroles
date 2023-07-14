class ShopItem {
  final String name;
  final String description;
  final String image;
  final double price;

  ShopItem({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
  });
}

class ShopBackend {
  static final List<ShopItem> items = [
    ShopItem(
      name: 'Product 1', //Seatheating, Klima, Lenkradheizung, Position,
      description: 'This is a description for Product 1.',
      image: 'assets/images/placeholder-image.png',
      price: 20.0,
    ),
    ShopItem(
      name: 'Product 2',
      description: 'This is a description for Product 2.',
      image: 'assets/images/placeholder-image.png',
      price: 30.0,
    ),
    ShopItem(
      name: 'Product 3',
      description: 'This is a description for Product 3.',
      image: 'assets/images/placeholder-image.png',
      price: 25.0,
    ),
    ShopItem(
      name: 'Product 4',
      description: 'This is a description for Product 4.',
      image: 'assets/images/placeholder-image.png',
      price: 15.0,
    ),
    ShopItem(
      name: 'Product 5',
      description: 'This is a description for Product 5.',
      image: 'assets/images/placeholder-image.png',
      price: 40.0,
    ),
    ShopItem(
      name: 'Product 6',
      description: 'This is a description for Product 6.',
      image: 'assets/images/placeholder-image.png',
      price: 50.0,
    ),
    ShopItem(
      name: 'Product 7',
      description: 'This is a description for Product 7.',
      image: 'assets/images/placeholder-image.png',
      price: 35.0,
    ),
    ShopItem(
      name: 'Product 8',
      description: 'This is a description for Product 8.',
      image: 'assets/images/placeholder-image.png',
      price: 45.0,
    ),
  ];

  static getItems() {
    return items;
  }

}