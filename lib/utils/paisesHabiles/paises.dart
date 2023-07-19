Map<String, dynamic> listaPaises = {
  'paises': [
    {'id': 1, 'nombre': 'Ecuador'},
    {'id': 2, 'nombre': 'Panamá'}
  ]..sort((a, b) => a["nombre"]
      .toString()
      .toLowerCase()
      .compareTo(b["nombre"].toString().toLowerCase()))
};

//todo--------------------------------------------------------------------------
//todo------------------------------ECUADOR-------------------------------------
//todo--------------------------------------------------------------------------
Map<String, dynamic> listaProvinciasEcuador = {
  'provincias': [
    {'id': 1, 'nombre': 'Azuay'},
    {'id': 2, 'nombre': 'Bolivar'},
    {'id': 3, 'nombre': 'Cañar'},
    {'id': 4, 'nombre': 'Carchi'},
    {'id': 5, 'nombre': 'Chimborazo'},
    {'id': 6, 'nombre': 'Cotopaxi'},
    {'id': 7, 'nombre': 'El Oro'},
    {'id': 8, 'nombre': 'Esmeraldas'},
    {'id': 9, 'nombre': 'Galápagos'},
    {'id': 10, 'nombre': 'Guayas'},
    {'id': 11, 'nombre': 'Imbabura'},
    {'id': 12, 'nombre': 'Loja'},
    {'id': 13, 'nombre': 'Los Ríos'},
    {'id': 14, 'nombre': 'Manabí'},
    {'id': 15, 'nombre': 'Morona Santiago'},
    {'id': 16, 'nombre': 'Napo'},
    {'id': 17, 'nombre': 'Sucumbíos'},
    {'id': 18, 'nombre': 'Pastaza'},
    {'id': 19, 'nombre': 'Pichincha'},
    {'id': 20, 'nombre': 'Santa Elena'},
    {'id': 21, 'nombre': 'Santo Domingo'},
    {'id': 22, 'nombre': 'Francisco de Orellana'},
    {'id': 23, 'nombre': 'Tungurahua'},
    {'id': 24, 'nombre': 'Zamora Chinchipe'},
  ]..sort((a, b) => a["nombre"]
      .toString()
      .toLowerCase()
      .compareTo(b["nombre"].toString().toLowerCase()))
};

List<String> listaCiudadesAzuay = [
  'Camilo Ponce Enríquez',
  'Pucará',
  'Santa Isabel',
  'Nabón',
  'Oña',
  'Girón',
  'San Fernando',
  'Cuenca',
  'Sígsig',
  'Chordeleg',
  'Gualaceo',
  'El Pan',
  'Paute',
  'Sevilla de Oro'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesBolivar = [
  'Caluma',
  'Chillanes',
  'Chimbo',
  'Echendia',
  'Guaranda',
  'Las Naves',
  'San Miguel'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesCanar = [
  'Azogues',
  'Biblián',
  'Cañar',
  'Déleg',
  'El Tambo',
  'La Troncal',
  'Suscal'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesCarchi = [
  'Tulcán',
  'El Ángel',
  'San Gabriel',
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesChimborazo = [
  'Alausí',
  'Chambo',
  'Chunchi',
  'Colta',
  'Cumandá',
  'Guamote',
  'Guano',
  'Pallatanga',
  'Penite',
  'Riobamba'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesCotopaxi = [
  'La Maná',
  'Latacunga',
  'Pangua',
  'Pujilí',
  'Salcedo',
  'Saquisilí',
  'Sichos'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesElOro = [
  'Arenillas',
  'Atahualpa',
  'Balsas',
  'Chilla',
  'El Guabo',
  'Huaquillas',
  'Las Lajas',
  'Machala',
  'Marcabelí',
  'Pasaje',
  'Piñas',
  'Portovelo',
  'Santa Rosa',
  'Zaruma',
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesEsmeraldas = [
  'Atacames',
  'Eloy Alfaro',
  'Esmeraldas',
  'Muisne',
  'Quinindé',
  'Rioverde',
  'San Lorenzo'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesGalapagos = ['Isabela', 'San Cristobal', 'Santa Cruz']
  ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesGuayas = [
  'Alfredo Baquerizo Moreno',
  'Balao',
  'Balzar',
  'Colimes',
  'Coronel Marcelino Maridueña',
  'Daule',
  'Durán',
  'El Empalme',
  'El Triunfo',
  'General Antonio Elizalde',
  'Guayaquil',
  'Isidro Ayora',
  'Lomas de Sargentillo',
  'Milagro',
  'Naranjal',
  'Naranjito',
  'Nobol',
  'Palestina',
  'Pedro Carbo',
  'Playas',
  'Salitre',
  'Samborondón',
  'Santa Lucía',
  'Simón Bolivar',
  'Yaguachi'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesImbabura = [
  'Antonio Ante',
  'Cotacachi',
  'Ibarra',
  'Otavalo',
  'Pimampiro',
  'Urcuquí',
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesLoja = [
  'Calvas',
  'Catamayo',
  'Celica',
  'Chaguarpamba',
  'Epíndola',
  'Gonzanamá',
  'Loja',
  'Macará',
  'Olmedo',
  'Paltas',
  'Puyango',
  'Quilanga',
  'Saraguro',
  'Sozaranga',
  'Zapotillo'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesLosRios = [
  'Baba',
  'Babahoyo',
  'Buena Fe',
  'Mocache',
  'Montalvo',
  'Palenque',
  'Puebloviejo',
  'Quevedo',
  'Quinsaloma',
  'Urdaneta',
  'Valencia',
  'Ventanas',
  'Vinces'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesManabi = [
  'Bolívar',
  'Chone',
  'El Carmen',
  'Flavio Alfaro',
  'Jama',
  'Jaramijó',
  'Jipijapa',
  'Junín',
  'Manta',
  'Montecristi',
  'Olmedo',
  'Paján',
  'Pedernales',
  'Pichincha',
  'Portoviejo',
  'Puerto López',
  'Rocafuerte',
  'San Vicente',
  'Santa Ana',
  'Sucre',
  'Tosagua',
  'Veinticuatro de Mayo'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesMoronaSant = [
  'Gualaquiza',
  'Huamboya',
  'Limón Indanza',
  'Logroño',
  'Morona',
  'Pablo Sexto',
  'Palora',
  'San Juan Bosco',
  'Santiago',
  'Sucúa',
  'Taisha',
  'Tiwintza',
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesNapo = [
  'Archidona',
  'Carlos Julio Arosemena Tola',
  'El Chaco',
  'Quijos',
  'Tena'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesSucumbios = [
  'Cascales',
  'Cuyabeno',
  'Gonzalo Pizarro',
  'Lago Agrio',
  'Putumayo',
  'Shushufindi',
  'Sucumbíos'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesPastaza = [
  'Arajuno',
  'Mera',
  'Puyo',
  'Santa Clara',
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesPichincha = [
  'Cayambe',
  'Machachi',
  'Quito',
  'Sangolqui',
  'Santo Domingo'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesSantaElena = [
  'Salinas',
  'Santa Elena',
  'La Libertad',
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesSantoDomin = [
  'La Concordia',
  'Santo Domingo',
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesFrancOrellana = [
  'Orellana',
  'Tiputini',
  'Loreto',
  'La Joya de los Sachas'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesTungurahua = [
  'Ambato',
  'Baños',
  'Cevallos',
  'Mocha',
  'Patate',
  'Pelileo',
  'Píllaro',
  'Quero',
  'Tisaleo'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaZamoraChinchipe = [
  'Zamora',
  'Paquisha',
  'El Pangui',
  'Yantzaza',
  'Zumba',
  'San Carlos de las Minas'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

//todo--------------------------------------------------------------------------
//todo------------------------------PANAMÁ--------------------------------------
//todo--------------------------------------------------------------------------
Map<String, dynamic> listaProvinciasPanama = {
  'provincias': [
    {'id': 1, 'nombre': 'Bocas del Toro'},
    {'id': 2, 'nombre': 'Coclé'},
    {'id': 3, 'nombre': 'Colón'},
    {'id': 4, 'nombre': 'Chiriqui'},
    {'id': 5, 'nombre': 'Darién'},
    {'id': 6, 'nombre': 'Herrera'},
    {'id': 7, 'nombre': 'Los Santos'},
    {'id': 8, 'nombre': 'Panamá'},
    {'id': 9, 'nombre': 'Veraguas'},
    {'id': 10, 'nombre': 'Panamá Oeste'}
  ]..sort((a, b) => a["nombre"]
      .toString()
      .toLowerCase()
      .compareTo(b["nombre"].toString().toLowerCase()))
};

List<String> listaCiudadesBocasDelToro = [
  'Almirante',
  'Bocas del Toro',
  'Changuinola',
  'Chriquí Grande'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesCocle = [
  'Agua Dulce',
  'Antón',
  'La Pintada',
  'Natá',
  'Olá',
  'Penonomé',
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesColon = [
  'Colón',
  'Chagres',
  'Donoso',
  'Portobelo',
  'Palenque',
  'Omar Torrijos Herrera'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesChiriqui = [
  'Alanje',
  'Barú',
  'Boquerón',
  'Boquete',
  'Bugaba',
  'David',
  'Dolega',
  'Gualaca',
  'Remedios',
  'Renacimiento',
  'San Félix',
  'San Lorenzo',
  'Tierras Altas',
  'Tolé'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesDarien = [
  'Chepigana',
  'Santa Fe',
  'Pinogana',
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesHerrera = [
  'Chitré',
  'Las Minas',
  'Los Pozos',
  'Ocú',
  'Parita',
  'Pesé',
  'Santa María'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesLosSantos = [
  'Guararé',
  'Las Tablas',
  'Los Santos',
  'Macaracas',
  'Pedasí',
  'Pocrí',
  'Tonosí',
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesPanama = [
  'Balboa',
  'Chepo',
  'Chimán',
  'Panamá',
  'San Miguelito',
  'Taboga',
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesVeraguas = [
  'Atalaya',
  'Calobre',
  'Cañazas',
  'La Mesa',
  'Las Palmas',
  'Mariato',
  'Montijo',
  'Río de Jesus',
  'San Francisco',
  'Santa Fe',
  'Santiago',
  'Soná'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

List<String> listaCiudadesPanamaOeste = [
  'Arraiján',
  'Capira',
  'Chame',
  'La Chorrera',
  'San Carlos'
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
