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

  parameter Real posDisMult(unit = "1", min = 0, max = 1)=0.8
    "Positive displacement chiller type staging multiplier";

  parameter Real conSpeCenMult(unit = "1", min = 0, max = 1)=0.9
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

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta "Waterside economizer status" annotation (
     Placement(transformation(extent={{-220,110},{-180,150}}),
        iconTransformation(extent={{-120,70},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaAva[nSta] "Stage availability status"
    annotation (Placement(transformation(extent={{-220,140},{-180,180}}),
        iconTransformation(extent={{-120,90},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta(
    final min=0,
    final max=nSta) "Chiller stage"
    annotation (Placement(transformation(extent={{-220,170},{-180,210}}),
      iconTransformation(extent={{-120,110},{-100,130}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-220,-280},{-180,-240}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWsePre(final unit="1")
    "Predicted waterside economizer outlet temperature" annotation (Placement(
        transformation(extent={{-220,-240},{-180,-200}}), iconTransformation(
          extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature" annotation (Placement(transformation(
          extent={{-220,-210},{-180,-170}}), iconTransformation(extent={{-120,-30},
            {-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure" annotation (Placement(
        transformation(extent={{-220,-170},{-180,-130}}), iconTransformation(
          extent={{-120,-70},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint" annotation (
      Placement(transformation(extent={{-220,-140},{-180,-100}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMax(
    final unit="K",
    final quantity="ThermodynamicTemperature") if nVsdCen>0
    "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-220,-30},{-180,10}}),
        iconTransformation(extent={{-120,-160},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMin(
    final unit="K",
    final quantity="ThermodynamicTemperature") if nVsdCen>0
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),
        iconTransformation(extent={{-120,-180},{-100,-160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLif(
    final unit="K",
    final quantity="ThermodynamicTemperature") if nVsdCen>0
    "Chiller lift"
    annotation (Placement(transformation(extent={{-220,-90},{-180,-50}}),
        iconTransformation(extent={{-120,-140},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint" annotation (Placement(
        transformation(extent={{-220,70},{-180,110}}),  iconTransformation(
          extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
      iconTransformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-220,10},{-180,50}}),
      iconTransformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y(
    final max=1,
    final min=-1)
    "fixme change to chiller stage and loop back as input to up and down seq"
    annotation (Placement(transformation(extent={{180,-20},{200,0}}),
                           iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta(final max=1, final min=-1)
    "fixme: see if this needs to be removed when joined with the up and down process "
    annotation (Placement(transformation(extent={{180,60},{200,80}}),
        iconTransformation(extent={{100,40},{120,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap(
    final nSta = nSta,
    final staNomCap = staNomCap,
    final minStaUnlCap = minStaUnlCap) "Nominal and minimal capacities at each stage"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

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
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Boolean to integer conversion"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Boolean to integer conversion"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt(
    final k2=-1)
    "Adder"
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up staUp(
    final delayStaCha = delayStaCha,
    final TDiff = TDiff,
    final dpDiff = dpDiff,
    final hasWSE = hasWSE,
    final shortDelay = shortDelay,
    final longDelay = longDelay,
    final smallTDiff = smallTDiff,
    final largeTDiff = largeTDiff) "Stage up conditions"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down staDow(
    final hasWSE = hasWSE,
    final delayStaCha = delayStaCha,
    final TDiff = TDiff,
    final dpDiff = dpDiff) "Stage down conditions"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt1(final k2=+1)
    "Adder"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));

equation
  connect(booToInt.y, addInt.u1) annotation (Line(points={{121,10},{130,10},{130,
          -4},{138,-4}}, color={255,127,0}));
  connect(booToInt1.y, addInt.u2) annotation (Line(points={{121,-30},{130,-30},{
          130,-16},{138,-16}}, color={255,127,0}));
  connect(addInt.y, y)
    annotation (Line(points={{161,-10},{190,-10}},                 color={255,127,0}));
  connect(staCap.yStaNom,PLRs. uStaCapNom) annotation (Line(points={{-99,-63},{-74,
          -63},{-74,-5},{-61,-5}},     color={0,0,127}));
  connect(staCap.yStaUpNom,PLRs. uStaUpCapNom) annotation (Line(points={{-99,-67},
          {-72,-67},{-72,-7},{-61,-7}},      color={0,0,127}));
  connect(staCap.yStaDowNom,PLRs. uStaDowCapNom) annotation (Line(points={{-99,-71},
          {-70,-71},{-70,-9},{-61,-9}},      color={0,0,127}));
  connect(staCap.yStaUpMin,PLRs. uStaUpCapMin) annotation (Line(points={{-99,-76},
          {-66,-76},{-66,-11},{-61,-11}},      color={0,0,127}));
  connect(staCap.yStaMin,PLRs. uStaCapMin) annotation (Line(points={{-99,-78},{-64,
          -78},{-64,-13},{-61,-13}}, color={0,0,127}));
  connect(staUp.y, booToInt.u)
    annotation (Line(points={{81,10},{98,10}}, color={255,0,255}));
  connect(staDow.y, booToInt1.u)
    annotation (Line(points={{81,-30},{98,-30}}, color={255,0,255}));
  connect(capReq.y, PLRs.uCapReq) annotation (Line(points={{-99,-10},{-80,-10},{
          -80,-3},{-61,-3}}, color={0,0,127}));
  connect(uSta, PLRs.uSta) annotation (Line(points={{-200,190},{-70,190},{-70,-1},
          {-61,-1}}, color={255,127,0}));
  connect(uSta, staCap.uSta) annotation (Line(points={{-200,190},{-130,190},{-130,
          -70},{-122,-70}}, color={255,127,0}));
  connect(TChiWatSupSet, capReq.TChiWatSupSet) annotation (Line(points={{-200,90},
          {-140,90},{-140,-5},{-121,-5}},  color={0,0,127}));
  connect(TChiWatRet, capReq.TChiWatRet) annotation (Line(points={{-200,60},{-148,
          60},{-148,-10},{-121,-10}}, color={0,0,127}));
  connect(VChiWat_flow, capReq.VChiWat_flow) annotation (Line(points={{-200,30},
          {-160,30},{-160,-15},{-121,-15}}, color={0,0,127}));
  connect(PLRs.y, staUp.uOplr) annotation (Line(points={{-39,-3},{-20,-3},{-20,0},
          {-10,0},{-10,20},{59,20}}, color={0,0,127}));
  connect(PLRs.yStaUp, staUp.uSplrUp) annotation (Line(points={{-39,-11},{-8,-11},
          {-8,18},{59,18}}, color={0,0,127}));
  connect(PLRs.yUp, staUp.uOplrUp) annotation (Line(points={{-39,-5},{-6,-5},{-6,
          15},{59,15}}, color={0,0,127}));
  connect(PLRs.yUpMin, staUp.uOplrUpMin) annotation (Line(points={{-39,-17},{-4,
          -17},{-4,13},{59,13}}, color={0,0,127}));
  connect(PLRs.yDow, staDow.uOplrDow) annotation (Line(points={{-39,-7},{2,-7},{
          2,-18},{59,-18}}, color={0,0,127}));
  connect(PLRs.yStaDow, staDow.uSplrDow) annotation (Line(points={{-39,-13},{0,-13},
          {0,-20},{59,-20}},       color={0,0,127}));
  connect(PLRs.y, staDow.uOplr) annotation (Line(points={{-39,-3},{4,-3},{4,-22},
          {59,-22}},      color={0,0,127}));
  connect(PLRs.yMin, staDow.uOplrMin) annotation (Line(points={{-39,-19},{-20,-19},
          {-20,-24},{59,-24}}, color={0,0,127}));
  connect(dpChiWatPumSet, staDow.dpChiWatPumSet) annotation (Line(points={{-200,
          -120},{0,-120},{0,-26},{59,-26}}, color={0,0,127}));
  connect(dpChiWatPum, staDow.dpChiWatPum) annotation (Line(points={{-200,-150},
          {2,-150},{2,-28},{59,-28}}, color={0,0,127}));
  connect(TChiWatSupSet, staUp.TChiWatSupSet) annotation (Line(points={{-200,90},
          {6,90},{6,10},{59,10}},  color={0,0,127}));
  connect(TChiWatSupSet, staDow.TChiWatSupSet) annotation (Line(points={{-200,90},
          {6,90},{6,-30},{59,-30}},  color={0,0,127}));
  connect(TChiWatSup, staDow.TChiWatSup) annotation (Line(points={{-200,-190},{
          6,-190},{6,-32},{59,-32}},color={0,0,127}));
  connect(TChiWatSup, staUp.TChiWatSup) annotation (Line(points={{-200,-190},{8,
          -190},{8,8},{59,8}}, color={0,0,127}));
  connect(TWsePre, staDow.TWsePre) annotation (Line(points={{-200,-220},{10,
          -220},{10,-34},{59,-34}}, color={0,0,127}));
  connect(dpChiWatPumSet, staUp.dpChiWatPumSet) annotation (Line(points={{-200,-120},
          {12,-120},{12,5},{59,5}}, color={0,0,127}));
  connect(dpChiWatPum, staUp.dpChiWatPum) annotation (Line(points={{-200,-150},{
          14,-150},{14,3},{59,3}}, color={0,0,127}));
  connect(uTowFanSpeMax, staDow.uTowFanSpeMax) annotation (Line(points={{-200,-260},
          {16,-260},{16,-36},{59,-36}}, color={0,0,127}));
  connect(uSta, staUp.uChiSta) annotation (Line(points={{-200,190},{18,190},{18,
          0},{59,0}}, color={255,127,0}));
  connect(uSta, staDow.uChiSta) annotation (Line(points={{-200,190},{20,190},{20,
          -40},{59,-40}}, color={255,127,0}));
  connect(uWseSta, staDow.uWseSta) annotation (Line(points={{-200,130},{22,130},
          {22,-38},{59,-38}},  color={255,0,255}));
  connect(uLifMax, PLRs.uLifMax) annotation (Line(points={{-200,-10},{-170,-10},
          {-170,-24},{-90,-24},{-90,-18},{-61,-18}}, color={0,0,127}));
  connect(uLifMin, PLRs.uLifMin) annotation (Line(points={{-200,-40},{-170,-40},
          {-170,-26},{-88,-26},{-88,-20},{-61,-20}}, color={0,0,127}));
  connect(uLif, PLRs.uLif) annotation (Line(points={{-200,-70},{-170,-70},{-170,
          -40},{-92,-40},{-92,-16},{-61,-16}},color={0,0,127}));
  connect(uStaAva, staCap.uStaAva) annotation (Line(points={{-200,160},{-132,160},
          {-132,-76},{-122,-76}}, color={255,0,255}));
  connect(addInt1.y, ySta)
    annotation (Line(points={{161,70},{190,70}}, color={255,127,0}));
  connect(addInt.y, addInt1.u2) annotation (Line(points={{161,-10},{170,-10},{170,
          50},{130,50},{130,64},{138,64}}, color={255,127,0}));
  connect(uSta, addInt1.u1) annotation (Line(points={{-200,190},{130,190},{130,76},
          {138,76}}, color={255,127,0}));
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
        extent={{-180,-280},{180,200}})),
Documentation(info="<html>
<p>
Outputs the chiller stage change signal

fixme: add a stage availability input signal, which will
remove the stage change delay if the stage is unavailable, to
allow for a change to the next available stage at the next instant.  

add WSE enable at plant enable part (input, output, predicted temperature) and at staging down from 1.
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
