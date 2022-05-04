import 'package:appdalada/core/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarGroup extends PreferredSize {
  AppBarGroup({
    Key? key,
    context,
  }) : super(
          key: key,
          preferredSize: Size.fromHeight(100),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 30),
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.principal,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                      onPressed: () => {Navigator.pop(context)},
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Criar grupo',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
}
