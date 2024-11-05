import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:single_line_rawing/core/constants/colors.dart';
import 'package:single_line_rawing/services/android_version_check.dart';
import '../../core/constants/size_globals.dart';
import '../setting/setting_page.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage>
    with WidgetsBindingObserver {
  bool? _isAndroid13OrAbove;
  bool _hasStoragePermission = false;
  bool _hasNotificationPermission = false;
  bool _isStoragePermPermanentlyDenied = false;
  bool _isNotificationPermPermanentlyDenied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAndroidVersion();
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkAndroidVersion() async {
    final isAndroid13 = await AndroidVersionCheck.getIsAndroid13OrAbove();

    setState(() {
      _isAndroid13OrAbove = isAndroid13;
    });
  }

  Future<void> _checkPermissions() async {
    final storage = await Permission.storage.status;
    final notification = await Permission.notification.status;

    setState(() {
      _hasStoragePermission = storage.isGranted;
      _hasNotificationPermission = notification.isGranted;
    });
  }

  Future<void> _requestStoragePermission() async {
    if (_isStoragePermPermanentlyDenied) {
      if (!mounted) return;
      openAppSettings();
      return;
    }

    final status = await Permission.storage.request();

    if (status.isPermanentlyDenied) {
      setState(() {
        _isStoragePermPermanentlyDenied = true;
      });
    }

    setState(() {
      _hasStoragePermission = status.isGranted;
    });
  }

  Future<void> _requestNotificationPermission() async {
    if (_isNotificationPermPermanentlyDenied) {
      if (!mounted) return;
      openAppSettings();
      return;
    }

    final status = await Permission.notification.request();

    if (status.isPermanentlyDenied) {
      setState(() {
        _isNotificationPermPermanentlyDenied = true;
      });
    }

    setState(() {
      _hasNotificationPermission = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool canContinue = _isAndroid13OrAbove == true
        ? _hasNotificationPermission
        : _hasStoragePermission;

    return Scaffold(
      backgroundColor: AppColor.backgroundMain,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).permission_screen,
          style: TextStyle(
            fontFamily: "Draw-SemiBold",
            fontSize: GlobalFontSize.textSize_S2105,
            color: GlobalColor.mediumBlue,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70.h,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/svgs/ic_lock_permission.svg",
                    width: 160.w,
                    height: 160.h,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                AppLocalizations.of(context).permission_title,
                style: TextStyle(
                  fontFamily: "Draw-Regular",
                  color: const Color(0xff485972),
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ListTile(
                  trailing: Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: _isAndroid13OrAbove == true
                          ? true
                          : _hasStoragePermission,
                      onChanged: (value) => _isAndroid13OrAbove == true ||
                              _hasStoragePermission == true
                          ? null
                          : _requestStoragePermission(),
                      trackColor: const Color(0xffBABABA),
                      activeColor: const Color(0xffFFC843),
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context).storage,
                    style: TextStyle(
                      fontFamily: "Draw-Medium",
                      fontSize: 18.sp,
                      color: const Color(0xff485972),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              if (_isAndroid13OrAbove == true)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: ListTile(
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: _hasNotificationPermission,
                        onChanged: (value) => _hasNotificationPermission == true
                            ? null
                            : _requestNotificationPermission(),
                        trackColor: const Color(0xffBABABA),
                        activeColor: const Color(0xffFFC843),
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context).notifications,
                      style: TextStyle(
                        fontFamily: "Draw-Medium",
                        fontSize: 18.sp,
                        color: const Color(0xff485972),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 40),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingPage()),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    canContinue
                        ? AppLocalizations.of(context).continue_per
                        : AppLocalizations.of(context).cont_without_permission,
                    style: TextStyle(
                      fontFamily: "Draw-Medium",
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
