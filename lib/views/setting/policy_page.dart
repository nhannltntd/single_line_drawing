import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:single_line_rawing/core/constants/colors.dart';
import 'package:single_line_rawing/core/constants/size_globals.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/constants/const_globals.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    bool isTap = false;
    return Scaffold(
      backgroundColor: GlobalColor.bgAppColor,
      appBar: AppBar(
        foregroundColor: GlobalColor.bgAppColor,
        shadowColor: Colors.transparent,
        backgroundColor: GlobalColor.bgAppColor,
        surfaceTintColor: GlobalColor.bgAppColor,
        leading: IconButton(
          icon: SvgPicture.asset('assets/svgs/btn_back.svg'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context).policy,
          style: TextStyle(
            fontFamily: "Draw-Bold",
            color: GlobalColor.mediumBlue,
            fontSize: GlobalFontSize.textButtonPopup_S20,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: GlobalColor.bgAppColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(22.0),
              bottomRight: Radius.circular(22.0),
            ),
          ),
        ),
        elevation: 10,
        automaticallyImplyLeading: true,
        toolbarHeight: 110,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 100.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/icon_app.png",
                  height: 80,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context).app_name,
                  style: const TextStyle(
                    fontFamily: "Draw-Bold",
                    color: GlobalColor.mediumBlue,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<String>(
                  future: _getAppVersion(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(
                        '${AppLocalizations.of(context).version} 1.0.3',
                        style: const TextStyle(
                          fontFamily: "Draw-Regular",
                          color: Color(0xff6c798d),
                          fontSize: 14,
                        ),
                      );
                    } else {
                      return Text(
                        '${AppLocalizations.of(context).version} ${snapshot.data}',
                        style: const TextStyle(
                          fontFamily: "Draw-Regular",
                          color: Color(0xff6c798d),
                          fontSize: 14,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    if (!isTap) {
                      isTap = true;

                      launchUrl(
                        Uri.parse(LINK_POLICY),
                      ).then((_) {
                        isTap = false;
                      });
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context).privacy_policy,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontFamily: "Draw-Medium",
                      color: Color(0xff485972),
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
