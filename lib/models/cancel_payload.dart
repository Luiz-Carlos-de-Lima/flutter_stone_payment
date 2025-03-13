class CancelPayload {
  final double? amount;
  final String atk;
  final bool editableAmount;

  CancelPayload({required this.amount, required this.atk, this.editableAmount = false});

  Map<String, dynamic> toJson() {
    return {
      'amount': amount is double ? (amount! * 100).toInt().toString() : '0',
      'atk': atk,
      'editable_amount': amount is double ? editableAmount : true,
    };
  }

  static CancelPayload fromJson(Map json) {
    return CancelPayload(
      amount: json['amount'],
      atk: json['atk'],
      editableAmount: json['editable_amount'],
    );
  }
}
