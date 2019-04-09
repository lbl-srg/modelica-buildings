within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Change "Calculates the chiller stage signal"

  parameter Boolean hasWSE = true
    "true = plant has a WSE, false = plant does not have WSE";

  parameter Integer nPosDis = 2
    "Number of chiller stages of positive displacement chiller type";

  parameter Integer nVsdCen = 0
    "Number of chiller stages of variable speed centrifugal chiller type";

  parameter Integer nConCen = 0
    "Number of chiller stages of constant speed centrifugal chiller type";

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

  final parameter Integer nSta = nPosDis + nVsdCen + nConCen
    "Number of stages";

  parameter Modelica.SIunits.Power staNomCap[nSta] = fill(5e5, nSta)
    "Array of nominal capacities at each individual stage";

  parameter Modelica.SIunits.Power minStaUnlCap[nSta] = fill(0.2*staNomCap[1], nSta)
    "Array of unload capacities at each individual stage";

  parameter Modelica.SIunits.Time delayStaCha = 15*60
    "Delay stage change";

  parameter Modelica.SIunits.Time avePer = 5*60
  "Period for the rolling average";

  parameter Modelica.SIunits.Time shortDelay = 10*60
    "Short stage 0 to 1 delay";

  parameter Modelica.SIunits.Time longDelay = 20*60
    "Long stage 0 to 1 delay";

  parameter Modelica.SIunits.TemperatureDifference smallTDiff = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference largeTDiff = 2
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.TemperatureDifference TDiff = 1
    "Offset between the chilled water supply temperature and its setpoint";

  parameter Modelica.SIunits.PressureDifference dpDiff = 2 * 6895
    "Offset between the chilled water pump differential static pressure and its setpoint";

  parameter Modelica.SIunits.Density watDen = 1000 "Water density";

  parameter Modelica.SIunits.SpecificHeatCapacity watSpeHea = 4184
  "Specific heat capacity of water";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta
    "Waterside economizer status"
    annotation (
     Placement(transformation(extent={{-240,110},{-200,150}}),
        iconTransformation(extent={{-120,70},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaAva[nSta]
    "Stage availability status"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-120,90},{-100,110}})));

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
    "Chilled water pump differential static pressure" annotation (Placement(
        transformation(extent={{-240,-170},{-200,-130}}), iconTransformation(
          extent={{-120,-70},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint" annotation (
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
    annotation (Placement(transformation(extent={{340,-50},{360,-30}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta(
    final start=0,
    final max=nSta,
    final min=0)
    "Chiller stage"
    annotation (Placement(transformation(extent={{340,30},{360,50}}),
      iconTransformation(extent={{100,40},{120,60}})));

//protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap(
    final nSta = nSta,
    final staNomCap = staNomCap,
    final minStaUnlCap = minStaUnlCap) "Nominal and minimal capacities at each stage"
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
    final TDiff = TDiff,
    final dpDiff = dpDiff,
    final hasWSE = hasWSE,
    final shortDelay = shortDelay,
    final longDelay = longDelay,
    final smallTDiff = smallTDiff,
    final largeTDiff = largeTDiff) "Stage up conditions"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down staDow(
    final hasWSE = hasWSE,
    final delayStaCha = delayStaCha,
    final TDiff = TDiff,
    final dpDiff = dpDiff) "Stage down conditions"
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

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(
    final samplePeriod=1)
    "Stage change delay"
    annotation (Placement(transformation(extent={{220,120},{240,140}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Type converter"
    annotation (Placement(transformation(extent={{260,120},{280,140}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam2
    "Triggered sampler"
    annotation (Placement(transformation(extent={{280,80},{300,100}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Type converter"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Type converter"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));

  CDL.Conversions.BooleanToReal booToRea[nSta](realTrue=fill(0, nSta),
      realFalse=fill(1, nSta))
    "Negated state availability signal (true if stage unavailable)"
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  CDL.Routing.RealExtractor                        extStaLowCap(final
      outOfRangeValue=-1, final nin=nSta)
    "Extracts the nominal capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  CDL.Conversions.RealToInteger reaToInt1
    annotation (Placement(transformation(extent={{170,70},{190,90}})));
  CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{262,40},{282,60}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{232,60},{252,80}})));
  CDL.Logical.Or or1
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=delayStaCha,
      falseHoldDuration=delayStaCha)
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  CDL.Integers.Change cha
    annotation (Placement(transformation(extent={{200,70},{220,90}})));
  CDL.Logical.Change
                   cha1
    annotation (Placement(transformation(extent={{180,30},{200,50}})));
equation
  connect(staCap.yStaNom,PLRs. uStaCapNom) annotation (Line(points={{-119,-63},{
          -94,-63},{-94,-5},{-81,-5}}, color={0,0,127}));
  connect(staCap.yStaUpNom,PLRs. uStaUpCapNom) annotation (Line(points={{-119,-67},
          {-92,-67},{-92,-7},{-81,-7}},      color={0,0,127}));
  connect(staCap.yStaDowNom,PLRs. uStaDowCapNom) annotation (Line(points={{-119,
          -71},{-90,-71},{-90,-9},{-81,-9}}, color={0,0,127}));
  connect(staCap.yStaUpMin,PLRs. uStaUpCapMin) annotation (Line(points={{-119,-76},
          {-86,-76},{-86,-11},{-81,-11}}, color={0,0,127}));
  connect(staCap.yStaMin,PLRs. uStaCapMin) annotation (Line(points={{-119,-78},{
          -84,-78},{-84,-13},{-81,-13}}, color={0,0,127}));
  connect(capReq.y, PLRs.uCapReq) annotation (Line(points={{-119,-10},{-100,-10},
          {-100,-3},{-81,-3}}, color={0,0,127}));
  connect(TChiWatSupSet, capReq.TChiWatSupSet) annotation (Line(points={{-220,90},
          {-160,90},{-160,-5},{-141,-5}},  color={0,0,127}));
  connect(TChiWatRet, capReq.TChiWatRet) annotation (Line(points={{-220,60},{-168,
          60},{-168,-10},{-141,-10}}, color={0,0,127}));
  connect(VChiWat_flow, capReq.VChiWat_flow) annotation (Line(points={{-220,30},
          {-180,30},{-180,-15},{-141,-15}}, color={0,0,127}));
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
  connect(uWseSta, staDow.uWseSta) annotation (Line(points={{-220,130},{2,130},{
          2,-118},{19,-118}},  color={255,0,255}));
  connect(uLifMax, PLRs.uLifMax) annotation (Line(points={{-220,-10},{-190,-10},
          {-190,-24},{-110,-24},{-110,-18},{-81,-18}}, color={0,0,127}));
  connect(uLifMin, PLRs.uLifMin) annotation (Line(points={{-220,-40},{-190,-40},
          {-190,-26},{-108,-26},{-108,-20},{-81,-20}}, color={0,0,127}));
  connect(uLif, PLRs.uLif) annotation (Line(points={{-220,-70},{-190,-70},{-190,
          -40},{-112,-40},{-112,-16},{-81,-16}}, color={0,0,127}));
  connect(uStaAva, staCap.uStaAva) annotation (Line(points={{-220,160},{-152,160},
          {-152,-76},{-142,-76}}, color={255,0,255}));
  connect(conInt.y, minInt.u1) annotation (Line(points={{201,-30},{210,-30},{
          210,-34},{218,-34}}, color={255,127,0}));
  connect(addInt1.y, minInt.u2) annotation (Line(points={{201,-70},{210,-70},{
          210,-46},{218,-46}}, color={255,127,0}));
  connect(conInt1.y, maxInt.u1) annotation (Line(points={{201,10},{210,10},{210,
          16},{258,16}}, color={255,127,0}));
  connect(minInt.y, maxInt.u2) annotation (Line(points={{241,-40},{250,-40},{
          250,4},{258,4}},   color={255,127,0}));
  connect(zerOrdHol.y, reaToInt.u)
    annotation (Line(points={{241,130},{258,130}}, color={0,0,127}));
  connect(addInt.y, addInt1.u2) annotation (Line(points={{151,-110},{160,-110},
          {160,-76},{178,-76}},color={255,127,0}));
  connect(reaToInt.y, addInt1.u1) annotation (Line(points={{281,130},{290,130},
          {290,150},{160,150},{160,-64},{178,-64}}, color={255,127,0}));
  connect(reaToInt.y, staUp.uChiSta) annotation (Line(points={{281,130},{290,
          130},{290,150},{10,150},{10,0},{19,0}}, color={255,127,0}));
  connect(reaToInt.y, PLRs.uSta) annotation (Line(points={{281,130},{290,130},{
          290,150},{-90,150},{-90,-1},{-81,-1}}, color={255,127,0}));
  connect(reaToInt.y, staCap.uSta) annotation (Line(points={{281,130},{290,130},
          {290,150},{-150,150},{-150,-70},{-142,-70}}, color={255,127,0}));
  connect(reaToInt.y, staDow.uChiSta) annotation (Line(points={{281,130},{290,
          130},{290,150},{10,150},{10,-120},{19,-120}}, color={255,127,0}));
  connect(addInt.y, y) annotation (Line(points={{151,-110},{320,-110},{320,-40},
          {350,-40}},color={255,127,0}));
  connect(maxInt.y, intToRea.u)
    annotation (Line(points={{281,10},{288,10}}, color={255,127,0}));
  connect(intToRea.y, triSam2.u) annotation (Line(points={{311,10},{320,10},{
          320,68},{272,68},{272,90},{278,90}}, color={0,0,127}));
  connect(staUp.y, booToInt1.u) annotation (Line(points={{41,10},{50,10},{50,
          -40},{78,-40}}, color={255,0,255}));
  connect(booToInt1.y, addInt.u1) annotation (Line(points={{101,-40},{120,-40},
          {120,-104},{128,-104}}, color={255,127,0}));
  connect(staDow.y, booToInt.u) annotation (Line(points={{41,-110},{50,-110},{
          50,-70},{78,-70}}, color={255,0,255}));
  connect(booToInt.y, addInt.u2) annotation (Line(points={{101,-70},{110,-70},{
          110,-116},{128,-116}}, color={255,127,0}));
  connect(triSam2.y, zerOrdHol.u) annotation (Line(points={{301,90},{320,90},{
          320,110},{200,110},{200,130},{218,130}}, color={0,0,127}));
  connect(reaToInt.y, ySta) annotation (Line(points={{281,130},{336,130},{336,
          40},{350,40}}, color={255,127,0}));
  connect(uStaAva, booToRea.u) annotation (Line(points={{-220,160},{70,160},{70,
          110},{78,110}}, color={255,0,255}));
  connect(reaToInt.y, extStaLowCap.index) annotation (Line(points={{281,130},{
          292,130},{292,160},{150,160},{150,90},{130,90},{130,98}}, color={255,
          127,0}));
  connect(booToRea.y, extStaLowCap.u)
    annotation (Line(points={{101,110},{118,110}}, color={0,0,127}));
  connect(extStaLowCap.y, reaToInt1.u) annotation (Line(points={{141,110},{156,
          110},{156,80},{168,80}}, color={0,0,127}));
  connect(staUp.y, or1.u1) annotation (Line(points={{41,10},{50,10},{50,30},{78,
          30}}, color={255,0,255}));
  connect(staDow.y, or1.u2) annotation (Line(points={{41,-110},{60,-110},{60,22},
          {78,22}}, color={255,0,255}));
  connect(or1.y, truFalHol.u)
    annotation (Line(points={{101,30},{119,30}}, color={255,0,255}));
  connect(reaToInt1.y, cha.u)
    annotation (Line(points={{191,80},{198,80}}, color={255,127,0}));
  connect(staUp.y, and2.u2) annotation (Line(points={{41,10},{172,10},{172,60},
          {202,60},{202,62},{230,62}},
                         color={255,0,255}));
  connect(and2.y, or2.u1) annotation (Line(points={{253,70},{258,70},{258,50},{
          260,50}}, color={255,0,255}));
  connect(or2.y, triSam2.trigger) annotation (Line(points={{283,50},{288,50},{
          288,78.2},{290,78.2}}, color={255,0,255}));
  connect(truFalHol.y, cha1.u) annotation (Line(points={{141,30},{166,30},{166,
          40},{178,40}}, color={255,0,255}));
  connect(cha1.y, or2.u2) annotation (Line(points={{201,40},{234,40},{234,42},{
          260,42}}, color={255,0,255}));
  connect(cha.y, and2.u1) annotation (Line(points={{221,80},{224,80},{224,70},{
          230,70}}, color={255,0,255}));
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
        extent={{-200,-280},{340,200}})),
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
January xx, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Change;
