within Buildings.Electrical.Transmission.Grids;
record TestGrid2Nodes "Simple model of a 2-nodes 1-link grid"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    Nnodes=2,
    Nlinks=1,
    FromTo=[[1,2]],
    L={200},
    cables={LowVoltageCables.Cu35()});
end TestGrid2Nodes;
