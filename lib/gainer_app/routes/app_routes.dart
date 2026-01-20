// <<<<<<< HEAD
//
// abstract class Routes {
//   static const SPLASH = '/splash';
//   static const LOGIN = '/login';
//   static const HOME = '/home';
//   static const DMSPLASH = '/dm-splash';
//   static const GAINERSPLASH = '/gainer-splash';
//   static const NOINTERNETVIEW = '/no-internet-view';
//   static const GAINERMAINVIEW = '/gainer-main-view';
// =======
abstract class Routes {
  ///common screens routes
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const APPSWITCHER = '/app-switcher-view';
  static const DMSPLASH = '/dm-splash';
  static const NOINTERNETVIEW = '/no-internet-view';

  ///Gainer Routes
  static const GAINERSPLASH = '/gainer/splash';
  static const GAINERMAINVIEW = '/gainer/main-view';
  // static const HOME = '/gainer/home';

  ///Gainer Buyer Routes
  static const ORDERPLACED = '/gainer/buyer/order-placed';

  ///Temp screen
  static const ORDERS = '/orders';
  static const INVENTORY = '/inventory';
  static const PROFILE = '/profile';
}
