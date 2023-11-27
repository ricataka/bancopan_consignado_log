import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'modelo_participantes.dart';

class DatabaseServiceShuttle {
  final String? shuttleUid;
  final String? paxUid;

  DatabaseServiceShuttle({this.shuttleUid, this.paxUid});

  final CollectionReference transferInColecao =
      FirebaseFirestore.instance.collection('shuttle');

  Future inserirDadosTransferIn(
      String uid,
      String veiculoNumeracao,
      String status,
      String classificacaoVeiculo,
      int participantesEmbarcados,
      int totalParticipantes,
      Timestamp previsaoSaida,
      Timestamp previsaoChegada,
      Timestamp horaInicioViagem,
      Timestamp horaFimViagem,
      int previsaoChegadaGoogle,
      String origem,
      String destino,
      String origemConsultaMaps,
      String destinoConsultaMaps,
      String observacaoVeiculo,
      String placa,
      String motorista,
      double notaAvaliacao,
      bool checkInicioViagem,
      bool checkFimViagem,
      String avaliacaoVeiculo,
      bool isAvaliado,
      String telefoneMotorista,
      int numeroVeiculo,
      String userInicioViagem,
      String userFimViagem,
      double distancia) async {
    return await transferInColecao.doc(uid).set({
      'veiculoNumeracao': veiculoNumeracao,
      'status': status,
      'classificacaoVeiculo': classificacaoVeiculo,
      'participantesEmbarcados': participantesEmbarcados,
      'totalParticipantes': totalParticipantes,
      'previsaoSaida': previsaoSaida,
      'previsaoChegada': previsaoChegada,
      'horaInicioViagem': horaInicioViagem,
      'horaFimViagem': horaFimViagem,
      'previsaoChegadaGoogle': previsaoChegadaGoogle,
      'origem': origem,
      'destino': destino,
      'origemConsultaMap': origemConsultaMaps,
      'destinoConsultaMaps': destinoConsultaMaps,
      'observacaoVeiculo': observacaoVeiculo,
      'placa': placa,
      'motorista': motorista,
      'notaAvaliacao': notaAvaliacao,
      'checkInicioViagem': checkInicioViagem,
      'checkFimViagem': checkFimViagem,
      'avaliacaoVeiculo': avaliacaoVeiculo,
      'isAvaliado': isAvaliado,
      'telefoneMotorista': telefoneMotorista,
      'numeroVeiculo': numeroVeiculo,
      'userInicioViagem': userInicioViagem,
      'userFimViagem': userFimViagem,
      'distancia': distancia,
      'participante': [],
    });
  }

  Future inserirDadosShuttleArcaMorumbi() async {
    return await transferInColecao.doc().set({
      'veiculoNumeracao': "VAN",
      'status': "Programado",
      'classificacaoVeiculo': "SHUTTLE",
      'participantesEmbarcados': 0,
      'totalParticipantes': 0,
      'previsaoSaida': Timestamp.now(),
      'previsaoChegada':
          Timestamp.now().toDate().add(const Duration(minutes: 18)),
      'horaInicioViagem': Timestamp.now(),
      'horaFimViagem': Timestamp.now(),
      'previsaoChegadaGoogle': 0,
      'origem': "ARCA",
      'destino': "HILTON MORUMBI",
      'origemConsultaMap':
          "Av. Manuel Bandeira, 360 - Vila Leopoldina, São Paulo - SP, 05317-020",
      'destinoConsultaMaps':
          "Av. das Nações Unidas, 12901 - Brooklin, São Paulo - SP, 04578-000",
      'observacaoVeiculo': "",
      'placa': "",
      'motorista': "",
      'notaAvaliacao': 0,
      'checkInicioViagem': false,
      'checkFimViagem': false,
      'avaliacaoVeiculo': "",
      'isAvaliado': false,
      'telefoneMotorista': "",
      'numeroVeiculo': 1,
      'userInicioViagem': "",
      'userFimViagem': "",
      'distancia': 0,
      'participante': [],
    });
  }

  Future inserirDadosShuttleMorumbiArca() async {
    return await transferInColecao.doc().set({
      'veiculoNumeracao': "VAN",
      'status': "Programado",
      'classificacaoVeiculo': "SHUTTLE",
      'participantesEmbarcados': 0,
      'totalParticipantes': 0,
      'previsaoSaida': Timestamp.now(),
      'previsaoChegada':
          Timestamp.now().toDate().add(const Duration(minutes: 18)),
      'horaInicioViagem': Timestamp.now(),
      'horaFimViagem': Timestamp.now(),
      'previsaoChegadaGoogle': 0,
      'origem': "HILTON MORUMBI",
      'destino': "ARCA",
      'origemConsultaMap':
          "Av. das Nações Unidas, 12901 - Brooklin, São Paulo - SP, 04578-000",
      'destinoConsultaMaps':
          "Av. Manuel Bandeira, 360 - Vila Leopoldina, São Paulo - SP, 05317-020",
      'observacaoVeiculo': "",
      'placa': "",
      'motorista': "",
      'notaAvaliacao': 0,
      'checkInicioViagem': false,
      'checkFimViagem': false,
      'avaliacaoVeiculo': "",
      'isAvaliado': false,
      'telefoneMotorista': "",
      'numeroVeiculo': 1,
      'userInicioViagem': "",
      'userFimViagem': "",
      'distancia': 0,
      'participante': [],
    });
  }

  Future updatePLanilhaDadosTransferIn(
      String uid,
      String veiculoNumeracao,
      String status,
      String classificacaoVeiculo,
      int participantesEmbarcados,
      int totalParticipantes,
      Timestamp previsaoSaida,
      Timestamp previsaoChegada,
      Timestamp horaInicioViagem,
      Timestamp horaFimViagem,
      int previsaoChegadaGoogle,
      String origem,
      String destino,
      String origemConsultaMaps,
      String destinoConsultaMaps,
      String observacaoVeiculo,
      String placa,
      String motorista,
      double notaAvaliacao,
      bool checkInicioViagem,
      bool checkFimViagem,
      String avaliacaoVeiculo,
      bool isAvaliado,
      String telefoneMotorista,
      int numeroVeiculo,
      String userInicioViagem,
      String userFimViagem,
      double distancia) async {
    return await transferInColecao.doc(uid).update({
      'veiculoNumeracao': veiculoNumeracao,
      'status': status,
      'classificacaoVeiculo': classificacaoVeiculo,
      'participantesEmbarcados': participantesEmbarcados,
      'totalParticipantes': totalParticipantes,
      'previsaoSaida': previsaoSaida,
      'previsaoChegada': previsaoChegada,
      'horaInicioViagem': horaInicioViagem,
      'horaFimViagem': horaFimViagem,
      'previsaoChegadaGoogle': previsaoChegadaGoogle,
      'origem': origem,
      'destino': destino,
      'origemConsultaMap': origemConsultaMaps,
      'destinoConsultaMaps': destinoConsultaMaps,
      'observacaoVeiculo': observacaoVeiculo,
      'placa': placa,
      'motorista': motorista,
      'notaAvaliacao': notaAvaliacao,
      'checkInicioViagem': checkInicioViagem,
      'checkFimViagem': checkFimViagem,
      'avaliacaoVeiculo': avaliacaoVeiculo,
      'isAvaliado': isAvaliado,
      'telefoneMotorista': telefoneMotorista,
      'numeroVeiculo': numeroVeiculo,
      'userInicioViagem': userInicioViagem,
      'userFimViagem': userFimViagem,
      'distancia': distancia
    });
  }

  Future updateDadosTransferIn(
    String uid,
    String veiculoNumeracao,
    Timestamp previsaoSaida,
    Timestamp previsaoChegada,
    String origem,
    String origemConsultaMap,
    String destino,
    String destinoConsultaMaps,
    String classificacaoVeiculo,
    String motorista,
    String telefoneMotorista,
  ) async {
    return await transferInColecao.doc(uid).update({
      'veiculoNumeracao': veiculoNumeracao,
      'previsaoSaida': previsaoSaida,
      'previsaoChegada': previsaoChegada,
      'origem': origem,
      'origemConsultaMap': origemConsultaMap,
      'destino': destino,
      'destinoConsultaMaps': destinoConsultaMaps,
      'classificacaoVeiculo': classificacaoVeiculo,
      'motorista': motorista,
      'telefoneMotorista': telefoneMotorista,
    });
  }

  Future updateNotaTransferIn(
    String uid,
    double notaAvaliacao,
  ) async {
    return await transferInColecao.doc(uid).update({
      'notaAvaliacao': 0,
    });
  }

  Future criarTransferIn(
      String uid,
      String veiculoNumeracao,
      String status,
      String classificacaoVeiculo,
      int participantesEmbarcados,
      int totalParticipantes,
      Timestamp previsaoSaida,
      Timestamp previsaoChegada,
      Timestamp horaInicioViagem,
      Timestamp horaFimViagem,
      int previsaoChegadaGoogle,
      String origem,
      String destino,
      String origemConsultaMaps,
      String destinoConsultaMaps,
      String observacaoVeiculo,
      String placa,
      String motorista,
      double notaAvaliacao,
      bool checkInicioViagem,
      bool checkFimViagem,
      String avaliacaoVeiculo,
      bool isAvaliado,
      String telefoneMotorista,
      int numeroVeiculo,
      String userInicioViagem,
      String userFimViagem,
      double distancia) async {
    return await transferInColecao.doc(uid).set({
      'veiculoNumeracao': veiculoNumeracao,
      'status': 'Programado',
      'classificacaoVeiculo': classificacaoVeiculo,
      'participantesEmbarcados': participantesEmbarcados,
      'totalParticipantes': totalParticipantes,
      'previsaoSaida': previsaoSaida,
      'previsaoChegada': previsaoChegada,
      'horaInicioViagem': horaInicioViagem,
      'horaFimViagem': horaFimViagem,
      'previsaoChegadaGoogle': previsaoChegadaGoogle,
      'origem': origem,
      'destino': destino,
      'origemConsultaMap': origemConsultaMaps,
      'destinoConsultaMaps': destinoConsultaMaps,
      'observacaoVeiculo': observacaoVeiculo,
      'placa': placa,
      'motorista': motorista,
      'notaAvaliacao': notaAvaliacao,
      'checkInicioViagem': checkInicioViagem,
      'checkFimViagem': checkFimViagem,
      'avaliacaoVeiculo': avaliacaoVeiculo,
      'isAvaliado': isAvaliado,
      'telefoneMotorista': telefoneMotorista,
      'numeroVeiculo': numeroVeiculo,
      'userInicioViagem': userInicioViagem,
      'userFimViagem': userFimViagem,
      'distancia': distancia
    });
  }

  List<Shuttle> _listTransferInSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      List<String> participantes = [];
      List<dynamic> participanteUid = doc.get('participante');
      for (var element in participanteUid) {
        participantes.add(
          element,
        );
      }
      return Shuttle(
        uid: doc.id,
        veiculoNumeracao: doc.get('veiculoNumeracao') ?? '',
        classificacaoVeiculo: doc.get('classificacaoVeiculo') ?? '',
        status: doc.get('status') ?? '',
        participantesEmbarcados: doc.get('participantesEmbarcados') ?? 0,
        totalParticipantes: doc.get('totalParticipantes') ?? 0,
        previsaoSaida: doc.get('previsaoSaida') ??
            Timestamp.fromMillisecondsSinceEpoch(86400000),
        previsaoChegada: doc.get('previsaoChegada') ??
            Timestamp.fromMillisecondsSinceEpoch(86400000),
        horaInicioViagem: doc.get('horaInicioViagem') ??
            Timestamp.fromMillisecondsSinceEpoch(86400000),
        horaFimViagem: doc.get('horaFimViagem') ??
            Timestamp.fromMillisecondsSinceEpoch(86400000),
        previsaoChegadaGoogle: doc.get('previsaoChegadaGoogle') ?? 0,
        origem: doc.get('origem') ?? '',
        destino: doc.get('destino') ?? '',
        origemConsultaMap: doc.get('origemConsultaMap') ?? '',
        destinoConsultaMaps: doc.get('destinoConsultaMaps') ?? '',
        observacaoVeiculo: doc.get('observacaoVeiculo') ?? '',
        placa: doc.get('placa') ?? '',
        motorista: doc.get('motorista') ?? '',
        notaAvaliacao: (doc.get('notaAvaliacao') as num).toDouble(),
        checkInicioViagem: doc.get('checkInicioViagem'),
        checkFimViagem: doc.get('checkFimViagem'),
        avaliacaoVeiculo: doc.get('avaliacaoVeiculo') ?? '',
        isAvaliado: doc.get('isAvaliado'),
        telefoneMotorista: doc.get('telefoneMotorista') ?? '',
        numeroVeiculo: doc.get('numeroVeiculo') ?? 0,
        userInicioViagem: doc.get('userInicioViagem') ?? '',
        userFimViagem: doc.get('userFimViagem') ?? '',
        distancia: (doc.get('distancia') as num).toDouble(),
        participante: participantes,
      );
    }).toList();
  }

  Stream<List<Shuttle>> get transferIn {
    return transferInColecao.snapshots().map(_listTransferInSnapshot);
  }

  Shuttle transferInSnapShot(DocumentSnapshot snapshot) {
    List<String> participantes = [];
    List<dynamic> participanteUid = snapshot.get('participante');
    for (var element in participanteUid) {
      participantes.add(
        element,
      );
    }
    return Shuttle(
      uid: snapshot.id,
      veiculoNumeracao: snapshot.get('veiculoNumeracao') ?? '',
      classificacaoVeiculo: snapshot.get('classificacaoVeiculo') ?? '',
      status: snapshot.get('status') ?? '',
      participantesEmbarcados: snapshot.get('participantesEmbarcados') ?? 0,
      totalParticipantes: snapshot.get('totalParticipantes') ?? 0,
      previsaoSaida: snapshot.get('previsaoSaida') ??
          Timestamp.fromMillisecondsSinceEpoch(86400000),
      previsaoChegada: snapshot.get('previsaoChegada') ??
          Timestamp.fromMillisecondsSinceEpoch(86400000),
      horaInicioViagem: snapshot.get('horaInicioViagem') ??
          Timestamp.fromMillisecondsSinceEpoch(86400000),
      horaFimViagem: snapshot.get('horaFimViagem') ??
          Timestamp.fromMillisecondsSinceEpoch(86400000),
      previsaoChegadaGoogle: snapshot.get('previsaoChegadaGoogle') ?? 0,
      origem: snapshot.get('origem') ?? '',
      destino: snapshot.get('destino') ?? '',
      origemConsultaMap: snapshot.get('origemConsultaMap') ?? '',
      destinoConsultaMaps: snapshot.get('destinoConsultaMaps') ?? '',
      observacaoVeiculo: snapshot.get('observacaoVeiculo') ?? '',
      placa: snapshot.get('placa') ?? '',
      motorista: snapshot.get('motorista') ?? '',
      notaAvaliacao: (snapshot.get('notaAvaliacao') as num).toDouble(),
      checkInicioViagem: snapshot.get('checkInicioViagem'),
      checkFimViagem: snapshot.get('checkFimViagem'),
      avaliacaoVeiculo: snapshot.get('avaliacaoVeiculo') ?? '',
      isAvaliado: snapshot.get('isAvaliado') ?? false,
      telefoneMotorista: snapshot.get('telefoneMotorista') ?? '',
      numeroVeiculo: snapshot.get('numeroVeiculo') ?? 0,
      userInicioViagem: snapshot.get('userInicioViagem') ?? '',
      userFimViagem: snapshot.get('userFimViagem') ?? '',
      distancia: (snapshot.get('distancia') as num).toDouble(),
      participante: participantes,
    );
  }

  Stream<Shuttle> get transferInSnapshot {
    return transferInColecao
        .doc(shuttleUid)
        .snapshots()
        .map(transferInSnapShot);
  }

  Future insertPaxShuttle(
    String uid,
    List<String> participante,
  ) async {
    for (var pax in participante) {
      await FirebaseFirestore.instance.collection("shuttle").doc(uid).set({
        "participante": FieldValue.arrayUnion([pax])
      }, SetOptions(merge: true));
    }
  }

  Future updatePaxShuttle(
    String uid,
    List<String> participante,
  ) async {
    for (var pax in participante) {
      await FirebaseFirestore.instance.collection("shuttle").doc(uid).update({
        "participante": FieldValue.arrayUnion([pax])
      });
    }
  }

  Future removerPaxShuttle(
    String uid,
    String value,
  ) async {
    return await FirebaseFirestore.instance
        .collection("shuttle")
        .doc(uid)
        .update({
      "participante": FieldValue.arrayRemove([
        value,

        //Make sure this is Map<String, dynamic> so that firestore can read it
      ])
    });
    // participante.forEach((value) async {
    //   await FirebaseFirestore.instance.collection("shuttle").doc(uid).update({
    //     "participante": FieldValue.arrayRemove([
    //
    //       value,
    //
    //
    //
    //
    //       //Make sure this is Map<String, dynamic> so that firestore can read it
    //     ])
    //   } );
    // });
  }

  Future updatePrevisaoChegadaGoogle(String uid, int previsaoChegadaGoogle,
      double distancia, String horaAtualizacao) async {
    return await transferInColecao.doc(uid).update({
      'previsaoChegadaGoogle': previsaoChegadaGoogle,
      'distancia': distancia,
      'observacaoVeiculo': horaAtualizacao,
    });
  }

  Future updateIncrementoEmbarcadoCarro(String uid) async {
    return await transferInColecao.doc(uid).update({
      'participantesEmbarcados': FieldValue.increment(1),
    });
  }

  Future updateVeiculoTransferenciaOutSomar(String uid) async {
    return await transferInColecao.doc(uid).update({
      'totalParticipantes': FieldValue.increment(1),
      'participantesEmbarcados': FieldValue.increment(1),
    });
  }

  Future updateVeiculoTransferenciaOutDiminuir(String uid) async {
    return await transferInColecao.doc(uid).update({
      'totalParticipantes': FieldValue.increment(-1),
      'participantesEmbarcados': FieldValue.increment(-1),
    });
  }

  Future updateNumeroPax(String uid, int total, int embarcados) async {
    return await transferInColecao.doc(uid).update({
      'totalParticipantes': FieldValue.increment(total),
      'participantesEmbarcados': FieldValue.increment(embarcados),
    });
  }

  Future updateIncrementoTotalCarro(String uid) async {
    return await transferInColecao.doc(uid).update({
      'totalParticipantes': FieldValue.increment(1.0),
    });
  }

  Future updateAvaliacaoVeiculo(
      String uid, double nota, String avaliacaoVeiculo) async {
    return await transferInColecao.doc(uid).update({
      'notaAvaliacao': nota,
      'avaliacaoVeiculo': avaliacaoVeiculo,
      'isAvaliado': true,
    });
  }

  Future updateDetrimentoEmbarcadoCarro(String uid) async {
    return await transferInColecao.doc(uid).update({
      'participantesEmbarcados': FieldValue.increment(-1.0),
    });
  }

  Future updateDetrimentoTotalCarro(String uid) async {
    return await transferInColecao.doc(uid).update({
      'totalParticipantes': FieldValue.increment(1.0),
    });
  }

  Future updateStatuCarroEmTransito(String uid, userName) async {
    return await transferInColecao.doc(uid).update({
      'status': 'Trânsito',
      'horaInicioViagem': FieldValue.serverTimestamp(),
      'checkInicioViagem': true,
      'userInicioViagem': userName,
    });
  }

  Future updateStatuCarroEmFinalizado(String uid, String userName) async {
    return await transferInColecao.doc(uid).update({
      'status': 'Finalizado',
      'horaFimViagem': FieldValue.serverTimestamp(),
      'checkFimViagem': true,
      'userFimViagem': userName,
    });
  }

  Future updateStatuCarroEmAvaliacao(String uid) async {
    return await transferInColecao.doc(uid).update({
      'status': 'Finalizado',
    });
  }

  Future updateStatusCancelado(String uid) async {
    return await transferInColecao.doc(uid).update({
      'status': 'Cancelado',
      'horaFimViagem': FieldValue.serverTimestamp(),
    });
  }

  Future updateZerarViagem(String uid) async {
    return await transferInColecao.doc(uid).update({
      'status': 'Programado',
      'checkFimViagem': false,
      'checkInicioViagem': false,
      'isAvaliado': false
    });
  }

// Future updateParticipantesEmbarcarOk(String uid) async {
//   return await transferInColecao
//       .doc(transferUid)
//       .collection('participantesTransfer')
//       .doc(uid)
//       .update({
//     'isEmbarque': true,
//     'horaEMbarque': FieldValue.serverTimestamp(),
//   });
// }
//
// Future updateParticipantesEmbarcarOUTOk(String uid) async {
//   return await transferInColecao
//       .doc(transferUid)
//       .collection('participantesTransfer')
//       .doc(uid)
//       .update({
//     'isEmbarqueOut': true,
//     'horaEMbarqueOut': FieldValue.serverTimestamp(),
//   });
// }
//
// Future updateParticipantesCancelarEmbarque(String uid) async {
//   return await transferInColecao
//       .doc(transferUid)
//       .collection('participantesTransfer')
//       .doc(uid)
//       .update({
//     'isEmbarque': false,
//   });
// }
//
// Future updateParticipantesCancelarOUTEmbarque(String uid) async {
//   return await transferInColecao
//       .doc(transferUid)
//       .collection('participantesTransfer')
//       .doc(uid)
//       .update({
//     'isEmbarqueOut': false,
//   });
// }
//
// Future updateParticipantesRebanhoOK(String uid) async {
//   return await transferInColecao
//       .doc(transferUid)
//       .collection('participantesTransfer')
//       .doc(uid)
//       .update({
//     'isRebanho': true,
//   });
// }
//
// Future updateParticipantesCancelarRebanho(String uid) async {
//   return await transferInColecao
//       .doc(transferUid)
//       .collection('participantesTransfer')
//       .doc(uid)
//       .update({
//     'isRebanho': false,
//   });
// }
}

class DatabaseServiceUsuarioControleApp {
  final CollectionReference participantesColecao =
      FirebaseFirestore.instance.collection('usuario');

  Future updateHorarioSala(Timestamp hora) async {
    return await participantesColecao
        .doc('311.758.78-08')
        .collection('chat')
        .doc('7nScJkmx6sjzx57S8WI2')
        .update({
      'horarioControle': hora,
    });
  }

  List<UserControleApp> _listUsuarioControleApp(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserControleApp(
        uid: doc.id,
        horarioControle: doc.get('horarioControle'),
      );
    }).toList();
  }

  Stream<List<UserControleApp>> get listaconversas {
    return participantesColecao
        .doc('311.757.778-08')
        .collection('chat')
        .snapshots()
        .map(_listUsuarioControleApp);
  }
}

class DatabaseServiceQuartos {
  final String uid;

  DatabaseServiceQuartos({required this.uid});

  final CollectionReference participantesColecao =
      FirebaseFirestore.instance.collection('quartos');

  Future createQuarto(
    String uid,
    String quarto,
    String x,
  ) async {
    return await participantesColecao.doc(uid).set({
      'uid': uid,
      'quarto': quarto,
      'isEntregue': false,
      'horaEntrega': Timestamp.now(),
      'responsavel': "",
    });
  }

  Future updateEntregaQuarto2(
    String uid,
  ) async {
    return await participantesColecao.doc(uid).update({
      'isEntregue2': true,
      'horaEntrega2': FieldValue.serverTimestamp(),
    });
  }

  Future cancelarEntregaQuarto2(
    String uid,
  ) async {
    return await participantesColecao.doc(uid).update({
      'isEntregue2': false,
      'horaEntrega2': FieldValue.serverTimestamp(),
    });
  }

  Future updateEntregaQuarto(
    String uid,
  ) async {
    return await participantesColecao.doc(uid).update({
      'isEntregue': true,
      'horaEntrega': FieldValue.serverTimestamp(),
    });
  }

  Future cancelarEntregaQuarto(
    String uid,
  ) async {
    return await participantesColecao.doc(uid).update({
      'isEntregue': false,
      'horaEntrega': FieldValue.serverTimestamp(),
    });
  }

  EntregaBrinde _quartosDataFromSnapShot(DocumentSnapshot snapshot) {
    return EntregaBrinde(
      uid: uid,
      isEntregue2: snapshot.get('isEntregue2') ?? false,
      horaEntrega2: snapshot.get('horaEntrega2') ?? Timestamp(0, 0),
      responsavel2: snapshot.get('responsavel2') ?? '',
      quarto: snapshot.get('quarto') ?? '',
      isEntregue: snapshot.get('isEntregue') ?? false,
      horaEntrega: snapshot.get('horaEntrega') ?? Timestamp.now(),
      responsavel: snapshot.get('responsavel') ?? '',
    );
  }

  Stream<EntregaBrinde> get quarto {
    return participantesColecao
        .doc(uid)
        .snapshots()
        .map(_quartosDataFromSnapShot);
  }

  List<EntregaBrinde> _listEntregaBrindeSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return EntregaBrinde(
        isEntregue2: doc.get('isEntregue2') ?? false,
        horaEntrega2: doc.get('horaEntrega2') ?? Timestamp(0, 0),
        responsavel2: doc.get('responsavel2') ?? '',
        uid: doc.id,
        quarto: doc.get('quarto') ?? '',
        isEntregue: doc.get('isEntregue') ?? false,
        horaEntrega: doc.get('horaEntrega') ?? Timestamp.now(),
        responsavel: doc.get('responsavel') ?? '',
      );
    }).toList();
  }

  Stream<List<EntregaBrinde>> get colecaoquarto {
    return participantesColecao.snapshots().map(_listEntregaBrindeSnapshot);
  }
}

class DatabaseServiceAgendaParticipantes {
  final CollectionReference participantesColecao =
      FirebaseFirestore.instance.collection('agendaParticipante');

  Future insertAgendaParticipante(
    String uid,
    String horario,
    String tempo,
    String atividades,
    String facilitador,
    String local,
    int ordem,
    int dia,
  ) async {
    return await participantesColecao.doc(uid).set({
      'horario': horario,
      'tempo': tempo,
      'atividades': atividades,
      'facilitador': facilitador,
      'local': local,
      'ordem': ordem,
      'dia': dia,
    });
  }

  Future updateParticipantesEmbarcarOUTItau(
      String uidPax, String uidTransfer) async {
    return await participantesColecao.doc(uidPax).update({
      'uidTransferOuT': uidTransfer,
      'isEmbarqueOut': true,
      'horaEMbarqueOut': FieldValue.serverTimestamp(),
    });
  }

  Future updateAgendaParticipante(
    String uid,
    String horario,
    String tempo,
    String atividades,
    String facilitador,
    String local,
    int ordem,
    int dia,
  ) async {
    return await participantesColecao.doc(uid).update({
      'horario': horario,
      'tempo': tempo,
      'atividades': atividades,
      'facilitador': facilitador,
      'local': local,
      'ordem': ordem,
      'dia': dia,
    });
  }

  List<AgendaParticipante> _listcompromissosParticipantes(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AgendaParticipante(
        uid: doc.id,
        horario: doc.get('horario') ?? '',
        tempo: doc.get('tempo') ?? '',
        atividades: doc.get('atividades') ?? '',
        facilitador: doc.get('facilitador') ?? '',
        local: doc.get('local') ?? Timestamp.now(),
        ordem: doc.get('ordem') ?? 1,
        dia: doc.get('dia') ?? 1,
      );
    }).toList();
  }

  Stream<List<AgendaParticipante>> get compromissos {
    return participantesColecao.snapshots().map(_listcompromissosParticipantes);
  }
}

class DatabaseServiceVoosChegada {
  final CollectionReference participantesColecao =
      FirebaseFirestore.instance.collection('voosChegada');

  Future insertVooChegada(
    String uid,
    String cia2,
    String voo2,
    String origem2,
    String destino2,
    Timestamp saida2,
    Timestamp chegada2,
    String siglaCompanhia2,
  ) async {
    return await participantesColecao.doc(uid).set({
      'cia2': cia2,
      'voo2': voo2,
      'origem2': origem2,
      'destino2': destino2,
      'saida2': saida2,
      'chegada2': chegada2,
      'siglaCompanhia2': siglaCompanhia2,
      'horaChegada': Timestamp.now(),
      'hasArrived': false,
    });
  }

  Future updateDadosVooChegada(
    String uid,
    String cia2,
    String voo2,
    String origem2,
    String destino2,
    Timestamp saida2,
    Timestamp chegada2,
    String siglaCompanhia2,
  ) async {
    return await participantesColecao.doc(uid).update({
      'cia2': cia2,
      'voo2': voo2,
      'origem2': origem2,
      'destino2': destino2,
      'saida2': saida2,
      'chegada2': chegada2,
      'siglaCompanhia2': siglaCompanhia2,
      'horaChegada': Timestamp.now(),
      'hasArrived': false,
    });
  }

  Future updateVooChegadaOk(
    String uid,
  ) async {
    return await participantesColecao.doc(uid).update({
      'hasArrived': true,
      'horaChegada': Timestamp.now(),
    });
  }

  Future updateVooChegadaCancelar(
    String uid,
  ) async {
    return await participantesColecao.doc(uid).update({
      'hasArrived': false,
      'horaChegada': Timestamp.now(),
    });
  }

  List<VooChegada> _listVooChegadaSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return VooChegada(
        uid: doc.id,
        cia2: doc.get('cia2') ?? '',
        voo2: doc.get('voo2') ?? '',
        origem2: doc.get('origem2') ?? '',
        destino2: doc.get('destino2') ?? '',
        saida2: doc.get('saida2') ?? Timestamp.now(),
        chegada2: doc.get('chegada2') ?? Timestamp.now(),
        siglaCompanhia2: doc.get('siglaCompanhia2') ?? '',
        horaChegada: doc.get('horaChegada') ?? Timestamp.now(),
        hasArrived: doc.get('hasArrived') ?? false,
      );
    }).toList();
  }

  Stream<List<VooChegada>> get vooschegada {
    return participantesColecao.snapshots().map(_listVooChegadaSnapshot);
  }
}

class DatabaseServiceUsuarios {
  final String? uid;

  DatabaseServiceUsuarios({this.uid});

  final CollectionReference participantesColecao =
      FirebaseFirestore.instance.collection('coordenador');

  Future updateDadosCoordenador(
    String uid,
    String nome,
    String urlFoto,
    String email,
    String telefone,
  ) async {
    return await participantesColecao.doc(uid).set({
      'uid': uid,
      'nome': nome,
      'urlFoto': urlFoto,
      'telefone': telefone,
      'email': email,
      'isAceite': false,
    });
  }

  Future updateTermosCoordenador(
    String uid,
  ) async {
    return await participantesColecao.doc(uid).set({
      'uid': uid,
      'isAceite': true,
    }, SetOptions(merge: true));
  }

  Future updateNomeTel(
    String nome,
    String telefone,
  ) async {
    return await participantesColecao.doc('$uid').update({
      'nome': nome,
      'telefone': telefone,
    });
  }

  Future updatePhoto(
    String urlFoto,
  ) async {
    return await participantesColecao.doc('$uid').update({
      'urlFoto': urlFoto,
    });
  }

  List<Coordenador> _listUsuariosSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Coordenador(
        uid: doc.id,
        nome: doc.get('nome') ?? '',
        urlFoto: doc.get('urlFoto') ?? '',
        email: doc.get('email') ?? '',
        telefone: doc.get('telefone') ?? '',
        isAceite: doc.get('isAceite') ?? false,
        isFavorite: false,
      );
    }).toList();
  }

  Stream<List<Coordenador>> get getUsuarios {
    return participantesColecao.snapshots().map(_listUsuariosSnapshot);
  }

  Coordenador _usuariosDataFromSnapShot(DocumentSnapshot snapshot) {
    return Coordenador(
      uid: uid ?? '',
      nome: snapshot.get('nome') ?? '',
      urlFoto: snapshot.get('urlFoto') ?? '',
      email: snapshot.get('email') ?? '',
      telefone: snapshot.get('telefone') ?? '',
      isAceite: snapshot.get('isAceite') ?? false,
      isFavorite: false,
    );
  }

  Stream<Coordenador> get usuarioDados {
    return participantesColecao
        .doc(uid)
        .snapshots()
        .map(_usuariosDataFromSnapShot);
  }
}

class DatabaseServiceNotificacoes {
  final CollectionReference participantesColecao =
      FirebaseFirestore.instance.collection('Notificacoes');

  Future setNotificacoes(
    String title,
    String body,
    String user,
    Timestamp date,
    bool isLido,
  ) async {
    return await participantesColecao.doc().set(
      {
        'title': title,
        'body': body,
        'user': user,
        'date': date,
        'isLido': isLido
      },
    );
  }

  List<PushNotification> _listNotificacoesSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PushNotification(
        dataTitle: doc.get('dataTitle') ?? '',
        dataBody: doc.get('dataBody') ?? '',
        title: doc.get('title') ?? '',
        body: doc.get('body') ?? '',
        user: doc.get('user') ?? '',
        date: doc.get('date') ?? DateTime.now(),
        isLido: doc.get('isLido') ?? false,
      );
    }).toList();
  }

  Stream<List<PushNotification>> get getNotifications {
    return participantesColecao.snapshots().map(_listNotificacoesSnapShot);
  }
}

class DatabaseService {
  final CollectionReference participantesColecao =
      FirebaseFirestore.instance.collection('participantes');

  Future updateParticipantesuidOut2(String uid, String uidCarroOut) async {
    return await participantesColecao.doc(uid).update({
      'uidTransferOuT2': uidCarroOut,
      'isEmbarqueOut2': false,
    });
  }

  Future updateParticipantesuidOut2Itau(String uid, String uidCarroOut) async {
    return await participantesColecao.doc(uid).update({
      'uidTransferOuT2': uidCarroOut,
      'isEmbarqueOut2': true,
      'horaEMbarqueOut2': FieldValue.serverTimestamp(),
    });
  }

  Future updateDados(
    String uid,
    String nome,
    String cpf,
    String telefone,
    String email,
    String embarque,
    bool isCredenciamento,
    bool isEntregaMaterial,
    Timestamp horaCredenciamento,
    bool pcp,
    bool noShow,
    bool cancelado,
    String hotel,
    Timestamp checkIn,
    Timestamp checkOut,
    String hotel2,
    Timestamp checkIn2,
    Timestamp checkOut2,
    String cia1,
    String voo1,
    String origem1,
    String destino1,
    Timestamp saida1,
    Timestamp chegada1,
    String siglaCompanhia1,
    String eticket1,
    String loc1,
    String cia2,
    String voo2,
    String origem2,
    String destino2,
    Timestamp saida2,
    Timestamp chegada2,
    String siglaCompanhia2,
    String eticket2,
    String loc2,
    String cia3,
    String voo3,
    String origem3,
    String destino3,
    Timestamp saida3,
    Timestamp chegada3,
    String siglaCompanhia3,
    String eticket3,
    String loc3,
    String cia4,
    String voo4,
    String origem4,
    String destino4,
    Timestamp saida4,
    Timestamp chegada4,
    String siglaCompanhia4,
    String eticket4,
    String loc4,
    String uidTransferIn,
    String uidTransferOuT,
    String quarto,
    bool isCheckOut,
    Timestamp horaCheckOut,
    String linkQr,
    bool hasCredenciamento,
    bool isRebanho,
    bool isEmbarque,
    Timestamp horaEMbarque,
    bool isEmbarqueOut,
    Timestamp horaEMbarqueOut,
    bool isEntregaBagagem,
    int quantidadeBagagem,
    bool isVar1,
    bool isVar2,
    bool isVar3,
    bool isVar4,
  ) async {
    return await participantesColecao.doc(uid).set({
      'uid': uid,
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
      'email': email,
      'embarque': embarque,
      'isCredenciamento': isCredenciamento,
      'isEntregaMaterial': isEntregaMaterial,
      'horaCredenciamento': horaCredenciamento,
      'pcp': pcp,
      'noShow': noShow,
      'cancelado': cancelado,
      'hotel': hotel,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'hotel2': hotel2,
      'checkIn2': checkIn2,
      'checkOut2': checkOut2,
      'cia1': cia1,
      'voo1': voo1,
      'origem1': origem1,
      'destino1': destino1,
      'saida1': saida1,
      'chegada1': chegada1,
      'siglaCompanhia1': siglaCompanhia1,
      'eticket1': eticket1,
      'loc1': loc1,
      'cia2': cia2,
      'voo2': voo2,
      'origem2': origem2,
      'destino2': destino2,
      'saida2': saida2,
      'chegada2': chegada2,
      'siglaCompanhia2': siglaCompanhia2,
      'eticket2': eticket2,
      'loc2': loc2,
      'cia21': "",
      'voo21': "",
      'origem21': "",
      'destino21': "",
      'saida21': Timestamp.now(),
      'chegada21': Timestamp.now(),
      'siglaCompanhia21': "",
      'eticket21': "",
      'loc21': "",
      'cia3': cia3,
      'voo3': voo3,
      'origem3': origem3,
      'destino3': destino3,
      'saida3': saida3,
      'chegada3': chegada3,
      'siglaCompanhia3': siglaCompanhia3,
      'eticket3': eticket3,
      'loc3': loc3,
      'cia4': cia4,
      'voo4': voo4,
      'origem4': origem4,
      'destino4': destino4,
      'saida4': saida4,
      'chegada4': chegada4,
      'siglaCompanhia4': siglaCompanhia4,
      'eticket4': eticket4,
      'loc4': loc4,
      'cia41': "",
      'voo41': "",
      'origem41': "",
      'destino41': "",
      'saida41': Timestamp.now(),
      'chegada41': Timestamp.now(),
      'siglaCompanhia41': "",
      'eticket41': "",
      'loc41': "",
      'uidTransferIn': uidTransferIn,
      'uidTransferOuT': uidTransferOuT,
      'quarto': quarto,
      'isCheckOut': isCheckOut,
      'horaCheckOut': horaCheckOut,
      'linkQr': linkQr,
      'hasCredenciamento': hasCredenciamento,
      'isRebanho': isRebanho,
      'isEmbarque': isEmbarque,
      'horaEMbarque': horaEMbarque,
      'isEmbarqueOut': isEmbarqueOut,
      'horaEMbarqueOut': horaEMbarqueOut,
      'isEntregaBagagem': isEntregaBagagem,
      'quantidadeBagagem': quantidadeBagagem,
      'isVar1': isVar1,
      'isVar2': isVar2,
      'isVar3': isVar3,
      'isVar4': isVar4,
      'uidTransferIn2': "",
      'uidTransferOuT2': "",
      'isEmbarque2': false,
      'isEmbarqueOut2': false,
      'horaEMbarque2': Timestamp.now(),
      'horaEMbarqueOut2': Timestamp.now(),
      'hotelPernoiteIda1': "",
      'checkInPernoite1': Timestamp.now(),
      'checkOutPernoite1': Timestamp.now(),
      'hotelPernoiteVolta': "",
      'checkInPernoiteVolta': Timestamp.now(),
      'checkOutPernoiteVolta': Timestamp.now(),
    });
  }

  Future updateDados2(
    String uid,
    String nome,
    String cpf,
    String telefone,
    String email,
    String embarque,
    bool isCredenciamento,
    bool isEntregaMaterial,
    Timestamp horaCredenciamento,
    bool pcp,
    bool noShow,
    bool cancelado,
    String hotel,
    Timestamp checkIn,
    Timestamp checkOut,
    String hotel2,
    Timestamp checkIn2,
    Timestamp checkOut2,
    String cia1,
    String voo1,
    String origem1,
    String destino1,
    Timestamp saida1,
    Timestamp chegada1,
    String siglaCompanhia1,
    String eticket1,
    String loc1,
    String cia2,
    String voo2,
    String origem2,
    String destino2,
    Timestamp saida2,
    Timestamp chegada2,
    String siglaCompanhia2,
    String eticket2,
    String loc2,
    String cia3,
    String voo3,
    String origem3,
    String destino3,
    Timestamp saida3,
    Timestamp chegada3,
    String siglaCompanhia3,
    String eticket3,
    String loc3,
    String cia4,
    String voo4,
    String origem4,
    String destino4,
    Timestamp saida4,
    Timestamp chegada4,
    String siglaCompanhia4,
    String eticket4,
    String loc4,
    String uidTransferIn,
    String uidTransferOuT,
    String quarto,
    bool isCheckOut,
    Timestamp horaCheckOut,
    String linkQr,
    bool hasCredenciamento,
    bool isRebanho,
    bool isEmbarque,
    Timestamp horaEMbarque,
    bool isEmbarqueOut,
    Timestamp horaEMbarqueOut,
    bool isEntregaBagagem,
    int quantidadeBagagem,
    bool isVar1,
    bool isVar2,
    bool isVar3,
    bool isVar4,
  ) async {
    return await participantesColecao.doc(uid).update({
      'hotelPernoiteIda1': hotel,
      'checkInPernoite1': checkIn,
      'checkOutPernoite1': checkOut,
      'hotelPernoiteVolta': hotel2,
      'checkInPernoiteVolta': checkIn2,
      'checkOutPernoiteVolta': checkOut2,
      'siglaCompanhia1': siglaCompanhia1,
    });
  }

  Future updatePlanilhaVooIn(
    String uid,
    String cia1,
    String voo1,
    String origem1,
    String destino1,
    Timestamp saida1,
    Timestamp chegada1,
    String siglaCompanhia1,
    String eticket1,
    String loc1,
    String cia2,
    String voo2,
    String origem2,
    String destino2,
    Timestamp saida2,
    Timestamp chegada2,
    String siglaCompanhia2,
    String eticket2,
    String loc2,
  ) async {
    return await participantesColecao.doc(uid).update({
      'cia1': cia1,
      'voo1': voo1,
      'origem1': origem1,
      'destino1': destino1,
      'saida1': saida1,
      'chegada1': chegada1,
      'siglaCompanhia1': siglaCompanhia1,
      'eticket1': eticket1,
      'loc1': loc1,
      'cia2': cia2,
      'voo2': voo2,
      'origem2': origem2,
      'destino2': destino2,
      'saida2': saida2,
      'chegada2': chegada2,
      'siglaCompanhia2': siglaCompanhia2,
      'eticket2': eticket2,
      'loc2': loc2,
    });
  }

  Future updatePlanilhaVooOut(
    String uid,
    String cia3,
    String voo3,
    String origem3,
    String destino3,
    Timestamp saida3,
    Timestamp chegada3,
    String siglaCompanhia3,
    String eticket3,
    String loc3,
    String cia4,
    String voo4,
    String origem4,
    String destino4,
    Timestamp saida4,
    Timestamp chegada4,
    String siglaCompanhia4,
    String eticket4,
    String loc4,
  ) async {
    return await participantesColecao.doc(uid).update({
      'cia3': cia3,
      'voo3': voo3,
      'origem3': origem3,
      'destino3': destino3,
      'saida3': saida3,
      'chegada3': chegada3,
      'siglaCompanhia3': siglaCompanhia3,
      'eticket3': eticket3,
      'loc3': loc3,
      'cia4': cia4,
      'voo4': voo4,
      'origem4': origem4,
      'destino4': destino4,
      'saida4': saida4,
      'chegada4': chegada4,
      'siglaCompanhia4': siglaCompanhia4,
      'eticket4': eticket4,
      'loc4': loc4,
    });
  }

  Future criarPaxFormulario({
    // String id,
    required String nome,
    required String telefone,
    required String email,
    required bool pcp,
    required bool hasCredenciamento,
  }) async {
    return await FirebaseFirestore.instance.collection('participantes').add({
      'nome': nome,
      'cpf': "",
      'telefone': telefone,
      'email': email,
      'embarque': "",
      'isCredenciamento': false,
      'isEntregaMaterial': false,
      'horaCredenciamento': Timestamp.now(),
      'pcp': pcp,
      'noShow': false,
      'cancelado': false,
      'hotel': '',
      'checkIn': Timestamp.now(),
      'checkOut': Timestamp.now(),
      'hotel2': '',
      'checkIn2': Timestamp.now(),
      'checkOut2': Timestamp.now(),
      'cia1': '',
      'voo1': '',
      'origem1': '',
      'destino1': '',
      'saida1': Timestamp.now(),
      'chegada1': Timestamp.now(),
      'siglaCompanhia1': '',
      'eticket1': '',
      'loc1': '',
      'cia2': '',
      'voo2': '',
      'origem2': '',
      'destino2': '',
      'saida2': Timestamp.now(),
      'chegada2': Timestamp.now(),
      'siglaCompanhia2': '',
      'eticket2': '',
      'loc2': '',
      'cia21': '',
      'voo21': '',
      'origem21': '',
      'destino21': '',
      'saida21': Timestamp.now(),
      'chegada21': Timestamp.now(),
      'siglaCompanhia21': '',
      'eticket21': '',
      'loc21': '',
      'cia3': '',
      'voo3': '',
      'origem3': '',
      'destino3': '',
      'saida3': Timestamp.now(),
      'chegada3': Timestamp.now(),
      'siglaCompanhia3': '',
      'eticket3': '',
      'loc3': '',
      'cia4': '',
      'voo4': '',
      'origem4': '',
      'destino4': '',
      'saida4': Timestamp.now(),
      'chegada4': Timestamp.now(),
      'siglaCompanhia4': '',
      'eticket4': '',
      'loc4': '',
      'cia41': '',
      'voo41': '',
      'origem41': '',
      'destino41': '',
      'saida41': Timestamp.now(),
      'chegada41': Timestamp.now(),
      'siglaCompanhia41': '',
      'eticket41': '',
      'loc41': '',
      'uidTransferIn': '',
      'uidTransferOuT': '',
      'quarto': '',
      'isCheckOut': false,
      'horaCheckOut': Timestamp.now(),
      'linkQr': 'PORTUGUES',
      'hasCredenciamento': hasCredenciamento,
      'isRebanho': false,
      'isEmbarque': false,
      'horaEMbarque': Timestamp.now(),
      'isEmbarqueOut': false,
      'horaEMbarqueOut': Timestamp.now(),
      'isEntregaBagagem': false,
      'quantidadeBagagem': 0,
      'isVar1': false,
      'isVar2': false,
      'isVar3': false,
      'isVar4': false,
      'uidTransferIn2': "",
      'uidTransferOuT2': "",
      'isEmbarque2': false,
      'isEmbarqueOut2': false,
      'horaEMbarque2': Timestamp.now(),
      'horaEMbarqueOut2': Timestamp.now(),
      'hotelPernoiteIda1': '',
      'checkInPernoite1': Timestamp.now(),
      'checkOutPernoite1': Timestamp.now(),
      'hotelPernoiteVolta': '',
      'checkInPernoiteVolta': Timestamp.now(),
      'checkOutPernoiteVolta': Timestamp.now(),
    });
  }

  Future editarBox(
    String uid,
    String box,
  ) async {
    return await participantesColecao.doc(uid).update({
      'siglaCompanhia41': box,
    });
  }

  Future editarDadosStatusPax(
    String uid,
    String nome,
    String telefone,
    String email,
    bool pcp,
    bool noShow,
    bool cancelado,
  ) async {
    return await participantesColecao.doc(uid).update({
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'pcp': pcp,
      'noShow': noShow,
      'cancelado': cancelado,
    });
  }

  Future clearDadosHospedagem(
    String uid,
  ) async {
    return await participantesColecao.doc(uid).update({
      'hotelPernoiteIda1': '',
      'checkInPernoite1': Timestamp.now(),
      'checkOutPernoite1': Timestamp.now(),
      'hotel': '',
      'checkIn': Timestamp.now(),
      'checkOut': Timestamp.now(),
      'quarto': '',
      'hotel2': '',
      'checkIn2': Timestamp.now(),
      'checkOut2': Timestamp.now(),
      'hotelPernoiteVolta': '',
      'checkInPernoiteVolta': Timestamp.now(),
      'checkOutPernoiteVolta': Timestamp.now(),
    });
  }

  Future updateQuarto(
    String uid,
    String email,
  ) async {
    return await participantesColecao.doc(uid).update({
      'email': email,
    });
  }

  Future updateEMbarcadoShuttleOK(
    String uid,
  ) async {
    return await participantesColecao.doc(uid).update({
      'isVar2': true,
    });
  }

  Future updateEMbarcadoShuttleCancelar(
    String uid,
  ) async {
    return await participantesColecao.doc(uid).update({
      'isVar2': false,
    });
  }

  Future updateAgendaUser(
    String uid,
    String agenda,
  ) async {
    return await participantesColecao.doc(uid).update({
      'linkQr': agenda,
    });
  }

  Future updatEmail(
    String uid,
    String email,
  ) async {
    return await participantesColecao.doc(uid).update({
      'quarto': email,
    });
  }

  Future updateGrupoSorteio(
    String uid,
    String grupoSorteio,
  ) async {
    return await participantesColecao.doc(uid).update({
      'uidTransferIn2': "",
      'uidTransferOuT2': "",
      'isEmbarque2': false,
      'isEmbarqueOut2': false,
      'horaEMbarque2': Timestamp.now(),
      'horaEMbarqueOut2': Timestamp.now(),
    });
  }

  Future updateMala(
    String uid,
    String isentregarMala,
  ) async {
    return await participantesColecao.doc(uid).update({
      'isVar1': true,
    });
  }

  Future clearGanhadorSorteioVeiculo(
    String uid,
  ) async {
    return await participantesColecao.doc(uid).update({
      'isVar3': false,
    });
  }

  Future clearDadosVooIn(
    String uid,
  ) async {
    return await participantesColecao.doc(uid).update({
      'cia1': '',
      'voo1': '',
      'origem1': '',
      'destino1': '',
      'saida1': Timestamp.now(),
      'chegada1': Timestamp.now(),
      'siglaCompanhia1': '',
      'eticket1': '',
      'loc1': '',
      'cia2': '',
      'voo2': '',
      'origem2': '',
      'destino2': '',
      'saida2': Timestamp.now(),
      'chegada2': Timestamp.now(),
      'siglaCompanhia2': '',
      'eticket2': '',
      'loc2': '',
      'voo21': '',
      'origem21': '',
      'destino21': '',
      'saida21': Timestamp.now(),
      'chegada21': Timestamp.now(),
      'siglaCompanhia21': '',
      'eticket21': '',
      'loc21': '',
    });
  }

  Future clearCredenciamento(
    String uid,
    bool hasCredenciamento,
    String hotel,
  ) async {
    return await participantesColecao.doc(uid).update({
      'hasCredenciamento': hasCredenciamento,
      'hotel': hotel,
    });
  }

  Future clearDadosVooOut(
    String uid,
  ) async {
    return await participantesColecao.doc(uid).update({
      'cia3': '',
      'voo3': '',
      'origem3': '',
      'destino3': '',
      'saida3': Timestamp.now(),
      'chegada3': Timestamp.now(),
      'siglaCompanhia3': '',
      'eticket3': '',
      'loc3': '',
      'cia4': '',
      'voo4': '',
      'origem4': '',
      'destino4': '',
      'saida4': Timestamp.now(),
      'chegada4': Timestamp.now(),
      'siglaCompanhia4': '',
      'eticket4': '',
      'loc4': '',
      'cia41': '',
      'voo41': '',
      'origem41': '',
      'destino41': '',
      'saida41': Timestamp.now(),
      'chegada41': Timestamp.now(),
      'siglaCompanhia41': '',
      'eticket41': '',
      'loc41': '',
    });
  }

  Future updateDadosVooIn(
    String uid,
    String cia1,
    String voo1,
    String origem1,
    String destino1,
    Timestamp saida1,
    Timestamp chegada1,
    String siglacompanhia1,
    String loc1,
    String eticket1,
    String cia2,
    String voo2,
    String origem2,
    String destino2,
    Timestamp saida2,
    Timestamp chegada2,
    String siglacompanhia2,
    String loc2,
    String eticket2,
    String cia21,
    String voo21,
    String origem21,
    String destino21,
    Timestamp saida21,
    Timestamp chegada21,
    String siglacompanhia21,
    String loc21,
    String eticket21,
  ) async {
    return await participantesColecao.doc(uid).update({
      'cia1': cia1,
      'voo1': voo1,
      'origem1': origem1,
      'destino1': destino1,
      'saida1': saida1,
      'chegada1': chegada1,
      'siglaCompanhia1': siglacompanhia1,
      'eticket1': eticket1,
      'loc1': loc1,
      'cia2': cia2,
      'voo2': voo2,
      'origem2': origem2,
      'destino2': destino2,
      'saida2': saida2,
      'chegada2': chegada2,
      'siglaCompanhia2': siglacompanhia2,
      'eticket2': eticket2,
      'loc2': loc2,
      'cia21': cia21,
      'voo21': voo21,
      'origem21': origem21,
      'destino21': destino21,
      'saida21': saida21,
      'chegada21': chegada21,
      'siglaCompanhia21': siglacompanhia21,
      'eticket21': eticket21,
      'loc21': loc21,
    });
  }

  Future updateDadosVooIn2(
    String uid,
    String cia1,
    String voo1,
    String origem1,
    String destino1,
    Timestamp saida1,
    Timestamp chegada1,
    String siglacompanhia1,
    String loc1,
    String eticket1,
    String cia2,
    String voo2,
    String origem2,
    String destino2,
    Timestamp saida2,
    Timestamp chegada2,
    String siglacompanhia2,
    String loc2,
    String eticket2,
    String cia3,
    String voo3,
    String origem3,
    String destino3,
    Timestamp saida3,
    Timestamp chegada3,
    String siglacompanhia3,
    String loc3,
    String eticket3,
  ) async {
    return await participantesColecao.doc(uid).update({
      'cia1': cia1,
      'voo1': voo1,
      'origem1': origem1,
      'destino1': destino1,
      'saida1': saida1,
      'chegada1': chegada1,
      'siglaCompanhia1': siglacompanhia1,
      'eticket1': eticket1,
      'loc1': loc1,
      'cia2': cia2,
      'voo2': voo2,
      'origem2': origem2,
      'destino2': destino2,
      'saida2': saida2,
      'chegada2': chegada2,
      'siglaCompanhia2': siglacompanhia2,
      'eticket2': eticket2,
      'loc2': loc2,
      'cia21': cia3,
      'voo21': voo3,
      'origem21': origem3,
      'destino21': destino3,
      'saida21': saida3,
      'chegada21': chegada3,
      'siglaCompanhia21': siglacompanhia3,
      'eticket21': eticket3,
      'loc21': loc3,
    });
  }

  Future updateDadosLocIn(
    String uid,
    String cia1,
    String voo1,
    String origem1,
    String destino1,
    Timestamp saida1,
    Timestamp chegada1,
    String siglacompanhia1,
    String loc1,
    String eticket1,
    String cia2,
    String voo2,
    String origem2,
    String destino2,
    Timestamp saida2,
    Timestamp chegada2,
    String siglacompanhia2,
    String loc2,
    String eticket2,
    String cia3,
    String voo3,
    String origem3,
    String destino3,
    Timestamp saida3,
    Timestamp chegada3,
    String siglacompanhia3,
    String loc3,
    String eticket3,
  ) async {
    return await participantesColecao.doc(uid).update({
      'loc1': loc1,
      'loc2': loc2,
      'loc21': loc3,
    });
  }

  Future inserirPessoasTransfer(
    String uid,
    String cia3,
    String voo3,
    String origem3,
    String destino3,
    Timestamp saida3,
    Timestamp chegada3,
    String siglacompanhia3,
    String loc3,
    String eticket3,
    String cia4,
    String voo4,
    String origem4,
    String destino4,
    Timestamp saida4,
    Timestamp chegada4,
    String siglacompanhia4,
    String loc4,
    String eticket4,
  ) async {
    return await participantesColecao.doc(uid).update({
      'cia3': cia3,
      'voo3': voo3,
      'origem3': origem3,
      'destino3': destino3,
      'saida3': saida3,
      'chegada3': chegada3,
      'siglaCompanhia3': siglacompanhia3,
      'eticket3': eticket3,
      'loc3': loc3,
      'cia4': cia4,
      'voo4': voo4,
      'origem4': origem4,
      'destino4': destino4,
      'saida4': saida4,
      'chegada4': chegada4,
      'siglaCompanhia4': siglacompanhia4,
      'eticket4': eticket4,
      'loc4': loc4,
    });
  }

  Future updateDadosVooOut(
    String uid,
    String cia3,
    String voo3,
    String origem3,
    String destino3,
    Timestamp saida3,
    Timestamp chegada3,
    String siglacompanhia3,
    String loc3,
    String eticket3,
    String cia4,
    String voo4,
    String origem4,
    String destino4,
    Timestamp saida4,
    Timestamp chegada4,
    String siglacompanhia4,
    String loc4,
    String eticket4,
    String cia41,
    String voo41,
    String origem41,
    String destino41,
    Timestamp saida41,
    Timestamp chegada41,
    String siglacompanhia41,
    String loc41,
    String eticket41,
  ) async {
    return await participantesColecao.doc(uid).update({
      'cia3': cia3,
      'voo3': voo3,
      'origem3': origem3,
      'destino3': destino3,
      'saida3': saida3,
      'chegada3': chegada3,
      'siglaCompanhia3': siglacompanhia3,
      'eticket3': eticket3,
      'loc3': loc3,
      'cia4': cia4,
      'voo4': voo4,
      'origem4': origem4,
      'destino4': destino4,
      'saida4': saida4,
      'chegada4': chegada4,
      'siglaCompanhia4': siglacompanhia4,
      'eticket4': eticket4,
      'loc4': loc4,
      'cia41': cia41,
      'voo41': voo41,
      'origem41': origem41,
      'destino41': destino41,
      'saida41': saida41,
      'chegada41': chegada41,
      'siglaCompanhia41': siglacompanhia41,
      'eticket41': eticket41,
      'loc41': loc41,
    });
  }

  Future updateDadosLocOut(
    String uid,
    String cia3,
    String voo3,
    String origem3,
    String destino3,
    Timestamp saida3,
    Timestamp chegada3,
    String siglacompanhia3,
    String loc3,
    String eticket3,
    String cia4,
    String voo4,
    String origem4,
    String destino4,
    Timestamp saida4,
    Timestamp chegada4,
    String siglacompanhia4,
    String loc4,
    String eticket4,
    String cia41,
    String voo41,
    String origem41,
    String destino41,
    Timestamp saida41,
    Timestamp chegada41,
    String siglacompanhia41,
    String loc41,
    String eticket41,
  ) async {
    return await participantesColecao.doc(uid).update({
      'loc3': loc3,
      'loc4': loc4,
      'loc41': loc41,
    });
  }

  Future updateDadosVooOut2(
    String uid,
    String cia3,
    String voo3,
    String origem3,
    String destino3,
    Timestamp saida3,
    Timestamp chegada3,
    String siglacompanhia3,
    String loc3,
    String eticket3,
    String cia4,
    String voo4,
    String origem4,
    String destino4,
    Timestamp saida4,
    Timestamp chegada4,
    String siglacompanhia4,
    String loc4,
    String eticket4,
    String cia41,
    String voo41,
    String origem41,
    String destino41,
    Timestamp saida41,
    Timestamp chegada41,
    String siglacompanhia41,
    String loc41,
    String eticket41,
  ) async {
    return await participantesColecao.doc(uid).update({
      'cia3': cia3,
      'voo3': voo3,
      'origem3': origem3,
      'destino3': destino3,
      'saida3': saida3,
      'chegada3': chegada3,
      'siglaCompanhia3': siglacompanhia3,
      'eticket3': eticket3,
      'loc3': loc3,
      'cia4': cia4,
      'voo4': voo4,
      'origem4': origem4,
      'destino4': destino4,
      'saida4': saida4,
      'chegada4': chegada4,
      'siglaCompanhia4': siglacompanhia4,
      'eticket4': eticket4,
      'loc4': loc4,
      'cia41': cia41,
      'voo41': voo41,
      'origem41': origem41,
      'destino41': destino41,
      'saida41': saida41,
      'chegada41': chegada41,
      'siglaCompanhia41': siglacompanhia41,
      'eticket41': eticket41,
      'loc41': loc41,
    });
  }

  Future updateDadosPerfilPax(
    String uid,
    String nome,
    String telefone,
    String email,
    bool isPcp,
  ) async {
    return await participantesColecao.doc(uid).update({
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'pcp': isPcp,
    });
  }

  Future updateDadosHospedagem2(
    String uid,
    String hotelpernoite1,
    Timestamp checkInpernoite1,
    Timestamp checkOutpernoite1,
    String hotelpernoite2,
    Timestamp checkInpernoite2,
    Timestamp checkOutpernoite2,
    String hotel,
    String quarto,
    Timestamp checkIn,
    Timestamp checkOut,
    String hotelpernoitevolta,
    Timestamp checkInpernoitevolta,
    Timestamp checkOutpernoitevolta,
  ) async {
    return await participantesColecao.doc(uid).update({
      'hotelPernoiteIda1': hotelpernoite1,
      'checkInPernoite1': checkInpernoite1,
      'checkOutPernoite1': checkOutpernoite1,
      'hotel': hotelpernoite2,
      'checkIn': checkInpernoite2,
      'checkOut': checkOutpernoite2,
      'hotel2': hotel,
      'quarto': quarto,
      'checkIn2': checkIn,
      'checkOut2': checkOut,
      'hotelPernoiteVolta': hotelpernoitevolta,
      'checkInPernoiteVolta': checkInpernoitevolta,
      'checkOutPernoiteVolta': checkOutpernoitevolta,
    });
  }

  Future updateDadosHospedagem(
    String uid,
    String hotel,
    String quarto,
    Timestamp checkIn,
    Timestamp checkOut,
  ) async {
    return await participantesColecao.doc(uid).update({
      'hotel2': hotel,
      'quarto': quarto,
      'checkIn2': checkIn,
      'checkOut2': checkOut,
    });
  }

  Future updateDadosHospedagem1Hotel(
    String uid,
    String hotel,
    String quarto,
    Timestamp checkIn,
    Timestamp checkOut,
  ) async {
    return await participantesColecao.doc(uid).update({
      'hotel2': hotel,
      'quarto': quarto,
      'checkIn2': checkIn,
      'checkOut2': checkOut,
    });
  }

  Future updateDadosHospedagem2Hotel(
    String uid,
    String hotel,
    String quarto,
    Timestamp checkIn,
    Timestamp checkOut,
    String hotel2,
    String quarto2,
    Timestamp checkIn2,
    Timestamp checkOut2,
  ) async {
    return await participantesColecao.doc(uid).update({
      'hotel': hotel,
      'linkQr': quarto,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'hotel2': hotel2,
      'quarto': quarto2,
      'checkIn2': checkIn2,
      'checkOut2': checkOut2,
    });
  }

  Future updateParticipantesuidIn(String uid, String uidCarroIn) async {
    return await participantesColecao.doc(uid).update({
      'uidTransferIn': uidCarroIn,
    });
  }

  Future clearUidIn(
      String uid, String uidTransfer, bool isRebanho, bool isEmbarque) async {
    return await participantesColecao.doc(uid).update({
      'uidTransferIn': uidTransfer,
      'isRebanho': isRebanho,
      'isEmbarque': isEmbarque,
    });
  }

  Future clearUidOut(
      String uid, String uidTransferOuT, bool isEmbarqueOut) async {
    return await participantesColecao.doc(uid).update({
      'uidTransferOuT': uidTransferOuT,
      'isEmbarqueOut': isEmbarqueOut,
    });
  }

  Future updateParticipanteUidINRebanho(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao.doc(uidPax).update({
      'uidTransferIn': uidCarroIn,
      'isRebanho': true,
      "horaEMbarque": FieldValue.serverTimestamp(),
    });
  }

  Future updateParticipanteUidINRebanhofalse(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao.doc(uidPax).update({
      'uidTransferIn': uidCarroIn,
      'isRebanho': false,
    });
  }

  Future updateParticipanteUidINRebanhoCancelarEmbarque(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao.doc(uidPax).update(
        {'uidTransferIn': uidCarroIn, 'isRebanho': true, 'isEmbarque': false});
  }

  Future updateParticipanteUidINRemoverPaxVeiculo(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao.doc(uidPax).update(
        {'uidTransferIn': uidCarroIn, 'isRebanho': false, 'isEmbarque': false});
  }

  Future updateParticipanteUidOUTRemoverPaxVeiculo(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao.doc(uidPax).update({
      'uidTransferOuT': uidCarroIn,
      'isEmbarqueOut': false,
    });
  }

  Future updateParticipantesuidIn2(String uid, String uidCarroIn) async {
    return await participantesColecao.doc(uid).update({
      'uidTransferIn2': uidCarroIn,
    });
  }

  Future updateParticipantesuidTransferInternoIN(
      String uid, String uidCarroIn) async {
    return await participantesColecao.doc(uid).update({
      'uidTransferIn2': uidCarroIn,
    });
  }

  Future updateParticipantesuidTransferInternoOUT(
      String uid, String uidCarroIn) async {
    return await participantesColecao.doc(uid).update({
      'uidTransferOuT2': uidCarroIn,
    });
  }

  Future updateParticipantesTransferenciaOut2(
    String uid,
    String uidCarroOut,
  ) async {
    return await participantesColecao.doc(uid).update({
      'uidTransferOuT2': uidCarroOut,
      'isEmbarqueOut2': true,
      'horaEMbarqueOut2': FieldValue.serverTimestamp(),
    });
  }

  Future clearUidIn2(
      String uid, String uidTransfer, bool isRebanho, bool isEmbarque) async {
    return await participantesColecao.doc(uid).update({
      'uidTransferIn2': uidTransfer,
      'isEmbarque2': isEmbarque,
    });
  }

  Future clearUidOut2(
      String uid, String uidTransferOuT, bool isEmbarqueOut) async {
    return await participantesColecao.doc(uid).update({
      'uidTransferOuT2': uidTransferOuT,
      'isEmbarqueOut2': isEmbarqueOut,
    });
  }

  Future updateParticipanteUidINRebanho2(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao.doc(uidPax).update({
      'uidTransferIn2': uidCarroIn,
      'isEmbarque2': true,
    });
  }

  Future updateParticipanteUidINRebanhoItau(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao.doc(uidPax).update(
        {'uidTransferIn': uidCarroIn, 'isRebanho': true, 'isEmbarque': false});
  }

  Future updateParticipanteUidINRebanhoCancelarEmbarque2(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao
        .doc(uidPax)
        .update({'uidTransferIn': uidCarroIn, 'isEmbarque2': true});
  }

  Future updateParticipanteRemoverTransferInterno(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao
        .doc(uidPax)
        .update({'uidTransferIn': '', 'isEmbarque2': false});
  }

  Future updateParticipanteIncluitTransferInternoIda(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao.doc(uidPax).update({
      'uidTransferIn2': uidCarroIn,
      'isEmbarque2': true,
      'horaEMbarque2': FieldValue.serverTimestamp(),
    });
  }

  Future updateParticipanteIncluitTransferInternoVolta(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao.doc(uidPax).update({
      'uidTransferOuT2': uidCarroIn,
    });
  }

  Future updateParticipanteRemoverTransferInternoIda(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao
        .doc(uidPax)
        .update({'uidTransferIn2': '', 'isEmbarque2': false});
  }

  Future updateParticipanteRemoverTransferInternoVolta(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao
        .doc(uidPax)
        .update({'uidTransferOuT2': '', 'isEmbarqueOut2': false});
  }

  Future updateParticipanteUidINRemoverPaxVeiculo2(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao
        .doc(uidPax)
        .update({'uidTransferIn2': '', 'isEmbarque2': false});
  }

  Future updateParticipanteUidINRemoverPaxVeiculo3(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao
        .doc(uidPax)
        .update({'uidTransferOuT2': '', 'isEmbarqueOut2': false});
  }

  Future updateParticipanteUidOUTRemoverPaxVeiculo2(
      String uidPax, String uidCarroIn) async {
    return await participantesColecao.doc(uidPax).update({
      'uidTransferOuT2': uidCarroIn,
      'isEmbarqueOut2': false,
    });
  }

  Future updateResultadoCovid(String uid, bool resultado) async {
    return await participantesColecao.doc(uid).update({
      'isVar1': true,
      "isVar2": resultado,
    });
  }

  Future updateParticipantesuidOut(String uid, String uidCarroOut) async {
    return await participantesColecao.doc(uid).update({
      'uidTransferOuT': uidCarroOut,
    });
  }

  Future updateParticipantesTransferenciaOut(
    String uid,
    String uidCarroOut,
  ) async {
    return await participantesColecao.doc(uid).update({
      'uidTransferOuT': uidCarroOut,
      'isEmbarqueOut': true,
      'horaEMbarqueOut': FieldValue.serverTimestamp(),
    });
  }

  Future updateCheckOutOk(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isCheckOut': true,
      'horaCheckOut': FieldValue.serverTimestamp(),
    });
  }

  Future updateCheckOutCancelar(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isCheckOut': false,
      'horaCheckOut': FieldValue.serverTimestamp(),
    });
  }

  Future updateUberOk(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isVar4': true,
    });
  }

  Future updateUbercancelar(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isVar4': false,
    });
  }

  Future deletarParticipante(String uid) async {
    return await participantesColecao.doc(uid).delete();
  }

  Future updateParticipantesPCPOk(String uid) async {
    return await participantesColecao.doc(uid).update({
      'pcp': true,
    });
  }

  Future updateParticipantesPCPCancelar(String uid) async {
    return await participantesColecao.doc(uid).update({
      'pcp': false,
    });
  }

  Future updateParticipantesEntregaMaterial(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isEntregaMaterial': true,
      'horaCheckOut': FieldValue.serverTimestamp(),
      'isCredenciamento': false,
    });
  }

  Future updateParticipantesEntregaBrinde(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isVar2': true,
    });
  }

  Future updateParticipantesEntregaCancelarBrinde(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isVar2': false,
    });
  }

  Future updateParticipantesVacinacao(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isVar1': true,
    });
  }

  Future updateParticipantesCancelarVacinacao(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isVar1': false,
    });
  }

  Future updateParticipantesCancelarEntregaMaterial(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isEntregaMaterial': false,
    });
  }

  Future updateParticipantesCredenciamento(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isCredenciamento': true,
      'horaCredenciamento': FieldValue.serverTimestamp(),
      'isEntregaMaterial': false,
    });
  }

  Future updateParticipantesCredenciamentoEntregaMaterialok(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isCredenciamento': true,
      'horaCredenciamento': FieldValue.serverTimestamp(),
    });
  }

  Future updateParticipantesCancelarCredenciamento(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isCredenciamento': false,
      'horaCredenciamento': null,
    });
  }

  Future updateParticipantesCancelarCredenciamento2(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isCredenciamento': false,
      'horaCredenciamento': null,
    });
  }

  Future updateParticipantesCancelarCredenciamentoCancel(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isCredenciamento': false,
      'horaCredenciamento': null,
      'isEntregaMaterial': false,
    });
  }

  Future updateParticipantesCredenciamentoMaterialOk(String uid) async {
    return await participantesColecao.doc(uid).update({
      'isCredenciamento': true,
      'horaCredenciamento': FieldValue.serverTimestamp(),
      'isEntregaMaterial': true,
    });
  }

  List<Participantes> _listParticipanteSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var map = doc.data() as Map<String, dynamic>;
      map['uid'] ??= doc.id;
      return Participantes.fromMap(map);
    }).toList();
  }

  Stream<List<Participantes>> get participantes {
    return participantesColecao.snapshots().map(_listParticipanteSnapshot);
  }
}

class DatabaseServiceParticipante {
  final String? uid;

  DatabaseServiceParticipante({this.uid});

  final CollectionReference participantesColecao =
      FirebaseFirestore.instance.collection('participantes');

  Participantes _participanteDataFromSnapShot(DocumentSnapshot snapshot) {
    return Participantes(
      isFavorite: true,
      uid: uid ?? '',
      nome: snapshot.get('nome') ?? '',
      cpf: snapshot.get('cpf') ?? '',
      telefone: snapshot.get('telefone') ?? '',
      email: snapshot.get('email') ?? '',
      embarque: snapshot.get('embarque') ?? '',
      isCredenciamento: snapshot.get('isCredenciamento') ?? false,
      isEntregaMaterial: snapshot.get('isEntregaMaterial') ?? false,
      horaCredenciamento: snapshot.get('horaCredenciamento') ?? Timestamp.now(),
      pcp: snapshot.get('pcp') ?? false,
      noShow: snapshot.get('noShow') ?? Timestamp.now(),
      cancelado: snapshot.get('cancelado') ?? Timestamp.now(),
      hotel: snapshot.get('hotel') ?? '',
      checkIn: snapshot.get('checkIn') ?? Timestamp.now(),
      checkOut: snapshot.get('checkOut') ?? Timestamp.now(),
      hotel2: snapshot.get('hotel2') ?? '',
      checkIn2: snapshot.get('checkIn2') ?? Timestamp.now(),
      checkOut2: snapshot.get('checkOut2') ?? Timestamp.now(),
      cia1: snapshot.get('cia1') ?? '',
      voo1: snapshot.get('voo1') ?? '',
      origem1: snapshot.get('origem1') ?? '',
      destino1: snapshot.get('destino1') ?? '',
      saida1: snapshot.get('saida1') ?? Timestamp.now(),
      chegada1: snapshot.get('chegada1') ?? Timestamp.now(),
      siglaCompanhia1: snapshot.get('siglaCompanhia1') ?? '',
      eticket1: snapshot.get('eticket1') ?? '',
      loc1: snapshot.get('loc1') ?? '',
      cia2: snapshot.get('cia2') ?? '',
      voo2: snapshot.get('voo2') ?? '',
      origem2: snapshot.get('origem2') ?? '',
      destino2: snapshot.get('destino2') ?? '',
      saida2: snapshot.get('saida2') ?? Timestamp.now(),
      chegada2: snapshot.get('chegada2') ?? Timestamp.now(),
      siglaCompanhia2: snapshot.get('siglaCompanhia2') ?? '',
      eticket2: snapshot.get('eticket2') ?? '',
      loc2: snapshot.get('loc2') ?? '',
      cia21: snapshot.get('cia21') ?? '',
      voo21: snapshot.get('voo21') ?? '',
      origem21: snapshot.get('origem21') ?? '',
      destino21: snapshot.get('destino21') ?? '',
      saida21: snapshot.get('saida21') ?? Timestamp.now(),
      chegada21: snapshot.get('chegada21') ?? Timestamp.now(),
      siglaCompanhia21: snapshot.get('siglaCompanhia21') ?? '',
      eticket21: snapshot.get('eticket21') ?? '',
      loc21: snapshot.get('loc21') ?? '',
      cia3: snapshot.get('cia3') ?? '',
      voo3: snapshot.get('voo3') ?? '',
      origem3: snapshot.get('origem3') ?? '',
      destino3: snapshot.get('destino3') ?? '',
      saida3: snapshot.get('saida3') ?? Timestamp.now(),
      chegada3: snapshot.get('chegada3') ?? Timestamp.now(),
      siglaCompanhia3: snapshot.get('siglaCompanhia3') ?? '',
      eticket3: snapshot.get('eticket3') ?? '',
      loc3: snapshot.get('loc3') ?? '',
      cia4: snapshot.get('cia4') ?? '',
      voo4: snapshot.get('voo4') ?? '',
      origem4: snapshot.get('origem4') ?? '',
      destino4: snapshot.get('destino4') ?? '',
      saida4: snapshot.get('saida4') ?? Timestamp.now(),
      chegada4: snapshot.get('chegada4') ?? Timestamp.now(),
      siglaCompanhia4: snapshot.get('siglaCompanhia4') ?? '',
      eticket4: snapshot.get('eticket4') ?? '',
      loc4: snapshot.get('loc4') ?? '',
      cia41: snapshot.get('cia41') ?? '',
      voo41: snapshot.get('voo41') ?? '',
      origem41: snapshot.get('origem41') ?? '',
      destino41: snapshot.get('destino41') ?? '',
      saida41: snapshot.get('saida41') ?? Timestamp.now(),
      chegada41: snapshot.get('chegada41') ?? Timestamp.now(),
      siglaCompanhia41: snapshot.get('siglaCompanhia41') ?? '',
      eticket41: snapshot.get('eticket41') ?? '',
      loc41: snapshot.get('loc41') ?? '',
      uidTransferIn: snapshot.get('uidTransferIn') ?? '',
      uidTransferOuT: snapshot.get('uidTransferOuT') ?? '',
      quarto: snapshot.get('quarto') ?? '',
      isCheckOut: snapshot.get('isCheckOut') ?? false,
      horaCheckOut: snapshot.get('horaCheckOut') ?? Timestamp.now(),
      linkQr: snapshot.get('linkQr') ?? '',
      hasCredenciamento: snapshot.get('hasCredenciamento') ?? false,
      isRebanho: snapshot.get('isRebanho') ?? false,
      isEmbarque: snapshot.get('isEmbarque') ?? false,
      horaEMbarque: snapshot.get('horaEMbarque') ?? Timestamp.now(),
      isEmbarqueOut: snapshot.get('isEmbarqueOut') ?? false,
      horaEMbarqueOut: snapshot.get('horaEMbarqueOut') ?? Timestamp.now(),
      isEntregaBagagem: snapshot.get('isEntregaBagagem') ?? false,
      quantidadeBagagem: snapshot.get('quantidadeBagagem') ?? 0,
      isVar1: snapshot.get('isVar1') ?? false,
      isVar2: snapshot.get('isVar2') ?? false,
      isVar3: snapshot.get('isVar3') ?? false,
      isVar4: snapshot.get('isVar4') ?? false,
      uidTransferIn2: snapshot.get('uidTransferIn2') ?? '',
      uidTransferOuT2: snapshot.get('uidTransferOuT2') ?? '',
      isEmbarque2: snapshot.get('isEmbarque2') ?? false,
      horaEMbarque2: snapshot.get('horaEMbarque2') ?? Timestamp.now(),
      isEmbarqueOut2: snapshot.get('isEmbarqueOut2') ?? false,
      horaEMbarqueOut2: snapshot.get('horaEMbarqueOut2') ?? Timestamp.now(),
      hotelPernoiteIda1: snapshot.get('hotelPernoiteIda1') ?? '',
      checkInPernoite1: snapshot.get('checkInPernoite1') ?? Timestamp.now(),
      checkOutPernoite1: snapshot.get('checkOutPernoite1') ?? Timestamp.now(),
      hotelPernoiteVolta: snapshot.get('hotelPernoiteVolta') ?? '',
      checkInPernoiteVolta:
          snapshot.get('checkInPernoiteVolta') ?? Timestamp.now(),
      checkOutPernoiteVolta:
          snapshot.get('checkOutPernoiteVolta') ?? Timestamp.now(),
    );
  }

  Stream<Participantes> get participantesDados {
    return participantesColecao
        .doc(uid)
        .snapshots()
        .map(_participanteDataFromSnapShot);
  }

  Stream<Participantes> get participantesDados2 {
    return participantesColecao
        .doc(uid)
        .snapshots()
        .map(_participanteDataFromSnapShot);
  }

  Future inserirDadosTransferNoParticipante(
    String uidPax,
    String uidTransfer,
    String origem,
    String destino,
    Timestamp previsaoSaida,
    String veiculoNumeracao,
    String classificacaoVeiculo,
  ) async {
    return await participantesColecao
        .doc(uidPax)
        .collection('transfer')
        .doc(uidTransfer)
        .set({
      'uidPax': uidPax,
      'uidTransfer': uidTransfer,
      'origem': origem,
      'destino': destino,
      'previsaoSaida': previsaoSaida,
      'veiculoNumeracao': veiculoNumeracao,
      'classificacaoVeiculo': classificacaoVeiculo,
    });
  }

  Future noShowParticipante(String uidPax) async {
    return await participantesColecao.doc(uidPax).update({
      'noShow': true,
    });
  }

  Future desfazerNoShowParticipante(String uidPax) async {
    return await participantesColecao.doc(uidPax).update({
      'noShow': false,
    });
  }

  Future cancelarParticipante(String uidPax) async {
    return await participantesColecao.doc(uidPax).update({
      'cancelado': true,
    });
  }

  Future desfazerCancelarcanParticipante(String uidPax) async {
    return await participantesColecao.doc(uidPax).update({
      'cancelado': false,
    });
  }

  Future updateEmbarcarPax2(String uidPax, String uidCarroIn) async {
    return await participantesColecao.doc(uidPax).update({
      'uidTransferIn2': uidCarroIn,
      'isEmbarque2': true,
      'horaEMbarque2': FieldValue.serverTimestamp(),
    });
  }

  Future updateEmbarcarPax22(String uidPax) async {
    return await participantesColecao.doc(uidPax).update({
      'isEmbarque2': true,
      'horaEMbarque2': FieldValue.serverTimestamp(),
    });
  }

  Future updateParticipantesCancelarOUTEmbarque2(String uidPax) async {
    return await participantesColecao.doc(uidPax).update({
      'isEmbarqueOut2': false,
    });
  }

  Future updateParticipantesEmbarcarOUTOk2(
    String uidPax,
  ) async {
    return await participantesColecao.doc(uidPax).update({
      'isEmbarqueOut2': true,
      'horaEMbarqueOut2': FieldValue.serverTimestamp(),
    });
  }

  Future updateCancelarEmbarcarPax22(String uidPax) async {
    return await participantesColecao.doc(uidPax).update({
      'isEmbarque2': false,
      'horaEMbarque2': FieldValue.serverTimestamp(),
    });
  }

  Future updateParticipantesEmbarcarOk(String uidPax) async {
    return await participantesColecao.doc(uidPax).update({
      'isEmbarque': true,
      'horaEMbarque': FieldValue.serverTimestamp(),
    });
  }

  Future updateEmbarcarPax(String uidPax, String uidCarroIn) async {
    return await participantesColecao.doc(uidPax).update({
      'uidTransferIn': uidCarroIn,
      'isEmbarque': true,
      'horaEMbarque': FieldValue.serverTimestamp(),
    });
  }

  Future updateParticipantesEmbarcarOUTOk(
    String uidPax,
  ) async {
    return await participantesColecao.doc(uidPax).update({
      'isEmbarqueOut': true,
      'horaEMbarqueOut': FieldValue.serverTimestamp(),
    });
  }

  Future updateParticipantesCancelarEmbarque(String uidPax) async {
    return await participantesColecao.doc(uidPax).update({
      'isEmbarque': false,
    });
  }

  Future updateParticipantesCancelarOUTEmbarque(String uidPax) async {
    return await participantesColecao.doc(uidPax).update({
      'isEmbarqueOut': false,
    });
  }

  Future<void> updateRebanhoCloudOK(String uid) async {
    final rebanhoFunction = FirebaseFunctions.instance.httpsCallable(
        'updateRebanho',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 5)));

    try {
      await rebanhoFunction(uid);
      // print(result.data);
    } catch (e, s) {
      log('Erro ao enviar mensagem', error: e, stackTrace: s);
      throw Exception('Erro ao enviar a mensagem');
    }
  }

  Future updateParticipantesRebanhoOK(String uidPax) async {
    return await participantesColecao.doc(uidPax).update({
      'isRebanho': true,
    });
  }

  Future updateParticipantesCancelarRebanho(String uidPax) async {
    return await participantesColecao.doc(uidPax).update({
      'isRebanho': false,
    });
  }

  Future updateRemoverPaxVeiculoIn(String uidPax) async {
    return await participantesColecao.doc(uidPax).update({
      'isRebanho': false,
      'isEmbarque': false,
    });
  }

  Future updateRemoverPaxVeiculoOut(String uidPax) async {
    return await participantesColecao.doc(uidPax).update({
      'isEmbarqueOut': false,
    });
  }

  Future updateBagagem(String uidPax, int quantidadeBagagem) async {
    return await participantesColecao.doc(uidPax).update({
      'isEntregaBagagem': true,
      'quantidadeBagagem': quantidadeBagagem,
    });
  }

  Future removerDadosTransferNoParticipante(
    String uidPax,
    String uidTransfer,
  ) async {
    return await participantesColecao
        .doc(uidPax)
        .collection('transfer')
        .doc(uidTransfer)
        .delete();
  }
}

class DatabaseServiceTransferIn {
  final String? transferUid;
  final String? paxUid;

  DatabaseServiceTransferIn({this.transferUid, this.paxUid});

  ParticipantesTransfer _participanteTransferFromSnapShot(
      DocumentSnapshot snapshot) {
    var map = snapshot.data() as Map<String, dynamic>;
    map['uid'] ??= snapshot.id;
    return ParticipantesTransfer.fromMap(map);
  }

  List<ParticipantesTransfer> _listParticipantesTransferInSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var map = doc.data() as Map<String, dynamic>;
      map['uid'] ??= doc.id;
      return ParticipantesTransfer.fromMap(map);
    }).toList();
  }

  Stream<List<ParticipantesTransfer>> get participantesTransfer {
    return transferInColecao
        .doc(transferUid)
        .collection('participantesTransfer')
        .snapshots()
        .map(_listParticipantesTransferInSnapshot);
  }

  Stream<ParticipantesTransfer> get participantesTransferSnapShot {
    return transferInColecao
        .doc(transferUid)
        .collection('participantesTransfer')
        .doc(paxUid)
        .snapshots()
        .map(_participanteTransferFromSnapShot);
  }

  final CollectionReference transferInColecao =
      FirebaseFirestore.instance.collection('transferIn');

  Future inserirDadosTransferIn(
      String uid,
      String veiculoNumeracao,
      String status,
      String classificacaoVeiculo,
      int participantesEmbarcados,
      int totalParticipantes,
      Timestamp previsaoSaida,
      Timestamp previsaoChegada,
      Timestamp horaInicioViagem,
      Timestamp horaFimViagem,
      int previsaoChegadaGoogle,
      String origem,
      String destino,
      String origemConsultaMaps,
      String destinoConsultaMaps,
      String observacaoVeiculo,
      String placa,
      String motorista,
      double notaAvaliacao,
      bool checkInicioViagem,
      bool checkFimViagem,
      String avaliacaoVeiculo,
      bool isAvaliado,
      String telefoneMotorista,
      int numeroVeiculo,
      String userInicioViagem,
      String userFimViagem,
      double distancia) async {
    return await transferInColecao.doc(uid).set({
      'veiculoNumeracao': veiculoNumeracao,
      'status': status,
      'classificacaoVeiculo': classificacaoVeiculo,
      'participantesEmbarcados': participantesEmbarcados,
      'totalParticipantes': totalParticipantes,
      'previsaoSaida': previsaoSaida,
      'previsaoChegada': previsaoChegada,
      'horaInicioViagem': horaInicioViagem,
      'horaFimViagem': horaFimViagem,
      'previsaoChegadaGoogle': previsaoChegadaGoogle,
      'origem': origem,
      'destino': destino,
      'origemConsultaMap': origemConsultaMaps,
      'destinoConsultaMaps': destinoConsultaMaps,
      'observacaoVeiculo': observacaoVeiculo,
      'placa': placa,
      'motorista': motorista,
      'notaAvaliacao': notaAvaliacao,
      'checkInicioViagem': checkInicioViagem,
      'checkFimViagem': checkFimViagem,
      'avaliacaoVeiculo': avaliacaoVeiculo,
      'isAvaliado': isAvaliado,
      'telefoneMotorista': telefoneMotorista,
      'numeroVeiculo': numeroVeiculo,
      'userInicioViagem': userInicioViagem,
      'userFimViagem': userFimViagem,
      'distancia': distancia
    });
  }

  Future updatePLanilhaDadosTransferIn(
      String uid,
      String veiculoNumeracao,
      String status,
      String classificacaoVeiculo,
      int participantesEmbarcados,
      int totalParticipantes,
      Timestamp previsaoSaida,
      Timestamp previsaoChegada,
      Timestamp horaInicioViagem,
      Timestamp horaFimViagem,
      int previsaoChegadaGoogle,
      String origem,
      String destino,
      String origemConsultaMaps,
      String destinoConsultaMaps,
      String observacaoVeiculo,
      String placa,
      String motorista,
      double notaAvaliacao,
      bool checkInicioViagem,
      bool checkFimViagem,
      String avaliacaoVeiculo,
      bool isAvaliado,
      String telefoneMotorista,
      int numeroVeiculo,
      String userInicioViagem,
      String userFimViagem,
      double distancia) async {
    return await transferInColecao.doc(uid).update({
      'veiculoNumeracao': veiculoNumeracao,
      'status': status,
      'classificacaoVeiculo': classificacaoVeiculo,
      'participantesEmbarcados': participantesEmbarcados,
      'totalParticipantes': totalParticipantes,
      'previsaoSaida': previsaoSaida,
      'previsaoChegada': previsaoChegada,
      'horaInicioViagem': horaInicioViagem,
      'horaFimViagem': horaFimViagem,
      'previsaoChegadaGoogle': previsaoChegadaGoogle,
      'origem': origem,
      'destino': destino,
      'origemConsultaMap': origemConsultaMaps,
      'destinoConsultaMaps': destinoConsultaMaps,
      'observacaoVeiculo': observacaoVeiculo,
      'placa': placa,
      'motorista': motorista,
      'notaAvaliacao': notaAvaliacao,
      'checkInicioViagem': checkInicioViagem,
      'checkFimViagem': checkFimViagem,
      'avaliacaoVeiculo': avaliacaoVeiculo,
      'isAvaliado': isAvaliado,
      'telefoneMotorista': telefoneMotorista,
      'numeroVeiculo': numeroVeiculo,
      'userInicioViagem': userInicioViagem,
      'userFimViagem': userFimViagem,
      'distancia': distancia
    });
  }

  Future updateDadosTransferIn(
    String uid,
    String classVeiculo,
    String veiculoNumeracao,
    Timestamp previsaoSaida,
    Timestamp previsaoChegada,
    String origem,
    String origemConsultaMap,
    String destino,
    String destinoConsultaMaps,
    String classificacaoVeiculo,
    String motorista,
    String telefoneMotorista,
  ) async {
    return await transferInColecao.doc(uid).update({
      'classificacaoVeiculo': classVeiculo,
      'veiculoNumeracao': veiculoNumeracao,
      'previsaoSaida': previsaoSaida,
      'previsaoChegada': previsaoChegada,
      'origem': origem,
      'origemConsultaMap': origemConsultaMap,
      'destino': destino,
      'destinoConsultaMaps': destinoConsultaMaps,
      'motorista': motorista,
      'telefoneMotorista': telefoneMotorista,
    });
  }

  Future updateNotaTransferIn(
    String uid,
    double notaAvaliacao,
  ) async {
    return await transferInColecao.doc(uid).update({
      'notaAvaliacao': 0,
    });
  }

  Future criarTransferIn(
      String uid,
      String veiculoNumeracao,
      String status,
      String classificacaoVeiculo,
      int participantesEmbarcados,
      int totalParticipantes,
      Timestamp previsaoSaida,
      Timestamp previsaoChegada,
      Timestamp horaInicioViagem,
      Timestamp horaFimViagem,
      int previsaoChegadaGoogle,
      String origem,
      String destino,
      String origemConsultaMaps,
      String destinoConsultaMaps,
      String observacaoVeiculo,
      String placa,
      String motorista,
      double notaAvaliacao,
      bool checkInicioViagem,
      bool checkFimViagem,
      String avaliacaoVeiculo,
      bool isAvaliado,
      String telefoneMotorista,
      int numeroVeiculo,
      String userInicioViagem,
      String userFimViagem,
      double distancia) async {
    return await transferInColecao.doc(uid).set({
      'veiculoNumeracao': veiculoNumeracao,
      'status': 'Programado',
      'classificacaoVeiculo': classificacaoVeiculo,
      'participantesEmbarcados': participantesEmbarcados,
      'totalParticipantes': totalParticipantes,
      'previsaoSaida': previsaoSaida,
      'previsaoChegada': previsaoChegada,
      'horaInicioViagem': horaInicioViagem,
      'horaFimViagem': horaFimViagem,
      'previsaoChegadaGoogle': previsaoChegadaGoogle,
      'origem': origem,
      'destino': destino,
      'origemConsultaMap': origemConsultaMaps,
      'destinoConsultaMaps': destinoConsultaMaps,
      'observacaoVeiculo': observacaoVeiculo,
      'placa': placa,
      'motorista': motorista,
      'notaAvaliacao': notaAvaliacao,
      'checkInicioViagem': checkInicioViagem,
      'checkFimViagem': checkFimViagem,
      'avaliacaoVeiculo': avaliacaoVeiculo,
      'isAvaliado': isAvaliado,
      'telefoneMotorista': telefoneMotorista,
      'numeroVeiculo': numeroVeiculo,
      'userInicioViagem': userInicioViagem,
      'userFimViagem': userFimViagem,
      'distancia': distancia
    });
  }

  List<TransferIn> _listTransferInSnapshot(QuerySnapshot snapshot) {
    // print('TRANSFERIN: ${snapshot.docs.first.data().toString()}');
    return snapshot.docs.map((doc) {
      final map = doc.data() as Map<String, dynamic>;
      map['uid'] ??= doc.id;
      return TransferIn.fromMap(map);
    }).toList();
  }

  Stream<List<TransferIn>> get transferIn {
    return transferInColecao.snapshots().map(_listTransferInSnapshot);
  }

  TransferIn transferInSnapShot(DocumentSnapshot snapshot) {
    var map = snapshot.data() as Map<String, dynamic>;
    map['uid'] ??= snapshot.id;
    return TransferIn.fromMap(map);
  }

  Stream<TransferIn> get transferInSnapshot {
    return transferInColecao
        .doc(transferUid)
        .snapshots()
        .map(transferInSnapShot);
  }

  Future inserirDadosParticiantesNoCarro(
    String uidTranfer,
    String uid,
    String nome,
    String telefone,
    bool isRebanho,
    bool isNoShow,
    bool isCancelado,
    bool isEmbarque,
    Timestamp horaEMbarque,
    String cia1,
    String voo1,
    String sigla1,
    String cia2,
    String voo2,
    String sigla2,
    bool isEmbarqueOut,
    Timestamp horaEMbarqueOut,
  ) async {
    return await transferInColecao
        .doc(uidTranfer)
        .collection('participantesTransfer')
        .doc(uid)
        .set({
      'uid': uid,
      'nome': nome,
      'telefone': telefone,
      'isRebanho': isRebanho,
      'isNoShow': isNoShow,
      'isCancelado': isCancelado,
      'isEmbarque': isEmbarque,
      'horaEMbarque': FieldValue.serverTimestamp(),
      'cia1': cia1,
      'voo1': voo1,
      'sigla1': sigla1,
      'cia2': cia1,
      'voo2': voo2,
      'sigla2': sigla2,
      'isEmbarqueOut': isEmbarqueOut,
      'horaEMbarqueOut': FieldValue.serverTimestamp(),
    });
  }

  Future removerParticipantesCarro(String uidCarro, String uidPax) async {
    return await transferInColecao
        .doc(uidCarro)
        .collection('participantesTransfer')
        .doc(uidPax)
        .delete();
  }

  Future updatePrevisaoChegadaGoogle(String uid, int previsaoChegadaGoogle,
      double distancia, String horaAtualizacao) async {
    return await transferInColecao.doc(uid).update({
      'previsaoChegadaGoogle': previsaoChegadaGoogle,
      'distancia': distancia,
      'observacaoVeiculo': horaAtualizacao,
    });
  }

  Future updateIncrementoEmbarcadoCarro(String uid) async {
    return await transferInColecao.doc(uid).update({
      'participantesEmbarcados': FieldValue.increment(1),
    });
  }

  Future updateVeiculoTransferenciaOutSomar(String uid) async {
    return await transferInColecao.doc(uid).update({
      'totalParticipantes': FieldValue.increment(1),
      'participantesEmbarcados': FieldValue.increment(1),
    });
  }

  Future updateVeiculoTransferenciaOutDiminuir(String uid) async {
    return await transferInColecao.doc(uid).update({
      'totalParticipantes': FieldValue.increment(-1),
      'participantesEmbarcados': FieldValue.increment(-1),
    });
  }

  Future updateNumeroPax(String uid, int total, int embarcados) async {
    return await transferInColecao.doc(uid).update({
      'totalParticipantes': FieldValue.increment(total),
      'participantesEmbarcados': FieldValue.increment(embarcados),
    });
  }

  Future updateIncrementoTotalCarro(String uid) async {
    return await transferInColecao.doc(uid).update({
      'totalParticipantes': FieldValue.increment(1),
    });
  }

  Future updateAvaliacaoVeiculo(
      String uid, double nota, String avaliacaoVeiculo) async {
    return await transferInColecao.doc(uid).update({
      'notaAvaliacao': nota,
      'avaliacaoVeiculo': avaliacaoVeiculo,
      'isAvaliado': true,
    });
  }

  Future updateDetrimentoEmbarcadoCarro(String uid) async {
    return await transferInColecao.doc(uid).update({
      'participantesEmbarcados': FieldValue.increment(-1),
    });
  }

  Future updateDetrimentoTotalCarro(String uid) async {
    return await transferInColecao.doc(uid).update({
      'totalParticipantes': FieldValue.increment(-1),
    });
  }

  Future updateStatuCarroEmTransito(String uid, userName) async {
    return await transferInColecao.doc(uid).update({
      'status': 'Trânsito',
      'horaInicioViagem': FieldValue.serverTimestamp(),
      'checkInicioViagem': true,
      'userInicioViagem': userName,
    });
  }

  Future updateStatuCarroEmFinalizado(String uid, String userName) async {
    return await transferInColecao.doc(uid).update({
      'status': 'Finalizado',
      'horaFimViagem': FieldValue.serverTimestamp(),
      'checkFimViagem': true,
      'userFimViagem': userName,
    });
  }

  Future updateStatuCarroEmAvaliacao(String uid) async {
    return await transferInColecao.doc(uid).update({
      'status': 'Finalizado',
    });
  }

  Future updateStatusCancelado(String uid) async {
    return await transferInColecao.doc(uid).update({
      'status': 'Cancelado',
      'horaFimViagem': FieldValue.serverTimestamp(),
    });
  }

  Future updateZerarViagem(String uid) async {
    return await transferInColecao.doc(uid).update({
      'status': 'Programado',
      'checkFimViagem': false,
      'checkInicioViagem': false,
      'isAvaliado': false
    });
  }
}
