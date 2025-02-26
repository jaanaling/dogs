part of 'user_bloc.dart';

abstract class UserEvent {}

class UserLoadData extends UserEvent {}

class CompleteTaskEvent extends UserEvent {
  final String dogId;
  final String taskId;
  CompleteTaskEvent({required this.dogId, required this.taskId});
}

class CreateDogEvent extends UserEvent {
  final Dog newDog;
  CreateDogEvent({
    required this.newDog,
  });
}

/// Обновление существующего курятника
class UpdateDogEvent extends UserEvent {
  final Dog dogToUpdate;
  UpdateDogEvent({
    required this.dogToUpdate,
  });
}

class RemoveDogEvent extends UserEvent {
  final Dog dogToRemove;
  RemoveDogEvent({required this.dogToRemove});
}
