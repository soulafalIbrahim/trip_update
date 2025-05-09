import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip/core/constant/const_data.dart';

import '../../../core/constant/routes.dart';
import '../../../widget/circle_button_widget.dart';
import '../gift_controller/gift_controller.dart';


class GiftsMapScreen extends StatefulWidget {
  const GiftsMapScreen({super.key});

  @override
  State<GiftsMapScreen> createState() => _GiftsMapScreenState();
}

class _GiftsMapScreenState extends State<GiftsMapScreen> with SingleTickerProviderStateMixin {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(24.7136, 46.6753);
 // final GiftController giftController = Get.put(GiftController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init:GiftController() ,
      builder: (giftController) => 
      Scaffold(
        body: Stack(
          children: [
            /// Google Map with dark mode style
            GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
                mapController.setMapStyle(ConstData.darkMapStyle);
              },
              initialCameraPosition: CameraPosition(
                target:_center,
                //giftController.currentLocationt!,
                zoom: 15.0,
              ),
              markers:giftController.markers,
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
            Positioned(
              right: 16,
              bottom: 10,
              child: GestureDetector(
                onTap: () {
             Get.toNamed(AppRoutes.giftsShoppingListScreen);
                },
                child: const CircleButtonWidget(icon:Icons.add,height: 60,width: 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // List<Widget> _buildARIcons() {
  //   final List<Offset> positions = [
  //     const Offset(80, 150),
  //     const Offset(200, 250),
  //     const Offset(120, 300),
  //     const Offset(280, 180),
  //     const Offset(160, 450),
  //   ];
  //
  //   final List<Color> colors = [
  //     const Color(0xffff66c4),
  //     const Color(0xffff66c4),
  //     const Color(0xffff66c4),
  //     const Color(0xffff66c4),
  //     const Color(0xffff66c4),
  //   ];
  //
  //   return List.generate(
  //     positions.length,
  //         (index) => Positioned(
  //       left: positions[index].dx,
  //       top: positions[index].dy,
  //       child: InkWell(
  //         onTap: (){
  //           Get.toNamed(AppRoutes.giftsShoppingListScreen);
  //         },
  //         child: Container(
  //           width: 60,
  //           height: 60,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             color: colors[index].withOpacity(0.2),
  //
  //           ),
  //           child: Center(
  //             child: Icon(
  //               Icons.card_giftcard,
  //               color: colors[index],
  //               size: 30,
  //               shadows: [
  //                 Shadow(
  //                   color: colors[index].withOpacity(0.7),
  //                   blurRadius: 10,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

}
