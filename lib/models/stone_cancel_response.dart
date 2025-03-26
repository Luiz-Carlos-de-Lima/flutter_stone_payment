class StoneCancelResponse {
  final String responseCode;
  final String atk;
  final String canceledAmount;
  final String paymentType;
  final String transactionAmount;
  final String orderId;
  final String authorizationCode;
  final String reason;

  StoneCancelResponse(
      {required this.responseCode,
      required this.atk,
      required this.canceledAmount,
      required this.paymentType,
      required this.transactionAmount,
      required this.orderId,
      required this.authorizationCode,
      required this.reason});

  Map<String, dynamic> toJson() {
    return {
      'response_code': responseCode,
      'atk': atk,
      'canceled_amount': canceledAmount,
      'payment_type': paymentType,
      'transaction_amount': transactionAmount,
      'order_id': orderId,
      'authorization_code': authorizationCode,
      'reason': reason,
    };
  }

  static StoneCancelResponse fromJson(Map json) {
    return StoneCancelResponse(
      responseCode: json['response_code'] ?? "response_code is Null",
      atk: json['atk'],
      canceledAmount: json['canceled_amount'] ?? "canceled_amount is Null",
      paymentType: json['payment_type'] ?? "payment_type is Null",
      transactionAmount: json['transaction_amount'] ?? "transaction_amount is Null",
      orderId: json['order_id'] ?? "order_id is Null",
      authorizationCode: json['authorization_code'] ?? "authorization_code is Null",
      reason: json['reason'] ?? "reason is Null",
    );
  }
}
