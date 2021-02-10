import 'package:meta/meta.dart';

import 'package:tezart/src/common/exceptions/common_exception.dart';
import 'package:tezart/src/common/utils/enum_util.dart';
import 'package:tezart/src/common/utils/map_utils.dart';
import 'package:tezart/src/core/rpc/rpc_interface.dart';

enum TezartNodeErrorTypes {
  already_revealed_key,
  monitoring_timed_out,
  unhandled,
}

class TezartNodeError extends CommonException {
  final TezartHttpError cause;
  final TezartNodeErrorTypes _inputType;
  final String _inputMessage;
  final Map<String, String> metadata;

  final staticErrorsMessages = {
    TezartNodeErrorTypes.already_revealed_key: "You're trying to reveal an already revealed key.",
    TezartNodeErrorTypes.unhandled: 'Unhandled error',
  };

  final dynamicErrorMessages = {
    TezartNodeErrorTypes.monitoring_timed_out: (String operationId) => 'Monitoring the operation $operationId timedout',
  };

  TezartNodeError({@required TezartNodeErrorTypes type, String message, this.metadata})
      : _inputType = type,
        _inputMessage = message,
        cause = null;
  TezartNodeError.fromHttpError(this.cause)
      : _inputType = null,
        _inputMessage = null,
        metadata = null;

  TezartNodeErrorTypes get type => _inputType ?? _computedType;

  @override
  String get message => _inputMessage ?? _computedMessage;

  TezartNodeErrorTypes get _computedType {
    if (RegExp(r'previously_revealed_key').hasMatch(errorId)) return TezartNodeErrorTypes.already_revealed_key;

    return TezartNodeErrorTypes.unhandled;
  }

  // TODO: what to do when there is multiple errors ?
  String get errorId => cause?.responseBody?.first['id'];

  @override
  String get key => EnumUtil.enumToString(type);

  String get _computedMessage {
    if (staticErrorsMessages.containsKey(type)) return staticErrorsMessages[type];

    switch (type) {
      case TezartNodeErrorTypes.monitoring_timed_out:
        {
          return dynamicErrorMessages[type](MapUtils.fetch(
            map: metadata,
            key: 'operationId',
          ));
        }
        break;
      default:
        {
          throw UnimplementedError('Unimplemented error type $type');
        }
        break;
    }
  }

  @override
  TezartHttpError get originalException => cause;
}
