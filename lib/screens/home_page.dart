import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/banner_slider.dart';
import '../widgets/category_card.dart';
import '../widgets/offer_card.dart';
import '../widgets/app_drawer.dart';
import '../theme/bhejdu_colors.dart';
import '../screens/product_variants_page.dart';
import '../models/cart_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController fadeCtrl;
  late Animation<double> fadeAnim;

  bool loading = true;
  List categories = [];
  List featured = [];
  List<String> banners = [];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    fadeAnim = CurvedAnimation(
      parent: fadeCtrl,
      curve: Curves.easeIn,
    );

    fadeCtrl.forward();
    fetchAllData();
  }

  Future fetchAllData() async {
    setState(() => loading = true);

    try {
      final bannerRes = await http.get(Uri.parse(
          "https://darkslategrey-chicken-274271.hostingersite.com/api/get_banners.php"));

      final catRes = await http.get(Uri.parse(
          "https://darkslategrey-chicken-274271.hostingersite.com/api/get_categories.php"));

      final featRes = await http.get(Uri.parse(
          "https://darkslategrey-chicken-274271.hostingersite.com/api/get_featured_products.php"));

      final bData = jsonDecode(bannerRes.body);
      final cData = jsonDecode(catRes.body);
      final fData = jsonDecode(featRes.body);

      if (bData["status"] == "success") {
        banners = (bData["banners"] as List)
            .map<String>((e) => e["image"].toString())
            .toList();
      }

      if (cData["status"] == "success") {
        categories = cData["categories"];
        // Replace "testing" with "Bakery and Bread"
        for (var cat in categories) {
          if (cat["name"] != null && cat["name"].toString().toLowerCase().contains("test")) {
            cat["name"] = "Bakery and Bread";
            cat["icon"] = "bakery";
          }
        }
      }

      if (fData["status"] == "success") {
        featured = fData["products"];
        // Replace only testing products with Fresh White Bread and Brown Bread
        final breadProducts = [
          {"id": "101", "name": "Fresh White Bread", "price": "25", "image": "https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?w=400&h=300&fit=crop"},
          {"id": "102", "name": "Brown Bread", "price": "30", "image": "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=300&fit=crop"},
        ];
        for (int i = 0; i < featured.length; i++) {
          if (featured[i]["name"] != null && featured[i]["name"].toString().toLowerCase().contains("test")) {
            featured[i] = breadProducts[i % breadProducts.length];
          }
        }
      }
    } catch (e) {
      debugPrint("Home error: $e");
      // ✅ Mock data fallback - Bakery & Bread Focus
      if (categories.isEmpty) {
        categories = [
          {"id": "1", "name": "Bakery and Bread", "icon": "bakery"},
          {"id": "2", "name": "Fruits", "icon": "eco"},
          {"id": "3", "name": "Vegetables", "icon": "eco"},
          {"id": "4", "name": "Dairy", "icon": "local_cafe"},
          {"id": "5", "name": "Snacks", "icon": "fastfood"},
        ];
      }
      if (featured.isEmpty) {
        featured = [
          {"id": "101", "name": "Fresh White Bread", "price": "25", "image": "https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?w=400&h=300&fit=crop"},
          {"id": "102", "name": "Brown Bread", "price": "30", "image": "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=300&fit=crop"},
          {"id": "1", "name": "Fresh Apples", "price": "120", "image": "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&h=300&fit=crop"},
          {"id": "2", "name": "Whole Milk 1L", "price": "60", "image": "https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&h=300&fit=crop"},
          {"id": "3", "name": "Basmati Rice 1kg", "price": "90", "image": "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&h=300&fit=crop"},
          {"id": "4", "name": "Orange Juice", "price": "75", "image": "https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400&h=300&fit=crop"},
        ];
      }
    }

    setState(() => loading = false);
  }

  IconData getIcon(String? name) {
    switch (name) {
      case "eco":
        return Icons.eco;
      case "apple":
        return Icons.apple;
      case "fastfood":
        return Icons.fastfood;
      case "local_cafe":
        return Icons.local_cafe;
      case "bakery":
        return Icons.bakery_dining;
      default:
        return Icons.category;
    }
  }

  @override
  void dispose() {
    fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      backgroundColor: BhejduColors.bgLight,

      body: FadeTransition(
        opacity: fadeAnim,
        child: Column(
          children: [
            /// ---------------- WHITE HEADER ----------------
            Container(
              padding: const EdgeInsets.only(
                  top: 45, left: 16, right: 16, bottom: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState!.openDrawer(),
                    child: const Icon(Icons.menu),
                  ),
                  const Text(
                    "Home",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: () =>
                            Navigator.pushNamed(context, "/cart"),
                      ),
                      IconButton(
                        icon: const Icon(Icons.person_outline),
                        onPressed: () async {
                          final prefs =
                          await SharedPreferences.getInstance();
                          final userId = prefs.getInt("user_id");
                          Navigator.pushNamed(
                              context, userId != null ? "/profile" : "/login");
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),

            /// ---------------- CONTENT ----------------
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    banners.isEmpty
                        ? const BannerSlider()
                        : _ServerBannerSlider(banners: banners),

                    const SizedBox(height: 24),

                    /// OFFERS
                    const Text(
                      "Special Offers",
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OfferCard(
                          title: "Flat 20% OFF\nFirst Order",
                          bgColor: BhejduColors.offerOrange,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/product-list",
                              arguments: {"id": "1", "name": "Bakery and Bread"},
                            );
                          },
                        ),
                        OfferCard(
                          title: "Free Delivery\nAbove ₹500",
                          bgColor: BhejduColors.successGreen,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/product-list",
                              arguments: {"id": "1", "name": "Bakery and Bread"},
                            );
                          },
                        ),
                        OfferCard(
                          title: "Buy 1 Get 1\nSpecial Offer",
                          bgColor: BhejduColors.offerBlue,
                          onTap: () {
                            Navigator.pushNamed(context, "/special-offers");
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// CATEGORIES
                    const Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: BhejduColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 14),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((cat) {
                          return Padding(
                            padding:
                            const EdgeInsets.only(right: 14),
                            child: CategoryCard(
                              title: cat["name"],
                              icon: getIcon(cat["icon"]),
                              bgColor: Colors.white,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  "/product-list",
                                  arguments: {
                                    "id": int.parse(
                                        cat["id"].toString()),
                                    "name": cat["name"],
                                  },
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// FEATURED PRODUCTS
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Featured Products",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "View All",
                          style: TextStyle(
                              color: BhejduColors.primaryBlue,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemCount: featured.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, i) {
                        final p = featured[i];

                        /// ✅ IMAGE URL FIX (IMPORTANT)
                        final img = p["image"].toString();

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductVariantsPage(
                                      productId: int.parse(
                                          p["id"].toString()),
                                      productName: p["name"],
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5)
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  const BorderRadius.vertical(
                                      top:
                                      Radius.circular(16)),
                                  child: Image.network(
                                    img,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                    const Icon(
                                        Icons.broken_image),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p["name"],
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight:
                                            FontWeight.w600),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "₹${p["price"]}",
                                            style: const TextStyle(
                                                color: BhejduColors
                                                    .successGreen,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              try {
                                                developer.log('========== ADD BUTTON TAPPED ==========');
                                                developer.log('Raw product data: $p');
                                                developer.log('ID raw: ${p["id"]}, type: ${p["id"]?.runtimeType}');
                                                developer.log('Price raw: ${p["price"]}, type: ${p["price"]?.runtimeType}');
                                                developer.log('Name raw: ${p["name"]}');
                                                
                                                final id = p["id"];
                                                final price = p["price"];
                                                final name = p["name"] ?? "Unknown";
                                                final image = p["image"] ?? "";
                                                
                                                if (id == null) {
                                                  developer.log('ERROR: ID is null');
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Error: Product ID is null')),
                                                  );
                                                  return;
                                                }
                                                
                                                final idStr = id.toString();
                                                final priceStr = price?.toString() ?? "0";
                                                
                                                developer.log('ID string: "$idStr"');
                                                developer.log('Price string: "$priceStr"');
                                                
                                                if (idStr.isEmpty || idStr == "null") {
                                                  developer.log('ERROR: ID string is empty or null');
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Error: Invalid product ID')),
                                                  );
                                                  return;
                                                }
                                                
                                                final productId = int.tryParse(idStr) ?? 0;
                                                final productPrice = int.tryParse(priceStr) ?? 0;
                                                
                                                developer.log('Parsed productId: $productId, productPrice: $productPrice');
                                                
                                                if (productId == 0) {
                                                  developer.log('ERROR: Failed to parse productId');
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Error: Cannot parse product ID')),
                                                  );
                                                  return;
                                                }
                                                
                                                developer.log('Adding to cart: id=$productId, name=$name, price=$productPrice');
                                                
                                                CartModel.addItem(
                                                  productId: productId,
                                                  name: name,
                                                  price: productPrice,
                                                  image: image,
                                                );
                                                
                                                developer.log('SUCCESS: Item added to cart');
                                                Navigator.pushNamed(context, "/cart");
                                              } catch (e, stackTrace) {
                                                developer.log('ERROR adding featured product: $e');
                                                developer.log('Stack trace: $stackTrace');
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: $e')),
                                                );
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: BhejduColors.primaryBlue,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                "ADD",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
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
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    /// REVIEWS
                    const Text(
                      "What Customers Say",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 14),

                    _simpleReview("Priya", "Fresh & fast delivery 👍"),
                    _simpleReview("Rahul", "Best grocery app so far!"),
                    _simpleReview("Neha", "Quality products, loved it"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /// ---------------- BOTTOM NAV ----------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: BhejduColors.primaryBlue,
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          setState(() => _currentIndex = i);
          if (i == 1) Navigator.pushNamed(context, "/categories");
          if (i == 2) Navigator.pushNamed(context, "/orders");
          if (i == 3) Navigator.pushNamed(context, "/profile");
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: "Orders"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _simpleReview(String name, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4)
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.person),
          const SizedBox(width: 12),
          Expanded(child: Text("$name: $text")),
        ],
      ),
    );
  }
}

/// ---------------- SERVER BANNER SLIDER ----------------
class _ServerBannerSlider extends StatefulWidget {
  final List<String> banners;
  const _ServerBannerSlider({required this.banners});

  @override
  State<_ServerBannerSlider> createState() => _ServerBannerSliderState();
}

class _ServerBannerSliderState extends State<_ServerBannerSlider> {
  late PageController controller;
  int index = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    controller = PageController();
    timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!controller.hasClients) return;
      index = (index + 1) % widget.banners.length;
      controller.animateToPage(index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: controller,
        itemCount: widget.banners.length,
        itemBuilder: (_, i) => ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(widget.banners[i], fit: BoxFit.cover),
        ),
      ),
    );

  }
}
