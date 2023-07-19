import 'package:kmello_app/utils/paisesHabiles/paises.dart';

List<String> obtenerCiudadesEcuadorDe(String? nombre) {
  List<String> lista = [];
  switch (nombre) {
    case 'Azuay':
      lista = listaCiudadesAzuay;
      break;
    case 'Bolivar':
      lista = listaCiudadesBolivar;
      break;
    case 'Cañar':
      lista = listaCiudadesCanar;
      break;
    case 'Carchi':
      lista = listaCiudadesCarchi;
      break;
    case 'Chimborazo':
      lista = listaCiudadesChimborazo;
      break;
    case 'Cotopaxi':
      lista = listaCiudadesCotopaxi;
      break;
    case 'El Oro':
      lista = listaCiudadesElOro;
      break;
    case 'Esmeraldas':
      lista = listaCiudadesEsmeraldas;
      break;
    case 'Galápagos':
      lista = listaCiudadesGalapagos;
      break;
    case 'Guayas':
      lista = listaCiudadesGuayas;
      break;
    case 'Imbabura':
      lista = listaCiudadesImbabura;
      break;
    case 'Loja':
      lista = listaCiudadesLoja;
      break;
    case 'Los Ríos':
      lista = listaCiudadesLosRios;
      break;
    case 'Manabí':
      lista = listaCiudadesManabi;
      break;
    case 'Morona Santiago':
      lista = listaCiudadesMoronaSant;
      break;
    case 'Napo':
      lista = listaCiudadesNapo;
      break;
    case 'Sucumbíos':
      lista = listaCiudadesSucumbios;
      break;
    case 'Pastaza':
      lista = listaCiudadesPastaza;
      break;
    case 'Pichincha':
      lista = listaCiudadesPichincha;
      break;
    case 'Santa Elena':
      lista = listaCiudadesSantaElena;
      break;
    case 'Santo Domingo':
      lista = listaCiudadesSantoDomin;
      break;
    case 'Francisco de Orellana':
      lista = listaCiudadesFrancOrellana;
      break;
    case 'Tungurahua':
      lista = listaCiudadesTungurahua;
      break;
    case 'Zamora Chinchipe':
      lista = listaZamoraChinchipe;
      break;
    default:
  }
  return lista;
}

List<String> obtenerCiudadesPanama(String? nombre) {
  List<String> lista = [];
  switch (nombre) {
    case 'Bocas del Toro':
      lista = listaCiudadesBocasDelToro;
      break;
    case 'Coclé':
      lista = listaCiudadesCocle;
      break;
    case 'Colón':
      lista = listaCiudadesColon;
      break;
    case 'Chiriqui':
      lista = listaCiudadesChiriqui;
      break;
    case 'Darién':
      lista = listaCiudadesDarien;
      break;
    case 'Herrera':
      lista = listaCiudadesHerrera;
      break;
    case 'Los Santos':
      lista = listaCiudadesLosSantos;
      break;
    case 'Panamá':
      lista = listaCiudadesPanama;
      break;
    case 'Veraguas':
      lista = listaCiudadesVeraguas;
      break;
    case 'Panamá Oeste':
      lista = listaCiudadesPanamaOeste;
      break;
    default:
  }
  return lista;
}
