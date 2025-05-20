import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip/core/constant/color.dart';
import 'package:trip/view/leave_a_trace/screen/leave_a_trace_screen.dart';
import '../../../widget/custom_elevated_button.dart';
import '../controller/leave_a_trace_controller.dart';

class ImagePreviewScreen extends StatelessWidget {
  final File imageFile;

  const ImagePreviewScreen({super.key, required this.imageFile});


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeaveTraceController());

    return Scaffold(
      backgroundColor: AppColor.dark,
      appBar: AppBar(
          leading:  IconButton(
            icon:  const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
              size: 25,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: AppColor.dark,
          title: Text("Preview" , style: TextStyle(color: AppColor.white),)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                child: Image.file(imageFile , fit: BoxFit.fill,),
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                    ()=> CustomElevatedButton(
                          text: controller.isloading.value ?  'Saving..' : 'Save',
                          buttonColor: AppColor.appColor,
                          onPressed: () => controller.saveImageToTagZoneFolder(imageFile)
                      ),
                    ),
                    const SizedBox(height: 20,) ,
                    CustomElevatedButton(
                        text: 'Add New Memory',
                        buttonColor: AppColor.appColor,
                        onPressed: (){Get.to(() => const LeaveTraceScreen());}
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
