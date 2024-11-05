import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:single_line_rawing/controllers/rate_bloc.dart';
import 'package:single_line_rawing/core/constants/colors.dart';
import 'package:single_line_rawing/core/constants/size_globals.dart';

class CustomRatingDialog extends StatefulWidget {
  final bool isHome;
  const CustomRatingDialog({super.key, this.isHome = false});

  @override
  State<CustomRatingDialog> createState() => _CustomRatingDialogState();
}

class _CustomRatingDialogState extends State<CustomRatingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final InAppReview _inAppReview = InAppReview.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final ValueNotifier<int> _rating = ValueNotifier<int>(5);
  final ValueNotifier<bool> _isRated = ValueNotifier<bool>(false);

  final List<String> _ratingFaces = [
    'assets/svgs/sad_face.svg',
    'assets/svgs/very_sad_face.svg',
    'assets/svgs/neutral_face.svg',
    'assets/svgs/smile_face.svg',
    'assets/svgs/happy_face.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0.r),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 22.0.h, horizontal: 12.0.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0.r),
          ),
          child: ValueListenableBuilder<bool>(
            valueListenable: _isRated,
            builder: (context, isRated, child) {
              if (isRated && _rating.value <= 3) {
                Timer(const Duration(seconds: 3), () {
                  Navigator.pop(context);
                });
                return _thankYouMessage();
              } else {
                return _ratingMessage(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _thankYouMessage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/svgs/send_oke.svg',
          height: 100.0.h,
        ),
        SizedBox(height: 16.0.h),
        Text(
          AppLocalizations.of(context).thank_you,
          style: TextStyle(
            fontFamily: "Draw-Medium",
            color: GlobalColor.mediumBlue,
            fontSize: GlobalFontSize.textSize_S20,
          ),
        ),
        SizedBox(height: 8.0.h),
        Text(
          AppLocalizations.of(context).your_feedback,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Draw-Regular",
            color: const Color(0xff2E2E2E),
            fontSize: GlobalFontSize.textSize_S18,
          ),
        ),
      ],
    );
  }

  Widget _ratingMessage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _rating,
          builder: (context, rating, child) {
            return SvgPicture.asset(
              rating > 0 && rating <= _ratingFaces.length
                  ? _ratingFaces[rating - 1]
                  : 'assets/svgs/sad_face.svg',
              height: 64.0.h,
              width: 64.0.h,
            );
          },
        ),
        SizedBox(height: 16.0.h),
        Text(
          AppLocalizations.of(context).like_app,
          style: TextStyle(
            fontFamily: "Draw-Medium",
            color: GlobalColor.mediumBlue,
            fontSize: GlobalFontSize.textSize_S18,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.0.h),
        Text(
          AppLocalizations.of(context).give_rating,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Draw-Regular",
            color: const Color(0xff485972),
            fontSize: GlobalFontSize.textSize_S15,
          ),
        ),
        SizedBox(height: 16.0.h),
        ValueListenableBuilder<int>(
          valueListenable: _rating,
          builder: (context, rating, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => GestureDetector(
                  onTap: () => _rating.value = index + 1,
                  child: Image.asset(
                    rating >= index + 1
                        ? 'assets/images/star_filled.png'
                        : 'assets/images/star_outline.png',
                    height: 48.0.h,
                    width: 48.0.h,
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 20.0.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              _isRated.value = true;
              context.read<RateBloc>().setRate(true);
              if (_rating.value >= 4) {
                Navigator.pop(context);
                // Gọi đến package in_app_review
                try {
                  final isAvailable = await _inAppReview.isAvailable();
                  if (isAvailable) {
                    await _inAppReview.requestReview().then((_) {
                      if (widget.isHome) SystemNavigator.pop();
                    });
                  }
                } catch (e) {
                  // Xử lý lỗi nếu cần
                  print('Error requesting review: $e');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GlobalColor.secondaryColor,
              padding: EdgeInsets.symmetric(
                vertical: 12.0.h,
              ),
              textStyle: TextStyle(
                fontSize: GlobalFontSize.textSize_S16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              elevation: 0,
            ),
            child: Text(
              AppLocalizations.of(context).rate,
              style: TextStyle(
                fontFamily: "Draw-SemiBold",
                color: Colors.white,
                fontSize: GlobalFontSize.textSize_S18,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.0.h),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (widget.isHome) {
              SystemNavigator.pop();
            }
          },
          child: Text(
            AppLocalizations.of(context).later,
            style: TextStyle(
              fontFamily: "Draw-Regular",
              color: const Color(0xff485972),
              fontSize: GlobalFontSize.textSize_S18,
            ),
          ),
        ),
      ],
    );
  }
}
