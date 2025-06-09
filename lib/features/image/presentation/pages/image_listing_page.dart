import 'package:file_hub/core/di/di.dart';
import 'package:file_hub/core/enums/app_enum/page_state_enum.dart';
import 'package:file_hub/features/image/presentation/bloc/image_bloc.dart';
import 'package:file_hub/features/image/presentation/widgets/image_card_skeleton_widget.dart';
import 'package:file_hub/features/image/presentation/widgets/image_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ImageListingPage extends StatefulWidget {
  const ImageListingPage({super.key});

  @override
  State<ImageListingPage> createState() => _ImageListingPageState();
}

class _ImageListingPageState extends State<ImageListingPage> {
  final imageBloc = getIt<ImageBloc>();

  @override
  void initState() {
    super.initState();
    imageBloc.itemListScrollController.addListener(() => imageBloc.add(ScrollEvent()));
    imageBloc.add(InitialImageEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImageBloc, ImageState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.pageState == PageState.loading) {
          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth ~/ 150;
              crossAxisCount = crossAxisCount.clamp(2, 4);
              return MasonryGridView.count(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: constraints.maxWidth * 0.02,
                crossAxisSpacing: constraints.maxWidth * 0.02,
                itemCount: 15,
                itemBuilder: (context, index) {
                  double aspectRatio = _getAspectRatio(index);
                  return ImageCardSkeletonWidget(
                    aspectRatio: aspectRatio,
                    constraints: constraints,
                  );
                },
              );
            },
          );
        } else if (state.pageState == PageState.error) {
          return const Center(child: Text('Error Occurs'));
        } else {
          if (state.imageModels.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                imageBloc.add(RefreshEvent());
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth ~/ 150;
                  crossAxisCount = crossAxisCount.clamp(2, 4);
                  return MasonryGridView.count(
                    controller: imageBloc.itemListScrollController,
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: constraints.maxWidth * 0.02,
                    crossAxisSpacing: constraints.maxWidth * 0.02,
                    itemCount: state.imageModels.length,
                    itemBuilder: (context, index) {
                      double aspectRatio = _getAspectRatio(index);
                      return ImageCardWidget(
                        imageModel: state.imageModels[index],
                        aspectRatio: aspectRatio,
                        constraints: constraints,
                      );
                    },
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('No Files found'));
          }
        }
      },
    );
  }

  double _getAspectRatio(int index) {
    int position = index % 4;
    Map<int, double> ratios = {
      0: 1, // Square
      1: 1.2, // Wide
      2: 0.8, // Tall
      3: 1.6, // Extra wide
    };

    return ratios[position] ?? 1.0; // Default to square if not specified
  }
}
