part of 'navigation_bloc.dart';

class NavigationState extends Equatable {
  final int tabIndex;
  final int pageNo;

  const NavigationState({
    this.tabIndex = 0,
    this.pageNo = 0,
  });

  @override
  List<Object> get props => [tabIndex];

  NavigationState copyWith({
    int? tabIndex,
    int? pageNo,
  }) {
    return NavigationState(
      tabIndex: tabIndex ?? this.tabIndex,
      pageNo: pageNo ?? this.pageNo,
    );
  }
}
