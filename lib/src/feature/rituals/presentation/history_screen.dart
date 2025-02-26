import 'package:happy_dog_house/src/core/utils/icon_provider.dart';
import 'package:happy_dog_house/src/core/utils/text_with_border.dart';
import 'package:happy_dog_house/src/feature/rituals/bloc/user_bloc.dart';
import 'package:happy_dog_house/src/feature/rituals/model/dog.dart';

import 'package:happy_dog_house/ui_kit/app_app_bar.dart';
import 'package:happy_dog_house/ui_kit/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatelessWidget {
  final Dog dog;
  const HistoryScreen({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is! UserLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        final item = state.dogs.firstWhere((dog) => dog.id == dog.id);
        return Column(
          children: [
            const AppAppBar(title: 'History'),
            Expanded(
              child: ListView.separated(
                itemCount: item.taskHistory.length, // Пример
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final task = item.taskHistory[index];
                  return AppCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWithBorder(task.title),
                          TextWithBorder(task.isOverdue ? 'Overdue' : ''),
                          TextWithBorder(
                            '${task.finishDate!.difference(DateTime.now()).inDays} Days ago',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
