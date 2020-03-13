within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Initial "Outputs the initial stage"

  parameter Boolean serChi = false
    "true = series chillers plant; false = parallel chillers plant";

  parameter Modelica.SIunits.Time delayStaCha = 900
    "Enable delay";

  parameter Modelica.SIunits.TemperatureDifference TDif = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference TDifHys = 1
    "Temperature hysteresis deadband";

  parameter Real hysSig = 0.05
    "Signal hysteresis deadband";

  parameter Modelica.SIunits.PressureDifference dpDif = 2 * 6895
    "Offset between the chilled water differential pressure and its setpoint";

  parameter Modelica.SIunits.PressureDifference dpDifHys = 0.5 * 6895
    "Pressure difference hysteresis deadband";

  Economizer.Subsequences.PredictedOutletTemperature
    wseTOut(
    final heaExcAppDes=heaExcAppDes,
    final cooTowAppDes=cooTowAppDes,
    final TOutWetDes=TOutWetDes,
    final VHeaExcDes_flow=VHeaExcDes_flow) if hasWSE
    "Waterside economizer outlet temperature predictor"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutWet(final unit="K",
      final quantity="ThermodynamicTemperature") if
                                                  hasWSE
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-280,10},{-240,50}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTunPar if hasWSE
    "Tuning parameter as at last plant disable"
    annotation (Placement(transformation(extent={{-280,-60},{-240,-20}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        TChiWatSupSet(final unit="K",
      final quantity="ThermodynamicTemperature") if
                                                  hasWSE
    "Chilled water supply setpoint"
    annotation (Placement(transformation(extent={{-280,50},{-240,90}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIni
    "Initial chiller plant stage" annotation (Placement(transformation(extent={{240,-10},
            {260,10}}),           iconTransformation(extent={{100,-70},{120,-50}})));
  CDL.Interfaces.IntegerInput uUp(final min=0, final max=nSta)
    "First higher available chiller stage" annotation (Placement(transformation(
          extent={{-280,-100},{-240,-60}}), iconTransformation(extent={{-140,-70},
            {-100,-30}})));
  CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
protected
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger                        reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                        staZer(final k=0)
    "Zero stage"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis                        hys1(final uLow=0, final
      uHigh=wseDt) if     hasWSE
    "Check if predicted heat exchange leaving water temperature is greater than chilled water supply temperature setpoint less offset"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback                        feedback if hasWSE
    "Difference between predicted heat exchanger leaving water temperature and chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-110,40},{-90,60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch                        swi "Logical switch"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant                        con2(final k=
        true) if hasWSE "Constant true"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                        con3(k=VHeaExcDes_flow) if hasWSE
    "Design heat exchanger chiller water flow rate"
    annotation (Placement(transformation(extent={{-220,-20},{-200,0}})));
equation

  connect(reaToInt.y, yIni)
    annotation (Line(points={{182,0},{250,0}},     color={255,127,0}));
  connect(feedback.y,hys1. u)
    annotation (Line(points={{-88,50},{-62,50}},     color={0,0,127}));
  connect(con2.y,swi. u2)
    annotation (Line(points={{-38,10},{-20,10},{-20,50},{58,50}},
      color={255,0,255}));
  connect(hys1.y,swi. u2)
    annotation (Line(points={{-38,50},{58,50}},     color={255,0,255}));
  connect(wseTOut.TOutWet,TOutWet)
    annotation (Line(points={{-142,-2},{-180,-2},{-180,30},{-260,30}},
      color={0,0,127}));
  connect(con3.y,wseTOut. VChiWat_flow)
    annotation (Line(points={{-198,-10},{-142,-10}},
      color={0,0,127}));
  connect(wseTOut.uTunPar,uTunPar)
    annotation (Line(points={{-142,-18},{-180,-18},{-180,-40},{-260,-40}},
      color={0,0,127}));
  connect(wseTOut.y,feedback. u2)
    annotation (Line(points={{-118,-10},{-100,-10},{-100,38}},     color={0,0,127}));
  connect(TChiWatSupSet,feedback. u1)
    annotation (Line(points={{-260,70},{-170,70},{-170,50},{-112,50}},
      color={0,0,127}));
  connect(staZer.y,swi. u1)
    annotation (Line(points={{22,70},{40,70},{40,58},{58,58}},         color={0,0,127}));
  connect(uUp, intToRea.u) annotation (Line(points={{-260,-80},{-100,-80},{-100,
          -30},{-62,-30}}, color={255,127,0}));
  connect(intToRea.y, swi.u3) annotation (Line(points={{-38,-30},{40,-30},{40,42},
          {58,42}}, color={0,0,127}));
  connect(swi.y, reaToInt.u) annotation (Line(points={{82,50},{140,50},{140,0},{
          158,0}}, color={0,0,127}));
annotation (defaultComponentName = "faiSafCon",
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
          extent={{-240,-100},{240,100}})),
Documentation(info="<html>
<p>
Failsafe condition used in staging up and down,
implemented according to the specification provided in section 
5.2.4.15.6. and 10. in the December 2019 draft. The subsequence
applies to primary-only plants with and without a WSE. The 
sequence contains a boolean flag to differentiate between parallel and series chiller 
plants.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 21, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Initial;
