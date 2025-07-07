import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sotfbee/features/admin/reports/model/api_models.dart';
import 'package:sotfbee/features/admin/reports/presentation/report_detail_page.dart';
import 'package:sotfbee/features/admin/reports/service/reports_service.dart';
import 'package:sotfbee/features/admin/reports/widgets/dashboard_widgets.dart';
import 'package:sotfbee/features/admin/reports/widgets/responsive_widgets.dart';

class DashboardReportsPage extends StatefulWidget {
  @override
  _DashboardReportsPageState createState() => _DashboardReportsPageState();
}

class _DashboardReportsPageState extends State<DashboardReportsPage> {
  bool _isLoading = true;
  String? _error;
  List<Monitoreo> _reports = [];
  List<Apiario> _apiarios = [];
  SystemStats? _stats;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final reports = await ReportsService.getMonitoringReports();
      final apiarios = await ReportsService.getApiarios();
      final stats = await ReportsService.getSystemStats();

      // Asignar monitoreos a sus respectivos apiarios
      for (var apiario in apiarios) {
        apiario.monitoreos = reports
            .where((report) => report.apiarioId == apiario.id)
            .toList();
      }

      setState(() {
        _reports = reports;
        _apiarios = apiarios;
        _stats = stats;
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
      backgroundColor: ApiarioTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Reportes de Monitoreo', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: ApiarioTheme.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Actualizar reportes',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _buildErrorWidget();
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(ApiarioTheme.getPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_stats != null)
              DashboardSummaryCard(stats: _stats!),
            SizedBox(height: 24),
            ApiariosSectionWidget(
              apiarios: _apiarios,
              crossAxisCount: ResponsiveBreakpoints.isDesktop(context) ? 2 : 1,
            ),
            SizedBox(height: 24),
            RecentMonitoreosWidget(monitoreos: _reports),
            SizedBox(height: 24),
            AlertsWidget(monitoreos: _reports),
            SizedBox(height: 24),
            WeatherWidget(),
            SizedBox(height: 24),
            ProductionChart(monitoreos: _reports),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red, size: 50),
          SizedBox(height: 10),
          Text('Error al cargar los reportes', style: GoogleFonts.poppins()),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _loadData,
            child: Text('Reintentar', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }
}
