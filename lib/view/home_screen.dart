// مشان اسرق الشكل منها 





import 'package:audio_transcription_app/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zoom_widget/zoom_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool isEdit;
  late TextEditingController textController;
  late String inputText;

  @override
  void initState() {
    isEdit = false;
    textController = TextEditingController();
    // inputText = "With this widget you can create a customizable canvas in which you can zoom in flutter."
    //     "It is possible to customize virtually all the canvases of the canvas such as color, background color, acitvate and deactivate scrolls, change the color of scrolls, modify the sensitivity of the zoom, the initial zoom enters other aspects found in the construction of the Zoom class."
    //     "You only need to create an instance of the Zoom class in the child of your Scaffold or within the widget of your choice, within the child attribute, put the widget that you want to zoom in and the width and height of the canvas where it will be made zoom.";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(onPressed: (){
              setState(() {
                isEdit = !isEdit;
              });
              textController = TextEditingController(text: inputText);
            }, icon: Icon(isEdit ? Icons.close : Icons.edit_outlined)),),
            Expanded(
              child: isEdit? Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor,width: 3,),
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Zoom(
                    maxZoomWidth: Get.width + 100,
                    maxZoomHeight: 1000,
                    colorScrollBars: primaryColor,
                    backgroundColor: Colors.transparent,
                    opacityScrollBars: 0.9,
                    scrollWeight: 10.0,
                    centerOnScale: true,
                    enableScroll: true,
                    doubleTapZoom: true,
                    zoomSensibility: 0.05,
                    child: Center(child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(inputText,style: const TextStyle(fontSize: 20),),
                    )),
                  )) : Center(
                child: TextField(
                  controller: textController,
                  maxLines: 10,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  surfaceTintColor: primaryColor,
                  child: InkWell(
                    onTap: (){},
                    child: Column(
                      children: [
                        Icon(Icons.picture_as_pdf_outlined,color: primaryColor,),
                        Text("Convert to PDF",style: TextStyle(color: primaryColor),)
                      ],
                    ),
                  ),
                ),
                Material(
                  child: InkWell(
                    onTap: (){},
                    child: Column(
                      children: [
                        Icon(Icons.summarize_outlined,color: primaryColor,),
                        Text("Summarize",style: TextStyle(color: primaryColor),)
                      ],
                    ),
                  ),
                ),
                Material(
                  child: InkWell(
                    onTap: (){},
                    child: Column(
                      children: [
                        Icon(Icons.question_answer_outlined,color: primaryColor,),
                        Text("Generate Questions",style: TextStyle(color: primaryColor,),)
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
