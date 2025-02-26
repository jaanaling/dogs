part of 'user_bloc.dart';

abstract class UserState {
  const UserState();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final List<Dog> dogs;

  final List<TaskCatalog> tasks;

  const UserLoaded({
    required this.dogs,
    required this.tasks,
  });
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);
}
