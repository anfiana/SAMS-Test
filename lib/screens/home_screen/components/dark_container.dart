import 'package:fyp2/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DarkContainer extends StatelessWidget {
  final String iconAsset;
  final VoidCallback onTap;
  final String device;
  final String deviceCount;
  final bool itsOn;
  final VoidCallback switchButton;
  final bool isFav;
  final VoidCallback switchFav;
  const DarkContainer({
    super.key,
    required this.iconAsset,
    required this.onTap,
    required this.device,
    required this.deviceCount,
    required this.itsOn,
    required this.switchButton,
    required this.isFav,
    required this.switchFav,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: getProportionateScreenWidth(140),
        height: getProportionateScreenHeight(140),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: itsOn
              ? const Color(
                  0XFF1A5319) // Change background color when itsOn is true
              : const Color(0xffededed),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(10),
            vertical: getProportionateScreenHeight(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: itsOn
                          ? const Color.fromARGB(255, 255, 255, 255)
                          : const Color(0xffdadada),
                      borderRadius:
                          const BorderRadius.all(Radius.elliptical(45, 45)),
                    ),
                    child: SvgPicture.asset(
                      iconAsset,
                      color: itsOn ? Colors.amber : const Color(0xFF808080),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: itsOn
                              ? Colors.white
                              : Colors
                                  .black, // Text becomes white when itsOn is true
                        ),
                  ),
                  Text(
                    deviceCount,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Color.fromRGBO(166, 166, 166, 1),
                        fontSize: 13,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.6),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    itsOn ? 'On' : 'Off',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: itsOn
                              ? Colors.white
                              : Colors
                                  .black, // Text becomes white when itsOn is true
                        ),
                  ),
                  GestureDetector(
                    onTap: switchButton,
                    child: Container(
                      width: 48,
                      height: 25.6,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: itsOn
                            ? const Color(
                                0XFF1A5319) // Match the background color
                            : const Color(0xffd6d6d6),
                        border: Border.all(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          width: itsOn ? 2 : 0,
                        ),
                      ),
                      child: Row(
                        children: [
                          itsOn ? const Spacer() : const SizedBox(),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
