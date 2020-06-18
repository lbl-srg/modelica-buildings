within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Conditionals;
block UnpopulatedWithOccupancySensor
  "Sets minimum area volume when the zone has an occupancy sensor and is unpopulated"

  parameter Real VOutAreMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s",
    final displayUnit="m3/h") = 0.01
    "Zone minimum outdoor airflow for building area, per California Title 24 prescribed airflow-per-area requirements";

  parameter Real floFra(
    final min=0,
    final max=1) = 0.25
    "Fraction of the zone minimum outdoor airflow";

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VOutMinSet_flow(
    final min=0,
    final max=1,
    final unit="1") "Zone minimum outdoor airflow for building area, per California Title 24 prescribed airflow-per-area requirements"
    annotation (Placement(
        transformation(extent={{60,-20},{100,20}}), iconTransformation(extent={{
            100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=VOutAreMin_flow)
    "Zone minimum outdoor airflow for building area, per California Title 24 prescribed airflow-per-area requirements"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain gai(
    final k=floFra) "Takes a fraction of the zone minimum outdoor airflow for building area"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

equation

  connect(con.y, gai.u)
    annotation (Line(points={{-18,0},{-2,0}}, color={0,0,127}));
  connect(gai.y, VOutMinSet_flow)
    annotation (Line(points={{22,0},{80,0}}, color={0,0,127}));
annotation (
  defaultComponentName = "unpWitOcc",
  Icon(graphics={
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={28,108,200}),
                 Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-60,-40},{60,40}})),
 Documentation(info="<html>
<p>
Determines an airflow setpoint value as a <code>floFra</code> fraction of <code>VOutAreMin_flow</code> for a zone that has an occupancy sensor and is unpopulated. 
The conditional is according to section 5.2.1.4. under b.1.ii, b.2.ii and c.1.
</p>
</html>", revisions="<html>
<ul>
<li>
Jun 20, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end UnpopulatedWithOccupancySensor;
