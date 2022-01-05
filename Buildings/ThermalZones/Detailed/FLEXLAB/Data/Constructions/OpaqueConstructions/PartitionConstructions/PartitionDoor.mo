within Buildings.ThermalZones.Detailed.FLEXLAB.Data.Constructions.OpaqueConstructions.PartitionConstructions;
record PartitionDoor =
   Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588)},
    final nLay=2) "Model of a partition door. Air is neglected"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datOpaCon",
Documentation(info="<html>
    <p>
    This is a model of a parition door. It is used in every test cell
    as the door between the cell itself and the closet.
    </p>
    </html>", revisions="<html>
<ul>
<li>
September 17, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
