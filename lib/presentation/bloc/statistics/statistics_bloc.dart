import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/statistics.dart';
import '../../../domain/usecases/statistics_usecases.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final GetStatistics getStatistics;

  StatisticsBloc({required this.getStatistics}) : super(StatisticsInitial()) {
    on<GetStatisticsEvent>(_onGet);
  }

  Future<void> _onGet(
      GetStatisticsEvent event, Emitter<StatisticsState> emit) async {
    emit(StatisticsLoading());
    final result = await getStatistics();
    result.fold(
      (failure) => emit(StatisticsError(failure.message)),
      (stats) => emit(StatisticsLoaded(stats)),
    );
  }
}
