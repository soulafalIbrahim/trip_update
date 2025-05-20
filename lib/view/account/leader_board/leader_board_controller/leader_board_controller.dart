import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class LeaderBoardController  extends GetxController{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
   CollectionReference users = FirebaseFirestore.instance.collection('users');
   bool isloading = false ;
   List allUaser = [ ];


    Future getAllUsers() async {
      isloading = true ;
      update();
      users.orderBy('fingerPoint' , descending: true).snapshots().listen((event){
        final doc = event.docs;
        allUaser.assignAll(doc);
        
        update();
        isloading = false ;

        
      });
    }

   @override
  void onInit() async {
    await getAllUsers();
    super.onInit();
  }
}