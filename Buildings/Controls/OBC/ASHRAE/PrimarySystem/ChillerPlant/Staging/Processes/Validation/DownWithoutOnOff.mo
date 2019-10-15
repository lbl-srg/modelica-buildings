within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Validation;
model DownWithoutOnOff
  "Validate sequence of staging down process which does require chiller ON"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Down
    dowProCon(
    final nChi=2,
    final totChiSta=3,
    final totSta=4,
    final chaChiWatIsoTim=300,
    final staVec={0,0.5,1,2},
    final desConWatPumSpe={0,0.5,0.75,0.6},
    final desConWatPumNum={0,1,1,2},
    final byPasSetTim=300,
    final minFloSet={1,1},
    final maxFloSet={1.5,1.5})
    "Stage down process when does not require chiller on and off"
    annotation (Placement(transformation(extent={{40,100},{60,140}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiWatFlo(
    final height=-1,
    final duration=300,
    final offset=2,
    final startTime=800) "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=2) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.1,
    final period=1500) "Boolean pulse"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow "Stage down command"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLoa[2](
    final k=fill(1000,2)) "Chiller load"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOPLR(
    final k=0.78) "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fulOpe[2](
    final k=fill(1, 2)) "Full open isolation valve"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2[2](
    final pre_u_start=fill(true,2)) "Break algebraic loop"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[2] "Logical switch"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri[2](final k={1,2})
    "Chiller enabling priority"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staTwo(
    final k=2) "Chiller stage two"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staOne(
    final k=1) "Chiller stage one"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiSta "Logical switch"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch IsoVal[2] "Logical switch"
    annotation (Placement(transformation(extent={{-20,-190},{0,-170}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[2](
    final samplePeriod=fill(10, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant wseSta(final k=false)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-140,-230},{-120,-210}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol2(
    final samplePeriod=20)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));

equation
  connect(booPul.y,staDow. u)
    annotation (Line(points={{-118,160},{-102,160}}, color={255,0,255}));
  connect(staDow.y, dowProCon.uStaDow)
    annotation (Line(points={{-78,160},{-70,160},{-70,139},{38,139}},
      color={255,0,255}));
  connect(enaPri.y, dowProCon.uChiPri)
    annotation (Line(points={{-118,110},{-60,110},{-60,137},{38,137}},
      color={255,127,0}));
  connect(minOPLR.y, dowProCon.minOPLR)
    annotation (Line(points={{-118,70},{-58,70},{-58,133.8},{38,133.8}},
      color={0,0,127}));
  connect(dowProCon.yChi, pre2.u)
    annotation (Line(points={{62,132},{94,132},{94,90},{98,90}},
      color={255,0,255}));
  connect(pre2.y, swi1.u2)
    annotation (Line(points={{122,90},{140,90},{140,50},{-80,50},{-80,10},{-62,10}},
      color={255,0,255}));
  connect(chiLoa.y, swi1.u1)
    annotation (Line(points={{-118,30},{-100,30},{-100,18},{-62,18}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{-118,-10},{-100,-10},{-100,2},{-62,2}},
      color={0,0,127}));
  connect(swi1.y, dowProCon.uChiLoa)
    annotation (Line(points={{-38,10},{-30,10},{-30,131.8},{38,131.8}},
      color={0,0,127}));
  connect(pre2.y, dowProCon.uChi)
    annotation (Line(points={{122,90},{140,90},{140,50},{-28,50},{-28,129},{38,129}},
      color={255,0,255}));
  connect(chiWatFlo.y, dowProCon.VChiWat_flow)
    annotation (Line(points={{-118,-50},{-26,-50},{-26,126},{38,126}},
      color={0,0,127}));
  connect(staDow.y, chiSta.u2)
    annotation (Line(points={{-78,160},{-70,160},{-70,-110},{-62,-110}},
      color={255,0,255}));
  connect(staTwo.y, chiSta.u3)
    annotation (Line(points={{-118,-130},{-100,-130},{-100,-118},{-62,-118}},
      color={0,0,127}));
  connect(staOne.y, chiSta.u1)
    annotation (Line(points={{-118,-90},{-100,-90},{-100,-102},{-62,-102}},
      color={0,0,127}));
  connect(chiSta.y, reaToInt1.u)
    annotation (Line(points={{-38,-110},{-22,-110}}, color={0,0,127}));
  connect(reaToInt1.y, dowProCon.uChiSta)
    annotation (Line(points={{2,-110},{10,-110},{10,123},{38,123}},
      color={255,127,0}));
  connect(pre2.y, dowProCon.uChiHeaCon)
    annotation (Line(points={{122,90},{140,90},{140,50},{12,50},{12,120},{38,120}},
      color={255,0,255}));
  connect(staDow.y, booRep.u)
    annotation (Line(points={{-78,160},{-70,160},{-70,-150},{-62,-150}},
      color={255,0,255}));
  connect(booRep.y, IsoVal.u2)
    annotation (Line(points={{-38,-150},{-30,-150},{-30,-180},{-22,-180}},
      color={255,0,255}));
  connect(fulOpe.y, IsoVal.u3)
    annotation (Line(points={{-118,-180},{-100,-180},{-100,-188},{-22,-188}},
      color={0,0,127}));
  connect(dowProCon.yChiWatIsoVal, zerOrdHol.u)
    annotation (Line(points={{62,124},{88,124},{88,20},{98,20}},
      color={0,0,127}));
  connect(zerOrdHol.y, IsoVal.u1)
    annotation (Line(points={{122,20},{150,20},{150,-140},{-26,-140},{-26,-172},
      {-22,-172}}, color={0,0,127}));
  connect(IsoVal.y, dowProCon.uChiWatIsoVal)
    annotation (Line(points={{2,-180},{14,-180},{14,117},{38,117}},
      color={0,0,127}));
  connect(pre2.y, dowProCon.uChiWatReq)
    annotation (Line(points={{122,90},{140,90},{140,50},{16,50},{16,114},{38,114}},
      color={255,0,255}));
  connect(pre2.y, dowProCon.uConWatReq)
    annotation (Line(points={{122,90},{140,90},{140,50},{18,50},{18,112},{38,112}},
      color={255,0,255}));
  connect(pre2.y, dowProCon.uChiConIsoVal)
    annotation (Line(points={{122,90},{140,90},{140,50},{20,50},{20,109},{38,109}},
      color={255,0,255}));
  connect(wseSta.y, dowProCon.uWSE)
    annotation (Line(points={{-118,-220},{22,-220},{22,106},{38,106}},
      color={255,0,255}));
  connect(dowProCon.yDesConWatPumSpe, zerOrdHol1.u)
    annotation (Line(points={{62,109},{80,109},{80,-30},{98,-30}},
      color={0,0,127}));
  connect(zerOrdHol1.y, dowProCon.uConWatPumSpeSet)
    annotation (Line(points={{122,-30},{140,-30},{140,-110},{24,-110},{24,103},
      {38,103}},color={0,0,127}));
  connect(zerOrdHol1.y, zerOrdHol2.u)
    annotation (Line(points={{122,-30},{140,-30},{140,-50},{80,-50},{80,-70},
      {98,-70}},  color={0,0,127}));
  connect(zerOrdHol2.y, dowProCon.uConWatPumSpe)
    annotation (Line(points={{122,-70},{130,-70},{130,-90},{26,-90},{26,101},
      {38,101}}, color={0,0,127}));

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
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-260},{160,260}}),
        graphics={
        Text(
          extent={{-144,238},{-96,230}},
          lineColor={0,0,127},
          textString="Stage down:"),
        Text(
          extent={{-134,226},{26,216}},
          lineColor={0,0,127},
          textString="from stage 2 which has chiller one and two enabled, "),
        Text(
          extent={{-138,214},{-36,200}},
          lineColor={0,0,127},
          textString="to stage 1 which only has chiller 1.")}));
end DownWithoutOnOff;
