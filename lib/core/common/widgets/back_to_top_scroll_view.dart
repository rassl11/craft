import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/assignments/presentation/blocs/scroll/scroll_button_bloc.dart';

class BackToTopScrollView extends StatefulWidget {
  final Widget child;

  const BackToTopScrollView({super.key, required this.child});

  @override
  State<BackToTopScrollView> createState() => _BackToTopScrollViewState();
}

class _BackToTopScrollViewState extends State<BackToTopScrollView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset >= 200) {
        context.read<ScrollBloc>().add(ViewScrolledForward());
      } else {
        context.read<ScrollBloc>().add(ViewScrolledToStart());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScrollBloc, ScrollState>(
      listener: (context, state) {
        if (state is ScrollUp) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
