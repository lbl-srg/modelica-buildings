within Buildings.Electrical.Examples.Benchmarks;
model singleFeeder_20nodes
  extends Buildings.Electrical.Examples.Benchmarks.singleFeeder_nNodes(
    N=20,
    Nload=19,
    Npv=7,
    connMatrix=[1,1; 5,5; 6,6; 10,10; 14,14; 18,18; 19,19],
    network(redeclare
        Buildings.Electrical.Transmission.Benchmarks.Grids.SingleFeeder_20nodes_Al70
        grid));

end singleFeeder_20nodes;
