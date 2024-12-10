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
    on<TabChanged>(_onTabChanged);
    on<PageChanged>(_onPageChanged);
  }

  void _onTabChanged(TabChanged event, Emitter<NavigationState> emit) {
    emit(NavigationState(tabIndex: event.tabIndex));
    pageController.jumpToPage(event.tabIndex);
  }

  FutureOr<void> _onPageChanged(PageChanged event, Emitter<NavigationState> emit) {
    emit(state.copyWith(pageNo: event.pageIndex));
  }
}
