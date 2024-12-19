part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class DashboardInitialEvent extends DashboardEvent {}

class TabChangedEvent extends DashboardEvent {
  final int tabIndex;

  const TabChangedEvent(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

class PageChangedEvent extends DashboardEvent {
  final int pageIndex;

  const PageChangedEvent(this.pageIndex);

  @override
  List<Object> get props => [pageIndex];
}
