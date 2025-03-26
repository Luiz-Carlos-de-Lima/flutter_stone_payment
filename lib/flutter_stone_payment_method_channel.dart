import 'package:flutter/services.dart';
import 'flutter_stone_payment_platform_interface.dart';

import 'exceptions/stone_cancel_exception.dart';
import 'exceptions/stone_print_exception.dart';
import 'exceptions/stone_reprint_exception.dart';
import 'exceptions/stone_payment_exception.dart';
import 'models/stone_cancel_payload.dart';
import 'models/stone_cancel_response.dart';
import 'models/stone_payment_payload.dart';
import 'models/stone_payment_response.dart';
import 'models/stone_print_payload.dart';
import 'models/stone_reprint_payload.dart';
import 'constants/stone_status_deeplink.dart';

class MethodChannelFlutterStonePayment extends FlutterStonePaymentPlatform {
  final methodChannel = const MethodChannel('flutter_stone_payment');

  @override
  Future<StonePaymentResponse> pay({required StonePaymentPayload paymentPayload}) async {
    try {
      final response = await methodChannel.invokeMethod<Map>('pay', paymentPayload.toJson());
      if (response is Map) {
        if (response['code'] == StoneStatusDeeplink.SUCCESS.name && response['data'] is Map) {
          final jsonData = response['data'];
          return StonePaymentResponse.fromJson(jsonData);
        } else {
          throw StonePaymentException(message: response['message']);
        }
      } else {
        throw StonePaymentException(message: 'invalid response');
      }
    } on StonePaymentException catch (e) {
      throw StonePaymentException(message: e.message);
    } on PlatformException catch (e) {
      throw StonePaymentException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw StonePaymentException(message: "Pay Error: $e");
    }
  }

  @override
  Future<StoneCancelResponse> cancel({required StoneCancelPayload cancelPayload}) async {
    try {
      final response = await methodChannel.invokeMethod<Map>('cancel', cancelPayload.toJson());

      if (response is Map) {
        if (response['code'] == StoneStatusDeeplink.SUCCESS.name && response['data'] is Map) {
          final jsonData = response['data'];
          return StoneCancelResponse.fromJson(jsonData);
        } else {
          throw StoneCancelException(message: response['message']);
        }
      } else {
        throw StoneCancelException(message: 'invalid response');
      }
    } on StoneCancelException catch (e) {
      throw StoneCancelException(message: e.message);
    } on PlatformException catch (e) {
      throw StoneCancelException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw StoneCancelException(message: "Cancel Error: $e");
    }
  }

  @override
  Future<void> print({required StonePrintPayload printPayload}) async {
    try {
      final response = await methodChannel.invokeMethod<Map>('print', printPayload.toJson());

      if (response is Map) {
        if (response['code'] != StoneStatusDeeplink.SUCCESS.name) {
          throw StonePrintException(message: response['message']);
        }
      } else {
        throw StonePrintException(message: 'invalid response');
      }
    } on StonePrintException catch (e) {
      throw StonePrintException(message: e.message);
    } on PlatformException catch (e) {
      throw StonePrintException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw StonePrintException(message: "Print Error: $e");
    }
  }

  @override
  Future<void> reprint({required StoneReprintPayload reprintPayload}) async {
    try {
      final response = await methodChannel.invokeMethod<Map>('reprint', reprintPayload.toJson());

      if (response is Map) {
        if (response['code'] != StoneStatusDeeplink.SUCCESS.name) {
          throw StoneReprintException(message: response['message']);
        }
      } else {
        throw StoneReprintException(message: 'invalid response');
      }
    } on StoneReprintException catch (e) {
      throw StoneReprintException(message: e.message);
    } on PlatformException catch (e) {
      throw StoneReprintException(message: e.message ?? 'PlatformException');
    } catch (e) {
      throw StoneReprintException(message: "reprint Error: $e");
    }
  }
}
