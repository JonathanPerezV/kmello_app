import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:abi_praxis/src/controller/dataBase/operations.dart';
import 'package:abi_praxis/src/models/calendarEvento/documentos_model.dart';
import 'package:abi_praxis/utils/flushbar.dart';
import 'package:abi_praxis/utils/loading.dart';
import 'package:abi_praxis/utils/selectFile/select_file.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../../../../../utils/responsive.dart';

class DocumentosEvento extends StatefulWidget {
  int idAgenda;
  DocumentosEvento({super.key, required this.idAgenda});

  @override
  State<DocumentosEvento> createState() => _DocumentosEventoState();
}

class _DocumentosEventoState extends State<DocumentosEvento> {
  bool loading = false;
  final op = Operations();
  List<DocsModel> documentos = [];
  final docs = SeleccionArchivos();
  late int estado;

  Future<void> obtenerDocumentos() async {
    setState(() => loading = true);
    setState(() => documentos.clear());
    final res = await op.obtenerDocumentosAgenda(widget.idAgenda);
    final res2 = await op.obtenerAgenda(widget.idAgenda);
    setState(() => estado = res2!.estado);
    if (res.isNotEmpty) {
      setState(() => documentos = res);
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    obtenerDocumentos();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: documentos.isEmpty
              ? const Center(
                  child: Text("No hay documentos agregados"),
                )
              : ListView.builder(
                  itemCount: documentos.length,
                  itemBuilder: (itemBuilder, index) {
                    return Container(
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                      height: 60,
                      width: double.infinity,
                      child: Card(
                          child: ListTile(
                        minVerticalPadding: 0,
                        contentPadding: const EdgeInsets.only(
                            left: 5, top: 0, bottom: 0, right: 0),
                        trailing: PopupMenuButton(
                            icon: const Icon(Icons.more_vert_rounded),
                            onSelected: (value) {
                              switch (value) {
                                case 1:
                                  viewPdf(documentos[index].nombreDoc,
                                      documentos[index].pathDoc);
                                  break;
                                case 2:
                                  deleteDoc(documentos[index].idDoc!);
                                default:
                              }
                            },
                            itemBuilder: (itemBuilder) {
                              final list = <PopupMenuEntry>[];
                              list.add(const PopupMenuItem(
                                  value: 1, child: Text("Ver")));
                              list.add(const PopupMenuItem(
                                  value: 2, child: Text("Eliminar")));
                              return list;
                            }),
                        leading:
                            const Icon(Icons.picture_as_pdf_outlined, size: 25),
                        title: Text(
                          documentos[index]
                              .nombreDoc
                              .replaceAll("-", " ")
                              .replaceAll("_", " "),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      )),
                    );
                  }),
        ),
        if (loading) loadingWidget(text: "Cargando..."),
        if (estado == 0)
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(right: 15, bottom: 25),
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                backgroundColor: Colors.black,
                onPressed: () => seleccionarArchivo(),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          )
      ],
    );
  }

  void viewPdf(String name, Uint8List file) async {
    final rsp = Responsive.of(context);
    showModalBottomSheet(
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: true,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (builder) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: rsp.hp(85),
              child: Column(
                children: [
                  Center(
                      child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17),
                  )),
                  const SizedBox(height: 10),
                  Expanded(
                      child: SfPdfViewer.memory(file,
                          canShowTextSelectionMenu: true,
                          canShowPageLoadingIndicator: true))
                ],
              ),
            ),
          );
        });
  }

  void deleteDoc(int id) async {
    setState(() => loading = true);
    final res = await op.eliminarDocumentoAgenda(id);
    if (res == 1) {
      await obtenerDocumentos();

      flushBarGlobal(context, "Documento eliminado",
          const Icon(Icons.check, color: Colors.green));
    } else {
      flushBarGlobal(context, "No se elimino el documento",
          const Icon(Icons.error, color: Colors.red));
    }
    setState(() => loading = false);
  }

  void seleccionarArchivo() async {
    final file = await docs.openFileExplorer(FileType.custom, context);

    if (file != null) {
      debugPrint("Archivo: $file");
      final bytes = await File(file).readAsBytes();
      final pdfName = File(file).uri.pathSegments.last;

      final doc = DocsModel(
          nombreDoc: pdfName, pathDoc: bytes, idAgenda: widget.idAgenda);

      final res = await op.insertarDocumentoAgenda(doc);

      if (res != 0) {
        await obtenerDocumentos();
        flushBarGlobal(context, "Documento agregado",
            const Icon(Icons.check, color: Colors.green));
      } else {
        flushBarGlobal(context, "No se agrego el documento",
            const Icon(Icons.error, color: Colors.red));
      }
    } else {
      flushBarGlobal(
          context, "Documento no seleccionado", const Icon(Icons.warning));
    }
  }
}
