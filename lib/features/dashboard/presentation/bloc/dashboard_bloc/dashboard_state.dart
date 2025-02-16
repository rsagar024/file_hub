part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final PageState pageState;
  final int tabIndex;
  final int pageNo;
  final String selectedType;
  final bool isMiniPlayerVisible;

  const DashboardState({
    this.pageState = PageState.initial,
    this.tabIndex = 0,
    this.pageNo = 0,
    this.selectedType = 'audio',
    this.isMiniPlayerVisible = false,
  });

  @override
  List<Object> get props => [pageState, tabIndex, pageNo, selectedType, isMiniPlayerVisible];

  DashboardState copyWith({
    PageState? pageState,
    int? tabIndex,
    int? pageNo,
    String? selectedType,
    bool? isMiniPlayerVisible,
  }) {
    return DashboardState(
      pageState: pageState ?? this.pageState,
      tabIndex: tabIndex ?? this.tabIndex,
      pageNo: pageNo ?? this.pageNo,
      selectedType: selectedType ?? this.selectedType,
      isMiniPlayerVisible: isMiniPlayerVisible ?? this.isMiniPlayerVisible,
    );
  }
}
