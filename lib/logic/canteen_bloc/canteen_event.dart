/// Abstract class that represents a generic [CanteenEvent]. All specific
/// [CanteenEvent]s have to extends from this abstract class.
abstract class CanteenEvent {}

/// This class represents the [FetchCanteenMenusEvent].
class FetchCanteenMenusEvent extends CanteenEvent {}
