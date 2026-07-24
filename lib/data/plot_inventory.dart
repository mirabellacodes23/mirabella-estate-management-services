class PlotListing {
  final String sector;
  final String plotNumber;
  final String demand;
  final String status;

  const PlotListing({
    required this.sector,
    required this.plotNumber,
    required this.demand,
    this.status = 'Available',
  });
}

const List<PlotListing> plotInventory = [
  // C-15
  PlotListing(
    sector: 'C-15',
    plotNumber: '1674',
    demand: 'PKR 6 Crore 35 Lakh',
  ),
  PlotListing(
    sector: 'C-15',
    plotNumber: '1641',
    demand: 'PKR 4 Crore 25 Lakh',
  ),
  PlotListing(sector: 'C-15', plotNumber: '208', demand: 'PKR 3 Crore 25 Lakh'),
  PlotListing(sector: 'C-15', plotNumber: '243', demand: 'PKR 3 Crore 25 Lakh'),
  PlotListing(sector: 'C-15', plotNumber: '310', demand: 'PKR 3 Crore 75 Lakh'),

  // C-16/2
  PlotListing(
    sector: 'C-16/2',
    plotNumber: '2167',
    demand: 'PKR 2 Crore 75 Lakh',
  ),
  PlotListing(
    sector: 'C-16/2',
    plotNumber: '2215',
    demand: 'PKR 2 Crore 95 Lakh',
  ),
  PlotListing(
    sector: 'C-16/2',
    plotNumber: '1989',
    demand: 'PKR 2 Crore 70 Lakh',
  ),

  // C-16/3
  PlotListing(
    sector: 'C-16/3',
    plotNumber: '2740-C',
    demand: 'PKR 3 Crore 90 Lakh',
  ),
  PlotListing(
    sector: 'C-16/3',
    plotNumber: '2526',
    demand: 'PKR 4 Crore 15 Lakh',
  ),

  // C-16/4
  PlotListing(
    sector: 'C-16/4',
    plotNumber: '3599-C',
    demand: 'PKR 2 Crore 95 Lakh',
  ),
  PlotListing(
    sector: 'C-16/4',
    plotNumber: '3811',
    demand: 'PKR 2 Crore 90 Lakh',
  ),
  PlotListing(
    sector: 'C-16/4',
    plotNumber: '3711',
    demand: 'PKR 2 Crore 55 Lakh',
  ),
];
