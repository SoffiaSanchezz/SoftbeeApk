import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TreatmentSettingsPage extends StatefulWidget {
  const TreatmentSettingsPage({Key? key}) : super(key: key);

  @override
  _TreatmentSettingsPageState createState() => _TreatmentSettingsPageState();
}

class _TreatmentSettingsPageState extends State<TreatmentSettingsPage> {
  bool _appliesTreatment = false;
  bool _isLoading = true;

  static const String _treatmentPreferenceKey = 'applies_treatment';

  @override
  void initState() {
    super.initState();
    _loadTreatmentPreference();
  }

  Future<void> _loadTreatmentPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _appliesTreatment = prefs.getBool(_treatmentPreferenceKey) ?? false;
      _isLoading = false;
    });
  }

  Future<void> _saveTreatmentPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_treatmentPreferenceKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configuración de Tratamientos',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.amber[600],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                SwitchListTile(
                  title: Text(
                    '¿Aplicas tratamientos cuando las abejas están enfermas?',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    _appliesTreatment
                        ? 'Sí, aplicas tratamientos.'
                        : 'No, no aplicas tratamientos.',
                    style: GoogleFonts.poppins(),
                  ),
                  value: _appliesTreatment,
                  onChanged: (bool value) {
                    setState(() {
                      _appliesTreatment = value;
                    });
                    _saveTreatmentPreference(value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Preferencia guardada: ${_appliesTreatment ? "Sí" : "No"}',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  activeColor: Colors.amber[800],
                ),
                const Divider(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Información',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Al activar esta opción, el sistema registrará que aplicas tratamientos a tus colmenas como parte de tus prácticas de manejo. Esta preferencia puede ser utilizada en futuros reportes o análisis.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
