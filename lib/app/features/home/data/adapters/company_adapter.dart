import 'package:tractian_challenge/app/features/home/interactor/entities/company_entity.dart';

class CompanyAdapter {
  static CompanyEntity fromJson(Map<String, dynamic> json) {
    return CompanyEntity(id: json['id'], name: json['name']);
  }
}
