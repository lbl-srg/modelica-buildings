within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.Generic;
block ChangeStatus "Sequence to change pump status"

  parameter Integer nPum = 2
    "Total number of pumps";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotWatPum[nPum]
    "Hot water pump status"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uNexLagPumSta
    "Status of next lag pump"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
        iconTransformation(extent={{-140,58},{-100,98}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLasLagPumSta
    "Status of last lag pump"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
        iconTransformation(extent={{-140,18},{-100,58}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uNexLagPum
    "Index of next lag pump"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uLasLagPum
    "Index of last lag pump"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHotWatPum[nPum]
    "Hot water pump status"
    annotation (Placement(transformation(extent={{160,0},{200,40}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumStaCom
    "Hot water pump status change completion signal"
    annotation (Placement(transformation(extent={{160,-140},{200,-100}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

protected
  parameter Integer pumInd[nPum]={i for i in 1:nPum}
    "Pump index, {1,2,...,n}";

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[nPum]
    "Check next lag pump"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3[nPum]
    "Check last lag pump"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Switch nexLagPumSta[nPum]
    "Next lag pump status"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Switch lasLagPumSta[nPum]
    "Last lag pump status"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Or enaPum[nPum]
    "Hot water pump status"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));

  Buildings.Controls.OBC.CDL.Logical.And pumSta[nPum]
    "Hot water pump status"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Switch remPum[nPum]
    "Remove pump"
    annotation (Placement(transformation(extent={{110,-50},{130,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Switch addPum[nPum]
    "Add pump"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nPum)
    "Integer replicator"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep1(
    final nout=nPum)
    "Integer replicator"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nPum](
    final k=pumInd)
    "Pump index"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Convert pump enable signal into a pulse signal"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Convert pump disable signal into a pulse signal"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Latch to indicate pump enable is in-process"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Latch to indicate pump disable is in-process"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Convert in-process signal into False signal to apply on the pump being disabled"
    annotation (Placement(transformation(extent={{50,70},{70,90}})));

  Buildings.Controls.OBC.CDL.Logical.Xor xor[nPum]
    "Identify pumps with non-matching enable status between output and proven on
    signal"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));

  Buildings.Controls.OBC.CDL.Logical.Not not4[nPum]
    "True signal for pumps that are at correct state"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nin=nPum)
    "Check if all pumps are at desired status"
    annotation (Placement(transformation(extent={{50,-130},{70,-110}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Convert completion of pump status change process into pulse signal"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Pre block for clearing in-process status latch"
    annotation (Placement(transformation(extent={{140,90},{120,110}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSamDis
    "Sample last lag pump index when pump disable is triggered"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSamEna
    "Sample next lag pump index when pump enable is triggered"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to Integer conversion for last lag pump index"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Real to Integer conversion for next lag pump index"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Integer to Real conversion for next lag pump index"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    "Integer to Real conversion for last lag pump index"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

equation
  connect(nexLagPumSta.u2, intEqu2.y)
    annotation (Line(points={{38,-20},{22,-20}},   color={255,0,255}));

  connect(intEqu3.y, lasLagPumSta.u2)
    annotation (Line(points={{22,-60},{38,-60}},   color={255,0,255}));

  connect(intRep.y, intEqu2.u1)
    annotation (Line(points={{-18,-20},{-2,-20}},  color={255,127,0}));

  connect(intRep1.y, intEqu3.u1)
    annotation (Line(points={{-18,-60},{-2,-60}},  color={255,127,0}));

  connect(booRep2.y, lasLagPumSta.u1) annotation (Line(points={{102,80},{106,80},
          {106,-40},{34,-40},{34,-52},{38,-52}},
                                color={255,0,255}));

  connect(booRep1.y, nexLagPumSta.u1) annotation (Line(points={{82,120},{114,120},
          {114,34},{34,34},{34,-12},{38,-12}},
                                color={255,0,255}));

  connect(uHotWatPum, nexLagPumSta.u3) annotation (Line(points={{-180,20},{28,20},
          {28,-28},{38,-28}},   color={255,0,255}));

  connect(uHotWatPum, lasLagPumSta.u3) annotation (Line(points={{-180,20},{28,20},
          {28,-68},{38,-68}},   color={255,0,255}));

  connect(nexLagPumSta.y, enaPum.u1)
    annotation (Line(points={{62,-20},{68,-20}},
                                               color={255,0,255}));

  connect(uHotWatPum, enaPum.u2) annotation (Line(points={{-180,20},{28,20},{28,
          -36},{68,-36},{68,-28}},
                    color={255,0,255}));

  connect(uHotWatPum, remPum.u1) annotation (Line(points={{-180,20},{64,20},{64,
          -32},{108,-32}},
                     color={255,0,255}));

  connect(enaPum.y, addPum.u1) annotation (Line(points={{92,-20},{100,-20},{100,
          28},{118,28}},
                     color={255,0,255}));

  connect(lasLagPumSta.y, pumSta.u1)
    annotation (Line(points={{62,-60},{78,-60}},color={255,0,255}));

  connect(enaPum.y, pumSta.u2) annotation (Line(points={{92,-20},{100,-20},{100,
          -44},{70,-44},{70,-68},{78,-68}},
                                       color={255,0,255}));

  connect(pumSta.y, remPum.u3) annotation (Line(points={{102,-60},{106,-60},{106,
          -48},{108,-48}},
                     color={255,0,255}));

  connect(booRep2.y, remPum.u2) annotation (Line(points={{102,80},{106,80},{106,
          -40},{108,-40}},color={255,0,255}));

  connect(booRep1.y, addPum.u2) annotation (Line(points={{82,120},{114,120},{114,
          20},{118,20}},  color={255,0,255}));

  connect(remPum.y, addPum.u3) annotation (Line(points={{132,-40},{140,-40},{140,
          -20},{110,-20},{110,12},{118,12}},
                                       color={255,0,255}));

  connect(addPum.y, yHotWatPum) annotation (Line(points={{142,20},{180,20}},
                    color={255,0,255}));

  connect(conInt.y, intEqu2.u2) annotation (Line(points={{-38,40},{-10,40},{-10,
          -28},{-2,-28}},  color={255,127,0}));

  connect(conInt.y, intEqu3.u2) annotation (Line(points={{-38,40},{-10,40},{-10,
          -68},{-2,-68}},  color={255,127,0}));

  connect(uLasLagPumSta, falEdg.u)
    annotation (Line(points={{-180,80},{-142,80}},color={255,0,255}));
  connect(uNexLagPumSta, edg.u)
    annotation (Line(points={{-180,120},{-142,120}},color={255,0,255}));
  connect(edg.y, lat.u)
    annotation (Line(points={{-118,120},{18,120}}, color={255,0,255}));
  connect(lat.y, booRep1.u)
    annotation (Line(points={{42,120},{58,120}},  color={255,0,255}));
  connect(falEdg.y, lat1.u)
    annotation (Line(points={{-118,80},{18,80}}, color={255,0,255}));
  connect(lat1.y, not1.u)
    annotation (Line(points={{42,80},{48,80}},   color={255,0,255}));
  connect(not1.y, booRep2.u)
    annotation (Line(points={{72,80},{78,80}}, color={255,0,255}));
  connect(xor.y,not4. u)
    annotation (Line(points={{2,-120},{18,-120}},      color={255,0,255}));
  connect(not4.y,mulAnd. u[1:nPum]) annotation (Line(points={{42,-120},{48,-120}},
                                    color={255,0,255}));
  connect(uHotWatPum, xor.u2) annotation (Line(points={{-180,20},{28,20},{28,-100},
          {-30,-100},{-30,-128},{-22,-128}},color={255,0,255}));
  connect(addPum.y, xor.u1) annotation (Line(points={{142,20},{148,20},{148,-100},
          {-30,-100},{-30,-120},{-22,-120}},color={255,0,255}));
  connect(mulAnd.y, edg1.u)
    annotation (Line(points={{72,-120},{118,-120}},color={255,0,255}));
  connect(edg1.y, yPumStaCom)
    annotation (Line(points={{142,-120},{180,-120}},color={255,0,255}));
  connect(edg1.y, pre1.u) annotation (Line(points={{142,-120},{150,-120},{150,100},
          {142,100}}, color={255,0,255}));
  connect(pre1.y, lat.clr) annotation (Line(points={{118,100},{10,100},{10,114},
          {18,114}}, color={255,0,255}));
  connect(pre1.y, lat1.clr) annotation (Line(points={{118,100},{10,100},{10,74},
          {18,74}}, color={255,0,255}));
  connect(reaToInt1.y, intRep.u)
    annotation (Line(points={{-48,-20},{-42,-20}}, color={255,127,0}));
  connect(reaToInt.y, intRep1.u)
    annotation (Line(points={{-48,-60},{-42,-60}}, color={255,127,0}));
  connect(triSamEna.y, reaToInt1.u)
    annotation (Line(points={{-78,-20},{-72,-20}}, color={0,0,127}));
  connect(triSamDis.y, reaToInt.u)
    annotation (Line(points={{-78,-60},{-72,-60}}, color={0,0,127}));
  connect(uNexLagPum, intToRea.u)
    annotation (Line(points={{-180,-20},{-142,-20}}, color={255,127,0}));
  connect(uLasLagPum, intToRea1.u)
    annotation (Line(points={{-180,-60},{-142,-60}}, color={255,127,0}));
  connect(intToRea.y, triSamEna.u)
    annotation (Line(points={{-118,-20},{-102,-20}}, color={0,0,127}));
  connect(intToRea1.y, triSamDis.u)
    annotation (Line(points={{-118,-60},{-102,-60}}, color={0,0,127}));
  connect(falEdg.y, triSamDis.trigger) annotation (Line(points={{-118,80},{-110,
          80},{-110,-82},{-90,-82},{-90,-72}}, color={255,0,255}));
  connect(edg.y, triSamEna.trigger) annotation (Line(points={{-118,120},{-104,120},
          {-104,-40},{-90,-40},{-90,-32}}, color={255,0,255}));
annotation (
  defaultComponentName="chaSta",
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,140}})),
Documentation(info="<html>
<p>
Block that changes the status of pumps. This sequence is not directly specified 
in ASHRAE Guideline 36. It provides a side calculation pertaining to generalization of the staging 
sequences for any number of pumps and stages provided by the user.
</p>
<ol>
<li>
When the block receives the index of next lag pump to be enabled <code>uNexLagPum</code>
and a <code>true</code> pulse on the next lag pump status <code>uNexLagPumSta</code>,
it changes the pump status <code>yHotWatPum[uNexLagPum]</code> to <code>true</code>.
</li>
<li>
When the block receives the index of last lag pump to be disabled <code>uLasLagPum</code>
and a <code>false</code> pulse on the last lag pump status <code>uLasLagPumSta</code>, it changes
the pump status <code>yHotWatPum[uLasLagPum]</code> to <code>false</code>.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 19, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChangeStatus;
