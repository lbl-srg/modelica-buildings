within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences;
block ChangeStatus "Sequence for changing DX coil status"

  parameter Integer nCoi = 2
    "Total number of DX coils";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCoil[nCoi]
    "DX coil status"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uNexDXCoiSta
    "Status of next DX coil"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLasDXCoiSta
    "Status of last DX coil"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uNexDXCoi
    "Index of next DX coil"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uLasDXCoi
    "Index of last DX coil"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDXCoi[nCoi]
    "DX coil status"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{120,-20},{160,20}})));

protected
  parameter Integer coiInd[nCoi]={i for i in 1:nCoi}
    "DX coil index, {1,2,...,n}";

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nCoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nCoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[nCoi]
    "Check next DX coil"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3[nCoi]
    "Check last DX coil"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch nexDXCoiSta[nCoi]
    "Next DX coil status"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Switch lasDXCoiSta[nCoi]
    "Last DX coil status"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Or enaCoi[nCoi]
    "DX coil status"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));

  Buildings.Controls.OBC.CDL.Logical.And coiSta[nCoi]
    "DX coil status"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch remCoi[nCoi]
    "Remove DX coil"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Switch addCoi[nCoi]
    "Add DX coil"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nCoi)
    "Integer replicator"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep1(
    final nout=nCoi)
    "Integer replicator"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nCoi](
    final k=coiInd)
    "DX coil index"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));

equation
  connect(nexDXCoiSta.u2, intEqu2.y)
    annotation (Line(points={{-22,-40},{-38,-40}}, color={255,0,255}));

  connect(intEqu3.y, lasDXCoiSta.u2)
    annotation (Line(points={{-38,-80},{-22,-80}}, color={255,0,255}));

  connect(uNexDXCoiSta, booRep1.u)
    annotation (Line(points={{-120,80},{-82,80}}, color={255,0,255}));

  connect(uLasDXCoiSta, booRep2.u)
    annotation (Line(points={{-120,50},{-82,50}}, color={255,0,255}));

  connect(intRep.y, intEqu2.u1)
    annotation (Line(points={{-68,-40},{-62,-40}}, color={255,127,0}));

  connect(intRep1.y, intEqu3.u1)
    annotation (Line(points={{-68,-80},{-62,-80}}, color={255,127,0}));

  connect(uNexDXCoi, intRep.u)
    annotation (Line(points={{-120,-40},{-92,-40}}, color={255,127,0}));

  connect(uLasDXCoi, intRep1.u)
    annotation (Line(points={{-120,-80},{-92,-80}}, color={255,127,0}));

  connect(booRep2.y, lasDXCoiSta.u1) annotation (Line(points={{-58,50},{-36,50},
          {-36,-72},{-22,-72}}, color={255,0,255}));

  connect(booRep1.y, nexDXCoiSta.u1) annotation (Line(points={{-58,80},{-24,80},
          {-24,-32},{-22,-32}}, color={255,0,255}));

  connect(uDXCoil, nexDXCoiSta.u3) annotation (Line(points={{-120,0},{-30,0},{-30,
          -48},{-22,-48}}, color={255,0,255}));

  connect(uDXCoil, lasDXCoiSta.u3) annotation (Line(points={{-120,0},{-30,0},{-30,
          -88},{-22,-88}}, color={255,0,255}));

  connect(nexDXCoiSta.y, enaCoi.u1)
    annotation (Line(points={{2,-40},{8,-40}}, color={255,0,255}));

  connect(uDXCoil, enaCoi.u2) annotation (Line(points={{-120,0},{4,0},{4,-48},{8,
          -48}}, color={255,0,255}));

  connect(uDXCoil, remCoi.u1) annotation (Line(points={{-120,0},{4,0},{4,-52},{48,
          -52}}, color={255,0,255}));

  connect(enaCoi.y,addCoi. u1) annotation (Line(points={{32,-40},{40,-40},{40,8},
          {58,8}},   color={255,0,255}));

  connect(lasDXCoiSta.y, coiSta.u1)
    annotation (Line(points={{2,-80},{18,-80}}, color={255,0,255}));

  connect(enaCoi.y,coiSta. u2) annotation (Line(points={{32,-40},{40,-40},{40,
          -56},{10,-56},{10,-88},{18,-88}},
                                       color={255,0,255}));

  connect(coiSta.y,remCoi. u3) annotation (Line(points={{42,-80},{46,-80},{46,-68},
          {48,-68}}, color={255,0,255}));

  connect(booRep2.y,remCoi. u2) annotation (Line(points={{-58,50},{-36,50},{-36,
          -60},{48,-60}}, color={255,0,255}));

  connect(booRep1.y,addCoi. u2) annotation (Line(points={{-58,80},{50,80},{50,0},
          {58,0}},        color={255,0,255}));

  connect(remCoi.y,addCoi. u3) annotation (Line(points={{72,-60},{80,-60},{80,-40},
          {50,-40},{50,-8},{58,-8}},   color={255,0,255}));

  connect(addCoi.y, yDXCoi)
    annotation (Line(points={{82,0},{120,0}}, color={255,0,255}));

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
          extent={{-100,-100},{120,100}},
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
Block that changes the status of DX coils. 
It provides a side calculation pertaining to generalization of the staging 
sequences for any number of DX coils and stages provided by the user.
</p>
<ol>
<li>
When the block receives the index of next DX coil to be enabled <code>uNexDXCoi</code>
and a <code>true</code> pulse on the next DX coil status <code>uNexDXCoiSta</code>,
it changes the DX coil status <code>yDXCoi[uNexDXCoi]</code> to <code>true</code>.
</li>
<li>
When the block receives the index of last DX coil to be disabled <code>uLasDXCoi</code>
and a <code>false</code> pulse on the last DX coil status <code>uLasDXCoiSta</code>, it changes
the DX coil status <code>yDXCoi[uLasDXCoi]</code> to <code>false</code>.
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
