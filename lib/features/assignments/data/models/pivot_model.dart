import '../../domain/entities/article.dart';

class PivotModel extends Pivot {
  const PivotModel({
    required super.articleId,
    required super.assignmentId,
    required super.amount,
    required super.used,
  });

  factory PivotModel.fromJson(Map<String, dynamic> json) {
    return PivotModel(
      articleId: json['article_id'] as int? ?? 0,
      assignmentId: json['assignment_id'] as int? ?? 0,
      amount: json['amount'] as int? ?? 0,
      used: json['used'] as int? ?? 0,
    );
  }
}
