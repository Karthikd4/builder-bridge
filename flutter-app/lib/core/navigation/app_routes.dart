abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/auth/login';
  static const otp = '/auth/otp';
  static const authSuccess = '/auth/success';
  static const dashboard = '/dashboard';
  static const inventory = '/inventory';
  static const payments = '/payments';
  static const documents = '/documents';
  static const support = '/support';

  static String towerFloor(int towerId) => '/inventory/tower/$towerId';
  static const estimate = '/estimate';
  static const bookingConfirm = '/booking/confirm';
  static const supportNew = '/support/new';
  static String supportDetail(int id) => '/support/$id';
}
