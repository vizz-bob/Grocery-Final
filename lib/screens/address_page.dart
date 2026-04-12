import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class AddressManagementPage extends StatefulWidget {
  const AddressManagementPage({super.key});

  @override
  State<AddressManagementPage> createState() => _AddressManagementPageState();
}

class _AddressManagementPageState extends State<AddressManagementPage> {
  List<Map<String, dynamic>> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAddresses();
  }

  // ✅ Load addresses from SharedPreferences (works offline)
  Future<void> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString("local_addresses") ?? "[]";
    final List decoded = jsonDecode(raw);
    setState(() {
      addresses = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      isLoading = false;
    });
  }

  Future<void> saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("local_addresses", jsonEncode(addresses));
  }

  void addAddress(String type, String address) {
    final newId = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      addresses.add({"id": newId, "title": type, "address": address});
    });
    saveAddresses();
  }

  void updateAddress(int id, String type, String address) {
    setState(() {
      final idx = addresses.indexWhere((a) => a["id"] == id);
      if (idx != -1) addresses[idx] = {"id": id, "title": type, "address": address};
    });
    saveAddresses();
  }

  void deleteAddress(int id) {
    setState(() => addresses.removeWhere((a) => a["id"] == id));
    saveAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(title: "My Addresses", showBack: true, onBackTap: () => Navigator.pop(context)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BhejduColors.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.add_location_alt, color: Colors.white),
                label: const Text("Add New Address", style: TextStyle(color: Colors.white, fontSize: 16)),
                onPressed: () => _addressBottomSheet(),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : addresses.isEmpty
                    ? const Center(child: Text("No addresses saved.\nTap above to add one.", textAlign: TextAlign.center))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          final item = addresses[index];
                          return GestureDetector(
                            onTap: () => Navigator.pop(context, item),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 3))],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Chip(
                                        label: Text(item["title"], style: const TextStyle(color: Colors.white)),
                                        backgroundColor: BhejduColors.primaryBlue,
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: BhejduColors.primaryBlue),
                                            onPressed: () => _addressBottomSheet(item: item),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => deleteAddress(item["id"]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(item["address"], style: const TextStyle(color: BhejduColors.textGrey, fontSize: 14)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _addressBottomSheet({dynamic item}) {
    String selectedType = item?["title"] ?? "Home";
    final houseCtrl = TextEditingController(text: "");
    final streetCtrl = TextEditingController(text: "");
    final cityCtrl = TextEditingController(text: "");
    final pincodeCtrl = TextEditingController(text: "");

    // Pre-fill if editing
    if (item != null) {
      final parts = item["address"].toString().split("\n");
      if (parts.isNotEmpty) houseCtrl.text = parts[0];
      if (parts.length > 1) streetCtrl.text = parts[1];
      if (parts.length > 2) cityCtrl.text = parts[2];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) {
        return StatefulBuilder(builder: (ctx, setModalState) {
          return Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Address Type", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 10),
                  Row(
                    children: ["Home", "Work", "Other"].map((type) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(type),
                          selected: selectedType == type,
                          selectedColor: BhejduColors.primaryBlue,
                          labelStyle: TextStyle(color: selectedType == type ? Colors.white : Colors.black),
                          onSelected: (_) => setModalState(() => selectedType = type),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  _input("Flat / House No.", houseCtrl),
                  _input("Street / Area", streetCtrl),
                  _input("City", cityCtrl),
                  _input("Pincode", pincodeCtrl, keyboard: TextInputType.number),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BhejduColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        final fullAddress = "${houseCtrl.text}\n${streetCtrl.text}\n${cityCtrl.text} - ${pincodeCtrl.text}".trim();
                        if (item == null) {
                          addAddress(selectedType, fullAddress);
                        } else {
                          updateAddress(item["id"], selectedType, fullAddress);
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Save Address", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _input(String label, TextEditingController controller, {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: BhejduColors.bgLight,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
