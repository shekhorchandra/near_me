
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/values/app_color.dart';
import '../../../../../../core/values/app_text.dart';
import '../../../../../../data/models/payment_method_model.dart';

class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    super.key,
    required this.paymentMethod,
    this.isSelectable = false,
    this.isSelected = false,
    this.onSelect,
  });

  final PaymentMethodModel paymentMethod;
  final bool isSelectable;
  final bool isSelected;
  final VoidCallback? onSelect;

  String getMaskedNumber(String number) {
    if (number.length <= 4) return number;
    final masked = '*' * (number.length - 4) + number.substring(number.length - 4);
    return masked.replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isSelectable ? onSelect : null,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: isSelected ? AppColor.primary.withAlpha(30) : Colors.transparent,
        ),
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(paymentMethod.icon),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(paymentMethod.name, style: AppText.body1.semiBold),
                    Text(
                      getMaskedNumber(paymentMethod.number),
                      style: AppText.body1.medium.copyWith(color: Color(0xFF7D7D7D)),
                    ),
                  ],
                ),
              ],
            ),

            Row(
              children: [
                if (isSelectable)
                  Icon(
                    isSelected ? Icons.check_circle : Icons.radio_button_off,
                    color: isSelected ? AppColor.primary : Colors.black,
                  ),
                PopupMenuButton<String>(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onSelected: (value) {
                    if (value == 'delete') {
                      debugPrint('Delete button pressed!');
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded, color: AppColor.error),
                          const SizedBox(width: 10),
                          Text(
                            'Delete',
                            style: AppText.body2.medium.copyWith(color: AppColor.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.more_vert_rounded, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
