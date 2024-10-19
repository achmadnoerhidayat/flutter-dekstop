import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNav extends StatefulWidget {
  final List<dynamic> buttonNav;
  const BottomNav({super.key, required this.buttonNav});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      color: Colors.white,
      padding: const EdgeInsets.only(top: 15, bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < widget.buttonNav.length; i++)
            Column(
              children: [
                (widget.buttonNav[i]['active'] == "true")
                    ? ElevatedButton(
                        onPressed: () {
                          context.go("${widget.buttonNav[i]['route']}");
                        },
                        child: widget.buttonNav[i]['icon'],
                        style: ElevatedButton.styleFrom(
                            // ignore: use_full_hex_values_for_flutter_colors
                            backgroundColor: const Color(0xfffc59fed)),
                      )
                    : IconButton(
                        onPressed: () {
                          context.go("${widget.buttonNav[i]['route']}");
                        },
                        icon: widget.buttonNav[i]['icon'],
                      ),
                Text(
                  "${widget.buttonNav[i]['name']}",
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
