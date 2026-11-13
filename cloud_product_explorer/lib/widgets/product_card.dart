
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  static const Color ivory = Color(0xFFF8F5EF);
  static const Color espresso = Color(0xFF38342F);
  static const Color taupe = Color(0xFFB9A58D);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ivory,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Hero(
                tag: 'product_image_${product.id}',
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.image_outlined,
                      size: 40,
                      color: taupe,
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Category
          Text(
            product.category.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              letterSpacing: 1.5,
              color: taupe,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          // Product name
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.35,
              color: espresso,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          // Rating and reviews
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFB99B65),
                size: 15,
              ),
              const SizedBox(width: 4),
              Text(
                '${product.rating} (${product.reviewCount})',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          // Price
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: espresso,
            ),
          ),
        ],
      ),
    );
  }
}
