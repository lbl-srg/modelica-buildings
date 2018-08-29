within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.Validation;
model ActiveAirFlow
  "Validate the model for calculating active airflow setpoint for VAV terminal unit with reheat"
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow
    actAirSet_RehBox(
    VCooMax=0.075,
    VMin=0.017,
    VHeaMax=0.05,
    VMinCon=0.01,
    AFlo=40,
    have_occSen=true,
    have_winSen=true,
    have_CO2Sen=true)
    "Output the active airflow setpoint for VAV reheat terminal unit"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow
    actAirSet_RehBox1(
    VCooMax=0.075,
    VMin=0.017,
    VHeaMax=0.05,
    VMinCon=0.01,
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
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta(
    startTime=0,
    width=0.2,
    period=90000)
    "Generate signal indicating window status"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=1) "Occupied mode index"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(k=2) "Cool-down mode index"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

equation
  connect(coCon.y,actAirSet_RehBox. ppmCO2)
    annotation (Line(points={{-19,70},{-8,70},{-8,76},{59,76}},
      color={0,0,127}));
  connect(winSta.y,actAirSet_RehBox. uWin)
    annotation (Line(points={{-19,-80},{4,-80},{4,63},{59,63}},
      color={255,0,255}));
  connect(sine.y,actAirSet_RehBox. nOcc)
    annotation (Line(points={{-19,30},{-4,30},{-4,72},{59,72}},
      color={0,0,127}));
  connect(conInt.y, actAirSet_RehBox.uOpeMod)
    annotation (Line(points={{-19,-10},{0,-10},{0,67},{59,67}},
      color={255,127,0}));
  connect(coCon.y, actAirSet_RehBox1.ppmCO2)
    annotation (Line(points={{-19,70},{-8,70},{-8,16},{59,16}},
      color={0,0,127}));
  connect(sine.y, actAirSet_RehBox1.nOcc)
    annotation (Line(points={{-19,30},{-4,30},{-4,12},{59,12}},
      color={0,0,127}));
  connect(conInt1.y, actAirSet_RehBox1.uOpeMod)
    annotation (Line(points={{-19,-40},{8,-40},{8,7},{59,7}},
      color={255,127,0}));
  connect(winSta.y, actAirSet_RehBox1.uWin)
    annotation (Line(points={{-19,-80},{4,-80},{4,3},{59,3}},
      color={255,0,255}));

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
