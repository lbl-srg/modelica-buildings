within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.Validation;
model EnableProcesses
  "Validation sequence of tower cells enabling process"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableProcesses
    towCelStaPro
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[4](
    final k=fill(0,4)) "Constant zero"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2[4](
    final k={0,2,3,0}) "Enabling cells index"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp1 "Chiller stage up status"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.15,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3[4](
    final k=fill(false,4))
    "Initial tower cell status"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[4] "Logical switch"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=4) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt[4]
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[4](
    final samplePeriod=fill(5,4))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));

equation
  connect(booPul2.y, staUp1.u)
    annotation (Line(points={{-98,-20},{-82,-20}}, color={255,0,255}));
  connect(staUp1.y, booRep.u)
    annotation (Line(points={{-58,-20},{-42,-20}}, color={255,0,255}));
  connect(booRep.y, swi.u2)
    annotation (Line(points={{-18,-20},{-10,-20},{-10,50},{-2,50}}, color={255,0,255}));
  connect(con2.y, swi.u1)
    annotation (Line(points={{-58,70},{-20,70},{-20,58},{-2,58}}, color={0,0,127}));
  connect(con.y, swi.u3)
    annotation (Line(points={{-58,30},{-20,30},{-20,42},{-2,42}}, color={0,0,127}));
  connect(swi.y, reaToInt.u)
    annotation (Line(points={{22,50},{38,50}}, color={0,0,127}));
  connect(reaToInt.y, towCelStaPro.uCelInd)
    annotation (Line(points={{62,50},{70,50},{70,28},{78,28}}, color={255,127,0}));
  connect(staUp1.y, towCelStaPro.uEnaCel)
    annotation (Line(points={{-58,-20},{-50,-20},{-50,16},{78,16}}, color={255,0,255}));
  connect(con3.y, towCelStaPro.uTowSta)
    annotation (Line(points={{-58,-60},{60,-60},{60,12},{78,12}}, color={255,0,255}));
  connect(towCelStaPro.yIsoVal, zerOrdHol.u)
    annotation (Line(points={{102,20},{118,20}}, color={0,0,127}));
  connect(zerOrdHol.y, towCelStaPro.uIsoVal)
    annotation (Line(points={{142,20},{150,20},{150,0},{70,0},{70,24},{78,24}},
      color={0,0,127}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Tower/Staging/Subsequences/Validation/EnableProcesses.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableProcesses\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableProcesses</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 12, 2019, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{160,100}})));
end EnableProcesses;
