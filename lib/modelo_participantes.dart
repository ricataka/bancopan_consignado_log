import 'package:cloud_firestore/cloud_firestore.dart';

class UserControleApp {
  final String uid;
  final Timestamp horarioControle;
  UserControleApp({required this.uid, required this.horarioControle});
}

class TransferParticipante {
  final String? uid;
  final String? origem;
  final String? destino;
  final Timestamp? previsaoSaida;
  final String? veiculoNumeracao;
  final String? classificacaoVeiculo;

  TransferParticipante(
      {this.uid,
      this.veiculoNumeracao,
      this.previsaoSaida,
      this.origem,
      this.destino,
      this.classificacaoVeiculo});
}

class User2 {
  final String uid;
  final String urlFoto;
  final String email;
  final String nome;

  const User2(
      {required this.uid,
      required this.urlFoto,
      required this.email,
      required this.nome});
}

class SorteadoPan {
  final String uid;
  final String nome;
  final String area;
  final bool isSorteado;
  SorteadoPan(
      {required this.uid,
      required this.nome,
      required this.area,
      required this.isSorteado});
}

class Coordenador {
  final String uid;
  final String nome;
  final String urlFoto;
  final String email;
  final String telefone;
  final bool isAceite;
  bool isFavorite;

  Coordenador({
    required this.isAceite,
    required this.uid,
    required this.nome,
    required this.urlFoto,
    required this.email,
    required this.telefone,
    required this.isFavorite,
  });
}

class ControlePresenca {
  final String uid;
  final String nomePax;
  final Timestamp horaConfirmacao;
  final bool isConfirmado;
  ControlePresenca({
    required this.uid,
    required this.nomePax,
    required this.horaConfirmacao,
    required this.isConfirmado,
  });
}

class EntregaBrinde {
  final String uid;
  final String quarto;
  final bool isEntregue;
  final Timestamp horaEntrega;
  final String responsavel;
  final bool isEntregue2;
  final Timestamp horaEntrega2;
  final String responsavel2;

  EntregaBrinde({
    required this.uid,
    required this.quarto,
    required this.isEntregue,
    required this.horaEntrega,
    required this.responsavel,
    required this.isEntregue2,
    required this.horaEntrega2,
    required this.responsavel2,
  });
}

class MensagensChat {
  final String? uid;
  final String? mensagem;
  final String? urlFoto;
  final String? usuarioEnvio;
  final bool? lido;
  final Timestamp? horaenvio;
  final bool? isMe;
  final String? nomeUsuarioEnvio;
  final bool? isread;

  MensagensChat(
      {this.uid,
      this.mensagem,
      this.urlFoto,
      this.lido,
      this.usuarioEnvio,
      this.horaenvio,
      this.isMe,
      this.nomeUsuarioEnvio,
      this.isread});
}

class Participantes {
  final String uid;
  final String nome;
  final String cpf;
  final String telefone;
  final String email;
  final String embarque;
  final bool isCredenciamento;
  final bool isEntregaMaterial;
  final Timestamp horaCredenciamento;
  final bool pcp;
  final bool noShow;
  final bool cancelado;
  final String hotel;
  final Timestamp checkIn;
  final Timestamp checkOut;
  final String hotel2;
  final Timestamp checkIn2;
  final Timestamp checkOut2;
  final String hotelPernoiteIda1;
  final Timestamp checkInPernoite1;
  final Timestamp checkOutPernoite1;
  final String hotelPernoiteVolta;
  final Timestamp checkInPernoiteVolta;
  final Timestamp checkOutPernoiteVolta;
  final String cia1;
  final String voo1;
  final String origem1;
  final String destino1;
  final Timestamp saida1;
  final Timestamp chegada1;
  final String siglaCompanhia1;
  final String eticket1;
  final String loc1;
  final String cia2;
  final String voo2;
  final String origem2;
  final String destino2;
  final Timestamp saida2;
  final Timestamp chegada2;
  final String siglaCompanhia2;
  final String eticket2;
  final String loc2;
  final String cia21;
  final String voo21;
  final String origem21;
  final String destino21;
  final Timestamp saida21;
  final Timestamp chegada21;
  final String siglaCompanhia21;
  final String eticket21;
  final String loc21;
  final String cia3;
  final String voo3;
  final String origem3;
  final String destino3;
  final Timestamp saida3;
  final Timestamp chegada3;
  final String siglaCompanhia3;
  final String eticket3;
  final String loc3;
  final String cia4;
  final String voo4;
  final String origem4;
  final String destino4;
  final Timestamp saida4;
  final Timestamp chegada4;
  final String siglaCompanhia4;
  final String eticket4;
  final String loc4;
  final String cia41;
  final String voo41;
  final String origem41;
  final String destino41;
  final Timestamp saida41;
  final Timestamp chegada41;
  final String siglaCompanhia41;
  final String eticket41;
  final String loc41;
  final String uidTransferIn;
  final String uidTransferOuT;
  final String quarto;
  final bool isCheckOut;
  final Timestamp horaCheckOut;
  final String linkQr;
  final bool hasCredenciamento;
  final bool isRebanho;
  final bool isEmbarque;
  final Timestamp horaEMbarque;
  final bool isEmbarqueOut;
  final Timestamp horaEMbarqueOut;
  final bool isEntregaBagagem;
  final int quantidadeBagagem;
  final bool isVar1;
  final bool isVar2;
  final bool isVar3;
  final bool isVar4;
  final String uidTransferIn2;
  final String uidTransferOuT2;
  final bool isEmbarque2;
  final Timestamp horaEMbarque2;
  final bool isEmbarqueOut2;
  final Timestamp horaEMbarqueOut2;
  final bool isFavorite;

  const Participantes({
    required this.isEntregaBagagem,
    required this.hotelPernoiteIda1,
    required this.checkInPernoite1,
    required this.checkOutPernoite1,
    required this.hotelPernoiteVolta,
    required this.checkInPernoiteVolta,
    required this.checkOutPernoiteVolta,
    required this.uidTransferIn2,
    required this.uidTransferOuT2,
    required this.isEmbarqueOut2,
    required this.horaEMbarque2,
    required this.horaEMbarqueOut2,
    required this.isEmbarque2,
    required this.quantidadeBagagem,
    required this.uid,
    required this.linkQr,
    required this.hasCredenciamento,
    required this.isCheckOut,
    required this.horaCheckOut,
    required this.eticket1,
    required this.eticket2,
    required this.eticket3,
    required this.eticket4,
    required this.loc1,
    required this.loc2,
    required this.loc3,
    required this.loc4,
    required this.nome,
    required this.quarto,
    required this.cpf,
    required this.embarque,
    required this.isCredenciamento,
    required this.isEntregaMaterial,
    required this.horaCredenciamento,
    required this.isFavorite,
    required this.cancelado,
    required this.checkIn,
    required this.checkOut,
    required this.chegada1,
    required this.chegada2,
    required this.cia1,
    required this.cia2,
    required this.destino1,
    required this.destino2,
    required this.email,
    required this.hotel,
    required this.noShow,
    required this.origem1,
    required this.origem2,
    required this.pcp,
    required this.saida1,
    required this.saida2,
    required this.siglaCompanhia1,
    required this.siglaCompanhia2,
    required this.telefone,
    required this.voo1,
    required this.voo2,
    required this.uidTransferIn,
    required this.uidTransferOuT,
    required this.cia3,
    required this.voo3,
    required this.origem3,
    required this.destino3,
    required this.saida3,
    required this.chegada3,
    required this.cia4,
    required this.isRebanho,
    required this.isEmbarque,
    required this.horaEMbarque,
    required this.isEmbarqueOut,
    required this.horaEMbarqueOut,
    required this.cia21,
    required this.chegada21,
    required this.hotel2,
    required this.checkOut2,
    required this.checkIn2,
    required this.destino21,
    required this.destino41,
    required this.loc21,
    required this.loc41,
    required this.chegada4,
    required this.chegada41,
    required this.eticket21,
    required this.voo4,
    required this.origem4,
    required this.origem21,
    required this.origem41,
    required this.destino4,
    required this.voo21,
    required this.voo41,
    required this.saida4,
    required this.saida21,
    required this.saida41,
    required this.siglaCompanhia3,
    required this.siglaCompanhia21,
    required this.siglaCompanhia41,
    required this.siglaCompanhia4,
    required this.isVar4,
    required this.isVar3,
    required this.isVar2,
    required this.isVar1,
    required this.cia41,
    required this.eticket41,
  });

  factory Participantes.fromMap(Map<String, dynamic> map) {
    return Participantes(
      uid: map['uid'] ?? '',
      embarque: map['embarque'] ?? '',
      nome: map['nome'] ?? '',
      cpf: map['cpf'] ?? '',
      telefone: map['telefone'] ?? '',
      email: map['email'] ?? '',
      isCredenciamento: map['isCredenciamento'] ?? false,
      isEntregaMaterial: map['isEntregaMaterial'] ?? false,
      horaCredenciamento: map['horaCredenciamento'] ?? Timestamp.now(),
      isFavorite: false,
      pcp: map['pcp'] ?? false,
      noShow: map['noShow'] ?? false,
      cancelado: map['cancelado'] ?? false,
      hotel: map['hotel'] ?? '',
      checkIn: map['checkIn'] ?? Timestamp.now(),
      checkOut: map['checkOut'] ?? Timestamp.now(),
      hotel2: map['hotel2'] ?? '',
      checkIn2: map['checkIn2'] ?? Timestamp.now(),
      checkOut2: map['checkOut2'] ?? Timestamp.now(),
      cia1: map['cia1'] ?? '',
      voo1: map['voo1'] ?? '',
      origem1: map['origem1'] ?? '',
      destino1: map['destino1'] ?? '',
      saida1: map['saida1'] ?? Timestamp.now(),
      chegada1: map['chegada1'] ?? Timestamp.now(),
      siglaCompanhia1: map['siglaCompanhia1'] ?? '',
      eticket1: map['eticket1'] ?? '',
      loc1: map['loc1'] ?? '',
      cia2: map['cia2'] ?? '',
      voo2: map['voo2'] ?? '',
      origem2: map['origem2'] ?? '',
      destino2: map['destino2'] ?? '',
      saida2: map['saida2'] ?? Timestamp.now(),
      chegada2: map['chegada2'] ?? Timestamp.now(),
      siglaCompanhia2: map['siglaCompanhia2'] ?? '',
      eticket2: map['eticket2'] ?? '',
      loc2: map['loc2'] ?? '',
      cia21: map['cia21'] ?? '',
      voo21: map['voo21'] ?? '',
      origem21: map['origem21'] ?? '',
      destino21: map['destino21'] ?? '',
      saida21: map['saida21'] ?? Timestamp.now(),
      chegada21: map['chegada21'] ?? Timestamp.now(),
      siglaCompanhia21: map['siglaCompanhia21'] ?? '',
      eticket21: map['eticket21'] ?? '',
      loc21: map['loc21'] ?? '',
      cia3: map['cia3'] ?? '',
      voo3: map['voo3'] ?? '',
      origem3: map['origem3'] ?? '',
      destino3: map['destino3'] ?? '',
      saida3: map['saida3'] ?? Timestamp.now(),
      chegada3: map['chegada3'] ?? Timestamp.now(),
      siglaCompanhia3: map['siglaCompanhia3'] ?? '',
      eticket3: map['eticket3'] ?? '',
      loc3: map['loc3'] ?? '',
      cia4: map['cia4'] ?? '',
      voo4: map['voo4'] ?? '',
      origem4: map['origem4'] ?? '',
      destino4: map['destino4'] ?? '',
      saida4: map['saida4'] ?? Timestamp.now(),
      chegada4: map['chegada4'] ?? Timestamp.now(),
      siglaCompanhia4: map['siglaCompanhia4'] ?? '',
      eticket4: map['eticket4'] ?? '',
      loc4: map['loc4'] ?? '',
      cia41: map['cia41'] ?? '',
      voo41: map['voo41'] ?? '',
      origem41: map['origem41'] ?? '',
      destino41: map['destino41'] ?? '',
      saida41: map['saida41'] ?? Timestamp.now(),
      chegada41: map['chegada41'] ?? Timestamp.now(),
      siglaCompanhia41: map['siglaCompanhia41'] ?? '',
      eticket41: map['eticket41'] ?? '',
      loc41: map['loc41'] ?? '',
      uidTransferIn: map['uidTransferIn'] ?? '',
      uidTransferOuT: map['uidTransferOuT'] ?? '',
      quarto: map['quarto'] ?? '',
      isCheckOut: map['isCheckOut'] ?? false,
      horaCheckOut: map['horaCheckOut'] ?? Timestamp.now(),
      linkQr: map['linkQr'] ?? '',
      hasCredenciamento: map['hasCredenciamento'] ?? false,
      isRebanho: map['isRebanho'] ?? false,
      isEmbarque: map['isEmbarque'] ?? false,
      horaEMbarque: map['horaEMbarque'] ?? Timestamp.now(),
      isEmbarqueOut: map['isEmbarqueOut'] ?? false,
      horaEMbarqueOut: map['horaEMbarqueOut'] ?? Timestamp.now(),
      isEntregaBagagem: map['isEntregaBagagem'] ?? false,
      quantidadeBagagem: map['quantidadeBagagem'] ?? 0,
      isVar1: map['isVar1'] ?? false,
      isVar2: map['isVar2'] ?? false,
      isVar3: map['isVar3'] ?? false,
      isVar4: map['isVar4'] ?? false,
      uidTransferIn2: map['uidTransferIn2'] ?? '',
      uidTransferOuT2: map['uidTransferOuT2'] ?? '',
      isEmbarque2: map['isEmbarque2'] ?? false,
      horaEMbarque2: map['horaEMbarque2'] ?? Timestamp.now(),
      isEmbarqueOut2: map['isEmbarqueOut2'] ?? false,
      horaEMbarqueOut2: map['horaEMbarqueOut2'] ?? Timestamp.now(),
      hotelPernoiteIda1: map['hotelPernoiteIda1'] ?? '',
      checkInPernoite1: map['checkInPernoite1'] ?? Timestamp.now(),
      checkOutPernoite1: map['checkOutPernoite1'] ?? Timestamp.now(),
      hotelPernoiteVolta: map['hotelPernoiteVolta'] ?? '',
      checkInPernoiteVolta: map['checkInPernoiteVolta'] ?? Timestamp.now(),
      checkOutPernoiteVolta: map['checkOutPernoiteVolta'] ?? Timestamp.now(),
    );
  }

  factory Participantes.empty() {
    return Participantes(
        cancelado: false,
        checkIn2: Timestamp.fromMillisecondsSinceEpoch(0),
        checkIn: Timestamp.fromMillisecondsSinceEpoch(0),
        checkInPernoite1: Timestamp.fromMillisecondsSinceEpoch(0),
        checkInPernoiteVolta: Timestamp.fromMillisecondsSinceEpoch(0),
        checkOut2: Timestamp.fromMillisecondsSinceEpoch(0),
        checkOut: Timestamp.fromMillisecondsSinceEpoch(0),
        checkOutPernoite1: Timestamp.fromMillisecondsSinceEpoch(0),
        checkOutPernoiteVolta: Timestamp.fromMillisecondsSinceEpoch(0),
        chegada1: Timestamp.fromMillisecondsSinceEpoch(0),
        chegada21: Timestamp.fromMillisecondsSinceEpoch(0),
        chegada2: Timestamp.fromMillisecondsSinceEpoch(0),
        chegada3: Timestamp.fromMillisecondsSinceEpoch(0),
        chegada41: Timestamp.fromMillisecondsSinceEpoch(0),
        chegada4: Timestamp.fromMillisecondsSinceEpoch(0),
        cia1: '',
        cia21: '',
        cia2: '',
        cia3: '',
        cia41: '',
        cia4: '',
        cpf: '',
        destino1: '',
        destino21: '',
        destino2: '',
        destino3: '',
        destino41: '',
        destino4: '',
        email: '',
        embarque: '',
        eticket1: '',
        eticket21: '',
        eticket2: '',
        eticket3: '',
        eticket41: '',
        eticket4: '',
        hasCredenciamento: false,
        horaCheckOut: Timestamp.fromMillisecondsSinceEpoch(0),
        horaCredenciamento: Timestamp.fromMillisecondsSinceEpoch(0),
        horaEMbarque2: Timestamp.fromMillisecondsSinceEpoch(0),
        horaEMbarque: Timestamp.fromMillisecondsSinceEpoch(0),
        horaEMbarqueOut2: Timestamp.fromMillisecondsSinceEpoch(0),
        horaEMbarqueOut: Timestamp.fromMillisecondsSinceEpoch(0),
        hotel2: '',
        hotel: '',
        hotelPernoiteIda1: '',
        hotelPernoiteVolta: '',
        isCheckOut: false,
        isCredenciamento: false,
        isEmbarque2: false,
        isEmbarque: false,
        isEmbarqueOut2: false,
        isEmbarqueOut: false,
        isEntregaBagagem: false,
        isEntregaMaterial: false,
        isFavorite: false,
        isRebanho: false,
        isVar1: false,
        isVar2: false,
        isVar3: false,
        isVar4: false,
        linkQr: '',
        loc1: '',
        loc21: '',
        loc2: '',
        loc3: '',
        loc41: '',
        loc4: '',
        noShow: false,
        nome: '',
        origem1: '',
        origem21: '',
        origem2: '',
        origem3: '',
        origem41: '',
        origem4: '',
        pcp: false,
        quantidadeBagagem: 0,
        quarto: '',
        saida1: Timestamp.fromMillisecondsSinceEpoch(0),
        saida21: Timestamp.fromMillisecondsSinceEpoch(0),
        saida2: Timestamp.fromMillisecondsSinceEpoch(0),
        saida3: Timestamp.fromMillisecondsSinceEpoch(0),
        saida41: Timestamp.fromMillisecondsSinceEpoch(0),
        saida4: Timestamp.fromMillisecondsSinceEpoch(0),
        siglaCompanhia1: '',
        siglaCompanhia21: '',
        siglaCompanhia2: '',
        siglaCompanhia3: '',
        siglaCompanhia41: '',
        siglaCompanhia4: '',
        telefone: '',
        uid: '',
        uidTransferIn2: '',
        uidTransferIn: '',
        uidTransferOuT2: '',
        uidTransferOuT: '',
        voo1: '',
        voo21: '',
        voo2: '',
        voo3: '',
        voo41: '',
        voo4: '');
  }
  bool get isEmpty {
    return this ==
        Participantes(
            cancelado: false,
            checkIn2: Timestamp.fromMillisecondsSinceEpoch(0),
            checkIn: Timestamp.fromMillisecondsSinceEpoch(0),
            checkInPernoite1: Timestamp.fromMillisecondsSinceEpoch(0),
            checkInPernoiteVolta: Timestamp.fromMillisecondsSinceEpoch(0),
            checkOut2: Timestamp.fromMillisecondsSinceEpoch(0),
            checkOut: Timestamp.fromMillisecondsSinceEpoch(0),
            checkOutPernoite1: Timestamp.fromMillisecondsSinceEpoch(0),
            checkOutPernoiteVolta: Timestamp.fromMillisecondsSinceEpoch(0),
            chegada1: Timestamp.fromMillisecondsSinceEpoch(0),
            chegada21: Timestamp.fromMillisecondsSinceEpoch(0),
            chegada2: Timestamp.fromMillisecondsSinceEpoch(0),
            chegada3: Timestamp.fromMillisecondsSinceEpoch(0),
            chegada41: Timestamp.fromMillisecondsSinceEpoch(0),
            chegada4: Timestamp.fromMillisecondsSinceEpoch(0),
            cia1: '',
            cia21: '',
            cia2: '',
            cia3: '',
            cia41: '',
            cia4: '',
            cpf: '',
            destino1: '',
            destino21: '',
            destino2: '',
            destino3: '',
            destino41: '',
            destino4: '',
            email: '',
            embarque: '',
            eticket1: '',
            eticket21: '',
            eticket2: '',
            eticket3: '',
            eticket41: '',
            eticket4: '',
            hasCredenciamento: false,
            horaCheckOut: Timestamp.fromMillisecondsSinceEpoch(0),
            horaCredenciamento: Timestamp.fromMillisecondsSinceEpoch(0),
            horaEMbarque2: Timestamp.fromMillisecondsSinceEpoch(0),
            horaEMbarque: Timestamp.fromMillisecondsSinceEpoch(0),
            horaEMbarqueOut2: Timestamp.fromMillisecondsSinceEpoch(0),
            horaEMbarqueOut: Timestamp.fromMillisecondsSinceEpoch(0),
            hotel2: '',
            hotel: '',
            hotelPernoiteIda1: '',
            hotelPernoiteVolta: '',
            isCheckOut: false,
            isCredenciamento: false,
            isEmbarque2: false,
            isEmbarque: false,
            isEmbarqueOut2: false,
            isEmbarqueOut: false,
            isEntregaBagagem: false,
            isEntregaMaterial: false,
            isFavorite: false,
            isRebanho: false,
            isVar1: false,
            isVar2: false,
            isVar3: false,
            isVar4: false,
            linkQr: '',
            loc1: '',
            loc21: '',
            loc2: '',
            loc3: '',
            loc41: '',
            loc4: '',
            noShow: false,
            nome: '',
            origem1: '',
            origem21: '',
            origem2: '',
            origem3: '',
            origem41: '',
            origem4: '',
            pcp: false,
            quantidadeBagagem: 0,
            quarto: '',
            saida1: Timestamp.fromMillisecondsSinceEpoch(0),
            saida21: Timestamp.fromMillisecondsSinceEpoch(0),
            saida2: Timestamp.fromMillisecondsSinceEpoch(0),
            saida3: Timestamp.fromMillisecondsSinceEpoch(0),
            saida41: Timestamp.fromMillisecondsSinceEpoch(0),
            saida4: Timestamp.fromMillisecondsSinceEpoch(0),
            siglaCompanhia1: '',
            siglaCompanhia21: '',
            siglaCompanhia2: '',
            siglaCompanhia3: '',
            siglaCompanhia41: '',
            siglaCompanhia4: '',
            telefone: '',
            uid: '',
            uidTransferIn2: '',
            uidTransferIn: '',
            uidTransferOuT2: '',
            uidTransferOuT: '',
            voo1: '',
            voo21: '',
            voo2: '',
            voo3: '',
            voo41: '',
            voo4: '');
  }

  Participantes copyWith({
    String? uid,
    String? nome,
    String? cpf,
    String? telefone,
    String? email,
    String? embarque,
    bool? isCredenciamento,
    bool? isEntregaMaterial,
    Timestamp? horaCredenciamento,
    bool? pcp,
    bool? noShow,
    bool? cancelado,
    String? hotel,
    Timestamp? checkIn,
    Timestamp? checkOut,
    String? hotel2,
    Timestamp? checkIn2,
    Timestamp? checkOut2,
    String? hotelPernoiteIda1,
    Timestamp? checkInPernoite1,
    Timestamp? checkOutPernoite1,
    String? hotelPernoiteVolta,
    Timestamp? checkInPernoiteVolta,
    Timestamp? checkOutPernoiteVolta,
    String? cia1,
    String? voo1,
    String? origem1,
    String? destino1,
    Timestamp? saida1,
    Timestamp? chegada1,
    String? siglaCompanhia1,
    String? eticket1,
    String? loc1,
    String? cia2,
    String? voo2,
    String? origem2,
    String? destino2,
    Timestamp? saida2,
    Timestamp? chegada2,
    String? siglaCompanhia2,
    String? eticket2,
    String? loc2,
    String? cia21,
    String? voo21,
    String? origem21,
    String? destino21,
    Timestamp? saida21,
    Timestamp? chegada21,
    String? siglaCompanhia21,
    String? eticket21,
    String? loc21,
    String? cia3,
    String? voo3,
    String? origem3,
    String? destino3,
    Timestamp? saida3,
    Timestamp? chegada3,
    String? siglaCompanhia3,
    String? eticket3,
    String? loc3,
    String? cia4,
    String? voo4,
    String? origem4,
    String? destino4,
    Timestamp? saida4,
    Timestamp? chegada4,
    String? siglaCompanhia4,
    String? eticket4,
    String? loc4,
    String? cia41,
    String? voo41,
    String? origem41,
    String? destino41,
    Timestamp? saida41,
    Timestamp? chegada41,
    String? siglaCompanhia41,
    String? eticket41,
    String? loc41,
    String? uidTransferIn,
    String? uidTransferOuT,
    String? quarto,
    bool? isCheckOut,
    Timestamp? horaCheckOut,
    String? linkQr,
    bool? hasCredenciamento,
    bool? isRebanho,
    bool? isEmbarque,
    Timestamp? horaEMbarque,
    bool? isEmbarqueOut,
    Timestamp? horaEMbarqueOut,
    bool? isEntregaBagagem,
    int? quantidadeBagagem,
    bool? isVar1,
    bool? isVar2,
    bool? isVar3,
    bool? isVar4,
    String? uidTransferIn2,
    String? uidTransferOuT2,
    bool? isEmbarque2,
    Timestamp? horaEMbarque2,
    bool? isEmbarqueOut2,
    Timestamp? horaEMbarqueOut2,
    bool? isFavorite,
  }) {
    return Participantes(
      uid: uid ?? this.uid,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      embarque: embarque ?? this.embarque,
      isCredenciamento: isCredenciamento ?? this.isCredenciamento,
      isEntregaMaterial: isEntregaMaterial ?? this.isEntregaMaterial,
      horaCredenciamento: horaCredenciamento ?? this.horaCredenciamento,
      pcp: pcp ?? this.pcp,
      noShow: noShow ?? this.noShow,
      cancelado: cancelado ?? this.cancelado,
      hotel: hotel ?? this.hotel,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      hotel2: hotel2 ?? this.hotel2,
      checkIn2: checkIn2 ?? this.checkIn2,
      checkOut2: checkOut2 ?? this.checkOut2,
      hotelPernoiteIda1: hotelPernoiteIda1 ?? this.hotelPernoiteIda1,
      checkInPernoite1: checkInPernoite1 ?? this.checkInPernoite1,
      checkOutPernoite1: checkOutPernoite1 ?? this.checkOutPernoite1,
      hotelPernoiteVolta: hotelPernoiteVolta ?? this.hotelPernoiteVolta,
      checkInPernoiteVolta: checkInPernoiteVolta ?? this.checkInPernoiteVolta,
      checkOutPernoiteVolta:
          checkOutPernoiteVolta ?? this.checkOutPernoiteVolta,
      cia1: cia1 ?? this.cia1,
      voo1: voo1 ?? this.voo1,
      origem1: origem1 ?? this.origem1,
      destino1: destino1 ?? this.destino1,
      saida1: saida1 ?? this.saida1,
      chegada1: chegada1 ?? this.chegada1,
      siglaCompanhia1: siglaCompanhia1 ?? this.siglaCompanhia1,
      eticket1: eticket1 ?? this.eticket1,
      loc1: loc1 ?? this.loc1,
      cia2: cia2 ?? this.cia2,
      voo2: voo2 ?? this.voo2,
      origem2: origem2 ?? this.origem2,
      destino2: destino2 ?? this.destino2,
      saida2: saida2 ?? this.saida2,
      chegada2: chegada2 ?? this.chegada2,
      siglaCompanhia2: siglaCompanhia2 ?? this.siglaCompanhia2,
      eticket2: eticket2 ?? this.eticket2,
      loc2: loc2 ?? this.loc2,
      cia21: cia21 ?? this.cia21,
      voo21: voo21 ?? this.voo21,
      origem21: origem21 ?? this.origem21,
      destino21: destino21 ?? this.destino21,
      saida21: saida21 ?? this.saida21,
      chegada21: chegada21 ?? this.chegada21,
      siglaCompanhia21: siglaCompanhia21 ?? this.siglaCompanhia21,
      eticket21: eticket21 ?? this.eticket21,
      loc21: loc21 ?? this.loc21,
      cia3: cia3 ?? this.cia3,
      voo3: voo3 ?? this.voo3,
      origem3: origem3 ?? this.origem3,
      destino3: destino3 ?? this.destino3,
      saida3: saida3 ?? this.saida3,
      chegada3: chegada3 ?? this.chegada3,
      siglaCompanhia3: siglaCompanhia3 ?? this.siglaCompanhia3,
      eticket3: eticket3 ?? this.eticket3,
      loc3: loc3 ?? this.loc3,
      cia4: cia4 ?? this.cia4,
      voo4: voo4 ?? this.voo4,
      origem4: origem4 ?? this.origem4,
      destino4: destino4 ?? this.destino4,
      saida4: saida4 ?? this.saida4,
      chegada4: chegada4 ?? this.chegada4,
      siglaCompanhia4: siglaCompanhia4 ?? this.siglaCompanhia4,
      eticket4: eticket4 ?? this.eticket4,
      loc4: loc4 ?? this.loc4,
      cia41: cia41 ?? this.cia41,
      voo41: voo41 ?? this.voo41,
      origem41: origem41 ?? this.origem41,
      destino41: destino41 ?? this.destino41,
      saida41: saida41 ?? this.saida41,
      chegada41: chegada41 ?? this.chegada41,
      siglaCompanhia41: siglaCompanhia41 ?? this.siglaCompanhia41,
      eticket41: eticket41 ?? this.eticket41,
      loc41: loc41 ?? this.loc41,
      uidTransferIn: uidTransferIn ?? this.uidTransferIn,
      uidTransferOuT: uidTransferOuT ?? this.uidTransferOuT,
      quarto: quarto ?? this.quarto,
      isCheckOut: isCheckOut ?? this.isCheckOut,
      horaCheckOut: horaCheckOut ?? this.horaCheckOut,
      linkQr: linkQr ?? this.linkQr,
      hasCredenciamento: hasCredenciamento ?? this.hasCredenciamento,
      isRebanho: isRebanho ?? this.isRebanho,
      isEmbarque: isEmbarque ?? this.isEmbarque,
      horaEMbarque: horaEMbarque ?? this.horaEMbarque,
      isEmbarqueOut: isEmbarqueOut ?? this.isEmbarqueOut,
      horaEMbarqueOut: horaEMbarqueOut ?? this.horaEMbarqueOut,
      isEntregaBagagem: isEntregaBagagem ?? this.isEntregaBagagem,
      quantidadeBagagem: quantidadeBagagem ?? this.quantidadeBagagem,
      isVar1: isVar1 ?? this.isVar1,
      isVar2: isVar2 ?? this.isVar2,
      isVar3: isVar3 ?? this.isVar3,
      isVar4: isVar4 ?? this.isVar4,
      uidTransferIn2: uidTransferIn2 ?? this.uidTransferIn2,
      uidTransferOuT2: uidTransferOuT2 ?? this.uidTransferOuT2,
      isEmbarque2: isEmbarque2 ?? this.isEmbarque2,
      horaEMbarque2: horaEMbarque2 ?? this.horaEMbarque2,
      isEmbarqueOut2: isEmbarqueOut2 ?? this.isEmbarqueOut2,
      horaEMbarqueOut2: horaEMbarqueOut2 ?? this.horaEMbarqueOut2,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class ParticipantesTransfer {
  final String? uid;
  final String? nome;
  final String? telefone;
  final bool? isRebanho;
  final bool? isNoShow;
  final bool? isCancelado;
  final bool? isEmbarque;
  final Timestamp? horaEMbarque;
  final String? cia1;
  final String? voo1;
  final String? sigla1;
  final String? cia2;
  final String? voo2;
  final String? sigla2;
  final bool? isEmbarqueOut;
  final Timestamp? horaEMbarqueOut;

  final bool? isFavorite;

  ParticipantesTransfer(
      {this.uid,
      this.nome,
      this.voo2,
      this.voo1,
      this.cia1,
      this.cia2,
      this.sigla1,
      this.sigla2,
      this.isEmbarqueOut,
      this.horaEMbarqueOut,
      this.telefone,
      this.isRebanho,
      this.isNoShow,
      this.isCancelado,
      this.isEmbarque,
      this.horaEMbarque,
      this.isFavorite});

  factory ParticipantesTransfer.fromMap(Map<String, dynamic> map) {
    return ParticipantesTransfer(
      uid: map['uid'] ?? '',
      nome: map['nome'] ?? '',
      telefone: map['telefone'] ?? '',
      isRebanho: map['isRebanho'] ?? false,
      isNoShow: map['isNoShow'] ?? false,
      isCancelado: map['isCancelado'] ?? false,
      isEmbarque: map['isEmbarque'] ?? false,
      horaEMbarque:
          map['horaEMbarque'] ?? Timestamp.fromMillisecondsSinceEpoch(86400000),
      isFavorite: false,
      cia1: map['cia1'] ?? '',
      voo1: map['voo1'] ?? '',
      sigla1: map['sigla1'] ?? '',
      cia2: map['cia2'] ?? '',
      voo2: map['voo2'] ?? '',
      sigla2: map['sigla2'] ?? '',
      isEmbarqueOut: map['isEmbarqueOut'] ?? false,
      horaEMbarqueOut: map['horaEMbarqueOut'] ??
          Timestamp.fromMillisecondsSinceEpoch(86400000),
    );
  }
}

class VooChegada {
  final String uid;
  final String cia2;
  final String voo2;
  final String origem2;
  final String destino2;
  final Timestamp saida2;
  final Timestamp chegada2;
  final String siglaCompanhia2;
  final Timestamp horaChegada;
  final bool hasArrived;

  VooChegada(
      {required this.uid,
      required this.cia2,
      required this.destino2,
      required this.origem2,
      required this.saida2,
      required this.siglaCompanhia2,
      required this.voo2,
      required this.chegada2,
      required this.hasArrived,
      required this.horaChegada});
}

class AgendaParticipante {
  final String uid;

  final String horario;
  final String tempo;

  final String atividades;
  final String facilitador;
  final String local;
  final int ordem;
  final int dia;

  AgendaParticipante({
    required this.uid,
    required this.horario,
    required this.tempo,
    required this.atividades,
    required this.facilitador,
    required this.local,
    required this.dia,
    required this.ordem,
  });
}

class PushNotification {
  PushNotification({
    required this.title,
    required this.body,
    required this.dataTitle,
    required this.dataBody,
    required this.user,
    required this.date,
    required this.isLido,
  });

  String title;
  String body;
  String dataTitle;
  String dataBody;
  Timestamp date;
  String user;
  bool isLido;
}

class TransferIn {
  final String? uid;
  final String? veiculoNumeracao;
  final String? classificacaoVeiculo;
  final String? status;
  final int? participantesEmbarcados;
  final int? totalParticipantes;
  final Timestamp? previsaoSaida;
  final Timestamp? previsaoChegada;
  final Timestamp? horaInicioViagem;
  final Timestamp? horaFimViagem;
  final int? previsaoChegadaGoogle;
  final String? origem;
  final String? destino;
  final String? origemConsultaMap;
  final String? destinoConsultaMaps;
  final String? observacaoVeiculo;
  final String? placa;
  final String? motorista;
  final int? notaAvaliacao;
  final bool? checkInicioViagem;
  final bool? checkFimViagem;
  final String? avaliacaoVeiculo;
  final bool? isAvaliado;
  final String? telefoneMotorista;
  final int? numeroVeiculo;
  final String? userInicioViagem;
  final String? userFimViagem;
  final double distancia;
  final String? uidTransferIn2;
  final String? uidTransferOuT2;
  final bool? isEmbarque2;
  final Timestamp? horaEMbarque2;
  final bool? isEmbarqueOut2;
  final Timestamp? horaEMbarqueOut2;

  TransferIn(
      {this.uid,
      this.veiculoNumeracao,
      this.status,
      this.participantesEmbarcados,
      this.totalParticipantes,
      this.previsaoChegada,
      this.previsaoSaida,
      this.horaFimViagem,
      this.horaInicioViagem,
      this.origem,
      this.destino,
      this.origemConsultaMap,
      this.destinoConsultaMaps,
      this.observacaoVeiculo,
      this.placa,
      this.motorista,
      this.notaAvaliacao,
      this.checkInicioViagem,
      this.checkFimViagem,
      this.avaliacaoVeiculo,
      this.isAvaliado,
      this.previsaoChegadaGoogle,
      this.classificacaoVeiculo,
      this.numeroVeiculo,
      this.uidTransferIn2,
      this.uidTransferOuT2,
      this.isEmbarque2,
      this.horaEMbarqueOut2,
      this.isEmbarqueOut2,
      this.horaEMbarque2,
      this.telefoneMotorista,
      this.userFimViagem,
      this.userInicioViagem,
      required this.distancia});

  factory TransferIn.empty() {
    return TransferIn(
        avaliacaoVeiculo: '',
        checkFimViagem: false,
        checkInicioViagem: false,
        classificacaoVeiculo: '',
        destino: '',
        destinoConsultaMaps: '',
        distancia: 0,
        horaEMbarque2: Timestamp.fromMillisecondsSinceEpoch(86400000),
        horaEMbarqueOut2: Timestamp.fromMillisecondsSinceEpoch(86400000),
        horaFimViagem: Timestamp.fromMillisecondsSinceEpoch(86400000),
        horaInicioViagem: Timestamp.fromMillisecondsSinceEpoch(86400000),
        isAvaliado: false,
        isEmbarque2: false,
        isEmbarqueOut2: false,
        motorista: '',
        notaAvaliacao: 0,
        numeroVeiculo: 0,
        observacaoVeiculo: '',
        origem: '',
        origemConsultaMap: '',
        participantesEmbarcados: 0,
        placa: '',
        previsaoChegada: Timestamp.fromMillisecondsSinceEpoch(86400000),
        previsaoChegadaGoogle: 0,
        previsaoSaida: Timestamp.fromMillisecondsSinceEpoch(86400000),
        status: '',
        telefoneMotorista: '',
        totalParticipantes: 0,
        uid: '',
        uidTransferIn2: '',
        uidTransferOuT2: '',
        userFimViagem: '',
        userInicioViagem: '',
        veiculoNumeracao: '');
  }

  factory TransferIn.fromMap(Map<String, dynamic> map) {
    return TransferIn(
      // uidTransferIn2: snapshot.get('uidTransferIn2') ?? '',
      // uidTransferOuT2: snapshot.get('uidTransferOut2') ?? '',
      // isEmbarque2: snapshot.get('isEmbarque2') ?? false,
      // isEmbarqueOut2: snapshot.get('isEmbarqueOut2') ?? false,
      // horaEMbarque2: snapshot.get('horaEMbarque2') ??
      //     Timestamp.fromMicrosecondsSinceEpoch(86400000),
      // horaEMbarqueOut2: snapshot.get('horaEMbarqueOut2') ??
      //     Timestamp.fromMicrosecondsSinceEpoch(86400000),
      uid: map['uid'] ?? '',
      veiculoNumeracao: map['veiculoNumeracao'] ?? '',
      classificacaoVeiculo: map['classificacaoVeiculo'] ?? '',
      status: map['status'] ?? '',
      participantesEmbarcados: map['participantesEmbarcados'] ?? 0,
      totalParticipantes: map['totalParticipantes'] ?? 0,
      previsaoSaida: map['previsaoSaida'] ??
          Timestamp.fromMillisecondsSinceEpoch(86400000),
      previsaoChegada: map['previsaoChegada'] ??
          Timestamp.fromMillisecondsSinceEpoch(86400000),
      horaInicioViagem: map['horaInicioViagem'] ??
          Timestamp.fromMillisecondsSinceEpoch(86400000),
      horaFimViagem: map['horaFimViagem'] ??
          Timestamp.fromMillisecondsSinceEpoch(86400000),
      previsaoChegadaGoogle: map['previsaoChegadaGoogle'] ?? 0,
      origem: map['origem'] ?? '',
      destino: map['destino'] ?? '',
      origemConsultaMap: map['origemConsultaMap'] ?? '',
      destinoConsultaMaps: map['destinoConsultaMaps'] ?? '',
      observacaoVeiculo: map['observacaoVeiculo'] ?? '',
      placa: map['placa'] ?? '',
      motorista: map['motorista'] ?? '',
      notaAvaliacao: map['notaAvaliacao'] ?? 0,
      checkInicioViagem: map['checkInicioViagem'] ?? false,
      checkFimViagem: map['checkFimViagem'] ?? false,
      avaliacaoVeiculo: map['avaliacaoVeiculo'] ?? '',
      isAvaliado: map['isAvaliado'] ?? false,
      telefoneMotorista: map['telefoneMotorista'] ?? '',
      numeroVeiculo: map['numeroVeiculo'] ?? 0,
      userInicioViagem: map['userInicioViagem'] ?? '',
      userFimViagem: map['userFimViagem'] ?? '',
      distancia: map['distancia'] ?? 0,
    );
  }
}

class Sala {
  final String? uid;
  final String? nomeacao;
  final String? descricao;
  final bool? isDisponivel;

  Sala({this.uid, this.nomeacao, this.descricao, this.isDisponivel});
}

class LocalTransfer {
  final String? uid;
  final String? local;
  final String? endereco;

  LocalTransfer({this.uid, this.endereco, this.local});
}

class Shuttle {
  final String uid;
  final String veiculoNumeracao;
  final String classificacaoVeiculo;
  final String status;
  final int participantesEmbarcados;
  final int totalParticipantes;
  final Timestamp previsaoSaida;
  final Timestamp previsaoChegada;
  final Timestamp horaInicioViagem;
  final Timestamp horaFimViagem;
  final int previsaoChegadaGoogle;
  final String origem;
  final String destino;
  final String origemConsultaMap;
  final String destinoConsultaMaps;
  final String observacaoVeiculo;
  final String placa;
  final String motorista;
  final double notaAvaliacao;
  final bool checkInicioViagem;
  final bool checkFimViagem;
  final String avaliacaoVeiculo;
  final bool isAvaliado;
  final String telefoneMotorista;
  final int numeroVeiculo;
  final String userInicioViagem;
  final String userFimViagem;
  final double distancia;
  final List<String> participante;

  Shuttle(
      {required this.uid,
      required this.veiculoNumeracao,
      required this.status,
      required this.participantesEmbarcados,
      required this.totalParticipantes,
      required this.previsaoChegada,
      required this.previsaoSaida,
      required this.horaFimViagem,
      required this.horaInicioViagem,
      required this.origem,
      required this.destino,
      required this.origemConsultaMap,
      required this.destinoConsultaMaps,
      required this.observacaoVeiculo,
      required this.placa,
      required this.motorista,
      required this.notaAvaliacao,
      required this.checkInicioViagem,
      required this.checkFimViagem,
      required this.avaliacaoVeiculo,
      required this.isAvaliado,
      required this.previsaoChegadaGoogle,
      required this.classificacaoVeiculo,
      required this.numeroVeiculo,
      required this.telefoneMotorista,
      required this.userFimViagem,
      required this.userInicioViagem,
      required this.distancia,
      required this.participante});

  factory Shuttle.empty() {
    return Shuttle(
        uid: '',
        veiculoNumeracao: '',
        status: '',
        participantesEmbarcados: 0,
        totalParticipantes: 0,
        previsaoChegada: Timestamp.now(),
        previsaoSaida: Timestamp.now(),
        horaFimViagem: Timestamp.now(),
        horaInicioViagem: Timestamp.now(),
        origem: '',
        destino: '',
        origemConsultaMap: '',
        destinoConsultaMaps: '',
        observacaoVeiculo: '',
        placa: '',
        motorista: '',
        notaAvaliacao: 0,
        checkInicioViagem: false,
        checkFimViagem: false,
        avaliacaoVeiculo: '',
        isAvaliado: false,
        previsaoChegadaGoogle: 0,
        classificacaoVeiculo: '',
        numeroVeiculo: 0,
        telefoneMotorista: '',
        userFimViagem: '',
        userInicioViagem: '',
        distancia: 0.0,
        participante: []);
  }
}

class Eventos {
  final String uid;
  final String titulo;
  final String descricao;
  final String observacao;
  final String local;
  final String equipe;
  final Timestamp dataInicio;
  final Timestamp dataTermino;
  final bool isTarefaConcluida;
  final List<String> coordenadores;

  Eventos({
    required this.uid,
    required this.local,
    required this.equipe,
    required this.titulo,
    required this.descricao,
    required this.observacao,
    required this.dataInicio,
    required this.dataTermino,
    required this.isTarefaConcluida,
    required this.coordenadores,
  });

  factory Eventos.empty() => Eventos(
      uid: '',
      local: '',
      equipe: '',
      titulo: '',
      descricao: '',
      observacao: '',
      dataInicio: Timestamp.fromMillisecondsSinceEpoch(0),
      dataTermino: Timestamp.fromMillisecondsSinceEpoch(0),
      isTarefaConcluida: false,
      coordenadores: []);

  // Map<String,dynamic> toMap() => {
  //   "uid": this.uid,
  //   "titulo": this.titulo,
  //   "descricao": this.descricao,
  // "observacao": this.observacao,
  // "local": this.local,
  // "equipe": this.equipe,
  // "dataInicio": this.dataInicio,
  // "dataTermino": this.dataTermino,
  // "isTarefaConcluida": this.isTarefaConcluida,
  // "coordenadores": this.coordenadores,
  // };
}

class CordenadorMail {
  final String email;
  CordenadorMail({required this.email});
}

class ItemEventos {
  final String uid;
  final String item;
  final bool isFinalizado;

  ItemEventos({
    required this.uid,
    required this.item,
    required this.isFinalizado,
  });
}

class UserEventos {
  final String uid;

  UserEventos({
    required this.uid,
  });
}
