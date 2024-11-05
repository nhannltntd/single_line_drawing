import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:single_line_rawing/controllers/rate_bloc.dart';
import 'package:single_line_rawing/core/constants/colors.dart';
import 'package:single_line_rawing/core/constants/size_globals.dart';
import 'package:single_line_rawing/views/pages/language_page.dart';
import 'package:single_line_rawing/views/setting/policy_page.dart';
import '../widgets/custom_rate_dialog.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSharing = false;
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
          AppLocalizations.of(context).setting,
          style: TextStyle(
            fontFamily: "Draw-Bold",
            color: GlobalColor.mediumBlue,
            fontSize: GlobalFontSize.textButtonPopup_S20,
          ),
        ),
        centerTitle: true,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            listItem(
              'assets/svgs/st_language.svg',
              AppLocalizations.of(context).language,
              context,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LanguagePage(
                            isSetting: true,
                          )),
                );
              },
            ),
            BlocBuilder<RateBloc, RateState>(builder: (context, state) {
              return !state.isRate
                  ? listItem(
                      'assets/svgs/st_rating.svg',
                      AppLocalizations.of(context).rate,
                      context,
                      () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return const CustomRatingDialog();
                          },
                        );
                      },
                    )
                  : const SizedBox();
            }),
            listItem(
              'assets/svgs/st_policy.svg',
              AppLocalizations.of(context).policy,
              context,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PolicyPage()),
                );
              },
            ),
            listItem(
              'assets/svgs/st_share.svg',
              AppLocalizations.of(context).share,
              context,
              () async {
                if (!isSharing) {
                  isSharing = true;
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();
                  String applicationId = packageInfo.packageName;
                  await Share.share(
                    'Check out this cool app:\nGoogle Play: https://play.google.com/store/apps/details?id=$applicationId',
                  ).then((_) {
                    isSharing = false;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget listItem(String leadingIcon, String text, BuildContext context,
      VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: SvgPicture.asset(
          leadingIcon,
        ),
        title: Text(
          text,
          style: const TextStyle(
            fontFamily: "Draw-Medium",
            color: GlobalColor.mediumBlue,
            fontSize: 20,
          ),
        ),
        trailing: SvgPicture.asset('assets/svgs/forward.svg'),
        onTap: onTap,
      ),
    );
  }
}
