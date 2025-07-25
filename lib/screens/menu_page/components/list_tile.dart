import 'package:flutter/material.dart';
import 'package:fyp2/config/size_config.dart';
import 'package:flutter_svg/svg.dart';

class MenuListItems extends StatelessWidget {
  final String iconPath;
  final String itemName;
  final VoidCallback function;
  const MenuListItems({
    super.key,
    required this.iconPath,
    required this.itemName,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            SvgPicture.asset(iconPath),
            SizedBox(
              width: getProportionateScreenWidth(25),
            ),
            Text(
              itemName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
