import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/bloc/user/user_bloc.dart';
import 'package:kasir_dekstop/models/user_model.dart';
import 'package:kasir_dekstop/page/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController? txtName;
  TextEditingController? txtPass;
  FocusNode focusNode = FocusNode();
  bool ishide = true;
  @override
  void initState() {
    super.initState();
    txtName = TextEditingController();
    txtPass = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    super.dispose();
    txtName!.dispose();
    txtPass!.dispose();
    focusNode.dispose();
  }

  final formState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            height: double.infinity,
            color: const Color(0XFF1a278a),
            width: MediaQuery.of(context).size.width * .4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('asset/icon.png'),
                Text(
                  "REY POS",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 45,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Applikasi Jual Beli Gula & Kelontongan",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 14,
                    color: const Color(0XFFcfcaca),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: double.infinity,
            color: Colors.white,
            width: MediaQuery.of(context).size.width * .6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: formState,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Daftar Ke REY POS",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sudah Punya Akun REY POS",
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              context.go(LoginScreen.routeName);
                            },
                            child: Text(
                              "Masuk",
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.amber),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * .3,
                        child: TextFormField(
                          focusNode: focusNode,
                          keyboardType: TextInputType.text,
                          controller: txtName,
                          validator: (value) {
                            if (value == '') {
                              return "Name Tidak Boleh Kosong";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(
                                left: 15, top: 5, bottom: 5),
                            hintText: "Masukan Nama",
                            hintStyle: const TextStyle(
                              color: Color(0XFFAA9D9D),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * .3,
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: ishide,
                          controller: txtPass,
                          validator: (value) {
                            if (value == '') {
                              return "Password Tidak Boleh Kosong";
                            }
                            if (value!.length < 4) {
                              return "Password Minimal 4 Karakter";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(
                                left: 15, top: 5, bottom: 5, right: 15),
                            hintText: "Masukan Password",
                            hintStyle: const TextStyle(
                              color: Color(0XFFAA9D9D),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(ishide
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  ishide = !ishide;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      BlocConsumer<UserBloc, UserState>(
                        listener: (context, state) {
                          if (state is RegisterUser) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.blue,
                                  content:
                                      Text('Daftar Berhasil Silahkan Masuk')),
                            );
                            context.go(LoginScreen.routeName);
                          }
                        },
                        builder: (context, state) {
                          if (state is UserLoading) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(400.0, 50),
                                  backgroundColor: const Color(0XFF1a278a)),
                              onPressed: () {},
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(400.0, 50),
                                backgroundColor: const Color(0XFF1a278a)),
                            onPressed: () {
                              if (formState.currentState!.validate()) {
                                var request = UserModel(
                                    nama: txtName!.text,
                                    role: "1",
                                    email: null,
                                    password: txtPass!.text,
                                    created: DateTime.now().toIso8601String());
                                context
                                    .read<UserBloc>()
                                    .add(RegisterEvent(user: request));
                              }
                            },
                            child: const Text(
                              "Masuk",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
