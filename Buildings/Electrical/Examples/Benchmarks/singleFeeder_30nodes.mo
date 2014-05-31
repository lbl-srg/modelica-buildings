within Buildings.Electrical.Examples.Benchmarks;
model singleFeeder_30nodes
  extends Buildings.Electrical.Examples.Benchmarks.singleFeeder_Nnodes(
    N=30,
    Nload=29,
    Npv=10,
    connMatrix=[1,1; 5,5; 6,6; 10,10; 14,14; 18,18; 19,19; 22,22; 27,27; 29,29],
    network(redeclare
        Buildings.Electrical.Transmission.Benchmark.BenchmarkGrids.SingleFeeder_30nodes
        grid));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));

end singleFeeder_30nodes;
