import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/canteen_repository.dart';
import 'canteen_event.dart';
import 'canteen_state.dart';

/// Bloc that manages the State of canteen menu data and handles events which
/// can be executed in code.
class CanteenBloc extends Bloc<CanteenEvent, CanteenState> {
  CanteenRepository repository;

  /// Constructor for a new canteen bloc. It requires a [CanteenRepository] in
  /// order to be able to start fetching data from it.
  CanteenBloc({required this.repository}) : super(CanteenInitialState()) {
    on<FetchCanteenMenusEvent>(_onFetchCanteenMenuEvent);
  }

  /// If the [FetchCanteenMenusEvent] is pushed, it tries to fetch data from the
  /// API. If the fetch was successful, state changes to
  /// [CanteenLoadingSuccessfulState] else to [CanteenErrorState].
  void _onFetchCanteenMenuEvent(
      FetchCanteenMenusEvent event, Emitter<CanteenState> emit) async {
    emit(CanteenLoadingState());
    try {
      Map<String, dynamic> menus = await repository.getMenu();
      emit(CanteenLoadingSuccessfulState(menus: menus));
    } catch (e) {
      emit(CanteenErrorState(message: e.toString()));
    }
  }
}
