import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services.dart';

class ChangeLangaugeController extends GetxController {

  
   Locale? initial ;
   Future <void> changeLanguage (String languageCode)async {
    Locale newLocale =  Locale(languageCode); 
    await MyServices.saveStringValue( 'Lang',languageCode);
     // var v = await MyServices.getStringValue('Lang');
  
    Get.updateLocale(newLocale);

   }
    
   

       getLocal() async {
     String ?localecode = await MyServices.getStringValue('Lang');
        
     initial = localecode == 'ar' ? const Locale('ar', 'AR') : const Locale('en', 'US');
      Get.updateLocale(initial!);

     }
   @override
  void onInit() async {
     await  getLocal();
    // TODO: implement onInit
    super.onInit();
  }

}