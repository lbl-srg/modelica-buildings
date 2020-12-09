within Buildings.ThermalZones.Detailed.FLEXLAB.Data.Constructions.OpaqueConstructions.Roofs;
record CA_T24_2013Roof =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.016),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127)},
    final nLay=3) "Construction model for a roof minimally compliant with CA Title 24-2013.
      Used in test cells X2A and X2B"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datOpaCon",
Documentation(info="<html>
    <p>
    This is a model of a roof construction which is minimally compliant with
    CA Title 24-2013. It is used in test bed 90X2.
    </p>
    <p>
    Note: This model is currently a work in progress. For more information see
    the documentation available at
    <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.UsersGuide\">
    Buildings.ThermalZones.Detailed.FLEXLAB.UsersGuide</a>.
    </p>
    </html>", revisions="<html>
<ul>
<li>
September 17, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
