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
    final unit="m3/s")=0.015
  "Desing heat exchanger water flow rate";

  CDL.Interfaces.RealInput TOutWet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-200,80},{-160,120}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  CDL.Interfaces.RealInput uTowFanSpe "Water side economizer tower fan speed"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealInput VChiWat_flow(final quantity="VolumeFlowRate", final
      unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
    iconTransformation(extent={{-140,-40},{-100,0}})));
  CDL.Interfaces.RealInput TChiWatRet
    "Chiller water return temperature upstream of the water side economizer"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Continuous.Sources.Constant addTOffset(k=TOffset)
    "Additional temperature offset"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  CDL.Continuous.Greater gre
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  CDL.Logical.TrueDelay truDel(delayTime=minDisableTime)
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  CDL.Interfaces.BooleanOutput yEcoSta
    "Water side economizer enable disable status"
    annotation (Placement(transformation(extent={{160,-10},{180,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Tuning wseTun
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  PredictedOutletTemperature wseTOut
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
equation
  connect(addTOffset.y, add2.u2) annotation (Line(points={{-19,10},{-10,10},{
          -10,24},{-2,24}},
                    color={0,0,127}));
  connect(add2.y, gre.u2) annotation (Line(points={{21,30},{30,30},{30,42},{38,
          42}},
        color={0,0,127}));
  connect(TChiWatRet, gre.u1) annotation (Line(points={{-180,40},{-100,40},{
          -100,80},{30,80},{30,50},{38,50}},
                                          color={0,0,127}));
  connect(uTowFanSpe, wseTun.uTowFanSpe) annotation (Line(points={{-180,-100},{
          -132,-100},{-132,-85},{-122,-85}},
                                       color={0,0,127}));
  connect(wseTun.yTunPar, wseTOut.uTunPar) annotation (Line(points={{-99,-80},{
          -80,-80},{-80,42},{-62,42}},
                                   color={0,0,127}));
  connect(TOutWet, wseTOut.TOutWet) annotation (Line(points={{-180,100},{-80,
          100},{-80,58},{-62,58}},
                              color={0,0,127}));
  connect(wseTOut.TEcoOut_pred, add2.u1) annotation (Line(points={{-38,50},{-20,
          50},{-20,36},{-2,36}},
                            color={0,0,127}));
  connect(VChiWat_flow, wseTOut.VChiWat_flow) annotation (Line(points={{-180,
          -40},{-90,-40},{-90,50},{-62,50}},
                                          color={0,0,127}));
  connect(pre.y, wseTun.uEcoSta) annotation (Line(points={{141,-30},{150,-30},{
          150,-60},{-130,-60},{-130,-75},{-122,-75}}, color={255,0,255}));
  connect(gre.y, truDel.u)
    annotation (Line(points={{61,50},{78,50}}, color={255,0,255}));
  connect(truDel.y, yEcoSta) annotation (Line(points={{101,50},{140,50},{140,0},
          {170,0}}, color={255,0,255}));
  connect(truDel.y, pre.u) annotation (Line(points={{101,50},{108,50},{108,-30},
          {118,-30}}, color={255,0,255}));
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
