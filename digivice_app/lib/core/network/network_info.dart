import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@Injectable(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl();

  @override
  Future<bool> get isConnected async {
    //faltan implementaciones
    return true;
  }
}
