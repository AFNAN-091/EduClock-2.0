import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routine_management/ui/theme.dart';
import '../models/notice_model.dart';

class NoticeBar extends StatelessWidget {

  final Notice notice;
  const NoticeBar({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 6, top: 6),
        child: Container(
        padding: const EdgeInsets.all(16),
      //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _getBGClr(notice.color ?? 0),
        ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notice?.title ?? "",
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 5,),
                        Text(notice.date?.substring(0,10) ?? "",
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              )
            ],

          ),

      )
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return yellowDarkColor;
      case 1:
        return pinkishColor;
      case 2:
        return pink;
      case 3:
        return sky;
      case 4:
        return lightGreen;
      default:
        return light;
    }
  }
}
