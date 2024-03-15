import 'dart:io';

import 'package:core/ConstantUrl.dart';
import 'package:core/common_folder/constantes/enums.dart';
import 'package:core/librairies/register_mobile_alternative_for_web_only_package.dart'
    if (dart.library.html) 'package:core/librairies/register_web_only_package.dart' as WebOnlyPackages;
import 'package:core/objet/Commande.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class GenerateFactureFile {
  GenerateFactureFile();
  Future<Uint8List> createPdf({required Commande commande, required FormatImpressionFacture format}) async {
    // Page
    String urlImage = commande.entreprise != null
        ? "https://${ConstantUrl.urlServer}${ConstantUrl.base}${commande.entreprise!.img_logo_link}"
        : "";
    final netImage = await networkImage(urlImage).timeout(Duration(seconds: 5));
    pw.TextStyle titleStyle =
        pw.TextStyle(fontSize: format == FormatImpressionFacture.FACTURE ? 10 : 6, lineSpacing: 1.5);
    pw.TextStyle contentStyle =
        pw.TextStyle(fontSize: format == FormatImpressionFacture.FACTURE ? 8 : 6, lineSpacing: 1.5);

    final pdf = pw.Document(title: "Facture d'achat N° ${commande.code}", author: "Buz'Up");
    pdf.addPage(pw.MultiPage(
        pageFormat:
            format == FormatImpressionFacture.FACTURE ? PdfPageFormat.a4 : PdfPageFormat(250, 500, marginAll: 16),
        build: (context) => [
              pw.Row(children: [
                if (commande.entreprise != null)
                  pw.Expanded(
                    flex: 3,
                    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      if (netImage != null) pw.Image(netImage, width: 48, height: 48),
                      pw.Text("${commande.entreprise!.nom}",
                          style: titleStyle.copyWith(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      if (commande.entreprise!.ifu!.isNotEmpty)
                        pw.Text("IFU. : ${commande.entreprise!.ifu} ", style: contentStyle),
                      if (commande.entreprise!.rccm!.isNotEmpty)
                        pw.Text("Tel. : ${commande.entreprise!.rccm} ", style: contentStyle),
                      if (commande.entreprise!.adresse!.isNotEmpty)
                        pw.Text(
                            "Adresse : ${commande.entreprise!.adresse} ${commande.entreprise!.ville} ${commande.entreprise!.pays}",
                            style: contentStyle),
                      if (commande.entreprise!.mail!.isNotEmpty)
                        pw.Text("E-mail : ${commande.entreprise!.mail}", style: contentStyle),
                      if (commande.entreprise!.site_web!.isNotEmpty)
                        pw.Text("Site Web : ${commande.entreprise!.site_web} ", style: contentStyle),
                    ]),
                  ),
                pw.Expanded(
                    flex: 2,
                    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.SizedBox(height: 24),
                      pw.Text("${commande.code}", style: titleStyle.copyWith(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 12),
                      pw.Text("Client ", style: titleStyle),
                      pw.Text("${commande.client!.nom}".trim(), style: contentStyle),
                      pw.Text("${commande.client!.telephone}", style: contentStyle)
                    ]))
              ]),
              pw.SizedBox(height: 48),
              pw.Column(children: []),
              pw.TableHelper.fromTextArray(
                border: null,
                headerAlignment: pw.Alignment.centerLeft,
                headerStyle: titleStyle,
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey200),
                headers: ["Nom", "PU", "Qte", "Total", "Taxe"],
                data: commande.achatList!
                    .map((e) => [
                          if (e.produit != null)
                            pw.Text(e.produit!.nom != null ? e.produit!.nom! : "", style: contentStyle),
                          if (e.service != null)
                            pw.Text(e.service!.nom != null ? e.service!.nom! : "", style: contentStyle),
                          if (e.produit != null)
                            pw.Text(e.produit!.prix != null ? e.produit!.prix! : "", style: contentStyle),
                          if (e.service != null)
                            pw.Text(e.service!.cout != null ? e.service!.cout! : "", style: contentStyle),
                          pw.Text(e.qte_total!, style: contentStyle),
                          pw.Text(e.prix_total!, style: contentStyle),
                          if (e.produit != null)
                            pw.Text(e.produit!.code_taxe != null ? e.produit!.code_taxe! : "",
                                style: pw.TextStyle(fontSize: 8)),
                          if (e.service != null)
                            pw.Text(e.service!.code_taxe != null ? e.service!.code_taxe! : "",
                                style: pw.TextStyle(fontSize: 8)),
                        ])
                    .toList(),
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerRight,
                  2: pw.Alignment.centerRight,
                  3: pw.Alignment.centerRight,
                  4: pw.Alignment.centerRight,
                },
                cellStyle: pw.TextStyle(fontSize: 8),
              ),
              pw.Divider(height: 10, thickness: 1),
              pw.Row(children: [
                if (format == FormatImpressionFacture.FACTURE) pw.Spacer(flex: 1),
                pw.Expanded(
                    flex: 1,
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Container(
                          padding: pw.EdgeInsets.all(16),
                          child: pw.BarcodeWidget(
                              data: "${commande.code}",
                              barcode: pw.Barcode.qrCode(),
                              width: 48,
                              height: 48,
                              drawText: false),
                        ),
                        pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              TotalBlocItemWidget(
                                  title: "Total HT :",
                                  value: "${commande.total_ht} F CFA",
                                  titleStyle: titleStyle,
                                  contentStyle: contentStyle),
                              TotalBlocItemWidget(
                                  title: "Taxes :",
                                  value: "${commande.taxe} F CFA",
                                  titleStyle: titleStyle,
                                  contentStyle: contentStyle),
                              TotalBlocItemWidget(
                                  title: "Total TTC :",
                                  value: "${commande.total_ttc} F CFA",
                                  titleStyle: titleStyle.copyWith(fontWeight: pw.FontWeight.bold),
                                  contentStyle: contentStyle.copyWith(fontWeight: pw.FontWeight.bold)),
                              TotalBlocItemWidget(
                                  title: "Montant Reçu :",
                                  value: "${commande.montant_recu} F CFA",
                                  titleStyle: titleStyle,
                                  contentStyle: contentStyle),
                              if (commande.remise!.isNotEmpty)
                                TotalBlocItemWidget(
                                    title: "Remise :",
                                    value: "${commande.remise} F CFA",
                                    titleStyle: titleStyle,
                                    contentStyle: contentStyle),
                              TotalBlocItemWidget(
                                  title: "Monnaie rendu :",
                                  value: "${commande.montant_rendue} F CFA",
                                  titleStyle: titleStyle,
                                  contentStyle: contentStyle),
                              TotalBlocItemWidget(
                                  title: "Mode payement :",
                                  value: commande.mode_payement,
                                  titleStyle: titleStyle,
                                  contentStyle: contentStyle),
                            ])
                      ],
                    ))
              ]),
              pw.Divider(height: 10, thickness: 1),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Text("Facture générée avec Buz'Up (www.buzup.app)",
                    textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 6)),
              ])
            ]));
    final bytes = await pdf.save();
    if (kIsWeb) {
      WebOnlyPackages.pdfFomBytesDownloder(bytes: bytes, name: "${commande.code}");
    } else {
      final dir = await getExternalStorageDirectory();
      final file = File("${dir!.path}/commande.pdf");
      final resultSave = await file.writeAsBytes(bytes);

      print("Save result $resultSave");
      OpenResult result = await OpenFile.open(file.path);

      print("Open result ${result.message}.");
    }
    return bytes;
  }

  pw.Widget TotalBlocItemWidget({
    String? title,
    String? value,
    pw.TextStyle? titleStyle,
    pw.TextStyle? contentStyle,
  }) {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Container(width: 50, child: pw.Text(title!, style: titleStyle)),
      pw.Text(value!, style: contentStyle)
    ]);
  }
}
