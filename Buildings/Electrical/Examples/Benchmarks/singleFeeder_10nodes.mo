within Buildings.Electrical.Examples.Benchmarks;
model singleFeeder_10nodes
  extends Buildings.Electrical.Examples.Benchmarks.singleFeeder_nNodes(
    N=10,
    Nload=9,
    Npv=3,
    connMatrix=[1,1; 5,5; 6,6],
    network(redeclare
        Buildings.Electrical.Transmission.Benchmarks.BenchmarkGrids.SingleFeeder_10nodes
        grid));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));

end singleFeeder_10nodes;
