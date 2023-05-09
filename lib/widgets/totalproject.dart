
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../screen/constants.dart';


class InfoCardt extends StatelessWidget {
  final String title;
  final int effectedNum;
  final Color iconColor;
  // final Function press;
  InfoCardt(
      this.title,
      this.effectedNum,
      this.iconColor

      ) ;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: (){

          },
          child: Expanded(
            child: Container(


              // Here constraints.maxWidth provide us the available width for the widget
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Column(

                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          // wrapped within an expanded widget to allow for small density device

                            Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: iconColor.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/running.svg",
                                height: 12,
                                width: 12,
                                color: iconColor,
                              ),
                            ),

                          SizedBox(width: 10),
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,right: 10,left: 10),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: kTextColor),

                          children: [

                            TextSpan(
                              text: "$effectedNum \n",
                              style:
                              Theme.of(context).textTheme.headline3?.copyWith(
                                fontWeight: FontWeight.bold,

                              ),
                            ),
                            TextSpan(
                              text: "Project",
                              style: TextStyle(
                                fontSize: 12,
                                height: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


}

