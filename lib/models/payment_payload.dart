import 'package:flutter_stone_payment/constants/installment_type.dart';
import 'package:flutter_stone_payment/constants/transaction_type.dart';

class PaymentPayload {
  final double amount;
  final TransactionType transactionType;
  final InstallmentType? installmentType;
  final int? installmentCount;
  final String orderId;

  PaymentPayload({required this.amount, required this.transactionType, this.installmentType, this.installmentCount, required this.orderId})
      : assert(!(transactionType == TransactionType.CREDIT && installmentType == null && installmentCount == null),
            'InstallmentType and InstallmentCount must be provided for CREDIT transactionType');

  Map<String, dynamic> toJson() {
    return {
      'amount': (amount * 100).toInt().toString(),
      'transactionType': transactionType.name,
      'installmentType': installmentType?.name,
      'installmentCount': installmentCount?.toString(),
      'orderId': orderId,
    };
  }

  static PaymentPayload fromJson(Map<String, dynamic> json) {
    return PaymentPayload(
      amount: json['amount'],
      transactionType: json['transactionType'],
      installmentType: json['installmentType'],
      installmentCount: json['installmentCount'],
      orderId: json['orderId'],
    );
  }
}
