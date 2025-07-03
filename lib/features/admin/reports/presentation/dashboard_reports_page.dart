import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sotfbee/features/admin/reports/model/api_models.dart';
import 'package:sotfbee/features/admin/reports/presentation/report_detail_page.dart';
import 'package:sotfbee/features/admin/reports/service/reports_service.dart';

class DashboardReportsPage extends StatefulWidget {
  @override
  _DashboardReportsPageState createState() => _DashboardReportsPageState();
}

class _DashboardReportsPageState extends State<DashboardReportsPage> {
  bool _isLoading = true;
  String? _error;
  List<Monitoreo> _reports = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final reports = await ReportsService.getMonitoringReports();
      setState(() {
        _reports = reports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reportes de Monitoreo'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 50),
            SizedBox(height: 10),
            Text('Error al cargar los reportes'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadReports,
              child: Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_reports.isEmpty) {
      return Center(child: Text('No hay reportes disponibles.'));
    }

    return ListView.builder(
      itemCount: _reports.length,
      itemBuilder: (context, index) {
        final report = _reports[index];
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text('Reporte #${report.monitoreoId}'),
            subtitle: Text('Apiario: ${report.apiarioNombre} - Colmena: ${report.hiveNumber}'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportDetailPage(report: report),
                ),
              );
            },
          ),
        ).animate().fadeIn();
      },
    );
  }
}
