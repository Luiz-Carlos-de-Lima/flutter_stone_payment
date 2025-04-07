class StonePaymentResponse {
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

  StonePaymentResponse(
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

  static StonePaymentResponse fromJson(Map json) {
    return StonePaymentResponse(
      cardholderName: json['cardholder_name'] ?? "cardholder_name is Null",
      itk: json['itk'] ?? "itk is Null",
      atk: json['atk'] ?? "atk is Null",
      brand: json['brand'] ?? "brand is Null",
      authorizationDateTime: json['authorization_date_time'] ?? "authorization_date_time is Null",
      orderId: json['order_id'] ?? "order_id is Null",
      authorizationCode: json['authorization_code'] ?? "authorization_code is Null",
      installmentCount: json['installment_count'] ?? "installment_count is Null",
      pan: json['pan'] ?? "pan is Null",
      type: json['type'] ?? "type is Null",
      entryMode: json['entry_mode'] ?? "entry_mode is Null",
      accountId: json['account_id'] ?? "account_id is Null",
      customerWalletProviderId: json['customer_wallet_provider_id'] ?? "customer_wallet_provider_id is Null",
      code: json['code'] ?? "code is Null",
      transactionQualifier: json['transaction_qualifier'] ?? "transaction_qualifier is Null",
      amount: json['amount'] ?? "amount is Null",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardholder_name': cardholderName,
      'itk': itk,
      'atk': atk,
      'brand': brand,
      'authorization_date_time': authorizationDateTime,
      'order_id': orderId,
      'authorization_code': authorizationCode,
      'installment_count': installmentCount,
      'pan': pan,
      'type': type,
      'entry_mode': entryMode,
      'account_id': accountId,
      'customer_wallet_provider_id': customerWalletProviderId,
      'code': code,
      'transaction_qualifier': transactionQualifier,
      'amount': amount,
    };
  }
}
