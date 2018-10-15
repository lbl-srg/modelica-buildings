within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer;
block Status "Water side economizer enable/disable status"

  parameter Modelica.SIunits.Time holdPeriod=20*60
  "Post disable enable delay";

  parameter Modelica.SIunits.TemperatureDifference TOffsetEna=2
  "Temperature offset between the chilled water return upstream of WSE and the predicted WSE output";

  parameter Modelica.SIunits.TemperatureDifference TOffsetDis=1
  "Temperature offset between the chilled water return upstream and downstream of WSE";

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
    iconTransformation(extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.RealInput TChiWatRet
    "Chiller water return temperature upstream of the water side economizer"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Continuous.Sources.Constant addTOffsetEna(k=TOffsetEna)
    "Additional temperature offset"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  CDL.Continuous.Greater greEna "Enable condition"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  CDL.Interfaces.BooleanOutput yEcoSta
    "Water side economizer enable disable status"
    annotation (Placement(transformation(extent={{160,-10},{180,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Tuning wseTun
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  PredictedOutletTemperature wseTOut
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  CDL.Continuous.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  CDL.Continuous.Greater greDis "Disable condition"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  CDL.Continuous.Sources.Constant addTOffsetDis(k=TOffsetDis)
    "Additional temperature offset"
    annotation (Placement(transformation(extent={{-60,-62},{-40,-42}})));
  CDL.Interfaces.RealInput TChiWatWseDow
    "Chiller water return temperature downstream of the water side economizer"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Logical.Timer tim
    annotation (Placement(transformation(extent={{90,80},{110,100}})));
  CDL.Logical.Timer tim1
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  CDL.Logical.And enaIfTrue "True if WSE is to get enabled"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  CDL.Logical.And disIfTrue "True if WSE is to get disabled"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  CDL.Continuous.GreaterEqualThreshold greEquThr(threshold=holdPeriod)
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  CDL.Continuous.GreaterEqualThreshold greEquThr1(threshold=holdPeriod)
    annotation (Placement(transformation(extent={{90,-40},{110,-20}})));
  CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  CDL.Logical.And and3 "Combines enable and disable signals"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));
equation
  connect(addTOffsetEna.y, add2.u2) annotation (Line(points={{-39,10},{-30,10},{
          -30,24},{-22,24}},color={0,0,127}));
  connect(add2.y, greEna.u2) annotation (Line(points={{1,30},{10,30},{10,42},{18,
          42}}, color={0,0,127}));
  connect(TChiWatRet, greEna.u1) annotation (Line(points={{-180,60},{-120,60},{-120,
          80},{10,80},{10,50},{18,50}}, color={0,0,127}));
  connect(uTowFanSpe, wseTun.uTowFanSpe) annotation (Line(points={{-180,-100},{-132,
          -100},{-132,-105},{-122,-105}},
                                       color={0,0,127}));
  connect(wseTun.yTunPar, wseTOut.uTunPar) annotation (Line(points={{-99,-100},{
          -90,-100},{-90,42},{-82,42}},
                                   color={0,0,127}));
  connect(TOutWet, wseTOut.TOutWet) annotation (Line(points={{-180,100},{-100,100},
          {-100,58},{-82,58}},color={0,0,127}));
  connect(wseTOut.TEcoOut_pred, add2.u1) annotation (Line(points={{-58,50},{-40,
          50},{-40,36},{-22,36}},
                            color={0,0,127}));
  connect(VChiWat_flow, wseTOut.VChiWat_flow) annotation (Line(points={{-180,
          -40},{-100,-40},{-100,50},{-82,50}},
                                          color={0,0,127}));
  connect(pre.y, wseTun.uEcoSta) annotation (Line(points={{141,-50},{150,-50},{
          150,-80},{-132,-80},{-132,-95},{-122,-95}}, color={255,0,255}));
  connect(TChiWatRet, add1.u1) annotation (Line(points={{-180,60},{-130,60},{
          -130,-24},{-22,-24}},
                           color={0,0,127}));
  connect(add1.y, greDis.u2) annotation (Line(points={{1,-30},{8,-30},{8,-18},{18,
          -18}}, color={0,0,127}));
  connect(addTOffsetDis.y, add1.u2) annotation (Line(points={{-39,-52},{-32,-52},
          {-32,-36},{-22,-36}}, color={0,0,127}));
  connect(TChiWatWseDow, greDis.u1) annotation (Line(points={{-180,20},{-140,20},
          {-140,-10},{18,-10}}, color={0,0,127}));
  connect(pre.y, tim1.u) annotation (Line(points={{141,-50},{144,-50},{144,-74},
          {52,-74},{52,-30},{58,-30}}, color={255,0,255}));
  connect(not1.y, tim.u)
    annotation (Line(points={{81,90},{88,90}}, color={255,0,255}));
  connect(pre.y, not1.u) annotation (Line(points={{141,-50},{144,-50},{144,-76},
          {50,-76},{50,90},{58,90}}, color={255,0,255}));
  connect(tim.y, greEquThr.u)
    annotation (Line(points={{111,90},{118,90}}, color={0,0,127}));
  connect(tim1.y, greEquThr1.u)
    annotation (Line(points={{81,-30},{88,-30}}, color={0,0,127}));
  connect(greEquThr.y, enaIfTrue.u1) annotation (Line(points={{141,90},{148,90},
          {148,70},{70,70},{70,40},{78,40}}, color={255,0,255}));
  connect(greEna.y, enaIfTrue.u2) annotation (Line(points={{41,50},{60,50},{60,
          32},{78,32}}, color={255,0,255}));
  connect(greEquThr1.y, disIfTrue.u2) annotation (Line(points={{111,-30},{120,
          -30},{120,-8},{68,-8},{68,2},{78,2}}, color={255,0,255}));
  connect(greDis.y, disIfTrue.u1) annotation (Line(points={{41,-10},{60,-10},{
          60,10},{78,10}}, color={255,0,255}));
  connect(disIfTrue.y, not2.u)
    annotation (Line(points={{101,10},{118,10}}, color={255,0,255}));
  connect(enaIfTrue.y, and3.u1)
    annotation (Line(points={{101,40},{118,40}}, color={255,0,255}));
  connect(not2.y, and3.u2) annotation (Line(points={{141,10},{146,10},{146,26},
          {110,26},{110,32},{118,32}}, color={255,0,255}));
  connect(yEcoSta, and3.y) annotation (Line(points={{170,0},{156,0},{156,40},{
          141,40}}, color={255,0,255}));
  connect(and3.y, pre.u) annotation (Line(points={{141,40},{146,40},{146,-38},{
          112,-38},{112,-50},{118,-50}}, color={255,0,255}));
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
