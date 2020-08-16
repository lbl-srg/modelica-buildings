within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.Validation;
model ZoneAbsoluteMinimumOutdoorAirflow
  "Validates zone absolute outdoor airflow setpoint"

  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneAbsoluteMinimumOutdoorAirflow
    VOutMinZonAbs(have_winSwi=true)
    "Determines zone absolute minimum outdoor air setpoint for a zone with a window switch"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneAbsoluteMinimumOutdoorAirflow
    VOutMinZonAbs1(have_winSwi=true, have_occSen=true)
    "Determines zone absolute minimum outdoor air setpoint for a zone with a window switch and an occupancy sensor"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneAbsoluteMinimumOutdoorAirflow
    VOutMinZonAbs2(have_occSen=true)
    "Determines zone absolute minimum outdoor air setpoint for a zone with an occupancy sensor"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneAbsoluteMinimumOutdoorAirflow
    VOutMinZonAbs3
    "Determines zone absolute minimum outdoor air setpoint for a zone without any sensors"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneAbsoluteMinimumOutdoorAirflow
    VOutMinZonAbs4(have_occSen=true, have_CO2Sen=true)
    "Determines zone absolute minimum outdoor air setpoint for a zone with an occupancy and a CO2 sensor"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneAbsoluteMinimumOutdoorAirflow
    VOutMinZonAbs5(have_winSwi=true, have_CO2Sen=true)
    "Determines zone absolute minimum outdoor air setpoint for a zone with a window switch and a CO2 sensor"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  CDL.Logical.Sources.Pulse occSig(period=60) "Occupancy signal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  CDL.Logical.Sources.Pulse winSig(period=120, startTime=30)
    "Window open or closed signal"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  CDL.Continuous.Sources.Constant VOutMinDes(final k=0.15)
    "Zone design minimum outdoor airflow"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation

  connect(VOutMinDes.y, VOutMinZonAbs.VOutMinZonDes_flow) annotation (Line(
        points={{-58,70},{0,70},{0,104},{18,104}}, color={0,0,127}));
  connect(winSig.y, VOutMinZonAbs.uWin) annotation (Line(points={{-18,110},{0,110},
          {0,112},{18,112}}, color={255,0,255}));
  connect(winSig.y, VOutMinZonAbs1.uWin) annotation (Line(points={{-18,110},{-2,
          110},{-2,72},{18,72}}, color={255,0,255}));
  connect(occSig.y, VOutMinZonAbs1.uOcc) annotation (Line(points={{-18,50},{8,50},
          {8,78},{18,78}}, color={255,0,255}));
  connect(VOutMinDes.y, VOutMinZonAbs1.VOutMinZonDes_flow) annotation (Line(
        points={{-58,70},{-2,70},{-2,64},{18,64}}, color={0,0,127}));
  connect(VOutMinDes.y, VOutMinZonAbs2.VOutMinZonDes_flow) annotation (Line(
        points={{-58,70},{-2,70},{-2,24},{18,24}}, color={0,0,127}));
  connect(occSig.y, VOutMinZonAbs2.uOcc) annotation (Line(points={{-18,50},{-10,
          50},{-10,38},{18,38}}, color={255,0,255}));
  connect(occSig.y, VOutMinZonAbs4.uOcc) annotation (Line(points={{-18,50},{-10,
          50},{-10,-42},{18,-42}}, color={255,0,255}));
  connect(VOutMinDes.y, VOutMinZonAbs3.VOutMinZonDes_flow) annotation (Line(
        points={{-58,70},{-54,70},{-54,-16},{18,-16}}, color={0,0,127}));
  connect(winSig.y, VOutMinZonAbs5.uWin) annotation (Line(points={{-18,110},{-6,
          110},{-6,-88},{18,-88}}, color={255,0,255}));
annotation (
  experiment(
      StopTime=600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/VentilationZones/Title24/SetPoints/Validation/ZoneAbsoluteMinimumOutdoorAirflow.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneAbsoluteMinimumOutdoorAirflow\">
Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints.ZoneAbsoluteMinimumOutdoorAirflow</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
Jun 20, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
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
