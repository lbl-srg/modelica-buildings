within Buildings.ThermalZones.Detailed.FLEXLAB.Data.Constructions.OpaqueConstructions.DividingWalls;
record TestBedDividingWall =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.127),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.127),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.127),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.1588)},
    nLay = 10) "Wall separating test beds"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datOpaCon",
Documentation(info="<html>
    <p>
    This is a dividing wall commonly found in FLEXLAB test cells.
    It is used to separate one test cell from another (For example,
    it is found between test cells X2B and X3A).
    </p>
    </html>", revisions="<html>
<ul>
<li>
September 17, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
