import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/product_horizontal_card.dart';
import '../models/cart_model.dart';

class SpecialOffersPage extends StatefulWidget {
  const SpecialOffersPage({super.key});

  @override
  State<SpecialOffersPage> createState() => _SpecialOffersPageState();
}

class _SpecialOffersPageState extends State<SpecialOffersPage> {
  final List<Map<String, dynamic>> offerProducts = [
    {"id": "201", "name": "Buy 1 Get 1 - White Bread", "price": "25", "image": "https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?w=400&h=300&fit=crop"},
    {"id": "202", "name": "Buy 1 Get 1 - Brown Bread", "price": "30", "image": "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=300&fit=crop"},
    {"id": "203", "name": "Buy 1 Get 1 - Milk", "price": "60", "image": "https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&h=300&fit=crop"},
    {"id": "204", "name": "Buy 1 Get 1 - Orange Juice", "price": "75", "image": "https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400&h=300&fit=crop"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(
            title: "Special Offers",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: offerProducts.length,
              itemBuilder: (context, index) {
                final item = offerProducts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: ProductHorizontalCard(
                    title: item["name"]!,
                    price: "₹${item["price"]} (Buy 1 Get 1)",
                    image: item["image"]!,
                    onTapProduct: () {},
                    onAdd: () {
                      final productId = int.tryParse(item["id"].toString()) ?? 0;
                      final productPrice = int.tryParse(item["price"].toString()) ?? 0;
                      CartModel.addItem(
                        productId: productId,
                        name: item["name"]!,
                        price: productPrice,
                        image: item["image"]!,
                      );
                      Navigator.pushNamed(context, "/cart");
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
