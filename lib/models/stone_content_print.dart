import 'package:flutter_stone_payment/constants/stone_print_content_types.dart';

class StoneContentprint {
  final StonePrintType type;
  final String? content;
  final StonePrintAlign? align;
  final StonePrintSize? size;
  final String? imagePath;
  final bool ignoreLineBreak;

  StoneContentprint({required this.type, this.content, this.align, this.size, this.imagePath, this.ignoreLineBreak = false})
      : assert(
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
      'content': type != StonePrintType.image ? _formatContent() : null,
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

  /// Método para formatar o conteúdo evitando cortes no meio das palavras e tratando palavras maiores que o limite da linha.
  String _formatContent() {
    if (ignoreLineBreak == true) {
      return content ?? '';
    }
    if (type == StonePrintType.image || content == null || size == null) return content ?? '';

    int maxLength = _getMaxLength(size!);
    List<String> lines = [];
    List<String> words = content!.split(' ');
    String currentLine = '';

    for (var word in words) {
      if (word.length > maxLength) {
        // Se a palavra for maior que o limite da linha, quebra a palavra
        if (currentLine.isNotEmpty) {
          lines.add(currentLine);
          currentLine = '';
        }

        // Divide a palavra em partes do tamanho máximo permitido
        for (int i = 0; i < word.length; i += maxLength) {
          lines.add(word.substring(i, (i + maxLength) > word.length ? word.length : (i + maxLength)));
        }
      } else if (currentLine.isEmpty) {
        currentLine = word;
      } else if ((currentLine.length + word.length + 1) <= maxLength) {
        currentLine += ' $word';
      } else {
        lines.add(currentLine);
        currentLine = word;
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return lines.join("\n");
  }

  /// Retorna o tamanho máximo de caracteres permitido para cada tamanho de impressão
  int _getMaxLength(StonePrintSize size) {
    switch (size) {
      case StonePrintSize.small:
        return 48;
      case StonePrintSize.medium:
      case StonePrintSize.big:
        return 32;
    }
  }
}
