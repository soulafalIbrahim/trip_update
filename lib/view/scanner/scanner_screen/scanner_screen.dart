
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip/core/constant/assets.dart';
import 'package:trip/core/constant/color.dart';
import 'package:trip/widget/custom_text.dart';

import '../../../core/constant/const_data.dart';
import '../../ar_map/screen/ar_take_photo_screen.dart';
import '../../gift_comments/screen/gift_comments.dart';
import '../scanner_controller/scanner_controller.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {

  //  ConstData.fingerprintDocId = fingerprintDoc.id;
  //             Get.to(GiftCommentsScreen());
    return  Scaffold(
      backgroundColor:AppColor.dark,
      appBar:AppBar(  
         toolbarHeight:30,
        leading:InkWell(
          onTap:(){
            Get.to(ArTakePhotoScreen());
          },
          child:const Icon(Icons.arrow_back_ios,color:Colors.black,),
        ),
      ),
      body:GetBuilder(
        init:ScannerController(),
        builder: (controller) =>
         SafeArea(
          
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height:Get.height,
              width: Get.width,
              child: controller.isLoading == true ?const Center(child:Text('Loading......' , style:TextStyle(color:Colors.white , fontSize:28)  ),) :
              controller.nearby.isEmpty ?const Center(child:Text('No nearby fingerPrints' , style:TextStyle(color:Colors.white , fontSize:28)  ),) :
              ListView.separated(
                itemCount:controller.nearby.length,
                separatorBuilder:(context, index) =>const Divider( color:Colors.white, height:10, thickness:.2,),
                itemBuilder: (context, index) {
                  final nearbyFingerPrint = controller.nearby[index];
                    return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap:(){
                      ConstData.fingerprintDocId = nearbyFingerPrint['figerprintId'];
                        Get.to(()=> GiftCommentsScreen());
                        print( ConstData.fingerprintDocId);
                    },
                    child: Row(
                      mainAxisAlignment:MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius:20,
                          foregroundColor:AppColor.appColor,
                          foregroundImage: nearbyFingerPrint['userImage'].isEmpty ?Image.asset('assets/icons/avatar.png').image : 
                          Image.network(nearbyFingerPrint['userImage'] , width:40 , height:40,).image ,
                          
                    
                        ),
                        const SizedBox(width:10,),
                        CustomText(
                          text:nearbyFingerPrint['username'],
                          fontSize:12,
                          color:Colors.white,
                          
                        ),
                      ],
                    ),
                  ),
                );
                }
              
              ),
            ),
          ),
        ),
      ),
    );
  }
}

