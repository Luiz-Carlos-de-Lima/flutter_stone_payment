import 'package:flutter_stone_payment/constants/print_content_types.dart';

class Contentprint {
  final Type type;
  final String? content;
  final Align? align;
  final Size? size;
  final String? imagePath;

  Contentprint({
    required this.type,
    this.content,
    this.align,
    this.size,
    this.imagePath,
  })  : assert(type == Type.text && content != null && align != null && size != null, "content and align and size must be null when type is equal text"),
        assert(type == Type.image && imagePath != null, "imagePath cannot null when type is equal image"),
        assert(type == Type.line && content != null, "content cannot null when type is equal line"),
        assert(type == Type.line && align == null && size == null, "align and size must be null when type is equal line");

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
      type: Type.values.firstWhere((e) => e.name == json['type']),
      content: json['content'],
      align: json['align'] != null ? Align.values.firstWhere((e) => e.name == json['align']) : null,
      size: json['size'] != null ? Size.values.firstWhere((e) => e.name == json['size']) : null,
      imagePath: json['imagePath'],
    );
  }
}
