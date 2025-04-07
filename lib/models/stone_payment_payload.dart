import 'package:flutter_stone_payment/constants/stone_installment_type.dart';
import 'package:flutter_stone_payment/constants/stone_transaction_type.dart';

class StonePaymentPayload {
  final double? amount;
  final StoneTransactionType? transactionType;
  final StoneInstallmentType? installmentType;
  final int? installmentCount;
  final bool editableAmount;
  final String orderId;

  StonePaymentPayload({
    this.amount,
    this.transactionType,
    this.installmentType,
    this.installmentCount,
    this.editableAmount = false,
    required this.orderId,
  })  : assert(
          transactionType == StoneTransactionType.CREDIT || (installmentType == null && installmentCount == null),
          'installmentType and installmentCount must be null for DEBIT, INSTANT_PAYMENT, VOUCHER, and PIX transactionType.',
        ),
        assert(
          transactionType != StoneTransactionType.CREDIT ||
              (installmentType == null && installmentCount == null) || // Pode ser null
              (installmentType == StoneInstallmentType.NONE && (installmentCount == null || installmentCount == 1)) || // NONE: null ou 1
              ((installmentType == StoneInstallmentType.MERCHANT || installmentType == StoneInstallmentType.ISSUER) &&
                  (installmentCount == null || installmentCount > 1)), // MERCHANT/ISSUER: null ou maior que 1
          'For CREDIT transactions: installmentType can be null, but if it is NONE, installmentCount must be null or 1; '
          'if it is MERCHANT or ISSUER, installmentCount must be null or greater than 1.',
        );

  Map<String, dynamic> toJson() {
    return {
      'amount': amount is double ? (amount! * 100).toInt().toString() : '0',
      'transaction_type': transactionType?.name,
      'installment_type': transactionType == StoneTransactionType.CREDIT ? installmentType?.name : null,
      'installment_count': transactionType == StoneTransactionType.CREDIT && installmentType != null ? installmentCount?.toString() : null,
      'editable_amount': amount is double ? editableAmount : true,
      'order_id': orderId,
    };
  }

  static StonePaymentPayload fromJson(Map json) {
    return StonePaymentPayload(
      amount: json['amount'],
      transactionType: StoneTransactionType.values.firstWhere((e) => e.name == json['transaction_type']),
      installmentType: json['installment_type'] != null ? StoneInstallmentType.values.firstWhere((e) => e.name == json['installment_type']) : null,
      installmentCount: json['installment_count'],
      editableAmount: json['editable_amount'],
      orderId: json['order_id'],
    );
  }
}
