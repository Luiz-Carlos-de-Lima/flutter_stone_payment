import 'flutter_stone_payment_platform_interface.dart';
import 'models/cancel_payload.dart';
import 'models/cancel_response.dart';
import 'models/payment_payload.dart';
import 'models/payment_response.dart';
import 'models/print_payload.dart';
import 'models/reprint_payload.dart';

class FlutterStonePayment {
  Future<PaymentResponse> pay({required PaymentPayload paymentPayload}) {
    return FlutterStonePaymentPlatform.instance.pay(paymentPayload: paymentPayload);
  }

  Future<CancelResponse> cancel({required CancelPayload cancelPayload}) {
    return FlutterStonePaymentPlatform.instance.cancel(cancelPayload: cancelPayload);
  }

  Future<void> print({required PrintPayload printPayload}) {
    return FlutterStonePaymentPlatform.instance.print(printPayload: printPayload);
  }

  Future<void> reprint({required ReprintPayload reprintPayload}) {
    return FlutterStonePaymentPlatform.instance.reprint(reprintPayload: reprintPayload);
  }
}
