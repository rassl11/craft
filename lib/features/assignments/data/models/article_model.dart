import 'dart:developer';

import '../../domain/entities/article.dart';
import 'pivot_model.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.name,
    required super.unit,
    required super.pivot,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      unit: ArticleUnit.values.firstWhere(
        (unit) => unit.name == (json['unit'] as String),
        orElse: () {
          log('Unknown article unit: ${json['unit']}');
          return ArticleUnit.unknown;
        },
      ),
      pivot: json['pivot'] != null
          ? PivotModel.fromJson(json['pivot'] as Map<String, dynamic>)
          : null,
    );
  }
}
