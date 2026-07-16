import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/features/language/data/cubit/language_cubit.dart';
import 'package:smart_salary/features/language/presentation/widget/custom_language_card.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/cubit/language_state.dart';

class LanguageProfile extends StatefulWidget {
  const LanguageProfile({super.key});

  @override
  State<LanguageProfile> createState() => _LanguageProfileState();
}

class _LanguageProfileState extends State<LanguageProfile> {
  String selectedLang = "en";

  @override
  void initState() {
    super.initState();
    selectedLang = context.read<LanguageCubit>().state.locale.languageCode;
  }

  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      initialized = true;
      selectedLang = context.read<LanguageCubit>().state.locale.languageCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    // final currentLang =
    //     context.watch<AppLocalizationCubit>().state.languageCode;
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return MainGradientBackground(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios),
              ),
              title: Text(appLocalizations.selectLanguage),
            ),
            body: Padding(
              padding: REdgeInsets.symmetric(vertical: 18.0, horizontal: 16),
              child: Column(
                children: [
                  Text(
                    appLocalizations
                        .choose_your_preferred_language_for_the_app_interface,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50.h),
                  CustomLanguageCard(
                    title: "English",
                    subTitle: "Default System Language",
                    languageCode: "en",
                    selectedLanguage: selectedLang,
                    onChanged: (value) {
                      setState(() {
                        selectedLang = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  CustomLanguageCard(
                    title: "العربية",
                    subTitle: "Arabic",
                    languageCode: "ar",
                    selectedLanguage: selectedLang,
                    onChanged: (value) {
                      setState(() {
                        selectedLang = value!;
                      });
                    },
                  ),
                  SizedBox(height: 70.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await context.read<LanguageCubit>().changeLanguage(
                          selectedLang,
                        );
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(appLocalizations.saveChanges),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
