import 'package:flutter_stone_payment/constants/print_content_types.dart';

class Contentprint {
  final PrintType type;
  final String? content;
  final PrintAlign? align;
  final PrintSize? size;
  final String? imagePath;

  Contentprint({
    required this.type,
    this.content,
    this.align,
    this.size,
    this.imagePath,
  })  : assert(
            !(type == PrintType.text && content == null && align == null && size == null), "content and align and size must be null when type is equal text"),
        assert(!(type == PrintType.image && imagePath == null), "imagePath cannot null when type is equal image"),
        assert(!(type == PrintType.line && content == null), "content cannot null when type is equal line"),
        assert(!(type == PrintType.line && align == null && size == null), "align and size must be null when type is equal line");

  Map<String, dynamic> toJson() {
    return {
      'type': type.name.toString(),
      'content': content,
      'align': align?.name.toString(),
      'size': size?.name.toString(),
      'imagePath': imagePath,
    };
  }

  static Contentprint fromJson(Map<String, dynamic> json) {
    return Contentprint(
      type: PrintType.values.firstWhere((e) => e.name == json['type']),
      content: json['content'],
      align: json['align'] != null ? PrintAlign.values.firstWhere((e) => e.name == json['align']) : null,
      size: json['size'] != null ? PrintSize.values.firstWhere((e) => e.name == json['size']) : null,
      imagePath: json['imagePath'],
    );
  }
}
