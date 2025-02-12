within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Validation;
model Setpoint
  "Validation sequence of specifying condener return water temperature setpoint"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Setpoint
    conWatRetSet(
    nChi=2,
    LIFT_min={12,14},
    TConWatRet_nominal={303.15,305.15})
    "Specify condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    width=0.15,
    period=3600)
    "Generate boolean pulse"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    k=false) "Constant false"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp parLoaRat(
    height=0.6,
    duration=3600)
    "Partial load ratio"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatSupSet(
    k=273.15 + 6.5)
    "Chilled water supply setpoint"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

equation
  connect(booPul.y, not1.u)
    annotation (Line(points={{-58,60},{-42,60}}, color={255,0,255}));
  connect(not1.y, conWatRetSet.uChi[1])
    annotation (Line(points={{-18,60},{50,60},{50,27.5},{58,27.5}},
      color={255,0,255}));
  connect(con.y, conWatRetSet.uChi[2])
    annotation (Line(points={{-18,30},{40,30},{40,28.5},{58,28.5}},
      color={255,0,255}));
  connect(not1.y, swi.u2)
    annotation (Line(points={{-18,60},{-10,60},{-10,-20},{-2,-20}},
      color={255,0,255}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-58,-40},{-20,-40},{-20,-28},{-2,-28}},
      color={0,0,127}));
  connect(parLoaRat.y, swi.u1)
    annotation (Line(points={{-58,0},{-20,0},{-20,-12},{-2,-12}}, color={0,0,127}));
  connect(swi.y, conWatRetSet.uOpeParLoaRat)
    annotation (Line(points={{22,-20},{30,-20},{30,23},{58,23}}, color={0,0,127}));
  connect(chiWatSupSet.y, conWatRetSet.TChiWatSupSet)
    annotation (Line(points={{22,-60},{40,-60},{40,17},{58,17}}, color={0,0,127}));
  connect(not1.y, conWatRetSet.uPla)
    annotation (Line(points={{-18,60},{50,60},{50,12},{58,12}}, color={255,0,255}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/FanSpeed/ReturnWaterTemperature/Subsequences/Validation/Setpoint.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Setpoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Setpoint</a>.
</p>
<p>
It shows the calculation of the condenser water return temperature setpoint for the
case that the plant is enabled at 540 seconds.
</p>
<ul>
<li>
Before 540 seconds, the plant is not enabled so the calculation of the
setpoint is not valid.
</li>
<li>
In the period from 540 to 1140 seconds, the setpoint equals to the
minimum nominal condenser water return temperature minus
10 &deg;F.
</li>
<li>
In the period from 1140 to 1740 seconds, the setpoint ramps from
value of previous period to the one caluclated by the
equations showing in the validating model.
</li>
<li>
After 1740 seconds, the setpoint is calculated by the equations
showing in the validating model.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 12, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})));
end Setpoint;
