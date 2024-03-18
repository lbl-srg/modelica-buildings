within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Validation;
model DownWithoutOnOff
  "Validate sequence of staging down process which does require chiller ON"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Down
    dowProCon(
    final nChi=2,
    final totSta=4,
    final need_reduceChillerDemand=true,
    final chaChiWatIsoTim=300,
    final staVec={0,0.5,1,2},
    final desConWatPumSpe={0,0.5,0.75,0.6},
    final desConWatPumNum={0,1,1,2},
    final byPasSetTim=300,
    final minFloSet={1,1},
    final maxFloSet={1.5,1.5})
    "Stage down process when does not require chiller on and off"
    annotation (Placement(transformation(extent={{40,50},{60,90}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp chiWatFlo(
    final height=-1,
    final duration=300,
    final offset=2,
    final startTime=800) "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=2) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,-210},{-40,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.075,
    final period=1500) "Boolean pulse"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow "Stage down command"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiLoa[2](
    final k=fill(2, 2))
    "Chiller load"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yOpeParLoaRatMin(
    final k=0.78) "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fulOpe[2](
    final k=fill(1, 2)) "Full open isolation valve"
    annotation (Placement(transformation(extent={{-140,-240},{-120,-220}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer1[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2[2](
    final pre_u_start=fill(true,2)) "Break algebraic loop"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1[2] "Logical switch"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch IsoVal[2] "Logical switch"
    annotation (Placement(transformation(extent={{-20,-240},{0,-220}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[2](
    final samplePeriod=fill(10, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant wseSta(final k=false)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-140,-280},{-120,-260}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol2(
    final samplePeriod=20)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-130},{120,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staTwoChi2[2](final k={
        true,true})
    "Vector of chillers status setpoint at stage two"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staOneChi2[2](
    final k={true,false})
    "Vector of chillers status setpoint at stage one"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(final nout=2)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiSet2[2]
    "Chiller status setpoint"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger staSet2
    "Stage setpoint index"
    annotation (Placement(transformation(extent={{-20,200},{0,220}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant upSta2(final k=2)
    "Stage two"
    annotation (Placement(transformation(extent={{-140,180},{-120,200}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dowSta2(final k=1)
    "Stage one"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant staOne(final k=1) "Stage one"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant staTwo(final k=2)
    "Stage two"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiSta "Current chiller stage"
    annotation (Placement(transformation(extent={{-60,-170},{-40,-150}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger sta "Current chiller stage"
    annotation (Placement(transformation(extent={{-20,-170},{0,-150}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Check if the down process has ended"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(final k=false)
    "Logical false"
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "True when it is not in process"
    annotation (Placement(transformation(extent={{120,130},{140,150}})));

equation
  connect(booPul.y,staDow. u)
    annotation (Line(points={{-118,130},{-102,130}}, color={255,0,255}));
  connect(yOpeParLoaRatMin.y, dowProCon.yOpeParLoaRatMin)
    annotation (Line(points={{-118,20},{-58,20},{-58,84},{38,84}},
      color={0,0,127}));
  connect(dowProCon.yChi, pre2.u)
    annotation (Line(points={{62,82},{94,82},{94,40},{98,40}},
      color={255,0,255}));
  connect(pre2.y, swi1.u2)
    annotation (Line(points={{122,40},{140,40},{140,0},{-80,0},{-80,-40},{-62,-40}},
      color={255,0,255}));
  connect(chiLoa.y, swi1.u1)
    annotation (Line(points={{-118,-20},{-100,-20},{-100,-32},{-62,-32}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{-118,-60},{-100,-60},{-100,-48},{-62,-48}},
      color={0,0,127}));
  connect(swi1.y, dowProCon.uChiLoa)
    annotation (Line(points={{-38,-40},{-30,-40},{-30,82},{38,82}},
      color={0,0,127}));
  connect(pre2.y, dowProCon.uChi)
    annotation (Line(points={{122,40},{140,40},{140,0},{-28,0},{-28,79},{38,79}},
      color={255,0,255}));
  connect(chiWatFlo.y, dowProCon.VChiWat_flow)
    annotation (Line(points={{-118,-100},{-26,-100},{-26,77},{38,77}},
      color={0,0,127}));
  connect(pre2.y, dowProCon.uChiHeaCon)
    annotation (Line(points={{122,40},{140,40},{140,0},{12,0},{12,71},{38,71}},
      color={255,0,255}));
  connect(staDow.y, booRep.u)
    annotation (Line(points={{-78,130},{-70,130},{-70,-200},{-62,-200}},
      color={255,0,255}));
  connect(booRep.y, IsoVal.u2)
    annotation (Line(points={{-38,-200},{-30,-200},{-30,-230},{-22,-230}},
      color={255,0,255}));
  connect(fulOpe.y, IsoVal.u3)
    annotation (Line(points={{-118,-230},{-100,-230},{-100,-238},{-22,-238}},
      color={0,0,127}));
  connect(dowProCon.yChiWatIsoVal, zerOrdHol.u)
    annotation (Line(points={{62,74},{88,74},{88,-30},{98,-30}},
      color={0,0,127}));
  connect(zerOrdHol.y, IsoVal.u1)
    annotation (Line(points={{122,-30},{150,-30},{150,-190},{-26,-190},{-26,-222},
          {-22,-222}}, color={0,0,127}));
  connect(IsoVal.y, dowProCon.uChiWatIsoVal)
    annotation (Line(points={{2,-230},{14,-230},{14,68},{38,68}},
      color={0,0,127}));
  connect(pre2.y, dowProCon.uChiWatReq)
    annotation (Line(points={{122,40},{140,40},{140,0},{16,0},{16,65},{38,65}},
      color={255,0,255}));
  connect(pre2.y, dowProCon.uConWatReq)
    annotation (Line(points={{122,40},{140,40},{140,0},{18,0},{18,63},{38,63}},
      color={255,0,255}));
  connect(pre2.y, dowProCon.uChiConIsoVal)
    annotation (Line(points={{122,40},{140,40},{140,0},{20,0},{20,60},{38,60}},
      color={255,0,255}));
  connect(wseSta.y, dowProCon.uWSE)
    annotation (Line(points={{-118,-270},{22,-270},{22,57},{38,57}},
      color={255,0,255}));
  connect(dowProCon.yDesConWatPumSpe, zerOrdHol1.u)
    annotation (Line(points={{62,59},{80,59},{80,-80},{98,-80}},
      color={0,0,127}));
  connect(zerOrdHol1.y, dowProCon.uConWatPumSpeSet)
    annotation (Line(points={{122,-80},{140,-80},{140,-160},{24,-160},{24,55},{
          38,55}},
                color={0,0,127}));
  connect(zerOrdHol1.y, zerOrdHol2.u)
    annotation (Line(points={{122,-80},{140,-80},{140,-100},{80,-100},{80,-120},
          {98,-120}}, color={0,0,127}));
  connect(zerOrdHol2.y, dowProCon.uConWatPumSpe)
    annotation (Line(points={{122,-120},{130,-120},{130,-140},{26,-140},{26,53},
          {38,53}}, color={0,0,127}));
  connect(staDow.y, booRep2.u)
    annotation (Line(points={{-78,130},{-62,130}}, color={255,0,255}));
  connect(staTwoChi2.y, chiSet2.u3) annotation (Line(points={{-118,100},{-30,100},
          {-30,122},{-22,122}}, color={255,0,255}));
  connect(booRep2.y, chiSet2.u2)
    annotation (Line(points={{-38,130},{-22,130}}, color={255,0,255}));
  connect(staOneChi2.y, chiSet2.u1) annotation (Line(points={{-118,160},{-30,160},
          {-30,138},{-22,138}}, color={255,0,255}));
  connect(upSta2.y, swi2.u3) annotation (Line(points={{-118,190},{-100,190},{-100,
          202},{-62,202}}, color={0,0,127}));
  connect(dowSta2.y, swi2.u1) annotation (Line(points={{-118,230},{-100,230},{-100,
          218},{-62,218}}, color={0,0,127}));
  connect(swi2.y, staSet2.u)
    annotation (Line(points={{-38,210},{-22,210}}, color={0,0,127}));
  connect(staDow.y, swi2.u2) annotation (Line(points={{-78,130},{-70,130},{-70,210},
          {-62,210}}, color={255,0,255}));
  connect(chiSet2.y, dowProCon.uChiSet) annotation (Line(points={{2,130},{12,
          130},{12,87},{38,87}},  color={255,0,255}));
  connect(staSet2.y, dowProCon.uStaSet) annotation (Line(points={{2,210},{20,
          210},{20,89},{38,89}},  color={255,127,0}));
  connect(staOne.y, chiSta.u1) annotation (Line(points={{-118,-140},{-100,-140},
          {-100,-152},{-62,-152}}, color={0,0,127}));
  connect(staTwo.y, chiSta.u3) annotation (Line(points={{-118,-180},{-100,-180},
          {-100,-168},{-62,-168}}, color={0,0,127}));
  connect(chiSta.y, sta.u)
    annotation (Line(points={{-38,-160},{-22,-160}}, color={0,0,127}));
  connect(dowProCon.yStaPro, falEdg.u) annotation (Line(points={{62,89},{70,89},
          {70,140},{78,140}}, color={255,0,255}));
  connect(falEdg.y, lat.u)
    annotation (Line(points={{102,140},{118,140}}, color={255,0,255}));
  connect(fal.y, lat.clr) annotation (Line(points={{102,110},{110,110},{110,134},
          {118,134}}, color={255,0,255}));
  connect(lat.y, chiSta.u2) annotation (Line(points={{142,140},{154,140},{154,-180},
          {-80,-180},{-80,-160},{-62,-160}}, color={255,0,255}));
  connect(sta.y, dowProCon.uChiSta) annotation (Line(points={{2,-160},{10,-160},
          {10,74},{38,74}}, color={255,127,0}));

annotation (
 experiment(StopTime=1500, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Validation/DownWithoutOnOff.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Down\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Down</a>.
</p>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-300},{160,300}}),
        graphics={
        Text(
          extent={{-144,294},{-96,286}},
          textColor={0,0,127},
          textString="Stage down:"),
        Text(
          extent={{-134,282},{26,272}},
          textColor={0,0,127},
          textString="from stage 2 which has chiller one and two enabled, "),
        Text(
          extent={{-138,270},{-36,256}},
          textColor={0,0,127},
          textString="to stage 1 which only has chiller 1.")}));
end DownWithoutOnOff;
