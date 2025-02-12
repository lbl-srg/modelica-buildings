within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences;
block EnableLead_dedicated
  "Sequence for enabling lead pump of plants with dedicated condenser water pumps"

  final parameter Real offTimThr(
    final unit="s",
    final quantity="Time")=180
    "Threshold to check lead chiller OFF time";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaPla
    "True: plant is just enabled"
    annotation(Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiEna
    "Lead chiller commanded on status"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiSta
    "Lead chiller proven on status"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaConWatReq
    "Status indicating if chiller is requesting condenser water"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLea "Lead pump status"
    annotation (Placement(transformation(extent={{100,50},{140,90}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch leaPumSta
    "Lead pump status"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=offTimThr)
    "Check if the chiller has been proven off for more than threshold time"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Check if the lead chiller is disabled"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Logical or"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

equation
  connect(uLeaConWatReq, not1.u)
    annotation (Line(points={{-120,-80},{-82,-80}}, color={255,0,255}));
  connect(uLeaChiEna, leaPumSta.u)
    annotation (Line(points={{-120,30},{18,30}}, color={255,0,255}));
  connect(uLeaChiSta, not2.u)
    annotation (Line(points={{-120,-40},{-82,-40}}, color={255,0,255}));
  connect(not2.y, tim.u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={255,0,255}));
  connect(not1.y, or2.u2)
    annotation (Line(points={{-58,-80},{20,-80},{20,-48},{38,-48}},
      color={255,0,255}));
  connect(or2.y, and2.u2)
    annotation (Line(points={{62,-40},{80,-40},{80,-20},{-30,-20},{-30,-8},
        {-22,-8}},color={255,0,255}));
  connect(uLeaChiEna, not3.u)
    annotation (Line(points={{-120,30},{-80,30},{-80,0},{-62,0}},
      color={255,0,255}));
  connect(not3.y, and2.u1)
    annotation (Line(points={{-38,0},{-22,0}},  color={255,0,255}));
  connect(and2.y, leaPumSta.clr)
    annotation (Line(points={{2,0},{10,0},{10,24},{18,24}},    color={255,0,255}));
  connect(tim.passed, or2.u1)
    annotation (Line(points={{-18,-48},{0,-48},{0,-40},{38,-40}},
      color={255,0,255}));
  connect(or1.y, yLea)
    annotation (Line(points={{82,70},{120,70}}, color={255,0,255}));
  connect(uEnaPla, or1.u1)
    annotation (Line(points={{-120,70},{58,70}}, color={255,0,255}));
  connect(leaPumSta.y, or1.u2) annotation (Line(points={{42,30},{50,30},{50,62},
          {58,62}}, color={255,0,255}));

annotation (
  defaultComponentName="enaLeaConPum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,54},{-44,32}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uLeaChiEna"),
        Text(
          extent={{42,12},{96,-10}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yLeaPum"),
        Text(
          extent={{-100,150},{100,110}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,-28},{-44,-50}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uLeaChiOn"),
        Text(
          extent={{-98,-68},{-26,-90}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uLeaConWatReq"),
        Text(
          extent={{-96,90},{-50,70}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uEnaPla")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Block that enable and disable lead condenser water pump, for plants
with dedicated condenser water pumps,
according to ASHRAE Guideline36-2021,
section 5.20.9 Condenser water pumps, part 5.20.9.4.
</p>
<p>
The lead condenser water pump should be enabled when lead chiller is commanded
to run (<code>uLeaChiEna</code> = true). It should be disabled when the lead
chiller is disabled and either the lead chiller has been proven off
(<code>uLeaChiSta</code> = false) for <code>offTimThr</code>, i.e. 3 minutes, or
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
