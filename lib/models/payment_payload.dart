import 'package:flutter_stone_payment/constants/installment_type.dart';
import 'package:flutter_stone_payment/constants/transaction_type.dart';

class PaymentPayload {
  final double? amount;
  final TransactionType? transactionType;
  final InstallmentType? installmentType;
  final int? installmentCount;
  final bool editableAmount;
  final String orderId;

  PaymentPayload({
    this.amount,
    this.transactionType,
    this.installmentType,
    this.installmentCount,
    this.editableAmount = false,
    required this.orderId,
  })  : assert(
          transactionType == TransactionType.CREDIT || (installmentType == null && installmentCount == null),
          'installmentType and installmentCount must be null for DEBIT, INSTANT_PAYMENT, VOUCHER, and PIX transactionType.',
        ),
        assert(
          transactionType != TransactionType.CREDIT ||
              (installmentType == null && installmentCount == null) || // Pode ser null
              (installmentType == InstallmentType.NONE && (installmentCount == null || installmentCount == 1)) || // NONE: null ou 1
              ((installmentType == InstallmentType.MERCHANT || installmentType == InstallmentType.ISSUER) &&
                  (installmentCount == null || installmentCount > 1)), // MERCHANT/ISSUER: null ou maior que 1
          'For CREDIT transactions: installmentType can be null, but if it is NONE, installmentCount must be null or 1; '
          'if it is MERCHANT or ISSUER, installmentCount must be null or greater than 1.',
        );

  Map<String, dynamic> toJson() {
    return {
      'amount': amount is double ? (amount! * 100).toInt().toString() : '0',
      'transaction_type': transactionType?.name,
      'installment_type': transactionType == TransactionType.CREDIT ? installmentType?.name : null,
      'installment_count': transactionType == TransactionType.CREDIT && installmentType != null ? installmentCount?.toString() : null,
      'editable_amount': amount is double ? editableAmount : true,
      'order_id': orderId,
    };
  }

  static PaymentPayload fromJson(Map json) {
    return PaymentPayload(
      amount: json['amount'],
      transactionType: TransactionType.values.firstWhere((e) => e.name == json['transaction_type']),
      installmentType: json['installment_type'] != null ? InstallmentType.values.firstWhere((e) => e.name == json['installment_type']) : null,
      installmentCount: json['installment_count'],
      editableAmount: json['editable_amount'],
      orderId: json['order_id'],
    );
  }
}
