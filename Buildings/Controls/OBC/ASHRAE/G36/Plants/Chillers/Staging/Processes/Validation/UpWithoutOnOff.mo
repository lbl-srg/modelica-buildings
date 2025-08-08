within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Validation;
model UpWithoutOnOff
  "Validate sequence of staging up process which does not require chiller OFF"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Up upProCon(
    final nChi=2,
    final totSta=4,
    final have_fixSpeConWatPum=false,
    final need_reduceChillerDemand=true,
    final chaChiWatIsoTim=300,
    final staVec={0,0.5,1,2},
    final desConWatPumSpe={0,0.5,0.75,0.6},
    final desConWatPumNum={0,1,1,2},
    final byPasSetTim=300,
    final minFloSet={1,1},
    final maxFloSet={1.5,1.5})
    "Stage up process when does not require chiller off"
    annotation (Placement(transformation(extent={{-20,48},{0,88}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp chiWatFlo(
    final height=1,
    final duration=300,
    final offset=1,
    final startTime=500) "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=2) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-120,-230},{-100,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.075,
    final period=2000)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp "Stage up command"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiLoa(final k=2)
    "Chiller load"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant iniChiIsoVal[2](
    final k={1,0}) "Initial chilled water solation valve"
    annotation (Placement(transformation(extent={{-200,-260},{-180,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer1(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch IsoVal[2] "Logical switch"
    annotation (Placement(transformation(extent={{-80,-260},{-60,-240}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[2](
    final samplePeriod=fill(10, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant wseSta(
    final k=false)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-200,-180},{-180,-160}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol2(
    final samplePeriod=20)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staOneChi[2](
    final k={true,false})
    "Vector of chillers status setpoint at stage one"
    annotation (Placement(transformation(extent={{-200,62},{-180,82}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staTwoChi[2](
    final k={true,true})
    "Vector of chillers status setpoint at stage two"
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dowSta(final k=1)
    "Stage one"
    annotation (Placement(transformation(extent={{-200,170},{-180,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant upSta(final k=2)
    "Stage two"
    annotation (Placement(transformation(extent={{-200,210},{-180,230}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{-120,190},{-100,210}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger staSet
    "Stage setpoint index"
    annotation (Placement(transformation(extent={{-80,190},{-60,210}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(final nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiSet[2]
    "Chiller status setpoint"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant staOne(final k=1) "Stage one"
    annotation (Placement(transformation(extent={{-200,-140},{-180,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant staTwo(final k=2)
    "Stage two"
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiSta "Current chiller stage"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger sta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(final k=false)
    "Logical false"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Check if the up process has ended"
    annotation (Placement(transformation(extent={{20,170},{40,190}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "True when it is not in process"
    annotation (Placement(transformation(extent={{60,170},{80,190}})));
  Buildings.Templates.Components.Controls.StatusEmulator chiTwoSta(
    final delayTime=0)
    "Chiller two status"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=true)
    "Constant true"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=1,
    final delayOnInit=true)
    "Check if it has passed initial time"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiOneSta
    "Chiller one status"
    annotation (Placement(transformation(extent={{140,30},{160,50}})));
  Buildings.Templates.Components.Controls.StatusEmulator chiOneSta1(
    final delayTime=0)
    "Chiller one status"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if there is any enabled chiller"
    annotation (Placement(transformation(extent={{140,110},{160,130}})));
equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-178,110},{-162,110}}, color={255,0,255}));
  connect(chiLoa.y, swi1.u1)
    annotation (Line(points={{-178,40},{-160,40},{-160,28},{-122,28}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{-178,0},{-160,0},{-160,12},{-122,12}},
      color={0,0,127}));
  connect(iniChiIsoVal.y, IsoVal.u3)
    annotation (Line(points={{-178,-250},{-160,-250},{-160,-258},{-82,-258}},
      color={0,0,127}));
  connect(swi1.y, upProCon.uChiLoa) annotation (Line(points={{-98,20},{-90,20},{
          -90,80},{-22,80}},  color={0,0,127}));
  connect(chiWatFlo.y, upProCon.VChiWat_flow) annotation (Line(points={{-178,-40},
          {-86,-40},{-86,75.6},{-22,75.6}},color={0,0,127}));
  connect(wseSta.y, upProCon.uWSE) annotation (Line(points={{-178,-170},{-46,-170},
          {-46,64},{-22,64}}, color={255,0,255}));
  connect(upProCon.yDesConWatPumSpe, zerOrdHol1.u) annotation (Line(points={{2,67},{
          20,67},{20,-60},{38,-60}},  color={0,0,127}));
  connect(zerOrdHol1.y, upProCon.uConWatPumSpeSet) annotation (Line(points={{62,-60},
          {80,-60},{80,-140},{-44,-140},{-44,62},{-22,62}},       color={0,0,127}));
  connect(zerOrdHol1.y, zerOrdHol2.u) annotation (Line(points={{62,-60},{80,-60},
          {80,-90},{20,-90},{20,-110},{38,-110}},  color={0,0,127}));
  connect(zerOrdHol2.y, upProCon.uConWatPumSpe) annotation (Line(points={{62,-110},
          {70,-110},{70,-134},{-42,-134},{-42,60},{-22,60}}, color={0,0,127}));
  connect(staUp.y, booRep.u) annotation (Line(points={{-138,110},{-130,110},{-130,
          -220},{-122,-220}}, color={255,0,255}));
  connect(booRep.y, IsoVal.u2) annotation (Line(points={{-98,-220},{-90,-220},{-90,
          -250},{-82,-250}}, color={255,0,255}));
  connect(upProCon.yChiWatIsoVal, zerOrdHol.u) annotation (Line(points={{2,54},{
          28,54},{28,-30},{38,-30}}, color={0,0,127}));
  connect(zerOrdHol.y, IsoVal.u1) annotation (Line(points={{62,-30},{90,-30},{90,
          -190},{-140,-190},{-140,-242},{-82,-242}},   color={0,0,127}));
  connect(IsoVal.y, upProCon.uChiWatIsoVal) annotation (Line(points={{-58,-250},
          {-38,-250},{-38,51},{-22,51}}, color={0,0,127}));
  connect(staUp.y, booRep1.u)
    annotation (Line(points={{-138,110},{-122,110}}, color={255,0,255}));
  connect(staOneChi.y, chiSet.u3) annotation (Line(points={{-178,72},{-120,72},{
          -120,90},{-90,90},{-90,102},{-82,102}}, color={255,0,255}));
  connect(booRep1.y, chiSet.u2)
    annotation (Line(points={{-98,110},{-82,110}}, color={255,0,255}));
  connect(staTwoChi.y, chiSet.u1) annotation (Line(points={{-178,150},{-90,150},
          {-90,118},{-82,118}}, color={255,0,255}));
  connect(upSta.y, swi.u1) annotation (Line(points={{-178,220},{-140,220},{-140,
          208},{-122,208}}, color={0,0,127}));
  connect(dowSta.y, swi.u3) annotation (Line(points={{-178,180},{-140,180},{-140,
          192},{-122,192}}, color={0,0,127}));
  connect(staUp.y, swi.u2) annotation (Line(points={{-138,110},{-130,110},{-130,
          200},{-122,200}}, color={255,0,255}));
  connect(swi.y, staSet.u)
    annotation (Line(points={{-98,200},{-82,200}}, color={0,0,127}));
  connect(staSet.y, upProCon.uStaSet) annotation (Line(points={{-58,200},{-30,200},
          {-30,87},{-22,87}}, color={255,127,0}));
  connect(chiSet.y, upProCon.uChiSet) annotation (Line(points={{-58,110},{-40,110},
          {-40,84},{-22,84}}, color={255,0,255}));
  connect(staTwo.y, chiSta.u1) annotation (Line(points={{-178,-90},{-160,-90},{-160,
          -102},{-122,-102}},color={0,0,127}));
  connect(staOne.y, chiSta.u3) annotation (Line(points={{-178,-130},{-160,-130},
          {-160,-118},{-122,-118}},color={0,0,127}));
  connect(chiSta.y, sta.u)
    annotation (Line(points={{-98,-110},{-82,-110}}, color={0,0,127}));
  connect(sta.y, upProCon.uChiSta) annotation (Line(points={{-58,-110},{-52,-110},
          {-52,71},{-22,71}}, color={255,127,0}));
  connect(upProCon.yStaPro, falEdg.u) annotation (Line(points={{2,87},{10,87},{10,
          180},{18,180}}, color={255,0,255}));
  connect(falEdg.y, lat.u)
    annotation (Line(points={{42,180},{58,180}}, color={255,0,255}));
  connect(fal.y, lat.clr) annotation (Line(points={{42,150},{50,150},{50,174},{58,
          174}}, color={255,0,255}));
  connect(lat.y, chiSta.u2) annotation (Line(points={{82,180},{90,180},{90,-80},
          {-140,-80},{-140,-110},{-122,-110}}, color={255,0,255}));
  connect(wseSta.y, upProCon.uEnaPlaConPum) annotation (Line(points={{-178,-170},
          {-46,-170},{-46,69},{-22,69}}, color={255,0,255}));
  connect(wseSta.y, upProCon.uEnaPlaConIso) annotation (Line(points={{-178,-170},
          {-46,-170},{-46,58},{-22,58}}, color={255,0,255}));
  connect(con2.y, truDel.u) annotation (Line(points={{62,20},{80,20},{80,40},{98,
          40}}, color={255,0,255}));
  connect(con2.y, chiOneSta.u3) annotation (Line(points={{62,20},{130,20},{130,32},
          {138,32}}, color={255,0,255}));
  connect(truDel.y, chiOneSta.u2)
    annotation (Line(points={{122,40},{138,40}}, color={255,0,255}));
  connect(upProCon.yChi[2], chiTwoSta.y1) annotation (Line(points={{2,51.5},{32,
          51.5},{32,120},{38,120}}, color={255,0,255}));
  connect(chiOneSta.y, upProCon.uChi[1]) annotation (Line(points={{162,40},{170,
          40},{170,0},{-56,0},{-56,77.5},{-22,77.5}}, color={255,0,255}));
  connect(chiTwoSta.y1_actual, upProCon.uChi[2]) annotation (Line(points={{62,120},
          {70,120},{70,0},{-56,0},{-56,78.5},{-22,78.5}}, color={255,0,255}));
  connect(chiOneSta.y, upProCon.uChiConIsoVal[1]) annotation (Line(points={{162,
          40},{170,40},{170,0},{-54,0},{-54,72.5},{-22,72.5}}, color={255,0,255}));
  connect(chiTwoSta.y1_actual, upProCon.uChiConIsoVal[2]) annotation (Line(
        points={{62,120},{70,120},{70,0},{-54,0},{-54,73.5},{-22,73.5}}, color={
          255,0,255}));
  connect(chiOneSta.y, upProCon.uConWatReq[1]) annotation (Line(points={{162,40},
          {170,40},{170,0},{-50,0},{-50,65.5},{-22,65.5}}, color={255,0,255}));
  connect(chiTwoSta.y1_actual, upProCon.uConWatReq[2]) annotation (Line(points={
          {62,120},{70,120},{70,0},{-50,0},{-50,66.5},{-22,66.5}}, color={255,0,
          255}));
  connect(chiOneSta.y, upProCon.uChiHeaCon[1]) annotation (Line(points={{162,40},
          {170,40},{170,0},{-48,0},{-48,52.5},{-22,52.5}}, color={255,0,255}));
  connect(chiTwoSta.y1_actual, upProCon.uChiHeaCon[2]) annotation (Line(points={
          {62,120},{70,120},{70,0},{-48,0},{-48,53.5},{-22,53.5}}, color={255,0,
          255}));
  connect(chiOneSta.y, upProCon.uChiWatReq[1]) annotation (Line(points={{162,40},
          {170,40},{170,0},{-36,0},{-36,48.5},{-22,48.5}}, color={255,0,255}));
  connect(chiTwoSta.y1_actual, upProCon.uChiWatReq[2]) annotation (Line(points={
          {62,120},{70,120},{70,0},{-36,0},{-36,49.5},{-22,49.5}}, color={255,0,
          255}));
  connect(upProCon.yChi[1], chiOneSta1.y1) annotation (Line(points={{2,50.5},{
          32,50.5},{32,80},{38,80}}, color={255,0,255}));
  connect(chiOneSta1.y1_actual, chiOneSta.u1) annotation (Line(points={{62,80},
          {130,80},{130,48},{138,48}}, color={255,0,255}));
  connect(chiTwoSta.y1_actual, or2.u1)
    annotation (Line(points={{62,120},{138,120}}, color={255,0,255}));
  connect(chiOneSta.y, or2.u2) annotation (Line(points={{162,40},{170,40},{170,100},
          {132,100},{132,112},{138,112}}, color={255,0,255}));
  connect(or2.y, swi1.u2) annotation (Line(points={{162,120},{180,120},{180,-10},
          {-140,-10},{-140,20},{-122,20}}, color={255,0,255}));
annotation (
 experiment(StopTime=2000, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Chillers/Staging/Processes/Validation/UpWithoutOnOff.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Up\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Up</a>.
</p>
<p>
It shows a process of staging up from stage 1 which requires only chiller 1 being
enabled, to stage 2 which requires both chiller 1 and 2 being enabled. In stage 1
and 2, the required minimum chilled water flow setpoints are 1.0 m3/s and 2.0 m3/s
respectively. The process are below:
</p>
<ul>
<li>
Before 150 seconds, the plant is not in the staging process.
</li>
<li>
At 150 seconds, the plant starts staging up (<code>yStaPro=true</code>). The
operating chiller load is reduced from 2 A to 1.5 A (which is lower than 80% of
the operating chiller load).
</li>
<li>
After 300 seconds (<code>byPasSetTim</code>) to 450 seconds, the minimum chilled
water flow setpoint slowly increase from 1.0 m3/s to 2.0 m3/s which is for the case
when both chiller 1 and 2 are operating. The setpoint is achieved at 750 seconds.
</li>
<li>
Wait 60 seconds (<code>aftByPasSetTim</code>) to allow the loop being stable,
enabling the head pressure control of chiller 2 (<code>yChiHeaCon[2]=true</code>)
at 840 seconds.
</li>
<li>
After 30 seconds (<code>waiTim</code>) at 870 seconds, it starts slowly open the chilled
water isolation valve of chiller 2 (<code>yChiWatIsoVal[2]</code>). After 300
seconds (<code>chaChiWatIsoTim</code>) at 1170 seconds, the valve is fully open.
</li>
<li>
At 1170 seconds, the chiller 2 becomes enabled. The chiller load demand is released.
The staging process is done (<code>yStaPro=false</code>).
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
May 31, 2024, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-300},{200,300}}),
        graphics={
        Text(
          extent={{-208,290},{-160,282}},
          textColor={0,0,127},
          textString="Stage up:"),
        Text(
          extent={{-198,274},{-68,264}},
          textColor={0,0,127},
          textString="from stage 1 which has chiller 1 enabled, "),
        Text(
          extent={{-196,262},{-70,248}},
          textColor={0,0,127},
          textString="to stage 2 which has chiller 1 and 2 enabled.")}));
end UpWithoutOnOff;
