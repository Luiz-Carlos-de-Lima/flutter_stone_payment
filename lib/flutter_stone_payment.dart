import 'package:flutter_stone_payment/models/stone_device_info.dart';

import 'flutter_stone_payment_platform_interface.dart';

import 'models/stone_cancel_payload.dart';
import 'models/stone_cancel_response.dart';
import 'models/stone_payment_payload.dart';
import 'models/stone_payment_response.dart';
import 'models/stone_reprint_payload.dart';
import 'models/stone_print_payload.dart';

class FlutterStonePayment {
  Future<StonePaymentResponse> pay({required StonePaymentPayload paymentPayload}) {
    return FlutterStonePaymentPlatform.instance.pay(paymentPayload: paymentPayload);
  }

  Future<StoneCancelResponse> cancel({required StoneCancelPayload cancelPayload}) {
    return FlutterStonePaymentPlatform.instance.cancel(cancelPayload: cancelPayload);
  }

  Future<void> print({required StonePrintPayload printPayload}) {
    return FlutterStonePaymentPlatform.instance.print(printPayload: printPayload);
  }

  Future<void> reprint({required StoneReprintPayload reprintPayload}) {
    return FlutterStonePaymentPlatform.instance.reprint(reprintPayload: reprintPayload);
  }

  Future<StoneDeviceInfo> deviceInfo() {
    return FlutterStonePaymentPlatform.instance.deviceInfo();
  }
}
