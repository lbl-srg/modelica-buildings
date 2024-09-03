within Buildings.ThermalZones.Detailed.FLEXLAB.Data.Constructions.OpaqueConstructions.Roofs;
record ASHRAE_901_2010Roof =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.016),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127)},
    final nLay=3) "Construction model for a roof minimally compliant with ASHRAE
    90.1-2010. Used in test cells X3A, X3B, and XRA"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datOpaCon",
Documentation(info="<html>
    <p>
    This is a model of a roof which is minimally compliant with ASHRAE 90.1-2010.
    It is used in the bed X3 and test cell XRA.
    </p>
    <p>
    Note: This model is currently a work in progress. For more information see
    the documentation available at
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
