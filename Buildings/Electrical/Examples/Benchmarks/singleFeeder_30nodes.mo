within Buildings.Electrical.Examples.Benchmarks;
model singleFeeder_30nodes
  extends Buildings.Electrical.Examples.Benchmarks.singleFeeder_nNodes(
    N=30,
    Nload=29,
    Npv=10,
    connMatrix=[1,1; 5,5; 6,6; 10,10; 14,14; 18,18; 19,19; 22,22; 27,27; 29,29],
    network(redeclare
        Buildings.Electrical.Transmission.Benchmarks.Grids.SingleFeeder_30nodes_Al70
        grid));

end singleFeeder_30nodes;
