import 'package:flutter/material.dart';

class TreatmentsHistoryPage extends StatefulWidget {
  const TreatmentsHistoryPage({Key? key}) : super(key: key);

  @override
  State<TreatmentsHistoryPage> createState() => _TreatmentsHistoryPageState();
}

class _TreatmentsHistoryPageState extends State<TreatmentsHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> treatments = [
    {
      'id': '1',
      'name': 'Tratamiento Anti-Varroa',
      'type': 'curativo',
      'date': '2024-01-15',
      'hive': 'Colmena A',
      'product': 'Apivar',
      'dosage': '2 tiras por colmena',
      'notes': 'Aplicado después de la cosecha de otoño',
    },
    {
      'id': '2',
      'name': 'Alimentación Primaveral',
      'type': 'nutricional',
      'date': '2024-02-20',
      'hive': 'Todas las colmenas',
      'product': 'Jarabe de azúcar 1:1',
      'dosage': '2L por colmena',
      'notes': 'Estimulación antes de la floración',
    },
    {
      'id': '3',
      'name': 'Prevención Nosema',
      'type': 'preventivo',
      'date': '2024-03-10',
      'hive': 'Colmena B, C',
      'product': 'Fumidil B',
      'dosage': 'Según instrucciones del fabricante',
      'notes': 'Tratamiento preventivo de primavera',
    },
    {
      'id': '4',
      'name': 'Control de Polilla',
      'type': 'curativo',
      'date': '2024-03-25',
      'hive': 'Colmena D',
      'product': 'Bacillus thuringiensis',
      'dosage': '1 aplicación',
      'notes': 'Detección temprana de larvas',
    },
  ];

  final List<Map<String, dynamic>> treatmentOptions = [
    {
      'name': 'Control de Varroa con Ácido Oxálico',
      'type': 'curativo',
      'description':
          'Tratamiento efectivo contra el ácaro Varroa destructor mediante sublimación o goteo',
      'timing': 'Invierno cuando no hay cría',
      'dosage': '2.3g en 50ml de jarabe por colmena',
    },
    {
      'name': 'Apivar (Amitraz)',
      'type': 'curativo',
      'description':
          'Tratamiento de contacto para control de Varroa de larga duración',
      'timing': 'Después de cosecha, primavera u otoño',
      'dosage': '2 tiras por colmena durante 6-8 semanas',
    },
    {
      'name': 'Alimentación con Polen',
      'type': 'nutricional',
      'description':
          'Suplemento proteico para fortalecer la colonia y mejorar la cría',
      'timing': 'Primavera temprana o períodos de escasez',
      'dosage': '200-300g por semana por colmena',
    },
    {
      'name': 'Jarabe Estimulante',
      'type': 'nutricional',
      'description':
          'Estimula la postura de la reina y el desarrollo de la colonia',
      'timing': 'Primavera antes de la floración',
      'dosage': 'Jarabe 1:1 (azúcar:agua), 1-2L por semana',
    },
    {
      'name': 'Fumidil B (Fumagilina)',
      'type': 'preventivo',
      'description': 'Prevención y tratamiento de Nosema apis y ceranae',
      'timing': 'Otoño y primavera',
      'dosage': 'Según indicaciones del fabricante en jarabe',
    },
    {
      'name': 'Ácido Fórmico',
      'type': 'curativo',
      'description': 'Tratamiento orgánico contra Varroa y control de Nosema',
      'timing': 'Temperaturas entre 10-30°C',
      'dosage': 'Según sistema de evaporación usado',
    },
    {
      'name': 'Timol',
      'type': 'curativo',
      'description':
          'Tratamiento natural contra Varroa y prevención de enfermedades',
      'timing': 'Primavera u otoño, T° >15°C',
      'dosage': '10-20g por colmena durante 2-4 semanas',
    },
    {
      'name': 'Candy Proteico',
      'type': 'nutricional',
      'description': 'Alimento de emergencia rico en proteínas para invierno',
      'timing': 'Finales de otoño y durante invierno',
      'dosage': '1-2kg por colmena según necesidad',
    },
  ];

  List<Map<String, dynamic>> get filteredTreatments {
    if (_selectedFilter == 'all') return treatments;
    return treatments.where((t) => t['type'] == _selectedFilter).toList();
  }

  Color getTypeColor(String type) {
    switch (type) {
      case 'curativo':
        return const Color(0xFFEF4444); // red-500
      case 'preventivo':
        return const Color(0xFF3B82F6); // blue-500
      case 'nutricional':
        return const Color(0xFF10B981); // green-500
      default:
        return Colors.grey;
    }
  }

  String getTypeLabel(String type) {
    switch (type) {
      case 'curativo':
        return 'Curativo';
      case 'preventivo':
        return 'Preventivo';
      case 'nutricional':
        return 'Nutricional';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEB), // amber-50
      appBar: AppBar(
        backgroundColor: const Color(0xFFD97706), // amber-600
        elevation: 0,
        title: const Text(
          'Tratamientos de Colmenas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFFFEF3C7), // amber-100
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Historial'),
            Tab(text: 'Opciones de Tratamiento'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildHistoryTab(), _buildOptionsTab()],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Column(
      children: [
        // Filtros
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtrar por tipo',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF92400E), // amber-800
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip('all', 'Todos'),
                  _buildFilterChip('curativo', 'Curativos'),
                  _buildFilterChip('preventivo', 'Preventivos'),
                  _buildFilterChip('nutricional', 'Nutricionales'),
                ],
              ),
            ],
          ),
        ),
        // Lista de tratamientos
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredTreatments.length,
            itemBuilder: (context, index) {
              final treatment = filteredTreatments[index];
              return _buildTreatmentCard(treatment);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFFFBBF24), // amber-400
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF78350F) : const Color(0xFF92400E),
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected
            ? const Color(0xFFF59E0B) // amber-500
            : const Color(0xFFFDE68A), // amber-200
      ),
    );
  }

  Widget _buildTreatmentCard(Map<String, dynamic> treatment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)), // amber-200
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    treatment['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF78350F), // amber-900
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getTypeColor(treatment['type']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: getTypeColor(treatment['type']),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    getTypeLabel(treatment['type']),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: getTypeColor(treatment['type']),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.calendar_today, 'Fecha', treatment['date']),
            _buildInfoRow(Icons.home_work, 'Colmena', treatment['hive']),
            _buildInfoRow(Icons.medication, 'Producto', treatment['product']),
            _buildInfoRow(Icons.science, 'Dosificación', treatment['dosage']),
            if (treatment['notes'] != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7), // amber-100
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFFDE68A), // amber-200
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.notes,
                      size: 16,
                      color: Color(0xFF92400E), // amber-800
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        treatment['notes'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF92400E), // amber-800
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFFD97706)), // amber-600
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF92400E), // amber-800
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF78350F), // amber-900
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: treatmentOptions.length,
      itemBuilder: (context, index) {
        final option = treatmentOptions[index];
        return _buildOptionCard(option);
      },
    );
  }

  Widget _buildOptionCard(Map<String, dynamic> option) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)), // amber-200
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    option['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF78350F), // amber-900
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getTypeColor(option['type']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: getTypeColor(option['type']),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    getTypeLabel(option['type']),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: getTypeColor(option['type']),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              option['description'],
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF92400E), // amber-800
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.schedule, 'Momento', option['timing']),
            _buildDetailRow(Icons.science, 'Dosificación', option['dosage']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFFD97706)), // amber-600
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF92400E), // amber-800
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF78350F), // amber-900
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
