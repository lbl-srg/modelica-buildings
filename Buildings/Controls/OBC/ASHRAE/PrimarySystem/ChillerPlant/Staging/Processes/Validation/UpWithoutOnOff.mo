within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Validation;
model UpWithoutOnOff
  "Validate sequence of staging up process which does not require chiller OFF"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Up upProCon(
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
    annotation (Placement(transformation(extent={{40,48},{60,88}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp chiWatFlo(
    final height=1,
    final duration=300,
    final offset=1,
    final startTime=500) "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=2) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,-230},{-40,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.075,
    final period=2000)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp "Stage up command"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiLoa[2](
    final k=fill(2, 2))
    "Chiller load"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant iniChiIsoVal[2](
    final k={1,0}) "Initial chilled water solation valve"
    annotation (Placement(transformation(extent={{-140,-260},{-120,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer1[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiStaRet[2](
    final pre_u_start={true,false}) "Chiller status return value"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1[2] "Logical switch"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch IsoVal[2] "Logical switch"
    annotation (Placement(transformation(extent={{-20,-260},{0,-240}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[2](
    final samplePeriod=fill(10, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant wseSta(final k=false)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol2(
    final samplePeriod=20)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staOneChi[2](
    final k={true,false})
    "Vector of chillers status setpoint at stage one"
    annotation (Placement(transformation(extent={{-140,62},{-120,82}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staTwoChi[2](
    final k={true,true})
    "Vector of chillers status setpoint at stage two"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dowSta(final k=1)
    "Stage one"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant upSta(final k=2)
    "Stage two"
    annotation (Placement(transformation(extent={{-140,210},{-120,230}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{-60,190},{-40,210}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger staSet
    "Stage setpoint index"
    annotation (Placement(transformation(extent={{-20,190},{0,210}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(final nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiSet[2]
    "Chiller status setpoint"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant staOne(final k=1) "Stage one"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant staTwo(final k=2)
    "Stage two"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiSta "Current chiller stage"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger sta "Current chiller stage"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(final k=false)
    "Logical false"
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Check if the up process has ended"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "True when it is not in process"
    annotation (Placement(transformation(extent={{120,130},{140,150}})));

equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-118,110},{-102,110}}, color={255,0,255}));
  connect(chiLoa.y, swi1.u1)
    annotation (Line(points={{-118,40},{-100,40},{-100,28},{-62,28}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{-118,0},{-100,0},{-100,12},{-62,12}},
      color={0,0,127}));
  connect(iniChiIsoVal.y, IsoVal.u3)
    annotation (Line(points={{-118,-250},{-100,-250},{-100,-258},{-22,-258}},
      color={0,0,127}));
  connect(upProCon.yChi, chiStaRet.u) annotation (Line(points={{62,51},{94,51},{
          94,70},{98,70}},  color={255,0,255}));
  connect(chiStaRet.y, swi1.u2) annotation (Line(points={{122,70},{140,70},{140,
          40},{-80,40},{-80,20},{-62,20}}, color={255,0,255}));
  connect(swi1.y, upProCon.uChiLoa) annotation (Line(points={{-38,20},{-30,20},{
          -30,80},{38,80}},   color={0,0,127}));
  connect(chiStaRet.y, upProCon.uChi) annotation (Line(points={{122,70},{140,70},
          {140,40},{-28,40},{-28,78},{38,78}}, color={255,0,255}));
  connect(chiWatFlo.y, upProCon.VChiWat_flow) annotation (Line(points={{-118,-40},
          {-26,-40},{-26,75.6},{38,75.6}}, color={0,0,127}));
  connect(chiStaRet.y, upProCon.uChiConIsoVal) annotation (Line(points={{122,70},
          {140,70},{140,40},{-24,40},{-24,73},{38,73}}, color={255,0,255}));
  connect(chiStaRet.y, upProCon.uConWatReq) annotation (Line(points={{122,70},{
          140,70},{140,40},{12,40},{12,66},{38,66}}, color={255,0,255}));
  connect(wseSta.y, upProCon.uWSE) annotation (Line(points={{-118,-170},{14,
          -170},{14,64},{38,64}}, color={255,0,255}));
  connect(upProCon.yDesConWatPumSpe, zerOrdHol1.u) annotation (Line(points={{62,67},
          {80,67},{80,-60},{98,-60}}, color={0,0,127}));
  connect(zerOrdHol1.y, upProCon.uConWatPumSpeSet) annotation (Line(points={{122,-60},
          {140,-60},{140,-140},{16,-140},{16,62},{38,62}},        color={0,0,127}));
  connect(zerOrdHol1.y, zerOrdHol2.u) annotation (Line(points={{122,-60},{140,-60},
          {140,-90},{80,-90},{80,-110},{98,-110}}, color={0,0,127}));
  connect(zerOrdHol2.y, upProCon.uConWatPumSpe) annotation (Line(points={{122,
          -110},{130,-110},{130,-134},{18,-134},{18,60},{38,60}}, color={0,0,127}));
  connect(chiStaRet.y, upProCon.uChiHeaCon) annotation (Line(points={{122,70},{
          140,70},{140,40},{20,40},{20,53},{38,53}}, color={255,0,255}));
  connect(staUp.y, booRep.u) annotation (Line(points={{-78,110},{-70,110},{-70,-220},
          {-62,-220}}, color={255,0,255}));
  connect(booRep.y, IsoVal.u2) annotation (Line(points={{-38,-220},{-30,-220},{-30,
          -250},{-22,-250}}, color={255,0,255}));
  connect(upProCon.yChiWatIsoVal, zerOrdHol.u) annotation (Line(points={{62,54},
          {88,54},{88,-20},{98,-20}},color={0,0,127}));
  connect(zerOrdHol.y, IsoVal.u1) annotation (Line(points={{122,-20},{150,-20},{
          150,-190},{-80,-190},{-80,-242},{-22,-242}}, color={0,0,127}));
  connect(IsoVal.y, upProCon.uChiWatIsoVal) annotation (Line(points={{2,-250},{22,
          -250},{22,51},{38,51}},   color={0,0,127}));
  connect(chiStaRet.y, upProCon.uChiWatReq) annotation (Line(points={{122,70},{
          140,70},{140,40},{24,40},{24,49},{38,49}}, color={255,0,255}));
  connect(staUp.y, booRep1.u)
    annotation (Line(points={{-78,110},{-62,110}}, color={255,0,255}));
  connect(staOneChi.y, chiSet.u3) annotation (Line(points={{-118,72},{-60,72},{-60,
          90},{-30,90},{-30,102},{-22,102}}, color={255,0,255}));
  connect(booRep1.y, chiSet.u2)
    annotation (Line(points={{-38,110},{-22,110}}, color={255,0,255}));
  connect(staTwoChi.y, chiSet.u1) annotation (Line(points={{-118,150},{-30,150},
          {-30,118},{-22,118}}, color={255,0,255}));
  connect(upSta.y, swi.u1) annotation (Line(points={{-118,220},{-80,220},{-80,208},
          {-62,208}}, color={0,0,127}));
  connect(dowSta.y, swi.u3) annotation (Line(points={{-118,180},{-80,180},{-80,192},
          {-62,192}}, color={0,0,127}));
  connect(staUp.y, swi.u2) annotation (Line(points={{-78,110},{-70,110},{-70,200},
          {-62,200}}, color={255,0,255}));
  connect(swi.y, staSet.u)
    annotation (Line(points={{-38,200},{-22,200}}, color={0,0,127}));
  connect(staSet.y, upProCon.uStaSet) annotation (Line(points={{2,200},{30,200},
          {30,87},{38,87}}, color={255,127,0}));
  connect(chiSet.y, upProCon.uChiSet) annotation (Line(points={{2,110},{20,110},
          {20,84},{38,84}}, color={255,0,255}));
  connect(staTwo.y, chiSta.u1) annotation (Line(points={{-118,-90},{-100,-90},{-100,
          -102},{-62,-102}}, color={0,0,127}));
  connect(staOne.y, chiSta.u3) annotation (Line(points={{-118,-130},{-100,-130},
          {-100,-118},{-62,-118}}, color={0,0,127}));
  connect(chiSta.y, sta.u)
    annotation (Line(points={{-38,-110},{-22,-110}}, color={0,0,127}));
  connect(sta.y, upProCon.uChiSta) annotation (Line(points={{2,-110},{8,-110},{
          8,71},{38,71}}, color={255,127,0}));
  connect(upProCon.yStaPro, falEdg.u) annotation (Line(points={{62,87},{70,87},{
          70,140},{78,140}}, color={255,0,255}));
  connect(falEdg.y, lat.u)
    annotation (Line(points={{102,140},{118,140}}, color={255,0,255}));
  connect(fal.y, lat.clr) annotation (Line(points={{102,110},{110,110},{110,134},
          {118,134}}, color={255,0,255}));
  connect(lat.y, chiSta.u2) annotation (Line(points={{142,140},{150,140},{150,0},
          {-80,0},{-80,-110},{-62,-110}}, color={255,0,255}));
  connect(wseSta.y, upProCon.uEnaPlaConPum) annotation (Line(points={{-118,-170},
          {14,-170},{14,69},{38,69}}, color={255,0,255}));
  connect(wseSta.y, upProCon.uEnaPlaConIso) annotation (Line(points={{-118,-170},
          {14,-170},{14,58},{38,58}}, color={255,0,255}));
annotation (
 experiment(StopTime=2000, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Validation/UpWithoutOnOff.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Up\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Up</a>.
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
After 30 seconds (<code>waiTim) at 870 seconds, it starts slowly open the chilled
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
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-300},{160,300}}),
        graphics={
        Text(
          extent={{-148,290},{-100,282}},
          textColor={0,0,127},
          textString="Stage up:"),
        Text(
          extent={{-138,274},{-8,264}},
          textColor={0,0,127},
          textString="from stage 1 which has chiller 1 enabled, "),
        Text(
          extent={{-136,262},{-10,248}},
          textColor={0,0,127},
          textString="to stage 2 which has chiller 1 and 2 enabled.")}));
end UpWithoutOnOff;
