import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:trip/core/constant/color.dart';
import '../controller/home_controller.dart';

class ARMapScreen extends StatelessWidget {
  const ARMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.dark,
      body: Stack(
        children: [
          GetBuilder<HomeController>(
            init: HomeController(),
            builder: (controller) {
              if (controller.currentLocation == null) {
                return const Center(child: CircularProgressIndicator());
              }
  return FlutterMap(
                options: MapOptions(
                  initialCenter: controller.currentLocation!,
                  initialZoom: 15,
                  onTap: (tapPosition, point) {},
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.trip',
                    retinaMode: RetinaMode.isHighDensity(context),
                  ),
                  CircleLayer(
      circles: [
        CircleMarker(
          point: controller.currentLocation!,
          radius: 3, 
          color: Colors.blue,
          borderColor: Colors.blue,
          borderStrokeWidth: 2,
        ),
      ],
    ),
                
                  MarkerLayer(markers: controller.markers),

                  PolylineLayer(polylines: controller.polylines),
                ],
              );
            
            },
          ),

        ],
      ),
    );
  }
}

// class CircleButtonWidget extends StatelessWidget {
//   final IconData icon;
//   final double height;
//   final double width;
//
//   const CircleButtonWidget({
//     super.key,
//     required this.icon,
//     required this.height,
//     required this.width,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return CircleAvatar(
//       radius: width / 2,
//       backgroundColor: Colors.transparent,
//       child: Icon(icon, size: height / 2, color: Colors.blue),
//     );
//   }
// }
