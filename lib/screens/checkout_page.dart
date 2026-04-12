import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Map? selectedAddress;
  bool loadingAddress = true;

  @override
  void initState() {
    super.initState();
    fetchDefaultAddress();
  }

  // ✅ Load first saved address from local storage
  Future<void> fetchDefaultAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString("local_addresses") ?? "[]";
    final List decoded = jsonDecode(raw);
    setState(() {
      if (decoded.isNotEmpty) {
        selectedAddress = Map<String, dynamic>.from(decoded[0]);
      }
      loadingAddress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final int total = args?["total"] ?? 0;

    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(title: "Checkout", showBack: true, onBackTap: () => Navigator.pop(context)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── DELIVERY ADDRESS ──
                  const Text("Delivery Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: BhejduColors.textDark)),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.pushNamed(context, "/address");
                      if (result != null && result is Map) {
                        setState(() => selectedAddress = result as Map);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(2, 3))],
                      ),
                      child: loadingAddress
                          ? const Center(child: CircularProgressIndicator())
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on, color: BhejduColors.primaryBlue, size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedAddress?["title"] ?? "Add Address",
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: BhejduColors.textDark),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        selectedAddress?["address"] ?? "Tap to add delivery address",
                                        style: const TextStyle(color: BhejduColors.textGrey, height: 1.4),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.edit, color: BhejduColors.primaryBlue),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ── ORDER SUMMARY ──
                  const Text("Order Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: BhejduColors.textDark)),
                  const SizedBox(height: 12),
                  _summaryRow("Grand Total", "₹$total", isBold: true),

                  const SizedBox(height: 40),

                  // ── PLACE ORDER BUTTON ──
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedAddress == null
                          ? null
                          : () {
                              Navigator.pushNamed(
                                context,
                                "/orderConfirmation",
                                arguments: {
                                  "address_id": selectedAddress!["id"],
                                  "total": total,
                                },
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BhejduColors.primaryBlue,
                        disabledBackgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        selectedAddress == null ? "Add Address to Place Order" : "Place Order",
                        style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  if (selectedAddress == null) ...[
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton.icon(
                        icon: const Icon(Icons.add_location_alt),
                        label: const Text("Add Delivery Address"),
                        onPressed: () async {
                          final result = await Navigator.pushNamed(context, "/address");
                          if (result != null && result is Map) {
                            setState(() => selectedAddress = result);
                          }
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isBold ? 17 : 15, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500, color: BhejduColors.textDark)),
          Text(value, style: TextStyle(fontSize: isBold ? 17 : 15, fontWeight: isBold ? FontWeight.w700 : FontWeight.w600, color: BhejduColors.primaryBlue)),
        ],
      ),
    );
  }
}
