within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences;
block LeadSwap
  "Ensures previous lead stays enabled until the new lead is proven on"

  parameter Boolean lag = true
    "true = lead/lag, false = lead/standby";

  parameter Boolean initRoles[nDev] = {true, false}
    "Initial roles: true = lead, false = lag/standby"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Initiation"));

  parameter Modelica.SIunits.Time stagingRuntime(
    final displayUnit = "h") = 864000
    "Staging runtime for each device";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaStaSet[nDev]
    "Lead device status setpoint prior to lead swap delay" annotation (
      Placement(transformation(extent={{-180,50},{-160,70}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta[nDev]
    ""
    annotation (Placement(
        transformation(extent={{-180,-50},{-160,-30}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevStaSet[nDev]
    "Device status setpoint"
    annotation (Placement(transformation(extent={{160,30},{180,50}}), iconTransformation(
          extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.And and2[nDev] "Logical and"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nu=nDev) "Multi or"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=nDev) ""
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1[nDev]
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nDev]
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[nDev](
    final k=fill(1, nDev))
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr[nDev](
    final threshold=fill(0.5, nDev))
    annotation (Placement(transformation(extent={{0,60},{20,80}})));

  Buildings.Controls.OBC.CDL.Logical.And and1[nDev]
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2[nDev]
    annotation (Placement(transformation(extent={{80,30},{100,50}})));

protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  final parameter Modelica.SIunits.Time stagingRuntimes[nDev] = fill(stagingRuntime, nDev)
    "Staging runtimes array";

equation
  connect(uDevSta, and2.u2) annotation (Line(points={{-170,-40},{-140,-40},{-140,
          -38},{-122,-38}}, color={255,0,255}));
  connect(uLeaStaSet, and2.u1) annotation (Line(points={{-170,60},{-140,60},{-140,
          -30},{-122,-30}}, color={255,0,255}));
  connect(and2.y, mulOr.u[1:2]) annotation (Line(points={{-98,-30},{-82,-30},{-82,
          -30}},   color={255,0,255}));
  connect(mulOr.y, not1.u)
    annotation (Line(points={{-58,-30},{-42,-30}}, color={255,0,255}));
  connect(not1.y, booRep.u) annotation (Line(points={{-18,-30},{-2,-30}}, color={255,0,255}));
  connect(uLeaStaSet, falEdg1.u) annotation (Line(points={{-170,60},{-100,60},{-100,
          30},{-82,30}},    color={255,0,255}));
  connect(con.y, triSam.u)
    annotation (Line(points={{-58,70},{-42,70}}, color={0,0,127}));
  connect(falEdg1.y, triSam.trigger) annotation (Line(points={{-58,30},{-30,30},
          {-30,58.2}},  color={255,0,255}));
  connect(triSam.y, greThr.u)
    annotation (Line(points={{-18,70},{-2,70}}, color={0,0,127}));
  connect(greThr.y, and1.u1)
    annotation (Line(points={{22,70},{38,70}}, color={255,0,255}));
  connect(booRep.y, and1.u2) annotation (Line(points={{22,-30},{30,-30},{30,62},
          {38,62}},  color={255,0,255}));
  connect(and1.y, or2.u1) annotation (Line(points={{62,70},{70,70},{70,40},{78,40}},
                 color={255,0,255}));
  connect(uLeaStaSet, or2.u2) annotation (Line(points={{-170,60},{-100,60},{-100,
          10},{70,10},{70,32},{78,32}}, color={255,0,255}));
  connect(or2.y,yDevStaSet)  annotation (Line(points={{102,40},{170,40}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-160,-60},{160,100}})),
      defaultComponentName="leaSwa",
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-75,-6},{-89,8}},
          lineColor=DynamicSelect({235,235,235}, if u1 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u1 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
  Documentation(info="<html>
<p>
This block ensures that the new lead device is started and proven on before the old lead device is switched to standby and shut off. The implementation is 
according to RP 1711 5.1.2.4.2.
</p>
</html>", revisions="<html>
<ul>
<li>
September 18, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end LeadSwap;
