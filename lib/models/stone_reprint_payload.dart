import 'package:flutter_stone_payment/constants/stone_reprint_type.dart';

class StoneReprintPayload {
  final String atk;
  final StoneTypeCustomer typeCustomer;
  final bool showFeedbackScreen;

  StoneReprintPayload({required this.atk, required this.typeCustomer, required this.showFeedbackScreen});

  Map<String, dynamic> toJson() {
    return {
      'atk': atk,
      'type_customer': typeCustomer.name,
      'show_feedback_screen': showFeedbackScreen,
    };
  }

  static StoneReprintPayload fromJson(Map json) {
    return StoneReprintPayload(
      atk: json['atk'],
      typeCustomer: StoneTypeCustomer.values.firstWhere((e) => e.name == json['type_customer'], orElse: () => StoneTypeCustomer.MERCHANT),
      showFeedbackScreen: json['show_feedback_screen'],
    );
  }
}
