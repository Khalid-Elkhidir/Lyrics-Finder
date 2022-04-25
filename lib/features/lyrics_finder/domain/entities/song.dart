import 'package:equatable/equatable.dart';

class Song extends Equatable {
  @override
  List<Object?> get props => [path];

  final String path;

  Song({required this.path});
}
