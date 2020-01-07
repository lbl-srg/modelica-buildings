within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Change "Calculates the chiller stage signal"

  // stage change limiter between 0 and nSta should be here and then
  // we don't need to defend the range in any other sequence

  parameter Modelica.SIunits.Power chiNomCap[nChi]
    "Nominal chiller capacities";

  parameter Modelica.SIunits.Power chiMinCap[nChi]
    "Chiller unload capacities";

  parameter Integer chiTyp[nChi] = {1,2}
    "Chiller type: 1 - positive displacement, 2 - variable speed centrifugal, 3 - constant speed centrifugal";

  parameter Boolean hasWSE = true
    "true = plant has a WSE, false = plant does not have WSE";

  parameter Real posDisMult(
    final unit = "1",
    final min = 0,
    final max = 1)=0.8
    "Positive displacement chiller type staging multiplier";

  parameter Real conSpeCenMult(
    final unit = "1",
    final min = 0,
    final max = 1)=0.9
    "Constant speed centrifugal chiller type staging multiplier";

  parameter Modelica.SIunits.Time delayStaCha = 15*60
    "Delay stage change";

  parameter Modelica.SIunits.Time avePer = 5*60
  "Period for the rolling average";

  parameter Modelica.SIunits.Time shortDelay = 10*60
    "Short stage 0 to 1 delay";

  parameter Modelica.SIunits.Time longDelay = 20*60
    "Long stage 0 to 1 delay";

  parameter Modelica.SIunits.TemperatureDifference smallTDif = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference largeTDif = 2
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference TDif = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.PressureDifference dpDif = 2 * 6895
    "Offset between the chilled water pump Diferential static pressure and its setpoint";

  parameter Modelica.SIunits.Density watDen = 1000 "Water density";

  parameter Modelica.SIunits.SpecificHeatCapacity watSpeHea = 4184
  "Specific heat capacity of water";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta
    "Waterside economizer status"
    annotation (
     Placement(transformation(extent={{-340,120},{-300,160}}),
        iconTransformation(extent={{-120,70},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nSta]
    "Chiller availability status"
    annotation (Placement(transformation(extent={{-340,160},{-300,200}}),
                                    iconTransformation(extent={{-120,90},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax
    "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-340,-280},{-300,-240}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWsePre(
    final unit="1")
    "Predicted waterside economizer outlet temperature" annotation (Placement(
        transformation(extent={{-340,-240},{-300,-200}}), iconTransformation(
          extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature" annotation (Placement(transformation(
          extent={{-340,-210},{-300,-170}}), iconTransformation(extent={{-120,-30},
            {-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump Diferential static pressure" annotation (Placement(
        transformation(extent={{-340,-170},{-300,-130}}), iconTransformation(
          extent={{-120,-70},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump Diferential static pressure setpoint" annotation (
      Placement(transformation(extent={{-340,-140},{-300,-100}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMax(
    final unit="K",
    final quantity="ThermodynamicTemperature") if nVsdCen>0
    "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-340,-30},{-300,10}}),
        iconTransformation(extent={{-120,-160},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMin(
    final unit="K",
    final quantity="ThermodynamicTemperature") if nVsdCen>0
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-340,-60},{-300,-20}}),
        iconTransformation(extent={{-120,-180},{-100,-160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLif(
    final unit="K",
    final quantity="ThermodynamicTemperature") if nVsdCen>0
    "Chiller lift"
    annotation (Placement(transformation(extent={{-340,-90},{-300,-50}}),
        iconTransformation(extent={{-120,-140},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint" annotation (Placement(
        transformation(extent={{-340,70},{-300,110}}),  iconTransformation(
          extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-340,40},{-300,80}}),
      iconTransformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-340,10},{-300,50}}),
      iconTransformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y(
    final max=1,
    final min=-1)
    "Stage change signal"
    annotation (Placement(transformation(extent={{420,-50},{440,-30}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta(
    final start=0,
    final max=nSta,
    final min=0) "Chiller stage"
    annotation (Placement(transformation(extent={{420,30},{440,50}}),
      iconTransformation(extent={{100,40},{120,60}})));

//protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    cap(
    final nSta=nSta,
    final staNomCap=staNomCap,
    final minStaUnlCap=minStaUnlCap)
    "Nominal and minimal capacities at each stage"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs(
    final nPosDis = nPosDis,
    final nVsdCen = nVsdCen,
    final nConCen = nConCen,
    final posDisMult = posDisMult,
    final conSpeCenMult = conSpeCenMult)
    "Calculates operating and staging part load ratios"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.CapacityRequirement capReq(
    final watDen = watDen,
    final watSpeHea = watSpeHea,
    final avePer = avePer)
    "Capacity requirement"
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt(
    final k2=-1)
    "Adder"
    annotation (Placement(transformation(extent={{160,-120},{180,-100}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up staUp(
    final delayStaCha = delayStaCha,
    final TDif = TDif,
    final dpDif = dpDif,
    final shortDelay = shortDelay,
    final longDelay = longDelay,
    final smallTDif = smallTDif,
    final largeTDif = largeTDif) "Stage up conditions"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down staDow(
    final hasWSE = hasWSE,
    final delayStaCha = delayStaCha,
    final TDif = TDif,
    final dpDif = dpDif) "Stage down conditions"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt1(
    final k2=+1)
    "Adder"
    annotation (Placement(transformation(extent={{240,0},{260,20}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Type converter"
    annotation (Placement(transformation(extent={{290,0},{310,20}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Type converter"
    annotation (Placement(transformation(extent={{340,120},{360,140}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Type converter"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Type converter"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Status sta(
    nSta=nSta,
    nChi=nChi,
    staMat=staMat)
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
  Configurator conf(chiNomCap=chiNomCap, chiMinCap=chiMinCap,
    staMat=staMat,
    chiTyp=chiTyp,
    nSta=nSta,
    nChi=nChi)
    annotation (Placement(transformation(extent={{-260,100},{-240,120}})));
  CDL.Interfaces.IntegerInput                        u if hasWSE
    "Chiller stage"
    annotation (Placement(transformation(extent={{-340,240},{-300,280}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));
  CDL.Interfaces.BooleanInput                        chaPro
    "Stage change process status, true = on, false = off"
    annotation (Placement(transformation(extent={{-340,200},{-300,240}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
equation
  connect(capReq.y, PLRs.uCapReq) annotation (Line(points={{-178,-10},{-116,-10},
          {-116,3},{-61,3}},   color={0,0,127}));
  connect(TChiWatSupSet, capReq.TChiWatSupSet) annotation (Line(points={{-320,90},
          {-230,90},{-230,-7},{-202,-7}},  color={0,0,127}));
  connect(TChiWatRet, capReq.TChiWatRet) annotation (Line(points={{-320,60},{
          -240,60},{-240,-13},{-202,-13}},
                                      color={0,0,127}));
  connect(VChiWat_flow, capReq.VChiWat_flow) annotation (Line(points={{-320,30},
          {-250,30},{-250,-18},{-202,-18}}, color={0,0,127}));
  connect(dpChiWatPumSet, staDow.dpChiWatPumSet) annotation (Line(points={{-320,
          -120},{-20,-120},{-20,-106},{39,-106}}, color={0,0,127}));
  connect(dpChiWatPum, staDow.dpChiWatPum) annotation (Line(points={{-320,-150},
          {-18,-150},{-18,-108},{39,-108}}, color={0,0,127}));
  connect(TChiWatSupSet, staUp.TChiWatSupSet) annotation (Line(points={{-320,90},
          {-14,90},{-14,10},{39,10}}, color={0,0,127}));
  connect(TChiWatSupSet, staDow.TChiWatSupSet) annotation (Line(points={{-320,90},
          {-14,90},{-14,-110},{39,-110}}, color={0,0,127}));
  connect(TChiWatSup, staDow.TChiWatSup) annotation (Line(points={{-320,-190},{
          -14,-190},{-14,-112},{39,-112}},
                                       color={0,0,127}));
  connect(TChiWatSup, staUp.TChiWatSup) annotation (Line(points={{-320,-190},{
          -12,-190},{-12,8},{39,8}},
                                 color={0,0,127}));
  connect(TWsePre, staDow.TWsePre) annotation (Line(points={{-320,-220},{-10,
          -220},{-10,-114},{39,-114}},
                                 color={0,0,127}));
  connect(dpChiWatPumSet, staUp.dpChiWatPumSet) annotation (Line(points={{-320,
          -120},{-8,-120},{-8,5},{39,5}},
                                    color={0,0,127}));
  connect(dpChiWatPum, staUp.dpChiWatPum) annotation (Line(points={{-320,-150},
          {-6,-150},{-6,3},{39,3}},color={0,0,127}));
  connect(uTowFanSpeMax, staDow.uTowFanSpeMax) annotation (Line(points={{-320,
          -260},{-4,-260},{-4,-116},{39,-116}},
                                          color={0,0,127}));
  connect(uWseSta, staDow.uWseSta) annotation (Line(points={{-320,140},{0,140},
          {0,-118},{39,-118}}, color={255,0,255}));
  connect(uLifMax, PLRs.uLifMax) annotation (Line(points={{-320,-10},{-260,-10},
          {-260,-24},{-110,-24},{-110,-12},{-61,-12}}, color={0,0,127}));
  connect(uLifMin, PLRs.uLifMin) annotation (Line(points={{-320,-40},{-260,-40},
          {-260,-26},{-108,-26},{-108,-14},{-61,-14}}, color={0,0,127}));
  connect(uLif, PLRs.uLif) annotation (Line(points={{-320,-70},{-240,-70},{-240,
          -40},{-112,-40},{-112,-10},{-61,-10}}, color={0,0,127}));
  connect(addInt.y, addInt1.u2) annotation (Line(points={{182,-110},{200,-110},
          {200,4},{238,4}},    color={255,127,0}));
  connect(reaToInt.y, addInt1.u1) annotation (Line(points={{362,130},{368,130},
          {368,150},{200,150},{200,16},{238,16}},   color={255,127,0}));
  connect(reaToInt.y, staUp.uChiSta) annotation (Line(points={{362,130},{372,
          130},{372,152},{10,152},{10,0},{39,0}}, color={255,127,0}));
  connect(reaToInt.y, PLRs.u) annotation (Line(points={{362,130},{378,130},{378,
          154},{-88,154},{-88,-20},{-61,-20}},
                                             color={255,127,0}));
  connect(reaToInt.y, cap.u) annotation (Line(points={{362,130},{382,130},{382,
          156},{-150,156},{-150,-64},{-142,-64}},
                                             color={255,127,0}));
  connect(reaToInt.y, staDow.u) annotation (Line(points={{362,130},{386,130},{
          386,160},{8,160},{8,-120},{39,-120}},
                                            color={255,127,0}));
  connect(addInt.y, y) annotation (Line(points={{182,-110},{400,-110},{400,-40},
          {430,-40}},color={255,127,0}));
  connect(staUp.y, booToInt1.u) annotation (Line(points={{61,10},{80,10},{80,
          -40},{98,-40}}, color={255,0,255}));
  connect(booToInt1.y, addInt.u1) annotation (Line(points={{122,-40},{150,-40},
          {150,-104},{158,-104}}, color={255,127,0}));
  connect(staDow.y, booToInt.u) annotation (Line(points={{61,-110},{80,-110},{
          80,-70},{98,-70}}, color={255,0,255}));
  connect(booToInt.y, addInt.u2) annotation (Line(points={{122,-70},{140,-70},{
          140,-116},{158,-116}}, color={255,127,0}));
  connect(reaToInt.y, ySta) annotation (Line(points={{362,130},{400,130},{400,
          40},{430,40}}, color={255,127,0}));
  connect(uChiAva, conf.uChiAva) annotation (Line(points={{-320,180},{-290,180},
          {-290,110},{-262,110}}, color={255,0,255}));
  connect(conf.yAva, sta.uAva) annotation (Line(points={{-238,106},{-228,106},{
          -228,44},{-222,44}},
                          color={255,0,255}));
  connect(conf.yTyp, PLRs.uTyp) annotation (Line(points={{-238,102},{-90,102},{
          -90,-17},{-61,-17}},
                           color={255,127,0}));
  connect(conf.yMinCap, cap.uMinCap) annotation (Line(points={{-238,114},{-146,
          114},{-146,-79},{-142,-79}}, color={0,0,127}));
  connect(sta.yHig, cap.uHig) annotation (Line(points={{-198,53},{-160,53},{
          -160,-73},{-142,-73}},                color={255,0,255}));
  connect(sta.yLow, cap.uLow) annotation (Line(points={{-198,44},{-170,44},{
          -170,-76},{-142,-76}},                     color={255,0,255}));
  connect(sta.yHig, staUp.uHigSta) annotation (Line(points={{-198,53},{12,53},{
          12,-2},{39,-2}}, color={255,0,255}));
  connect(conf.yDesCap, cap.uDesCap) annotation (Line(points={{-238,118},{-144,
          118},{-144,-61},{-142,-61}}, color={0,0,127}));
  connect(u, sta.u) annotation (Line(points={{-320,260},{-270,260},{-270,56},{
          -222,56}}, color={255,127,0}));
  connect(sta.yUp, cap.uUp) annotation (Line(points={{-198,56},{-152,56},{-152,
          -67},{-142,-67}}, color={255,127,0}));
  connect(sta.yDown, cap.uDown) annotation (Line(points={{-198,47},{-154,47},{
          -154,-70},{-142,-70}}, color={255,127,0}));
  connect(sta.yUp, PLRs.uUp) annotation (Line(points={{-198,56},{-100,56},{-100,
          -22},{-61,-22}}, color={255,127,0}));
  connect(sta.yDown, PLRs.uDown) annotation (Line(points={{-198,47},{-102,47},{
          -102,-24},{-61,-24}}, color={255,127,0}));
  connect(cap.yDes, PLRs.uCapDes) annotation (Line(points={{-118,-62},{-80,-62},
          {-80,1},{-61,1}}, color={0,0,127}));
  connect(cap.yUpDes, PLRs.uUpCapDes) annotation (Line(points={{-118,-66},{-78,
          -66},{-78,-1},{-61,-1}}, color={0,0,127}));
  connect(cap.yDowDes, PLRs.uDowCapDes) annotation (Line(points={{-118,-70},{
          -76,-70},{-76,-3},{-61,-3}}, color={0,0,127}));
  connect(cap.yMin, PLRs.uCapMin) annotation (Line(points={{-118,-74},{-74,-74},
          {-74,-5},{-61,-5}}, color={0,0,127}));
  connect(cap.yUpMin, PLRs.uUpCapMin) annotation (Line(points={{-118,-78},{-72,
          -78},{-72,-7},{-61,-7}}, color={0,0,127}));
  connect(chaPro, capReq.chaPro) annotation (Line(points={{-320,220},{-280,220},
          {-280,-2},{-202,-2}}, color={255,0,255}));
  connect(addInt1.y, intToRea.u)
    annotation (Line(points={{262,10},{288,10}}, color={255,127,0}));
  connect(PLRs.yOpeUp, staUp.uOpeUp) annotation (Line(points={{-39,-5},{-18,-5},
          {-18,15},{39,15}}, color={0,0,127}));
  connect(PLRs.yStaUp, staUp.uStaUp) annotation (Line(points={{-39,-11},{-20,
          -11},{-20,18},{39,18}}, color={0,0,127}));
  connect(PLRs.yOpeUpMin, staUp.uOpeUpMin) annotation (Line(points={{-39,-17},{
          -22,-17},{-22,13},{39,13}}, color={0,0,127}));
  connect(PLRs.yOpe, staUp.uOpe) annotation (Line(points={{-39,-3},{-24,-3},{
          -24,20},{39,20}}, color={0,0,127}));
  connect(PLRs.yOpeDow, staDow.uOpeDow) annotation (Line(points={{-39,-7},{30,
          -7},{30,-98},{39,-98}}, color={0,0,127}));
  connect(PLRs.yStaDow, staDow.uStaDow) annotation (Line(points={{-39,-13},{28,
          -13},{28,-100},{39,-100}}, color={0,0,127}));
  connect(PLRs.yOpeMin, staDow.uOpeMin) annotation (Line(points={{-39,-19},{26,
          -19},{26,-104},{39,-104}}, color={0,0,127}));
  connect(PLRs.yOpe, staDow.uOpe) annotation (Line(points={{-39,-3},{-30,-3},{
          -30,-102},{39,-102}}, color={0,0,127}));
  connect(intToRea.y, reaToInt.u) annotation (Line(points={{312,10},{330,10},{
          330,130},{338,130}}, color={0,0,127}));
  annotation (defaultComponentName = "staCha",
        Icon(coordinateSystem(extent={{-300,-300},{420,300}}),
             graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),          Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-300,-300},{420,300}})),
Documentation(info="<html>
<p>
Outputs the chiller stage change signal

fixme: add a stage availability input signal, which will
remove the stage change delay if the stage is unavailable, to
allow for a change to the next available stage at the next instant.  

WSE enable at plant enable part - in plant enable subsequence
</p>
</html>",
revisions="<html>
<ul>
<li>
January xx, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Change;
