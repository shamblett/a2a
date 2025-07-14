/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// Represents a part of a message, which can be text, a file, or structured data.
sealed class A2APart {}

/// Represents a text segment within parts.
final class A2ATextPart extends A2APart {
  /// Part type - text for TextParts
  final kind = 'text';

  /// Optional metadata associated with the part.
  A2ASV? metadata;

  /// Text content
  String text = '';
}

/// Represents a File segment within parts.
final class A2AFilePart extends A2APart {
  /// Part type - file for TextParts
  final kind = 'file';

  /// Optional metadata associated with the part.
  A2ASV? metadata;

  /// File content either as url or bytes
  A2AFilePartVariant? file;
}

final class A2ADataPart extends A2APart {
  /// Structured data content
  A2ASV data = {};

  /// Part type - data for DataParts
  final kind = 'data';

  /// Optional metadata associated with the part.
  A2ASV? metadata;
}

/// File type variants
sealed class A2AFilePartVariant {}

/// Define the variant where 'bytes' is present and 'uri' is absent
final class FileWithBytes extends A2AFilePartVariant {
  /// base64 encoded content of the file
  String bytes = '';

  /// Optional mimeType for the file
  String mimeTYpe = '';

  /// Optional name for the file
  String name = '';
}

/// Define the variant where 'uri' is present and 'bytes' is absent
final class A2AFileWithUrl extends A2AFilePartVariant {
  /// Optional mimeType for the file
  String mimeTYpe = '';

  /// Optional name for the file
  String name = '';

  /// URL for the File content
  String url = '';
}
