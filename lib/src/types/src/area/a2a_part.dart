/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// Represents a part of a message, which can be text, a file, or structured data.
base class A2APart {}

/// Represents a text segment within parts.
final class TextPart extends A2APart {
  /// Part type - text for TextParts
  final kind = 'text';

  /// Optional metadata associated with the part.
  SV? metadata;

  /// Text content
  String text = '';
}

/// Represents a File segment within parts.
final class FilePart extends A2APart {
  /// Part type - file for TextParts
  final kind = 'file';

  /// Optional metadata associated with the part.
  SV? metadata;

  /// File content either as url or bytes
  FilePartVariant? file;
}

final class DataPart extends A2APart {
  /// Structured data content
  SV data = {};

  /// Part type - data for DataParts
  final kind = 'data';

  /// Optional metadata associated with the part.
  SV? metadata;
}

/// File type variants
base class FilePartVariant {}

/// Define the variant where 'bytes' is present and 'uri' is absent
final class FileWithBytes extends FilePartVariant {
  /// base64 encoded content of the file
  String bytes = '';

  /// Optional mimeType for the file
  String mimeTYpe = '';

  /// Optional name for the file
  String name = '';
}

/// Define the variant where 'uri' is present and 'bytes' is absent
final class FileWithUrl extends FilePartVariant {
  /// Optional mimeType for the file
  String mimeTYpe = '';

  /// Optional name for the file
  String name = '';

  /// URL for the File content
  String url = '';
}
