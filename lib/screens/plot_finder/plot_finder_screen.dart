import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../data/plot_inventory.dart';

const Map<String, List<String>> _pricedPlotNumbersBySector = {
  'C-15': ['1674', '1641', '208', '243', '310'],
  'C-16/2': ['2167', '2215', '1989'],
  'C-16/3': ['2740-C', '2526'],
  'C-16/4': ['3599-C', '3811', '3711'],
};

class PlotFinderScreen extends StatefulWidget {
  const PlotFinderScreen({super.key});

  @override
  State<PlotFinderScreen> createState() => _PlotFinderScreenState();
}

class _PlotFinderScreenState extends State<PlotFinderScreen> {
  static const Color gold = Color(0xFFD6A84F);
  static const Color background = Color(0xFF0B0B0B);
  static const Color panel = Color(0xFF171717);

  String _selectedSector = 'C-15';
  String _selectedC16Part = '3';

  final TextEditingController _plotController = TextEditingController();

  PlotListing? _selectedPlot;
  PlotListing? _panelPlot;
  String? _searchMessage;

  String get _effectiveSector {
    if (_selectedSector == 'C-16') {
      return 'C-16/$_selectedC16Part';
    }
    return _selectedSector;
  }

  List<PlotListing> _plotsForSector(String sector) {
    final allowed = _pricedPlotNumbersBySector[sector] ?? const <String>[];

    return plotInventory.where((plot) {
      return plot.sector == sector && allowed.contains(plot.plotNumber);
    }).toList();
  }

  List<PlotListing> get _panelPlotsForCurrentSector {
    return _plotsForSector(_effectiveSector);
  }

  void _clearSelection() {
    _selectedPlot = null;
    _panelPlot = null;
    _searchMessage = null;
    _plotController.clear();
  }

  void _setActivePlot(PlotListing plot) {
    setState(() {
      _selectedPlot = plot;
      _panelPlot = plot;
      _searchMessage = null;
      _plotController.text = plot.plotNumber;
    });
  }

  void _showNextPanelPlot() {
    final plots = _panelPlotsForCurrentSector;

    if (plots.isEmpty) return;

    final currentIndex = _panelPlot == null
        ? -1
        : plots.indexWhere(
            (plot) =>
                plot.sector == _panelPlot!.sector &&
                plot.plotNumber == _panelPlot!.plotNumber,
          );

    final nextIndex = currentIndex == -1
        ? 0
        : (currentIndex + 1) % plots.length;

    setState(() {
      _panelPlot = plots[nextIndex];
      _searchMessage = null;
    });
  }

  void _selectC16Part(String part) {
    final sector = 'C-16/$part';
    final plots = _plotsForSector(sector);
    final firstPlot = plots.isNotEmpty ? plots.first : null;

    setState(() {
      _selectedSector = 'C-16';
      _selectedC16Part = part;

      _selectedPlot = firstPlot;
      _panelPlot = firstPlot;
      _searchMessage = null;

      _plotController.text = firstPlot?.plotNumber ?? '';
    });
  }

  void _searchPlot() {
    final query = _plotController.text.trim().toUpperCase().replaceAll(' ', '');

    PlotListing? match;

    for (final plot in plotInventory) {
      final allowed =
          _pricedPlotNumbersBySector[plot.sector] ?? const <String>[];
      final normalizedNumber = plot.plotNumber.toUpperCase().replaceAll(
        ' ',
        '',
      );

      if (plot.sector == _effectiveSector &&
          allowed.contains(plot.plotNumber) &&
          normalizedNumber == query) {
        match = plot;
        break;
      }
    }

    setState(() {
      _selectedPlot = match;
      _panelPlot = match;

      if (query.isEmpty) {
        _searchMessage = 'Please enter a plot number';
      } else if (match == null) {
        _searchMessage =
            'Plot $query is not currently listed in Sector $_effectiveSector';
      } else {
        _searchMessage = null;
      }
    });
  }

  @override
  void dispose() {
    _plotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            _PlotFinderHeader(onBack: () => Navigator.of(context).pop()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 36,
                ),
                child: Column(
                  children: [
                    const Text(
                      'Find Your Plot',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explore available plots across C-14, C-15 and C-16',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white60, fontSize: 17),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 1150),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile = constraints.maxWidth < 750;

                          final sectorField = _SectorDropdown(
                            value: _selectedSector,
                            onChanged: (value) {
                              if (value == null) return;

                              if (value == 'C-16') {
                                final plots = _plotsForSector('C-16/3');
                                final PlotListing? firstPlot = plots.isNotEmpty
                                    ? plots.first
                                    : null;

                                setState(() {
                                  _selectedSector = 'C-16';
                                  _selectedC16Part = '3';
                                  _selectedPlot = firstPlot;
                                  _panelPlot = firstPlot;
                                  _searchMessage = null;
                                  _plotController.text =
                                      firstPlot?.plotNumber ?? '';
                                });

                                return;
                              }

                              setState(() {
                                _selectedSector = value;
                                _selectedPlot = null;
                                _panelPlot = null;
                                _searchMessage = null;
                                _plotController.clear();
                              });
                            },
                          );

                          final plotField = _SearchField(
                            icon: Icons.search_rounded,
                            hint: 'Enter plot number',
                            controller: _plotController,
                            onSubmitted: (_) => _searchPlot(),
                          );

                          final searchButton = SizedBox(
                            height: 58,
                            child: ElevatedButton(
                              onPressed: _searchPlot,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: gold,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 38,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Search',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );

                          if (isMobile) {
                            return Column(
                              children: [
                                sectorField,
                                const SizedBox(height: 12),
                                plotField,
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: searchButton,
                                ),
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(child: sectorField),
                              const SizedBox(width: 14),
                              Expanded(child: plotField),
                              const SizedBox(width: 14),
                              searchButton,
                            ],
                          );
                        },
                      ),
                    ),
                    if (_selectedSector == 'C-16') ...[
                      const SizedBox(height: 14),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 1150),
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: ['2', '3', '4'].map((part) {
                            final isSelected = _selectedC16Part == part;

                            return MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    _selectC16Part(part);
                                  },

                                  borderRadius: BorderRadius.circular(10),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 11,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? gold
                                          : const Color(0xFF171717),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFFFE3A1)
                                            : const Color(0x88D6A84F),
                                      ),
                                    ),
                                    child: Text(
                                      'C-16/$part',
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 1150,
                        minHeight: 520,
                      ),
                      decoration: BoxDecoration(
                        color: panel,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: gold.withValues(alpha: 0.65)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile = constraints.maxWidth < 850;

                          final leftView = _SectorContentView(
                            sector: _effectiveSector,
                            selectedPlot: _selectedPlot,
                            onPlotTap: _setActivePlot,
                          );

                          final activePanelPlot = _panelPlot ?? _selectedPlot;

                          final detailsView = activePanelPlot != null
                              ? _PlotResultCard(
                                  plot: activePanelPlot,
                                  onNext: _showNextPanelPlot,
                                )
                              : _searchMessage != null
                              ? _PlotSearchMessage(message: _searchMessage!)
                              : _effectiveSector == 'C-14'
                              ? const _SectorContactCard(sector: 'C-14')
                              : const _DetailsPlaceholder();

                          if (isMobile) {
                            return Column(
                              children: [
                                SizedBox(height: 480, child: leftView),
                                Container(
                                  height: 1,
                                  color: gold.withValues(alpha: 0.35),
                                ),
                                detailsView,
                              ],
                            );
                          }

                          return SizedBox(
                            height: 680,
                            child: Row(
                              children: [
                                Expanded(flex: 7, child: leftView),
                                Container(
                                  width: 1,
                                  color: gold.withValues(alpha: 0.35),
                                ),
                                SizedBox(width: 390, child: detailsView),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    const _InventoryInformationSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlotFinderHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _PlotFinderHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return Container(
      height: isMobile ? 72 : 90,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 34),
      decoration: const BoxDecoration(
        color: Color(0xFF101010),
        border: Border(bottom: BorderSide(color: Color(0x44D6A84F))),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.arrow_back_rounded, color: Color(0xFFD6A84F)),
            ),
          ),
          const SizedBox(width: 10),
          Image.asset(
            'assets/logo.png',
            height: isMobile ? 42 : 55,
            width: isMobile ? 42 : 55,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isMobile
                  ? 'MEMS PLOT FINDER'
                  : 'MEMS  •  MIRABELLA ESTATE MANAGEMENT SERVICES',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFFD6A84F),
                fontSize: isMobile ? 13 : 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
          if (!isMobile)
            const Text(
              'FIND YOUR PLOT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;

  const _SearchField({
    required this.icon,
    required this.hint,
    this.controller,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x88D6A84F)),
      ),
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: const Color(0xFFD6A84F)),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}

class _SectorDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const _SectorDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const sectors = ['C-14', 'C-15', 'C-16'];

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x88D6A84F)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Color(0xFFD6A84F)),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: const Color(0xFF1A1A1A),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFFD6A84F),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                items: sectors.map((sector) {
                  return DropdownMenuItem<String>(
                    value: sector,
                    child: Text('Sector $sector'),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectorContentView extends StatelessWidget {
  final String sector;
  final PlotListing? selectedPlot;
  final ValueChanged<PlotListing> onPlotTap;

  const _SectorContentView({
    required this.sector,
    required this.selectedPlot,
    required this.onPlotTap,
  });

  @override
  Widget build(BuildContext context) {
    if (sector == 'C-14') {
      return const _SectorInformationPanel(
        sector: 'C-14',
        title: 'About Sector C-14',
        description:
            'Sector C-14 is a planned residential sector featuring organised residential plot blocks, a central Markaz and commercial area, apartment sites, schools, mosques, parks and public facilities. The sector benefits from connectivity through Margalla Avenue, adjoining avenues and C.D. Principal Road. Current available plot numbers and demand prices will be added once confirmed inventory is received.',
      );
    }

    if (sector == 'C-15') {
      return _AvailablePlotList(
        sector: sector,
        selectedPlot: selectedPlot,
        onPlotTap: onPlotTap,
      );
    }

    if (sector.startsWith('C-16')) {
      return _SectorMapView(
        sector: sector,
        selectedPlot: selectedPlot,
        onPlotTap: onPlotTap,
      );
    }

    return const SizedBox.shrink();
  }
}

class _SectorInformationPanel extends StatelessWidget {
  final String sector;
  final String title;
  final String description;

  const _SectorInformationPanel({
    required this.sector,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF101010),
      padding: const EdgeInsets.all(36),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 620),
          padding: const EdgeInsets.all(34),
          decoration: BoxDecoration(
            color: const Color(0xFF171717),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x88D6A84F)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_city_rounded,
                color: Color(0xFFD6A84F),
                size: 60,
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFD6A84F),
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x18D6A84F),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0x66D6A84F)),
                ),
                child: Text(
                  'Sector $sector',
                  style: const TextStyle(
                    color: Color(0xFFD6A84F),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvailablePlotList extends StatelessWidget {
  final String sector;
  final PlotListing? selectedPlot;
  final ValueChanged<PlotListing> onPlotTap;

  const _AvailablePlotList({
    required this.sector,
    required this.selectedPlot,
    required this.onPlotTap,
  });

  @override
  Widget build(BuildContext context) {
    final allowed = _pricedPlotNumbersBySector[sector] ?? const <String>[];

    final plots = plotInventory.where((plot) {
      return plot.sector == sector && allowed.contains(plot.plotNumber);
    }).toList();

    return Container(
      color: const Color(0xFF101010),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.grid_view_rounded,
                color: Color(0xFFD6A84F),
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Available Plots — Sector $sector',
                  style: const TextStyle(
                    color: Color(0xFFD6A84F),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Select a plot below to view its demand and contact options.',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth < 500 ? 1 : 2;
                final ratio = columns == 1 ? 3.2 : 2.15;

                return GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: plots.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: ratio,
                  ),
                  itemBuilder: (context, index) {
                    final plot = plots[index];
                    final isSelected =
                        selectedPlot?.sector == plot.sector &&
                        selectedPlot?.plotNumber == plot.plotNumber;

                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => onPlotTap(plot),
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0x22D6A84F)
                                  : const Color(0xFF171717),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFFFD978)
                                    : const Color(0x66D6A84F),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? const [
                                      BoxShadow(
                                        color: Color(0x33D6A84F),
                                        blurRadius: 16,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFD6A84F)
                                        : const Color(0x22FFFFFF),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFFD6A84F),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    color: isSelected
                                        ? Colors.black
                                        : const Color(0xFFD6A84F),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Plot ${plot.plotNumber}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        plot.demand,
                                        style: const TextStyle(
                                          color: Color(0xFFD6A84F),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Color(0xFFD6A84F),
                                  size: 17,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlotSearchMessage extends StatelessWidget {
  final String message;

  const _PlotSearchMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x66D6A84F)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              color: Color(0xFFD6A84F),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 17,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlotResultCard extends StatelessWidget {
  final PlotListing plot;
  final VoidCallback onNext;

  const _PlotResultCard({required this.plot, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 620),
            margin: EdgeInsets.all(isMobile ? 18 : 32),
            padding: EdgeInsets.all(isMobile ? 22 : 34),
            decoration: BoxDecoration(
              color: const Color(0xFF101010),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD6A84F)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x44000000),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFFD6A84F),
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Sector ${plot.sector}',
                        style: TextStyle(
                          color: const Color(0xFFD6A84F),
                          fontSize: isMobile ? 22 : 27,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: Color(0x55D6A84F)),
                const SizedBox(height: 20),
                const Text(
                  'PLOT NUMBER',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  plot.plotNumber,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 30 : 38,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'DEMAND',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  plot.demand,
                  style: TextStyle(
                    color: const Color(0xFFD6A84F),
                    fontSize: isMobile ? 21 : 27,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'STATUS',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x2234C759),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF34C759)),
                  ),
                  child: Text(
                    plot.status,
                    style: const TextStyle(
                      color: Color(0xFF63E67C),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final stackButtons = constraints.maxWidth < 420;

                    final whatsappButton = SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          launchUrlString(
                            'https://wa.me/923300492037'
                            '?text=Hello%20MEMS,%20I%20am%20interested%20in%20'
                            'Plot%20${plot.plotNumber}%20in%20Sector%20${plot.sector}.',
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        icon: const Icon(Icons.chat_rounded),
                        label: const Text('WhatsApp'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF63E67C),
                          side: const BorderSide(color: Color(0xFF34C759)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    );

                    final callButton = SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          launchUrlString(
                            'tel:+923300492037',
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        icon: const Icon(Icons.phone_rounded),
                        label: const Text('Call Now'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFD6A84F),
                          side: const BorderSide(color: Color(0xFFD6A84F)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    );

                    if (stackButtons) {
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: whatsappButton,
                          ),
                          const SizedBox(height: 12),
                          SizedBox(width: double.infinity, child: callButton),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(child: whatsappButton),
                        const SizedBox(width: 14),
                        Expanded(child: callButton),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 4,
          top: 0,
          bottom: 0,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onNext,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6A84F),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFE3A1),
                      width: 1.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x55000000),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectorMapView extends StatelessWidget {
  final String sector;
  final PlotListing? selectedPlot;
  final ValueChanged<PlotListing> onPlotTap;

  const _SectorMapView({
    required this.sector,
    required this.selectedPlot,
    required this.onPlotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: const Color(0xFF080808)),
        LayoutBuilder(
          builder: (context, constraints) {
            const originalWidth = 1672.0;
            const originalHeight = 941.0;

            final fitScale = math.min(
              constraints.maxWidth / originalWidth,
              constraints.maxHeight / originalHeight,
            );

            final mapWidth = originalWidth * fitScale;
            final mapHeight = originalHeight * fitScale;

            return InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              boundaryMargin: const EdgeInsets.all(120),
              child: Center(
                child: SizedBox(
                  width: mapWidth,
                  height: mapHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/C16_MEMS_Plot_Map.png',
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xDD101010),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD6A84F)),
            ),
            child: Text(
              'SECTOR $sector',
              style: const TextStyle(
                color: Color(0xFFD6A84F),
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
        if (selectedPlot != null)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xE6D6A84F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'SELECTED: ${selectedPlot!.plotNumber}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        Positioned(
          left: 16,
          bottom: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xCC101010),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.zoom_in_rounded, color: Color(0xFFD6A84F), size: 18),
                SizedBox(width: 7),
                Text(
                  'Scroll or pinch to zoom',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailsPlaceholder extends StatelessWidget {
  const _DetailsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.touch_app_rounded, color: Color(0xFFD6A84F), size: 52),
            SizedBox(height: 16),
            Text(
              'SELECT OR SEARCH A PLOT',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Plot demand and availability will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectorContactCard extends StatelessWidget {
  final String sector;

  const _SectorContactCard({required this.sector});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFF101010),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD6A84F)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.support_agent_rounded,
              color: Color(0xFFD6A84F),
              size: 52,
            ),
            const SizedBox(height: 16),
            Text(
              'Interested in Sector $sector?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFD6A84F),
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Contact MEMS for current plot availability, demand and investment guidance.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 26),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  launchUrlString(
                    'https://wa.me/923300492037'
                    '?text=Hello%20MEMS,%20I%20would%20like%20information%20about%20Sector%20$sector.',
                    mode: LaunchMode.externalApplication,
                  );
                },
                icon: const Icon(Icons.chat_rounded),
                label: const Text('WhatsApp'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF63E67C),
                  side: const BorderSide(color: Color(0xFF34C759)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  launchUrlString(
                    'tel:+923300492037',
                    mode: LaunchMode.externalApplication,
                  );
                },
                icon: const Icon(Icons.phone_rounded),
                label: const Text('Call Now'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD6A84F),
                  side: const BorderSide(color: Color(0xFFD6A84F)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InventoryInformationSection extends StatelessWidget {
  const _InventoryInformationSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1150),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 34),
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x66D6A84F)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.apartment_rounded,
            color: Color(0xFFD6A84F),
            size: 42,
          ),
          const SizedBox(height: 12),

          const Text(
            'More Property Opportunities with MEMS',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFD6A84F),
              fontSize: 27,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'The listings displayed above represent selected plots with confirmed demand information. '
            'Additional opportunities may be available through the MEMS property network.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.6),
          ),

          const SizedBox(height: 28),

          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth < 650
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 18) / 2;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: const _InformationPointCard(
                      icon: Icons.inventory_2_outlined,
                      title: 'Selected Public Listings',
                      description:
                          'Only plots with clear and confirmed demand figures are displayed publicly on the Plot Finder.',
                    ),
                  ),

                  SizedBox(
                    width: cardWidth,
                    child: const _InformationPointCard(
                      icon: Icons.location_city_outlined,
                      title: 'Wider Sector Coverage',
                      description:
                          'MEMS handles property enquiries across C-14, C-15, C-16 and other developing areas of Islamabad.',
                    ),
                  ),

                  SizedBox(
                    width: cardWidth,
                    child: const _InformationPointCard(
                      icon: Icons.account_balance_outlined,
                      title: 'Planned Sector Amenities',
                      description:
                          'Sector layouts include residential blocks, Markaz and commercial areas, apartment sites, schools, mosques, parks and public facilities.',
                    ),
                  ),

                  SizedBox(
                    width: cardWidth,
                    child: const _InformationPointCard(
                      icon: Icons.support_agent_rounded,
                      title: 'Personalised Property Guidance',
                      description:
                          'Our team can assist with location, access, plot category, current demand, documentation and site-visit coordination.',
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 28),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF171717),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x55D6A84F)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 720;

                final message = Column(
                  crossAxisAlignment: isMobile
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Looking for a plot not displayed above?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Contact MEMS to request current inventory and demand information.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                  ],
                );

                final buttons = Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          launchUrlString(
                            'https://wa.me/923300492037'
                            '?text=Hello%20MEMS,%20please%20share%20your%20current%20available%20plot%20inventory.',
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        icon: const Icon(Icons.chat_rounded),
                        label: const Text('Request Inventory'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF63E67C),
                          side: const BorderSide(color: Color(0xFF34C759)),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          launchUrlString(
                            'tel:+923300492037',
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        icon: const Icon(Icons.phone_rounded),
                        label: const Text('Call MEMS'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFD6A84F),
                          side: const BorderSide(color: Color(0xFFD6A84F)),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                );

                if (isMobile) {
                  return Column(
                    children: [message, const SizedBox(height: 20), buttons],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: message),
                    const SizedBox(width: 24),
                    buttons,
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationPointCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InformationPointCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 155),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x44D6A84F)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0x18D6A84F),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0x88D6A84F)),
            ),
            child: Icon(icon, color: const Color(0xFFD6A84F), size: 25),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    height: 1.5,
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
