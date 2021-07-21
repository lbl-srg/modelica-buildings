within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.Validation;
model ActiveAirFlow
  "Validate the model for calculating active airflow setpoint for VAV terminal unit with reheat"
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow
    actAirSet_RehBox(
    VDisCooSetMax_flow=0.075,
    VDisSetMin_flow=0.017,
    VDisHeaSetMax_flow=0.05,
    VDisConMin_flow=0.01,
    AFlo=40,
    have_occSen=true,
    have_winSen=true,
    have_CO2Sen=true)
    "Output the active airflow setpoint for VAV reheat terminal unit"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow
    actAirSet_RehBox1(
    VDisCooSetMax_flow=0.075,
    VDisSetMin_flow=0.017,
    VDisHeaSetMax_flow=0.05,
    VDisConMin_flow=0.01,
    AFlo=40,
    have_occSen=true,
    have_winSen=true,
    have_CO2Sen=true)
    "Output the active airflow setpoint for VAV reheat terminal unit"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp coCon(
    height=400,
    duration=86400,
    offset=500) "CO2 concentration"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    amplitude=2,
    freqHz=1/86400,
    offset=2) "occNum"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta(
    shift=0,
    width=0.2,
    period=90000)
    "Generate signal indicating window status"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=1) "Occupied mode index"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(k=2) "Cool-down mode index"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

equation
  connect(coCon.y,actAirSet_RehBox. ppmCO2)
    annotation (Line(points={{-18,70},{-8,70},{-8,74},{58,74}},
      color={0,0,127}));
  connect(winSta.y,actAirSet_RehBox. uWin)
    annotation (Line(points={{-18,-80},{4,-80},{4,62},{58,62}},
      color={255,0,255}));
  connect(conInt.y, actAirSet_RehBox.uOpeMod)
    annotation (Line(points={{-18,-10},{0,-10},{0,78},{58,78}},
      color={255,127,0}));
  connect(coCon.y, actAirSet_RehBox1.ppmCO2)
    annotation (Line(points={{-18,70},{-8,70},{-8,14},{58,14}},
      color={0,0,127}));
  connect(conInt1.y, actAirSet_RehBox1.uOpeMod)
    annotation (Line(points={{-18,-40},{8,-40},{8,18},{58,18}},
      color={255,127,0}));
  connect(winSta.y, actAirSet_RehBox1.uWin)
    annotation (Line(points={{-18,-80},{4,-80},{4,2},{58,2}},
      color={255,0,255}));
  connect(sine.y, round1.u)
    annotation (Line(points={{-58,30},{-42,30}}, color={0,0,127}));
  connect(round1.y, actAirSet_RehBox.nOcc) annotation (Line(points={{-18,30},{-4,
          30},{-4,66},{58,66}}, color={0,0,127}));
  connect(round1.y, actAirSet_RehBox1.nOcc) annotation (Line(points={{-18,30},{-4,
          30},{-4,6},{58,6}}, color={0,0,127}));

annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Reheat/SetPoints/Validation/ActiveAirFlow.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow</a>
for calculating active minimum and maximum airflow setpoint used in a VAV reheat
terminal unit control.
</p>
</html>", revisions="<html>
<ul>
<li>
February 28, 2020, by Jianjun Hu:<br/>
Changed occupant number input.
</li>
<li>
September 07, 2017, by Jianjun Hu:<br/>
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
end ActiveAirFlow;
