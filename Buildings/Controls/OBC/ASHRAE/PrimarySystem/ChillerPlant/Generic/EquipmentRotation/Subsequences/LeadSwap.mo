within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences;
block LeadSwap
  "Ensures previous lead stays enabled until the new lead is proven on"

  parameter Boolean lag = true
    "true = lead/lag, false = lead/standby";

  parameter Boolean initRoles[nDev] = {true, false}
    "Initial roles: true = lead, false = lag/standby"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Initiation"));

  parameter Modelica.SIunits.Time stagingRuntime(
    final displayUnit = "h") = 864000
    "Staging runtime for each device";

  CDL.Interfaces.BooleanInput uLeaStaSet[nDev]
    "Lead device status setpoint prior to lead swap delay" annotation (
      Placement(transformation(extent={{-240,50},{-220,70}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.BooleanInput uDevSta[nDev] annotation (Placement(
        transformation(extent={{-240,-50},{-220,-30}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  CDL.Logical.And and2[nDev]
    annotation (Placement(transformation(extent={{-180,-40},{-160,-20}})));
  CDL.Logical.MultiOr mulOr(nu=2)
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  CDL.Routing.BooleanReplicator booRep(nout=nDev)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  CDL.Logical.FallingEdge falEdg1[nDev]
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  CDL.Discrete.TriggeredSampler triSam[nDev]
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  CDL.Continuous.Sources.Constant con[nDev](k=fill(1, nDev))
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  CDL.Continuous.GreaterThreshold greThr[nDev](threshold=fill(0.5, nDev))
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  CDL.Logical.And and1[nDev]
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  CDL.Logical.Or or2[nDev]
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  CDL.Interfaces.BooleanOutput yDevStaSet[nDev] "Device status setpoint"
                                                           annotation (
      Placement(transformation(extent={{220,50},{240,70}}), iconTransformation(
          extent={{100,-20},{140,20}})));
protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  final parameter Modelica.SIunits.Time stagingRuntimes[nDev] = fill(stagingRuntime, nDev)
    "Staging runtimes array";

equation
  connect(uDevSta, and2.u2) annotation (Line(points={{-230,-40},{-200,-40},{-200,
          -38},{-182,-38}}, color={255,0,255}));
  connect(uLeaStaSet, and2.u1) annotation (Line(points={{-230,60},{-200,60},{-200,
          -30},{-182,-30}}, color={255,0,255}));
  connect(and2.y, mulOr.u[1:2]) annotation (Line(points={{-158,-30},{-142,-30},{
          -142,-33.5}}, color={255,0,255}));
  connect(mulOr.y, not1.u)
    annotation (Line(points={{-118,-30},{-102,-30}}, color={255,0,255}));
  connect(not1.y, booRep.u) annotation (Line(points={{-78,-30},{-70,-30},{-70,-30},
          {-62,-30}}, color={255,0,255}));
  connect(uLeaStaSet, falEdg1.u) annotation (Line(points={{-230,60},{-160,60},{-160,
          100},{-142,100}}, color={255,0,255}));
  connect(con.y, triSam.u)
    annotation (Line(points={{-118,140},{-82,140}}, color={0,0,127}));
  connect(falEdg1.y, triSam.trigger) annotation (Line(points={{-118,100},{-70,100},
          {-70,128.2}}, color={255,0,255}));
  connect(triSam.y, greThr.u)
    annotation (Line(points={{-58,140},{-42,140}}, color={0,0,127}));
  connect(greThr.y, and1.u1)
    annotation (Line(points={{-18,140},{-2,140}}, color={255,0,255}));
  connect(booRep.y, and1.u2) annotation (Line(points={{-38,-30},{-10,-30},{-10,132},
          {-2,132}}, color={255,0,255}));
  connect(and1.y, or2.u1) annotation (Line(points={{22,140},{30,140},{30,110},{38,
          110}}, color={255,0,255}));
  connect(uLeaStaSet, or2.u2) annotation (Line(points={{-230,60},{-140,60},{-140,
          80},{30,80},{30,102},{38,102}}, color={255,0,255}));
  connect(or2.y,yDevStaSet)  annotation (Line(points={{62,110},{140,110},{140,60},
          {230,60}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-220,-160},{220,180}})),
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
This block rotates equipment, such as chillers, pumps or valves, in order 
to ensure equal wear and tear. It can be used for lead/lag and 
lead/standby operation, as specified in &quot;ASHRAE Fundamentals of Chilled Water Plant Design and Control SDL&quot;, 
Chapter 7, App B, 1.01, A.4.  The output vector <code>yDevRol<\code> indicates the lead/lag (or lead/standby) status
of the devices, while the <code>yDevSta<\code> indicates the on/off status of each device. The index of
output vectors and <code>initRoles<\code> parameter represents the physical device.
Default initial lead role is assigned to the device associated
with the first index in the input vector. The block measures the <code>stagingRuntime<\code> 
for each device and switches the lead role to the next higher index
as its <code>stagingRuntime<\code> expires. This block can be used for 2 devices. 
If using more than 2 devices, see 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotationMult\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotationMult</a>.
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
