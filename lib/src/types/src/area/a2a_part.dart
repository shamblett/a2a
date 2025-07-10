/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// Represents a part of a message, which can be text, a file, or structured data.
base class A2APart {}

final class TextPart extends A2APart {}

final class FilePart extends A2APart {}

final class DataPart extends A2APart {}
