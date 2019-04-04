within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences;
block Speed_primary_remoteDp
  "Pump speed control for primary-only plants where the remote DP sensor(s) is hardwired to the plant controller"
  parameter Integer nSen = 2
    "Total number of remote differential pressure sensors";
  parameter Integer nPum = 2
    "Total number of chilled water pumps";
  parameter Real minPumSpe = 0
    "Minimum pump speed";
  parameter Real maxPumSpe = 1
    "Maximum pump speed";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat[nSen](
    each final unit="Pa",
    each final quantity="PressureDifference")
    "Chilled water differential static pressure"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPumSpe(
    final min=0,
    final max=1,
    final unit="1") "Chilled water pump speed"
    annotation (Placement(transformation(extent={{120,50},{140,70}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    final nout=nSen) "Replicate real input"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID[nSen](
    each final yMax=1,
    each final yMin=0,
    each final reverseAction=true,
    each final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    each final y_reset=0) "Pump speed controller"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax maxLoo(
    final nin=nSen) "Maximum DP loop output"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=nSen)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Line pumSpe "Pump speed"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant pumSpe_min(
    final k=minPumSpe) "Minimum pump speed"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant pumSpe_max(
    final k=maxPumSpe) "Maximum pump speed"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nPum] "Logical not"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nu=nPum) "Multiple logical and"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

equation
  connect(dpChiWat, conPID.u_s)
    annotation (Line(points={{-140,0},{18,0}}, color={0,0,127}));
  connect(conPID.y, maxLoo.u)
    annotation (Line(points={{41,0},{58,0}}, color={0,0,127}));
  connect(booRep.y, conPID.trigger)
    annotation (Line(points={{1,-40},{22,-40},{22,-12}}, color={255,0,255}));
  connect(dpChiWatSet, reaRep.u)
    annotation (Line(points={{-140,-80},{-42,-80}}, color={0,0,127}));
  connect(reaRep.y, conPID.u_m)
    annotation (Line(points={{-19,-80},{30,-80},{30,-12}},color={0,0,127}));
  connect(zer.y, pumSpe.x1)
    annotation (Line(points={{1,80},{20,80},{20,68},{58,68}}, color={0,0,127}));
  connect(pumSpe_min.y, pumSpe.f1)
    annotation (Line(points={{-59,80},{-40,80},{-40,64},{58,64}}, color={0,0,127}));
  connect(one.y, pumSpe.x2)
    annotation (Line(points={{-59,40},{-40,40},{-40,56},{58,56}}, color={0,0,127}));
  connect(pumSpe_max.y, pumSpe.f2)
    annotation (Line(points={{1,40},{20,40},{20,52},{58,52}}, color={0,0,127}));
  connect(maxLoo.y, pumSpe.u)
    annotation (Line(points={{81,0},{100,0},{100,40},{40,40},{40,60},{58,60}},
      color={0,0,127}));
  connect(pumSpe.y, yChiWatPumSpe)
    annotation (Line(points={{81,60},{130,60}}, color={0,0,127}));
  connect(not2.y,mulAnd. u)
    annotation (Line(points={{-79,-40},{-62,-40}}, color={255,0,255}));
  connect(uChiWatPum, not2.u)
    annotation (Line(points={{-140,-40},{-102,-40}}, color={255,0,255}));
  connect(mulAnd.y, booRep.u)
    annotation (Line(points={{-38.3,-40},{-22,-40}}, color={255,0,255}));

annotation (
  defaultComponentName="chiPumSpe",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,12},{-44,-10}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiWatPum"),
        Text(
          extent={{-98,90},{-44,68}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWat"),
        Text(
          extent={{22,12},{98,-10}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatPumSpe"),
        Text(
          extent={{-98,-68},{-34,-90}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatSet")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}})),
  Documentation(info="<html>
<p>
Block that enable and disable leading primary chilled water pump, for plants
with headered primary chilled water pumps, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.6 Primary chilled water pumps, part 5.2.6.5 and 5.2.6.6.
</p>
<p>
1. When any chilled water pump is proven on, <code>uChiWatPum</code> = true, 
pump speed will be controlled by a reverse acting PID loop maintaining the
differential pressure signal at a setpoint <code>dpChiWatSet</code>. All pumps
receive the same speed signal. PID loop output shall be mapped from minimum
pump speed (<code>minPumSpe</code>) at 0% to maximum pump speed
(<code>maxPumSpe</code>) at 100%.
</p>
<p>
2. Where multiple differential pressure sensors exist, a PID loop shall run for
each sensor. Chilled water pumps shall be controlled to the high signal output
of all DP sensor loops.
</p>
</html>", revisions="<html>
<ul>
<li>
January 28, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Speed_primary_remoteDp;
