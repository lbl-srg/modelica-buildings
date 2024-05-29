within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Validation;
model DownWithOnOff
  "Validate sequence of staging down process which requires enabling one chiller and disabling another chiller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Down
    dowProCon(
    final nChi=2,
    final totSta=4,
    final have_ponyChiller=true,
    final need_reduceChillerDemand=true,
    final chaChiWatIsoTim=300,
    final staVec={0,0.5,1,2},
    final desConWatPumSpe={0,0.5,0.75,0.6},
    final desConWatPumNum={0,1,1,2},
    final byPasSetTim=300,
    final minFloSet={0.5,1},
    final maxFloSet={1,1.5})
    "Stage down process when does require chiller on and off"
    annotation (Placement(transformation(extent={{20,60},{40,100}})));

protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    delayTime=1,
    delayOnInit=true)
    "Delay the true input"
    annotation (Placement(transformation(extent={{80,210},{100,230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp chiWatFlo1(
    final height=0.5 - 5/3,
    final duration=300,
    final offset=5/3,
    final startTime=800) "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(final width=0.05, final
      period=1500)     "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,130},{-180,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow1 "Stage down command"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiLoa1(
    final k=2) "Chiller load"
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yOpeParLoaRatMin1(
    final k=0.78)
    "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fulOpe1(final k=1)
    "Full open isolation valve"
    annotation (Placement(transformation(extent={{-200,-260},{-180,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerLoa(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneSta(
    final pre_u_start=false) "Chiller one status"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiOneLoa "Chiller one load"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Reals.Switch IsoValOne "Logical switch"
    annotation (Placement(transformation(extent={{-120,-220},{-100,-200}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol3[2](
    final samplePeriod=fill(10, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-180},{120,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant wseSta1(
    final k=false)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-200,-300},{-180,-280}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol4(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-220},{120,-200}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol5(
    final samplePeriod=20)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-260},{120,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiTwoLoa "Chiller two load"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoSta(
    final pre_u_start=true) "Chiller two status"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer3[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol6(
    final samplePeriod=10) "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiLoa3(final k=1)
    "Chiller load"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiLoa2[2] "Chiller load"
    annotation (Placement(transformation(extent={{140,110},{160,130}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol7(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{180,110},{200,130}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneHea(
    final pre_u_start=false)
    "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoHea(
    final pre_u_start=true)
    "Chiller two head pressure control"
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerOpe2(
    final k=0) "Closed isolation valve"
    annotation (Placement(transformation(extent={{-200,-220},{-180,-200}})));
  Buildings.Controls.OBC.CDL.Reals.Switch IsoValTwo "Logical switch"
    annotation (Placement(transformation(extent={{-120,-260},{-100,-240}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staTwoChi2[2](
    final k={false,true})
    "Vector of chillers status setpoint at stage two"
    annotation (Placement(transformation(extent={{-200,90},{-180,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staOneChi2[2](
    final k={true,false})
    "Vector of chillers status setpoint at stage one"
    annotation (Placement(transformation(extent={{-200,160},{-180,180}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiSet2[2]
    "Chiller status setpoint"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant upSta2(
    final k=2)
    "Stage two"
    annotation (Placement(transformation(extent={{-200,190},{-180,210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dowSta2(
    final k=1)
    "Stage one"
    annotation (Placement(transformation(extent={{-200,230},{-180,250}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger staSet2
    "Stage setpoint index"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant staOne(
    final k=1) "Stage one"
    annotation (Placement(transformation(extent={{-200,-140},{-180,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant staTwo(
    final k=2)
    "Stage two"
    annotation (Placement(transformation(extent={{-200,-180},{-180,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiSta "Current chiller stage"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger sta "Current chiller stage"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(
    final k=false)
    "Logical false"
    annotation (Placement(transformation(extent={{120,180},{140,200}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Check if the down process has ended"
    annotation (Placement(transformation(extent={{120,210},{140,230}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "True when it is not in process"
    annotation (Placement(transformation(extent={{160,210},{180,230}})));

equation
  connect(booPul1.y, staDow1.u)
    annotation (Line(points={{-178,140},{-162,140}}, color={255,0,255}));
  connect(staDow1.y, chiOneLoa.u2)
    annotation (Line(points={{-138,140},{-130,140},{-130,-10},{-122,-10}},
      color={255,0,255}));
  connect(staDow1.y, chiTwoLoa.u2)
    annotation (Line(points={{-138,140},{-130,140},{-130,-50},{-122,-50}},
      color={255,0,255}));
  connect(chiLoa1.y, chiTwoLoa.u3)
    annotation (Line(points={{-178,-50},{-160,-50},{-160,-58},{-122,-58}},
      color={0,0,127}));
  connect(zerLoa.y, chiOneLoa.u3)
    annotation (Line(points={{-178,-10},{-160,-10},{-160,-18},{-122,-18}},
      color={0,0,127}));
  connect(chiLoa3.y, chiLoa2[1].u1)
    annotation (Line(points={{102,160},{120,160},{120,128},{138,128}},
      color={0,0,127}));
  connect(zerOrdHol6.y, chiLoa2[2].u1)
    annotation (Line(points={{102,120},{120,120},{120,128},{138,128}},
      color={0,0,127}));
  connect(zer3.y, chiLoa2.u3)
    annotation (Line(points={{102,90},{120,90},{120,112},{138,112}},
      color={0,0,127}));
  connect(dowProCon.yChiDem[2], zerOrdHol6.u)
    annotation (Line(points={{42,95.5},{60,95.5},{60,120},{78,120}},
      color={0,0,127}));
  connect(dowProCon.yChi[1], chiOneSta.u)
    annotation (Line(points={{42,91.5},{60,91.5},{60,40},{98,40}},
      color={255,0,255}));
  connect(dowProCon.yChi[2], chiTwoSta.u)
    annotation (Line(points={{42,92.5},{62,92.5},{62,0},{98,0}}, color={255,0,255}));
  connect(chiOneSta.y, chiLoa2[1].u2)
    annotation (Line(points={{122,40},{130,40},{130,120},{138,120}},
      color={255,0,255}));
  connect(chiTwoSta.y, chiLoa2[2].u2)
    annotation (Line(points={{122,0},{132,0},{132,120},{138,120}},
      color={255,0,255}));
  connect(chiLoa2[2].y, chiTwoLoa.u1)
    annotation (Line(points={{162,120},{170,120},{170,-70},{-140,-70},{-140,-42},
          {-122,-42}}, color={0,0,127}));
  connect(chiLoa2[1].y, zerOrdHol7.u)
    annotation (Line(points={{162,120},{178,120}}, color={0,0,127}));
  connect(zerOrdHol7.y, chiOneLoa.u1)
    annotation (Line(points={{202,120},{210,120},{210,-30},{-140,-30},{-140,-2},
          {-122,-2}}, color={0,0,127}));
  connect(yOpeParLoaRatMin1.y, dowProCon.yOpeParLoaRatMin)
    annotation (Line(points={{-178,30},{-126,30},{-126,93},{18,93}},
      color={0,0,127}));
  connect(chiOneLoa.y, dowProCon.uChiLoa[1])
    annotation (Line(points={{-98,-10},{-90,-10},{-90,90.5},{18,90.5}},
      color={0,0,127}));
  connect(chiTwoLoa.y, dowProCon.uChiLoa[2])
    annotation (Line(points={{-98,-50},{-88,-50},{-88,91.5},{18,91.5}},
      color={0,0,127}));
  connect(chiOneSta.y, dowProCon.uChi[1])
    annotation (Line(points={{122,40},{130,40},{130,20},{-80,20},{-80,88.5},
      {18,88.5}}, color={255,0,255}));
  connect(chiTwoSta.y, dowProCon.uChi[2])
    annotation (Line(points={{122,0},{132,0},{132,-20},{-78,-20},{-78,89.5},
      {18,89.5}}, color={255,0,255}));
  connect(chiWatFlo1.y, dowProCon.VChiWat_flow)
    annotation (Line(points={{-178,-90},{-76,-90},{-76,87},{18,87}},
      color={0,0,127}));
  connect(dowProCon.yChiHeaCon[1], chiOneHea.u)
    annotation (Line(points={{42,76.5},{58,76.5},{58,-90},{98,-90}},
      color={255,0,255}));
  connect(dowProCon.yChiHeaCon[2], chiTwoHea.u)
    annotation (Line(points={{42,77.5},{56,77.5},{56,-130},{98,-130}},
      color={255,0,255}));
  connect(chiOneHea.y, dowProCon.uChiHeaCon[1])
    annotation (Line(points={{122,-90},{140,-90},{140,-60},{-32,-60},{-32,80.5},
          {18,80.5}}, color={255,0,255}));
  connect(chiTwoHea.y, dowProCon.uChiHeaCon[2])
    annotation (Line(points={{122,-130},{140,-130},{140,-112},{-34,-112},{-34,81.5},
          {18,81.5}}, color={255,0,255}));
  connect(zerOpe2.y, IsoValOne.u3)
    annotation (Line(points={{-178,-210},{-160,-210},{-160,-218},{-122,-218}},
      color={0,0,127}));
  connect(fulOpe1.y, IsoValTwo.u3)
    annotation (Line(points={{-178,-250},{-160,-250},{-160,-258},{-122,-258}},
      color={0,0,127}));
  connect(staDow1.y, IsoValOne.u2)
    annotation (Line(points={{-138,140},{-130,140},{-130,-210},{-122,-210}},
      color={255,0,255}));
  connect(staDow1.y, IsoValTwo.u2)
    annotation (Line(points={{-138,140},{-130,140},{-130,-250},{-122,-250}},
      color={255,0,255}));
  connect(dowProCon.yChiWatIsoVal, zerOrdHol3.u)
    annotation (Line(points={{42,84},{72,84},{72,-170},{98,-170}},
      color={0,0,127}));
  connect(zerOrdHol3[1].y, IsoValOne.u1)
    annotation (Line(points={{122,-170},{140,-170},{140,-190},{-140,-190},
      {-140, -202},{-122,-202}}, color={0,0,127}));
  connect(zerOrdHol3[2].y, IsoValTwo.u1)
    annotation (Line(points={{122,-170},{140,-170},{140,-190},{-140,-190},
      {-140,-242},{-122,-242}}, color={0,0,127}));
  connect(IsoValOne.y, dowProCon.uChiWatIsoVal[1])
    annotation (Line(points={{-98,-210},{-44,-210},{-44,77.5},{18,77.5}},
      color={0,0,127}));
  connect(IsoValTwo.y, dowProCon.uChiWatIsoVal[2])
    annotation (Line(points={{-98,-250},{-42,-250},{-42,78.5},{18,78.5}},
      color={0,0,127}));
  connect(chiOneSta.y, dowProCon.uChiWatReq[1])
    annotation (Line(points={{122,40},{130,40},{130,20},{-30,20},{-30,74.5},
      {18,74.5}}, color={255,0,255}));
  connect(chiTwoSta.y, dowProCon.uChiWatReq[2])
    annotation (Line(points={{122,0},{132,0},{132,-20},{-28,-20},{-28,75.5},
      {18,75.5}}, color={255,0,255}));
  connect(chiOneSta.y, dowProCon.uConWatReq[1])
    annotation (Line(points={{122,40},{130,40},{130,20},{-26,20},{-26,72.5},
      {18,72.5}}, color={255,0,255}));
  connect(chiTwoSta.y, dowProCon.uConWatReq[2])
    annotation (Line(points={{122,0},{132,0},{132,-20},{-24,-20},{-24,73.5},
      {18,73.5}}, color={255,0,255}));
  connect(chiOneSta.y, dowProCon.uChiConIsoVal[1])
    annotation (Line(points={{122,40},{130,40},{130,20},{-22,20},{-22,69.5},
      {18,69.5}}, color={255,0,255}));
  connect(chiTwoSta.y, dowProCon.uChiConIsoVal[2])
    annotation (Line(points={{122,0},{132,0},{132,-20},{-20,-20},{-20,70.5},
      {18,70.5}}, color={255,0,255}));
  connect(wseSta1.y, dowProCon.uWSE)
    annotation (Line(points={{-178,-290},{-10,-290},{-10,67},{18,67}},
      color={255,0,255}));
  connect(dowProCon.yDesConWatPumSpe, zerOrdHol4.u)
    annotation (Line(points={{42,69},{78,69},{78,-210},{98,-210}},
      color={0,0,127}));
  connect(zerOrdHol4.y, zerOrdHol5.u)
    annotation (Line(points={{122,-210},{140,-210},{140,-230},{80,-230},{80,-250},
          {98,-250}}, color={0,0,127}));
  connect(zerOrdHol4.y, dowProCon.uConWatPumSpeSet)
    annotation (Line(points={{122,-210},{140,-210},{140,-230},{-8,-230},{-8,65},
          {18,65}}, color={0,0,127}));
  connect(zerOrdHol5.y, dowProCon.uConWatPumSpe)
    annotation (Line(points={{122,-250},{140,-250},{140,-270},{-6,-270},{-6,63},
          {18,63}}, color={0,0,127}));
  connect(staDow1.y, booRep2.u)
    annotation (Line(points={{-138,140},{-122,140}}, color={255,0,255}));
  connect(staTwoChi2.y, chiSet2.u3) annotation (Line(points={{-178,100},{-90,100},
          {-90,132},{-82,132}}, color={255,0,255}));
  connect(booRep2.y, chiSet2.u2)
    annotation (Line(points={{-98,140},{-82,140}}, color={255,0,255}));
  connect(staOneChi2.y, chiSet2.u1) annotation (Line(points={{-178,170},{-90,170},
          {-90,148},{-82,148}}, color={255,0,255}));
  connect(dowSta2.y, swi2.u1) annotation (Line(points={{-178,240},{-140,240},{-140,
          228},{-122,228}}, color={0,0,127}));
  connect(upSta2.y, swi2.u3) annotation (Line(points={{-178,200},{-140,200},{-140,
          212},{-122,212}}, color={0,0,127}));
  connect(staDow1.y, swi2.u2) annotation (Line(points={{-138,140},{-130,140},{-130,
          220},{-122,220}}, color={255,0,255}));
  connect(swi2.y, staSet2.u)
    annotation (Line(points={{-98,220},{-82,220}}, color={0,0,127}));
  connect(chiSet2.y, dowProCon.uChiSet) annotation (Line(points={{-58,140},{-40,
          140},{-40,97},{18,97}},     color={255,0,255}));
  connect(staSet2.y, dowProCon.uStaSet) annotation (Line(points={{-58,220},{-36,
          220},{-36,99},{18,99}},     color={255,127,0}));
  connect(staOne.y, chiSta.u1) annotation (Line(points={{-178,-130},{-160,-130},
          {-160,-142},{-122,-142}}, color={0,0,127}));
  connect(staTwo.y, chiSta.u3) annotation (Line(points={{-178,-170},{-160,-170},
          {-160,-158},{-122,-158}}, color={0,0,127}));
  connect(chiSta.y, sta.u)
    annotation (Line(points={{-98,-150},{-82,-150}}, color={0,0,127}));
  connect(falEdg.y, lat.u)
    annotation (Line(points={{142,220},{158,220}}, color={255,0,255}));
  connect(fal.y, lat.clr) annotation (Line(points={{142,190},{150,190},{150,214},
          {158,214}}, color={255,0,255}));
  connect(lat.y, chiSta.u2) annotation (Line(points={{182,220},{214,220},{214,-104},
          {-140,-104},{-140,-150},{-122,-150}}, color={255,0,255}));
  connect(sta.y, dowProCon.uChiSta) annotation (Line(points={{-58,-150},{-50,
          -150},{-50,84},{18,84}}, color={255,127,0}));
  connect(dowProCon.yStaPro, truDel.u) annotation (Line(points={{42,99},{50,99},
          {50,220},{78,220}}, color={255,0,255}));
  connect(truDel.y, falEdg.u)
    annotation (Line(points={{102,220},{118,220}}, color={255,0,255}));
annotation (
 experiment(StopTime=1500, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Validation/DownWithOnOff.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Down\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Down</a>.
</p>
<p>
It shows a process of staging down from stage 2 which requires large chiller 2
being enabled to stage 1 which requires small chiller 1 being enabled and chiller
2 being disabled.
</p>
<ul>
<li>
In stage 2, the design condenser water pump speed is 0.6 and it requires 2
condenser water pumps. The maximum and minimum chilled water flow are 1.5 m3/s and
1.0 m3/s.
</li>
<li>
In stage 1, the design condenser water pump speed is 0.75 and it requires 1 condenser
water pump. The maximum and minimum chilled water flow are 1.0 m3/s and 0.5 m3/s.
</li>
</ul>
<p>
It demonstrates process as below:
</p>
<ul>
<li>
Before 75 seconds, the plant is not in the staging process.
</li>
<li>
At 75 seconds, the plant starts staging down from stage 2 to stage 1. The operating
chiller load is reduced from 2 A to 1.56 A (which is lower than 80% of the operating
chiller load). It then slowly increases the minimum chilled water flow setpoint from
1 m3/s to both 1.667 m3/s. The setpoint change takes 300 seconds
(<code>byPasSetTim</code>) and it ends at about 344 seconds.
</li>
<li>
After the new setpoint being achieved, wait 60 seconds (<code>aftByPasSetTim</code>)
to 404 seconds, it enabled chiller 1 head pressure control (<code>yChiHeaCon[1]=true</code>).
</li>
<li>
After 30 seconds (<code>waiTim</code>) to 434 seconds, it starts slowly open the
chiller 1 isolation valve (<code>yChiWatIsoVal[1]</code>). It takes 300 seconds
(<code>chaChiWatIsoTim</code>) to fully open the valve, till 734 seconds.
</li>
<li>
At 734 seconds, the chiller 1 isolation valve is fully open and the chiller becomes
enabled (<code>uChi[1]=true</code>).
</li>
<li>
After 5 minutes (<code>proOnTim</code>) to 1034 seconds, the chiller 2 becomes
disabled (<code>uChi[2]=false</code>, <code>uChiLoa[2]=0</code>).
</li>
<li>
After the chiller 2 being disabled and no request for chilled water flow, it
starts slowly close the isolation valve of chiller 2. At 1334 seconds, the valve
is fully closed.
</li>
<li>
At 1334 seconds, the chiller 2 head pressure control becomes disabled
(<code>yChiHeaCon[2]=false</code>). It also changes the minimum flow setpoint to
the new one for the stage 1, which is 1 m3/s.
</li>
<li>
After the new setpoint being achieved for 60 seconds, to 1394 seconds, the staging
process is done.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
October 2, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-320},{220,320}}),
        graphics={
        Text(
          extent={{-194,276},{-4,260}},
          textColor={0,0,127},
          textString="to stage 1 which only has small chiller enabled (chiller 1)."),
        Text(
          extent={{-194,288},{-6,278}},
          textColor={0,0,127},
          textString="from stage 2 which only has large chiller enabled (chiller 2), "),
        Text(
          extent={{-204,300},{-156,292}},
          textColor={0,0,127},
          textString="Stage down:")}));
end DownWithOnOff;
