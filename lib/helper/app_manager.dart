import 'package:practical_manektech/helper/sql_helper.dart';

import 'internet_helper.dart';

class AppManager {
  final NetworkHelper _networkHelper = NetworkHelper();
  final SqlHelper _sqlHelper = SqlHelper();
  static AppManager? _instance;

  static AppManager? getInstance() {
    _instance ??= AppManager();
    return _instance;
  }

  NetworkHelper getNetworkHelper() {
    return _networkHelper;
  }

  SqlHelper getSqlHelper() {
    return _sqlHelper;
  }

  initialiseNetworkHelper() async {
    await _networkHelper.init();
  }

  initialiseDatabase() async {
    await _sqlHelper.init();
  }
}
