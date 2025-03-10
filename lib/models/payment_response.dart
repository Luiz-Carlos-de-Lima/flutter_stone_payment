class PaymentResponse {
  final String cardholderName;
  final String itk;
  final String atk;
  final String brand;
  final String authorizationDateTime;
  final String orderId;
  final String authorizationCode;
  final String installmentCount;
  final String pan;
  final String type;
  final String entryMode;
  final String accountId;
  final String customerWalletProviderId;
  final String code;
  final String transactionQualifier;
  final String amount;

  PaymentResponse(
      {required this.cardholderName,
      required this.itk,
      required this.atk,
      required this.brand,
      required this.authorizationDateTime,
      required this.orderId,
      required this.authorizationCode,
      required this.installmentCount,
      required this.pan,
      required this.type,
      required this.entryMode,
      required this.accountId,
      required this.customerWalletProviderId,
      required this.code,
      required this.transactionQualifier,
      required this.amount});

  static PaymentResponse fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      cardholderName: json['cardholder_name'],
      itk: json['itk'],
      atk: json['atk'],
      brand: json['brand'],
      authorizationDateTime: json['authorization_date_time'],
      orderId: json['order_id'],
      authorizationCode: json['authorization_code'],
      installmentCount: json['installment_count'],
      pan: json['pan'],
      type: json['type'],
      entryMode: json['entry_mode'],
      accountId: json['account_id'],
      customerWalletProviderId: json['customer_wallet_provider_id'],
      code: json['code'],
      transactionQualifier: json['transaction_qualifier'],
      amount: json['amount'],
    );
  }
}
