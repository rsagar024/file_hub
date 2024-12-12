import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';

part 'navigation_event.dart';

part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  PageController pageController = PageController();
  List<String> navIcons = [
    ImageResources.iconFile,
    ImageResources.iconUpload,
    ImageResources.iconProfile,
  ];

  NavigationBloc() : super(const NavigationState(tabIndex: 0)) {
    on<InitialNavigationEvent>(_onInitialNavigation);
    on<TabChangedEvent>(_onTabChanged);
    on<PageChangedEvent>(_onPageChanged);
  }

  FutureOr<void> _onInitialNavigation(InitialNavigationEvent event, Emitter<NavigationState> emit) {
    add(const TabChangedEvent(0));
    add(const PageChangedEvent(0));
  }

  FutureOr<void> _onTabChanged(TabChangedEvent event, Emitter<NavigationState> emit) {
    emit(NavigationState(tabIndex: event.tabIndex));
    if(pageController.hasClients) {
      pageController.jumpToPage(event.tabIndex);
    }
  }

  FutureOr<void> _onPageChanged(PageChangedEvent event, Emitter<NavigationState> emit) {
    emit(state.copyWith(pageNo: event.pageIndex));
  }
}
