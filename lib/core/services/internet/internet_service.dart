import 'package:connectivity_plus/connectivity_plus.dart';

class InternetService {
  Future<bool> hasConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
