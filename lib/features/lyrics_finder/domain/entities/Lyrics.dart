import 'package:equatable/equatable.dart';

class Lyrics extends Equatable {
  @override
  List<Object?> get props => [text];

  final String text;

  Lyrics({required this.text});
}