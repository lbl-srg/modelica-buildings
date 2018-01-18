within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Validation;
model ModeAndSetPoints
  "Validation models of reseting zone setpoint temperature"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints
    setPoi(
    numZon=2,
    cooAdj=true,
    heaAdj=true)
    "Output resetted zone setpoint remperature"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints
    setPoi1(
    numZon=2,
    have_occSen=true,
    have_winSen=true)
    "Output resetted zone setpoint remperature"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Controls.SetPoints.OccupancySchedule occSch "Occupancy schedule"
    annotation (Placement(transformation(extent={{-90,72},{-70,92}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine  heaSetAdj[2](
    each freqHz=1/28800,
    each amplitude=0.5)
    "Heating setpoint adjustment"
    annotation (Placement(transformation(extent={{-46,0},{-26,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine cooSetAdj[2](
    each freqHz=1/28800)
    "Cooling setpoint adjustment"
    annotation (Placement(transformation(extent={{-46,40},{-26,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TZon1(
    amplitude=5,
    offset=18 + 273.15,
    freqHz=1/86400) "Zone 1 temperature"
    annotation (Placement(transformation(extent={{-88,40},{-68,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TZon2(
    offset=18 + 273.15,
    freqHz=1/86400,
    amplitude=7.5) "Zone 2 temperature"
    annotation (Placement(transformation(extent={{-88,0},{-68,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta1(k=false)
    "Window status"
    annotation (Placement(transformation(extent={{-88,-80},{-68,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta2(k=true)
    "Window status"
    annotation (Placement(transformation(extent={{-46,-80},{-26,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant occSen1(k=false)
    "Occupancy sensor"
    annotation (Placement(transformation(extent={{-88,-40},{-68,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant occSen2(k=true)
    "Occupancy sensor"
    annotation (Placement(transformation(extent={{-46,-40},{-26,-20}})));

equation
  connect(occSch.tNexOcc, setPoi.tNexOcc)
    annotation (Line(points={{-69,88},{19,88}},
      color={0,0,127}));
  connect(occSch.occupied, setPoi.uOcc)
    annotation (Line(points={{-69,76},{-48,76},{-48,76.025},{19,76.025}},
      color={255,0,255}));
  connect(TZon1.y, setPoi.TZon[1])
    annotation (Line(points={{-67,50},{-56,50},{-56,84.5},{19,84.5}},
      color={0,0,127}));
  connect(TZon2.y, setPoi.TZon[2])
    annotation (Line(points={{-67,10},{-56,10},{-56,85.5},{19,85.5}},
      color={0,0,127}));
  connect(cooSetAdj.y, setPoi.setAdj)
    annotation (Line(points={{-25,50},{-20,50},{-20,82},{19,82}},
      color={0,0,127}));
  connect(heaSetAdj.y, setPoi.heaSetAdj)
    annotation (Line(points={{-25,10},{-16,10},{-16,79},{19,79}},
      color={0,0,127}));
  connect(occSch.tNexOcc, setPoi1.tNexOcc)
    annotation (Line(points={{-69,88},{0,88},{0,48},{19,48}},
      color={0,0,127}));
  connect(occSch.occupied, setPoi1.uOcc)
    annotation (Line(points={{-69,76},{-4,76},{-4,36.025},{19,36.025}},
      color={255,0,255}));
  connect(TZon1.y, setPoi1.TZon[1])
    annotation (Line(points={{-67,50},{-56,50},{-56,32},{-12,32},{-12,44.5},
      {19,44.5}}, color={0,0,127}));
  connect(TZon2.y, setPoi1.TZon[2])
    annotation (Line(points={{-67,10},{-56,10},{-56,32},{-12,32},{-12,45.5},
      {19,45.5}}, color={0,0,127}));
  connect(occSen1.y, setPoi1.uOccSen[1])
    annotation (Line(points={{-67,-30},{-60,-30},{-60,-12},{-4,-12},{-4,32.5},
      {19,32.5}}, color={255,0,255}));
  connect(occSen2.y, setPoi1.uOccSen[2])
    annotation (Line(points={{-25,-30},{-4,-30},{-4,33.5},{19,33.5}},
      color={255,0,255}));
  connect(winSta1.y, setPoi1.uWinSta[1])
    annotation (Line(points={{-67,-70},{-60,-70},{-60,-48},{0,-48},{0,30.5},
      {19,30.5}}, color={255,0,255}));
  connect(winSta2.y, setPoi1.uWinSta[2])
    annotation (Line(points={{-25,-70},{-20,-70},{-20,-48},{0,-48},{0,31.5},
      {19,31.5}}, color={255,0,255}));

annotation (experiment(StopTime=86400.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Validation/ModeAndSetPoints.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
 Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{50,86},{126,76}},
          lineColor={85,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="No window status sensor
No occupancy sensor"), Text(
          extent={{48,44},{102,36}},
          lineColor={85,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="No local setpoint adjustment")}),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}}),
                   Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}));
end ModeAndSetPoints;
