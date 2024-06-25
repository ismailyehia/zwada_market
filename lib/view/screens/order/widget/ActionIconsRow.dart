
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ActionIconsRow extends StatelessWidget {
  final String gmLink;
  final String wpNumber;
  final String phoneNumber;

  const ActionIconsRow({
    required this.gmLink,
    required this.wpNumber,
    required this.phoneNumber,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildCircularIcon(
          Icons.map,
          context,
          onTap: () async {
            if (await canLaunchUrl(Uri.parse(gmLink))) {
              await launchUrl(Uri.parse(gmLink));
            } else {
              showCustomSnackBar(
                  // ignore: use_build_context_synchronously
                  getTranslated('Could not launch Direction', context));
            }
          },
        ),
        const SizedBox(
          width: 8.0,
        ),
        _buildCircularIcon(
          Icons.chat_bubble,
          context,
          onTap: () {
            wpMessage(wpNumber, context);
          },
        ),
        const SizedBox(
          width: 8.0,
        ),
        _buildCircularIcon(
          Icons.phone,
          context,
          onTap: () {
            makePhoneCall(context);
          },
        ),
      ],
    );
  }

  Widget _buildCircularIcon(IconData iconData, BuildContext context,
      {Function? onTap}) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        width: 40, // Adjust the size as needed
        height: 40, // Adjust the size as needed
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFebebeb), // Adjust the color as needed
        ),
        child: Center(
          child: Icon(
            iconData,
            size: 25,
            color: const Color(0xFF4e4e4e),
          ),
        ),
      ),
    );
  }

  void makePhoneCall(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  String? phoneNumber = prefs.getString('phone');

  if (phoneNumber != null) {
    String url = 'tel:$phoneNumber';
  
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showCustomSnackBar(getTranslated('Something went wrong', context)!);
    }
  } else {
    // Show error message or handle the case where phone number is not available
  }
}

  // void makePhoneCall(String phoneNumber,    BuildContext context) async {
    
  //   String url = 'tel:$phoneNumber';
    
    

  //   if (await canLaunchUrlString(url)) {
  //     await launchUrlString(url);
  //   } else {
  //     // ignore: use_build_context_synchronously
  //     showCustomSnackBar(getTranslated('Something went wrong', context)!);
  //   }
  // }

  void wpMessage(String phoneNumber, BuildContext context) async {
    Uri url = Uri.parse('https://wa.me/$phoneNumber');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // ignore: use_build_context_synchronously
      showCustomSnackBar(getTranslated('Something went wrong', context)!);
    }
  }
}



