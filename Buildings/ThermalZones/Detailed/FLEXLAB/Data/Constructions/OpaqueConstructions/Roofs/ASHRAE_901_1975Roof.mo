within Buildings.ThermalZones.Detailed.FLEXLAB.Data.Constructions.OpaqueConstructions.Roofs;
record ASHRAE_901_1975Roof =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.016),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.09652),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127)},
    final nLay=3) "Construction model for a roof minimally compliant with ASHRAE 90.1-1975.
      Used in test cells X1A and X1B"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datOpaCon",
Documentation(info="<html>
    <p>
    This is a model of a roof which is minimally compliant with ASHRAE 90.1-1975. It is used
    to model the roof in test bed X1.
    </p>
    <p>
    This model is not currently completed. For more information see the future work list at
    <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.UsersGuide\">
    Buildings.ThermalZones.Detailed.FLEXLAB.UsersGuide</a>.
</html>",
revisions="<html>
<ul>
<li>
September 17, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
