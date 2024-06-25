import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/time_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class TimerView extends StatefulWidget {
  const TimerView({Key? key}) : super(key: key);

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
        builder: (context, orderTimer, child) {
          if (orderTimer.duration != null) {
          }
          return Column( children: [
            Image.asset(Images.logo, height: 200),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            // Text(
            //   minutes! < 5 ? getTranslated('be_prepared_your_delivery', context)! : getTranslated('your_delivery', context)!,
            //   style: rubikRegular.copyWith(color: Theme.of(context).hintColor),
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            // ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],);

        }
    );
  }
}


class TimerBox extends StatelessWidget {
  final int? time;
  final bool isBorder;
  final String? text;

  const TimerBox({Key? key,  this.time, this.isBorder = false, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isBorder ? null : Theme.of(context).primaryColor,
        border: isBorder ? Border.all(width: 1, color: Theme.of(context).primaryColor) : null,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(time! < 10 ? '0$time' : time.toString(),
              style: rubikMedium.copyWith(
                color: isBorder ? Theme.of(context).primaryColor : Theme.of(context).highlightColor,
                fontSize: Dimensions.fontSizeLarge,
              ),
            ),
            Text(text!, style: rubikRegular.copyWith(color: isBorder ?
            Theme.of(context).primaryColor : Theme.of(context).highlightColor,
              fontSize: Dimensions.fontSizeSmall,)),
          ],
        ),
      ),
    );
  }
}

