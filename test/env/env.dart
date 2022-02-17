import 'package:envify/envify.dart';
part 'env.g.dart';

@Envify(path: '.env.test')
abstract class Env {
  static const tezosNodeUrl = _Env.tezosNodeUrl;
  static const originatorSk = _Env.originatorSk;
  static const logLevel = _Env.logLevel;
}
