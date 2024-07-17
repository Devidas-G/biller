import 'package:equatable/equatable.dart';

abstract class Success extends Equatable {
  const Success(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class DatabaseSuccess extends Success {
  const DatabaseSuccess(super.message);
}
