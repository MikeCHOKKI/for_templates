// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class FormConstantes {
  static List<FormQuestionType> questionTypeList = [
    FormQuestionType(
      nom: "Type de réponse",
      icon: Icons.question_mark,
    ),
    FormQuestionType(
      nom: "Réponse Courte",
      icon: Icons.filter_list,
    ),
    FormQuestionType(
      nom: "Réponse Longue",
      icon: Icons.filter_list_rounded,
    ),
    FormQuestionType(
      nom: "Choix multiples",
      icon: Icons.radio_button_off_rounded,
    ),
    FormQuestionType(
      nom: "Case à cocher",
      icon: Icons.check_box_outline_blank_rounded,
    ),
    FormQuestionType(
      nom: "Liste déroulante",
      icon: Icons.arrow_drop_down_circle_rounded,
    ),
    FormQuestionType(
      nom: "Date",
      icon: Icons.date_range_rounded,
    ),
    FormQuestionType(
      nom: "Heure",
      icon: Icons.access_time_rounded,
    ),
  ];
}

class FormQuestionType {
  String nom;
  IconData? icon;

  FormQuestionType({
    this.nom = "",
    this.icon,
  });
}

class FormQuestion {
  String? id;
  String? question;
  String? type;
  List<String>? suggestionList;
  String? isRequired;

  FormQuestion({
    this.id,
    this.question,
    this.type,
    this.suggestionList,
    this.isRequired,
  });

  FormQuestion copyWith({
    String? id,
    String? question,
    String? type,
    List<String>? suggestionList,
    String? isRequired,
  }) {
    return FormQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      type: type ?? this.type,
      suggestionList: suggestionList ?? this.suggestionList,
      isRequired: isRequired ?? this.isRequired,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'question': question,
      'type': type,
      'suggestionList': suggestionList,
      'isRequired': isRequired,
    };
  }

  factory FormQuestion.fromMap(Map<String, dynamic> map) {
    return FormQuestion(
      id: map['id'] != null ? map['id'] as String : null,
      question: map['question'] != null ? map['question'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      suggestionList: map['suggestionList'] != null
          ? List<String>.from((map['suggestionList'] as List<String>))
          : null,
      isRequired:
          map['isRequired'] != null ? map['isRequired'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FormQuestion.fromJson(String source) =>
      FormQuestion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FormQuestion(id: $id, question: $question, type: $type, suggestionList: $suggestionList, isRequired: $isRequired)';
  }

  @override
  bool operator ==(covariant FormQuestion other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.question == question &&
        other.type == type &&
        listEquals(other.suggestionList, suggestionList) &&
        other.isRequired == isRequired;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        question.hashCode ^
        type.hashCode ^
        suggestionList.hashCode ^
        isRequired.hashCode;
  }
}

class MyForm {
  String? titre;
  String? description;
  List<FormQuestion>? questionList;

  MyForm({
    this.titre,
    this.description,
    this.questionList,
  });

  MyForm copyWith({
    String? titre,
    String? description,
    List<FormQuestion>? questionList,
  }) {
    return MyForm(
      titre: titre ?? this.titre,
      description: description ?? this.description,
      questionList: questionList ?? this.questionList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'titre': titre,
      'description': description,
      'questionList': questionList!.map((x) => x.toMap()).toList(),
    };
  }

  factory MyForm.fromMap(Map<String, dynamic> map) {
    return MyForm(
      titre: map['titre'] != null ? map['titre'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      questionList: map['questionList'] != null
          ? List<FormQuestion>.from(
              (map['questionList'] as List<FormQuestion>).map<FormQuestion?>(
                (x) => FormQuestion.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyForm.fromJson(String source) =>
      MyForm.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MyForm(titre: $titre, description: $description, questionList: $questionList)';

  @override
  bool operator ==(covariant MyForm other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.titre == titre &&
        other.description == description &&
        listEquals(other.questionList, questionList);
  }

  @override
  int get hashCode =>
      titre.hashCode ^ description.hashCode ^ questionList.hashCode;
}
