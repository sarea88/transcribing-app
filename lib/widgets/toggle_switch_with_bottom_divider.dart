import 'package:audio_transcription_app/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ToggleSwitchWithBottomDivider extends StatefulWidget {
  const ToggleSwitchWithBottomDivider({Key? key, required this.labels,this.onToggle})
      : super(key: key);
  final List<String> labels;
  final Function(int)? onToggle ;

  @override
  State<ToggleSwitchWithBottomDivider> createState() =>
      _ToggleSwitchWithBottomDividerState();
}

class _ToggleSwitchWithBottomDividerState
    extends State<ToggleSwitchWithBottomDivider> {
  late int currentIndex;

  @override
  void initState() {
    currentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          widget.labels.length,
          (index) => TextButton(
            onPressed: () {
              setState(() {
                currentIndex = index;
              });
              widget.onToggle?.call(currentIndex);
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(widget.labels[index],),
                  Visibility(
                    visible: currentIndex == index ? true : false,
                    child: SizedBox(width: Get.width /6,child: Divider(color: primaryColor,thickness: 3,))
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
