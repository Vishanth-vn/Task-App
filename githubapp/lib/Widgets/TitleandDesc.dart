import 'package:flutter/material.dart';
import 'package:githubapp/Styles/appColors.dart';
import 'package:githubapp/Styles/textCollection.dart';

// Used in many places so it is extracted into widget for Resuablity.
Column TitleandDesc(
  name,
  desc,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        name,
        style: TextStyleCollection.mediumRegularTextStyle14.copyWith(
          color: AppColors.themeColor,
        ),
      ),
      const SizedBox(
        height: 3,
      ),
      SelectableText(
        desc ?? "Description not available.",
        style: TextStyleCollection.mediumRegularTextStyle16.copyWith(),
      ),
      const SizedBox(
        height: 15,
      ),
    ],
  );
}
