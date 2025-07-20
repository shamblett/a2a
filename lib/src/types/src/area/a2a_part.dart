/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// Represents a part of a message, which can be text, a file, or structured data.
class A2APart {
  A2APart();

  factory A2APart.fromJson(Map<String, dynamic> json) => A2APart();

  Map<String, dynamic> toJson() => {};
}

/// Represents a text segment within parts.
@JsonSerializable(explicitToJson: true)
final class A2ATextPart extends A2APart {
  /// Part type - text for TextParts
  String kind = 'text';

  /// Optional metadata associated with the part.
  A2ASV? metadata;

  /// Text content
  String text = '';

  A2ATextPart();

  factory A2ATextPart.fromJson(Map<String, dynamic> json) =>
      _$A2ATextPartFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ATextPartToJson(this);
}

/// Represents a File segment within parts.
@JsonSerializable(explicitToJson: true)
final class A2AFilePart extends A2APart {
  /// Part type - file for TextParts
  String kind = 'file';

  /// Optional metadata associated with the part.
  A2ASV? metadata;

  /// File content either as url or bytes
  A2AFilePartVariant? file;

  A2AFilePart();

  factory A2AFilePart.fromJson(Map<String, dynamic> json) =>
      _$A2AFilePartFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AFilePartToJson(this);
}

/// Represents a Data segment within parts.
@JsonSerializable(explicitToJson: true)
final class A2ADataPart extends A2APart {
  /// Structured data content
  A2ASV data = {};

  /// Part type - data for DataParts
  String kind = 'data';

  /// Optional metadata associated with the part.
  A2ASV? metadata;

  A2ADataPart();

  factory A2ADataPart.fromJson(Map<String, dynamic> json) =>
      _$A2ADataPartFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ADataPartToJson(this);
}

/// File type variants
class A2AFilePartVariant {
  A2AFilePartVariant();

  factory A2AFilePartVariant.fromJson(Map<String, dynamic> json) =>
      A2AFilePartVariant();

  Map<String, dynamic> toJson() => {};
}

/// Define the variant where 'bytes' is present and 'uri' is absent
@JsonSerializable(explicitToJson: true)
final class A2AFileWithBytes extends A2AFilePartVariant {
  /// base64 encoded content of the file
  String bytes = '';

  /// Optional mimeType for the file
  String mimeTYpe = '';

  /// Optional name for the file
  String name = '';

  A2AFileWithBytes();

  factory A2AFileWithBytes.fromJson(Map<String, dynamic> json) =>
      _$A2AFileWithBytesFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AFileWithBytesToJson(this);
}

/// Define the variant where 'uri' is present and 'bytes' is absent
@JsonSerializable(explicitToJson: true)
final class A2AFileWithUrl extends A2AFilePartVariant {
  /// Optional mimeType for the file
  String mimeTYpe = '';

  /// Optional name for the file
  String name = '';

  /// URL for the File content
  String url = '';

  A2AFileWithUrl();

  factory A2AFileWithUrl.fromJson(Map<String, dynamic> json) =>
      _$A2AFileWithUrlFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AFileWithUrlToJson(this);
}
