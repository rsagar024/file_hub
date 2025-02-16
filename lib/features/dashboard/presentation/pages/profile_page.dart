import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vap_uploader/core/di/di.dart';
import 'package:vap_uploader/core/resources/common/image_resources.dart';
import 'package:vap_uploader/core/resources/themes/text_styles.dart';
import 'package:vap_uploader/core/services/auth_service/auth_service.dart';
import 'package:vap_uploader/features/auth/presentation/pages/auth_pin_page.dart';
import 'package:vap_uploader/features/auth/presentation/pages/on_boarding_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: 240,
                width: MediaQuery.sizeOf(context).width,
                alignment: Alignment.topCenter,
                child: Container(
                  height: 170,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/background.jpg'), fit: BoxFit.fitHeight),
                  ),
                ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                top: 115,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/pic.jpg'),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: PopupMenuButton<int>(
                  color: const Color(0xFF383B49),
                  offset: const Offset(-10, 45),
                  elevation: 1,
                  icon: CircleAvatar(backgroundColor: Colors.white12, child: SvgPicture.asset(ImageResources.iconMore)),
                  padding: EdgeInsets.zero,
                  onSelected: (value) async {
                    switch (value) {
                      case 1:
                        break;
                      case 2:
                        await getIt<AuthService>().signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnBoardingPage(),
                            ));
                        break;
                      case 3:
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthPinPage(setup: true)));
                        break;
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 1,
                        height: 30,
                        child: Text('Edit', style: TextStyle(fontSize: 12, color: Color(0xFFEEEEEE))),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        height: 30,
                        child: Text('Logout', style: TextStyle(fontSize: 12, color: Color(0xFFEEEEEE))),
                      ),
                      const PopupMenuItem(
                        value: 3,
                        height: 30,
                        child: Text('Setup Pin', style: TextStyle(fontSize: 12, color: Color(0xFFEEEEEE))),
                      ),
                    ];
                  },
                ),
              ),
            ],
          ),
          Text(
            'Raj Kumar',
            style: CustomTextStyles.baseStyle.copyWith(fontSize: 25, fontWeight: FontWeight.w700),
          ),
          Text(
            'Mobile Application Developer, Ethical Hacker * Passionate about innovation, meticulous design and best global product.',
            textAlign: TextAlign.center,
            style: CustomTextStyles.custom14Regular,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              await getIt<AuthService>().signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnBoardingPage(),
                  ));
            },
            child: Text(
              'Sign Out',
              style: CustomTextStyles.custom14Regular.copyWith(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
