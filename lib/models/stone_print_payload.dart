import 'package:flutter_stone_payment/models/stone_content_print.dart';

class StonePrintPayload {
  final bool showFeedbackScreen;
  final List<StoneContentprint> printableContent;

  StonePrintPayload({required this.showFeedbackScreen, required this.printableContent});

  Map<String, dynamic> toJson() {
    return {
      'show_feedback_screen': showFeedbackScreen,
      'printable_content': printableContent.map((e) => e.toJson()).toList(),
    };
  }

  static StonePrintPayload fromJson(Map json) {
    return StonePrintPayload(
      showFeedbackScreen: json['show_feedback_screen'],
      printableContent: json['printable_content'].map<StoneContentprint>((e) => StoneContentprint.fromJson(e)).toList(),
    );
  }
}
