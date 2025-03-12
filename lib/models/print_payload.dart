import 'package:flutter_stone_payment/models/contentPrint.dart';

class PrintPayload {
  final bool showFeedbackScreen;
  final List<Contentprint> printableContent;

  PrintPayload({required this.showFeedbackScreen, required this.printableContent});

  Map<String, dynamic> toJson() {
    return {
      'show_feedback_screen': showFeedbackScreen,
      'printable_content': printableContent.map((e) => e.toJson()).toList(),
    };
  }

  static PrintPayload fromJson(Map<String, dynamic> json) {
    return PrintPayload(
      showFeedbackScreen: json['show_feedback_screen'],
      printableContent: json['printable_content'].map<Contentprint>((e) => Contentprint.fromJson(e)).toList(),
    );
  }
}
