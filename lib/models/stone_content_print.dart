import 'package:flutter_stone_payment/constants/stone_print_content_types.dart';

class StoneContentprint {
  final StonePrintType type;
  final String? content;
  final StonePrintAlign? align;
  final StonePrintSize? size;
  final String? imagePath;

  StoneContentprint({
    required this.type,
    this.content,
    this.align,
    this.size,
    this.imagePath,
  })  : assert(
          type != StonePrintType.text || (content is String && align is StonePrintAlign && size is StonePrintSize),
          "content, align, and size must be defined when type is text",
        ),
        assert(
          type != StonePrintType.image || imagePath is String,
          "imagePath cannot be null when type is image",
        ),
        assert(
          type != StonePrintType.line || content is String,
          "content cannot be null when type is line",
        );

  Map<String, dynamic> toJson() {
    bool disableAlignAndSize = type != StonePrintType.text;

    return {
      'type': type.name.toString(),
      'content': type != StonePrintType.image ? content : null,
      'align': disableAlignAndSize ? null : align?.name.toString(),
      'size': disableAlignAndSize ? null : size?.name.toString(),
      'imagePath': type == StonePrintType.image ? imagePath : null,
    };
  }

  static StoneContentprint fromJson(Map<String, dynamic> json) {
    return StoneContentprint(
      type: StonePrintType.values.firstWhere((e) => e.name == json['type']),
      content: json['content'],
      align: json['align'] != null ? StonePrintAlign.values.firstWhere((e) => e.name == json['align']) : null,
      size: json['size'] != null ? StonePrintSize.values.firstWhere((e) => e.name == json['size']) : null,
      imagePath: json['imagePath'],
    );
  }
}
