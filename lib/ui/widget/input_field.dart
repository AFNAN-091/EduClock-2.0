import 'package:flutter/material.dart';
import 'package:routine_management/ui/theme.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final bool isRequired;
  final bool isDescription;
  const MyInputField({super.key, required this.title, required this.hint,this.controller, required this.isRequired,required this.isDescription, this.widget});
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children:[
                Text(
                  title,
                  style: titleStyle,
                ),
                if(isRequired)
                  const Text(
                    " *",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
              ]
            ),

            Container(
              height: isDescription ? 100 : 50,
              margin: const EdgeInsets.only(top: 10, right: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      readOnly: widget == null ? false : true,
                      autofocus: false,
                      maxLines: isDescription ? 4 : 1,
                      cursorColor: Colors.grey[700],
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: subTitleStyle,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(left: 10),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: primaryColor,
                              width: 0
                          )
                        )
                      ),
                      style: titleStyle,
                    ),
                  ),
                  widget == null? Container() : Container(child: widget)
                ],

              ),

            )
          ],
        )
    );
  }
}
