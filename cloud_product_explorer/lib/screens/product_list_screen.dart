
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  bool isLoading = true;
  String? errorMessage;
  String selectedCategory = 'All';

  static const Color ivory = Color(0xFFF8F5EF);
  static const Color espresso = Color(0xFF38342F);
  static const Color taupe = Color(0xFFB9A58D);

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await ProductService.fetchProducts();

      if (!mounted) return;

      setState(() {
        products = result;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage =
            error.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  List<String> get categories => [
        'All',
        ...products.map((p) => p.category).toSet(),
      ];

  List<Product> get filteredProducts {
    if (selectedCategory == 'All') return products;

    return products
        .where((p) => p.category == selectedCategory)
        .toList();
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'C L O U D   S T O R E',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.8,
                fontWeight: FontWeight.bold,
                color: espresso,
              ),
            ),
            const Icon(
              Icons.shopping_bag_outlined,
              color: espresso,
            ),
          ],
        ),

        const SizedBox(height: 35),

        const Text(
          'A world of',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w300,
            color: espresso,
          ),
        ),

        const Text(
          'beautiful finds.',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
            color: espresso,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Thoughtfully selected pieces for everyday living.',
          style: TextStyle(
            fontSize: 13,
            color: taupe,
          ),
        ),

        const SizedBox(height: 35),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'THE COLLECTION',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                color: espresso,
              ),
            ),
            Text(
              '${filteredProducts.length} ITEMS',
              style: const TextStyle(
                fontSize: 10,
                letterSpacing: 1,
                color: taupe,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: 9),
            itemBuilder: (context, index) {
              final category = categories[index];
              final selected = selectedCategory == category;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = category;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? espresso : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: selected
                          ? espresso
                          : const Color(0xFFDCD2C5),
                    ),
                  ),
                  child: Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 0.8,
                      color: selected ? Colors.white : espresso,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 28),
      ],
    );
  }

  Widget buildProductGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final columns = width >= 950
            ? 4
            : width >= 600
                ? 3
                : 2;

        final ratio = columns == 4
            ? 0.76
            : columns == 3
                ? 0.70
                : 0.62;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 18,
            mainAxisSpacing: 28,
            childAspectRatio: ratio,
          ),
          itemBuilder: (context, index) {
            final product = filteredProducts[index];

            return ProductCard(
              product: product,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(
                      product: product,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget buildProductFeed() {
    return RefreshIndicator(
      color: espresso,
      onRefresh: loadProducts,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeader(),
                  buildProductGrid(),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 55,
              color: taupe,
            ),
            const SizedBox(height: 20),
            const Text(
              'Connection unavailable',
              style: TextStyle(
                fontSize: 22,
                color: espresso,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage ?? 'Check your internet connection.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loadProducts,
              child: const Text('RETRY CONNECTION'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivory,
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: espresso,
                ),
              )
            : errorMessage != null
                ? buildError()
                : buildProductFeed(),
      ),
    );
  }
}
