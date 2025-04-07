class StoneCancelPayload {
  final double? amount;
  final String atk;
  final bool editableAmount;

  StoneCancelPayload({required this.amount, required this.atk, this.editableAmount = false});

  Map<String, dynamic> toJson() {
    return {
      'amount': amount is double ? (amount! * 100).toInt().toString() : '0',
      'atk': atk,
      'editable_amount': amount is double ? editableAmount : true,
    };
  }

  static StoneCancelPayload fromJson(Map json) {
    return StoneCancelPayload(
      amount: json['amount'],
      atk: json['atk'],
      editableAmount: json['editable_amount'],
    );
  }
}
