import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoggedIn = false;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("user_id");
    setState(() { _isLoggedIn = userId != null; _checking = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (!_isLoggedIn) {
      return Scaffold(
        backgroundColor: BhejduColors.bgLight,
        body: Column(
          children: [
            BhejduAppBar(title: "My Orders", showBack: true, onBackTap: () => Navigator.pop(context)),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 70, color: BhejduColors.primaryBlue),
                    const SizedBox(height: 16),
                    const Text("Login to view your orders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, "/login"),
                      style: ElevatedButton.styleFrom(backgroundColor: BhejduColors.primaryBlue, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          /// 🔵 Custom Blue App Bar
          BhejduAppBar(
            title: "My Orders",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          /// PAGE CONTENT
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _orderTile(
                  orderId: "#ORD1023",
                  date: "3 Dec 2025",
                  status: "Delivered",
                  color: BhejduColors.successGreen,
                  onTrack: () =>
                      Navigator.pushNamed(context, "/orderTracking"),
                ),

                _orderTile(
                  orderId: "#ORD1022",
                  date: "1 Dec 2025",
                  status: "Out for Delivery",
                  color: BhejduColors.offerBlue,
                  onTrack: () =>
                      Navigator.pushNamed(context, "/orderTracking"),
                ),

                _orderTile(
                  orderId: "#ORD1021",
                  date: "29 Nov 2025",
                  status: "Packed",
                  color: BhejduColors.offerOrange,
                  onTrack: () =>
                      Navigator.pushNamed(context, "/orderTracking"),
                ),

                _orderTile(
                  orderId: "#ORD1019",
                  date: "27 Nov 2025",
                  status: "Pending",
                  color: BhejduColors.textGrey,
                  onTrack: () =>
                      Navigator.pushNamed(context, "/orderTracking"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- ORDER TILE WIDGET ----------------
  Widget _orderTile({
    required String orderId,
    required String date,
    required String status,
    required Color color,
    required VoidCallback onTrack,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: BhejduColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Order ID + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderId,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: BhejduColors.textDark,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  color: BhejduColors.textGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Status Badge
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Track Order Button
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onTrack,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: BhejduColors.primaryBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Track Order",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
