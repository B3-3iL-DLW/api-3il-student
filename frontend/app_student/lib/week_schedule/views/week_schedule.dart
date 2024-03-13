import 'package:app_student/api/week_schedule/repositories/week_schedule_repository.dart';
import 'package:app_student/week_schedule/cubit/week_schedule_cubit.dart';
import 'package:app_student/week_schedule/views/widgets/day_schedule_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/users/repositories/user_repository.dart';

class WeekSchedulePage extends StatelessWidget {
  const WeekSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final weekScheduleRepository =
        RepositoryProvider.of<WeekScheduleRepository>(context);
    final userRepository = RepositoryProvider.of<UserRepository>(context);
    final weekScheduleCubit = WeekScheduleCubit(
        weekScheduleRepository: weekScheduleRepository,
        userRepository: userRepository);

    return BlocProvider<WeekScheduleCubit>(
      create: (context) => weekScheduleCubit..fetchUserAndSchedule(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Week Schedule'),
        ),
        body: BlocBuilder<WeekScheduleCubit, WeekScheduleState>(
          builder: (context, state) {
            if (state is WeekScheduleLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WeekScheduleLoaded) {
              return Expanded(
                child: PageView.builder(
                  itemCount: state.weekSchedule[0].daySchedules.length,
                  itemBuilder: (context, index) {
                    final daySchedule =
                        state.weekSchedule[0].daySchedules[index];
                    return DayScheduleWidget(daySchedule: daySchedule);
                  },
                ),
              );
            } else if (state is WeekScheduleError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
