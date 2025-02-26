import 'package:bloc/bloc.dart';
import 'package:happy_dog_house/src/core/dependency_injection.dart';

import 'package:happy_dog_house/src/feature/rituals/model/dog.dart';

import 'package:happy_dog_house/src/feature/rituals/model/tasks.dart';
import 'package:happy_dog_house/src/feature/rituals/repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Repository userRepository = locator<Repository>();

  UserBloc() : super(const UserLoading()) {
    on<UserLoadData>(_onUserLoadData);
    on<CompleteTaskEvent>(_onCompleteTaskEvent);
    on<CreateDogEvent>(_onCreateDogEvent);
    on<UpdateDogEvent>(_onUpdateDogEvent);
    on<RemoveDogEvent>(_onRemoveDogEvent);
  }

  Future<void> _onUserLoadData(
    UserLoadData event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    try {
      final dogs = await userRepository.load();
      final tasks = await userRepository.loadTask();

      dogs.forEach((action) async {
        action.tasks.forEach((a) => action.checkTask(a.id));
        await userRepository.update(action);
      });

      final checkedDogs = await userRepository.load();

      emit(
        UserLoaded(
          dogs: checkedDogs,
          tasks: tasks,
        ),
      );
    } catch (e) {
      emit(UserError('Произошла ошибка при загрузке: $e'));
    }
  }

  Future<void> _onCompleteTaskEvent(
    CompleteTaskEvent event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      try {
        final updatedDogs = currentState.dogs.map((dog) {
          if (dog.id == event.dogId) {
            return dog.completeTask(event.taskId);
          }
          return dog;
        }).toList();

        emit(
          UserLoaded(
            dogs: updatedDogs,
            tasks: currentState.tasks,
          ),
        );
      } catch (e) {
        emit(UserError('Ошибка при выполнении задания: $e'));
      }
    }
  }

  Future<void> _onCreateDogEvent(
    CreateDogEvent event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      try {
        final currentState = state as UserLoaded;
        var newDog = event.newDog;

        newDog = newDog.copyWith(
          tasks: currentState.tasks,
        );

        await userRepository.save(newDog);

        final dogs = await userRepository.load();

        emit(
          UserLoaded(
            dogs: dogs,
            tasks: currentState.tasks,
          ),
        );
      } catch (e) {
        emit(UserError('Ошибка при создании курятника: $e'));
      }
    }
  }

  Future<void> _onUpdateDogEvent(
    UpdateDogEvent event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      emit(const UserLoading());
      try {
        await userRepository.update(event.dogToUpdate);
        final dogs = await userRepository.load();
        final tasks = await userRepository.loadTask();

        emit(UserLoaded(dogs: dogs, tasks: tasks));
      } catch (e) {
        emit(UserError('Ошибка при обновлении курятника: $e'));
      }
    }
  }

  Future<void> _onRemoveDogEvent(
    RemoveDogEvent event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      emit(const UserLoading());
      try {
        await userRepository.remove(event.dogToRemove);
        final dogs = await userRepository.load();

        final tasks = await userRepository.loadTask();
        emit(UserLoaded(dogs: dogs, tasks: tasks));
      } catch (e) {
        emit(UserError('Ошибка при удалении курятника: $e'));
      }
    }
  }
}
