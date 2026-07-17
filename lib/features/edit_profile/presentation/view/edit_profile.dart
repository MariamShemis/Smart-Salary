import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/utils/ui_utils.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/features/edit_profile/data/cubit/edit_profile_cubit.dart';
import 'package:smart_salary/features/edit_profile/data/cubit/edit_profile_state.dart';
import 'package:smart_salary/features/edit_profile/presentation/widget/custom_profile_field.dart';
import 'package:smart_salary/features/edit_profile/presentation/widget/profile_brithday_field.dart';
import 'package:smart_salary/features/edit_profile/presentation/widget/profile_gender_drop_down.dart';
import 'package:smart_salary/features/main_layout/profile/presentation/widgets/user_image_profile.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _jobController = TextEditingController();
  final _birthdayController = TextEditingController();
  String? _selectedGender;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _jobController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    context.read<EditProfileCubit>().loadProfile();
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return MainGradientBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Text(appLocalizations.editProfile),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state is EditProfileSaving) {
              UiUtils.showLoading(context, isDismissible: false);
            }
            if (state is EditProfileLoaded) {
              _nameController.text = state.profile.name;
              _emailController.text = state.profile.email;
              _phoneController.text = state.profile.phone;
              _jobController.text = state.profile.jobTitle ?? "";
              _birthdayController.text = state.profile.birthday ?? "";
              _selectedGender = state.profile.gender;
            }
            if (state is EditProfileSuccess) {
              Navigator.pop(context);
              UiUtils.showSuccess(context, "Profile updated successfully");
              Navigator.pop(context, true);
            }
            if (state is EditProfileError) {
              Navigator.pop(context);
              UiUtils.showError(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is EditProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: REdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: UserImageProfile(
                      radius: 20.r,
                      image: CircleAvatar(
                        radius: 50.r,
                        backgroundColor: ColorManager.greyText,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (state is EditProfileLoaded &&
                                  state.profile.image != null &&
                                  state.profile.image!.isNotEmpty)
                            ? NetworkImage(state.profile.image!)
                            : null,
                        child:
                            _profileImage == null &&
                                (state is! EditProfileLoaded ||
                                    state.profile.image == null ||
                                    state.profile.image!.isEmpty)
                            ? Icon(
                                Icons.person,
                                size: 35.sp,
                                color: ColorManager.white,
                              )
                            : null,
                      ),
                      onTap: _showBottomSheetImage,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  CustomProfileField(
                    title: appLocalizations.name.toUpperCase(),
                    hintText: appLocalizations.enterYourName,
                    controller: _nameController,
                  ),

                  SizedBox(height: 20.h),

                  CustomProfileField(
                    title: appLocalizations.email.toUpperCase(),
                    hintText: appLocalizations.enterYourEmail,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: 20.h),

                  CustomProfileField(
                    title: appLocalizations.phoneNumber,
                    hintText: appLocalizations.enterYourPhoneNumber,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),

                  SizedBox(height: 20.h),

                  CustomProfileField(
                    title: appLocalizations.jobTitle.toUpperCase(),
                    hintText: appLocalizations.enter_your_job,
                    controller: _jobController,
                  ),

                  SizedBox(height: 20.h),

                  ProfileBirthdayField(controller: _birthdayController),

                  SizedBox(height: 20.h),

                  ProfileGenderDropdown(
                    selectedValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),

                  SizedBox(height: 40.h),

                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: _saveProfileToFirebase,
                      child: Text(appLocalizations.saveChanges.toUpperCase()),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _saveProfileToFirebase() {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      return;
    }

    context.read<EditProfileCubit>().updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      jobTitle: _jobController.text.trim(),
      birthday: _birthdayController.text.trim(),
      gender: _selectedGender ?? "",
      image: _profileImage,
    );
  }

  void _showBottomSheetImage() {
    final appLocalizations = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => Padding(
        padding: REdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => _pickImage(ImageSource.camera),
              child: Row(
                children: [
                  const Icon(Icons.photo_camera_outlined),
                  SizedBox(width: 10.w),
                  Text(appLocalizations.take_a_photo),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            InkWell(
              onTap: () => _pickImage(ImageSource.gallery),
              child: Row(
                children: [
                  const Icon(Icons.photo_library_outlined),
                  SizedBox(width: 10.w),
                  Text(appLocalizations.choose_from_gallery),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
