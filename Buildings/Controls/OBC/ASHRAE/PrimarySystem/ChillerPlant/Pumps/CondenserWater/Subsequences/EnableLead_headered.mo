within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences;
block EnableLead_headered
  "Sequence for enabling lead pump of plants with headered condenser water pumps"
  parameter Boolean have_WSE = true
    "Flag of waterside economizer: true=have WSE, false=no WSE";
  parameter Integer nChi=2 "Total number of chiller";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseConIsoVal
    if have_WSE "WSE condenser water isolation valve commanded status"
    annotation (Placement(transformation(extent={{-140,-28},{-100,12}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiConIsoVal[nChi]
    "Chiller condenser water isolation valve commanded status"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaPla
    "True: plant is just enabled"
    annotation(Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLea "Lead pump status"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Switch leaPumSta "Lead pump status"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false) "Logical false"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true) "Logical true"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=false) if not have_WSE
    "Logical false"
    annotation (Placement(transformation(extent={{-80,-48},{-60,-28}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nChi)
    "Check if there is any chiller enabled"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1 "Logical or"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

equation
  connect(con1.y, leaPumSta.u3)
    annotation (Line(points={{2,-80},{40,-80},{40,-8},{58,-8}},
      color={255,0,255}));
  connect(con.y, leaPumSta.u1)
    annotation (Line(points={{2,80},{40,80},{40,8},{58,8}}, color={255,0,255}));
  connect(leaPumSta.y, yLea)
    annotation (Line(points={{82,0},{120,0}}, color={255,0,255}));
  connect(uWseConIsoVal, or2.u2)
    annotation (Line(points={{-120,-8},{-42,-8}},
      color={255,0,255}));
  connect(con2.y, or2.u2)
    annotation (Line(points={{-58,-38},{-50,-38},{-50,-8},{-42,-8}},
      color={255,0,255}));
  connect(uChiConIsoVal, mulOr.u)
    annotation (Line(points={{-120,50},{-82,50}}, color={255,0,255}));
  connect(mulOr.y, or2.u1)
    annotation (Line(points={{-58,50},{-50,50},{-50,0},{-42,0}},
      color={255,0,255}));
  connect(or2.y, or1.u1) annotation (Line(points={{-18,0},{-2,0}},
               color={255,0,255}));
  connect(uEnaPla, or1.u2) annotation (Line(points={{-120,-60},{-10,-60},{-10,-8},
          {-2,-8}}, color={255,0,255}));
  connect(or1.y, leaPumSta.u2)
    annotation (Line(points={{22,0},{58,0}}, color={255,0,255}));

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
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,72},{-44,50}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiConIsoVal"),
        Text(
          extent={{42,12},{96,-10}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yLeaPum"),
        Text(
          extent={{-98,12},{-44,-10}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWseConIsoVal"),
        Text(
          extent={{-98,-50},{-58,-68}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uEnaPla")}),
   Diagram(coordinateSystem(preserveAspectRatio=false)),
   Documentation(info="<html>
<p>
Block that enable and disable lead condenser water pump, for plants
with headered condenser water pumps, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft on March 23, 2020), 
section 5.2.9 Condenser water pumps, part 5.2.9.2-3.
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
