import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'flutter_stone_payment_method_channel.dart';

import 'models/stone_cancel_payload.dart';
import 'models/stone_cancel_response.dart';
import 'models/stone_reprint_payload.dart';
import 'models/stone_payment_payload.dart';
import 'models/stone_payment_response.dart';
import 'models/stone_print_payload.dart';

abstract class FlutterStonePaymentPlatform extends PlatformInterface {
  /// Constructs a FlutterStonePaymentPlatform.
  FlutterStonePaymentPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterStonePaymentPlatform _instance = MethodChannelFlutterStonePayment();

  /// The default instance of [FlutterStonePaymentPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterStonePayment].
  static FlutterStonePaymentPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterStonePaymentPlatform] when
  /// they register themselves.
  static set instance(FlutterStonePaymentPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<StonePaymentResponse> pay({required StonePaymentPayload paymentPayload}) {
    throw UnimplementedError('pay() has not been implemented.');
  }

  Future<StoneCancelResponse> cancel({required StoneCancelPayload cancelPayload}) {
    throw UnimplementedError('cancel() has not been implemented.');
  }

  Future<void> print({required StonePrintPayload printPayload}) {
    throw UnimplementedError('print() has not been implemented.');
  }

  Future<void> reprint({required StoneReprintPayload reprintPayload}) {
    throw UnimplementedError('reprint() has not been implemented.');
  }
}
