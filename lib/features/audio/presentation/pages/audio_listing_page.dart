import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/core/enums/app_enum/page_state_enum.dart';
import 'package:vap_uploader/core/services/audio_service/audio_player_invoke.dart';
import 'package:vap_uploader/features/audio/presentation/bloc/audio_bloc.dart';
import 'package:vap_uploader/features/audio/presentation/widgets/audio_card_skeleton_widget.dart';
import 'package:vap_uploader/features/audio/presentation/widgets/audio_card_widget.dart';

class AudioListingPage extends StatefulWidget {
  const AudioListingPage({super.key});

  @override
  State<AudioListingPage> createState() => _AudioListingPageState();
}

class _AudioListingPageState extends State<AudioListingPage> {
  final audioBloc = getIt<AudioBloc>();

  @override
  void initState() {
    super.initState();
    audioBloc.itemListScrollController.addListener(() => audioBloc.add(ScrollEvent()));
    audioBloc.add(InitialAudioEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioBloc, AudioState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.pageState == PageState.loading) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: 15,
            itemBuilder: (context, index) {
              return const AudioCardSkeletonWidget();
            },
          );
        } else if (state.pageState == PageState.error) {
          return const Center(child: Text('Error Occurs'));
        } else {
          if (state.audioModels.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                audioBloc.add(RefreshEvent());
              },
              child: CustomScrollView(
                controller: audioBloc.itemListScrollController,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return AudioCardWidget(
                          audioModel: state.audioModels[index],
                          onPressed: () => audioPlayerPlayProcessDebounce(state.audioModels, index),
                        );
                      },
                      childCount: state.audioModels.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 70)),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No Files found'));
          }
        }
      },
    );
  }
}
