import 'package:appdalada/core/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarExplorarRoute extends PreferredSize {
  AppBarExplorarRoute({
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
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 1.5), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Explorar Rotas',
                        style: GoogleFonts.quicksand(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
}
