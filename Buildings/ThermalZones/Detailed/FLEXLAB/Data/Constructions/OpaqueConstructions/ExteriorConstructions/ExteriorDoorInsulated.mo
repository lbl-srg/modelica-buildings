within Buildings.ThermalZones.Detailed.FLEXLAB.Data.Constructions.OpaqueConstructions.ExteriorConstructions;
record ExteriorDoorInsulated =
   Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.05),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588)},
    final nLay=3) "Model of an insulated exterior door"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datOpaCon",
Documentation(info="<html>
    <p>
    This is a model of an insulated exterior door. It is used in all
    FLEXLAB test cell models.
    </p>
    </html>", revisions="<html>
<ul>
<li>
September 17, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
