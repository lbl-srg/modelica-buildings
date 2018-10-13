within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer;
block PredictedOutletTemperature
  "Water side economizer predicted outlet temperature"

  parameter Modelica.SIunits.TemperatureDifference heaExcAppDes=2
  "Design heat exchanger approach";

  parameter Modelica.SIunits.TemperatureDifference cooTowAppDes=2
  "Design cooling tower approach";

  parameter Modelica.SIunits.Temperature TOutWetDes=288.15
  "Design outdoor air wet bulb temperature";

  parameter Real VHeaExcDes_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")=0.1
  "Desing heat exchanger water flow rate";

  CDL.Interfaces.RealOutput TEcoOut_pred
    "Predicted water side economizer outlet temperature"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  CDL.Interfaces.RealInput uTunPar "Tuning parameter"
    annotation (Placement(transformation(extent={{-200,-160},{-160,-120}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  CDL.Interfaces.RealInput TOutWet "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-200,120},{-160,160}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Continuous.Division heaExcPlr "Heat exchanger flow part load ratio"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  CDL.Continuous.Sources.Constant des_flow(k=VHeaExcDes_flow)
    "Heat exchanger design flow"
    annotation (Placement(transformation(extent={{-112,40},{-92,60}})));
  CDL.Continuous.Sources.Constant heaAppDes(k=heaExcAppDes)
    "Heat exchanger design approach"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{-20,44},{0,64}})));
  CDL.Continuous.Add add1(k1=-1)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  CDL.Continuous.Sources.Constant TWetDes(k=TOutWetDes)
    "Design outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  CDL.Continuous.Product pro1
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  CDL.Continuous.Sources.Constant towAppDes1(k=cooTowAppDes)
    "Cooling tower design approach"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  CDL.Continuous.MultiSum mulSum(nin=4)
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  CDL.Continuous.Limiter lim(uMax=1, uMin=0)
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
  connect(TOutWet, mulSum.u[1]) annotation (Line(points={{-180,140},{46,140},{46,
          5.25},{78,5.25}}, color={0,0,127}));
  connect(pro.y, mulSum.u[2]) annotation (Line(points={{1,54},{30,54},{30,1.75},
          {78,1.75}}, color={0,0,127}));
  connect(pro1.y, mulSum.u[3]) annotation (Line(points={{1,-50},{30,-50},{30,-1.75},
          {78,-1.75}}, color={0,0,127}));
  connect(towAppDes1.y, mulSum.u[4]) annotation (Line(points={{41,-90},{48,-90},
          {48,-5.25},{78,-5.25}}, color={0,0,127}));
  connect(mulSum.y, TEcoOut_pred)
    annotation (Line(points={{101.7,0},{180,0}}, color={0,0,127}));
  connect(heaExcPlr.y, lim.u)
    annotation (Line(points={{-59,70},{-52,70}}, color={0,0,127}));
  connect(pro.u1, lim.y) annotation (Line(points={{-22,60},{-26,60},{-26,70},{-29,
          70}}, color={0,0,127}));
    annotation (defaultComponentName = "wseTOut",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
                                      Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-160,-180},{160,180}})),
Documentation(info="<html>
<p>
Fixme
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
