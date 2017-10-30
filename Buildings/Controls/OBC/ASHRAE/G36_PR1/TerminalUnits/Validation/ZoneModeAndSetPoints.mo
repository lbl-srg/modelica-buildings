within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Validation;
model ZoneModeAndSetPoints
  "Validation models of reseting zone setpoint temperature"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ZoneModeAndSetPoints
    zoneSetPoints(
    numZon=2,
    cooAdj=true,
    heaAdj=true,
    sinAdj=false) "Output resetted zone setpoint remperature"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch "Occupancy schedule"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Modelica.Blocks.Sources.Sine heaSetAdj(freqHz=1/28800, amplitude=0.5)
    "Heating setpoint adjustment"
    annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
  Modelica.Blocks.Sources.Sine cooSetAdj(freqHz=1/28800)
    "Cooling setpoint adjustment"
    annotation (Placement(transformation(extent={{-46,30},{-26,50}})));
  Modelica.Blocks.Sources.Sine TZon1(
    amplitude=5,
    offset=18 + 273.15,
    freqHz=1/86400) "Zone 1 temperature"
    annotation (Placement(transformation(extent={{-88,30},{-68,50}})));
  Modelica.Blocks.Sources.Sine TZon2(
    offset=18 + 273.15,
    freqHz=1/86400,
    amplitude=7.5) "Zone 2 temperature"
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));

equation
  connect(occSch.tNexOcc, zoneSetPoints.tNexOcc)
    annotation (Line(points={{-69,86},{-48,86},{-48,88},{-2,88}},
      color={0,0,127}));
  connect(occSch.occupied, zoneSetPoints.uOcc)
    annotation (Line(points={{-69,74},{-48,74},{-48,72.025},{-2,72.025}},
      color={255,0,255}));
  connect(TZon1.y, zoneSetPoints.TZon[1])
    annotation (Line(points={{-67,40},{-56,40},{-56,83.0125},{-2,83.0125}},
      color={0,0,127}));
  connect(TZon2.y, zoneSetPoints.TZon[2])
    annotation (Line(points={{-67,0},{-56,0},{-56,85.0375},{-2,85.0375}},
      color={0,0,127}));
  connect(cooSetAdj.y, zoneSetPoints.setAdj)
    annotation (Line(points={{-25,40},{-20,40},{-20,80},{-2,80}},
      color={0,0,127}));
  connect(heaSetAdj.y, zoneSetPoints.heaSetAdj)
    annotation (Line(points={{-25,0},{-16,0},{-16,76},{-2,76}},
      color={0,0,127}));

annotation (experiment(StopTime=86400.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Validation/ZoneModeAndSetPoints.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ZoneModeAndSetPoints\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ZoneModeAndSetPoints</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ZoneModeAndSetPoints;
