within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Validation;
model ModeAndSetPoints
  "Validation models of reseting the zone setpoint temperature"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints setPoi(
      cooAdj=true, heaAdj=true) "Output resetted zone setpoint remperature"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints setPoi1(
      have_occSen=true, have_winSen=true)
    "Output resetted zone setpoint remperature"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Controls.SetPoints.OccupancySchedule occSch "Occupancy schedule"
    annotation (Placement(transformation(extent={{-90,72},{-70,92}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine heaSetAdj(
   freqHz=1/28800,
   amplitude=0.5) "Heating setpoint adjustment"
    annotation (Placement(transformation(extent={{-46,0},{-26,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine cooSetAdj(
    freqHz=1/28800) "Cooling setpoint adjustment"
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
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints setPoi3(
      have_occSen=true, have_winSen=true)
    "Output resetted zone setpoint remperature"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints setPoi2(
      cooAdj=true, heaAdj=true) "Output resetted zone setpoint remperature"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

equation
  connect(cooSetAdj.y, setPoi.setAdj)
    annotation (Line(points={{-24,50},{-20,50},{-20,80},{18,80}},
      color={0,0,127}));
  connect(heaSetAdj.y, setPoi.heaSetAdj)
    annotation (Line(points={{-24,10},{-16,10},{-16,77},{18,77}},
      color={0,0,127}));

  connect(occSen2.y, setPoi3.uOccSen) annotation (Line(points={{-24,-30},{-2,-30},
          {-2,-56},{18,-56}},      color={255,0,255}));
  connect(winSta2.y, setPoi3.uWinSta) annotation (Line(points={{-24,-70},{-2,-70},
          {-2,-59},{18,-59}},      color={255,0,255}));
  connect(setPoi3.TZon, TZon2.y) annotation (Line(points={{18,-47},{6,-47},{6,-6},
          {-20,-6},{-20,-8},{-60,-8},{-60,10},{-66,10}},     color={0,0,127}));
  connect(setPoi2.TZon, TZon2.y) annotation (Line(points={{18,-7},{6,-7},{6,-6},
          {-20,-6},{-20,-8},{-60,-8},{-60,10},{-66,10}},     color={0,0,127}));
  connect(cooSetAdj.y, setPoi2.setAdj) annotation (Line(points={{-24,50},{-20,50},
          {-20,0},{10,0},{10,-10},{18,-10}},   color={0,0,127}));
  connect(heaSetAdj.y, setPoi2.heaSetAdj) annotation (Line(points={{-24,10},{12,
          10},{12,-13},{18,-13}},    color={0,0,127}));
  connect(TZon1.y, setPoi.TZon) annotation (Line(points={{-66,50},{-60,50},{-60,
          83},{18,83}},     color={0,0,127}));
  connect(setPoi1.TZon, setPoi.TZon) annotation (Line(points={{18,43},{-12,43},{
          -12,32},{-60,32},{-60,83},{18,83}},  color={0,0,127}));
  connect(occSch.tNexOcc, setPoi.tNexOcc)
    annotation (Line(points={{-69,88},{-26,88},{-26,89},{18,89}},
                                                color={0,0,127}));
  connect(occSch.tNexOcc, setPoi1.tNexOcc) annotation (Line(points={{-69,88},{4,
          88},{4,49},{18,49}},    color={0,0,127}));
  connect(setPoi2.tNexOcc, setPoi1.tNexOcc) annotation (Line(points={{18,-1},{4,
          -1},{4,49},{18,49}},    color={0,0,127}));
  connect(setPoi3.tNexOcc, setPoi1.tNexOcc) annotation (Line(points={{18,-41},{4,
          -41},{4,49},{18,49}},    color={0,0,127}));
  connect(occSch.occupied, setPoi.uOcc) annotation (Line(points={{-69,76},{-26,76},
          {-26,86.025},{18,86.025}},         color={255,0,255}));
  connect(occSch.occupied, setPoi1.uOcc) annotation (Line(points={{-69,76},{-6,76},
          {-6,46.025},{18,46.025}},        color={255,0,255}));
  connect(occSch.occupied, setPoi2.uOcc) annotation (Line(points={{-69,76},{-6,76},
          {-6,-3.975},{18,-3.975}},          color={255,0,255}));
  connect(occSch.occupied, setPoi3.uOcc) annotation (Line(points={{-69,76},{-6,76},
          {-6,-43.975},{18,-43.975}},        color={255,0,255}));
  connect(occSen1.y, setPoi1.uOccSen) annotation (Line(points={{-66,-30},{-58,-30},
          {-58,-14},{-10,-14},{-10,34},{18,34}},      color={255,0,255}));
  connect(winSta1.y, setPoi1.uWinSta) annotation (Line(points={{-66,-70},{-60,-70},
          {-60,-48},{0,-48},{0,31},{18,31}},      color={255,0,255}));
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
No occupancy sensor
Zone 1"),              Text(
          extent={{48,44},{102,36}},
          lineColor={85,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="No local setpoint adjustment
Zone 1"),              Text(
          extent={{46,-46},{100,-54}},
          lineColor={85,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="No local setpoint adjustment
Zone 2"),                                                      Text(
          extent={{48,-4},{124,-14}},
          lineColor={85,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="No window status sensor
No occupancy sensor
Zone 2")}),
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
