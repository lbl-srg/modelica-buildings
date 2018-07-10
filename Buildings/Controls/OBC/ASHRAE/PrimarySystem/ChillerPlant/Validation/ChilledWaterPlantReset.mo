within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Validation;
model ChilledWaterPlantReset
  "Validate model of generating chilled water plant reset"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChilledWaterPlantReset
    chiWatPlaRes "Chilled water plant reset"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uChiWatPum[2](
    k={true,false}) "Plant status"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    amplitude=6,
    freqHz=1/3600) "Block generates sine signal"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=5,
    duration=7200)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
    amplitude=6,
    freqHz=1/5400) "Block generates sine signal"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    period=3600,
    width=0.18333333) "Generate pulse signal of type Boolean"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch between two Real signals"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=0)
    "Zero request when device is OFF"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round3(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real to integer"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChilledWaterPlantReset
    chiWatPlaRes1 "Chilled water plant reset"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(nout=2)
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

equation
  connect(uChiWatPum.y, chiWatPlaRes.uChiWatPum)
    annotation (Line(points={{-39,80},{60,80},{60,76},{78,76}},
      color={255,0,255}));
  connect(sine.y,abs. u)
    annotation (Line(points={{-79,50},{-62,50}}, color={0,0,127}));
  connect(abs.y,round2. u)
    annotation (Line(points={{-39,50},{-22,50}}, color={0,0,127}));
  connect(round2.y,reaToInt1. u)
    annotation (Line(points={{1,50},{18,50}}, color={0,0,127}));
  connect(con1.y,swi. u1)
    annotation (Line(points={{-79,-50},{-74,-50},{-74,-42},{-62,-42}},
      color={0,0,127}));
  connect(sine1.y,swi. u3)
    annotation (Line(points={{-79,-80},{-70,-80},{-70,-58},{-62,-58}},
      color={0,0,127}));
  connect(swi.y,abs1. u)
    annotation (Line(points={{-39,-50},{-30,-50},{-30,-80},{-22,-80}},
      color={0,0,127}));
  connect(booPul.y,swi. u2)
    annotation (Line(points={{-79,-20},{-70,-20},{-70,-50},{-62,-50}},
      color={255,0,255}));
  connect(booPul.y,not1. u)
    annotation (Line(points={{-79,-20},{-22,-20}},color={255,0,255}));
  connect(abs1.y,round3. u)
    annotation (Line(points={{1,-80},{18,-80}}, color={0,0,127}));
  connect(round3.y,reaToInt3. u)
    annotation (Line(points={{41,-80},{50,-80},{50,-62},{8,-62},{8,-50},{18,-50}},
      color={0,0,127}));
  connect(not1.y, booRep.u)
    annotation (Line(points={{1,-20},{18,-20}}, color={255,0,255}));
  connect(booRep.y, chiWatPlaRes1.uChiWatPum)
    annotation (Line(points={{41,-20},{60,-20},{60,-24},{78,-24}},
      color={255,0,255}));
  connect(reaToInt1.y, chiWatPlaRes.TChiWatSupResReq)
    annotation (Line(points={{41,50},{60,50},{60,70},{78,70}},
      color={255,127,0}));
  connect(reaToInt2.y, chiWatPlaRes.uChiSta)
    annotation (Line(points={{41,20},{66,20},{66,64},{78,64}},
      color={255,127,0}));
  connect(reaToInt3.y, chiWatPlaRes1.TChiWatSupResReq)
    annotation (Line(points={{41,-50},{60,-50},{60,-30},{78,-30}},
      color={255,127,0}));
  connect(reaToInt2.y, chiWatPlaRes1.uChiSta)
    annotation (Line(points={{41,20},{66,20},{66,-36},{78,-36}},
      color={255,127,0}));
  connect(ram.y, round1.u)
    annotation (Line(points={{-39,20},{-22,20}}, color={0,0,127}));
  connect(round1.y, reaToInt2.u)
    annotation (Line(points={{1,20},{18,20}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Validation/ChilledWaterPlantReset.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChilledWaterPlantReset\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChilledWaterPump</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 14, 2018, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChilledWaterPlantReset;
