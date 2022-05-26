import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTest extends StatefulWidget {
  const ShimmerTest({Key? key}) : super(key: key);

  @override
  State<ShimmerTest> createState() => _ShimmerTestState();
}

class _ShimmerTestState extends State<ShimmerTest> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 224, 224, 224),
          highlightColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width * 0.4,
                  height: height * 0.02,
                  color: Colors.white,
                ),
                Container(
                  width: width * 0.4,
                  height: height * 0.25,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
