import 'package:flutter/material.dart';
import 'package:todo_app_new/core/Theme/app_spacing.dart';
import 'package:todo_app_new/core/Theme/text_styles.dart';

/// Small all-caps label used to separate groups of content. Currently used
/// to bucket tasks into Morning / Afternoon / Evening on the home screen,
/// but generic enough to reuse anywhere grouped content is needed.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.toUpperCase(), style: sectionHeaderStyle),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
