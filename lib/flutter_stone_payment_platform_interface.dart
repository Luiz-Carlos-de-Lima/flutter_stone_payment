import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_stone_payment_method_channel.dart';
import 'models/payment_payload.dart';
import 'models/payment_response.dart';

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

  Future<PaymentResponse> pay({required PaymentPayload paymentPayload}) {
    throw UnimplementedError('pay() has not been implemented.');
  }
}
