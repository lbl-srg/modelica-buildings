within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences;
block EnableLead_dedicated
  "Sequence to enable or disable the lead pump of plants with dedicated primary chilled water pumps"

  final parameter Real offTimThr(
    final unit="s",
    final quantity="Time")=180
      "Threshold to check lead chiller off time";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiEna
    "Lead chiller enabling status"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiSta
    "Lead chiller status"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiWatReq
    "Status indicating if chiller is requesting chilled water"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLea "Lead pump status"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.Latch leaPumSta(
    final pre_y_start=true)
    "Lead pump status"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim "Measures chiller OFF time"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=offTimThr)
    "Check if the chiller has been OFF for more than 3 minutes"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

equation
  connect(uLeaChiWatReq, not1.u)
    annotation (Line(points={{-120,-80},{-82,-80}}, color={255,0,255}));
  connect(uLeaChiEna, leaPumSta.u)
    annotation (Line(points={{-120,80},{58,80}}, color={255,0,255}));
  connect(leaPumSta.y, yLea)
    annotation (Line(points={{82,80},{120,80}}, color={255,0,255}));
  connect(uLeaChiSta, not2.u)
    annotation (Line(points={{-120,0},{-82,0}}, color={255,0,255}));
  connect(not2.y, tim.u)
    annotation (Line(points={{-58,0},{-42,0}}, color={255,0,255}));
  connect(tim.y, greEquThr.u)
    annotation (Line(points={{-18,0},{-2,0}}, color={0,0,127}));
  connect(greEquThr.y, or2.u1)
    annotation (Line(points={{22,0},{38,0}}, color={255,0,255}));
  connect(not1.y, or2.u2)
    annotation (Line(points={{-58,-80},{30,-80},{30,-8},{38,-8}},
      color={255,0,255}));
  connect(uLeaChiEna, not3.u)
    annotation (Line(points={{-120,80},{-80,80},{-80,50},{-62,50}},
      color={255,0,255}));
  connect(not3.y, and2.u1)
    annotation (Line(points={{-38,50},{-2,50}},
      color={255,0,255}));
  connect(or2.y, and2.u2)
    annotation (Line(points={{62,0},{80,0},{80,20},{-20,20},{-20,42},{-2,42}},
      color={255,0,255}));
  connect(and2.y, leaPumSta.clr)
    annotation (Line(points={{22,50},{40,50},{40,74},{58,74}}, color={255,0,255}));

annotation (
  defaultComponentName="enaLeaChiPum",
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
          extent={{62,10},{98,-6}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yUp"),
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
          textString="uLeaChiWatReq")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Block that enable and disable leading primary chilled water pump, for plants
with headered primary chilled water pumps and parallel chillers,
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 6 on July 25, 2019),
section 5.2.6 Primary chilled water pumps, part 5.2.6.5.
</p>
<p>
The lead primary chilled water pump should be enabled when lead chiller is commanded
to run (<code>uLeaChiEna</code> = true). It should be disabled when the lead
chiller is disabled and either the lead chiller has been proven off (<code>uLeaChiSta</code>
= false) for 3 minutes or is not requesting chilled water flow
(<code>uLeaChiWatReq</code> = false).
</p>
</html>", revisions="<html>
<ul>
<li>
August 1, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableLead_dedicated;
