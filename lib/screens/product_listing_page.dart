import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/product_horizontal_card.dart';
import 'product_variants_page.dart';
import '../models/cart_model.dart';

class ProductListingPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const ProductListingPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductListingPage> createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  List products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future fetchProducts() async {
    const String url =
        "https://darkslategrey-chicken-274271.hostingersite.com/api/get_products.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "category_id": widget.categoryId,
        }),
      );

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        products = data["products"];
        
        // Transform to Bakery products if category is "Bakery and Bread"
        if (widget.categoryName.toLowerCase().contains("bakery") || 
            widget.categoryName.toLowerCase().contains("bread")) {
          final bakeryNames = [
            "Fresh White Bread",
            "Brown Bread", 
            "Milk Bread",
            "Soft Buns (4 Pcs)",
            "Pav Bread (8 Pcs)",
            "Garlic Bread",
          ];
          final bakeryImages = [
            "https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?w=400&h=300&fit=crop",
            "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=300&fit=crop",
            "https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400&h=300&fit=crop",
            "https://images.unsplash.com/photo-1621236378699-8597fab6a5b1?w=400&h=300&fit=crop",
            "https://images.unsplash.com/photo-1601058268499-e5268c56b584?w=400&h=300&fit=crop",
            "https://images.unsplash.com/photo-1573140247632-f8fd74997d5c?w=400&h=300&fit=crop",
          ];
          for (int i = 0; i < products.length; i++) {
            if (products[i]["name"] != null && 
                products[i]["name"].toString().toLowerCase().contains("test")) {
              products[i]["name"] = bakeryNames[i % bakeryNames.length];
            }
            products[i]["image"] = bakeryImages[i % bakeryImages.length];
          }
        }
        
        setState(() {
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(
            title: widget.categoryName,
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                ? const Center(
              child: Text(
                "No products found in this category.",
                style: TextStyle(
                  color: BhejduColors.textGrey,
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];

                return Padding(
                  padding:
                  const EdgeInsets.only(bottom: 14),
                  child: ProductHorizontalCard(
                    title: item["name"],
                    price: "₹${item["price"]}",
                    image: item["image"],

                    onTapProduct: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductVariantsPage(
                                productId: int.parse(
                                    item["id"].toString()),
                                productName: item["name"],
                              ),
                        ),
                      );
                    },

                    // ✅ UPDATED ADD BUTTON
                    onAdd: () {
                      try {
                        developer.log('Add button tapped - item: $item');
                        
                        final id = item["id"];
                        final price = item["price"];
                        final name = item["name"] ?? "Unknown";
                        final image = item["image"] ?? "";
                        
                        developer.log('Raw values - id: $id, price: $price');
                        
                        if (id == null || id.toString().isEmpty) {
                          developer.log('ERROR: Product ID is null or empty');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error: Invalid product ID')),
                          );
                          return;
                        }
                        
                        if (price == null || price.toString().isEmpty) {
                          developer.log('ERROR: Product price is null or empty');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error: Invalid product price')),
                          );
                          return;
                        }
                        
                        final productId = int.tryParse(id.toString()) ?? 0;
                        final productPrice = int.tryParse(price.toString()) ?? 0;
                        
                        developer.log('Parsed values - productId: $productId, price: $productPrice');
                        
                        if (productId == 0) {
                          developer.log('ERROR: Failed to parse product ID');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error: Invalid product ID format')),
                          );
                          return;
                        }
                        
                        CartModel.addItem(
                          productId: productId,
                          name: name,
                          price: productPrice,
                          image: image,
                        );

                        developer.log('Item added to cart successfully');
                        
                        // ✅ NAVIGATE TO CART
                        Navigator.pushNamed(context, "/cart");
                      } catch (e, stackTrace) {
                        developer.log('ERROR in onAdd: $e\n$stackTrace');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error adding to cart: $e')),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
