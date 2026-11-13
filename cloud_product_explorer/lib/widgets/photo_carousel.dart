
import 'package:flutter/material.dart';
import '../models/product.dart';

class PhotoCarousel extends StatefulWidget {
  final Product product;

  const PhotoCarousel({
    super.key,
    required this.product,
  });

  @override
  State<PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  late final PageController _pageController;

  int _currentPage = 0;

  static const Color ivory = Color(0xFFF8F5EF);
  static const Color espresso = Color(0xFF38342F);
  static const Color taupe = Color(0xFFB9A58D);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fake Store API provides one original image per product.
    // Three pages demonstrate the required carousel interaction.
    final images = List<String>.filled(
      3,
      widget.product.imageUrl,
    );

    return Column(
      children: [
        Container(
          height: 350,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: ivory,
            borderRadius: BorderRadius.circular(18),
          ),
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(32),
                child: Image.network(
                  images[index],
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;

                    return const Center(
                      child: CircularProgressIndicator(
                        color: taupe,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 45,
                        color: taupe,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 22),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (_currentPage + 1).toString().padLeft(2, '0'),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: espresso,
              ),
            ),

            const SizedBox(width: 12),

            ...List.generate(
              images.length,
              (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 22 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? espresso
                        : const Color(0xFFDCD2C5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),

            const SizedBox(width: 12),

            Text(
              images.length.toString().padLeft(2, '0'),
              style: const TextStyle(
                fontSize: 11,
                color: taupe,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
