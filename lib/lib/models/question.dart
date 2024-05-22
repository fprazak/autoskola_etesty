import 'package:freezed_annotation/freezed_annotation.dart';

part 'question.freezed.dart';
part 'question.g.dart';

@freezed
class Question with _$Question {
  factory Question({
    required String id,
    required String question,
    required List<String> answers,
    required int correctAnswerIndex,
    String? imagePath,
    String? videoPath,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);
}
