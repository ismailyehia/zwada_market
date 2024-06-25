import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

class ProductButton extends StatelessWidget {
  final Function? onTap;
  final Function? onTap2;
  final String? btnTxt;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final double borderRadius;
  final double? width;
  final double? height;
  final bool transparent;
  final EdgeInsets? margin;

  const ProductButton({
    Key? key,
    this.onTap,
    this.onTap2,
    required this.btnTxt,
    this.backgroundColor,
    this.textStyle,
    this.borderRadius = 10,
    this.width,
    this.transparent = false,
    this.height,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onTap == null
          ? Theme.of(context).disabledColor
          : transparent
              ? Colors.transparent
              : backgroundColor ?? Theme.of(context).primaryColor,
      minimumSize: Size(width != null ? width! : Dimensions.webScreenWidth,
          height != null ? height! : 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    return Row(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: width ?? Dimensions.webScreenWidth / 2,
              child: Padding(
                padding: margin == null ? const EdgeInsets.all(0) : margin!,
                child: TextButton(
                  onPressed: onTap as void Function()?,
                  style: flatButtonStyle,
                  child: Text(
                    btnTxt ?? '',
                    style: textStyle ??
                        Theme.of(context).textTheme.displaySmall!.copyWith(
                              color: Colors.white,
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                  ),
                ),
              ),
            ),
          ),
        ),
        onTap2 != null
            ? const SizedBox(width: Dimensions.paddingSizeSmall)
            : const SizedBox(),
        onTap2 != null
            ? Expanded(
                child: Center(
                  child: Builder(
                    builder: (BuildContext builderContext) => SizedBox(
                      width: width ?? Dimensions.webScreenWidth / 2,
                      child: Padding(
                        padding:
                            margin == null ? const EdgeInsets.all(0) : margin!,
                        child: TextButton(
                          onPressed: onTap2 as void Function()?,
                          style: flatButtonStyle.copyWith(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFFF9BE13)),
                          ),
                          child: Text(
                            getTranslated('View More Offers', context)!,
                            style: textStyle ??
                                Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      color: Colors.white,
                                      fontSize: Dimensions.fontSizeLarge,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
