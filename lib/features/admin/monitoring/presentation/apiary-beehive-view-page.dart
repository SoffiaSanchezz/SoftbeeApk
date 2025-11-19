import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sotfbee/features/admin/monitoring/models/enhanced_models.dart';
import 'package:sotfbee/features/admin/monitoring/service/enhaced_api_service.dart';
// import 'package:sotfbee/features/admin/monitoring/screens/colmenas-management-screen.dart';
import 'package:sotfbee/features/admin/monitoring/presentation/beehive_management_page.dart';

class ApiaryBeehiveViewPage extends StatefulWidget {
  const ApiaryBeehiveViewPage({Key? key}) : super(key: key);

  @override
  _ApiaryBeehiveViewPageState createState() => _ApiaryBeehiveViewPageState();
}

class _ApiaryBeehiveViewPageState extends State<ApiaryBeehiveViewPage> {
  List<Apiario> _apiaries = [];
  bool _isLoading = true;
  String? _error;
  int? _selectedApiaryIndex;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final apiarios = await EnhancedApiService.obtenerApiarios();
      final List<Apiario> apiariosConColmenas = [];
      for (var apiary in apiarios) {
        final colmenas = await EnhancedApiService.obtenerColmenas(apiary.id);
        apiariosConColmenas.add(apiary.copyWith(colmenas: colmenas));
      }
      setState(() {
        _apiaries = apiariosConColmenas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = "Error al cargar los datos: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F6),
      appBar: AppBar(
        title: Text(
          'Colmenas por Apiario',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.amber[600],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: _buildBody(isDesktop, isTablet),
    );
  }

  Widget _buildBody(bool isDesktop, bool isTablet) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber[600]!),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              "Cargando apiarios...",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.amber[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.red[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[600],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_apiaries.isEmpty) {
      return _buildEmptyState(isDesktop);
    }

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 1200 : (isTablet ? 900 : double.infinity),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isDesktop, isTablet)
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.2, end: 0),
                SizedBox(height: isDesktop ? 32 : 20),
                _buildApiariesGrid(isDesktop, isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDesktop, bool isTablet) {
    final totalColmenas = _apiaries.fold<int>(
      0,
      (sum, apiario) => sum + (apiario.colmenas?.length ?? 0),
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 32 : (isTablet ? 24 : 20)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber[600]!, Colors.orange[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(isDesktop ? 16 : 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
                ),
                child:
                    Icon(
                          Icons.home_work,
                          size: isDesktop ? 40 : 32,
                          color: Colors.amber[700],
                        )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.1, 1.1),
                          duration: 2000.ms,
                        ),
              ),
              SizedBox(width: isDesktop ? 24 : 16),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Apiarios y Colmenas',
                      style: GoogleFonts.poppins(
                        fontSize: isDesktop ? 28 : (isTablet ? 26 : 24),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Selecciona un apiario para gestionar sus colmenas',
                      style: GoogleFonts.poppins(
                        fontSize: isDesktop ? 16 : 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isDesktop ? 32 : 20),
          if (isDesktop)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHeaderStat(
                  icon: Icons.home_work_outlined,
                  label: 'Total Apiarios',
                  value: _apiaries.length.toString(),
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.hive_outlined,
                  label: 'Total Colmenas',
                  value: totalColmenas.toString(),
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.analytics_outlined,
                  label: 'Promedio por Apiario',
                  value: _apiaries.isEmpty
                      ? '0'
                      : (totalColmenas / _apiaries.length).toStringAsFixed(1),
                  isDesktop: isDesktop,
                ),
              ],
            )
          else
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildHeaderStat(
                  icon: Icons.home_work_outlined,
                  label: 'Apiarios',
                  value: _apiaries.length.toString(),
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.hive_outlined,
                  label: 'Colmenas',
                  value: totalColmenas.toString(),
                  isDesktop: isDesktop,
                ),
                _buildHeaderStat(
                  icon: Icons.analytics_outlined,
                  label: 'Promedio',
                  value: _apiaries.isEmpty
                      ? '0'
                      : (totalColmenas / _apiaries.length).toStringAsFixed(1),
                  isDesktop: isDesktop,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat({
    required IconData icon,
    required String label,
    required String value,
    required bool isDesktop,
  }) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isDesktop ? 28 : 24, color: Colors.white),
          SizedBox(height: isDesktop ? 8 : 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isDesktop ? 14 : 12,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isDesktop ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildApiariesGrid(bool isDesktop, bool isTablet) {
    if (isDesktop) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.9,
        ),
        itemCount: _apiaries.length,
        itemBuilder: (context, index) {
          return _buildApiaryCard(_apiaries[index], index, isDesktop, isTablet);
        },
      );
    } else {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _apiaries.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: isTablet ? 16 : 12),
        itemBuilder: (context, index) {
          return _buildApiaryCard(_apiaries[index], index, isDesktop, isTablet);
        },
      );
    }
  }

  Widget _buildApiaryCard(
    Apiario apiary,
    int index,
    bool isDesktop,
    bool isTablet,
  ) {
    final isSelected = _selectedApiaryIndex == index;
    final colmenasCount = apiary.colmenas?.length ?? 0;
    final colmenasActivas =
        apiary.colmenas
            ?.where((c) => c.metadatos?['nivel_actividad'] == 'Alta')
            .length ??
        0;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedApiaryIndex = isSelected ? null : index;
        });
      },
      child:
          AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(isDesktop ? 24 : 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
                  border: Border.all(
                    color: isSelected ? Colors.amber[600]! : Colors.amber[200]!,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? Colors.amber.withOpacity(0.25)
                          : Colors.grey.withOpacity(0.1),
                      blurRadius: isSelected ? 20 : 15,
                      offset: Offset(0, isSelected ? 10 : 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header del apiario
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(isDesktop ? 14 : 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.amber[600]!, Colors.orange[500]!],
                            ),
                            borderRadius: BorderRadius.circular(
                              isDesktop ? 14 : 12,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.home_work,
                            color: Colors.white,
                            size: isDesktop ? 28 : 24,
                          ),
                        ),
                        SizedBox(width: isDesktop ? 16 : 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                apiary.name,
                                style: GoogleFonts.poppins(
                                  fontSize: isDesktop ? 20 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[800],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: isDesktop ? 16 : 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      apiary.location ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: isDesktop ? 14 : 12,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.amber[700],
                          size: isDesktop ? 28 : 24,
                        ),
                      ],
                    ),

                    SizedBox(height: isDesktop ? 20 : 16),

                    // Estadísticas del apiario
                    Container(
                      padding: EdgeInsets.all(isDesktop ? 16 : 12),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber[100]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildApiaryStatItem(
                            icon: Icons.hive,
                            label: 'Total',
                            value: colmenasCount.toString(),
                            color: Colors.amber[700]!,
                            isDesktop: isDesktop,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.amber[200],
                          ),
                          _buildApiaryStatItem(
                            icon: Icons.trending_up,
                            label: 'Activas',
                            value: colmenasActivas.toString(),
                            color: Colors.green[600]!,
                            isDesktop: isDesktop,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isDesktop ? 20 : 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navegar a la pantalla de gestión de colmenas
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ColmenasManagementScreen(apiario: apiary),
                            ),
                          ).then((_) {
                            // Recargar datos al volver
                            _loadData();
                          });
                        },
                        icon: Icon(Icons.settings, size: isDesktop ? 20 : 18),
                        label: Text(
                          'Gestionar Colmenas',
                          style: GoogleFonts.poppins(
                            fontSize: isDesktop ? 16 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[600],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: isDesktop ? 16 : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),

                    // Lista de colmenas (expandible)
                    if (isSelected) ...[
                      SizedBox(height: isDesktop ? 20 : 16),
                      Divider(color: Colors.amber[200], thickness: 1),
                      SizedBox(height: isDesktop ? 16 : 12),
                      if (apiary.colmenas != null &&
                          apiary.colmenas!.isNotEmpty) ...[
                        Text(
                          'Colmenas en este apiario:',
                          style: GoogleFonts.poppins(
                            fontSize: isDesktop ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: isDesktop ? 300 : 200,
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: apiary.colmenas!.length,
                            separatorBuilder: (context, i) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, i) {
                              final colmena = apiary.colmenas![i];
                              final nivelActividad =
                                  colmena.metadatos?['nivel_actividad'] ??
                                  'Media';
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.amber[50],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.amber[200]!),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.amber[600],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.hive,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Colmena #${colmena.numeroColmena}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: _getActivityColor(
                                                    nivelActividad,
                                                  ).withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: _getActivityColor(
                                                      nivelActividad,
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  nivelActividad,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: _getActivityColor(
                                                      nivelActividad,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                ),
                              ).animate().fadeIn(
                                delay: Duration(milliseconds: 50 * i),
                              );
                            },
                          ),
                        ),
                      ] else
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'No hay colmenas en este apiario',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(),
                    ],
                  ],
                ),
              )
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: 100 * index),
                duration: 600.ms,
              )
              .slideX(begin: 0.2, end: 0),
    );
  }

  Widget _buildApiaryStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDesktop,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: isDesktop ? 28 : 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isDesktop ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isDesktop ? 12 : 11,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Color _getActivityColor(String nivel) {
    switch (nivel) {
      case 'Alta':
        return Colors.green[700]!;
      case 'Media':
        return Colors.orange[700]!;
      case 'Baja':
        return Colors.red[700]!;
      default:
        return Colors.grey[600]!;
    }
  }

  Widget _buildEmptyState(bool isDesktop) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(isDesktop ? 32 : 20),
        padding: EdgeInsets.all(isDesktop ? 48 : 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.home_work_outlined,
              size: isDesktop ? 80 : 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'No hay apiarios disponibles',
              style: GoogleFonts.poppins(
                fontSize: isDesktop ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega tu primer apiario para comenzar',
              style: GoogleFonts.poppins(
                fontSize: isDesktop ? 16 : 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
