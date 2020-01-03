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
     Placement(transformation(extent={{-240,110},{-200,150}}),
        iconTransformation(extent={{-120,70},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nSta]
    "Chiller availability status"
    annotation (Placement(transformation(extent={{
            -240,140},{-200,180}}), iconTransformation(extent={{-120,90},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax
    "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-240,-280},{-200,-240}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWsePre(
    final unit="1")
    "Predicted waterside economizer outlet temperature" annotation (Placement(
        transformation(extent={{-240,-240},{-200,-200}}), iconTransformation(
          extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature" annotation (Placement(transformation(
          extent={{-240,-210},{-200,-170}}), iconTransformation(extent={{-120,-30},
            {-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump Diferential static pressure" annotation (Placement(
        transformation(extent={{-240,-170},{-200,-130}}), iconTransformation(
          extent={{-120,-70},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump Diferential static pressure setpoint" annotation (
      Placement(transformation(extent={{-240,-140},{-200,-100}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMax(
    final unit="K",
    final quantity="ThermodynamicTemperature") if nVsdCen>0
    "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-240,-30},{-200,10}}),
        iconTransformation(extent={{-120,-160},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMin(
    final unit="K",
    final quantity="ThermodynamicTemperature") if nVsdCen>0
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
        iconTransformation(extent={{-120,-180},{-100,-160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLif(
    final unit="K",
    final quantity="ThermodynamicTemperature") if nVsdCen>0
    "Chiller lift"
    annotation (Placement(transformation(extent={{-240,-90},{-200,-50}}),
        iconTransformation(extent={{-120,-140},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint" annotation (Placement(
        transformation(extent={{-240,70},{-200,110}}),  iconTransformation(
          extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
      iconTransformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-240,10},{-200,50}}),
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
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.CapacityRequirement capReq(
    final watDen = watDen,
    final watSpeHea = watSpeHea,
    final avePer = avePer)
    "Capacity requirement"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt(
    final k2=-1)
    "Adder"
    annotation (Placement(transformation(extent={{130,-120},{150,-100}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up staUp(
    final delayStaCha = delayStaCha,
    final TDif = TDif,
    final dpDif = dpDif,
    final shortDelay = shortDelay,
    final longDelay = longDelay,
    final smallTDif = smallTDif,
    final largeTDif = largeTDif) "Stage up conditions"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down staDow(
    final hasWSE = hasWSE,
    final delayStaCha = delayStaCha,
    final TDif = TDif,
    final dpDif = dpDif) "Stage down conditions"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt1(
    final k2=+1)
    "Adder"
    annotation (Placement(transformation(extent={{180,-80},{200,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Min minInt "Minimum"
    annotation (Placement(transformation(extent={{220,-50},{240,-30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=nSta)
    "Highest stage"
    annotation (Placement(transformation(extent={{180,-40},{200,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(k=0)
    "Stage 0"
    annotation (Placement(transformation(extent={{180,0},{200,20}})));

  Buildings.Controls.OBC.CDL.Integers.Max maxInt "Maximum"
    annotation (Placement(transformation(extent={{260,0},{280,20}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Type converter"
    annotation (Placement(transformation(extent={{290,0},{310,20}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(final
      samplePeriod=1)
    "Stage change delay"
    annotation (Placement(transformation(extent={{240,170},{260,190}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Type converter"
    annotation (Placement(transformation(extent={{340,120},{360,140}})));

  CDL.Discrete.Sampler                                 sam(samplePeriod=1)
    "Triggered sampler"
    annotation (Placement(transformation(extent={{200,170},{220,190}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Type converter"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Type converter"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));

  Status sta(
    nSta=nSta,
    nChi=nChi,
    staMat=staMat)
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Configurator conf(chiNomCap=chiNomCap, chiMinCap=chiMinCap,
    staMat=staMat,
    chiTyp=chiTyp,
    nSta=nSta,
    nChi=nChi)
    annotation (Placement(transformation(extent={{-190,100},{-170,120}})));
equation
  connect(cap.yStaNom, PLRs.uStaCapNom) annotation (Line(points={{-119,-63},{-94,
          -63},{-94,1},{-81,1}}, color={0,0,127}));
  connect(cap.yStaUpNom, PLRs.uStaUpCapNom) annotation (Line(points={{-119,-67},
          {-92,-67},{-92,-1},{-81,-1}}, color={0,0,127}));
  connect(cap.yStaDowNom, PLRs.uStaDowCapNom) annotation (Line(points={{-119,-71},
          {-90,-71},{-90,-3},{-81,-3}}, color={0,0,127}));
  connect(cap.yStaUpMin, PLRs.uStaUpCapMin) annotation (Line(points={{-119,-75},
          {-86,-75},{-86,-5},{-81,-5}}, color={0,0,127}));
  connect(cap.yStaMin, PLRs.uStaCapMin) annotation (Line(points={{-119,-77},{-84,
          -77},{-84,-7},{-81,-7}}, color={0,0,127}));
  connect(capReq.y, PLRs.uCapReq) annotation (Line(points={{-118,-10},{-116,-10},
          {-116,3},{-81,3}},   color={0,0,127}));
  connect(TChiWatSupSet, capReq.TChiWatSupSet) annotation (Line(points={{-220,90},
          {-160,90},{-160,-7},{-142,-7}},  color={0,0,127}));
  connect(TChiWatRet, capReq.TChiWatRet) annotation (Line(points={{-220,60},{
          -168,60},{-168,-13},{-142,-13}},
                                      color={0,0,127}));
  connect(VChiWat_flow, capReq.VChiWat_flow) annotation (Line(points={{-220,30},
          {-180,30},{-180,-18},{-142,-18}}, color={0,0,127}));
  connect(PLRs.y, staUp.uOplr) annotation (Line(points={{-59,-3},{-40,-3},{-40,0},
          {-30,0},{-30,20},{19,20}}, color={0,0,127}));
  connect(PLRs.yStaUp, staUp.uSplrUp) annotation (Line(points={{-59,-11},{-28,-11},
          {-28,18},{19,18}},color={0,0,127}));
  connect(PLRs.yUp, staUp.uOplrUp) annotation (Line(points={{-59,-5},{-26,-5},{-26,
          15},{19,15}}, color={0,0,127}));
  connect(PLRs.yUpMin, staUp.uOplrUpMin) annotation (Line(points={{-59,-17},{-24,
          -17},{-24,13},{19,13}},color={0,0,127}));
  connect(PLRs.yDow, staDow.uOplrDow) annotation (Line(points={{-59,-7},{-18,-7},
          {-18,-98},{19,-98}}, color={0,0,127}));
  connect(PLRs.yStaDow, staDow.uSplrDow) annotation (Line(points={{-59,-13},{-20,
          -13},{-20,-100},{19,-100}}, color={0,0,127}));
  connect(PLRs.y, staDow.uOplr) annotation (Line(points={{-59,-3},{-16,-3},{-16,
          -102},{19,-102}}, color={0,0,127}));
  connect(PLRs.yMin, staDow.uOplrMin) annotation (Line(points={{-59,-19},{-40,-19},
          {-40,-104},{19,-104}}, color={0,0,127}));
  connect(dpChiWatPumSet, staDow.dpChiWatPumSet) annotation (Line(points={{-220,
          -120},{-20,-120},{-20,-106},{19,-106}}, color={0,0,127}));
  connect(dpChiWatPum, staDow.dpChiWatPum) annotation (Line(points={{-220,-150},
          {-18,-150},{-18,-108},{19,-108}}, color={0,0,127}));
  connect(TChiWatSupSet, staUp.TChiWatSupSet) annotation (Line(points={{-220,90},
          {-14,90},{-14,10},{19,10}}, color={0,0,127}));
  connect(TChiWatSupSet, staDow.TChiWatSupSet) annotation (Line(points={{-220,90},
          {-14,90},{-14,-110},{19,-110}}, color={0,0,127}));
  connect(TChiWatSup, staDow.TChiWatSup) annotation (Line(points={{-220,-190},{-14,
          -190},{-14,-112},{19,-112}}, color={0,0,127}));
  connect(TChiWatSup, staUp.TChiWatSup) annotation (Line(points={{-220,-190},{-12,
          -190},{-12,8},{19,8}}, color={0,0,127}));
  connect(TWsePre, staDow.TWsePre) annotation (Line(points={{-220,-220},{-10,-220},
          {-10,-114},{19,-114}}, color={0,0,127}));
  connect(dpChiWatPumSet, staUp.dpChiWatPumSet) annotation (Line(points={{-220,-120},
          {-8,-120},{-8,5},{19,5}}, color={0,0,127}));
  connect(dpChiWatPum, staUp.dpChiWatPum) annotation (Line(points={{-220,-150},{
          -6,-150},{-6,3},{19,3}}, color={0,0,127}));
  connect(uTowFanSpeMax, staDow.uTowFanSpeMax) annotation (Line(points={{-220,-260},
          {-4,-260},{-4,-116},{19,-116}}, color={0,0,127}));
  connect(uWseSta, staDow.uWseSta) annotation (Line(points={{-220,130},{0,130},{
          0,-118},{19,-118}},  color={255,0,255}));
  connect(uLifMax, PLRs.uLifMax) annotation (Line(points={{-220,-10},{-190,-10},
          {-190,-24},{-110,-24},{-110,-12},{-81,-12}}, color={0,0,127}));
  connect(uLifMin, PLRs.uLifMin) annotation (Line(points={{-220,-40},{-190,-40},
          {-190,-26},{-108,-26},{-108,-14},{-81,-14}}, color={0,0,127}));
  connect(uLif, PLRs.uLif) annotation (Line(points={{-220,-70},{-190,-70},{-190,
          -40},{-112,-40},{-112,-10},{-81,-10}}, color={0,0,127}));
  connect(conInt.y, minInt.u1) annotation (Line(points={{202,-30},{210,-30},{
          210,-34},{218,-34}}, color={255,127,0}));
  connect(addInt1.y, minInt.u2) annotation (Line(points={{202,-70},{210,-70},{
          210,-46},{218,-46}}, color={255,127,0}));
  connect(conInt1.y, maxInt.u1) annotation (Line(points={{202,10},{240,10},{240,
          16},{258,16}}, color={255,127,0}));
  connect(minInt.y, maxInt.u2) annotation (Line(points={{242,-40},{250,-40},{
          250,4},{258,4}},   color={255,127,0}));
  connect(addInt.y, addInt1.u2) annotation (Line(points={{152,-110},{160,-110},
          {160,-76},{178,-76}},color={255,127,0}));
  connect(reaToInt.y, addInt1.u1) annotation (Line(points={{362,130},{368,130},
          {368,150},{160,150},{160,-64},{178,-64}}, color={255,127,0}));
  connect(reaToInt.y, staUp.uChiSta) annotation (Line(points={{362,130},{372,130},
          {372,152},{10,152},{10,0},{19,0}},      color={255,127,0}));
  connect(reaToInt.y, PLRs.u) annotation (Line(points={{362,130},{378,130},{378,
          154},{-88,154},{-88,-20},{-81,-20}},
                                             color={255,127,0}));
  connect(reaToInt.y, cap.u) annotation (Line(points={{362,130},{382,130},{382,
          156},{-150,156},{-150,-64},{-142,-64}},
                                             color={255,127,0}));
  connect(reaToInt.y, staDow.u) annotation (Line(points={{362,130},{386,130},{386,
          160},{8,160},{8,-120},{19,-120}}, color={255,127,0}));
  connect(addInt.y, y) annotation (Line(points={{152,-110},{400,-110},{400,-40},
          {430,-40}},color={255,127,0}));
  connect(maxInt.y, intToRea.u)
    annotation (Line(points={{282,10},{288,10}}, color={255,127,0}));
  connect(intToRea.y, sam.u) annotation (Line(points={{312,10},{320,10},{320,
          106},{180,106},{180,180},{198,180}},
                                          color={0,0,127}));
  connect(staUp.y, booToInt1.u) annotation (Line(points={{41,10},{50,10},{50,
          -40},{78,-40}}, color={255,0,255}));
  connect(booToInt1.y, addInt.u1) annotation (Line(points={{102,-40},{120,-40},
          {120,-104},{128,-104}}, color={255,127,0}));
  connect(staDow.y, booToInt.u) annotation (Line(points={{41,-110},{50,-110},{
          50,-70},{78,-70}}, color={255,0,255}));
  connect(booToInt.y, addInt.u2) annotation (Line(points={{102,-70},{110,-70},{
          110,-116},{128,-116}}, color={255,127,0}));
  connect(reaToInt.y, ySta) annotation (Line(points={{362,130},{400,130},{400,
          40},{430,40}}, color={255,127,0}));
  connect(sam.y, zerOrdHol.u)
    annotation (Line(points={{222,180},{238,180}},           color={0,0,127}));
  connect(zerOrdHol.y, reaToInt.u) annotation (Line(points={{262,180},{297.5,
          180},{297.5,130},{338,130}}, color={0,0,127}));
  connect(uChiAva, conf.uChiAva) annotation (Line(points={{-220,160},{-202,160},
          {-202,110},{-192,110}}, color={255,0,255}));
  connect(conf.yAva, sta.uAva) annotation (Line(points={{-168,106},{-164,106},{
          -164,44},{-142,44}},
                          color={255,0,255}));
  connect(conf.yTyp, PLRs.uTyp) annotation (Line(points={{-168,102},{-90,102},{-90,
          -17},{-81,-17}}, color={255,127,0}));
  connect(PLRs.uUp, sta.uUp) annotation (Line(points={{-81,-22},{-94,-22},{-94,
          55},{-119,55}},
                     color={255,127,0}));
  connect(sta.uDown, PLRs.uDown) annotation (Line(points={{-119,51},{-96,51},{
          -96,-24},{-81,-24}},
                           color={255,127,0}));
  connect(conf.yNomCap,cap.uDesCap)  annotation (Line(points={{-169,117},{-148,
          117},{-148,-61},{-141,-61}}, color={0,0,127}));
  connect(conf.yMinCap, cap.uMinCap) annotation (Line(points={{-168,114},{-146,
          114},{-146,-79},{-142,-79}}, color={0,0,127}));
  connect(sta.uUp, cap.uUp) annotation (Line(points={{-119,55},{-110,55},{-110,
          20},{-152,20},{-152,-69},{-141,-69}}, color={255,127,0}));
  connect(sta.uDown, cap.uDown) annotation (Line(points={{-119,51},{-112,51},{
          -112,22},{-154,22},{-154,-71},{-141,-71}}, color={255,127,0}));
  connect(sta.yHig, cap.uHig) annotation (Line(points={{-118,53},{-114,53},{
          -114,10},{-156,10},{-156,-73},{-142,-73}},
                                                color={255,0,255}));
  connect(sta.yLow, cap.uLow) annotation (Line(points={{-118,44},{-116,44},{
          -116,12},{-158,12},{-158,-76},{-142,-76}}, color={255,0,255}));
  connect(sta.yHig, staUp.uHigSta) annotation (Line(points={{-118,53},{12,53},{12,
          -2},{19,-2}},    color={255,0,255}));
  annotation (defaultComponentName = "staCha",
        Icon(graphics={
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
        extent={{-200,-280},{420,240}})),
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
