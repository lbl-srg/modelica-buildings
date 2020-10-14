within Buildings.Controls.OBC.FDE.DOAS;
block TSupSet
  "This block caclulates the DOAS supply air temperature set point."

  parameter Real loPriT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=273.15+20
   "Minimum primary supply air temperature reset value";

  parameter Real hiPriT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=273.15+24
   "Maximum primary supply air temperature reset value";

  parameter Real hiZonT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=273.15+25
   "Maximum zone temperature reset value";

  parameter Real loZonT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=273.15+21
   "Minimum zone temperature reset value";

  parameter Real coAdj(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=2
   "Supply air temperature cooling set point offset.";

  parameter Real heAdj(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=2
   "Supply air temperature heating set point offset.";

  // ---inputs---
  Buildings.Controls.OBC.CDL.Interfaces.RealInput highSpaceT(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")
    "Highest space temperature reported from all terminal units."
      annotation (Placement(transformation(extent={{-142,-18},{-102,22}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput dehumMode
    "True when dehumidification mode is active."
      annotation (Placement(transformation(extent={{-142,-102},{-102,-62}}),
        iconTransformation(extent={{-140,30},{-100,70}})));

  // ---outputs---
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput supCooSP
    "Supply air temperature cooling set point."
      annotation (Placement(transformation(extent={{102,16},{142,56}}),
        iconTransformation(extent={{102,20},{142,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput supHeaSP
    "Supply air temperature heating set point"
      annotation (Placement(transformation(extent={{102,-52},{142,-12}}),
        iconTransformation(extent={{102,-60},{142,-20}})));


  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Linear converter resets primary supply set point."
    annotation (Placement(transformation(extent={{-42,-8},{-22,12}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowPriT(
    final k=loPriT)
      "Low primary supply temperature set point reset value."
        annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant highPriT(
    final k=hiPriT)
      "High primary supply temperature set point reset value."
        annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant highZoneT(
    final k=hiZonT)
      "High zone temperature set point reset value."
        annotation (Placement(transformation(extent={{-90,-28},{-70,-8}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowZoneT(
    final k=loZonT)
      "Low zone temperature set point reset value."
        annotation (Placement(transformation(extent={{-90,42},{-70,62}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Adds the cooling set point adjustment to the primary set point."
    annotation (Placement(transformation(extent={{22,26},{42,46}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k2=-1)
    "Subtracts the heating set point adjustment from the primary set point."
      annotation (Placement(transformation(extent={{22,-50},{42,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant coolAdj(
    final k=coAdj)
      "Supply air temperature cooling set point offset."
        annotation (Placement(transformation(extent={{-14,44},{6,64}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heatAdj(
    final k=heAdj)
      "Supply air temperature heating set point offset."
      annotation (Placement(transformation(extent={{-14,-66},{6,-46}})));
  Buildings.Controls.OBC.CDL.Logical.Switch dehumSwi
    "Logical switch changes heating set point based on dehumidification mode."
    annotation (Placement(transformation(extent={{66,-42},{86,-22}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput supPrimSP
    "Supply air primary temperature set point."
      annotation (Placement(transformation(extent={{102,-18},{142,22}}),
          iconTransformation(extent={{102,-20},{142,20}})));
equation
  connect(lin.u, highSpaceT)
    annotation (Line(points={{-44,2},{-122,2}}, color={0,0,127}));
  connect(heatAdj.y, add1.u2)
    annotation (Line(points={{8,-56},{14,-56},{14,-46},{20,-46}},
      color={0,0,127}));
  connect(coolAdj.y, add2.u1)
    annotation (Line(points={{8,54},{14,54},{14,42},{20,42}},
      color={0,0,127}));
  connect(lin.y, add2.u2)
    annotation (Line(points={{-20,2},{2,2},{2,30},{20,30}}, color={0,0,127}));
  connect(lin.y, add1.u1)
    annotation (Line(points={{-20,2},{2,2},{2,-34},{20,-34}},
        color={0,0,127}));
  connect(add1.y, dehumSwi.u3)
    annotation (Line(points={{44,-40},{64,-40}}, color={0,0,127}));
  connect(add2.y, supCooSP)
    annotation (Line(points={{44,36},{122,36}}, color={0,0,127}));
  connect(dehumSwi.y, supHeaSP)
    annotation (Line(points={{88,-32},{122,-32}}, color={0,0,127}));
  connect(add2.y, dehumSwi.u1)
    annotation (Line(points={{44,36},{54,36},{54,-24},{64,-24}},
      color={0,0,127}));
  connect(dehumSwi.u2, dehumMode)
    annotation (Line(points={{64,-32},{54,-32},{54,-82},{-122,-82}},
      color={255,0,255}));
  connect(highZoneT.y, lin.x2)
    annotation (Line(points={{-68,-18},{-58,-18},{-58,-2},{-44,-2}},
      color={0,0,127}));
  connect(lowZoneT.y, lin.x1)
    annotation (Line(points={{-68,52},{-52,52},{-52,10},{-44,10}},
      color={0,0,127}));
  connect(highPriT.y, lin.f1)
    annotation (Line(points={{-68,20},{-56,20},{-56,6},{-44,6}},
      color={0,0,127}));
  connect(lowPriT.y, lin.f2)
    annotation (Line(points={{-68,-50},{-52,-50},{-52,-6},{-44,-6}},
      color={0,0,127}));
  connect(lin.y, supPrimSP)
    annotation (Line(points={{-20,2},{122,2}}, color={0,0,127}));
  annotation (defaultComponentName="TSupSetpt",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
           Text(
            extent={{-90,180},{90,76}},
            lineColor={28,108,200},
            textStyle={TextStyle.Bold},
            textString="%name"),
            Rectangle(extent={{-100,100},{100,-100}},
            lineColor={179,151,128},
            radius=10,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
        Text(
          extent={{-94,-40},{-40,-58}},
          lineColor={28,108,200},
          textString="highSpaceT"),
        Text(
          extent={{-94,60},{-40,42}},
          lineColor={28,108,200},
          textString="dehumMode"),
        Text(
          extent={{40,50},{94,32}},
          lineColor={28,108,200},
          textString="supCooSP"),
        Text(
          extent={{42,-30},{96,-48}},
          lineColor={28,108,200},
          textString="supHeaSP"),
        Rectangle(
          extent={{14,22},{18,-22}},
          lineColor={0,140,72},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,22},{18,60}},
          lineColor={238,46,47},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,-60},{18,-22}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-4},{6,-6}},
          lineColor={162,29,33},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{6,-4},{-8,6},{-12,-4},{6,-4}},
          lineColor={162,29,33},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{42,8},{96,-10}},
          lineColor={28,108,200},
          textString="supPrimSP")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
September 14, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>", info="<html>
<h4>Supply Temperature Set Points</h4>
<p>This block calculates the primary, cooling
(<code>supCooSP</code>), and heating
(<code>supHeaSP</code>) supply air temperature set points.
The primary supply air temperature set point is reset from
<code>loPriT</code> to <code>hiPriT</code> as the highest
space temperature (<code>highSpaceT</code>) falls from 
<code>hiZonT</code> to <code>loZonT</code>.</p>
<p>The supply air cooling set point is equal to the primary
air temperature set point plus <code>ccAdj</code>. The supply
air heating set point is equal to the primary air temperature
set point minus <code>ccAdj</code>. 
<h4>Dehumidification Set Point</h4>
<p>When dehumidification mode (<code>dehumMode</code>) is active the supply air
temperature heating set point is changed to equal the
supply air temperature cooling set point.</p> 
</html>"));
end TSupSet;
