import 'package:happy_dog_house/main.dart';
import 'package:happy_dog_house/src/core/utils/icon_provider.dart';
import 'package:happy_dog_house/src/core/utils/size_utils.dart';
import 'package:happy_dog_house/src/core/utils/text_with_border.dart';
import 'package:happy_dog_house/src/feature/rituals/bloc/user_bloc.dart';
import 'package:happy_dog_house/src/feature/rituals/model/dog.dart';

import 'package:happy_dog_house/src/feature/rituals/presentation/detailed_screen.dart';
import 'package:happy_dog_house/ui_kit/app_app_bar.dart';
import 'package:happy_dog_house/ui_kit/app_button.dart';
import 'package:happy_dog_house/ui_kit/app_card.dart';
import 'package:happy_dog_house/ui_kit/mask_widhget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TasksScreen extends StatefulWidget {
  final Dog dog;
  const TasksScreen({super.key, required this.dog});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool isOverdue = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is! UserLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        final item = state.dogs.firstWhere((dog) => dog.id == widget.dog.id);
        final tasks = item.tasks
            .where((task) => isOverdue ? task.isOverdue : true)
            .toList();
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5), // Полное затемнение фона
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 120, bottom: 320),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length, // Пример
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: AppCard(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWithBorder(task.title),
                                SizedBox(height: 8),
                                TextWithBorder(task.isOverdue
                                    ? '${task.dueDate!.difference(DateTime.now()).inDays} Days overdue'
                                    : '${task.dueDate!.difference(DateTime.now()).inDays} Days pending'),
                                if (task.isOverdue)
                                  Column(
                                    children: [
                                      SizedBox(height: 8),
                                      TextWithBorder(
                                        task.isOverdue ? 'Overdue' : '',
                                      ),
                                    ],
                                  ),
                                if (task.isPeriodic)
                                  Column(
                                    children: [
                                      SizedBox(height: 8),
                                      TextWithBorder(
                                        task.isPeriodic ? 'Periodic' : '',
                                      ),
                                    ],
                                  ),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 20,
                        child: AppButton(
                          color: BColor.green,
                          fontSize: 20,
                          width: getWidth(context, percent: 0.3),
                          onPressed: () {
                            {
                              context.read<UserBloc>().add(
                                    CompleteTaskEvent(
                                      dogId: widget.dog.id,
                                      taskId: task.id,
                                    ),
                                  );
                            }
                          },
                          text: 'Complete',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.black.withOpacity(0.3700000047683716),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 8),  
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(    width: getWidth(context, percent: 0.4),
                          color: BColor.green,
                          onPressed: () {
                            setState(() => isOverdue = false);
                          },
                          text: 'All',
                        ),
                        SizedBox(width: 8),
                        AppButton(    width: getWidth(context, percent: 0.4),
                          color: BColor.red,
                          onPressed: () {
                            setState(() => isOverdue = true);
                          },
                          text: 'Overdue',
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    AppButton(
                      width: getWidth(context, percent: 0.4),
                      color: BColor.blue,
                      onPressed: () {
                        {
                          context.push(
                            '/home/detailed/task/history',
                            extra: widget.dog,
                          );
                        }
                      },
                      text: 'History',
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            const AppAppBar(title: 'Tasks'),
            if (!isTask)
              MaskWidhget(
                screen: Screen.Task,
                setState: () => setState(
                  () {
                    isTask = true;
                  },
                ),
              )
          ],
        );
      },
    );
  }
}
