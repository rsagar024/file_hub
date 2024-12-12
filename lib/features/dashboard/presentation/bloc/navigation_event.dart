part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class InitialNavigationEvent extends NavigationEvent {}

class TabChangedEvent extends NavigationEvent {
  final int tabIndex;

  const TabChangedEvent(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

class PageChangedEvent extends NavigationEvent {
  final int pageIndex;

  const PageChangedEvent(this.pageIndex);

  @override
  List<Object> get props => [pageIndex];
}
