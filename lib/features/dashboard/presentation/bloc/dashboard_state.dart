part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final int tabIndex;
  final int pageNo;
  final String selectedType;

  const DashboardState({
    this.tabIndex = 0,
    this.pageNo = 0,
    this.selectedType = 'audio',
  });

  @override
  List<Object> get props => [tabIndex];

  DashboardState copyWith({
    int? tabIndex,
    int? pageNo,
    String? selectedType,
  }) {
    return DashboardState(
      tabIndex: tabIndex ?? this.tabIndex,
      pageNo: pageNo ?? this.pageNo,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}
