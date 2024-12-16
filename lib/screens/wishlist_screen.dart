import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import 'book_details_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wishlist',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Clear Wishlist', style: GoogleFonts.poppins()),
                  content: Text(
                    'Are you sure you want to clear your wishlist?',
                    style: GoogleFonts.poppins(),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Cancel', style: GoogleFonts.poppins()),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    TextButton(
                      child: Text('Clear', style: GoogleFonts.poppins()),
                      onPressed: () {
                        Provider.of<WishlistProvider>(context, listen: false).clear();
                        Navigator.of(ctx).pop();
                        Fluttertoast.showToast(
                          msg: 'Wishlist cleared',
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlist, child) {
          if (wishlist.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some books to get started',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: wishlist.items.length,
            itemBuilder: (context, index) {
              final book = wishlist.items.values.elementAt(index);
              return WishlistItem(book: book);
            },
          );
        },
      ),
    );
  }
}

class WishlistItem extends StatelessWidget {
  final Book book;

  const WishlistItem({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailsScreen(book: book),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  child: Image.asset(
                    book.imageAssetPath,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<WishlistProvider>(
                    builder: (context, wishlist, _) {
                      return IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          wishlist.toggleWishlist(book);
                          Fluttertoast.showToast(
                            msg: '${book.title} removed from wishlist',
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${book.price.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Consumer<CartProvider>(
                        builder: (context, cart, _) {
                          final isInCart = cart.items.containsKey(book.id);
                          return IconButton(
                            icon: Icon(
                              isInCart ? Icons.shopping_cart : Icons.add_shopping_cart_outlined,
                              color: isInCart ? Colors.green : Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              if (!isInCart) {
                                cart.addItem(book);
                                Fluttertoast.showToast(
                                  msg: '${book.title} added to cart',
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                );
                              } else {
                                Navigator.pushNamed(context, '/cart');
                              }
                            },
                            iconSize: 20,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
