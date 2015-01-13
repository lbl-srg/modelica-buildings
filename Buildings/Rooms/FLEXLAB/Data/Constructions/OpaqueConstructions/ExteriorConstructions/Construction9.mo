within Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions.ExteriorConstructions;
record Construction9 =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.06985),
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
    final nLay = 3) "South wall in test bed X1"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datOpaCon",
Documentation(info="<html>
    <p>
    This is a model of the south wall in test bed X1.
    </p>
    </html>", revisions="<html>
<ul>
<li>
December 12, 2014, by Michael Wetter:<br/>
Corrected wrong number of layers.
</li>
<li>
September 17, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
