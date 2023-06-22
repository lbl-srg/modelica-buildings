within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Validation;
model Controller "Validation head pressure controller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller chiPlaCon(
    final closeCoupledPlant=false,
    final nChi=2,
    final have_parChi=true,
    final have_ponyChiller=false,
    final desCap=400,
    final TChiWatSupMin={278.15,278.15},
    final minChiLif=10,
    final have_heaPreConSig=false,
    final anyVsdCen=false,
    final heaExcAppDes=2,
    final nChiWatPum=2,
    final have_heaChiWatPum=true,
    final have_locSenChiWatPum=false,
    final nSenChiWatPum=1,
    final nConWatPum=2,
    final have_heaConWatPum=true,
    final nSta=2,
    final totSta=6,
    final staMat=[1,0; 1,1],
    final staVec={0,0.5,1,1.5,2,2.5},
    final desConWatPumSpe={0,0.5,0.75,0.6,0.75,0.9},
    final desConWatPumNum={0,1,1,2,2,2},
    final towCelOnSet={0,1,1,2,2,2},
    final nTowCel=2,
    final cooTowAppDes=2,
    final dpChiWatPumMax={10*6894.76},
    final TChiWatSupMax=291.15,
    final have_WSE=true,
    final chiDesCap={200,200},
    final chiMinCap={20,20},
    final chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement})
    "Chiller plant controller"
    annotation (Placement(transformation(extent={{-20,-180},{80,220}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uChiWatPum[2](
    final k={true,false}) "Chilled water pump status"
    annotation (Placement(transformation(extent={{-260,122},{-240,142}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabLin1(
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final table=[0,2; 600,4; 1200,6; 1800,6; 2400,8; 3000,8; 3600,8; 4200,6; 4800,6;
                 5400,6; 6000,7; 6600,7; 7200,7])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-320,-80},{-300,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-280,-80},{-260,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uChiAva[2](
    final k={true,true})
    "Chilled availability"
    annotation (Placement(transformation(extent={{-240,-60},{-220,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TChiWatSup(
    final height=4,
    final duration=7200,
    final offset=273.15 + 7) "Chilled water supply"
    annotation (Placement(transformation(extent={{-280,-10},{-260,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutWet(
    final k=283.15)
    "Outdoor wet bulb temperatur"
    annotation (Placement(transformation(extent={{-280,30},{-260,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut1(
    final k=313.15) "Outdoor dry bulb temperature"
    annotation (Placement(transformation(extent={{-260,-190},{-240,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TChiWatRet(
    final height=5,
    final duration=3600,
    final offset=273.15 + 15) "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-240,10},{-220,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TChiWatRetDow(
    final height=3,
    final duration=3600,
    final offset=273.15 + 10) "Chilled water return downstream of WSE"
    annotation (Placement(transformation(extent={{-300,-170},{-280,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TConWatRet(
    final k=307.15)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-220,-250},{-200,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TConWatSup(
    final k=305.15)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-260,-230},{-240,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    annotation (Placement(transformation(extent={{120,-150},{140,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[2]
    annotation (Placement(transformation(extent={{220,-50},{240,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro[2]
    annotation (Placement(transformation(extent={{260,-30},{280,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dpChiWat(
    final height=2*6895,
    final duration=3600,
    final offset=3*6895,
    final startTime=0) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-260,60},{-240,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[2]
    annotation (Placement(transformation(extent={{-240,160},{-220,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro1[2]
    annotation (Placement(transformation(extent={{-200,-138},{-180,-118}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneSta
    "Chiller one status"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoSta
    "Chiller two status"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Buildings.Controls.OBC.CDL.Logical.Pre towSta1[2](
    final pre_u_start=fill(false, 2))
    "Tower cell status"
    annotation (Placement(transformation(extent={{120,-180},{140,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp watLev(
    final height=1.2,
    final duration=3600,
    final offset=0.5) "Water level in cooling tower"
    annotation (Placement(transformation(extent={{-260,-270},{-240,-250}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[2](
    final samplePeriod=fill(5, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1[2](
    final samplePeriod=fill(5, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{220,-20},{240,0}})));
  Buildings.Controls.OBC.CDL.Logical.Pre conWatPum[2](
    final pre_u_start=fill(false, 2))
    "Condenser water pump status setpoint"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol2[2](
    final samplePeriod=fill(5, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiCooLoa[2](
    final height={80,70},
    final duration=fill(3600, 2),
    final offset={20,25})
    "Current chiller cooling load"
    annotation (Placement(transformation(extent={{-300,-130},{-280,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiWatFlo(
    final height=0.002,
    final duration=10800,
    final offset=0.0075) "Chilled water flow"
    annotation (Placement(transformation(extent={{-300,-210},{-280,-190}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr
    "Check if the WSE pump should be enabled"
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TEntHex(
    final height=3,
    final duration=3600,
    final offset=273.15 + 14)
    "Chilled water temperature entering heat exchanger"
    annotation (Placement(transformation(extent={{-280,-40},{-260,-20}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol3(
    final samplePeriod=5)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{148,-150},{168,-130}})));
equation
  connect(chiPlaCon.uChiWatPum, uChiWatPum.y) annotation (Line(points={{-30,180},
          {-190,180},{-190,132},{-238,132}}, color={255,0,255}));
  connect(timTabLin1.y[1], reaToInt1.u)
    annotation (Line(points={{-298,-70},{-282,-70}}, color={0,0,127}));
  connect(reaToInt1.y, chiPlaCon.TChiWatSupResReq) annotation (Line(points={{-258,
          -70},{-100,-70},{-100,-50},{-30,-50}},      color={255,127,0}));
  connect(chiPlaCon.yChi[1], chiOneSta.u) annotation (Line(points={{90,97.5},{120,
          97.5},{120,140},{138,140}},    color={255,0,255}));
  connect(chiPlaCon.yChi[2], chiTwoSta.u) annotation (Line(points={{90,102.5},{114,
          102.5},{114,90},{138,90}},     color={255,0,255}));
  connect(uChiAva.y, chiPlaCon.uChiAva) annotation (Line(points={{-218,-50},{-124,
          -50},{-124,5},{-30,5}}, color={255,0,255}));
  connect(TOutWet.y, chiPlaCon.TOutWet)
    annotation (Line(points={{-258,40},{-150,40},{-150,100},{-30,100}}, color={0,0,127}));
  connect(TOut1.y, chiPlaCon.TOut) annotation (Line(points={{-238,-180},{-150,-180},
          {-150,-100},{-30,-100}}, color={0,0,127}));
  connect(TChiWatRet.y, chiPlaCon.TChiWatRet)
    annotation (Line(points={{-218,20},{-128,20},{-128,80},{-30,80}},
                                                  color={0,0,127}));
  connect(TChiWatSup.y, chiPlaCon.TChiWatSup)
    annotation (Line(points={{-258,0},{-144,0},{-144,60},{-30,60}},
                                                  color={0,0,127}));
  connect(TChiWatRetDow.y, chiPlaCon.TChiWatRetDow) annotation (Line(points={{-278,
          -160},{-170,-160},{-170,90},{-30,90}}, color={0,0,127}));
  connect(TConWatRet.y, chiPlaCon.TConWatRet) annotation (Line(points={{-198,-240},
          {-134,-240},{-134,70},{-30,70}},         color={0,0,127}));
  connect(TConWatSup.y, chiPlaCon.TConWatSup) annotation (Line(points={{-238,-220},
          {-120,-220},{-120,-140},{-30,-140}},       color={0,0,127}));
  connect(watLev.y, chiPlaCon.watLev) annotation (Line(points={{-238,-260},{-90,
          -260},{-90,-160},{-30,-160}}, color={0,0,127}));
  connect(chiPlaCon.yTowFanSpe[2], max1.u2) annotation (Line(points={{90,-97.5},
          {106,-97.5},{106,-146},{118,-146}},color={0,0,127}));
  connect(chiPlaCon.yTowFanSpe[1], max1.u1) annotation (Line(points={{90,-102.5},
          {112,-102.5},{112,-134},{118,-134}},  color={0,0,127}));
  connect(chiPlaCon.yTowCel, towSta1.u) annotation (Line(points={{90,-85},{96,-85},
          {96,-170},{118,-170}},       color={255,0,255}));
  connect(towSta1.y, chiPlaCon.uTowSta) annotation (Line(points={{142,-170},{160,
          -170},{160,-190},{-40,-190},{-40,-170},{-30,-170}}, color={255,0,255}));
  connect(chiPlaCon.yTowCelIsoVal, zerOrdHol.u) annotation (Line(points={{90,-70},
          {100,-70},{100,-90},{118,-90}},      color={0,0,127}));
  connect(zerOrdHol.y, chiPlaCon.uIsoVal) annotation (Line(points={{142,-90},{
          190,-90},{190,-210},{-70,-210},{-70,-150},{-30,-150}}, color={0,0,127}));
  connect(chiPlaCon.yConWatPum, conWatPum.u) annotation (Line(points={{90,20},{
          108,20},{108,-40},{158,-40}},
                                    color={255,0,255}));
  connect(conWatPum.y, chiPlaCon.uConWatPum) annotation (Line(points={{182,-40},
          {210,-40},{210,-230},{-100,-230},{-100,-90},{-30,-90}}, color={255,0,255}));
  connect(conWatPum.y, booToRea.u)
    annotation (Line(points={{182,-40},{218,-40}}, color={255,0,255}));
  connect(zerOrdHol1.y, pro.u1) annotation (Line(points={{242,-10},{250,-10},{
          250,-14},{258,-14}}, color={0,0,127}));
  connect(booToRea.y, pro.u2) annotation (Line(points={{242,-40},{250,-40},{250,
          -26},{258,-26}}, color={0,0,127}));
  connect(pro.y, chiPlaCon.uConWatPumSpe) annotation (Line(points={{282,-20},{300,
          -20},{300,-250},{-110,-250},{-110,-80},{-30,-80}},    color={0,0,127}));
  connect(chiPlaCon.yChiWatIsoVal, zerOrdHol2.u) annotation (Line(points={{90,-15},
          {100,-15},{100,-60},{118,-60}}, color={0,0,127}));
  connect(zerOrdHol2.y, chiPlaCon.uChiWatIsoVal) annotation (Line(points={{142,-60},
          {200,-60},{200,-220},{-80,-220},{-80,-40},{-30,-40}}, color={0,0,127}));
  connect(dpChiWat.y, chiPlaCon.dpChiWat_remote[1]) annotation (Line(points={{-238,70},
          {-180,70},{-180,140},{-30,140}},          color={0,0,127}));
  connect(booToRea1.y, pro1.u1) annotation (Line(points={{-218,170},{-210,170},
          {-210,-122},{-202,-122}}, color={0,0,127}));
  connect(chiCooLoa.y, pro1.u2) annotation (Line(points={{-278,-120},{-220,-120},
          {-220,-134},{-202,-134}}, color={0,0,127}));
  connect(pro1.y, chiPlaCon.uChiCooLoa) annotation (Line(points={{-178,-128},{-70,
          -128},{-70,-110},{-30,-110}},  color={0,0,127}));
  connect(chiWatFlo.y, chiPlaCon.VChiWat_flow) annotation (Line(points={{-278,-200},
          {-160,-200},{-160,130},{-30,130}},     color={0,0,127}));
  connect(chiPlaCon.yConWatPumSpe, zerOrdHol1.u) annotation (Line(points={{90,50},
          {140,50},{140,-10},{218,-10}}, color={0,0,127}));
  connect(reaToInt1.y, chiPlaCon.chiPlaReq) annotation (Line(points={{-258,-70},
          {-100,-70},{-100,-60},{-30,-60}}, color={255,127,0}));
  connect(reaToInt1.y, intGreThr.u) annotation (Line(points={{-258,-70},{-220,-70},
          {-220,-90},{-202,-90}}, color={255,127,0}));
  connect(intGreThr.y, chiPlaCon.uEcoPum) annotation (Line(points={{-178,-90},{-140,
          -90},{-140,-5},{-30,-5}}, color={255,0,255}));
  connect(TEntHex.y, chiPlaCon.TEntHex) annotation (Line(points={{-258,-30},{-148,
          -30},{-148,-15},{-30,-15}}, color={0,0,127}));
  connect(max1.y, zerOrdHol3.u)
    annotation (Line(points={{142,-140},{146,-140}}, color={0,0,127}));
  connect(zerOrdHol3.y, chiPlaCon.uFanSpe) annotation (Line(points={{170,-140},
          {180,-140},{180,-200},{-60,-200},{-60,-130},{-30,-130}}, color={0,0,
          127}));
  connect(chiOneSta.y, booToRea1[1].u) annotation (Line(points={{162,140},{200,140},
          {200,260},{-250,260},{-250,170},{-242,170}},     color={255,0,255}));
  connect(chiOneSta.y, chiPlaCon.uChiConIsoVal[1]) annotation (Line(points={{162,140},
          {200,140},{200,260},{-90,260},{-90,207.5},{-30,207.5}}, color=
          {255,0,255}));
  connect(chiOneSta.y, chiPlaCon.uConWatReq[1]) annotation (Line(points={{162,140},
          {200,140},{200,260},{-90,260},{-90,187.5},{-30,187.5}},    color={255,
          0,255}));
  connect(chiOneSta.y, chiPlaCon.uChiIsoVal[1]) annotation (Line(points={{162,140},
          {200,140},{200,260},{-90,260},{-90,167.5},{-30,167.5}},    color={255,
          0,255}));
  connect(chiOneSta.y, chiPlaCon.uChi[1]) annotation (Line(points={{162,140},{200,
          140},{200,260},{-90,260},{-90,117.5},{-30,117.5}},    color={255,0,
          255}));
  connect(chiOneSta.y, chiPlaCon.uChiHeaCon[1]) annotation (Line(points={{162,140},
          {200,140},{200,260},{-90,260},{-90,-32.5},{-30,-32.5}},    color={255,
          0,255}));
  connect(chiTwoSta.y, booToRea1[2].u) annotation (Line(points={{162,90},{210,90},
          {210,270},{-260,270},{-260,170},{-242,170}},     color={255,0,255}));
  connect(chiTwoSta.y, chiPlaCon.uChiConIsoVal[2]) annotation (Line(points={{162,90},
          {210,90},{210,270},{-100,270},{-100,212.5},{-30,212.5}},
        color={255,0,255}));
  connect(chiTwoSta.y, chiPlaCon.uConWatReq[2]) annotation (Line(points={{162,90},
          {210,90},{210,270},{-100,270},{-100,192.5},{-30,192.5}},     color={
          255,0,255}));
  connect(chiTwoSta.y, chiPlaCon.uChiIsoVal[2]) annotation (Line(points={{162,90},
          {210,90},{210,270},{-100,270},{-100,172.5},{-30,172.5}},     color={
          255,0,255}));
  connect(chiTwoSta.y, chiPlaCon.uChi[2]) annotation (Line(points={{162,90},{210,
          90},{210,270},{-100,270},{-100,122.5},{-30,122.5}},     color={255,0,
          255}));
  connect(chiTwoSta.y, chiPlaCon.uChiHeaCon[2]) annotation (Line(points={{162,90},
          {210,90},{210,270},{-100,270},{-100,-27.5},{-30,-27.5}},     color={
          255,0,255}));
  connect(chiOneSta.y, chiPlaCon.uChiWatReq[1]) annotation (Line(points={{162,
          140},{200,140},{200,260},{-90,260},{-90,197.5},{-30,197.5}}, color={
          255,0,255}));
  connect(chiTwoSta.y, chiPlaCon.uChiWatReq[2]) annotation (Line(points={{162,
          90},{210,90},{210,270},{-100,270},{-100,202.5},{-30,202.5}}, color={
          255,0,255}));
annotation (
  experiment(StopTime=10800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates composed chiller plant controller
<a href=\"modelica://Buildings.Controls.OBC.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller</a>. It shows the
process of enabling plant, enabling waterside economizer and staging up one chiller.
</p>
</html>", revisions="<html>
<ul>
<li>
September, 2021, by Jianjun Hu:<br/>
Refactored the implementations.
</li>
<li>
August 30, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-340,-300},{340,
            300}})));
end Controller;
