// lib/view_models/controller/statement_controller.dart

import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:todo_reminder/model/statement_model.dart';
import 'package:todo_reminder/res/components/app_alerts.dart';
import 'package:todo_reminder/view_models/controller/base_controller.dart';
import 'package:todo_reminder/view_models/service/transaction_service.dart';

class StatementController extends GetxController with BaseController {
  final TransactionService _transactionService = TransactionService();

  // Loading State
  final RxBool isLoadingStatement = false.obs;
  final RxBool isDownloadingPDF = false.obs;

  // Statement Data
  final Rx<StatementModel?> statementData = Rx<StatementModel?>(null);

  // Filter Selection
  final RxString selectedFilter = 'This Month'.obs;
  final List<String> filterOptions = [
    'This Month',
    'Last Month',
    'Last 6 Months',
    'All Time',
  ];

  // Contact Info (passed from transaction screen)
  String contactName = '';
  String contactPhone = '';
  String personType = '';

  // ==================== INITIALIZE ====================

  void initialize({
    required String name,
    required String phone,
    required String type,
  }) {
    contactName = name;
    contactPhone = phone;
    personType = type;

    print('📝 Statement initialized for: $name');

    // Fetch statement
    fetchStatement();
  }

  // ==================== FETCH STATEMENT ====================

  Future<void> fetchStatement() async {
    try {
      isLoadingStatement.value = true;

      final response = await _transactionService.getStatement<Map<String, dynamic>>(contactPhone);
      final model = StatementModel.fromJson(response);

      if (model.success) {
        statementData.value = model;
        print('✅ Fetched statement: ${model.data.length} date groups');
      } else {
        print('❌ Failed to fetch statement: ${model.message}');
        AppAlerts.error(model.message);
      }
    } catch (e) {
      handleError(e);
    } finally {
      isLoadingStatement.value = false;
    }
  }

  // ==================== FILTER CHANGED ====================

  void onFilterChanged(String? filter) {
    if (filter != null) {
      selectedFilter.value = filter;
      print('📊 Filter changed to: $filter');
      // TODO: Implement filtering logic if API supports it
      // For now, we'll just update the selection
    }
  }

  // ==================== DOWNLOAD PDF ====================

  Future<void> downloadStatement() async {
    if (statementData.value == null) {
      AppAlerts.error('No statement data available');
      return;
    }

    try {
      isDownloadingPDF.value = true;

      final pdf = pw.Document();
      final statement = statementData.value!;

      // Build PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            // Header
            pw.Text(
              'Transaction Statement',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 20),

            // Contact Info
            pw.Text(
              statement.contact.name,
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              'Phone: ${statement.contact.phone}',
              style: const pw.TextStyle(fontSize: 12),
            ),
            pw.Text(
              'Type: ${statement.contact.personType == 'creditor' ? 'Creditor' : 'Debtor'}',
              style: const pw.TextStyle(fontSize: 12),
            ),
            pw.SizedBox(height: 20),

            // Balance Summary
            pw.Text(
              'Balance Summary',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.green),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'You Will Receive',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          '₹${statement.balanceSummary.youWillReceive}',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.red),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'You Will Pay',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          '₹${statement.balanceSummary.youWillPay}',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 30),

            // Transaction History
            pw.Text(
              'Transaction History',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),

            // Transactions grouped by date
            ...statement.data.map((dateGroup) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    dateGroup.date,
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey,
                    ),
                  ),
                  pw.Divider(),
                  pw.SizedBox(height: 5),

                  // Transactions for this date
                  ...dateGroup.transactions.map((tx) {
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 8),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                tx.time,
                                style: const pw.TextStyle(
                                  fontSize: 10,
                                  color: PdfColors.grey,
                                ),
                              ),
                              pw.Text(
                                tx.transactionType == 'given'
                                    ? 'Payment Given'
                                    : 'Payment Received',
                                style: const pw.TextStyle(fontSize: 11),
                              ),
                              if (tx.note.isNotEmpty)
                                pw.Text(
                                  tx.note,
                                  style: const pw.TextStyle(
                                    fontSize: 9,
                                    color: PdfColors.grey,
                                  ),
                                ),
                            ],
                          ),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text(
                                '${tx.transactionType == 'given' ? '-' : '+'}₹${tx.totalAmount}',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                  color: tx.transactionType == 'given'
                                      ? PdfColors.red
                                      : PdfColors.green,
                                ),
                              ),
                              pw.Text(
                                'Balance: ₹${tx.pendingAmount}',
                                style: const pw.TextStyle(
                                  fontSize: 9,
                                  color: PdfColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  pw.SizedBox(height: 15),
                ],
              );
            }).toList(),
          ],
        ),
      );

      // Share/Download PDF
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'statement_${contactName.replaceAll(' ', '_')}.pdf',
      );

      AppAlerts.success('Statement downloaded successfully');
    } catch (e) {
      print('❌ PDF generation error: $e');
      AppAlerts.error('Failed to generate PDF');
    } finally {
      isDownloadingPDF.value = false;
    }
  }

  // ==================== UI HELPERS ====================

  String get balanceReceive {
    if (statementData.value == null) return '₹0';
    return '₹${statementData.value!.balanceSummary.youWillReceive}';
  }

  String get balancePay {
    if (statementData.value == null) return '₹0';
    return '₹${statementData.value!.balanceSummary.youWillPay}';
  }
}