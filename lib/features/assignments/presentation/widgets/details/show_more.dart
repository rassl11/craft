import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import 'underline_text.dart';

class ShowMore extends StatelessWidget {
  final int? _numberOfHiddenDocuments;
  final bool _isNumberless;
  final VoidCallback? _onTap;

  const ShowMore({
    super.key,
    int? numberOfHiddenDocuments,
    bool isNumberless = false,
    void Function()? onTap,
  })  : _onTap = onTap,
        _isNumberless = isNumberless,
        _numberOfHiddenDocuments = numberOfHiddenDocuments;

  @override
  Widget build(BuildContext context) {
    if (_isNumberless) {
      return UnderlineText(textToShow: S.current.showMore, onTap: _onTap);
    }

    if (_numberOfHiddenDocuments == null || _numberOfHiddenDocuments == 0) {
      return const SizedBox(height: 8);
    }

    return UnderlineText(
      textToShow: S.current.showMoreNumber(_numberOfHiddenDocuments!),
      onTap: _onTap,
    );
  }
}
