within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences;
block PredictedOutletTemperature
  "waterside economizer predicted outlet temperature"

  parameter Modelica.SIunits.TemperatureDifference heaExcAppDes=2
  "Design heat exchanger approach";

  parameter Modelica.SIunits.TemperatureDifference cooTowAppDes=2
  "Design cooling tower approach";

  parameter Modelica.SIunits.Temperature TOutWetDes=288.15
  "Design outdoor air wet bulb temperature";

  parameter Real VHeaExcDes_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")=0.01
  "Desing heat exchanger chilled water flow rate";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTunPar(min=-0.2, max=0.5) "Tuning parameter"
    annotation (Placement(transformation(extent={{-200,-160},{-160,-120}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutWet "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-200,120},{-160,160}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final quantity="ThermodynamicTemperature",
    final unit="K")
    "Predicted waterside economizer outlet temperature"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
    iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Division heaExcPlr
    "Heat exchanger flow part load ratio"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant des_flow(
    final k=VHeaExcDes_flow)
    "Heat exchanger design flow"
    annotation (Placement(transformation(extent={{-112,40},{-92,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaAppDes(
    final k=heaExcAppDes)
    "Heat exchanger design approach"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product"
    annotation (Placement(transformation(extent={{-20,44},{0,64}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k1=-1) "Adder"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TWetDes(
    final k=TOutWetDes)
    "Design outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro1 "Product"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant towAppDes1(
    final k=cooTowAppDes)
    "Cooling tower design approach"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final nin=4)
    "Sum of multiple inputs"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Limiter lim(
    final uMax=1,
    final uMin=0) "Limiter"
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));

equation
  connect(heaExcPlr.u2, des_flow.y) annotation (Line(points={{-82,64},{-88,64},{
          -88,50},{-91,50}}, color={0,0,127}));
  connect(VChiWat_flow, heaExcPlr.u1) annotation (Line(points={{-180,0},{-120,0},
          {-120,76},{-82,76}}, color={0,0,127}));
  connect(heaAppDes.y, pro.u2) annotation (Line(points={{-39,30},{-32,30},{-32,48},
          {-22,48}}, color={0,0,127}));
  connect(TOutWet, add1.u1) annotation (Line(points={{-180,140},{-130,140},{-130,
          -44},{-62,-44}}, color={0,0,127}));
  connect(TWetDes.y, add1.u2) annotation (Line(points={{-79,-70},{-72,-70},{-72,
          -56},{-62,-56}}, color={0,0,127}));
  connect(add1.y, pro1.u1) annotation (Line(points={{-39,-50},{-30,-50},{-30,-44},
          {-22,-44}}, color={0,0,127}));
  connect(uTunPar, pro1.u2) annotation (Line(points={{-180,-140},{-30,-140},{-30,
          -56},{-22,-56}}, color={0,0,127}));
  connect(TOutWet, mulSum.u[1]) annotation (Line(points={{-180,140},{60,140},{
          60,1.5},{78,1.5}},color={0,0,127}));
  connect(pro.y, mulSum.u[2]) annotation (Line(points={{1,54},{20,54},{20,0.5},
          {78,0.5}},  color={0,0,127}));
  connect(pro1.y, mulSum.u[3]) annotation (Line(points={{1,-50},{20,-50},{20,-0.5},
          {78,-0.5}},  color={0,0,127}));
  connect(towAppDes1.y, mulSum.u[4]) annotation (Line(points={{41,-90},{60,-90},
          {60,-2},{78,-2},{78,-1.5}}, color={0,0,127}));
  connect(mulSum.y, y)
    annotation (Line(points={{101,0},{180,0}}, color={0,0,127}));
  connect(heaExcPlr.y, lim.u)
    annotation (Line(points={{-59,70},{-52,70}}, color={0,0,127}));
  connect(pro.u1, lim.y)
    annotation (Line(points={{-22,60},{-26,60},{-26,70},{-29,70}},
      color={0,0,127}));
    annotation (defaultComponentName = "wseTOut",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-160,-180},{160,180}})),
Documentation(info="<html>
<p>
This algorithm predicts the achievable WSE output temperature based on current plant load conditions
and ambient wet bulb temperature relative to design conditions, as described in
OBC Chilled Water Plant Sequence of Operation, section 3.2.3.1. The tuning parameter 
<code>uTunPar</code> is an output from the <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences.Tuning\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences.Tuning</a> sequence.
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
end PredictedOutletTemperature;
