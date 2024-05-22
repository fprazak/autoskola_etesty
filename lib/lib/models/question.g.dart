// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionImpl _$$QuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionImpl(
      id: json['id'] as String,
      question: json['question'] as String,
      answers:
          (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
      correctAnswerIndex: (json['correctAnswerIndex'] as num).toInt(),
      imagePath: json['imagePath'] as String?,
      videoPath: json['videoPath'] as String?,
    );

Map<String, dynamic> _$$QuestionImplToJson(_$QuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answers': instance.answers,
      'correctAnswerIndex': instance.correctAnswerIndex,
      'imagePath': instance.imagePath,
      'videoPath': instance.videoPath,
    };
