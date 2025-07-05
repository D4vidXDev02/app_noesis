import 'package:flutter/material.dart';
import 'package:noesis/views/FavoritesScreen.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';
import 'MenuScreen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'SettingsScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileViewModel _profileViewModel;

  int currentBottomNavIndex = 2;

  @override
  void initState() {
    super.initState();
    _profileViewModel = ProfileViewModel();
    // Cargar datos del perfil al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileViewModel.loadProfileData();

      if (_profileViewModel.isLoggedIn) {
        _profileViewModel.refreshMLPrediction();
        _profileViewModel.loadUserRecommendations();
        _profileViewModel.loadCompleteMLAnalysis();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _profileViewModel,
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          // Verificar si el usuario está logueado
          if (!viewModel.isLoggedIn) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_off, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No hay usuario logueado',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text('Ir a Login'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(color: Color(0xFFC96B0D)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                viewModel.userEmail ?? 'No hay usuario',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MenuScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite_border),
                    title: Text('Favoritos'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavoritesScreen()),
                      );                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Perfil'),
                    onTap: () {
                      Navigator.pop(context);
                      // Ya estamos en ProfileScreen, no necesitamos navegar
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Ajustes'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsScreen()),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Cerrar Sesión'),
                    onTap: () {
                      Navigator.pop(context);
                      _showLogoutDialog(context, viewModel);
                    },
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/logo_noesis.png',
                    height: 40,
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 24,
                      fontWeight: FontWeight.w600, // semibold
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 24),

                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar del usuario
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFF3E0),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 45,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                        SizedBox(width: 24),

                        // Información del usuario
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Username
                            Text(
                              'Username:',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              viewModel.username ?? 'Usuario',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),

                            // Nivel
                            Text(
                              'Nivel:',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              viewModel.nivel,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.star,
                            color: Color(0xFFFFC107),
                            size: 32,
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.email, color: Colors.grey[600], size: 20),
                          SizedBox(width: 8),
                          Text(
                            viewModel.userEmail ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Línea divisoria
                  Container(
                    height: 2,
                    color: Color(0xFFE0E0E0),
                  ),
                  SizedBox(height: 32),

                  // Sección de puntaje mejorada
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Mejor',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 4),
                                if (viewModel.isLoadingScore)
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00BCD4)),
                                    ),
                                  ),
                              ],
                            ),
                            Text(
                              'puntaje',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getLevelColor(viewModel.nivel),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getLevelColor(viewModel.nivel).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.psychology, // Icono de IA/ML
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '${viewModel.nivel}',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (viewModel.mlPredictionData?['es_prediccion_mejor'] == true) ...[
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.trending_up,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ],
                                ],
                              ),
                            ),

// FRAGMENTO 4: Agregar este widget después del badge de nivel (nuevo componente)
// Mostrar recomendación ML si está disponible
                            if (viewModel.mlRecommendation != null) ...[
                              SizedBox(height: 12),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.blue.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      color: Colors.blue.shade600,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        viewModel.mlRecommendation!,
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 13,
                                          color: Colors.blue.shade800,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

// FRAGMENTO 5: Agregar botón de actualización ML (después de las estadísticas)
// Botón para refrescar análisis ML
                            SizedBox(height: 16),
                            GestureDetector(
                              onTap: viewModel.isLoadingPrediction ? null : () async {
                                await viewModel.refreshMLPrediction();
                                await viewModel.loadUserRecommendations();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.purple.shade400, Colors.purple.shade600],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purple.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (viewModel.isLoadingPrediction)
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    else
                                      Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    SizedBox(width: 8),
                                    Text(
                                      viewModel.isLoadingPrediction ? 'Analizando...' : 'Análisis ML',
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            // Puntaje principal
                            if (!viewModel.isLoadingScore)
                              Text(
                                '${viewModel.puntajeObtenido}/${viewModel.puntajeTotal}',
                                style: TextStyle(
                                  fontFamily: 'Odibee Sans',
                                  fontSize: 46,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                            else
                              Container(
                                width: 120,
                                height: 64,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00BCD4)),
                                  ),
                                ),
                              ),
                            // Porcentaje
                            if (!viewModel.isLoadingScore && viewModel.puntajeTotal > 0)
                              Text(
                                '${((viewModel.puntajeObtenido / viewModel.puntajeTotal) * 100).round()}%',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _getLevelColor(viewModel.nivel),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Iconos de gamificación mejorados
                      Container(
                        width: 120,
                        height: 120,
                        child: Stack(
                          children: [
                            // Trofeo principal - cambia según el nivel
                            Positioned(
                              top: 10,
                              left: 30,
                              child: Container(
                                width: 40,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _getLevelColor(viewModel.nivel),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getLevelColor(viewModel.nivel).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _getLevelIcon(viewModel.nivel),
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            // Resto de iconos decorativos...
                            Positioned(
                              top: 0,
                              right: 20,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 10,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Color(0xFF2196F3),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.trending_up,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),

                  // GRÁFICO DE PROBABILIDADES ML
                  _buildProbabilityChart(viewModel),

                  //TARJETA DE COMPARACIÓN ML
                  _buildMLDataCard(viewModel),

                  // Sección clase más recurrida
                  Text(
                    'Clase más recurrida...',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Card de la clase más recurrida con estado de carga
                  Center(
                    child: viewModel.isLoadingMostVisited
                        ? Container(
                      constraints: BoxConstraints(maxWidth: 350),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Placeholder para icono
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          // Texto de carga
                          Expanded(
                            child: Text(
                              'Cargando clase más visitada...',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(
                      constraints: BoxConstraints(maxWidth: 350),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Icono de la clase
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: viewModel.claseMasRecurrida.startsWith('Ninguna') ||
                                  viewModel.claseMasRecurrida.startsWith('Error')
                                  ? Color(0xFFFFEBEE)
                                  : Color(0xFFF3E5F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Icon(
                                    viewModel.claseMasRecurrida.startsWith('Ninguna') ||
                                        viewModel.claseMasRecurrida.startsWith('Error')
                                        ? Icons.info_outline
                                        : Icons.menu_book,
                                    color: viewModel.claseMasRecurrida.startsWith('Ninguna') ||
                                        viewModel.claseMasRecurrida.startsWith('Error')
                                        ? Colors.grey[600]
                                        : Color(0xFF9C27B0),
                                    size: 30,
                                  ),
                                ),
                                if (!viewModel.claseMasRecurrida.startsWith('Ninguna') &&
                                    !viewModel.claseMasRecurrida.startsWith('Error'))
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF4CAF50),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),

                          // Texto de la clase
                          Expanded(
                            child: Text(
                              viewModel.claseMasRecurrida,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: viewModel.claseMasRecurrida.startsWith('Ninguna') ||
                                    viewModel.claseMasRecurrida.startsWith('Error')
                                    ? Colors.grey[600]
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),

            // Bottom Navigation Bar
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.red,
              unselectedItemColor: Colors.grey,
              currentIndex: currentBottomNavIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
              ],
              onTap: (index) {
                setState(() {
                  currentBottomNavIndex = index;
                });

                // Navegación basada en el índice seleccionado
                switch (index) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuScreen()),
                    );
                    break;
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavoritesScreen()),
                    );
                    break;
                  case 2:
                    break;
                }
              },
            ),
          );
        },
      ),
    );
  }


  // WIDGET DEL GRÁFICO DE PROBABILIDADES RESPONSIVO
  Widget _buildProbabilityChart(ProfileViewModel viewModel) {
    if (viewModel.mlPredictionData == null) {
      return SizedBox.shrink();
    }

    final data = viewModel.mlPredictionData!;
    final probabilidades = data['probabilidades'] as Map<String, dynamic>? ?? {};

    // Convertir probabilidades a lista ordenada
    final probList = probabilidades.entries.map((entry) {
      return MapEntry(entry.key, (entry.value as num).toDouble() * 100);
    }).toList();

    // Ordenar por probabilidad descendente
    probList.sort((a, b) => b.value.compareTo(a.value));

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive height basado en el ancho de pantalla
        double chartHeight = constraints.maxWidth < 400 ? 280 : 320;
        double titleFontSize = constraints.maxWidth < 400 ? 16 : 18;
        double labelFontSize = constraints.maxWidth < 400 ? 10 : 12;

        return Container(
          width: double.infinity, // Ocupa todo el ancho disponible
          height: chartHeight,
          padding: EdgeInsets.all(constraints.maxWidth < 400 ? 16 : 20),
          margin: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade50, Colors.indigo.shade50],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.purple.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header responsivo
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade600,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.bar_chart, color: Colors.white, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Probabilidades por Nivel',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade800,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Gráfico con restricciones responsivas
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (touchedSpot) => Colors.purple.shade600,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${probList[group.x.toInt()].key}\n${rod.toY.toStringAsFixed(1)}%',
                              TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: labelFontSize,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: constraints.maxWidth < 400 ? 35 : 40,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value.toInt() < probList.length) {
                                String label = probList[value.toInt()].key;
                                // Truncar texto en pantallas pequeñas
                                if (constraints.maxWidth < 400 && label.length > 8) {
                                  label = label.substring(0, 7) + '...';
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: labelFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.purple.shade700,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }
                              return Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: constraints.maxWidth < 400 ? 35 : 40,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Text(
                                '${value.toInt()}%',
                                style: TextStyle(
                                  fontSize: labelFontSize - 1,
                                  color: Colors.grey.shade600,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: probList.asMap().entries.map((entry) {
                        final index = entry.key;
                        final prob = entry.value;

                        Color barColor;
                        if (prob.key == data['nivel_predicho']) {
                          barColor = Colors.purple.shade600;
                        } else {
                          barColor = Colors.purple.shade300;
                        }

                        // Ancho de barra responsivo
                        double barWidth = constraints.maxWidth < 400 ? 16 : 20;

                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: prob.value,
                              color: barColor,
                              width: barWidth,
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  barColor,
                                  barColor.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 20,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.purple.shade200.withOpacity(0.5),
                            strokeWidth: 1,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12),

              // Leyenda responsiva
              Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 8,
                spacing: 16,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade600,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Predicción ML',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Otros niveles',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

// WIDGET DE LA TABLA DE COMPARACIÓN RESPONSIVO
  Widget _buildMLDataCard(ProfileViewModel viewModel) {
    if (viewModel.mlPredictionData == null) {
      return SizedBox.shrink();
    }

    final data = viewModel.mlPredictionData!;

    return LayoutBuilder(
      builder: (context, constraints) {
        double titleFontSize = constraints.maxWidth < 400 ? 16 : 18;
        double tableFontSize = constraints.maxWidth < 400 ? 12 : 14;
        double cellFontSize = constraints.maxWidth < 400 ? 11 : 13;
        double padding = constraints.maxWidth < 400 ? 16 : 20;

        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 16),
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.indigo.shade50, Colors.blue.shade50],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header responsivo
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.analytics, color: Colors.white, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Análisis ML vs Datos Guardados',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Tabla responsiva con SingleChildScrollView horizontal para pantallas muy pequeñas
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200.withOpacity(0.5)),
                ),
                child: constraints.maxWidth < 350
                    ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildComparisonTable(viewModel, data, tableFontSize, cellFontSize, false),
                )
                    : _buildComparisonTable(viewModel, data, tableFontSize, cellFontSize, true),
              ),

              SizedBox(height: 16),

              // Indicador de mejora responsivo
              if (data['es_prediccion_mejor'] == true)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.green.shade700, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '¡El análisis ML sugiere que podrías estar en un nivel superior!',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: cellFontSize + 1,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

// TABLA DE COMPARACIÓN RESPONSIVA
  Widget _buildComparisonTable(ProfileViewModel viewModel, Map<String, dynamic> data,
      double headerFontSize, double cellFontSize, bool isFlexible) {

    Widget buildRow(String metric, String saved, String predicted, Color backgroundColor, {bool isLast = false, bool isHeader = false}) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: isHeader ? 16 : 14, horizontal: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: isLast ? BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ) : isHeader ? BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ) : null,
        ),
        child: Row(
          mainAxisSize: isFlexible ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Container(
              width: isFlexible ? null : 100,
              child: isFlexible
                  ? Expanded(
                flex: 2,
                child: Text(
                  metric,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: isHeader ? headerFontSize : cellFontSize,
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.w600,
                    color: isHeader ? Colors.blue.shade800 : Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  : Text(
                metric,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: isHeader ? headerFontSize : cellFontSize,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.w600,
                  color: isHeader ? Colors.blue.shade800 : Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: isFlexible ? null : 100,
              child: isFlexible
                  ? Expanded(
                flex: 2,
                child: Text(
                  saved,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: isHeader ? headerFontSize : cellFontSize,
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
                    color: isHeader ? Colors.blue.shade800 : Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  : Text(
                saved,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: isHeader ? headerFontSize : cellFontSize,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
                  color: isHeader ? Colors.blue.shade800 : Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: isFlexible ? null : 100,
              child: isFlexible
                  ? Expanded(
                flex: 2,
                child: Text(
                  predicted,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: isHeader ? headerFontSize : cellFontSize,
                    fontWeight: FontWeight.w600,
                    color: isHeader ? Colors.blue.shade800 : Colors.purple.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  : Text(
                predicted,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: isHeader ? headerFontSize : cellFontSize,
                  fontWeight: FontWeight.w600,
                  color: isHeader ? Colors.blue.shade800 : Colors.purple.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header
        buildRow('Métrica', 'Guardado', 'ML Predicho', Colors.blue.shade100, isHeader: true),

        // Filas de datos
        buildRow(
          'Puntaje',
          '${viewModel.puntajeObtenido}/${viewModel.puntajeTotal}',
          '${data['puntaje_obtenido']}/${data['puntaje_total']}',
          Colors.grey.shade50,
        ),
        buildRow(
          'Porcentaje',
          '${((viewModel.puntajeObtenido / viewModel.puntajeTotal) * 100).round()}%',
          '${data['porcentaje']?.toStringAsFixed(1)}%',
          Colors.white,
        ),
        buildRow(
          'Nivel',
          viewModel.nivel,
          data['nivel_predicho'],
          Colors.grey.shade50,
        ),
        buildRow(
          'Confianza ML',
          '',
          '${((data['confianza'] ?? 0) * 100).toStringAsFixed(1)}%',
          Colors.white,
          isLast: true,
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar Sesión'),
          content: Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                viewModel.logout();
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  // Metodos auxiliar para el estilo de nivel
  Color _getLevelColor(String nivel) {
    switch (nivel.toLowerCase()) {
      case 'avanzado':
        return Color(0xFFFF6B35); // Naranja para avanzado
      case 'intermedio':
        return Color(0xFF2196F3); // Azul para intermedio
      case 'básico':
      default:
        return Color(0xFF4CAF50); // Verde para básico
    }
  }

  IconData _getLevelIcon(String nivel) {
    switch (nivel.toLowerCase()) {
      case 'avanzado':
        return Icons.emoji_events; // Trofeo para avanzado
      case 'intermedio':
        return Icons.school; // Educación para intermedio
      case 'básico':
      default:
        return Icons.star; // Estrella para básico
    }
  }
}