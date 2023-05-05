within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences;
block Initial "Outputs the initial stage"

  parameter Boolean have_WSE = true
    "true = plant has a WSE, false = plant does not have WSE";

  parameter Real wseDt = 1
    "Offset for checking waterside economizer leaving water temperature"
    annotation (Dialog(tab="Advanced", enable=have_WSE));

  parameter Real heaExcAppDes(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="degC")=2
      "Design heat exchanger approach"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));

  parameter Real cooTowAppDes(
    final unit="K",
    final quantity="TemperatureDifference",
    displayUnit="degC")=2
      "Design cooling tower approach"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));

  parameter Real TOutWetDes(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=288.15
      "Design outdoor air wet bulb temperature"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));

  parameter Real VHeaExcDes_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    displayUnit="m3/s")=0.01
      "Desing heat exchanger chilled water flow rate"
    annotation (Dialog(group="Waterside economizer", enable=have_WSE));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uUp
    "First higher available chiller stage"
    annotation (Placement(transformation(extent={{-280,-60},{-240,-20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutWet(
    final unit="K",
    final quantity="ThermodynamicTemperature") if have_WSE
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-280,50},{-240,90}}),
      iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTunPar if have_WSE
    "Tuning parameter as at last plant disable"
    annotation (Placement(transformation(extent={{-280,-20},{-240,20}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature") if have_WSE
    "Chilled water supply setpoint"
    annotation (Placement(transformation(extent={{-280,90},{-240,130}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIni
    "Initial chiller plant stage"
    annotation (Placement(transformation(extent={{240,-10},{260,10}}),
    iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-280,-110},{-240,-70}}),
    iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Samples first available stage up at plant enable"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg(
    final pre_u_start=false) "Rising edge"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

//protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.PredictedOutletTemperature
    wseTOut(
    final heaExcAppDes=heaExcAppDes,
    final cooTowAppDes=cooTowAppDes,
    final TOutWetDes=TOutWetDes,
    final VHeaExcDes_flow=VHeaExcDes_flow) if have_WSE
    "Waterside economizer outlet temperature predictor"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea "Type converter"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt "Type converter"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staZer(
    final k=0)
    "Zero stage"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=0,
    final uHigh=wseDt) if have_WSE
    "Check if the initial predicted heat exchange leaving water temperature is greater than chilled water supply temperature setpoint less offset"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1 if have_WSE
    "Difference between predicted heat exchanger leaving water temperature and chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noWSE(
    final k=false) if not have_WSE "Replacement signal for no WSE case"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=VHeaExcDes_flow) if have_WSE
    "Design heat exchanger chiller water flow rate"
    annotation (Placement(transformation(extent={{-220,20},{-200,40}})));

equation
  connect(reaToInt.y, yIni)
    annotation (Line(points={{182,40},{200,40},{200,0},{250,0}}, color={255,127,0}));
  connect(sub1.y,hys1. u)
    annotation (Line(points={{-78,90},{-62,90}}, color={0,0,127}));
  connect(noWSE.y,swi. u2)
    annotation (Line(points={{-38,50},{-20,50},{-20,90},{58,90}},
      color={255,0,255}));
  connect(hys1.y,swi. u2)
    annotation (Line(points={{-38,90},{58,90}}, color={255,0,255}));
  connect(wseTOut.TOutWet,TOutWet)
    annotation (Line(points={{-162,38},{-180,38},{-180,70},{-260,70}},
      color={0,0,127}));
  connect(con3.y,wseTOut. VChiWat_flow)
    annotation (Line(points={{-198,30},{-162,30}},
      color={0,0,127}));
  connect(wseTOut.uTunPar,uTunPar)
    annotation (Line(points={{-162,22},{-180,22},{-180,0},{-260,0}},
      color={0,0,127}));
  connect(TChiWatSupSet,sub1. u1)
    annotation (Line(points={{-260,110},{-170,110},{-170,96},{-102,96}},
      color={0,0,127}));
  connect(staZer.y,swi. u1)
    annotation (Line(points={{22,110},{40,110},{40,98},{58,98}}, color={0,0,127}));
  connect(uUp, intToRea.u) annotation (Line(points={{-260,-40},{-100,-40},{-100,
          0},{-62,0}}, color={255,127,0}));
  connect(swi.y, reaToInt.u) annotation (Line(points={{82,90},{140,90},{140,40},
          {158,40}}, color={0,0,127}));
  connect(intToRea.y, triSam.u)
    annotation (Line(points={{-38,0},{-12,0}}, color={0,0,127}));
  connect(triSam.y, swi.u3)
    annotation (Line(points={{12,0},{40,0},{40,82},{58,82}}, color={0,0,127}));
  connect(uPla, edg.u)
    annotation (Line(points={{-260,-90},{-62,-90}}, color={255,0,255}));
  connect(edg.y, triSam.trigger)
    annotation (Line(points={{-38,-90},{0,-90},{0,-12}},   color={255,0,255}));
  connect(wseTOut.y, sub1.u2) annotation (Line(points={{-138,30},{-120,30},{
          -120,84},{-102,84}}, color={0,0,127}));
annotation (defaultComponentName = "iniSta",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Line(
          points={{-54,-50},{-2,-50},{-2,54},{50,54}},
          color={244,125,35},
          thickness=0.5),
        Text(
          extent={{-68,-44},{58,-114}},
          textColor={0,0,0},
          lineThickness=0.5,
          textString="At Enable")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-240,-140},{240,140}})),
Documentation(info="<html>
<p>
This subsequence is not directly specified in 1711 as it provides a side
calculation pertaining to generalization of the staging sequences for any
number of chillers and stages provided by the user.
</p>
<p>
Determines the initial stage upon plant startup for both plants with and
without a WSE. Implemented according to section 5.2.4.15. 1711 March 2020
Draft, under 8. (primary-only) and 15. (primary-secondary) plants.
</p>
<p>
The initial stage <code>yIni</code> is defined as:
</p>
<p>
When the plant is enabled and the plant has no waterside economizer
(<code>have_WSE</code>=false), the initial stage will be the lowest available
stage <code>uUp</code>.
</p>
<p>
When the plant is enabled and the plant has waterside economizer
(<code>have_WSE</code>=true), the initial stage will be:
</p>
<ul>
<li>If predicted waterside economizer outlet temperature calculated using
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.PredictedOutletTemperature\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.PredictedOutletTemperature</a>
with predicted heat exchanger part load ratio <code>PLRHeaExc</code> set to 1
is at least <code>wseDt</code> below the chilled water supply temperature
setpoint <code>TChiWatSupSet</code>, then the initial stage will be 0, meaning
that the plant initiates in a waterside economizer only mode.
</li>
<li>
Otherwise, the initial stage will be the lowest available stage <code>uUp</code>.
</li>
</ul>
<p>
The following state machine chart illustrates the initial stage selection for plants with a waterside economizer:
</p>
<p align=\"center\">
<img alt=\"Image of initial stage selection state machine chart\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/SetPoints/Subsequences/InitialStageSelectionStateGraph.png\"/>
</p>
</html>",
revisions="<html>
<ul>
<li>
January 19, 2021, by Milica Grahovac:<br/>
Added state chart illustration.
</li>
<li>
March 12, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Initial;
