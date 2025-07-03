import 'package:flutter/material.dart';
import 'package:sotfbee/features/admin/reports/model/api_models.dart';

class ReportDetailPage extends StatelessWidget {
  final Monitoreo report;

  const ReportDetailPage({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Reporte #${report.monitoreoId}'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Apiario:', report.apiarioNombre ?? 'N/A'),
            _buildDetailItem('Colmena:', report.hiveNumber.toString()),
            _buildDetailItem('Fecha:', report.fecha.toString()),
            SizedBox(height: 20),
            Text('Respuestas:', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 10),
            ...report.respuestas.map((respuesta) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text(respuesta.preguntaTexto),
                  subtitle: Text(respuesta.respuesta ?? 'N/A'),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
