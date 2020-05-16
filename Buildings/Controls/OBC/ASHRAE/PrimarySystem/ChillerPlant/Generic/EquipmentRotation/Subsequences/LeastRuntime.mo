within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences;
block LeastRuntime
  "Generates equipment rotation signal at each device enable if that device has a least total runtime"

  parameter Boolean initRoles[nDev] = {true, false}
    "Initial roles: true = lead, false = lag/standby"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Initiation"));

  parameter Modelica.SIunits.Time minLeaRuntime(
    final displayUnit = "h") = 864000
    "Staging runtime for each device";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta[nDev]
    "Device status: true = proven ON, false = proven OFF"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
                   iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPreDevRolSig[nDev]
    "Device roles in the previous time instance: true = lead; false = lag or standby"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yRot "Rotation trigger signal"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[nDev](
    final accumulate=fill(true, nDev))
    "Measures time spent loaded at the current role (lead or lag)"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  CDL.Logical.Sources.Constant con[nDev](k=fill(false, nDev))
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  CDL.Continuous.GreaterEqual longer1
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  CDL.Continuous.Greater longer2
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  CDL.Logical.Not not3[nDev]
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  CDL.Logical.And3 and3[nDev]
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  CDL.Logical.MultiOr mulOr(nu=2)
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
//protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  final parameter Modelica.SIunits.Time minLeaRuntimes[nDev] = fill(minLeaRuntime, nDev)
    "Staging runtimes array";

  CDL.Logical.Edge                                edg    [nDev](pre_u_start=
        fill(false, nDev)) "Falling edge"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

equation

  connect(uDevSta, tim.u)
    annotation (Line(points={{-180,60},{-62,60}},  color={255,0,255}));
  connect(con.y, tim.reset) annotation (Line(points={{-78,30},{-70,30},{-70,52},
          {-62,52}}, color={255,0,255}));
  connect(tim[1].y, longer1.u1)
    annotation (Line(points={{-38,60},{-22,60}}, color={0,0,127}));
  connect(tim[2].y, longer1.u2) annotation (Line(points={{-38,60},{-30,60},{-30,
          52},{-22,52}}, color={0,0,127}));
  connect(tim[1].y, longer2.u2) annotation (Line(points={{-38,60},{-30,60},{-30,
          22},{-22,22}}, color={0,0,127}));
  connect(tim[2].y, longer2.u1) annotation (Line(points={{-38,60},{-30,60},{-30,
          30},{-22,30}}, color={0,0,127}));
  connect(uDevSta, edg.u) annotation (Line(points={{-180,60},{-120,60},{-120,-10},
          {-102,-10}}, color={255,0,255}));
  connect(yRot, yRot)
    annotation (Line(points={{180,0},{180,0}}, color={255,0,255}));
  connect(longer2.y, not2.u)
    annotation (Line(points={{2,30},{18,30}}, color={255,0,255}));
  connect(longer1.y, not1.u)
    annotation (Line(points={{2,60},{18,60}}, color={255,0,255}));
  connect(uPreDevRolSig, not3.u)
    annotation (Line(points={{-180,-40},{18,-40}}, color={255,0,255}));
  connect(edg.y, and3.u2) annotation (Line(points={{-78,-10},{80,-10},{80,20},{98,
          20}}, color={255,0,255}));
  connect(not3.y, and3.u3) annotation (Line(points={{42,-40},{88,-40},{88,12},{98,
          12}}, color={255,0,255}));
  connect(not1.y, and3[1].u1) annotation (Line(points={{42,60},{80,60},{80,28},{
          98,28}}, color={255,0,255}));
  connect(not2.y, and3[2].u1) annotation (Line(points={{42,30},{70,30},{70,28},{
          98,28}}, color={255,0,255}));
  connect(mulOr.y, yRot)
    annotation (Line(points={{152,0},{180,0}}, color={255,0,255}));
  connect(and3.y, mulOr.u[1:2]) annotation (Line(points={{122,20},{124,20},{124,
          0},{128,0},{128,-3.5}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-160,-80},{160,80}})),
      defaultComponentName="leaRunTim",
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
This subsequence generates a rotation trigger based on measuring the time each of the devices has spent in its current role. 
The rotation trigger output <code>yRot</code> is generated when a device/a group of devices is enabled 
that has/have the shortest cumulative runtime.
</p>
<p>
The implementation is based on section 5.1.2.3. and 5.1.2.4.1. of RP1711 March 2020 draft.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end LeastRuntime;
