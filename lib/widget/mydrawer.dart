import 'package:flutter/material.dart';
import 'package:trip/core/constant/assets.dart';
import 'package:trip/core/constant/color.dart';
import 'package:trip/view/account/setting_profile/screen/settings_screen.dart';
import 'package:trip/widget/drawr_item.dart';

import '../view/home/screen/home_screen.dart';


class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: Colors.black54,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 80, 24, 0),
          child: Column(
            children: [
              headerWiget(),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: DrawerItem(
                  name: 'Home',
                  icon: Icons.home,
                  onTap: () => onItemPressed(context, index: 0),
                ),
              ),
              const Divider(
                height: 2,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 2.0),
                child: DrawerItem(
                  name: 'Upgrade',
                  icon: Icons.update,
                  onTap: () => onItemPressed(context, index: 1),
                ),
              ),
              const Divider(
                height: 2,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 2),
                child: DrawerItem(
                    name: 'Settings',
                    icon: Icons.settings,
                    onTap: () => onItemPressed(context, index: 2)),
              ),
              const Divider(
                height: 2,
                color: Colors.white60,
              ),

              const Divider(height: 2, color: Colors.white60),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 2),
                child: DrawerItem(
                    name: 'Share App',
                    icon: Icons.share,
                    onTap: () => onItemPressed(context, index: 4)),
              ),

              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  void onItemPressed(BuildContext context, {required int index}) {
    Navigator.pop(context);
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const ARMapScreen()));
        break;
      case 1:
        // fetchOffers();
         break;

      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SettingsScreen()));

        break;
        case 3:


        break;

      case 4:
        break;

      default:
        Navigator.pop(context);
        break;
    }
  }

  Widget headerWiget() {
    return const Column(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(Assets.logo),
          radius: 50,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "EZE LINE",
          style: TextStyle(
              color: AppColor.appColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat"),
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
