within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Setpoints;
block ChilledWaterSupply
  "Sequences to generate setpoints of chilled water supply temperaturea and the pump differential static pressure"

  parameter Modelica.SIunits.PressureDifference dpChiWatPumMin(
    final min=0,
    displayUnit="Pa")
    "Minimum chilled water pump differential static pressure";
  parameter Modelica.SIunits.PressureDifference dpChiWatPumMax(
    final min=dpChiWatPumMin,
    displayUnit="Pa")
    "Maximum chilled water pump differential static pressure";
  parameter Modelica.SIunits.ThermodynamicTemperature TChiWatSupMin(
    displayUnit="K")
    "Minimum chilled water supply temperature, typically the design chilled water temperature 
    for plants with variable speed chillers but should be 1~2 degF lower for constant speed
    plants";
  parameter Modelica.SIunits.ThermodynamicTemperature TChiWatSupMax(
    final min=TChiWatSupMin,
    displayUnit="K")
    "Maximum chilled water supply temperature";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatPlaRes(
    final min = 0,
    final max = 1,
    final unit = "1")
    "Chilled water plant reset"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{80,40},{100,60}}),
      iconTransformation(extent={{100,40},{120,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}}),
      iconTransformation(extent={{100,-60},{120,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Line chiWatPumPre
    "Chilled water pump differential pressure setpoint"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerRes(
    final k=0) "Zero plant reset"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant halRes(
    final k=0.5) "Half one plant reset"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneRes(
    final k=1) "One plant reset"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minChiWatPumPre(
    final k=dpChiWatPumMin)
    "Minimum chilled water pump differential pressure setpoint"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxChiWatPumPre(
    final k=dpChiWatPumMax)
    "Maximum chilled water pump differential pressure setpoint"
    annotation (Placement(transformation(extent={{-20,18},{0,38}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxChiWatTem(
    final k=TChiWatSupMax)
    "Maximum chilled water supply temperature"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minChiWatTem(
    final k=TChiWatSupMin)
    "Minimum chilled water supply temperature"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Line chiWatTem
    "Chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

equation
  connect(zerRes.y, chiWatPumPre.x1)
    annotation (Line(points={{-39,90},{20,90},{20,58},{38,58}},
      color={0,0,127}));
  connect(minChiWatPumPre.y, chiWatPumPre.f1)
    annotation (Line(points={{1,70},{14,70},{14,54},{38,54}},
      color={0,0,127}));
  connect(halRes.y, chiWatPumPre.x2)
    annotation (Line(points={{-39,0},{20,0},{20,46},{38,46}},
      color={0,0,127}));
  connect(maxChiWatPumPre.y, chiWatPumPre.f2)
    annotation (Line(points={{1,28},{14,28},{14,42},{38,42}},
      color={0,0,127}));
  connect(halRes.y, chiWatTem.x1)
    annotation (Line(points={{-39,0},{20,0},{20,-42},{38,-42}},
      color={0,0,127}));
  connect(maxChiWatTem.y, chiWatTem.f1)
    annotation (Line(points={{1,-30},{14,-30},{14,-46},{38,-46}},
      color={0,0,127}));
  connect(oneRes.y, chiWatTem.x2)
    annotation (Line(points={{-39,-90},{14,-90},{14,-54},{38,-54}},
      color={0,0,127}));
  connect(minChiWatTem.y, chiWatTem.f2)
    annotation (Line(points={{1,-70},{20,-70},{20,-58},{38,-58}},
      color={0,0,127}));
  connect(uChiWatPlaRes, chiWatPumPre.u)
    annotation (Line(points={{-100,0},{-70,0},{-70,50},{38,50}},
      color={0,0,127}));
  connect(uChiWatPlaRes, chiWatTem.u)
    annotation (Line(points={{-100,0},{-70,0},{-70,-50},{38,-50}},
      color={0,0,127}));
  connect(chiWatPumPre.y, dpChiWatPumSet)
    annotation (Line(points={{61,50},{90,50}}, color={0,0,127}));
  connect(chiWatTem.y, TChiWatSupSet)
    annotation (Line(points={{61,-50},{90,-50}}, color={0,0,127}));

annotation (
  defaultComponentName="chiWatSupSet",
  Diagram(coordinateSystem(preserveAspectRatio=false,
  extent={{-80,-120},{80,120}}), graphics={Rectangle(
          extent={{-78,118},{78,2}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-78,-2},{78,-118}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-26,118},{74,106}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Chilled water pump differential pressure setpoint"),
          Text(
          extent={{-22,-104},{74,-116}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Chilled water supply temperature setpoint")}),
  Icon(graphics={Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,10},{-46,-8}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiWatPlaRes"),
        Text(
          extent={{38,62},{96,38}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpChiWatPumSet"),
        Text(
          extent={{56,-38},{96,-60}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TChiWatSet")}),
Documentation(info="<html>
<p>
Block that output setpoints for the chilled water supply of systems with variable 
speed chiller, including supply temperature setpoint <code>TChiWatSupSet</code> 
and pump differential pressure setpoint <code>dpChiWatPumSet</code>, according 
to ASHRAE Fundamentals of Chilled Water Plant Design and Control SDL, Chapter 7, 
Appendix B, 1.01.B.10.
</p>
<p align=\"center\">
<img alt=\"Image of chilled water supply setpoints\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/ChiWatSupSet_VSChiller.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
March 15, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChilledWaterSupply;
