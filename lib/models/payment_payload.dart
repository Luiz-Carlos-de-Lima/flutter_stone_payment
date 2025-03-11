import 'package:flutter_stone_payment/constants/installment_type.dart';
import 'package:flutter_stone_payment/constants/transaction_type.dart';

class PaymentPayload {
  final double? amount;
  final TransactionType? transactionType;
  final InstallmentType? installmentType;
  final int? installmentCount;
  final bool? editableAmount;
  final String orderId;

  PaymentPayload({required this.amount, required this.transactionType, this.installmentType, this.installmentCount, this.editableAmount, required this.orderId})
      : assert(!(transactionType == TransactionType.CREDIT && installmentType == null && installmentCount == null),
            'InstallmentType and InstallmentCount must be provided for CREDIT transactionType'),
        assert(!(transactionType == TransactionType.CREDIT && installmentCount == 0), 'InstallmentCount must be greater than 0 for CREDIT transactionType'),
        assert(
            !((transactionType == TransactionType.DEBIT ||
                    transactionType == TransactionType.INSTANT_PAYMENT ||
                    transactionType == TransactionType.VOUCHER ||
                    transactionType == TransactionType.PIX) &&
                installmentType != null &&
                installmentCount != null),
            'installmentType and installmentCount must be null for DEBIT, INSTANT_PAYMENT, VOUCHER and PIX transactionType');

  Map<String, dynamic> toJson() {
    return {
      'amount': amount is double ? (amount! * 100).toInt().toString() : null,
      'transactionType': transactionType?.name,
      'installmentType': installmentType?.name,
      'installmentCount': installmentCount?.toString(),
      'editableAmount': amount is double ? editableAmount : true,
      'orderId': orderId,
    };
  }

  static PaymentPayload fromJson(Map<String, dynamic> json) {
    return PaymentPayload(
      amount: json['amount'],
      transactionType: json['transactionType'],
      installmentType: json['installmentType'],
      installmentCount: json['installmentCount'],
      editableAmount: json['editableAmount'],
      orderId: json['orderId'],
    );
  }
}
