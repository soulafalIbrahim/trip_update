 import 'package:flutter/material.dart';

import '../leader_board/leader_board_controller/leader_board_controller.dart';



Row leaderBoarditem(LeaderBoardController controller, int index) {
/// Builds a leaderboard row displaying user profile information.


    return Row(
                      children: [
                        controller.allUaser[index]['profileImage'] == '' || controller.allUaser[index]['profileImage'].isEmpty ?
                        const Icon(Icons.person , size:40 , color:Colors.blue,):
                        Image.network(controller.allUaser[index]['profileImage'] , width:40 , height:40,),
                        const SizedBox(width:12),
                        Column(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                          Text(controller.allUaser[index]['username'] , style:const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,),),
                          Text(controller.allUaser[index]['email'] , style:const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,),),
                           Text(' fingerPoint :${controller.allUaser[index]['fingerPoint']}' , style:const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 8.5,),),
                          
                          ]
                        ),
                      ],
                    );
  }
