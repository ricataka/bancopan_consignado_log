import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:expandable/expandable.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class SuporteWidget extends StatelessWidget {
  const SuporteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    openwhatsappRafael() async {
      const link = WhatsAppUnilink(
        phoneNumber: "+55" '17996479806',
        // text: "Hey! I'm inquiring about the apartment listing",
      );
      await launchUrl(Uri.parse('$link'));
    }

    openwhatsappWagner() async {
      const link = WhatsAppUnilink(
        phoneNumber: "+55" '17991394080',
        // text: "Hey! I'm inquiring about the apartment listing",
      );
      await launchUrl(Uri.parse('$link'));
    }
    // openwhatsappRafael() async{
    //   var whatsapp ="+5517996479806";
    //   var whatsappURl_android = "whatsapp://send?phone="+whatsapp;
    //   var whatappURL_ios ="https://wa.me/$whatsapp";
    //   if(Platform.isIOS){
    //     // for iOS phone only
    //     if( await canLaunch(whatappURL_ios)){
    //       await launch(whatappURL_ios, forceSafariVC: false);
    //     }else{
    //       ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(content: new Text("whatsapp no installed")));
    //
    //     }
    //
    //   }else{
    //     // android , web
    //     if( await canLaunch(whatsappURl_android)){
    //       await launch(whatsappURl_android);
    //     }else{
    //       ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(content: new Text("whatsapp no installed")));
    //
    //     }
    //
    //
    //   }
    //
    // }
    // openwhatsappWagner() async{
    //   var whatsapp ="+5517991394080";
    //   var whatsappURl_android = "whatsapp://send?phone="+whatsapp;
    //   var whatappURL_ios ="https://wa.me/$whatsapp";
    //   if(Platform.isIOS){
    //     // for iOS phone only
    //     if( await canLaunch(whatappURL_ios)){
    //       await launch(whatappURL_ios, forceSafariVC: false);
    //     }else{
    //       ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(content: new Text("whatsapp no installed")));
    //
    //     }
    //
    //   }else{
    //     // android , web
    //     if( await canLaunch(whatsappURl_android)){
    //       await launch(whatsappURl_android);
    //     }else{
    //       ScaffoldMessenger.of(context).showSnackBar(
    //           SnackBar(content: new Text("whatsapp no installed")));
    //
    //     }
    //
    //
    //   }
    //
    // }

    return Column(
      children: [
        ExpandablePanel(
          collapsed: const SizedBox.shrink(),
          header: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: ListTile(
              leading: const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/flutterhipax.appspot.com/o/1621809967155?alt=media&token=0d1d0a42-3a29-4873-ac15-610f7a848e3a'),
              ),
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rafael',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          expanded: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(92, 0, 0, 0),
                  child: Text(
                    'Telefone: (17) 996479806',
                    style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: 0.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      openwhatsappRafael();
                    },
                    child: const CircleAvatar(
                      radius: 19.2,
                      backgroundColor: Color(0xFF3F51B5),
                      child: CircleAvatar(
                        radius: 18.2,
                        backgroundColor: Color(0xFF3F51B5),
                        child: Icon(LineAwesomeIcons.what_s_app,
                            color: Colors.white, size: 26),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse("tel:" '17996479806'));
                    },
                    child: const CircleAvatar(
                      radius: 19.2,
                      backgroundColor: Color(0xFF3F51B5),
                      child: CircleAvatar(
                        radius: 18.2,
                        backgroundColor: Color(0xFF3F51B5),
                        child: Icon(FeatherIcons.phone,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Divider(
            thickness: 0.6,
            color: Color(0xFFCACACA),
            height: 4,
            indent: 0,
          ),
        ),
        ExpandablePanel(
          collapsed: const SizedBox.shrink(),
          header: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: ListTile(
              leading: const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/flutterhipax.appspot.com/o/1622064106785?alt=media&token=d37ffc09-534d-4966-aaf3-8f24c51ffe3a'),
              ),
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Wagner',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          expanded: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(92, 0, 0, 0),
                  child: Text(
                    'Telefone: (17) 991394080',
                    style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: 0.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      openwhatsappWagner();
                    },
                    child: const CircleAvatar(
                      radius: 19.2,
                      backgroundColor: Color(0xFF3F51B5),
                      child: CircleAvatar(
                        radius: 18.2,
                        backgroundColor: Color(0xFF3F51B5),
                        child: Icon(LineAwesomeIcons.what_s_app,
                            color: Colors.white, size: 26),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse("tel:" '17991394080'));
                    },
                    child: const CircleAvatar(
                      radius: 19.2,
                      backgroundColor: Color(0xFF3F51B5),
                      child: CircleAvatar(
                        radius: 18.2,
                        backgroundColor: Color(0xFF3F51B5),
                        child: Icon(FeatherIcons.phone,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Divider(
            thickness: 0.6,
            color: Color(0xFFCACACA),
            height: 4,
            indent: 0,
          ),
        ),
      ],
    );
  }
}
