within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences;
block PredictedOutletTemperature
  "Waterside economizer predicted outlet temperature"

  parameter Real heaExcAppDes(
    final unit="K",
    final quantity="TemperatureDifference")=2
    "Design heat exchanger approach";

  parameter Real cooTowAppDes(
    final unit="K",
    final quantity="TemperatureDifference")=2
    "Design cooling tower approach";

  parameter Real TOutWetDes(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=288.15
    "Design outdoor air wet bulb temperature";

  parameter Real VHeaExcDes_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    displayUnit="m3/s")=0.01
      "Desing heat exchanger chilled water flow rate";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTunPar(
    final min=-0.2,
    final max=0.5) "Tuning parameter"
    annotation (Placement(transformation(extent={{-200,-160},{-160,-120}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutWet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-200,120},{-160,160}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured (secondary for primary-secondary plants) chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final quantity="ThermodynamicTemperature",
    final unit="K")
    "Predicted waterside economizer outlet temperature"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
    iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Divide heaExcPlr
    "Heat exchanger flow part load ratio"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaExcDes_flow(
    final k= VHeaExcDes_flow) "Heat exchanger design flow"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaAppDes(
    final k=heaExcAppDes)
    "Heat exchanger design approach"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply pro "Product"
    annotation (Placement(transformation(extent={{0,44},{20,64}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1 "Subtraction"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TWetDes(
    final k=TOutWetDes)
    "Design outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply pro1 "Product"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant towAppDes(
    final k=cooTowAppDes)
    "Cooling tower design approach"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final nin=4)
    "Sum of multiple inputs"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Min min1
    "Lesser of the input"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));

equation
  connect(heaExcPlr.u2, heaExcDes_flow.y) annotation (Line(points={{-82,64},{-90,
          64},{-90,50},{-98,50}},        color={0,0,127}));
  connect(VChiWat_flow, heaExcPlr.u1) annotation (Line(points={{-180,0},{-140,0},
          {-140,76},{-82,76}}, color={0,0,127}));
  connect(heaAppDes.y, pro.u2) annotation (Line(points={{-18,30},{-10,30},{-10,48},
          {-2,48}},      color={0,0,127}));
  connect(sub1.y, pro1.u1) annotation (Line(points={{-38,-50},{-20,-50},{-20,-44},
          {-2,-44}},       color={0,0,127}));
  connect(uTunPar, pro1.u2) annotation (Line(points={{-180,-140},{-20,-140},{-20,
          -56},{-2,-56}},  color={0,0,127}));
  connect(TOutWet, mulSum.u[1]) annotation (Line(points={{-180,140},{60,140},{60,
          -0.75},{78,-0.75}},
                            color={0,0,127}));
  connect(pro.y, mulSum.u[2]) annotation (Line(points={{22,54},{40,54},{40,-0.25},
          {78,-0.25}},color={0,0,127}));
  connect(pro1.y, mulSum.u[3]) annotation (Line(points={{22,-50},{40,-50},{40,0.25},
          {78,0.25}},       color={0,0,127}));
  connect(towAppDes.y, mulSum.u[4]) annotation (Line(points={{42,-90},{60,-90},{
          60,-2},{78,-2},{78,0.75}},  color={0,0,127}));
  connect(mulSum.y, y)
    annotation (Line(points={{102,0},{180,0}}, color={0,0,127}));
  connect(TOutWet, sub1.u2) annotation (Line(points={{-180,140},{-150,140},{-150,
          -56},{-62,-56}}, color={0,0,127}));
  connect(TWetDes.y, sub1.u1) annotation (Line(points={{-98,-30},{-80,-30},{-80,
          -44},{-62,-44}}, color={0,0,127}));
  connect(heaExcPlr.y, min1.u2) annotation (Line(points={{-58,70},{-50,70},{-50,
          64},{-42,64}}, color={0,0,127}));
  connect(con.y, min1.u1) annotation (Line(points={{-58,110},{-50,110},{-50,76},
          {-42,76}}, color={0,0,127}));
  connect(min1.y, pro.u1) annotation (Line(points={{-18,70},{-10,70},{-10,60},{-2,
          60}}, color={0,0,127}));
    annotation (defaultComponentName = "wseTOut",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-160,-180},{160,180}})),
Documentation(info="<html>
<p>
The waterside economizer (WSE) is enabled or disabled based on the predicted WSE
heat exchanger (HX) leaving water temperature, <code>y</code>.
This block predicts <code>y</code> based on current plant load
and ambient wet bulb temperature with resepect to the design conditions, as described in
ASHRAE RP-1711, March 2020, section 5.2.3.1.
</p>
<p>
The block calculates the predicted WSE output temperature <code>y</code> as a sum of these
three components:
</p>
<ul>
<li>
Current outoor air wet bulb temperature <code>TOutWet</code>.
</li>
<li>
Predicted heat exchanger approach at current part load flow, which equals
the product of the design heat exchanger approach <code>heaExcAppDes</code> and the
lesser of 1 and predicted heat exchanger part load ratio (PLRHX). PRLHX is a ratio
of the current chilled water flow rate for primary-only plants or the current secondary chilled water
flow rate for primary-secondary plants, <code>VChiWat_flow</code>,
divided by design HX chilled water flow rate <code>VHeaExcDes_flow</code>.
</li>
<li>
Predicted cooling tower approach, which is a sum of the:
<ul>
<li>
Product of the tuning parameter <code>uTunPar</code> and the
difference between the design <code>TOutWetDes</code> and current
wetbulb temepratures <code>TOutWet</code>.
The tuning parameter <code>uTunPar</code> is an output from the
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.Tuning\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.Tuning</a> sequence.
</li>
<li>
Design cooling tower approach <code>cooTowAppDes</code>.
</li>
</ul>
</li>
</ul>
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
