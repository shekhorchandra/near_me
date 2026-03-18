// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentMethodModel {
  final int id;
  final String name;
  final String number;
  final String icon;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.number,
    required this.icon,
  });

  PaymentMethodModel copyWith({int? id, String? name, String? number, String? icon}) {
    return PaymentMethodModel(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'number': number, 'icon': icon};
  }

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      id: map['id'] as int,
      name: map['name'] as String,
      number: map['number'] as String,
      icon: map['icon'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentMethodModel.fromJson(String source) =>
      PaymentMethodModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentMethodModel(id: $id, name: $name, number: $number, icon: $icon)';
  }

  @override
  bool operator ==(covariant PaymentMethodModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.number == number && other.icon == icon;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ number.hashCode ^ icon.hashCode;
  }
}
