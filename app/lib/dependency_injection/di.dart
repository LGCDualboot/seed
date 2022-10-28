
import 'package:app/data/data_providers/authentication_api.dart';
import 'package:app/utils/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

enum Enviroment {
  DEV,
  PROD,
  QA
}

abstract class DependencyInjection {
  Future<void> init() async {

    GetIt getIt = GetIt.instance;

    const storage = SecureStorage();
    final token = await storage.read("token");
    final refreshToken = await storage.read("refreshToken");

    final Dio dio = Dio();

    getIt.registerSingleton<Dio>(dio);
    getIt.registerSingleton<ISecureStorage>(storage);
    getIt.registerSingleton<String>(token ?? "", instanceName: "token");
    getIt.registerSingleton<String>(refreshToken ?? "",
        instanceName: "refreshToken");


    //APIS
    getIt.registerFactory<AuthenticationApi>(
            () => AuthenticationApi(getIt<Dio>()));
    
  }
}

class DependencyInjectionDEV extends DependencyInjection {

  @override
  Future<void> init() {
    print("INIT CHILD DEV");
    return super.init();
  }
}

class DependencyInjectionPROD extends DependencyInjection {

  @override
  Future<void> init() {
    print("INIT CHILD PROD");
    return super.init();
  }
}

class DependencyInjectionQA extends DependencyInjection {

  @override
  Future<void> init() {
    print("INIT CHILD QA");
    return super.init();
  }
}

abstract class DependencyInjectionConfig {

  static Future<void> init(Enviroment env) async {
    switch(env){

      case Enviroment.DEV:
        await DependencyInjectionDEV().init();
        break;
      case Enviroment.PROD:
        await DependencyInjectionPROD().init();
        break;
      case Enviroment.QA:
        await DependencyInjectionQA().init();
        break;
    }
  }

}
