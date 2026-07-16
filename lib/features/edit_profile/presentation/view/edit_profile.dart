import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_salary/core/costants/color_manager.dart';
import 'package:smart_salary/core/widgets/main_gradient_background.dart';
import 'package:smart_salary/l10n/app_localizations.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // تعريف الـ Controllers لاستقبال البيانات وإرسالها لـ Firebase
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _jobController = TextEditingController();
  final _birthdayController = TextEditingController();

  String? _selectedGender; // لتخزين النوع (ذكر / أنثى)

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _jobController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  // ميثود لاختيار التاريخ (Date Picker) بشكل أنيق
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorManager.primaryColor, // لون تحديد التاريخ ذهبي
              onPrimary: ColorManager.white,
              onSurface: ColorManager.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return MainGradientBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: REdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60.r,
                      backgroundColor: ColorManager.grey,
                      backgroundImage: const NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          // هنا هتستدعي ميثود الـ Image Picker عشان تختار الصورة
                        },
                        child: Container(
                          padding: REdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: ColorManager.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: ColorManager.white,
                            size: 20.r,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              _buildFieldTitle(appLocalizations.name.toUpperCase()),
              TextFormField(
                controller: _nameController,
                decoration:  InputDecoration(
                  hintText: appLocalizations.enterYourName,
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              SizedBox(height: 20.h),
              _buildFieldTitle(appLocalizations.email.toUpperCase()),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: appLocalizations.enterYourEmail,
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              SizedBox(height: 20.h),
      
              // 4. حقل رقم التليفون
              _buildFieldTitle(appLocalizations.phoneNumber),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: appLocalizations.enterYourPhoneNumber,
                  prefixIcon: Icon(Icons.phone_android_outlined),
                ),
              ),
              SizedBox(height: 20.h),
      
              // 5. حقل الوظيفة
              _buildFieldTitle(appLocalizations.jobTitle.toUpperCase()),
              TextFormField(
                controller: _jobController,
                decoration: InputDecoration(
                  hintText: appLocalizations.enter_your_job,
                  prefixIcon: Icon(Icons.work_outline),
                ),
              ),
              SizedBox(height: 20.h),
      
              // 6. حقل عيد الميلاد (DatePicker)
              _buildFieldTitle(appLocalizations.name.toUpperCase()),
              TextFormField(
                controller: _birthdayController,
                readOnly: true, // عشان يفتح الـ Calendar لما يضغط وميكتبش يدوي
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  hintText: appLocalizations.select_your_birthday,
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
              ),
              SizedBox(height: 20.h),
      
              // 7. حقل النوع (Dropdown)
              _buildFieldTitle(appLocalizations.gender.toUpperCase()),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                icon: const Icon(Icons.keyboard_arrow_down),
                decoration: InputDecoration(
                  hintText: appLocalizations.selectGender,
                  prefixIcon: Icon(Icons.people_outline),
                ),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male (ذكر)')),
                  DropdownMenuItem(value: 'Female', child: Text('Female (أنثى)')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              SizedBox(height: 40.h),
      
              // 8. زرار حفظ التغييرات
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    // الميثود اللي هترفع الداتا لـ Firebase
                    _saveProfileToFirebase();
                  },
                  child: Text(appLocalizations.saveChanges.toUpperCase()),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت بسيطة لرسم عناوين الحقول بشكل متناسق مع تصميمك القديم
  Widget _buildFieldTitle(String title) {
    return Padding(
      padding: REdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: ColorManager.black,
        ),
      ),
    );
  }

  // كود مبدئي لكيفية الحفظ في Firebase (Firestore)
  void _saveProfileToFirebase() {
    // 1. تجميع البيانات
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final job = _jobController.text.trim();
    final birthday = _birthdayController.text;
    final gender = _selectedGender;

    // 2. التحقق من البيانات (Validation)
    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Email are required!')),
      );
      return;
    }

    // 3. كود الرفع لـ Firestore (هتفعلي السطور دي لما تربطي الـ SDK)
    /*
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'job': job,
        'birthday': birthday,
        'gender': gender,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Updated Successfully!')),
        );
      });
    }
    */
  }
}