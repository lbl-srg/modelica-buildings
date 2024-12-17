within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences;
block EnableLead_dedicated
  "Sequence to enable or disable the lead pump of plants with dedicated primary chilled water pumps"

  final parameter Real offTimThr(
    final unit="s",
    final quantity="Time")=180
      "Threshold to check lead chiller off time";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "True: plant is enabled"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiEna
    "True: lead chiller is enabled"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiSta
    "True: lead chiller is proven on"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiWatReq
    "True: lead chiller is requesting chilled water"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLea
    "Lead pump status setpoint"
    annotation (Placement(transformation(extent={{100,50},{140,90}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.Latch leaPumSta
    "Lead pump status"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not noChiWatReq "No chilled water request"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not proOff "Lead chiller proven off"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=offTimThr)
    "Check if the chiller has been OFF for more than 3 minutes"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not disLeaChi "Disabled lead chiller"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Edge disLeaPum
    "Disable lead pump when the input has rising edge"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
equation
  connect(uLeaChiWatReq, noChiWatReq.u)
    annotation (Line(points={{-120,-80},{-82,-80}}, color={255,0,255}));
  connect(uLeaChiSta, proOff.u)
    annotation (Line(points={{-120,-40},{-82,-40}}, color={255,0,255}));
  connect(proOff.y, tim.u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={255,0,255}));
  connect(noChiWatReq.y, or2.u2)
    annotation (Line(points={{-58,-80},{30,-80},{30,-48},{38,-48}},
      color={255,0,255}));
  connect(uLeaChiEna, disLeaChi.u)
    annotation (Line(points={{-120,40},{-82,40}}, color={255,0,255}));
  connect(disLeaChi.y, and2.u1)
    annotation (Line(points={{-58,40},{-42,40}}, color={255,0,255}));
  connect(or2.y, and2.u2)
    annotation (Line(points={{62,-40},{80,-40},{80,-10},{-50,-10},{-50,32},{-42,
          32}},  color={255,0,255}));
  connect(uPla, leaPumSta.u)
    annotation (Line(points={{-120,70},{38,70}}, color={255,0,255}));
  connect(and2.y, disLeaPum.u)
    annotation (Line(points={{-18,40},{-2,40}}, color={255,0,255}));
  connect(disLeaPum.y, leaPumSta.clr)
    annotation (Line(points={{22,40},{30,40},{30,64},{38,64}}, color={255,0,255}));
  connect(tim.passed, or2.u1) annotation (Line(points={{-18,-48},{20,-48},{20,-40},
          {38,-40}}, color={255,0,255}));
  connect(leaPumSta.y, yLea)
    annotation (Line(points={{62,70},{120,70}}, color={255,0,255}));
annotation (
  defaultComponentName="enaLeaChiPum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,42},{-44,20}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uLeaChiEna"),
        Text(
          extent={{62,10},{98,-6}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yUp"),
        Text(
          extent={{-100,150},{100,110}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,-18},{-44,-40}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uLeaChiOn"),
        Text(
          extent={{-98,-68},{-26,-90}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uLeaChiWatReq"),
        Text(
          extent={{-94,90},{-74,74}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uPla")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Block that enable and disable leading primary chilled water pump, for plants
with dedicated primary chilled water pumps and parallel chillers, 
according to ASHRAE Guideline36-2021, section 5.20.6.6.
</p>
<p>
The lead primary chilled water pump should be enabled when the plant is enabled
(<code>uPla</code> = true). It should be disabled when the lead 
chiller is disabled (<code>uLeaChiEna</code> = false) and either the lead chiller
has been proven off (<code>uLeaChiSta</code> = false) for 3 minutes or is not
requesting chilled water flow (<code>uLeaChiWatReq</code> = false).
</p>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableLead_dedicated;
