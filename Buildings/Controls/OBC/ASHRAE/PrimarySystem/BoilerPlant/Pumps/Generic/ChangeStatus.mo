within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.Generic;
block ChangeStatus "Sequence to change pump status"

  parameter Integer nPum = 2
    "Total number of pumps";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotWatPum[nPum]
    "Hot water pump status"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uNexLagPumSta
    "Status of next lag pump"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLasLagPumSta
    "Status of last lag pump"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uNexLagPum
    "Index of next lag pump"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uLasLagPum
    "Index of last lag pump"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHotWatPum[nPum]
    "Hot water pump status"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  parameter Integer pumInd[nPum]={i for i in 1:nPum}
    "Pump index, {1,2,...,n}";

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nPum)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[nPum]
    "Check next lag pump"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3[nPum]
    "Check last lag pump"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch nexLagPumSta[nPum]
    "Next lag pump status"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Switch lasLagPumSta[nPum]
    "Last lag pump status"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Or enaPum[nPum]
    "Hot water pump status"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));

  Buildings.Controls.OBC.CDL.Logical.And pumSta[nPum]
    "Hot water pump status"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch remPum[nPum]
    "Remove pump"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Switch addPum[nPum]
    "Add pump"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nPum)
    "Integer replicator"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep1(
    final nout=nPum)
    "Integer replicator"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nPum](
    final k=pumInd)
    "Pump index"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));

equation
  connect(nexLagPumSta.u2, intEqu2.y)
    annotation (Line(points={{-22,-40},{-38,-40}}, color={255,0,255}));

  connect(intEqu3.y, lasLagPumSta.u2)
    annotation (Line(points={{-38,-80},{-22,-80}}, color={255,0,255}));

  connect(uNexLagPumSta, booRep1.u)
    annotation (Line(points={{-120,80},{-82,80}}, color={255,0,255}));

  connect(uLasLagPumSta, booRep2.u)
    annotation (Line(points={{-120,50},{-82,50}}, color={255,0,255}));

  connect(intRep.y, intEqu2.u1)
    annotation (Line(points={{-68,-40},{-62,-40}}, color={255,127,0}));

  connect(intRep1.y, intEqu3.u1)
    annotation (Line(points={{-68,-80},{-62,-80}}, color={255,127,0}));

  connect(uNexLagPum, intRep.u)
    annotation (Line(points={{-120,-40},{-92,-40}}, color={255,127,0}));

  connect(uLasLagPum, intRep1.u)
    annotation (Line(points={{-120,-80},{-92,-80}}, color={255,127,0}));

  connect(booRep2.y, lasLagPumSta.u1) annotation (Line(points={{-58,50},{-36,50},
          {-36,-72},{-22,-72}}, color={255,0,255}));

  connect(booRep1.y, nexLagPumSta.u1) annotation (Line(points={{-58,80},{-24,80},
          {-24,-32},{-22,-32}}, color={255,0,255}));

  connect(uHotWatPum, nexLagPumSta.u3) annotation (Line(points={{-120,0},{-30,0},
          {-30,-48},{-22,-48}}, color={255,0,255}));

  connect(uHotWatPum, lasLagPumSta.u3) annotation (Line(points={{-120,0},{-30,0},
          {-30,-88},{-22,-88}}, color={255,0,255}));

  connect(nexLagPumSta.y, enaPum.u1)
    annotation (Line(points={{2,-40},{8,-40}}, color={255,0,255}));

  connect(uHotWatPum, enaPum.u2) annotation (Line(points={{-120,0},{4,0},{4,-48},
          {8,-48}}, color={255,0,255}));

  connect(uHotWatPum, remPum.u1) annotation (Line(points={{-120,0},{4,0},{4,-52},
          {48,-52}}, color={255,0,255}));

  connect(enaPum.y, addPum.u1) annotation (Line(points={{32,-40},{40,-40},{40,8},
          {58,8}},   color={255,0,255}));

  connect(lasLagPumSta.y, pumSta.u1)
    annotation (Line(points={{2,-80},{18,-80}}, color={255,0,255}));

  connect(enaPum.y, pumSta.u2) annotation (Line(points={{32,-40},{40,-40},{40,
          -56},{10,-56},{10,-88},{18,-88}},
                                       color={255,0,255}));

  connect(pumSta.y, remPum.u3) annotation (Line(points={{42,-80},{46,-80},{46,-68},
          {48,-68}}, color={255,0,255}));

  connect(booRep2.y, remPum.u2) annotation (Line(points={{-58,50},{-36,50},{-36,
          -60},{48,-60}}, color={255,0,255}));

  connect(booRep1.y, addPum.u2) annotation (Line(points={{-58,80},{50,80},{50,0},
          {58,0}},        color={255,0,255}));

  connect(remPum.y, addPum.u3) annotation (Line(points={{72,-60},{80,-60},{80,-40},
          {50,-40},{50,-8},{58,-8}},   color={255,0,255}));

  connect(addPum.y, yHotWatPum) annotation (Line(points={{82,0},{120,0}},
                    color={255,0,255}));

  connect(conInt.y, intEqu2.u2) annotation (Line(points={{-68,20},{-66,20},{-66,
          -48},{-62,-48}}, color={255,127,0}));

  connect(conInt.y, intEqu3.u2) annotation (Line(points={{-68,20},{-66,20},{-66,
          -88},{-62,-88}}, color={255,127,0}));

annotation (
  defaultComponentName="chaSta",
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{120,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,150},{100,110}},
          textColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
Documentation(info="<html>
<p>
Block that changes the status of pumps. This sequence is not directly specified 
in RP-1711. It provides a side calculation pertaining to generalization of the staging 
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
