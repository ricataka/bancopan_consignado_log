import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hipax_log/CentralTransfer/adicionar_veiculo_lista.dart';
import 'package:hipax_log/AdicionarParticipante/adicionar_pax_page.dart';
import 'package:hipax_log/MaisBarraNavegacao/menu_mais_opcoes.dart';
import 'package:hipax_log/Painel/painel_interativo.dart';
import 'package:hipax_log/auth.dart';
import 'package:hipax_log/database.dart';
import 'package:hipax_log/modelo_participantes.dart';
import 'package:hipax_log/solucoes_page.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'loader_core.dart';
import 'PesquisaParticipantes/pesquisa_pax_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MyHomePage9 extends StatefulWidget {
  final bool isAceite;
  const MyHomePage9({super.key, required this.isAceite});

  @override
  State<MyHomePage9> createState() => _MyHomePage9State();
}

class _MyHomePage9State extends State<MyHomePage9> {
  late FirebaseMessaging _messaging;

  final List<PushNotification> _listNotifications = [];
  late PageController _pageController;

  bool userPageDragging = false;
  bool isDarkMode = false;

  late PushNotification _notificationInfo;

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // print("Handling a background message: ${message.messageId}");
  }

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    _messaging.getToken().then((deviceToken) {
      // print("device Token$deviceToken");
    });
    _messaging.subscribeToTopic('Notificacoes');

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        aMessage(Map<String, dynamic> message) async {
          // print('onMessage: $message');
        }

        aMessage(message.data);
        // print(
        //     'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        PushNotification notification = PushNotification(
          user: '',
          date: Timestamp.now(),
          isLido: true,
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
          _listNotifications.add(notification);
        });
        _setMessage(notification);

        if (_notificationInfo.title != '') {
          // print('islido: ${_notificationInfo.isLido}');

          if (_notificationInfo.title[1] == 'e') {
            showSimpleNotification(
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5A623).withOpacity(0.90),
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(0.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        LineAwesomeIcons.bus,
                        color: Colors.black87,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        _notificationInfo.title,
                        style: GoogleFonts.lato(
                          letterSpacing: 0.6,
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              subtitle: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(0.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 16, 8, 16),
                  child: Text(
                    _notificationInfo.body,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              background: Colors.transparent,
              duration: const Duration(seconds: 4),
              slideDismissDirection: DismissDirection.up,
            );
          } else {
            showSimpleNotification(
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5A623).withOpacity(0.90),
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(0.0),
                      bottomLeft: Radius.circular(0.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            LineAwesomeIcons.plane,
                            color: Colors.black87,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            _notificationInfo.title,
                            style: GoogleFonts.lato(
                              letterSpacing: 0.6,
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                subtitle: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      topRight: Radius.circular(0.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 16, 8, 16),
                    child: Text(
                      _notificationInfo.body,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                background: Colors.transparent,
                duration: const Duration(seconds: 4),
                slideDismissDirection: DismissDirection.up);
          }
        }
      });
    } else {
      // print('User declined or has not accepted permission');
    }
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        date: Timestamp.now(),
        user: '',
        isLido: true,
        title: initialMessage.notification?.title ?? '',
        body: initialMessage.notification?.body ?? '',
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        _listNotifications.add(notification);
      });
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final AuthService _auth = AuthService();

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void darkMode(bool isdark) {
    setState(() {
      isDarkMode = isdark;
    });
  }

  void handlePageChange() {}

  _setMessage(PushNotification message) {
    final String title = message.title;
    final String body = message.body;
    final String dataTitle = message.dataTitle;
    final String dataBody = message.dataBody;

    setState(() {
      PushNotification m = PushNotification(
          user: '',
          date: Timestamp.now(),
          isLido: false,
          title: title,
          body: body,
          dataBody: dataBody,
          dataTitle: dataTitle);
      _listNotifications.add(m);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  ScrollController _hideBottomNavController = ScrollController();

  bool _isVisible = false;

  Future<void> _showStartDialog(String userMail) async {
    String telefonepax = '';
    String nomepax = '';
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return IntroductionScreen(
          pages: [
            PageViewModel(
              title:
                  'Termo de compromisso de confidencialidade de informações e'
                  ' proteção de dados pessoais e sensíveis – Lei '
                  'Geral de Proteção de Dados (L13709)',
              bodyWidget: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                          child: Text(
                            '1.	Reconheço que em razão da utilização da ferramenta tecnológica Aplicativo Hipax '
                            'disponibilizada pela Criarte, poderei ter acesso a '
                            'diversas informações pessoais, sensíveis, estratégicas - confidenciais ou não - '
                            'armazenadas nos sistema informatizado sob a responsabilidade da Hipax;',
                            style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Text(
                            '2.	Tenho ciência de que as credenciais de acesso (login e senha) são de uso'
                            ' pessoal e intrasferível e de conhecimento exclusivo. É de minha '
                            'inteira responsabilidade todo e qualquer prejuízo causado '
                            'pelo fornecimento de minha senha pessoal à terceiros, independente do motivo. ',
                            style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '3.	O usuário compromete-se:',
                              style: GoogleFonts.lato(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                          child: Text(
                            'a.	a manter sigilo e não utilizar as informações confidenciais a que tiver acesso em '
                            'virtude de tratamento de dados, para '
                            'gerar benefício próprio exclusivo e/ou unilateral, presente ou futuro, ou para o uso de terceiros; ',
                            style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                          child: Text(
                            'b.	a não efetuar nenhuma gravação ou cópia das informações a que tiver acesso; ',
                            style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                          child: Text(
                            'c.	a não repassar as informações confidenciais a que tiver acesso, responsabilizando-se por todas as pessoas, '
                            'físicas ou jurídicas, que vierem a ter acesso às informações, por seu intermédio.',
                            style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                          child: Text(
                            'd.	as informações confidenciais confiadas aos usuários somente poderão ser abertas a '
                            'terceiro, mediante consentimento prévio e por escrito da Hipax ou, em caso '
                            'de determinação judicial, hipótese em que o usuário deverá informar de imediato, por escrito, à Hipax..',
                            style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '4.	Reconheço que para os fins deste documento serão consideradas confidenciais todas as '
                              'informações, dados pessoais, dados e processos de logística, layout, '
                              'design transmitidas por meios escritos, '
                              'eletrônicos, verbais ou quaisquer outros e de qualquer natureza, incluindo, mas não se limitando a:',
                              style: GoogleFonts.lato(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                          child: Text(
                            'a.	Dados pessoais - Todas as informações relacionadas a uma pessoa identificada ou identificável. São os '
                            'dados de identificação, como nome, RG, CPF, endereço, telefone, e-mail, cargo, entre outros; ',
                            style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                          child: Text(
                            'b.	Dados da logística do evento – qualquer informação sobre dados aéreos (voos ida e volta), '
                            'terrestre (transfer ida e volta) e hospedagem (período, número do quarto);',
                            style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                          child: Text(
                            'c.	Dados sensíveis - Qualquer dado pessoal que diga respeito a origem racial ou étnica, '
                            'convicção religiosa, opinião política, filiação a sindicato ou a organização de caráter religioso,'
                            ' filosófico ou político, bem como dado referente à saúde ou à vida sexual, dado genético ou biométrico.',
                            style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                          child: Text(
                            'd.	Técnicas, layout, design, especificações, modelos, contratos e processos.',
                            style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '5.	Tenho conhecimento ainda de que a Hipax possui um programa de governança de '
                              'dados pessoais e de segurança da informação, em '
                              'relação aos quais tenho obrigação de obedecer e auxiliar o cumprimento;',
                              style: GoogleFonts.lato(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '6.	Me comprometo a não utilizar qualquer informação à qual tenha acesso, '
                              'classificada como confidencial ou não, para fins diversos daqueles para os'
                              ' quais tive autorização de acesso.',
                              style: GoogleFonts.lato(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '7.	Estou ciente que, é proibida a cópia, de qualquer informação para dispositivos estranhos, bem como a divulgação em '
                              'qualquer meio digital ou não e compartilhamento, exceto se a referida ação, seja estritamente necessária para a '
                              'prestação dos serviços contratados, devendo '
                              'ser realizada com a maior segurança possível e com expressa e prévia autorização do representante legal;',
                              style: GoogleFonts.lato(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '8.	Reconheço que os prejuízos causados por mim à Hipax, em razão da quebra de confidencialidade, disponibilidade ou '
                              'integridade das informações às quais tenho acesso, poderão ser reclamados, judicial ou extrajudicialmente e, '
                              'caso caracterizada qualquer infração penal, poderei ser pessoalmente responsabilizado;',
                              style: GoogleFonts.lato(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '9.	Reconheço que meus dados pessoais utilizados para acesso aos sistemas disponibilizados pela Hipax, serão conservados '
                              'durante o tempo que estiver vigente a relação contratual com a Criarte a qual estou vinculado e após esta finalizar,'
                              ' durante os períodos de retenção de dados legalmente exigíveis, de forma estritamente necessária, tais como, mas não se'
                              ' limitando, pelos prazos prescricionais para ajuizamento de ação penal ou civil, assim como para o exercício do direito de'
                              ' defesa em processo judicial de qualquer natureza ou para outra finalidade por período não excessivo adotado pela Hipax,'
                              ' garantida a transparência, confidencialidade, integridade e disponibilidade das minhas informações pessoais, bem como o'
                              ' exercício dos direitos previstos na Lei '
                              'Federal nº 13.709/2018 ("LGPD") na vigência da relação contratual assim como após o término da referida relação.',
                              style: GoogleFonts.lato(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '10.	Reconheço, neste ato, ter lido, compreendido e sanado todas '
                              'as dúvidas sobre o Termo De Compromisso De Confidencialidade De Informação E Proteção De Dados Pessoais'
                              ' e sensíveis.',
                              style: GoogleFonts.lato(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            PageViewModel(
              title:
                  "Precisamos do seu telefone para identificá-lo na lista de coordenadores",
              bodyWidget: Column(
                children: [
                  TextFormField(
                    style: GoogleFonts.lato(
                      fontSize: 14,
                    ),
                    initialValue: '',
                    autocorrect: false,
                    onSaved: (value) {},
                    maxLines: 1,
                    onChanged: (String value) {
                      nomepax = value.toUpperCase();
                    },
                    decoration: const InputDecoration(
                        labelText: 'Nome ',
                        hintText: 'Preencha seu nome',
                        labelStyle: TextStyle(
                            decorationStyle: TextDecorationStyle.solid)),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    style: GoogleFonts.lato(
                      fontSize: 14,
                    ),
                    initialValue: '',
                    inputFormatters: [
                      MaskTextInputFormatter(
                          mask: "(##)-#########",
                          filter: {"#": RegExp(r'[0-9]')})
                    ],
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    onSaved: (value) {},
                    maxLines: 1,
                    onChanged: (value) {
                      telefonepax = value.toUpperCase();
                    },
                    decoration: const InputDecoration(
                        labelText: 'Telefone ',
                        hintText: 'Preencha telefone',
                        labelStyle: TextStyle(
                            decorationStyle: TextDecorationStyle.solid)),
                  ),
                ],
              ),
            )
          ],
          onDone: () {
            DatabaseServiceUsuarios(uid: '').updateDadosCoordenador(
                userMail, nomepax, '', userMail, telefonepax);

            Navigator.pop(context);
          },
          onSkip: () {
            setValueToZero();
            Navigator.pop(context);
            _auth.signOut();
          },
          showSkipButton: true,
          skip: const Text("Não concordo"),
          next: const Text("Concordo"),
          done: const Text("Finalizar",
              style: TextStyle(fontWeight: FontWeight.w600)),
          dotsDecorator: DotsDecorator(
              size: const Size.square(10.0),
              activeSize: const Size(20.0, 10.0),
              activeColor: const Color(0xFF3F51B5),
              color: Colors.grey.shade300,
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0))),
        );
      },
    );
  }

  void setValue(String usuarioMail) async {
    final prefs = await SharedPreferences.getInstance();
    int launchCount = prefs.getInt('counter') ?? 0;
    prefs.setInt('counter', launchCount + 1);

    if (launchCount == 0) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _showStartDialog(usuarioMail));
    } else {
      // print("Not first launch");
    }
  }

  void setValueToZero() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt('counter', 0);
  }

  @override
  initState() {
    String usuariomail;
    usuariomail = Provider.of<User2>(context, listen: false).email;
    setValue(usuariomail);

    _pageController =
        PageController(initialPage: 0, keepPage: false, viewportFraction: 1.0);

    _pageController.addListener(handlePageChange);
    registerNotification();
    checkForInitialMessage();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        user: '',
        date: Timestamp.now(),
        isLido: false,
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
      });
    });

    _isVisible = true;
    _currentIndex = 0;

    _hideBottomNavController = ScrollController();
    _hideBottomNavController.addListener(
      () {
        if (_hideBottomNavController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisible) {
            setState(() {
              _isVisible = false;
              // print(_isVisible);
            });
          }
        }
        if (_hideBottomNavController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_isVisible) {
            setState(() {
              _isVisible = true;
              // print(_isVisible);
            });
          }
        }
      },
    );
    super.initState();
  }

  void hideBottombar(bool value) {
    setState(() {
      // print(value);
      _isVisible = value;
      // print(_isVisible);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User2>(context);

    if (user.email == '') {
      return const Loader();
    } else {
      List<Widget> children = [
        const Column(
          children: [
            Expanded(child: PainelInterativo()),
          ],
        ),
        CustomScrollView(
          controller: _hideBottomNavController,
          shrinkWrap: true,
          slivers: const <Widget>[
            SliverPadding(
              padding: EdgeInsets.all(0.0),
              sliver: SolucoesAppPage(),
            ),
          ],
        ),
        MenuMaisOpcoesPage(
          isDarkMode: darkMode,
          user: user,
        ),
      ];

      Widget appBarTitle = !isDarkMode
          ? Image.asset(
              'lib/assets/logohipaxazul2.png',
              width: 85,
              alignment: Alignment.centerLeft,
            )
          : Image.asset(
              'lib/assets/logohipaxazulnegativo.png',
              width: 85,
              alignment: Alignment.centerLeft,
            );

      listShare() {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Wrap(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.90),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0))),
                  child: const Column(
                    children: [],
                  ),
                ),
                Container(
                  color: const Color.fromRGBO(255, 255, 255, 0.90),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(PageRouteTransitionBuilder(
                              effect: TransitionEffect.bottomToTop,
                              page: const AdicionarPaxStep(),
                            ));
                          },
                          child: ListTile(
                            leading: const Icon(FeatherIcons.userPlus,
                                color: Color(0xFF3F51B5), size: 20),
                            title: Text(
                              'Adicionar participante',
                              style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  letterSpacing: 0.0),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .push(PageRouteTransitionBuilder(
                            effect: TransitionEffect.bottomToTop,
                            page: const AdicionarVeiculoLista(),
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 0),
                          child: ListTile(
                            leading: const Icon(LineAwesomeIcons.bus,
                                color: Color(0xFF3F51B5), size: 21),
                            title: Text(
                              'Adicionar transfer',
                              style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  letterSpacing: 0.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Scaffold(
        backgroundColor:
            isDarkMode ? const Color(0xFF111111) : const Color(0xFFFFFFFF),
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(FeatherIcons.plus,
                  color: Color(0xFF3F51B5), size: 23),
              onPressed: () => showModalBottomSheet(
                // expand: false,
                context: context,
                backgroundColor: Colors.white,
                builder: (context) => listShare(),
              ),
            ),
            IconButton(
                icon: const Icon(FeatherIcons.search,
                    color: Color(0xFF3F51B5), size: 22),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                      PageRouteTransitionBuilder(
                          page: const PesquisaPaxPage(),
                          effect: TransitionEffect.bottomToTop));
                })
          ],
          title: Stack(
            children: [
              appBarTitle,
            ],
          ),
          backgroundColor: isDarkMode ? const Color(0xFF111111) : Colors.white,
        ),
        body: children[_currentIndex],
        bottomNavigationBar: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 0.2),
              ),
            ),
            child: BottomNavigationBar(
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor:
                  isDarkMode ? const Color(0xFF111111) : Colors.white,
              currentIndex: _currentIndex,
              selectedItemColor: const Color(0xFF3F51B5),
              unselectedItemColor: isDarkMode ? Colors.white54 : Colors.black54,
              unselectedLabelStyle: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              selectedLabelStyle: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              onTap: onTabTapped,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.speed,
                      size: 23,
                    ),
                    label: 'Dashboard'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.window,
                      size: 23,
                    ),
                    label: 'Atividades'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                      size: 23,
                    ),
                    label: 'Mais'),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class PlaceholderWidget extends StatelessWidget {
  const PlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
