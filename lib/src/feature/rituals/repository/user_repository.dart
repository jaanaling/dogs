import 'package:happy_dog_house/src/feature/rituals/model/dog.dart';
import 'package:happy_dog_house/src/feature/rituals/model/tasks.dart';

import '../../../core/utils/json_loader.dart';

class Repository {
  final String tasks = 'tasks';
  final String dogs = 'dogs';

  Future<List<Dog>> load() {
    return JsonLoader.loadData<Dog>(
      dogs,
      'assets/json/$dogs.json',
      (json) => Dog.fromMap(json),
    );
  }



  Future<List<TaskCatalog>> loadTask() {
    return JsonLoader.loadData<TaskCatalog>(
      tasks,
      'assets/json/$tasks.json',
      (json) => TaskCatalog.fromMap(json),
    );
  }

  Future<void> update(Dog updated) async {
    return JsonLoader.modifyDataList<Dog>(
      dogs,
      updated,
      () async => await load(),
      (item) => item.toMap(),
      (itemList) async {
        final index = itemList.indexWhere((d) => d.id == updated.id);
        if (index != -1) {
          itemList[index] = updated;
        }
      },
    );
  }

  Future<void> save(Dog item) {
    return JsonLoader.saveData<Dog>(
      dogs,
      item,
      () async => await load(),
      (item) => item.toMap(),
    );
  }

  Future<void> remove(Dog item) {
    return JsonLoader.removeData<Dog>(
      dogs,
      item,
      () async => await load(),
      (item) => item.toMap(),
    );
  }
}
