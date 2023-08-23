import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/blocs/status.dart';
import '../../../../core/common/widgets/back_to_top_scroll_view.dart';
import '../../../../core/common/widgets/craftbox_app_bar.dart';
import '../../../../core/common/widgets/craftbox_bottom_sheet.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/utils/assignments_utils.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../generated/l10n.dart';
import '../../../protocol/presentation/pages/protocol_screen.dart';
import '../blocs/detailed_assignment/detailed_assignment_bloc.dart';
import '../blocs/scroll/scroll_button_bloc.dart';
import '../widgets/details/assignment_details.dart';

class AssignmentDetailsScreen extends StatelessWidget {
  static const routeName = '/assignmentDetails';

  const AssignmentDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as AssignmentArguments;
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailedAssignmentBloc>(
          create: (_) => sl<DetailedAssignmentBloc>(),
        ),
        BlocProvider<ScrollBloc>(
          create: (_) => sl<ScrollBloc>(),
        ),
      ],
      child: BlocConsumer<DetailedAssignmentBloc, DetailedAssignmentState>(
        listener: (context, state) {
          if (state.blocStatus == Status.error) {
            showSnackBarWithText(context, state.errorMsg);
          }
        },
        builder: (context, state) {
          final assignment = state.assignment;
          Color backgroundColor = args.inAppAssignmentState.bgColor;
          if (state.blocStatus == Status.loaded && assignment != null) {
            backgroundColor = assignment.state.inAppState.bgColor;
          }

          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: _buildAppBar(
              context,
              backgroundColor,
              state.assignmentSelectionStatus != Status.initial,
            ),
            floatingActionButton: _buildFloatingBackToTopButton(),
            body: _buildBodyScrollView(args, state, context),
            bottomSheet: CraftboxBottomSheet(
              buttonTitle: S.current.assignmentDetailsMainButtonText,
              onButtonPressed: () {
                Navigator.pushNamed(
                  context,
                  ProtocolScreen.routeName,
                  arguments: assignment?.id ?? 0,
                );
              },
            ),
          );
        },
      ),
    );
  }

  CraftboxAppBar _buildAppBar(
    BuildContext context,
    Color backgroundColor,
    bool assignmentStatusWasChanged,
  ) {
    return CraftboxAppBar(
      title: S.current.appointment,
      titleColor: AppColor.white,
      backgroundColor: backgroundColor,
      leadingIconPath: arrowLeft,
      leadingIconColor: AppColor.white,
      onLeadingIconPressed: () =>
          Navigator.of(context).pop(assignmentStatusWasChanged),
    );
  }

  BlocBuilder<ScrollBloc, ScrollState> _buildFloatingBackToTopButton() {
    return BlocBuilder<ScrollBloc, ScrollState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity: (state is ScrollButtonState && state.isVisible) ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: FloatingActionButton(
              mini: true,
              onPressed: () {
                context.read<ScrollBloc>().add(ScrollUpRequested());
              },
              backgroundColor: AppColor.grayControls,
              child: const Icon(Icons.keyboard_arrow_up),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodyScrollView(
    AssignmentArguments args,
    DetailedAssignmentState state,
    BuildContext context,
  ) {
    return BackToTopScrollView(
      child: Stack(
        children: [
          _buildBackground(state),
          _buildForeground(args, state),
        ],
      ),
    );
  }

  Widget _buildBackground(DetailedAssignmentState state) {
    if (state.blocStatus == Status.initial ||
        state.blocStatus == Status.loading ||
        state.blocStatus == Status.error) {
      return Container(
        margin: const EdgeInsets.only(top: 270).h,
        height: 1.sh,
        color: AppColor.background,
      );
    }

    return Positioned.fill(
      child: Container(
        margin: const EdgeInsets.only(top: 270).h,
        color: AppColor.background,
      ),
    );
  }

  Widget _buildForeground(
    AssignmentArguments args,
    DetailedAssignmentState state,
  ) {
    return AssignmentDetails(args: args, state: state);
  }
}

class AssignmentArguments {
  final int id;
  final InAppAssignmentState inAppAssignmentState;
  final String title;

  AssignmentArguments({
    required this.id,
    required this.inAppAssignmentState,
    required this.title,
  });
}
