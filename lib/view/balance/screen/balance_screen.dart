import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/balance_card.dart';
import '../widget/service_button.dart';


class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    return  Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  InkWell(
                      onTap:(){
                      Get.back();
                      },
                      child: const Icon(Icons.arrow_back)),
                  const Spacer(),
                  const Text("الرصيد", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const BalanceCard(),
            const SizedBox(height: 8),
             Center(
              child: Text(
                "Send a gift".tr,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 20),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Services".tr, style:const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
             Padding(
              padding:const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(child: ServiceButton(title: "Transactions".tr, icon: Icons.receipt_long)),
                const  SizedBox(width: 10),
                  Expanded(child: ServiceButton(title: "Help and notes".tr, icon: Icons.support_agent)),
                ],
              ),
            ),
            const Spacer(),
            Center(child: Text("pull".tr, style:const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
