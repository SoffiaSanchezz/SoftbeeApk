import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sotfbee/features/admin/reports/model/api_models.dart';
import 'package:sotfbee/features/admin/reports/widgets/responsive_widgets.dart';

class ReportDetailPage extends StatelessWidget {
  final Monitoreo report;

  const ReportDetailPage({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Reporte #${report.monitoreoId}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: ApiarioTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ApiarioTheme.getPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: 24),
            _buildRespuestasSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailItem(
              context,
              'Apiario:',
              report.apiarioNombre ?? 'N/A',
              Icons.home_work,
            ),
            Divider(),
            _buildDetailItem(
              context,
              'Colmena:',
              report.hiveNumber.toString(),
              Icons.hive,
            ),
            Divider(),
            _buildDetailItem(
              context,
              'Fecha:',
              report.fecha.toString(),
              Icons.calendar_today,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRespuestasSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Respuestas del Monitoreo',
          style: ApiarioTheme.titleStyle.copyWith(
            fontSize: ApiarioTheme.getSubtitleFontSize(context),
          ),
        ),
        SizedBox(height: 16),
        ...report.respuestas.map((respuesta) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                Icons.question_answer,
                color: ApiarioTheme.secondaryColor,
              ),
              title: Text(
                respuesta.preguntaTexto,
                style: ApiarioTheme.bodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                respuesta.respuesta ?? 'N/A',
                style: ApiarioTheme.bodyStyle.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: ApiarioTheme.primaryColor, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: ApiarioTheme.bodyStyle.copyWith(
                    color: Colors.grey[600],
                    fontSize: ApiarioTheme.getBodyFontSize(context) - 2,
                  ),
                ),
                Text(
                  value,
                  style: ApiarioTheme.bodyStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: ApiarioTheme.getBodyFontSize(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
