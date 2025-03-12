class CancelResponse {
  final String responseCode;
  final String atk;
  final String canceledAmount;
  final String paymentType;
  final String transactionAmount;
  final String orderId;
  final String authorizationCode;
  final String reason;

  CancelResponse(
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

  static CancelResponse fromJson(Map<String, dynamic> json) {
    return CancelResponse(
      responseCode: json['response_code'],
      atk: json['atk'],
      canceledAmount: json['canceled_amount'],
      paymentType: json['payment_type'],
      transactionAmount: json['transaction_amount'],
      orderId: json['order_id'],
      authorizationCode: json['authorization_code'],
      reason: json['reason'],
    );
  }
}
