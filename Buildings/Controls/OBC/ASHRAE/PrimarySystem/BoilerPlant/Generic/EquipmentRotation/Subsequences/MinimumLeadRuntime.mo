within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.EquipmentRotation.Subsequences;
block MinimumLeadRuntime
  "Generates equipment rotation signal when a lead device/group of devices exceeds a miminum cumulative runtime"

  parameter Boolean initRoles[nDev] = {true, false}
    "Initial roles: true = lead, false = lag/standby"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Initiation"));

  parameter Real minLeaRuntime(
    final unit="s",
    final quantity="Time",
    displayUnit="h") = 864000
    "Minimum cumulative runtime period for a current lead device before rotation may occur";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta[nDev]
    "Device status: true = proven ON, false = proven OFF"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPreDevRolSig[nDev]
    "Device roles in the previous time instance: true = lead; false = lag or standby"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yRot "Rotation trigger signal"
    annotation (Placement(transformation(extent={{160,0},{200,40}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.TimerAccumulating accTim[nDev](
    final t=fill(minLeaRuntime, nDev))
    "Measures time spent loaded at the current role (lead or lag)"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  final parameter Real minLeaRuntimes[nDev](
    final unit=fill("s",nDev),
    final quantity=fill("Time",nDev)) = fill(minLeaRuntime, nDev)
    "Staging runtimes array";

  Buildings.Controls.OBC.CDL.Logical.And and2[nDev] "Logical and"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nDev) "Array or"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd allOn(
    final nin=nDev) "Outputs true if all devices are enabled"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr anyOn(
    final nin=nDev) "Checks if any device is disabled"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Controls.OBC.CDL.Logical.Not allOff
    "Returns true if all devices are disabled"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nDev) "Booolean replicator"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Buildings.Controls.OBC.CDL.Logical.Or equSig
    "Outputs true if either all devices are enabled or all devices are disabled"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge  falEdg1[nDev] "Falling Edge"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

equation
  connect(mulOr.u, and2.y)
    annotation (Line(points={{118,20},{102,20}}, color={255,0,255}));

  connect(booRep1.y, and2.u2)
    annotation (Line(points={{42,20},{50,20},{50,12},{78,12}}, color={255,0,255}));
  connect(anyOn.y, allOff.u)
    annotation (Line(points={{-78,-10},{-62,-10}},   color={255,0,255}));
  connect(booRep1.u, equSig.y)
    annotation (Line(points={{18,20},{2,20}},  color={255,0,255}));
  connect(allOff.y, equSig.u2) annotation (Line(points={{-38,-10},{-30,-10},{-30,
          12},{-22,12}},     color={255,0,255}));
  connect(allOn.y, equSig.u1) annotation (Line(points={{-38,30},{-30,30},{-30,20},
          {-22,20}},color={255,0,255}));
  connect(uDevSta, accTim.u)
    annotation (Line(points={{-180,60},{-62,60}}, color={255,0,255}));
  connect(uDevSta, allOn.u) annotation (Line(points={{-180,60},{-80,60},{-80,
          30},{-62,30}},       color={255,0,255}));
  connect(uDevSta, anyOn.u) annotation (Line(points={{-180,60},{-120,60},{-120,
          -10},{-102,-10}},      color={255,0,255}));
  connect(mulOr.y, yRot)
    annotation (Line(points={{142,20},{180,20}}, color={255,0,255}));
  connect(uPreDevRolSig, falEdg1.u)
    annotation (Line(points={{-180,-60},{-142,-60}}, color={255,0,255}));
  connect(falEdg1.y, accTim.reset) annotation (Line(points={{-118,-60},{-110,-60},
          {-110,52},{-62,52}}, color={255,0,255}));
  connect(accTim.passed, and2.u1) annotation (Line(points={{-38,52},{60,52},{60,
          20},{78,20}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-160,-80},{160,80}})),
      defaultComponentName="minLeaTim",
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
      Line(points={{-66,-70},{82,-70}},
        color={192,192,192}),
      Line(points={{-58,68},{-58,-80}},
        color={192,192,192}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90.0,-70.0},{68.0,-62.0},{68.0,-78.0},{90.0,-70.0}}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-58,90},{-66,68},{-50,68},{-58,90}}),
      Line(points={{-56,-70},{-38,-70},{-38,-26},{40,-26},{40,-70},{68,-70}},
        color={255,0,255}),
      Line(points={{-58,0},{-40,0},{40,90},{40,0},{68,0}},
        color={0,0,127})}),
  Documentation(info="<html>
<p>
This subsequence generates a rotation trigger based on measuring time each of the devices enable time.
The rotation trigger output <code>yRot</code> is generated as the current lead device runtime
exceeds <code>minLeaRuntime</code> and the conditions are met such that the devices are not hot swapped. To
avoid hot swapping the lead and lag/standby device need to be either both ON or both OFF for the rotation to occur.
As the rotation trigger output <code>yRot</code> signal is generated, the runtime for the previous lead device
or group of devices is reset to zero.
<p>
This is an OBC custom implementation.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end MinimumLeadRuntime;
