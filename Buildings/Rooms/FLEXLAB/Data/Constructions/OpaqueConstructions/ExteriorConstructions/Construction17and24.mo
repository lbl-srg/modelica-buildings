within Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions.ExteriorConstructions;
record Construction17and24 =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.04752),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
    final nLay = 3) "Wall construction found in XRA"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datOpaCon",
Documentation(info="<html>
    <p>
    This is a model of one of the constructions used in test cell XRA. It
    represents the south wall, and the north wall next to the door.
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
