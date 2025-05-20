import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constant/color.dart';

import '../../widgets/leader_board_item.dart';
import '../../widgets/profile_header.dart';
import '../leader_board_controller/leader_board_controller.dart';

class LeaderBoardScreen extends StatelessWidget {
  const 
  LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       backgroundColor: AppColor.dark,
       body: SafeArea(
         child: GetBuilder(
          init: LeaderBoardController(),
          builder: (controller) => 
            Container(
              decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey,
                  Colors.black,
                ],
              ),
            ),
            child: Padding(
              padding:const EdgeInsets.symmetric(vertical:8 , horizontal: 10),
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  AppHeader(title: 'Leader Board'.tr,optionsSettings:false),
                  const SizedBox(height: 1),
                  controller.isloading == true ? const Center(child: CircularProgressIndicator(),) : 
                  Expanded(
                    child:ListView.separated(
                       itemCount:controller.allUaser.length,
                       separatorBuilder: (context, index) => const SizedBox(height: 14,),
                      itemBuilder: (context, index) =>   Container(
                        width:Get.width,
                        height: Get.height*0.1,
                        padding:const EdgeInsets.symmetric(horizontal:12 , vertical:10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow:const [
                             BoxShadow(
                              color:Color.fromARGB(255, 2, 85, 153),
                              blurRadius:5.8,
                              spreadRadius:0.7,
                              offset:Offset(1.5,0.8)
                            )
                          ]
                       
                        ),
           
                      child:leaderBoarditem(controller, index),
                      ), 
                      
                     )
                  
                  )
                 
                  
                ],
              ),
            ),
           ),
         ),
       )
    );
  }
}
 