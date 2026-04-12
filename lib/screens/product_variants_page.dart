import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../models/cart_model.dart';

class ProductVariantsPage extends StatefulWidget {
  final int productId;
  final String productName;

  const ProductVariantsPage({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<ProductVariantsPage> createState() => _ProductVariantsPageState();
}

class _ProductVariantsPageState extends State<ProductVariantsPage> {
  List variants = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchVariants();
  }

  Future fetchVariants() async {
    final url =
        "https://darkslategrey-chicken-274271.hostingersite.com/api/get_variants.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "product_id": widget.productId,
        }),
      );

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        setState(() {
          variants = data["variants"];
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
            title: widget.productName,
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : variants.isEmpty
                ? const Center(
              child: Text(
                "No variants found for this product.",
                style: TextStyle(
                  color: BhejduColors.textGrey,
                  fontSize: 16,
                ),
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: variants.length,
              separatorBuilder: (_, __) =>
              const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = variants[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: BhejduColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["size"] ?? "",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "₹${item["price"]}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color:
                              BhejduColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),

                      /// ✅ FINAL ADD BUTTON
                      ElevatedButton(
                        onPressed: () {
                          try {
                            developer.log('Variant add button tapped - item: $item');
                            
                            final variantId = item["id"];
                            final price = item["price"];
                            final size = item["size"] ?? "";
                            final image = item["image"] ?? "";
                            
                            developer.log('Raw values - variantId: $variantId, price: $price');
                            
                            final parsedPrice = int.tryParse(price?.toString() ?? "0") ?? 0;
                            
                            // Handle null/invalid variant ID - use 0 as default
                            int? parsedVariantId;
                            if (variantId != null && variantId.toString().isNotEmpty && variantId.toString() != "null") {
                              parsedVariantId = int.tryParse(variantId.toString());
                            }
                            
                            developer.log('Parsed - variantId: $parsedVariantId, price: $parsedPrice');
                            
                            CartModel.addItem(
                              productId: widget.productId,
                              variantId: parsedVariantId,
                              name: widget.productName,
                              size: size,
                              price: parsedPrice,
                              image: image,
                            );
                            
                            developer.log('SUCCESS: Variant added to cart');
                            Navigator.pushNamed(context, "/cart");
                          } catch (e, stackTrace) {
                            developer.log('ERROR in variant add: $e\n$stackTrace');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error adding variant: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          BhejduColors.primaryBlue,
                        ),
                        child: const Text(
                          "ADD",
                          style:
                          TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
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
