within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Validation;
model Controller "Validation head pressure controller"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Controller chiPlaCon(
    dTChiMinLif={285.15,285.15},
    dTChiMaxLif={291.15,291.15},
    TOutWetDes=288.15,
    minFloSet={0.0089,0.0089},
    maxFloSet={0.025,0.025},
    nPum_nominal=2,
    final closeCoupledPlant=false,
    final nChi=2,
    final have_parChi=true,
    final have_ponyChiller=false,
    final TChiWatSupMin={278.15,278.15},
    final heaExcAppDes=2,
    final nChiWatPum=2,
    final have_heaChiWatPum=true,
    final have_locSenChiWatPum=false,
    final nSenChiWatPum=1,
    final nConWatPum=2,
    final have_heaConWatPum=true,
    final conWatPumStaMat=[0,0; 1,0; 1,0; 1,1; 1,1; 1,1],
    final staMat=[1,0; 1,1],
    final desConWatPumSpe={0,0.5,0.75,0.5,0.75,0.9},
    final towCelOnSet={0,1,1,2,2,2},
    final nTowCel=2,
    final cooTowAppDes=2,
    VHeaExcDes_flow=0.015,
    VChiWat_flow_nominal=0.5,
    final dpChiWatMax={10*6894.76},
    final TPlaChiWatSupMax=291.15,
    final have_WSE=true,
    final chiDesCap={200,200},
    final chiMinCap={20,20},
    final chiTyp={Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.ChillersAndStages.PositiveDisplacement,
                  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.ChillersAndStages.PositiveDisplacement},
    TConWatSup_nominal={293.15,293.15},
    TConWatRet_nominal={303.15,303.15},
    watLevMin=0.7,
    watLevMax=1)
    "Chiller plant controller"
    annotation (Placement(transformation(extent={{-20,-180},{80,220}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uChiWatPum[2](
    final k={true,false}) "Chilled water pump status"
    annotation (Placement(transformation(extent={{-260,122},{-240,142}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable timTabLin1(
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final table=[0,2; 600,4; 1200,6; 1800,6; 2400,8; 3000,8; 3600,8; 4200,6; 4800,6;
                 5400,6; 6000,7; 6600,7; 7200,7])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-320,-80},{-300,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-280,-80},{-260,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TChiWatSup(
    final height=4,
    final duration=7200,
    final offset=273.15 + 7) "Chilled water supply"
    annotation (Placement(transformation(extent={{-300,0},{-280,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant phi(final k=0.65)
    "Outdoor relative humidity"
    annotation (Placement(transformation(extent={{-300,50},{-280,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut1(
    final k=313.15) "Outdoor dry bulb temperature"
    annotation (Placement(transformation(extent={{-260,-190},{-240,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TChiWatRet(
    final height=5,
    final duration=3600,
    final offset=273.15 + 15) "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-240,20},{-220,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TChiWatRetDow(
    final height=3,
    final duration=3600,
    final offset=273.15 + 10) "Chilled water return downstream of WSE"
    annotation (Placement(transformation(extent={{-300,-170},{-280,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TConWatRet(
    final k=307.15)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-220,-250},{-200,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TConWatSup(
    final k=305.15)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-260,-230},{-240,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp dpChiWat(
    final height=2*6895,
    final duration=3600,
    final offset=3*6895,
    final startTime=0) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-260,80},{-240,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp watLev(
    final height=1.2,
    final duration=3600,
    final offset=0.5) "Water level in cooling tower"
    annotation (Placement(transformation(extent={{-260,-270},{-240,-250}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol2[2](
    final samplePeriod=fill(5, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{160,-70},{180,-50}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr
    "Check if the WSE pump should be enabled"
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TEntHex(
    final height=3,
    final duration=3600,
    final offset=273.15 + 14)
    "Chilled water temperature entering heat exchanger"
    annotation (Placement(transformation(extent={{-280,-40},{-260,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable chiWatFlo(
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.LinearSegments,
    final table=[0,0; 6500,0; 7000,0.005; 7500,0.008; 9200,0.02; 10000,0.020;
        10800,0.024],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-300,-210},{-280,-190}})));
  Buildings.Templates.Components.Controls.StatusEmulator chiOne "Chiller one status"
    annotation (Placement(transformation(extent={{140,170},{160,190}})));
  Buildings.Templates.Components.Controls.StatusEmulator chiTwo "Chiller two status"
    annotation (Placement(transformation(extent={{140,110},{160,130}})));
  Buildings.Templates.Components.Controls.StatusEmulator conWatPum[2]
    "Condenser water pump status setpoint"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Templates.Components.Controls.StatusEmulator towSta[2] "Tower cell status"
    annotation (Placement(transformation(extent={{120,-180},{140,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant plaEna(final k=true)
    "Plant enable"
    annotation (Placement(transformation(extent={{-200,200},{-180,220}})));
  CDL.Conversions.BooleanToReal booToRea[2] "Convert valve command to position"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
equation
  connect(chiPlaCon.uChiWatPum, uChiWatPum.y) annotation (Line(points={{-30,180},
          {-190,180},{-190,132},{-238,132}}, color={255,0,255}));
  connect(timTabLin1.y[1], reaToInt1.u)
    annotation (Line(points={{-298,-70},{-282,-70}}, color={0,0,127}));
  connect(reaToInt1.y, chiPlaCon.TChiWatSupResReq) annotation (Line(points={{-258,
          -70},{-100,-70},{-100,-50},{-30,-50}},      color={255,127,0}));
  connect(phi.y, chiPlaCon.phi) annotation (Line(points={{-278,60},{-150,60},{
          -150,110},{-30,110}},
                           color={0,0,127}));
  connect(TOut1.y, chiPlaCon.TOut) annotation (Line(points={{-238,-180},{-150,
          -180},{-150,-90},{-30,-90}},
                                   color={0,0,127}));
  connect(TChiWatRet.y, chiPlaCon.TChiWatRet)
    annotation (Line(points={{-218,30},{-128,30},{-128,90},{-30,90}}, color={0,0,127}));
  connect(TChiWatSup.y, chiPlaCon.TChiWatSup)
    annotation (Line(points={{-278,10},{-144,10},{-144,60},{-30,60}}, color={0,0,127}));
  connect(TChiWatRetDow.y, chiPlaCon.TChiWatRetDow) annotation (Line(points={{-278,
          -160},{-170,-160},{-170,100},{-30,100}},
                                                 color={0,0,127}));
  connect(TConWatSup.y, chiPlaCon.TConWatSup) annotation (Line(points={{-238,
          -220},{-120,-220},{-120,-115},{-30,-115}}, color={0,0,127}));
  connect(watLev.y, chiPlaCon.watLev) annotation (Line(points={{-238,-260},{-90,
          -260},{-90,-165},{-30,-165}}, color={0,0,127}));
  connect(zerOrdHol2.y, chiPlaCon.uChiWatIsoVal) annotation (Line(points={{182,-60},
          {200,-60},{200,-220},{-80,-220},{-80,-20},{-30,-20}}, color={0,0,127}));
  connect(dpChiWat.y, chiPlaCon.dpChiWat_remote[1]) annotation (Line(points={{-238,90},
          {-180,90},{-180,140},{-30,140}}, color={0,0,127}));
  connect(reaToInt1.y, chiPlaCon.chiPlaReq) annotation (Line(points={{-258,-70},
          {-100,-70},{-100,-60},{-30,-60}}, color={255,127,0}));
  connect(reaToInt1.y, intGreThr.u) annotation (Line(points={{-258,-70},{-220,-70},
          {-220,-90},{-202,-90}}, color={255,127,0}));
  connect(intGreThr.y, chiPlaCon.uEcoPum) annotation (Line(points={{-178,-90},{
          -140,-90},{-140,0},{-30,0}},
                                    color={255,0,255}));
  connect(TEntHex.y, chiPlaCon.TEntHex) annotation (Line(points={{-258,-30},{
          -148,-30},{-148,-10},{-30,-10}},
                                      color={0,0,127}));
  connect(chiWatFlo.y[1], chiPlaCon.VChiWat_flow) annotation (Line(points={{
          -278,-200},{-160,-200},{-160,130},{-30,130}}, color={0,0,127}));
  connect(chiPlaCon.yChi[1], chiOne.y1) annotation (Line(points={{90,51.5},{110,
          51.5},{110,180},{138,180}}, color={255,0,255}));
  connect(chiPlaCon.yChi[2], chiTwo.y1) annotation (Line(points={{90,56.5},{120,
          56.5},{120,120},{138,120}},  color={255,0,255}));
  connect(chiOne.y1_actual, chiPlaCon.uChiWatReq[1]) annotation (Line(points={{162,
          180},{180,180},{180,240},{-40,240},{-40,197.5},{-30,197.5}}, color={255,
          0,255}));
  connect(chiOne.y1_actual, chiPlaCon.uConWatReq[1]) annotation (Line(points={{162,
          180},{180,180},{180,240},{-40,240},{-40,187.5},{-30,187.5}}, color={255,
          0,255}));
  connect(chiOne.y1_actual, chiPlaCon.uChi[1]) annotation (Line(points={{162,180},
          {180,180},{180,240},{-40,240},{-40,117.5},{-30,117.5}}, color={255,0,255}));
  connect(chiTwo.y1_actual, chiPlaCon.uChiWatReq[2]) annotation (Line(points={{162,
          120},{200,120},{200,250},{-60,250},{-60,202.5},{-30,202.5}}, color={255,
          0,255}));
  connect(chiTwo.y1_actual, chiPlaCon.uConWatReq[2]) annotation (Line(points={{162,
          120},{200,120},{200,250},{-60,250},{-60,192.5},{-30,192.5}}, color={255,
          0,255}));
  connect(chiTwo.y1_actual, chiPlaCon.uChi[2]) annotation (Line(points={{162,120},
          {200,120},{200,250},{-60,250},{-60,122.5},{-30,122.5}}, color={255,0,255}));
  connect(chiPlaCon.yConWatPum, conWatPum.y1) annotation (Line(points={{90,-25},
          {120,-25},{120,0},{138,0}},
                                    color={255,0,255}));
  connect(conWatPum.y1_actual, chiPlaCon.uConWatPum) annotation (Line(points={{162,0},
          {210,0},{210,-230},{-100,-230},{-100,-70},{-30,-70}},    color={255,0,
          255}));
  connect(chiPlaCon.yTowCel, towSta.y1) annotation (Line(points={{90,-110},{100,
          -110},{100,-170},{118,-170}},
                                  color={255,0,255}));
  connect(towSta.y1_actual, chiPlaCon.uTowSta) annotation (Line(points={{142,
          -170},{170,-170},{170,-190},{-50,-190},{-50,-175},{-30,-175}},
                                                                   color={255,0,
          255}));
  connect(plaEna.y, chiPlaCon.uPlaSchEna) annotation (Line(points={{-178,210},{
          -70,210},{-70,-80},{-30,-80}},
                                     color={255,0,255}));
  connect(TConWatRet.y, chiPlaCon.TConWatTowRet) annotation (Line(points={{-198,
          -240},{-134,-240},{-134,-105},{-30,-105}}, color={0,0,127}));
  connect(TConWatRet.y, chiPlaCon.TConWatRet[1]) annotation (Line(points={{-198,
          -240},{-134,-240},{-134,77.5},{-30,77.5}}, color={0,0,127}));
  connect(TConWatRet.y, chiPlaCon.TConWatRet[2]) annotation (Line(points={{-198,
          -240},{-134,-240},{-134,82.5},{-30,82.5}}, color={0,0,127}));
  connect(TChiWatSup.y, chiPlaCon.TChiWatSupChi[1]) annotation (Line(points={{
          -278,10},{-144,10},{-144,67.5},{-30,67.5}}, color={0,0,127}));
  connect(TChiWatSup.y, chiPlaCon.TChiWatSupChi[2]) annotation (Line(points={{
          -278,10},{-144,10},{-144,72.5},{-30,72.5}}, color={0,0,127}));
  connect(chiPlaCon.y1ChiWatIsoVal, booToRea.u) annotation (Line(points={{90,
          -55},{100,-55},{100,-60},{118,-60}}, color={255,0,255}));
  connect(booToRea.y, zerOrdHol2.u)
    annotation (Line(points={{142,-60},{158,-60}}, color={0,0,127}));
annotation (
  experiment(StopTime=10800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Chillers/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates composed chiller plant controller
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Controller</a>. It shows the
process of enabling plant, enabling waterside economizer and staging up one chiller. The plant:
</p>
<ul>
<li>
is less coupled;
</li>
<li>
has waterside economizer and the chilled water flow through the economizer is
controlled using heat exchanger pump;
</li>
<li>
has 2 parallel identical chillers and do not have head pressure control signal;
</li>
<li>
has 2 headed chilled water pumps, 1 remote differential pressure sensor and do
not have local differential pressure sensor hardwired to the plant controller;
</li>
<li>
has 2 headed variable speed condenser water pumps;
</li>
<li>
has cooling tower with 2 cells.
</li>
</ul>
 
<p>
The example shows following process:
</p>
<ul>
<li>
At 15 minutes, the plant becomes enabled in waterside economizer mode. The
economizer is enabled and the heat exchanger pump starts operating
(<code>wseSta.yPumSpe</code> is greater than 0). The condenser water pump becomes
enabled and the number (1) of enabling pumps is specified by the parameter
<code>desConWatPumNum</code> and it starts operating at speed (0.5) specified by
(<code>desConWatPumSpe</code>). The cooling tower cell 1 becomes enabled and its
isolation valve starts open. After 5 minutes (<code>chaTowCelIsoTim</code>) at 20
minutes when the isolation valve is fully open, it turns on the cell 1.
</li>
<li>
At 115 minutes, the plant starts staging up (<code>staSetCon.yUp=true</code>,
<code>upProCon.yStaPro=true</code>) and it stages up chiller 1.
</li>
<li>
In the staging up process, at 127.07 minutes, it increases the condenser water
pump speed (0.6) and increases number (2) of the pump. Also, it starts staging up
cooling tower (<code>upProCon.yTowStaUp=true</code>) at the same moment. At 127.241
minutes, it enables the chiller 1 head pressure control. When the chilled water
isolation valve is fully open at 132.741 minutes, it then turns on chiller 1. The
staging up process is done (<code>upProCon.yStaPro=false</code>).
</li>
</ul>
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
