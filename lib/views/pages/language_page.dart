import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:single_line_rawing/core/constants/colors.dart';
import 'package:single_line_rawing/core/constants/size_globals.dart';
import 'package:single_line_rawing/models/language_model.dart';
import 'package:single_line_rawing/views/pages/onboarding_screen.dart';
import 'package:single_line_rawing/views/widgets/box_outline_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../controllers/language/localization_bloc.dart';

class LanguagePage extends StatefulWidget {
  final bool isSetting;
  const LanguagePage({super.key, this.isSetting = false});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final List<LanguageModel> languageModel = [
    LanguageModel(language: 'English', languageCode: 'en'),
    LanguageModel(language: 'Français', languageCode: 'fr'),
    LanguageModel(language: 'Português', languageCode: 'pt'),
    LanguageModel(language: 'Español', languageCode: 'es'),
    LanguageModel(language: 'हिंदी', languageCode: 'hi'),
  ];

  @override
  Widget build(BuildContext context) {
    var groupValue = context.read<LocalizationBloc>().state.locale.languageCode;

    return BlocConsumer<LocalizationBloc, LocalizationState>(
      listener: (context, state) {
        groupValue = state.locale.languageCode;
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: GlobalColor.bgAppColor,
          appBar: widget.isSetting
              ? AppBar(
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
                    AppLocalizations.of(context).language,
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
                )
              : AppBar(
                  title: Text(
                    AppLocalizations.of(context).languages,
                    style: TextStyle(
                      fontFamily: "Draw-SemiBold",
                      color: GlobalColor.mediumBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: GlobalFontSize.headerPopup_S22,
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  backgroundColor: AppColor.backgroundMain,
                  elevation: 0,
                  toolbarHeight: 80.h,
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: GlobalSize.size_12),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OnboardingScreen()),
                          );
                        },
                        child: SvgPicture.asset(
                          "assets/svgs/check.svg",
                        ),
                      ),
                    )
                  ],
                ),
          body: Padding(
            padding: EdgeInsets.all(16.0.r),
            child: ListView.builder(
              itemCount: languageModel.length,
              itemBuilder: (context, index) {
                var item = languageModel[index];
                return InkWell(
                  onTap: () {
                    BlocProvider.of<LocalizationBloc>(context)
                        .add(LoadLocalization(Locale(item.languageCode)));

                    if (widget.isSetting) {
                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(6.0.r),
                    child: BoxOutlineButton(
                      isBackgroundColor:
                          groupValue == item.languageCode ? true : false,
                      isShadowColor:
                          groupValue == item.languageCode ? true : false,
                      title: item.language,
                      leadingWidget: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image(
                          image: AssetImage(
                              "assets/images/${item.languageCode}.png"),
                          width: 30.0,
                          height: 30.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
