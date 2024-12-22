import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vap_uploader/core/common/shapes/dotted_border_painter.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/core/enums/app_enum/page_state_enum.dart';
import 'package:vap_uploader/core/resources/themes/app_colors.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';
import 'package:vap_uploader/core/utilities/custom_snackbar.dart';
import 'package:vap_uploader/core/utilities/dialog_manager.dart';
import 'package:vap_uploader/features/dashboard/presentation/bloc/upload_bloc/upload_bloc.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final uploadBloc = getIt<UploadBloc>();

  @override
  void initState() {
    super.initState();
    uploadBloc.add(InitialUploadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UploadBloc, UploadState>(
        listener: (context, state) {
          if (state.pageState == PageState.loading) {
            if (state.loadingFileSelection) {
              DialogManager().showTransparentProgressDialog(context, message: 'please wait...');
            } else {
              DialogManager().showTransparentProgressDialog(context, message: 'uploading...');
            }
          } else if (state.pageState == PageState.initial) {
            DialogManager().hideTransparentProgressDialog();
          } else if (state.pageState == PageState.error) {
            DialogManager().hideTransparentProgressDialog();
            CustomSnackbar.show(context: context, message: state.errorMessage ?? '', type: SnackbarType.error);
          } else if (state.pageState == PageState.success) {
            DialogManager().hideTransparentProgressDialog();
            if (state.hasUploadedSuccessfully) {
              CustomSnackbar.show(
                context: context,
                message: 'Files are successfully upload.',
                type: SnackbarType.success,
              );
            }
          } else if (state.pageState == PageState.popup) {
            CustomSnackbar.show(context: context, message: state.errorMessage ?? '', type: SnackbarType.error);
          }
        },
        builder: (context, state) {
          final int count = state.files.length;
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 30, 18, 50),
                  child: CustomPaint(
                    painter: DottedBorderPainter(
                      color: AppColors.neutral100,
                      strokeWidth: 0.8,
                      dashPattern: [6, 6],
                    ),
                    size: Size.infinite,
                    isComplex: true,
                    willChange: false,
                    child: state.files.isEmpty
                        ? GestureDetector(
                            onTap: () {
                              uploadBloc.add(FilesSelectionEvent());
                            },
                            child: Container(
                              color: Colors.transparent,
                              height: 192,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/images/image_upload.svg', height: 70),
                                  const SizedBox(height: 5),
                                  Text('select your files', style: CustomTextStyles.custom14Medium),
                                ],
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 61, 20, count == 1 ? 61 : 10),
                                    padding: const EdgeInsets.only(left: 5, right: 10),
                                    height: 70,
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset('assets/images/image_audio.svg', height: 60),
                                        Flexible(
                                          child: Text(
                                            state.files.first.uri.pathSegments.last,
                                            style: CustomTextStyles.custom14Regular.copyWith(color: Colors.black),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (count != 1)
                                    RichText(
                                        text: TextSpan(
                                      text: '+${count - 1} more files ',
                                      style: CustomTextStyles.custom14Regular,
                                      children: [
                                        TextSpan(
                                          text: 'Show All',
                                          style: CustomTextStyles.custom14Regular.copyWith(color: Colors.red),
                                          recognizer: TapGestureRecognizer()..onTap = () {},
                                        )
                                      ],
                                    )),
                                  if (count != 1) const SizedBox(height: 31)
                                ],
                              ),
                              Positioned(
                                right: 15,
                                top: 55,
                                child: GestureDetector(
                                  onTap: () {
                                    uploadBloc.add(FilesRemoveEvent());
                                  },
                                  child: SvgPicture.asset('assets/icons/ic_cross.svg', height: 20),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    uploadBloc.add(FilesUploadEvent());
                  },
                  child: Text(
                    'Upload Files',
                    style: CustomTextStyles.custom14Regular.copyWith(color: Colors.white),
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
