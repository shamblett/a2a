/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// A discriminated union representing a part of a message or artifact, which can
/// be text, a file, or structured data.
class A2APart {
  A2APart();

  factory A2APart.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('kind')) {
      if (json['kind'] == 'text') {
        return A2ATextPart.fromJson(json);
      }
      if (json['kind'] == 'file') {
        return A2AFilePart.fromJson(json);
      }
      if (json['kind'] == 'data') {
        return A2ADataPart.fromJson(json);
      }
    }

    return A2APart();
  }

  Map<String, dynamic> toJson() => {};
}

/// Represents a text segment within a message or artifact.
@JsonSerializable(explicitToJson: true)
final class A2ATextPart extends A2APart {
  /// The type of this part, used as a discriminator. Always 'text'
  @JsonKey(includeToJson: true, includeFromJson: false)
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

/// Represents a file segment within a message or artifact. The file content can be
/// provided either directly as bytes or as a URI.
@JsonSerializable(explicitToJson: true)
final class A2AFilePart extends A2APart {
  /// Part type - file for TextParts
  @JsonKey(includeToJson: true, includeFromJson: false)
  String kind = 'file';

  /// Optional metadata associated with the part.
  A2ASV? metadata;

  /// The file content, represented as either a URI or as base64-encoded bytes.
  A2AFilePartVariant? file;

  A2AFilePart();

  factory A2AFilePart.fromJson(Map<String, dynamic> json) =>
      _$A2AFilePartFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AFilePartToJson(this);
}

/// Represents a structured data segment (e.g., JSON) within a message or artifact.
@JsonSerializable(explicitToJson: true)
final class A2ADataPart extends A2APart {
  /// Structured data content
  A2ASV data = {};

  /// Part type - data for DataParts
  @JsonKey(includeToJson: true, includeFromJson: false)
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

  factory A2AFilePartVariant.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('bytes')) {
      return A2AFileWithBytes.fromJson(json);
    }
    if (json.containsKey('uri')) {
      return A2AFileWithUri.fromJson(json);
    }

    return A2AFilePartVariant();
  }

  Map<String, dynamic> toJson() => {};
}

/// Represents a file with its content provided directly as a base64-encoded string
@JsonSerializable(explicitToJson: true)
final class A2AFileWithBytes extends A2AFilePartVariant {
  /// The base64 encoded content of the file
  String bytes = '';

  /// Optional mimeType for the file
  String mimeType = '';

  /// Optional name for the file
  String name = '';

  A2AFileWithBytes();

  factory A2AFileWithBytes.fromJson(Map<String, dynamic> json) =>
      _$A2AFileWithBytesFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AFileWithBytesToJson(this);
}

/// Represents a file with its content located at a specific URI.
@JsonSerializable(explicitToJson: true)
final class A2AFileWithUri extends A2AFilePartVariant {
  /// Optional mimeType for the file
  String mimeType = '';

  /// Optional name for the file
  String name = '';

  /// A URL pointing to the file's content
  String uri = '';

  A2AFileWithUri();

  factory A2AFileWithUri.fromJson(Map<String, dynamic> json) =>
      _$A2AFileWithUriFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AFileWithUriToJson(this);
}
