import 'package:flutter/services.dart';
import 'package:flutter_stone_payment/exceptions/cancel_exception.dart';
import 'package:flutter_stone_payment/models/cancel_payload.dart';
import 'package:flutter_stone_payment/models/cancel_response.dart';

import 'package:flutter_stone_payment/models/payment_payload.dart';
import 'package:flutter_stone_payment/models/payment_response.dart';
import 'package:flutter_stone_payment/models/print_payload.dart';
import 'package:flutter_stone_payment/models/reprint_payload.dart';

import 'constants/status_deeplink.dart';
import 'exceptions/payment_exception.dart';
import 'flutter_stone_payment_platform_interface.dart';

class MethodChannelFlutterStonePayment extends FlutterStonePaymentPlatform {
  final methodChannel = const MethodChannel('flutter_stone_payment');

  @override
  Future<PaymentResponse> pay({required PaymentPayload paymentPayload}) async {
    try {
      final response = await methodChannel.invokeMethod<Map>('pay', paymentPayload.toJson());

      if (response is Map) {
        if (response['code'] == StatusDeeplink.SUCCESS.name) {
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

  @override
  Future<CancelResponse> cancel({required CancelPayload cancelPayload}) async {
    try {
      final response = await methodChannel.invokeMethod<Map>('cancel', cancelPayload.toJson());

      if (response is Map) {
        if (response['code'] == StatusDeeplink.SUCCESS.name) {
          final jsonData = response['data'];
          return CancelResponse.fromJson(jsonData);
        } else {
          throw CancelException(message: response['message']);
        }
      } else {
        throw CancelException(message: 'invalid response');
      }
    } on CancelException catch (e) {
      throw CancelException(message: e.message);
    } on PlatformException catch (e) {
      throw CancelException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw CancelException(message: e.toString());
    }
  }

  @override
  Future<void> print({required PrintPayload printPayload}) async {
    try {
      final response = await methodChannel.invokeMethod<Map>('print', printPayload.toJson());

      if (response is Map) {
        if (response['code'] != StatusDeeplink.SUCCESS.name) {
          throw CancelException(message: response['message']);
        }
      } else {
        throw CancelException(message: 'invalid response');
      }
    } on CancelException catch (e) {
      throw CancelException(message: e.message);
    } on PlatformException catch (e) {
      throw CancelException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw CancelException(message: e.toString());
    }
  }

  @override
  Future<void> reprint({required ReprintPayload reprintPayload}) async {
    try {
      final response = await methodChannel.invokeMethod<Map>('reprint', reprintPayload.toJson());

      if (response is Map) {
        if (response['code'] != StatusDeeplink.SUCCESS.name) {
          throw CancelException(message: response['message']);
        }
      } else {
        throw CancelException(message: 'invalid response');
      }
    } on CancelException catch (e) {
      throw CancelException(message: e.message);
    } on PlatformException catch (e) {
      throw CancelException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw CancelException(message: e.toString());
    }
  }
}
