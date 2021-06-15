
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String userMessage;
  final String recoverySuggestion;
  final String devMessage;

  Failure(this.userMessage, this.devMessage, this.recoverySuggestion);

  @override
  List<Object> get props => [userMessage, devMessage, recoverySuggestion];
}

class ServerFailure extends Failure {

  ServerFailure({userMessage, devMessage = '', recoverySuggestion = ''}) : 
    super(userMessage, devMessage, recoverySuggestion);

  @override
  List<Object> get props => [userMessage, recoverySuggestion, recoverySuggestion];
}


class AuthFailure extends Failure {
  
  AuthFailure({userMessage, devMessage = '', recoverySuggestion = ''}) : 
    super(userMessage, devMessage, recoverySuggestion);

  @override
  List<Object> get props => [userMessage, recoverySuggestion, recoverySuggestion];
}

class ConnectionFailure extends Failure {

  ConnectionFailure({userMessage, devMessage = '', recoverySuggestion = ''}) : 
    super(userMessage, devMessage, recoverySuggestion);

  @override
  List<Object> get props => [userMessage, recoverySuggestion, recoverySuggestion];
}
