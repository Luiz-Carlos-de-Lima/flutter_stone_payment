import 'package:flutter/services.dart';

import 'package:flutter_stone_payment/models/payment_payload.dart';
import 'package:flutter_stone_payment/models/payment_response.dart';

import 'constants/payment_error.dart';
import 'exceptions/payment_exception.dart';
import 'flutter_stone_payment_platform_interface.dart';

class MethodChannelFlutterStonePayment extends FlutterStonePaymentPlatform {
  final methodChannel = const MethodChannel('flutter_stone_payment');

  @override
  Future<PaymentResponse> pay({required PaymentPayload paymentPayload}) async {
    try {
      final response = await methodChannel?.invokeMethod<Map>('pay', paymentPayload.toJson());

      if (response is Map) {
        if (response['code'] == PaymentError.SUCCESS.name) {
          final jsonData = response['data'];
          return PaymentResponse.fromJson(jsonData);
        } else {
          throw PaymentException(message: response['message']);
        }
      } else {
        throw PaymentException(message: 'invalid response');
      }
    } on PaymentException catch (e) {
      throw PaymentException(message: e.message);
    } on PlatformException catch (e) {
      throw PaymentException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw PaymentException(message: e.toString());
    }
  }
}
