within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences;
block EnableLead_dedicated
  "Sequence for enabling lead pump of plants with dedicated condenser water pumps"

  final parameter Real offTimThr(
    final unit="s",
    final quantity="Time")=180
    "Threshold to check lead chiller OFF time";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiEna
    "Lead chiller enabling status"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiSta
    "Lead chiller proven on status"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaConWatReq
    "Status indicating if chiller is requesting condenser water"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLea "Lead pump status"
    annotation (Placement(transformation(extent={{100,50},{140,90}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Latch leaPumSta
    "Lead pump status"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=offTimThr)
    "Check if the chiller has been OFF for more than threshold"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

equation
  connect(uLeaConWatReq, not1.u)
    annotation (Line(points={{-120,-80},{-82,-80}}, color={255,0,255}));
  connect(uLeaChiEna, leaPumSta.u)
    annotation (Line(points={{-120,70},{58,70}}, color={255,0,255}));
  connect(leaPumSta.y, yLea)
    annotation (Line(points={{82,70},{120,70}}, color={255,0,255}));
  connect(uLeaChiSta, not2.u)
    annotation (Line(points={{-120,-20},{-82,-20}}, color={255,0,255}));
  connect(not2.y, tim.u)
    annotation (Line(points={{-58,-20},{-42,-20}}, color={255,0,255}));
  connect(not1.y, or2.u2)
    annotation (Line(points={{-58,-80},{30,-80},{30,-28},{38,-28}},
      color={255,0,255}));
  connect(or2.y, and2.u2)
    annotation (Line(points={{62,-20},{80,-20},{80,20},{-20,20},{-20,32},{-2,32}},
      color={255,0,255}));
  connect(uLeaChiEna, not3.u)
    annotation (Line(points={{-120,70},{-80,70},{-80,40},{-62,40}},
      color={255,0,255}));
  connect(not3.y, and2.u1)
    annotation (Line(points={{-38,40},{-2,40}}, color={255,0,255}));
  connect(and2.y, leaPumSta.clr)
    annotation (Line(points={{22,40},{40,40},{40,64},{58,64}}, color={255,0,255}));
  connect(tim.passed, or2.u1)
    annotation (Line(points={{-18,-28},{0,-28},{0,-20},{38,-20}},
      color={255,0,255}));

annotation (
  defaultComponentName="enaLeaConPum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,94},{-44,72}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uLeaChiEna"),
        Text(
          extent={{42,12},{96,-10}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yLeaPum"),
        Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,12},{-44,-10}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uLeaChiOn"),
        Text(
          extent={{-98,-68},{-26,-90}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uLeaConWatReq")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Block that enable and disable lead condenser water pump, for plants
with dedicated condenser water pumps,
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft on March 2020),
section 5.2.9 Condenser water pumps, part 5.2.9.4.
</p>
<p>
The lead condenser water pump should be enabled when lead chiller is commanded
to run (<code>uLeaChiEna</code> = true). It should be disabled when the lead
chiller is disabled and either the lead chiller has been proven off
(<code>uLeaChiSta</code> = false) for <code>offTimThr</code>, i.e. 3 minutes or
is not requesting condenser water flow (<code>uLeaConWatReq</code> = false).
</p>
</html>", revisions="<html>
<ul>
<li>
January 28, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableLead_dedicated;
