import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hipax_log/ContatosCoordenadores/contatos_coordenadores.dart';
import 'package:hipax_log/loader_core.dart';
import 'package:hipax_log/MaisBarraNavegacao/editar_dadosperfil_page.dart';
import 'package:hipax_log/Suporte/suporte_page.dart';
import 'package:hipax_log/auth.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuMaisOpcoesPage extends StatefulWidget {
  final Function? isDarkMode;
  final User2 user;

  const MenuMaisOpcoesPage({super.key, this.isDarkMode, required this.user});
  @override
  State<MenuMaisOpcoesPage> createState() => _MenuMaisOpcoesPageState();
}

class _MenuMaisOpcoesPageState extends State<MenuMaisOpcoesPage> {
  final AuthService _auth = AuthService();
  bool isSwitched = false;
  bool isModoEscuro = false;
  String uidCoordenador = '';
  late Coordenador _coordenador;
  String scannertext = '';

  Future<void> addBoolToSF(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('boolDarkMode', value);
  }

  Future<bool> getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool boolValue = prefs.getBool('boolDarkMode') ?? false;

    return boolValue;
  }

  @override
  void initState() {
    super.initState();
  }

  void darModeON(bool isSwiched) {
    widget.isDarkMode!(isSwiched);
  }

  Future<void> getImageFromCamera(Coordenador cordenador) async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
    if (pickedFile == null) return;
    final image = File(pickedFile.path);

    imageSlected(image, cordenador);
  }

  Future<void> getImageFromGallery(Coordenador cordenador) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    final image = File(pickedFile?.path ?? '');
    imageSlected(image, cordenador);
  }

  void imageSlected(File image, Coordenador cordenador) {}

  Future<String> uploadFile(File image, Coordenador cordenador) async {
    var returnUrl = '';
    var storageReference = FirebaseStorage.instance
        .ref()
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    var uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() => null);

    await storageReference.getDownloadURL().then((fileURL) {
      returnUrl = fileURL;
      AuthService().updateUserInfo('Rafael', returnUrl);
      DatabaseServiceUsuarios(uid: _coordenador.uid).updatePhoto(returnUrl);
    });
    return returnUrl;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User2>(context);
    final listUsers = Provider.of<List<Coordenador>>(context);

    if (user.email.isEmpty) {
      return const Loader();
    } else {
      List<Coordenador> listUsers1 = listUsers.toList();
      listUsers1.sort((a, b) => a.nome.compareTo(b.nome));
      var listUsers2 = [listUsers1].expand((f) => f).toList();

      for (var element in listUsers1) {
        if (element.uid == widget.user.email) {
          _coordenador = element;
        }
      }

      return Container(
        color: isSwitched ? const Color(0xFF111111) : const Color(0xFFFFFFFF),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 24,
                  ),
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(FeatherIcons.user, size: 30),
                  ),
                  Text(
                    widget.user.email,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: isSwitched ? Colors.white70 : Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                ],
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(PageRouteTransitionBuilder(
                          effect: TransitionEffect.leftToRight,
                          page: ContatoCoordenadores(
                            listaUsuarios: listUsers2,
                          )));
                },
                leading: const Icon(
                  FeatherIcons.phone,
                  size: 22,
                  color: Color(0xFF3F51B5),
                ),
                trailing: const Icon(
                  FeatherIcons.chevronRight,
                  size: 18,
                  color: Color(0xFF3F51B5),
                ),
                title: Text(
                  'Contatos coordenadores',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    color: isSwitched ? Colors.white70 : Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    PageRouteTransitionBuilder(
                        effect: TransitionEffect.leftToRight,
                        page: EditarPerfilPage(
                          cordenador: _coordenador,
                        )),
                  );
                },
                child: ListTile(
                  leading: const Icon(FeatherIcons.edit,
                      color: Color(0xFF3F51B5), size: 22),
                  title: Text(
                    'Editar perfil',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: const Icon(
                    FeatherIcons.chevronRight,
                    size: 18,
                    color: Color(0xFF3F51B5),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                      PageRouteTransitionBuilder(
                          effect: TransitionEffect.leftToRight,
                          page: const SuportePage()));
                },
                leading: const Icon(
                  Icons.headset_mic_outlined,
                  size: 22,
                  color: Color(0xFF3F51B5),
                ),
                trailing: const Icon(
                  FeatherIcons.chevronRight,
                  size: 18,
                  color: Color(0xFF3F51B5),
                ),
                title: Text(
                  'Suporte',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(FeatherIcons.logOut,
                    size: 22, color: Color(0xFF3F51B5)),
                trailing: const Icon(
                  FeatherIcons.chevronRight,
                  size: 18,
                  color: Color(0xFF3F51B5),
                ),
                title: Text(
                  'Logout',
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    color: isSwitched ? Colors.white70 : Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  _auth.signOut();
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}
