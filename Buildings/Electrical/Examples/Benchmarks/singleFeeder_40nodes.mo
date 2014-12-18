within Buildings.Electrical.Examples.Benchmarks;
model singleFeeder_40nodes
  extends Buildings.Electrical.Examples.Benchmarks.singleFeeder_nNodes(
    N=40,
    Nload=39,
    Npv=14,
    connMatrix=[1,1; 5,5; 6,6; 10,10; 14,14; 18,18; 19,19; 22,22; 27,27; 29,29;
        31,31; 32,32; 34,34; 39,39],
    network(redeclare
        Buildings.Electrical.Transmission.Benchmarks.Grids.SingleFeeder_40nodes_Al70
        grid));

end singleFeeder_40nodes;
