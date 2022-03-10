abstract class CanteenState {}

class CanteenInitialState extends CanteenState {}

class CanteenLoadingState extends CanteenState {}

class CanteenLoadingSuccessfulState extends CanteenState {
  Map<String, dynamic> menus;

  CanteenLoadingSuccessfulState({required this.menus});
}

class CanteenErrorState extends CanteenState {
  String message;

  CanteenErrorState({required this.message});
}
