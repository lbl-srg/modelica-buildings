within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences;
block EnableLead_headered
  "Sequence for enabling lead pump of plants with headered condenser water pumps"

 Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseConIsoVal
    "WSE condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiConIsoVal
    "Chiller condenser water isolation valve status"
      annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaPum
    "Lead pump status"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch leaPumSta "Lead pump status"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(final k=false)
    "Logical false"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=true)
    "Logical true"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(con1.y, leaPumSta.u3)
    annotation (Line(points={{-19,-40},{0,-40},{0,-8},{18,-8}},
      color={255,0,255}));
  connect(con.y, leaPumSta.u1)
    annotation (Line(points={{-19,40},{0,40},{0,8},{18,8}}, color={255,0,255}));
  connect(leaPumSta.y, yLeaPum)
    annotation (Line(points={{41,0},{72,0},{72,0},{110,0}}, color={255,0,255}));
  connect(or2.y, leaPumSta.u2)
    annotation (Line(points={{-19,0},{18,0}}, color={255,0,255}));
  connect(uWseConIsoVal, or2.u2)
    annotation (Line(points={{-120,-20},{-60,-20},{-60,-8},{-42,-8}},
      color={255,0,255}));
  connect(uChiConIsoVal, or2.u1)
    annotation (Line(points={{-120,20},{-60,20},{-60,0},{-42,0}},
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
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,52},{-44,30}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiConIsoVal"),
        Text(
          extent={{42,12},{96,-10}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yLeaPum"),
        Text(
          extent={{-98,-28},{-44,-50}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWseConIsoVal")}),
   Diagram(coordinateSystem(preserveAspectRatio=false)),
   Documentation(info="<html>
<p>
Block that enable and disable lead condenser water pump, for plants
with headered condenser water pumps, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.9 Condenser water pumps, part 5.2.9.1 and section 5.2.9.2.
</p>
<ol>
<li>
Condenser water pumps shall be lead-lag.
</li>
<li>
The lead condenser water pump shall be enabled when condenser water 
isolation valve of any chiller <code>uChiConIsoVal</code> or water side economizer 
<code>uWseConIsoVal</code> is commanded open. It shall be disabled when 
all chiller and water side economizer condenser water isolation valves are 
commanded closed.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
January 28, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableLead_headered;
