import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class UserNewModel {

  const UserNewModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
  });

  final String id;
  final String name;
  final String phone;
  final String role;

  factory UserNewModel.fromJson(Map<String,dynamic> json) => UserNewModel(
    id: json['id'].toString(),
    name: json['name'].toString(),
    phone: json['phone'].toString(),
    role: json['role'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'role': role
  };

  UserNewModel clone() => UserNewModel(
    id: id,
    name: name,
    phone: phone,
    role: role
  );


  UserNewModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? role
  }) => UserNewModel(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    role: role ?? this.role,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is UserNewModel && id == other.id && name == other.name && phone == other.phone && role == other.role;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ phone.hashCode ^ role.hashCode;
}
