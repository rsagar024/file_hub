import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:file_hub/core/enums/app_enum/page_state_enum.dart';
import 'package:file_hub/core/resources/common/image_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  PageController pageController = PageController();
  List<String> navIcons = [
    ImageResources.iconFile,
    ImageResources.iconUpload,
    ImageResources.iconProfile,
  ];

  DashboardBloc() : super(const DashboardState()) {
    on<DashboardInitialEvent>(_onDashboardInitial);
    on<TabChangedEvent>(_onTabChanged);
    on<PageChangedEvent>(_onPageChanged);
    on<ShowTypeSelectionEvent>(_onShowTypeSelection);
    on<ToggleTypeChangedEvent>(_onToggleTypeChanged);
  }

  FutureOr<void> _onDashboardInitial(DashboardInitialEvent event, Emitter<DashboardState> emit) {
    add(const TabChangedEvent(0));
    add(const PageChangedEvent(0));
  }

  FutureOr<void> _onTabChanged(TabChangedEvent event, Emitter<DashboardState> emit) {
    emit(state.copyWith(tabIndex: event.tabIndex, isMiniPlayerVisible: event.tabIndex == 0 ? state.selectedType == 'audio' : false));
    if (pageController.hasClients) {
      pageController.jumpToPage(event.tabIndex);
    }
  }

  FutureOr<void> _onPageChanged(PageChangedEvent event, Emitter<DashboardState> emit) {
    emit(state.copyWith(pageNo: event.pageIndex, pageState: PageState.initial));
  }

  FutureOr<void> _onShowTypeSelection(ShowTypeSelectionEvent event, Emitter<DashboardState> emit) {
    emit(state.copyWith(pageState: PageState.success));
  }

  FutureOr<void> _onToggleTypeChanged(ToggleTypeChangedEvent event, Emitter<DashboardState> emit) {
    emit(state.copyWith(selectedType: event.selectedType ?? state.selectedType, pageState: PageState.initial, isMiniPlayerVisible: (event.selectedType ?? state.selectedType) == 'audio'));
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
