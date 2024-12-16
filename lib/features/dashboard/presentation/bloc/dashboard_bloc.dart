import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';

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
  }

  FutureOr<void> _onDashboardInitial(DashboardInitialEvent event, Emitter<DashboardState> emit) {
    add(const TabChangedEvent(0));
    add(const PageChangedEvent(0));
  }

  FutureOr<void> _onTabChanged(TabChangedEvent event, Emitter<DashboardState> emit) {
    emit(DashboardState(tabIndex: event.tabIndex));
    if (pageController.hasClients) {
      pageController.jumpToPage(event.tabIndex);
    }
  }

  FutureOr<void> _onPageChanged(PageChangedEvent event, Emitter<DashboardState> emit) {
    emit(state.copyWith(pageNo: event.pageIndex));
  }
}
