import 'package:tezart/tezart.dart';
import '../env/env.dart';
import './log_failed_tests.dart';

TezartClient testClient() {
  logFailedTests();
  return TezartClient(Env.tezosNodeUrl);
}
