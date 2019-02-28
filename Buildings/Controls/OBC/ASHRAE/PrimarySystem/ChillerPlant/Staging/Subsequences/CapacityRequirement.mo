within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block CapacityRequirement
  "Cooling capacity requirement"

  parameter Modelica.SIunits.Density watDen = 1000 "Water density";

  parameter Modelica.SIunits.SpecificHeatCapacity watSpeHea = 4184
  "Specific heat capacity of water";

  parameter Modelica.SIunits.Time avePer = 5*60
  "Period for the rolling average";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
    iconTransformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final quantity="Power",
    final unit="W") "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant density(
    final k = watDen)
    "Water density"
    annotation (Placement(transformation(extent={{-80,-32},{-60,-12}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant speHeaCap(
    final k = watSpeHea)
    "Specific heat capacity of water"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minLim(
    final k=0)
    "Minimum capacity requirement limit"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k1=-1) "Adder"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(
    final delta=avePer)
    "Moving average"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro1 "Product"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro2 "Product"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max "Maximum of two inputs"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

equation
  connect(TChiWatRet, add2.u2) annotation (Line(points={{-120,20},{-60,20},{-60,
          24},{-42,24}}, color={0,0,127}));
  connect(add2.u1, TChiWatSupSet) annotation (Line(points={{-42,36},{-60,36},{-60,
          80},{-120,80}}, color={0,0,127}));
  connect(add2.y, pro.u1) annotation (Line(points={{-19,30},{-10,30},{-10,6},{28,
          6}}, color={0,0,127}));
  connect(pro.y, movMea.u)
    annotation (Line(points={{51,0},{58,0}}, color={0,0,127}));
  connect(speHeaCap.y, pro1.u2) annotation (Line(points={{-59,-70},{-50,-70},{-50,
          -66},{-42,-66}}, color={0,0,127}));
  connect(pro1.y, pro2.u2) annotation (Line(points={{-19,-60},{-10,-60},{-10,-36},
          {-2,-36}}, color={0,0,127}));
  connect(pro.u2, pro2.y) annotation (Line(points={{28,-6},{24,-6},{24,-30},{21,
          -30}}, color={0,0,127}));
  connect(pro1.u1, density.y) annotation (Line(points={{-42,-54},{-50,-54},{-50,
          -22},{-59,-22}}, color={0,0,127}));
  connect(VChiWat_flow, pro2.u1) annotation (Line(points={{-120,-50},{-80,-50},{
          -80,-40},{-20,-40},{-20,-24},{-2,-24}}, color={0,0,127}));
  connect(max.u1, minLim.y) annotation (Line(points={{58,56},{50,56},{50,60},{41,
          60}}, color={0,0,127}));
  connect(movMea.y, max.u2) annotation (Line(points={{81,0},{82,0},{82,30},{50,30},
          {50,44},{58,44}}, color={0,0,127}));
  connect(max.y, y) annotation (Line(points={{81,50},{90,50},{90,0},{110,0}},
        color={0,0,127}));
  annotation (defaultComponentName = "capReq",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-78,-14},{44,-178}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Load
")}),                            Diagram(
        coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
Calculates cooling capacity requirement based on the measured chilled water return temperature
(CHWRT), <code>TChiWatRet<\code>, calculated chilled water supply temperature setpoint (CHWST setpoint),
<code>TChiWatSupSet<\code>, and the measured chilled water flow, <code>VChiWat_flow<\code>.
<li>
The calculation is according to OBC Chilled Water Plant Sequence of Operation document, section 3.2.4.3. 
</li>
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end CapacityRequirement;
