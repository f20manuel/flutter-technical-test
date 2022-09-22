import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// User model
@JsonSerializable()
class User {
  late String name;

  /// User constructor
  User({
    required this.name,
  });

  /// User from json
  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  /// User to json
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
