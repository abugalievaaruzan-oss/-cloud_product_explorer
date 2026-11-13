
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product.dart';
import '../widgets/photo_carousel.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  static const Color ivory = Color(0xFFF8F5EF);
  static const Color espresso = Color(0xFF38342F);
  static const Color taupe = Color(0xFFB9A58D);

  void _showShareSheet(BuildContext context) {
    final deepLink = 'narxoz://store/product/${product.id}';

    showModalBottomSheet(
      context: context,
      backgroundColor: ivory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SHARE THIS ITEM',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 2,
                  color: taupe,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Something worth sharing.',
                style: TextStyle(
                  fontSize: 24,
                  color: espresso,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(
                  deepLink,
                  style: const TextStyle(
                    color: espresso,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: deepLink),
                    );

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Link copied successfully!'),
                      ),
                    );

                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text('COPY LINK'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: espresso,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivory,

      appBar: AppBar(
        backgroundColor: ivory,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: espresso,
        ),
        centerTitle: true,
        title: const Text(
          'THE COLLECTION',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 2,
            color: espresso,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showShareSheet(context),
            icon: const Icon(Icons.share_outlined),
            color: espresso,
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            Hero(
              tag: 'product_image_${product.id}',
              child: PhotoCarousel(product: product),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      letterSpacing: 2,
                      color: taupe,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 27,
                      height: 1.3,
                      fontWeight: FontWeight.w300,
                      color: espresso,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 18,
                        color: Color(0xFFB99B65),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${product.rating} / 5.0',
                        style: const TextStyle(
                          fontSize: 13,
                          color: espresso,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${product.reviewCount} reviews',
                        style: const TextStyle(
                          fontSize: 12,
                          color: taupe,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: espresso,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Divider(color: Color(0xFFE5DED4)),

                  const SizedBox(height: 22),

                  const Text(
                    'ABOUT THE PRODUCT',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: espresso,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.8,
                      color: Color(0xFF817568),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Divider(color: Color(0xFFE5DED4)),

                  const SizedBox(height: 20),

                  const Row(
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        color: taupe,
                        size: 21,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Selected with care',
                        style: TextStyle(
                          fontSize: 12,
                          color: espresso,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        color: ivory,
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 18),
        child: SafeArea(
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product added to cart!'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: espresso,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'ADD TO CART',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
