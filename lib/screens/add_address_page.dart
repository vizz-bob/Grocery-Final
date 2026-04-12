import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../utils/preference_manager.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  String addressType = "Home";

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final houseCtrl = TextEditingController();
  final buildingCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final landmarkCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();

  final String baseUrl =
      "https://darkslategrey-chicken-274271.hostingersite.com/api";

  Future saveAddress() async {
    final userId = await PreferenceManager.getUserId();

    final fullAddress = """
${houseCtrl.text}, ${buildingCtrl.text}
${streetCtrl.text}
${landmarkCtrl.text.isNotEmpty ? "Landmark: ${landmarkCtrl.text}" : ""}
${cityCtrl.text} - ${pincodeCtrl.text}
Phone: ${phoneCtrl.text}
""";

    await http.post(
      Uri.parse("$baseUrl/add_address.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "title": addressType,
        "address": fullAddress.trim(),
      }),
    );

    Navigator.pop(context);
  }

  Widget input(String label, TextEditingController ctrl,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(
            title: "Add New Address",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  input("Full Name", nameCtrl),
                  input("Phone Number", phoneCtrl,
                      type: TextInputType.phone),
                  input("Flat / House No.", houseCtrl),
                  input("Building / Apartment Name", buildingCtrl),
                  input("Street / Locality", streetCtrl),
                  input("Landmark (Optional)", landmarkCtrl),

                  Row(
                    children: [
                      Expanded(child: input("City", cityCtrl)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: input(
                          "Pincode",
                          pincodeCtrl,
                          type: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Address Type",
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: ["Home", "Work", "Other"].map((type) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(type),
                          selected: addressType == type,
                          selectedColor: BhejduColors.primaryBlue,
                          labelStyle: TextStyle(
                            color: addressType == type
                                ? Colors.white
                                : Colors.black,
                          ),
                          onSelected: (_) {
                            setState(() => addressType = type);
                          },
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saveAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BhejduColors.primaryBlue,
                        padding:
                        const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Save Address",
                        style:
                        TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
