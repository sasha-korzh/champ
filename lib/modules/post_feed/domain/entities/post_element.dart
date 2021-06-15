import 'dart:io';

import 'package:equatable/equatable.dart';

class PostElement extends Equatable {
  final String id;
  final PostElementType type;
  String data;

  PostElement({this.id, this.type, this.data});

  @override
  List<Object> get props => [id];
}

enum PostElementType {
  h1,
  h2,
  h3,
  bullet,
  link,
  text,
  image,
  video,
}

class PostElementFile extends Equatable {
  final String postElementId;
  final File file;

  PostElementFile(this.postElementId, this.file);

  @override
  List<Object> get props => [postElementId];
}