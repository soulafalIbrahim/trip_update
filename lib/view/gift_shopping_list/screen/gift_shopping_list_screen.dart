import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip/core/constant/color.dart';
import 'package:trip/core/constant/routes.dart';
import 'package:trip/widget/custom_text.dart';
import '../controller/gift_shopping_controller.dart';
import '../widget/gift_item_widget.dart';
import '../widget/payment_item.dart';

class GiftsShoppingListScreen extends StatelessWidget {
  const GiftsShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.dark,

      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder(
          init: GiftsShoppingListController()  ,
          builder: (controller) => 
           Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child:const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  const Spacer(),
                  CustomText(
                    text: 'Gift shopping list'.tr,
                    fontSize: 20,
                    color: AppColor.lightGrey,
                  ),
                  const Spacer(),
                  InkWell(
                      onTap: (){
                        Get.toNamed(AppRoutes.balanceScreen);
                      },
                      child: Icon(Icons.wallet, color: AppColor.white)),
                ],
              ),
              const SizedBox(height: 40,),
               Row(
                children: [
                  CustomText(
                    text:
                    "Buy Gifts Now".tr,
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                  ),Spacer(),
                  Icon(Icons.fingerprint, color: AppColor.appColor)
                ],
              ),
              const SizedBox(height: 10,),
              const Divider(color: Colors.white24, thickness: 1, height: 20),
             
              /// Gift List
              controller.isLoading ? const Center(child: CircularProgressIndicator(),) :
                Expanded(
                child:ListView.separated(
                   itemCount:controller.allGifts.length,
                   separatorBuilder: (context, index) => const SizedBox(height: 12,),
                   
                  itemBuilder: (context, index) =>   GiftItemWidget(
                  
                  index: index+1,
                  name: "${controller.allGifts[index]['name']}",
                  points: controller.allGifts[index]['fingerPoint'],
                  price: "\$${controller.allGifts[index]['price']}",
                  color: Colors.blue,
                  giftimage:controller.allGifts[index]['giftImage'] != '' || controller.allGifts[index]['giftImage'].isNotEmpty ?Image.network(controller.allGifts[index]['giftImage'] , width:60 , height:60,fit: BoxFit.cover,): Image.asset("assets/images/gift1.png") ,
                   
                  imagePath: "assets/images/gift1.png"),
                   )),
              // const GiftItemWidget(
              //     index: 1,
              //     name: "Blu Gift",
              //     points: 500,
              //     price: "\$100",
              //     color: Colors.blue,
              //     imagePath: "assets/images/gift1.png"),
              // const GiftItemWidget(
              //     index: 2,
              //     name: "Red Gift",
              //     points: 400,
              //     price: "\$75",
              //     color: Colors.red,
              //     imagePath: "assets/images/gift2.png"),
              // const GiftItemWidget(
              //     index: 3,
              //     name: "Purble Gift",
              //     points: 300,
              //     price: "\$50",
              //     color: Colors.purple,
              //     imagePath: "assets/images/gift3.png"),
              // const GiftItemWidget(
              //     index: 4,
              //     name: "Pink Gift",
              //     points: 200,
              //     price: "\$25",
              //     color: Colors.pinkAccent,
              //     imagePath: "assets/images/gift4.png"),
          
              const SizedBox(height: 16),
               CustomText(text:
                "Purchase and payment methods".tr,
               color: AppColor.white, fontWeight: FontWeight.bold,
                 alignment: Alignment.topLeft,fontSize: 15,
              ),
              const Divider(color: Colors.white24, thickness: 1, height: 20),
          
              const PaymentItemWidget(
                  method: "Visa",
                  date: "April 3, 2025",
                  amount: "-\$100",
                  color: Colors.redAccent,
                  logoPath: "assets/images/visa.png"),
              const Divider(color: Colors.white24, thickness: 1, height: 20),
              const PaymentItemWidget(
                  method: "PayPal",
                  date: "April 3, 2025",
                  amount: "-\$50",
                  color: Colors.purpleAccent,
                  logoPath: "assets/images/paypal.png"),
            ],
          ),
        ),
      ),
    );
  }
}
