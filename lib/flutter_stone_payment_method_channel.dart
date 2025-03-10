import 'package:flutter/services.dart';

import 'package:flutter_stone_payment/models/payment_payload.dart';
import 'package:flutter_stone_payment/models/payment_response.dart';

import 'flutter_stone_payment_platform_interface.dart';

class MethodChannelFlutterStonePayment extends FlutterStonePaymentPlatform {
  MethodChannel? methodChannel;

  @override
  Future<PaymentResponse> pay({required PaymentPayload paymentPayload}) async {
    try {
      methodChannel = const MethodChannel('flutter_stone_payment');

      final json = await methodChannel?.invokeMethod<Map>('pay', paymentPayload.toJson());

      print(json);

      return PaymentResponse(
          cardholderName: '',
          itk: '',
          atk: '',
          brand: '',
          authorizationDateTime: '',
          orderId: 'orderId',
          authorizationCode: 'authorizationCode',
          installmentCount: 'installmentCount',
          pan: 'pan',
          type: 'type',
          entryMode: 'entryMode',
          accountId: 'accountId',
          customerWalletProviderId: 'customerWalletProviderId',
          code: 'code',
          transactionQualifier: 'transactionQualifier',
          amount: '1000');
      // if (json is Map) {
      //   if (json['code'] == PaymentError.SUCCESS.name) {
      //      return PaymentResponse(
      //       cardholderName: '',
      //       itk: '',
      //       atk: '',
      //       brand: '',
      //       authorizationDateTime: '',
      //       orderId: 'orderId',
      //       authorizationCode: 'authorizationCode',
      //       installmentCount: 'installmentCount',
      //       pan: 'pan',
      //       type: 'type',
      //       entryMode: 'entryMode',
      //       accountId: 'accountId',
      //       customerWalletProviderId: 'customerWalletProviderId',
      //       code: 'code',
      //       transactionQualifier: 'transactionQualifier',
      //       amount: '1000');
      //   } else if () {

      //   }

      // } else {
      //   throw PaymentException(message: 'Invalid response');
      // }
    } catch (e) {
      throw Exception(e);
    } finally {
      methodChannel?.setMethodCallHandler(null);
    }
  }
}
