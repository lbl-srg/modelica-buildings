within Buildings.ThermalZones.Detailed.FLEXLAB.Data.Constructions.OpaqueConstructions.ExteriorConstructions;
record Construction10and23 =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.02413),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.08255),
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
    final nLay = 4) "South and north exterior wall in test bed X3"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datOpaCon",
Documentation(info="<html>
    <p>
    This is a model of exterior walls in test bed X3. It is used to
    represent both the north and south exterior wall of the test cells
    themselves.
    </p>
    </html>", revisions="<html>
<ul>
<li>
September 17, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
