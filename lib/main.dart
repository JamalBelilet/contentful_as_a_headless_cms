import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'contentful_repository.dart';

void main() {
  runApp(const WpAsAHeadlessCmsApp());
}

class WpAsAHeadlessCmsApp extends StatelessWidget {
  const WpAsAHeadlessCmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'Contentful as a headless cms',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.notoSansGeorgianTextTheme(textTheme),
      ),
      home: const ProductsPage(title: 'Contentful as a Headless CMS'),
    );
  }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, required this.title});

  final String title;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Product>> futureProducts = getProducts();
  final List<Product> selectedProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Text(
          'Basket \n${selectedProducts.map((p) => p.name).join(', ')}',
          style: Theme.of(context).textTheme.labelSmall,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];

                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedProducts.add(product);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    color: index % 2 == 1
                        ? Theme.of(context).colorScheme.surfaceVariant
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          "\$${product.price}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        Image.network(
                          product.featuredProductImage['url'],
                          fit: BoxFit.cover,
                          height: 120,
                          width: double.infinity,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          product.description,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                '❗️ ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
