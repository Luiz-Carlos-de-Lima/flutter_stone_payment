import 'package:flutter_stone_payment/constants/installment_type.dart';
import 'package:flutter_stone_payment/constants/transaction_type.dart';

class PaymentPayload {
  final double? amount;
  final TransactionType? transactionType;
  final InstallmentType? installmentType;
  final int? installmentCount;
  final bool editableAmount;
  final String orderId;

  PaymentPayload({this.amount, this.transactionType, this.installmentType, this.installmentCount, this.editableAmount = false, required this.orderId})
      : assert(
          !(transactionType == TransactionType.CREDIT &&
              (installmentType == InstallmentType.MERCHANT || installmentType == InstallmentType.ISSUER) &&
              (installmentCount == null || installmentCount <= 1)),
          'installmentCount must be greater than 1 when installmentType is MERCHANT or ISSUER for CREDIT transactionType.',
        ),
        assert(
          !(transactionType == TransactionType.CREDIT && installmentType == InstallmentType.NONE && (installmentCount != null && installmentCount != 1)),
          'installmentCount must be 1 or null when installmentType is NONE for CREDIT transactionType.',
        ),
        assert(
          !(transactionType != TransactionType.CREDIT && (installmentType != null || installmentCount != null)),
          'installmentType and installmentCount must be null for DEBIT, INSTANT_PAYMENT, VOUCHER, and PIX transactionType.',
        );
  Map<String, dynamic> toJson() {
    return {
      'amount': amount is double ? (amount! * 100).toInt().toString() : '0',
      'transaction_type': transactionType?.name,
      'installment_type': installmentType?.name,
      'installment_count': installmentType != null ? installmentCount?.toString() : null,
      'editable_amount': amount is double ? editableAmount : true,
      'order_id': orderId,
    };
  }

  static PaymentPayload fromJson(Map<String, dynamic> json) {
    return PaymentPayload(
      amount: json['amount'],
      transactionType: TransactionType.values.firstWhere((e) => e.name == json['transaction_type']),
      installmentType: InstallmentType.values.firstWhere((e) => e.name == json['installment_type']),
      installmentCount: json['installment_count'],
      editableAmount: json['editable_amount'],
      orderId: json['order_id'],
    );
  }
}
