import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:single_line_rawing/core/constants/colors.dart';
import 'package:single_line_rawing/core/constants/size_globals.dart';

class BoxOutlineButton extends StatelessWidget {
  final String title;
  final Widget? leadingWidget;
  final bool isBackgroundColor;
  final bool isShadowColor;
  final double? widthWidget;
  final double? heightWidget;
  const BoxOutlineButton({
    super.key,
    this.title = "",
    this.leadingWidget,
    this.widthWidget = null,
    this.heightWidget = null,
    this.isBackgroundColor = false,
    this.isShadowColor = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthWidget,
      height: heightWidget,
      decoration: BoxDecoration(
        color: isBackgroundColor ? const Color(0xffFEEFBF) : Colors.white,
        borderRadius: BorderRadius.circular(12.0.r),
        border: Border.all(
          color: isBackgroundColor
              ? GlobalColor.secondaryColor
              : Colors.transparent,
          width: 3.0,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              leadingWidget!,
              const SizedBox(
                width: 7,
              ),
              Text(
                title,
                style: TextStyle(
                    fontFamily:
                        isBackgroundColor ? "Draw-SemiBold" : "Draw-Medium",
                    fontSize: GlobalFontSize.textSize_S17,
                    color: const Color(0xff485972)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
