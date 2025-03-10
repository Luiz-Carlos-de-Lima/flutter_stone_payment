import 'flutter_stone_payment_platform_interface.dart';
import 'models/payment_payload.dart';
import 'models/payment_response.dart';

class FlutterStonePayment {
  Future<PaymentResponse> pay({required PaymentPayload paymentPayload}) {
    return FlutterStonePaymentPlatform.instance.pay(paymentPayload: paymentPayload);
  }
}
