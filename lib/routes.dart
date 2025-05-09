import 'package:trip/view/ar_map/screen/ar_take_photo_screen.dart';
import 'package:trip/view/auth/screen/forgot_password_screen.dart';
import 'package:trip/view/auth/screen/login_screen.dart';
import 'package:get/get.dart';
import 'package:trip/view/account/setting_profile/screen/settings_screen.dart';
import 'package:trip/view/auth/screen/sign_up_screen.dart';
import 'package:trip/view/balance/screen/balance_screen.dart';
import 'package:trip/view/gift_comments/screen/gift_comments.dart';
import 'package:trip/view/gift_shopping_list/screen/gift_shopping_list_screen.dart';
import 'package:trip/view/home/screen/home_screen.dart';
import 'package:trip/view/leave_a_trace/screen/leave_a_trace_screen.dart';
import 'package:trip/view/notification/screen/notification_screen.dart';
import 'package:trip/view/splash/screen/splash_screen.dart';
import 'package:trip/widget/custom_button_navbar_widget.dart';
import 'core/constant/routes.dart';
List<GetPage<dynamic>>? routes = [

  GetPage(
    name:AppRoutes.buttonNavBarScreen,
    page: () =>  const CustomBottomNavigationWidget(),

  ),
  GetPage(
    name:AppRoutes.splashScreen,
    page: () => const SplashScreen(),
  ),
  GetPage(
    name:AppRoutes.login,
    page: () => const LoginScreen(),
  ),
  GetPage(
    name:AppRoutes.registerScreen,
    page: () => const RegisterScreen(),
  ),
  GetPage(
    name:AppRoutes.forgotPasswordScreen,
    page: () =>  ForgotPasswordScreen(),
  ),
  GetPage(
    name:AppRoutes.giftsShoppingListScreen,
    page: () =>  const GiftsShoppingListScreen(),
  ),
  GetPage(
    name:AppRoutes.arMapScreen,
    page: () =>  const ARMapScreen(),
  ),
  GetPage(
    name:AppRoutes.giftCommentsScreen,
    page: () =>  const GiftCommentsScreen(),
  ),
 GetPage(
    name:AppRoutes.balanceScreen,
    page: () =>  const BalanceScreen(),
  ),GetPage(
    name:AppRoutes.arTakePhotoScreen,
    page: () =>  const ArTakePhotoScreen(),
  ),
  GetPage(
    name:AppRoutes.leaveTraceScreen,
    page: () =>  const LeaveTraceScreen(),
  ), GetPage(
    name:AppRoutes.notificationScreen,
    page: () =>  const NotificationScreen(),
  ),
  GetPage(
    name: AppRoutes.settingsScreen,
    page: () => const SettingsScreen(),
  ),




];
