within Buildings.ThermalZones.Detailed.FLEXLAB.Data.Constructions.OpaqueConstructions.DividingWalls;
record CellAndElectricalDividingWall =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.127),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01905)},
    final nLay = 5) "Wall separating FLEXLAB test cells from the adjoining
      electrical rooms"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datOpaCon",
Documentation(info="<html>
    <p>
    This is a construction of a dividing wall commonly found in FLEXLAB test
    cells. It is used to divide one test cell from another (cell A and cell B)
    as well as separate the test cell from the connected electrical room.
    </p>
    </html>", revisions="<html>
<ul>
<li>
September 17, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
