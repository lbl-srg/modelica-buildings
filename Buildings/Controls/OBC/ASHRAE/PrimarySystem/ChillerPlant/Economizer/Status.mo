within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer;
block Status "Water side economizer enable/disable status"

  parameter Modelica.SIunits.Time minDisableTime=20*60
  "Post disable enable delay";

  parameter Modelica.SIunits.TemperatureDifference TOffset=2
  "Additional temperature offset";

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

  CDL.Interfaces.RealInput TOutWet "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-200,80},{-160,120}}),
        iconTransformation(extent={{-140,22},{-100,62}})));

  CDL.Interfaces.BooleanInput uEcoSta
    "Water side economizer enable disable status"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
        iconTransformation(extent={{-140,62},{-100,102}})));
  CDL.Interfaces.RealInput uTowFanSpe "Water side economizer tower fan speed"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealInput VChiWat_flow(final quantity="VolumeFlowRate", final
      unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
    iconTransformation(extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.RealInput TChiWatRet
    "Chiller water return temperature upstream of the water side economizer"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Continuous.Sources.Constant addTOffset(k=TOffset)
    "Additional temperature offset"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  CDL.Continuous.Greater gre
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  CDL.Logical.TrueDelay truDel(delayTime=minDisableTime)
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  CDL.Interfaces.BooleanOutput yEcoSta
    "Water side economizer enable disable status"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Tuning wseTun
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  PredictedOutletTemperature wseTOut
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
equation
  connect(addTOffset.y, add2.u2) annotation (Line(points={{21,-10},{28,-10},{28,
          4},{38,4}},
                    color={0,0,127}));
  connect(add2.y, gre.u2) annotation (Line(points={{61,10},{70,10},{70,42},{78,42}},
        color={0,0,127}));
  connect(TChiWatRet, gre.u1) annotation (Line(points={{-180,60},{-60,60},{-60,88},
          {70,88},{70,50},{78,50}},       color={0,0,127}));
  connect(gre.y, and2.u1) annotation (Line(points={{101,50},{110,50},{110,-10},{
          118,-10}},
                color={255,0,255}));
  connect(uEcoSta, truDel.u) annotation (Line(points={{-180,20},{-50,20},{-50,-30},
          {58,-30}},color={255,0,255}));
  connect(and2.u2, truDel.y) annotation (Line(points={{118,-18},{100,-18},{100,-30},
          {81,-30}},color={255,0,255}));
  connect(and2.y, yEcoSta) annotation (Line(points={{141,-10},{152,-10},{152,-40},
          {170,-40}},
               color={255,0,255}));
  connect(uEcoSta, wseTun.uEcoSta) annotation (Line(points={{-180,20},{-132,20},
          {-132,-45},{-82,-45}}, color={255,0,255}));
  connect(uTowFanSpe, wseTun.uTowFanSpe) annotation (Line(points={{-180,-100},{
          -132,-100},{-132,-55},{-82,-55}},
                                       color={0,0,127}));
  connect(wseTun.yTunPar, wseTOut.uTunPar) annotation (Line(points={{-59,-50},{-40,
          -50},{-40,42},{-22,42}}, color={0,0,127}));
  connect(TOutWet, wseTOut.TOutWet) annotation (Line(points={{-180,100},{-40,100},
          {-40,58},{-22,58}}, color={0,0,127}));
  connect(wseTOut.VChiWat_flow, TChiWatRet) annotation (Line(points={{-22,50},{-80,
          50},{-80,60},{-180,60}}, color={0,0,127}));
  connect(wseTOut.TEcoOut_pred, add2.u1) annotation (Line(points={{2,50},{20,50},
          {20,16},{38,16}}, color={0,0,127}));
  annotation (defaultComponentName = "wseSta",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-120},{160,120}})),
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
end Status;
