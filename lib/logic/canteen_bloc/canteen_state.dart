/// Abstract class that represents a generic [CanteenState]. All specific
/// [CanteenState]s have to extends from this abstract class.
abstract class CanteenState {}

/// This class represents the initial state of the canteen bloc.
class CanteenInitialState extends CanteenState {}

/// This class represents the state that the bloc has while fetching data from
/// the API.
class CanteenLoadingState extends CanteenState {}

/// This class represents the state when fetching the data was successful. It
/// then contains all data as a [Map] which is used to display the information
/// on screen.
class CanteenLoadingSuccessfulState extends CanteenState {
  Map<String, dynamic> menus;

  /// Constructor for the state. Needs the map of [menus] which then will be
  /// displayed on screen.
  CanteenLoadingSuccessfulState({required this.menus});
}

/// This class represents the state when fetching the data went wrong. It then
/// contains an error message which is used to display in a snackbar.
class CanteenErrorState extends CanteenState {
  String message;

  /// Constructor for the state. Needs an error-[message] which then will be
  /// displayed on screen.
  CanteenErrorState({required this.message});
}

class CanteenLoadingEmptySuccessfulState extends CanteenState {}
