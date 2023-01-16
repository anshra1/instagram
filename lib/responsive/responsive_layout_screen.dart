import 'package:flutter/cupertino.dart';
import 'package:instagram/utils/dimensions.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.webScreenLayout,
    required this.mobileScreenLayout,
    Key? key}) : super(key: key);

  final Widget webScreenLayout;
  final mobileScreenLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constrainsts){
      if(constrainsts.maxWidth > webScreenSize){
        return webScreenLayout;
      }
      return mobileScreenLayout;
    });
  }
}
