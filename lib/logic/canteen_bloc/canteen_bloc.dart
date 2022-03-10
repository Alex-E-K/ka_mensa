import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ka_mensa/data/repositories/canteen_repository.dart';
import 'package:ka_mensa/logic/canteen_bloc/canteen_event.dart';

import 'canteen_state.dart';

class CanteenBloc extends Bloc<CanteenEvent, CanteenState> {
  CanteenRepository repository;

  CanteenBloc({required this.repository}) : super(CanteenInitialState()) {
    on<FetchCanteenMenusEvent>(_onFetchCanteenMenuEvent);
  }

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
