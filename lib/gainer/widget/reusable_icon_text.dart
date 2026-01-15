import 'package:flutter/material.dart';
import '../screens/colors.dart';

Widget buildStageRow(List<Widget> children) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: children,
  );
}

Widget buildIconWithLabel(IconData icon, VoidCallback onTap,
    String label, int nos, double value ,{String? url}) {
  String nosString = nos > 0 ? '$nos No.' : '-';
  String valueString = value > 0 ? '${value.toStringAsFixed(2)} Lac' : '-';
  return Expanded(
    child: Column(
      children: [
        CustomIconButtonWithLabel(
          icon: icon,
          url: url,
          label: label,
          onTap: onTap,
        ),
        // const SizedBox(height: 10),
        // Text('$nos No.| ${value.toStringAsFixed(2)} Lac', style: const TextStyle(fontSize: 12)),
        nos > 0
            ? Text('$nosString | $valueString',
                style: const TextStyle(fontSize: 12))
            : Text('-', style: const TextStyle(fontSize: 12)),
        // Text('Nos: $nos', style: const TextStyle(fontSize: 12)),
        // const Divider(),
        // Center(child: SizedBox( width: mq.width*.25,child: const Divider())),
        // Text('Value: ${value.toStringAsFixed(2)} L',style: const TextStyle(fontSize: 12)
        // Text('Value: ${value.toStringAsFixed(2)} L',style: const TextStyle(fontSize: 12)
        // ),
      ],
    ),
  );
}

class CustomIconButtonWithLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? url;

  const CustomIconButtonWithLabel({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          // radius: 28,
          borderRadius: BorderRadius.circular(8), // adjust corner radius
          // backgroundColor: Colors.black12,
          child: IconButton(
            onPressed: onTap,
            // icon: Icon(icon,size: 40, color: AppColor.primary,)
            icon: url != null
                ? Image.asset(
                    url!,
                    height: 60,
                  )
                : Icon(
                    icon,
                    size: 40,
                    color: AppColor.primary,
                  ),
          ),
        ),
        // IconButton(
        //   onPressed: onTap,
        //   icon: Icon(
        //     icon,
        //     size: 48,
        //     color: AppColor.primary,
        //   ),
        //   highlightColor: AppColor.primaryShade,
        // ),
        // SizedBox(height: mq.height*.01),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
