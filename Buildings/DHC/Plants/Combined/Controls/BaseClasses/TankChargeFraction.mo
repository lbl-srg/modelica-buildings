within Buildings.DHC.Plants.Combined.Controls.BaseClasses;
block TankChargeFraction "Tank charge fraction"
  parameter Integer nTTan
    "Number of tank temperature points"
    annotation (Dialog(connectorSizing=true),HideResult=true);
  parameter Real TTanSet[2, 2](
    each final quantity="ThermodynamicTemperature",
    each final unit="K",
    each displayUnit="degC")
    "Tank temperature setpoints: 2 cycles with 2 setpoints";
  parameter Real fraUslTan(unit="1")
    "Useless fraction of TES";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTan[nTTan](
    final unit=fill("K",nTTan),
    displayUnit=fill("degC", nTTan)) "TES tank temperature"
    annotation (Placement(transformation(extent={{-180,80},{-140,120}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="1") "Tank charge fraction"
    annotation (Placement(transformation(extent={{140,-80},{180,-40}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.MatrixMax rowMax(
    final nRow=2,
    final nCol=2)
    "Row-wise maximum"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.MatrixMin rowMin(
    final nRow=2,
    final nCol=2)
    "Row-wise minimum"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax maxSet(
    final nin=2) "Maximum setpoint temperature"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin minSet(
    final nin=2) "Minimum setpoint temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant temSet[2,2](
    final k=TTanSet)
    "Tank temperature setpoints: 2 cycles with 2 setpoints"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant numTanTemPoi(
    final k=nTTan)
    "Number of tank temperature points"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant useFra(
    final k=fraUslTan)
    "Useless fraction"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nTTan)
    "Replicate the input"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub[nTTan]
    "Find the difference"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(
    final nin=nTTan) "Sum of the input vector"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1 "Find the difference"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1 "Input 1 divided by input 2"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div2 "Input 1 divided by input 2"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Find the difference"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub3
    "Find the difference"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div3
    "Input 1 divided by input 2"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage fraChaTan(
    final delta=5*60)
    "Moving mean of tank charge fraction used for control logic"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

equation
  connect(temSet.y,rowMax. u)
    annotation (Line(points={{-98,60},{-90,60},{-90,20},{-82,20}}, color={0,0,127}));
  connect(temSet.y,rowMin. u)
    annotation (Line(points={{-98,60},{-82,60}}, color={0,0,127}));
  connect(rowMax.y,maxSet. u)
    annotation (Line(points={{-58,20},{-42,20}}, color={0,0,127}));
  connect(rowMin.y,minSet. u)
    annotation (Line(points={{-58,60},{-42,60}}, color={0,0,127}));
  connect(minSet.y, reaScaRep.u)
    annotation (Line(points={{-18,60},{-2,60}},color={0,0,127}));
  connect(reaScaRep.y, sub.u2) annotation (Line(points={{22,60},{30,60},{30,74},
          {38,74}}, color={0,0,127}));
  connect(TTan, sub.u1) annotation (Line(points={{-160,100},{30,100},{30,86},{38,
          86}}, color={0,0,127}));
  connect(sub.y, mulSum.u)
    annotation (Line(points={{62,80},{78,80}}, color={0,0,127}));
  connect(maxSet.y, sub1.u1) annotation (Line(points={{-18,20},{0,20},{0,26},{18,
          26}}, color={0,0,127}));
  connect(minSet.y, sub1.u2)
    annotation (Line(points={{-18,60},{-10,60},{-10,14},{18,14}}, color={0,0,127}));
  connect(sub1.y, div1.u2) annotation (Line(points={{42,20},{80,20},{80,34},{98,
          34}},color={0,0,127}));
  connect(mulSum.y, div1.u1) annotation (Line(points={{102,80},{120,80},{120,60},
          {80,60},{80,46},{98,46}}, color={0,0,127}));
  connect(numTanTemPoi.y, div2.u2) annotation (Line(points={{-98,-70},{-80,-70},
          {-80,-26},{-62,-26}}, color={0,0,127}));
  connect(div1.y, div2.u1) annotation (Line(points={{122,40},{130,40},{130,0},{-80,
          0},{-80,-14},{-62,-14}}, color={0,0,127}));
  connect(div2.y, sub2.u1) annotation (Line(points={{-38,-20},{-20,-20},{-20,-34},
          {18,-34}}, color={0,0,127}));
  connect(useFra.y, sub2.u2) annotation (Line(points={{-38,-70},{-30,-70},{-30,-46},
          {18,-46}}, color={0,0,127}));
  connect(one.y, sub3.u1) annotation (Line(points={{2,-70},{10,-70},{10,-84},{18,
          -84}}, color={0,0,127}));
  connect(useFra.y, sub3.u2) annotation (Line(points={{-38,-70},{-30,-70},{-30,-96},
          {18,-96}}, color={0,0,127}));
  connect(sub2.y, div3.u1) annotation (Line(points={{42,-40},{50,-40},{50,-54},{
          58,-54}}, color={0,0,127}));
  connect(sub3.y, div3.u2) annotation (Line(points={{42,-90},{50,-90},{50,-66},{
          58,-66}}, color={0,0,127}));
  connect(div3.y, fraChaTan.u)
    annotation (Line(points={{82,-60},{98,-60}}, color={0,0,127}));
  connect(fraChaTan.y, y)
    annotation (Line(points={{122,-60},{160,-60}}, color={0,0,127}));

annotation (defaultComponentName="tanChaFra",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-100,100},{100,140}},
          textString="%name")}),
                          Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,120}})),
    Documentation(info="<html>
<p>
The tank charge fraction <code>y</code> is computed as the
5-minute moving average of the following expression:
</p>
<p>
<i>(&sum;<sub>i</sub> (TTan<sub>i</sub> - min(TTanSet)) /
(max(TTanSet) - min(TTanSet)) / nTTan - fraUslTan) /
(1 - fraUslTan)</i>,
</p>
<p>
where <i>TTan<sub>i</sub></i> is the measurement from the <i>i</i>-th temperature sensor
along the vertical axis of the tank,
<code>TTanSet</code> are the tank temperature setpoints (two values for each tank cycle),
<code>nTTan</code> is the number of temperature sensors along the vertical axis of the tank,
<code>fraUslTan</code> is the useless fraction of the tank which is computed as
shown in
<a href=\"modelica://Buildings.DHC.Plants.Combined.Controls.BaseClasses.ModeCondenserLoop\">
Buildings.DHC.Plants.Combined.Controls.BaseClasses.ModeCondenserLoop</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 12, 2025, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end TankChargeFraction;
