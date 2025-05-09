import 'package:get/get.dart';

import '../../account/setting_profile/controller/account_controller.dart';



class BalanceController extends GetxController {
  RxInt diamonds = 0.obs;
  RxDouble livePoints = 0.0.obs;
  //RxInt balance = 0.obs;
  //var fingerPoint = 0.obs;
  

   

  @override
  void onInit() {
    Get.find<AccountController>();
    super.onInit();
   
    
  }
  
}
