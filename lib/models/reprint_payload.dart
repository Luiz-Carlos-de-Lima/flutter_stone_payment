import 'package:flutter_stone_payment/constants/reprint_type.dart';

class ReprintPayload {
  final String atk;
  final TypeCustomer typeCustomer;
  final bool showFeedbackScreen;

  ReprintPayload({required this.atk, required this.typeCustomer, required this.showFeedbackScreen});

  Map<String, dynamic> toJson() {
    return {
      'atk': atk,
      'type_customer': typeCustomer.name,
      'show_feedback_screen': showFeedbackScreen,
    };
  }

  static ReprintPayload fromJson(Map<String, dynamic> json) {
    return ReprintPayload(
      atk: json['atk'],
      typeCustomer: TypeCustomer.values.firstWhere((e) => e.name == json['type_customer'], orElse: () => TypeCustomer.MERCHANT),
      showFeedbackScreen: json['show_feedback_screen'],
    );
  }
}
