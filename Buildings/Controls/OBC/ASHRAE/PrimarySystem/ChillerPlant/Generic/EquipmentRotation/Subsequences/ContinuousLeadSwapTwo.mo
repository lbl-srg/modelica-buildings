within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences;
block ContinuousLeadSwapTwo
  "Ensures that the previous lead device remains enabled until the new lead device is proven on"

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevRolSet[nDev]
    "Device role setpoint: true = lead, false = standby"
    annotation (Placement(transformation(extent={{-100,0},{-60,40}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta[nDev]
    "Device status: true = proven ON; false = proven OFF"
    annotation (Placement(transformation(extent={{-100,-40},{-60,0}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevStaSet[nDev]
    "Device status setpoint"
    annotation (Placement(transformation(extent={{60,0},{100,40}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  final parameter Integer nDev = 2
    "Total number of devices, such as chillers, isolation valves, CW pumps, or CHW pumps";

  Buildings.Controls.OBC.CDL.Logical.Or or1[nDev] "Logical or"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1[nDev] "Logical not"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

equation
  connect(uDevSta, not1.u)
    annotation (Line(points={{-80,-20},{-42,-20}}, color={255,0,255}));
  connect(uDevRolSet, or1.u1)
    annotation (Line(points={{-80,20},{18,20}},color={255,0,255}));
  connect(not1[1].y, or1[2].u2)
    annotation (Line(points={{-18,-20},{0,-20},{0,12},{18,12}}, color={255,0,255}));
  connect(not1[2].y, or1[1].u2)
    annotation (Line(points={{-18,-20},{-10,-20},{-10,12},{18,12}}, color={255,0,255}));
  connect(or1.y, yDevStaSet)
    annotation (Line(points={{42,20},{80,20}}, color={255,0,255}));
  annotation (defaultComponentName="leaSwa",
    Icon(graphics={Rectangle(
    extent={{-100,-100},{100,100}},
    lineColor={0,0,127}, fillColor={255,255,255},
    fillPattern=FillPattern.Solid),
    Ellipse( extent={{71,7},{85,-7}},
    lineColor=DynamicSelect({235,235,235}, if y then {0,255,0} else {235,235,235}),
    fillColor=DynamicSelect({235,235,235}, if y then {0,255,0} else {235,235,235}),
    fillPattern=FillPattern.Solid), Ellipse( extent={{-75,-6},{-89,8}},
    lineColor=DynamicSelect({235,235,235}, if u1 then {0,255,0} else {235,235,235}),
    fillColor=DynamicSelect({235,235,235}, if u1 then {0,255,0} else {235,235,235}),
    fillPattern=FillPattern.Solid), Text( extent={{-120,146},{100,108}},
    textColor={0,0,255}, textString="%name")}),
  Documentation(info="<html>
<p>
This block ensures that the new lead device is started and proven on before the old 
lead device is switched to standby and shut off. The implementation is 
according to ASHRAE Guideline36-2021, section 5.1.15.4.b.
</p>
</html>", revisions="<html>
<ul>
<li>
May 18, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-60,-40},{60,40}})));
end ContinuousLeadSwapTwo;
