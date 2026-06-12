abstract class Routes {
  ///common screens routes--------------------------------
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const APPSWITCHER = '/app-switcher-view';
  static const DMSPLASH = '/dm-splash';
  static const NOINTERNETVIEW = '/no-internet-view';

  ///Gainer Routes-----------------------------------------
  static const GAINERSPLASH = '/gainer/splash';
  static const GAINERMAINVIEW = '/gainer/main-view';

  ///Gainer Buyer Routes
  static const PARTREQUESTVIEW = '/gainer/buyer/part-request';
  static const DIRECTREQ = '/gainer/buyer/direct-req';
  static const DIRECTREQSENT = '/gainer/buyer/direct-req-sent';
  static const ORDERPLACED = '/gainer/buyer/order-placed';
  static const UPDATEPO = '/gainer/buyer/update-po';
  static const UPDATEPOIMAGEVIEW = '/gainer/buyer/update-po/image-view';
  static const UPDATEPOORDERSUMMARY = '/gainer/buyer/update-po/order-summary';
  static const PARTRECEIPT = '/gainer/buyer/part-receipt';

  ///Gainer Seller Routes
  static const DIRECTREQRECEIVED = '/gainer/buyer/direct-req-received';
  static const ORDERRECEIVED = '/gainer/seller/order-received';
  static const MANIFESTATIONVIEW = '/gainer/seller/manifestation';
  static const MANIFESTATIONSUMMARY = '/gainer/seller/manifestation/summary';
  static const MANIFESTATIONFCVIEW = '/gainer/seller/manifestation/fc-view';
  static const DISPATCHEDDETAILSVIEW = '/gainer/seller/dispatched-details';

  static const NOTIFICATIONVIEW = '/gainer/main-view/notification-view';
}
