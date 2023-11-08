import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SurveyForm(),
    );
  }
}

class SurveyForm extends StatefulWidget {
  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  String? surveyName;
  String? surveyDescription;
  String? selectedLanguage;
  String? selectedCountry;
  String? selectedGender;
  String textAnswer = '';
  List<Question> questions = [];

  List<String> languageOptions = ['中文', '英文'];
  List<String> countryOptions = ['台灣', '中國', '美國', '其他'];
  List<String> genderOptions = ['男', '女', '其他'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surveyName ?? '調查問卷'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text('問卷名稱：'),
              TextField(
                onChanged: (value) {
                  setState(() {
                    surveyName = value;
                  });
                },
              ),
              Text('問卷介紹：'),
              TextField(
                onChanged: (value) {
                  setState(() {
                    surveyDescription = value;
                  });
                },
              ),
              Text('選擇語言：'),
              DropdownButton<String>(
                value: selectedLanguage,
                items: languageOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value;
                  });
                },
              ),
              Text('選擇國家：'),
              DropdownButton<String>(
                value: selectedCountry,
                items: countryOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                  });
                },
              ),
              Text('選擇性別：'),
              DropdownButton<String>(
                value: selectedGender,
                items: genderOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              Text('單選題、多選題或問答題：'),
              Column(
                children: questions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final question = entry.value;
                  return Column(
                    children: [
                      Text('問題 ${index + 1}：'),
                      Text(question.text),
                      if (question.type == QuestionType.singleChoice) ...[
                        Column(
                          children: question.choices.map((choice) {
                            if (choice == '其他') {
                              return Column(
                                children: [
                                  RadioListTile<String>(
                                    title: Text(choice),
                                    value: choice,
                                    groupValue: question.selectedChoice,
                                    onChanged: (value) {
                                      setState(() {
                                        question.selectedChoice = value;
                                      });
                                    },
                                  ),
                                  if (question.selectedChoice == choice)
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: '其他，請填寫：',
                                      ),
                                      onChanged: (value) {
                                        question.otherText = value;
                                      },
                                    ),
                                ],
                              );
                            } else {
                              return RadioListTile<String>(
                                title: Text(choice),
                                value: choice,
                                groupValue: question.selectedChoice,
                                onChanged: (value) {
                                  setState(() {
                                    question.selectedChoice = value;
                                  });
                                },
                              );
                            }
                          }).toList(),
                        ),
                      ] else if (question.type == QuestionType.multiChoice) ...[
                        Column(
                          children: question.choices.map((choice) {
                            if (choice == '其他') {
                              return Column(
                                children: [
                                  CheckboxListTile(
                                    title: Text(choice),
                                    value: question.selectedChoices.contains(choice),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null) {
                                          if (value) {
                                            question.selectedChoices.add(choice);
                                          } else {
                                            question.selectedChoices.remove(choice);
                                          }
                                        }
                                      });
                                    },
                                  ),
                                  if (question.selectedChoices.contains(choice))
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: '其他，請填寫：',
                                      ),
                                      onChanged: (value) {
                                        question.otherText = value;
                                      },
                                    ),
                                ],
                              );
                            } else {
                              return CheckboxListTile(
                                title: Text(choice),
                                value: question.selectedChoices.contains(choice),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null) {
                                      if (value) {
                                        question.selectedChoices.add(choice);
                                      } else {
                                        question.selectedChoices.remove(choice);
                                      }
                                    }
                                  });
                                },
                              );
                            }
                          }).toList(),
                        ),
                      ] else if (question.type == QuestionType.text) ...[
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              question.textAnswer = value;
                            });
                          },
                        ),
                      ],
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            questions.removeAt(index);
                          });
                        },
                        child: Text('刪除問題'),
                      ),
                      Divider(),
                    ],
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    questions.add(Question(
                      type: QuestionType.singleChoice,
                      text: '新的單選題',
                      choices: ['選項A', '選項B', '其他'],
                    ));
                  });
                },
                child: Text('新增單選題'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    questions.add(Question(
                      type: QuestionType.multiChoice,
                      text: '新的多選題',
                      choices: ['選項A', '選項B', '其他'],
                    ));
                  });
                },
                child: Text('新增多選題'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    questions.add(Question(
                      type: QuestionType.text,
                      text: '新的問答題',
                      choices: [],
                    ));
                  });
                },
                child: Text('新增問答題'),
              ),
              ElevatedButton(
                onPressed: () {
                  print('問卷名稱: $surveyName');
                  print('問卷介紹: $surveyDescription');
                  print('選擇語言: $selectedLanguage');
                  print('選擇國家: $selectedCountry');
                  print('選擇性別: $selectedGender');
                  for (var question in questions) {
                    if (question.type == QuestionType.singleChoice) {
                      print('${question.text} 的答案: ${question.selectedChoice}');
                      if (question.selectedChoice == '其他') {
                        print('其他內容: ${question.otherText}');
                      }
                    }
                    if (question.type == QuestionType.multiChoice) {
                      print('${question.text} 的答案: ${question.selectedChoices}');
                      if (question.selectedChoices.contains('其他')) {
                        print('其他內容: ${question.otherText}');
                      }
                    }
                    if (question.type == QuestionType.text) {
                      print('${question.text} 的答案: ${question.textAnswer}');
                    }
                  }
                },
                child: Text('提交'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum QuestionType { singleChoice, multiChoice, text }

class Question {
  final QuestionType type;
  final String text;
  final List<String> choices;
  String? selectedChoice;
  List<String> selectedChoices = [];
  String otherText = '';
  String textAnswer = '';

  Question({
    required this.type,
    required this.text,
    required this.choices,
  });
}
