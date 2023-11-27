import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hipax_log/Login/wrapper2.dart';
import 'package:hipax_log/core/widgets/ui/themes/theme_config.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/firebase_options.dart';
import 'package:provider/provider.dart';
import 'auth.dart';
import 'modelo_participantes.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Shuttle>>.value(
      initialData: const [],
      value: DatabaseServiceShuttle().transferIn,
      child: StreamProvider<List<PushNotification>>.value(
        initialData: const [],
        value: DatabaseServiceNotificacoes().getNotifications,
        child: StreamProvider<List<Coordenador>>.value(
          initialData: const [],
          value: DatabaseServiceUsuarios().getUsuarios,
          child: StreamProvider<List<Participantes>>.value(
            initialData: const [],
            value: DatabaseService().participantes,
            child: StreamProvider<List<VooChegada>>.value(
              initialData: const [],
              value: DatabaseServiceVoosChegada().vooschegada,
              child: StreamProvider<List<TransferIn>>.value(
                initialData: const [],
                value: DatabaseServiceTransferIn().transferIn,
                child: StreamProvider<User2?>.value(
                  initialData:
                      const User2(uid: '', urlFoto: '', email: '', nome: ''),
                  value: AuthService().user,
                  child: OverlaySupport(
                    child: MaterialApp(
                        localizationsDelegates: const [
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        supportedLocales: const [
                          Locale('pt'),
                        ],
                        title: 'Hipax',
                        debugShowCheckedModeBanner: false,
                        theme: ThemeConfig.theme,
                        home: const Wrapper2()),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
