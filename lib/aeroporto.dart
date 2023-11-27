import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Aeroporto {
  String? nomeAeroportoSelecao;
  String? nomeAeroporto;
  String? codigo;

  Aeroporto({this.nomeAeroportoSelecao, this.codigo, this.nomeAeroporto});

  List<Aeroporto> main() {
    List<Aeroporto> aeroportos = [];
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: '',
        nomeAeroporto: '',
        codigo: ''));

    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO INTERNACIONAL DE DALLAS/FORT WORTH',
        nomeAeroporto: 'DALLAS-FORT WORTH',
        codigo: 'DFW'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO INTERNACIONAL DE CHARLOTTE/DOUGLAS',
        nomeAeroporto: 'CHARLOTTE',
        codigo: 'CLT'));

    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BUCARAMANGA',
        nomeAeroporto: 'BUCARAMANGA',
        codigo: 'BGA'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO JORGE NEWBERRY',
        nomeAeroporto: 'BUENOS AIRES',
        codigo: 'AEP'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO DE MIAMI',
        nomeAeroporto: 'MIAMI',
        codigo: 'MIA'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO INTERNACIONAL SANTIAGO',
        nomeAeroporto: 'SANTIAGO',
        codigo: 'SCL'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO INTERNACIONAL LAS AMERICAS',
        nomeAeroporto: 'SANTO DOMINGO',
        codigo: 'SDQ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO INTERNACIONAL PANAMA',
        nomeAeroporto: 'PANAMA',
        codigo: 'PTY'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO INTERNACIONAL ZURIQUE',
        nomeAeroporto: 'ZURIQUE',
        codigo: 'ZRH'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO INTERNACIONAL DE PUNTA CANA',
        nomeAeroporto: 'PUNTA CANA',
        codigo: 'PUJ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO O\'HARE CHICAGO',
        nomeAeroporto: 'CHICAGO',
        codigo: 'ORD'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO AMSTERDAM-SCHIPHOL',
        nomeAeroporto: 'AMSTERDAM',
        codigo: 'AMS'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO INTERNACIONAL DE LIMA',
        nomeAeroporto: 'LIMA',
        codigo: 'LIM'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO INTERNACIONAL DE BARRANQUILLA',
        nomeAeroporto: 'BARRANQUILLA',
        codigo: 'BAQ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO NEWARK',
        nomeAeroporto: 'NEWARK',
        codigo: 'EWR'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO MEDELLIN',
        nomeAeroporto: 'MEDELLIN',
        codigo: 'MED'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO INTERNACIONAL CIDADE DO MEXICO',
        nomeAeroporto: 'MEXICO',
        codigo: 'MEX'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO MARINGA',
        nomeAeroporto: 'MARINGA',
        codigo: 'MGF'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO INTERNACIONAL SILVIO PETTIROSSI',
        nomeAeroporto: 'PARAGUAI',
        codigo: 'ASU'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO GOIANIA',
        nomeAeroporto: 'GOIANIA',
        codigo: 'GYN'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO INTERNACIONAL EL DORADO',
        nomeAeroporto: 'PANAMA',
        codigo: 'PTY'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO INTERNACIONAL DO PANAMA',
        nomeAeroporto: 'BOGOTA',
        codigo: 'BOG'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO DE ATLANTA',
        nomeAeroporto: 'ATLANTA',
        codigo: 'ATL'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO RIO VERDE',
        nomeAeroporto: 'RIO VERDE',
        codigo: 'RVD'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CALDAS NOVAS',
        nomeAeroporto: 'CALDAS NOVAS',
        codigo: 'CLV'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CATALAO',
        nomeAeroporto: 'CATALAO',
        codigo: 'TLZ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BRASILIA',
        nomeAeroporto: 'BRASILIA',
        codigo: 'BSB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ALTA FLORESTA',
        nomeAeroporto: 'ALTA FLORESTA',
        codigo: 'AFL'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BARRA DOS GARCAS',
        nomeAeroporto: 'BARRA DOS GARCAS',
        codigo: 'BPG'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CASCAVEL',
        nomeAeroporto: 'CASCAVEL',
        codigo: 'CAC'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CACERES',
        nomeAeroporto: 'CACERES',
        codigo: 'CCX'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CUIABA',
        nomeAeroporto: 'CUIABA',
        codigo: 'CGB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO RONDONOPOLIS',
        nomeAeroporto: 'RONDONOPOLIS',
        codigo: 'ROO'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO TANGARA DA SERRA',
        nomeAeroporto: 'TANGARA DA SERRA',
        codigo: 'TGQ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SINOP',
        nomeAeroporto: 'SINOP',
        codigo: 'OPS'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SORRISO',
        nomeAeroporto: 'SORRISO',
        codigo: 'SMT'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BONITO',
        nomeAeroporto: 'BONITO',
        codigo: 'BYO'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CASSILANDIA',
        nomeAeroporto: 'CASSILANDIA',
        codigo: 'CSS'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CAMPO GRANDE',
        nomeAeroporto: 'CAMPO GRANDE',
        codigo: 'CGR'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CORUMBA',
        nomeAeroporto: 'CORUMBA',
        codigo: 'CMG'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO DOURADOS',
        nomeAeroporto: 'DOURADOS',
        codigo: 'DOU'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PARANAIBA',
        nomeAeroporto: 'PARANAIBA',
        codigo: 'PBB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PONTA PORA',
        nomeAeroporto: 'PONTA PORA',
        codigo: 'PMG'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO TRES LAGOAS',
        nomeAeroporto: 'TRES LAGOAS',
        codigo: 'TJL'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CRUZEIRO DO SUL',
        nomeAeroporto: 'CRUZEIRO DO SUL',
        codigo: 'CZS'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO RIO BRANCO',
        nomeAeroporto: 'RIO BRANCO',
        codigo: 'RBR'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO MACAPA',
        nomeAeroporto: 'MACAPA',
        codigo: 'MCP'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BARCELOS',
        nomeAeroporto: 'BARCELOS',
        codigo: 'BAZ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BOCA DO ACRE',
        nomeAeroporto: 'BOCA DO ACRE',
        codigo: 'BCR'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BORBA',
        nomeAeroporto: 'BORBA',
        codigo: 'RBB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CARAUARI',
        nomeAeroporto: 'CARAUARI',
        codigo: 'CAF'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO COARI',
        nomeAeroporto: 'COARI',
        codigo: 'CIZ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO EIRUNEPE',
        nomeAeroporto: 'EIRUNEPE',
        codigo: 'ERN'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO FONTE BOA',
        nomeAeroporto: 'FONTE BOA',
        codigo: 'FBA'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO HUMAITA',
        nomeAeroporto: 'HUMAITA',
        codigo: 'HUW'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ITACOATIARA',
        nomeAeroporto: 'ITACOATIARA',
        codigo: 'ITA'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO LABREA',
        nomeAeroporto: 'LABREA',
        codigo: 'LBR'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO MANAUS',
        nomeAeroporto: 'MANAUS',
        codigo: 'MAO'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO MANICORE',
        nomeAeroporto: 'MANICORE',
        codigo: 'MNX'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO MAUES',
        nomeAeroporto: 'MAUES',
        codigo: 'MBZ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO NOVO ARIPUANA',
        nomeAeroporto: 'NOVO ARIPUANA',
        codigo: 'NVP'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PARINTINS',
        nomeAeroporto: 'PARINTINS',
        codigo: 'PIN'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO IPATINGA',
        nomeAeroporto: 'IPATINGA',
        codigo: 'IPN'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SANTA ISABEL DO RIO NEGRO',
        nomeAeroporto: 'SANTA ISABEL DO RIO NEGRO',
        codigo: 'IRZ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SANTO ANTONIO DO ICA',
        nomeAeroporto: 'SANTO ANTONIO DO ICA',
        codigo: 'IPG'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SAO GABRIEL DA CACHOEIRA',
        nomeAeroporto: 'SAO GABRIEL DA CACHOEIRA',
        codigo: 'SJL'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SAO PAULO DE OLIVENCA',
        nomeAeroporto: 'SAO PAULO DE OLIVENCA',
        codigo: 'OLC'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO TABATINGA',
        nomeAeroporto: 'TABATINGA',
        codigo: 'TBT'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO TEFE',
        nomeAeroporto: 'TEFE',
        codigo: 'TFF'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ALTAMIRA',
        nomeAeroporto: 'ALTAMIRA',
        codigo: 'ATM'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BELEM',
        nomeAeroporto: 'BELEM',
        codigo: 'BEL'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CARAJAS',
        nomeAeroporto: 'CARAJAS',
        codigo: 'CKS'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ITAITUBA',
        nomeAeroporto: 'ITAITUBA',
        codigo: 'ITB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO MARABA',
        nomeAeroporto: 'MARABA',
        codigo: 'MAB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SANTAREM',
        nomeAeroporto: 'SANTAREM',
        codigo: 'STM'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PORTO VELHO',
        nomeAeroporto: 'PORTO VELHO',
        codigo: 'PVH'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO JI PARANA',
        nomeAeroporto: 'JI PARANA',
        codigo: 'JPR'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CACOAL',
        nomeAeroporto: 'CACOAL',
        codigo: 'OAL'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO VILHENA',
        nomeAeroporto: 'VILHENA',
        codigo: 'BVH'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BOA VISTA',
        nomeAeroporto: 'BOA VISTA',
        codigo: 'BVB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ARAGUAINA',
        nomeAeroporto: 'ARAGUAINA',
        codigo: 'AUX'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ARRAIAS',
        nomeAeroporto: 'ARRAIAS',
        codigo: 'AAI'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO DIANOPOLIS',
        nomeAeroporto: 'DIANOPOLIS',
        codigo: 'DNO'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO GURUPI',
        nomeAeroporto: 'GURUPI',
        codigo: 'GRP'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO MIRACEMA DO TOCANTINS',
        nomeAeroporto: 'MIRACEMA DO TOCANTINS',
        codigo: 'NTM'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PALMAS',
        nomeAeroporto: 'PALMAS',
        codigo: 'PMW'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PORTO NACIONAL',
        nomeAeroporto: 'PORTO NACIONAL',
        codigo: 'PNB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO TAQUATINGA',
        nomeAeroporto: 'TAQUATINGA',
        codigo: 'QHN'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ARAPIRACA',
        nomeAeroporto: 'ARAPIRACA',
        codigo: 'APQ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO MACEIO',
        nomeAeroporto: 'MACEIO',
        codigo: 'MCZ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BARRA',
        nomeAeroporto: 'BARRA',
        codigo: 'BQQ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BARREIRAS',
        nomeAeroporto: 'BARREIRAS',
        codigo: 'BRA'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BELMONTE',
        nomeAeroporto: 'BELMONTE',
        codigo: 'BVM'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BOM JESUS DA LAPA',
        nomeAeroporto: 'BOM JESUS DA LAPA',
        codigo: 'LAZ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BRUMADO',
        nomeAeroporto: 'BRUMADO',
        codigo: 'BMS'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CANAVIEIRAS',
        nomeAeroporto: 'CANAVIEIRAS',
        codigo: 'CNV'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CARAVELAS',
        nomeAeroporto: 'CARAVELAS',
        codigo: 'CRQ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO FEIRA DE SANTANA',
        nomeAeroporto: 'FEIRA DE SANTANA',
        codigo: 'FEC'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO GUANAMBI',
        nomeAeroporto: 'GUANAMBI',
        codigo: 'GNM'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ILHEUS',
        nomeAeroporto: 'ILHEUS',
        codigo: 'IOS'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO IPIAU',
        nomeAeroporto: 'IPIAU',
        codigo: 'IPU'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO IRECE',
        nomeAeroporto: 'IRECE',
        codigo: 'IRE'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ITABUNA',
        nomeAeroporto: 'ITABUNA',
        codigo: 'ITN'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ITUBERA',
        nomeAeroporto: 'ITUBERA',
        codigo: 'ITE'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO JACOBINA',
        nomeAeroporto: 'JACOBINA',
        codigo: 'JCM'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO JEQUIE',
        nomeAeroporto: 'JEQUIE',
        codigo: 'JEQ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO LENCOIS',
        nomeAeroporto: 'LENCOIS',
        codigo: 'LEC'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO MUCURI',
        nomeAeroporto: 'MUCURI',
        codigo: 'MVS'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PAULO AFONSO',
        nomeAeroporto: 'PAULO AFONSO',
        codigo: 'PAV'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PRADO',
        nomeAeroporto: 'PRADO',
        codigo: 'PDF'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PORTO SEGURO',
        nomeAeroporto: 'PORTO SEGURO',
        codigo: 'BPS'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SALVADOR',
        nomeAeroporto: 'SALVADOR',
        codigo: 'SSA'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO TEIXEIRA DE FREITAS',
        nomeAeroporto: 'TEIXEIRA DE FREITAS',
        codigo: 'TXF'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO COMANDATUBA',
        nomeAeroporto: 'COMANDATUBA',
        codigo: 'UNA'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO VALENCA',
        nomeAeroporto: 'VALENCA',
        codigo: 'VAL'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO VITORIA DA CONQUISTA',
        nomeAeroporto: 'VITORIA DA CONQUISTA',
        codigo: 'VDC'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ARACATI',
        nomeAeroporto: 'ARACATI',
        codigo: 'ARX'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CAMOCIM',
        nomeAeroporto: 'CAMOCIM',
        codigo: 'CMC'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO FORTALEZA',
        nomeAeroporto: 'FORTALEZA',
        codigo: 'FOR'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO INTERNACIONAL DE BUENOS AIRES',
        nomeAeroporto: 'BUENOS AIRES',
        codigo: 'EZE'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO JERICOACOARA',
        nomeAeroporto: 'JERICOACOARA',
        codigo: 'JJD'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO JUAZEIRO DO NORTE',
        nomeAeroporto: 'JUAZEIRO DO NORTE',
        codigo: 'JDO'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BALSAS',
        nomeAeroporto: 'BALSAS',
        codigo: 'BSS'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BARREIRINHAS',
        nomeAeroporto: 'BARREIRINHAS',
        codigo: 'BRB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO IMPERATRIZ',
        nomeAeroporto: 'IMPERATRIZ',
        codigo: 'IMP'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PINHEIRO',
        nomeAeroporto: 'PINHEIRO',
        codigo: 'PHI'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SAO LUIS',
        nomeAeroporto: 'SAO LUIS',
        codigo: 'SLZ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO UBERLANDIA',
        nomeAeroporto: 'UBERLANDIA',
        codigo: 'UDI'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CAMPINA GRANDE',
        nomeAeroporto: 'CAMPINA GRANDE',
        codigo: 'CPV'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO JOAO PESSOA',
        nomeAeroporto: 'JOAO PESSOA',
        codigo: 'JPA'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CARUARU',
        nomeAeroporto: 'CARUARU',
        codigo: 'CAU'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO FERNANDO DE NORONHA',
        nomeAeroporto: 'FERNANDO DE NORONHA',
        codigo: 'FEN'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PETROLINA',
        nomeAeroporto: 'PETROLINA',
        codigo: 'PNZ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO RECIFE',
        nomeAeroporto: 'RECIFE',
        codigo: 'REC'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SERRA TALHADA',
        nomeAeroporto: 'SERRA TALHADA',
        codigo: 'SET'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO FLORIANO',
        nomeAeroporto: 'FLORIANO',
        codigo: 'FLB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO GUADALUPE',
        nomeAeroporto: 'GUADALUPE',
        codigo: 'GDP'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PARNAIBA',
        nomeAeroporto: 'PARNAIBA',
        codigo: 'PHB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PICOS',
        nomeAeroporto: 'PICOS',
        codigo: 'PCS'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO TERESINA',
        nomeAeroporto: 'TERESINA',
        codigo: 'THE'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO MOSSORO',
        nomeAeroporto: 'MOSSORO',
        codigo: 'MVF'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO NAVEGANTES',
        nomeAeroporto: 'NAVEGANTES',
        codigo: 'NVT'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO NATAL',
        nomeAeroporto: 'NATAL',
        codigo: 'NAT'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ARACAJU',
        nomeAeroporto: 'ARACAJU',
        codigo: 'AJU'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO VITORIA',
        nomeAeroporto: 'VITORIA',
        codigo: 'VIX'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CACHOEIRO DE ITAPEMIRIM',
        nomeAeroporto: 'CACHOEIRO DE ITAPEMIRIM',
        codigo: 'CDI'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO GUARAPARI',
        nomeAeroporto: 'GUARAPARI',
        codigo: 'GUZ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SAO MATEUS',
        nomeAeroporto: 'SAO MATEUS',
        codigo: 'SBJ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BARBACENA',
        nomeAeroporto: 'BARBACENA',
        codigo: 'QAK'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PATOS DE MINAS',
        nomeAeroporto: 'PATOS DE MINAS',
        codigo: 'POJ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CONFINS',
        nomeAeroporto: 'CONFINS',
        codigo: 'CNF'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO DIVINOPOLIS',
        nomeAeroporto: 'DIVINOPOLIS',
        codigo: 'DIQ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO GOVERNADOR VALADARES',
        nomeAeroporto: 'GOVERNADOR VALADARES',
        codigo: 'GVR'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO JUIZ DE FORA',
        nomeAeroporto: 'JUIZ DE FORA',
        codigo: 'JDF'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO MONTES CLAROS',
        nomeAeroporto: 'MONTES CLAROS',
        codigo: 'MOC'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO INTERNACIONAL ALFONSO BONILLA ARAGON',
        nomeAeroporto: 'CALI',
        codigo: 'CLO'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PAMPULHA',
        nomeAeroporto: 'PAMPULHA',
        codigo: 'PLU'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PLANALTO SERRANO',
        nomeAeroporto: 'PLANALTO SERRANO',
        codigo: 'EEA'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO POCOS DE CALDAS',
        nomeAeroporto: 'POCOS DE CALDAS',
        codigo: 'POO'));
    aeroportos.add(Aeroporto(

        nomeAeroportoSelecao: 'AEROPORTO SAO JOAO DEL-REI',
        nomeAeroporto: 'SAO JOAO DEL-REI',
        codigo: 'JDR'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO UBERLANDIA',
        nomeAeroporto: 'UBERLANDIA',
        codigo: 'UDI'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO UBERABA',
        nomeAeroporto: 'UBERABA',
        codigo: 'UBA'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ZONA DA MATA',
        nomeAeroporto: 'ZONA DA MATA',
        codigo: 'IZA'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BARTOLOMEU DE GUSMAO',
        nomeAeroporto: 'BARTOLOMEU DE GUSMAO',
        codigo: 'SNZ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CAMPOS DOS GOYTACAZES',
        nomeAeroporto: 'CAMPOS DOS GOYTACAZES',
        codigo: 'CAW'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CABO FRIO',
        nomeAeroporto: 'CABO FRIO',
        codigo: 'CFB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO GALEAO',
        nomeAeroporto: 'GALEAO',
        codigo: 'GIG'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ITAPERUNA',
        nomeAeroporto: 'ITAPERUNA',
        codigo: 'ITP'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO MACAE',
        nomeAeroporto: 'MACAE',
        codigo: 'MEA'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO RESENDE',
        nomeAeroporto: 'RESENDE',
        codigo: 'QRZ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SANTOS DUMONT',
        nomeAeroporto: 'SANTOS DUMONT',
        codigo: 'SDU'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ARACATUBA',
        nomeAeroporto: 'ARACATUBA',
        codigo: 'ARU'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ARARAQUARA',
        nomeAeroporto: 'ARARAQUARA',
        codigo: 'AQA'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO ASSIS',
        nomeAeroporto: 'ASSIS',
        codigo: 'AIF'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO AVARE/ARANDU',
        nomeAeroporto: 'AVARE/ARANDU',
        codigo: 'QVP'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BARRETOS',
        nomeAeroporto: 'BARRETOS',
        codigo: 'BAT'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BAURU/AREALVA',
        nomeAeroporto: 'BAURU/AREALVA',
        codigo: 'JTC'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BOTUCATU',
        nomeAeroporto: 'BOTUCATU',
        codigo: 'QCP'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BRAGANCA PAULISTA',
        nomeAeroporto: 'BRAGANCA PAULISTA',
        codigo: 'BJP'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CAMPO DOS AMARAIS',
        nomeAeroporto: 'CAMPO DOS AMARAIS',
        codigo: 'CPQ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CONGONHAS',
        nomeAeroporto: 'CONGONHAS',
        codigo: 'CGH'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO DRACENA',
        nomeAeroporto: 'DRACENA',
        codigo: 'QDC'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO GUARATINGUETA',
        nomeAeroporto: 'GUARATINGUETA',
        codigo: 'GUJ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO GUARULHOS',
        nomeAeroporto: 'GUARULHOS',
        codigo: 'GRU'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO FRANCA',
        nomeAeroporto: 'FRANCA',
        codigo: 'FRC'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO JUNDIAI',
        nomeAeroporto: 'JUNDIAI',
        codigo: 'QDV'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO LENCOIS PAULISTA',
        nomeAeroporto: 'LENCOIS PAULISTA',
        codigo: 'QGC'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO LINS',
        nomeAeroporto: 'LINS',
        codigo: 'LIP'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO MARILIA',
        nomeAeroporto: 'MARILIA',
        codigo: 'MII'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO OURINHOS',
        nomeAeroporto: 'OURINHOS',
        codigo: 'OUS'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PIRACICABA',
        nomeAeroporto: 'PIRACICABA',
        codigo: 'QHB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PRESIDENTE PRUDENTE',
        nomeAeroporto: 'PRESIDENTE PRUDENTE',
        codigo: 'PPB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO RIBEIRAO PRETO',
        nomeAeroporto: 'RIBEIRAO PRETO',
        codigo: 'RAO'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SAO CARLOS',
        nomeAeroporto: 'SAO CARLOS',
        codigo: 'QSC'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SAO JOSE DO RIO PRETO',
        nomeAeroporto: 'SAO JOSE DO RIO PRETO',
        codigo: 'SJP'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SAO JOSE DOS CAMPOS',
        nomeAeroporto: 'SAO JOSE DOS CAMPOS',
        codigo: 'SJK'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SOROCABA',
        nomeAeroporto: 'SOROCABA',
        codigo: 'SOD'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO UBATUBA',
        nomeAeroporto: 'UBATUBA',
        codigo: 'UBT'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO VIRACOPOS',
        nomeAeroporto: 'CAMPINAS',
        codigo: 'VCP'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO VOTUPORANGA',
        nomeAeroporto: 'VOTUPORANGA',
        codigo: 'VOT'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CASCAVEL',
        nomeAeroporto: 'CASCAVEL',
        codigo: 'CAC'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CURITIBA',
        nomeAeroporto: 'CURITIBA',
        codigo: 'CWB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO FOZ DO IGUACU',
        nomeAeroporto: 'FOZ DO IGUACU',
        codigo: 'IGU'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO LONDRINA',
        nomeAeroporto: 'LONDRINA',
        codigo: 'LDB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO MARINGA',
        nomeAeroporto: 'MARINGA',
        codigo: 'MGF'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PONTA GROSSA',
        nomeAeroporto: 'PONTA GROSSA',
        codigo: 'PGZ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO UMUARAMA',
        nomeAeroporto: 'UMUARAMA',
        codigo: 'UMU'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PATO BRANCO',
        nomeAeroporto: 'PATO BRANCO',
        codigo: 'PTO'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BAGE',
        nomeAeroporto: 'BAGE',
        codigo: 'BGX'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PONTA GROSSA',
        nomeAeroporto: 'PONTA GROSSA',
        codigo: 'PGZ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CAXIAS DO SUL',
        nomeAeroporto: 'CAXIAS DO SUL',
        codigo: 'CXJ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PASSO FUNDO',
        nomeAeroporto: 'PASSO FUNDO',
        codigo: 'PFB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PORTO ALEGRE',
        nomeAeroporto: 'PORTO ALEGRE',
        codigo: 'POA'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SANTA MARIA',
        nomeAeroporto: 'SANTA MARIA',
        codigo: 'RIA'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO URUGUAIANA',
        nomeAeroporto: 'URUGUAIANA',
        codigo: 'URG'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO BLUMENAU',
        nomeAeroporto: 'BLUMENAU',
        codigo: 'BNU'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO CHAPECO',
        nomeAeroporto: 'CHAPECO',
        codigo: 'XAP'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO FORQUILHINHA',
        nomeAeroporto: 'FORQUILHINHA',
        codigo: 'CCM'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO FLORIANOPOLIS',
        nomeAeroporto: 'FLORIANOPOLIS',
        codigo: 'FLN'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO JAGUARUNA',
        nomeAeroporto: 'JAGUARUNA',
        codigo: 'JJG'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO JOACABA',
        nomeAeroporto: 'JOACABA',
        codigo: 'JCB'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO JOINVILLE',
        nomeAeroporto: 'JOINVILLE',
        codigo: 'JOI'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO LAGES',
        nomeAeroporto: 'LAGES',
        codigo: 'LAJ'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO NAVEGANTES',
        nomeAeroporto: 'NAVEGANTES',
        codigo: 'NVT'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO SANTO ANGELO',
        nomeAeroporto: 'SANTO ANGELO',
        codigo: 'GEL'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PALMAS',
        nomeAeroporto: 'PALMAS',
        codigo: 'PWM'));
    aeroportos.add(Aeroporto(
        nomeAeroportoSelecao: 'AEROPORTO PELOTAS',
        nomeAeroporto: 'PELOTAS',
        codigo: 'PET'));
    return aeroportos;
  }

  List<String?> getAeroporto(Aeroporto value) {
    List<String?> selecaoAeroporto =[];
    selecaoAeroporto= [value.nomeAeroportoSelecao, value.nomeAeroporto,value.codigo];
    // print(selecaoAeroporto);
    return selecaoAeroporto;
  }

  Widget listAeroportoOrigem() {
    List<Aeroporto> lista;
    lista = main();
    Aeroporto selectedAeroporto = Aeroporto();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<Aeroporto>(
        itemHeight: 50,
        isExpanded: true,
        decoration: const InputDecoration(
//                        border: OutlineInputBorder(),
          labelText: 'Origem',
        ),
        hint: Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
          child: Text(
            'Selecionar origem',
            style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500),
          ),
        ),
        value: selectedAeroporto,
        isDense: false,
        onSaved: (newValue) {},
        onChanged: (newValue) {

          getAeroporto(newValue ?? Aeroporto());
        },
        items: lista.map((Aeroporto values) {
          return DropdownMenuItem<Aeroporto>(
            value: values,
            child: Text(
              values.nomeAeroporto ?? Aeroporto(nomeAeroporto: '').nomeAeroporto!,
              style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400),
            ),
          );
        }).toList(),

      ),
    );
  }
}
