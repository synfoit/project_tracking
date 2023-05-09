import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../screen/constants.dart';



class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var assetsImage =  AssetImage(
        'assets/images/logo.png');
    return Column(
      children: [
        SizedBox(height: defaultPadding * 2),

        SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 2,
              child: Image(
                image: assetsImage,
                ),
             // child: SvgPicture.asset("assets/icons/login.svg"),
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}    //<- Creates an object that fetches an image.
