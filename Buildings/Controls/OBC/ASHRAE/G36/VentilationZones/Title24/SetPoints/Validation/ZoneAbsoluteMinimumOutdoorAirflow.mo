within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.Validation;
model ZoneAbsoluteMinimumOutdoorAirflow
  "Validates zone absolute outdoor airflow setpoint"

  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneAbsoluteMinimumOutdoorAirflow
    VOutMinZonAbs(have_winSwi=true)
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneAbsoluteMinimumOutdoorAirflow
    VOutMinZonAbs1(have_winSwi=true, have_occSen=true)
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneAbsoluteMinimumOutdoorAirflow
    VOutMinZonAbs2(have_occSen=true)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneAbsoluteMinimumOutdoorAirflow
    VOutMinZonAbs3
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneAbsoluteMinimumOutdoorAirflow
    VOutMinZonAbs4(have_occSen=true, have_CO2Sen=true)
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneAbsoluteMinimumOutdoorAirflow
    VOutMinZonAbs5(have_winSwi=true, have_CO2Sen=true)
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
equation

annotation (
  experiment(StopTime=1200.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/SetPoints/Validation/ExhaustDamper.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ExhaustDamper\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ExhaustDamper</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
Jun 20, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-140},{100,140}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-140},{100,140}})));
end ZoneAbsoluteMinimumOutdoorAirflow;
