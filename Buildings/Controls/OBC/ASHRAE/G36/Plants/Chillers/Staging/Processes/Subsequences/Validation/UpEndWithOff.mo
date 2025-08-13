within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.Validation;
model UpEndWithOff
  "Validate sequence of end staging up process which requires chiller OFF"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.UpEnd
    endUp1(
    final nChi=2,
    final chaChiWatIsoTim=300,
    final byPasSetTim=300,
    final minFloSet={0.5,1},
    final maxFloSet={1,1.5})
    "End staging up process which does require one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{0,150},{20,170}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant nexEnaChi1(final k=2)
    "Next enable chiller"
    annotation (Placement(transformation(extent={{-240,170},{-220,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer1(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-240,130},{-220,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    final width=0.4,
    final period=2500)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-240,80},{-220,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp1 "Stage up command"
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not upStrDev1 "Upstream device status"
    annotation (Placement(transformation(extent={{-200,40},{-180,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4(
    final width=0.45,
    final period=2500)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-240,40},{-220,60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3 "Logical switch"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer4(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-240,-40},{-220,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant nexDisChi2(final k=1)
    "Next disable chiller"
    annotation (Placement(transformation(extent={{-240,0},{-220,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fulOpe(final k=1)
    "Full open"
    annotation (Placement(transformation(extent={{-240,-80},{-220,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chiIsoVal1
    "Chilled water isolation valve one"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1[2](
    final samplePeriod=fill(10, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant enaHeaCon(final k=true)
    "Enable head pressure control"
    annotation (Placement(transformation(extent={{-240,-170},{-220,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiOneHeaCon
    "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneHea1(final pre_u_start=true)
    "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatFlo1(final k=1)
    "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-240,-210},{-220,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatFlo2(final k=1.667)
    "Minimum chilled water flow setpoint calculated from upstream process"
    annotation (Placement(transformation(extent={{-240,-250},{-220,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Staging up"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Templates.Components.Controls.StatusEmulator chiTwoSta(
    final delayTime=0)
    "Chiller two status"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=true)
    "Constant true"
    annotation (Placement(transformation(extent={{80,160},{100,180}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=1,
    final delayOnInit=true)
    "Check if it has passed initial time"
    annotation (Placement(transformation(extent={{140,210},{160,230}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiOneSta
    "Chiller one status"
    annotation (Placement(transformation(extent={{180,210},{200,230}})));
  Buildings.Templates.Components.Controls.StatusEmulator chiOneSta1(
    final delayTime=0)
    "Chiller one status"
    annotation (Placement(transformation(extent={{80,230},{100,250}})));
equation
  connect(booPul3.y, staUp1.u)
    annotation (Line(points={{-218,90},{-202,90}}, color={255,0,255}));
  connect(booPul4.y, upStrDev1.u)
    annotation (Line(points={{-218,50},{-202,50}}, color={255,0,255}));
  connect(nexEnaChi1.y, swi1.u1)
    annotation (Line(points={{-218,180},{-200,180},{-200,168},{-162,168}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{-218,140},{-200,140},{-200,152},{-162,152}},
      color={0,0,127}));
  connect(swi1.y, reaToInt1.u)
    annotation (Line(points={{-138,160},{-122,160}}, color={0,0,127}));
  connect(staUp1.y, swi1.u2)
    annotation (Line(points={{-178,90},{-170,90},{-170,160},{-162,160}},
      color={255,0,255}));
  connect(reaToInt1.y, endUp1.nexEnaChi)
    annotation (Line(points={{-98,160},{-80,160},{-80,172},{-2,172}},
      color={255,127,0}));
  connect(upStrDev1.y, endUp1.uEnaChiWatIsoVal)
    annotation (Line(points={{-178,50},{-72,50},{-72,168},{-2,168}},
      color={255,0,255}));
  connect(staUp1.y, endUp1.uOnOff)
    annotation (Line(points={{-178,90},{-60,90},{-60,164},{-2,164}},
      color={255,0,255}));
  connect(nexDisChi2.y, swi3.u1)
    annotation (Line(points={{-218,10},{-200,10},{-200,-2},{-162,-2}},
      color={0,0,127}));
  connect(zer4.y, swi3.u3)
    annotation (Line(points={{-218,-30},{-200,-30},{-200,-18},{-162,-18}},
      color={0,0,127}));
  connect(staUp1.y, swi3.u2)
    annotation (Line(points={{-178,90},{-170,90},{-170,-10},{-162,-10}},
      color={255,0,255}));
  connect(swi3.y, reaToInt2.u)
    annotation (Line(points={{-138,-10},{-122,-10}}, color={0,0,127}));
  connect(reaToInt2.y, endUp1.nexDisChi)
    annotation (Line(points={{-98,-10},{-56,-10},{-56,162},{-2,162}},
      color={255,127,0}));
  connect(fulOpe.y, chiIsoVal1.u3)
    annotation (Line(points={{-218,-70},{-200,-70},{-200,-78},{-162,-78}},
      color={0,0,127}));
  connect(staUp1.y, chiIsoVal1.u2)
    annotation (Line(points={{-178,90},{-170,90},{-170,-70},{-162,-70}},
      color={255,0,255}));
  connect(endUp1.yChiWatIsoVal, zerOrdHol1.u)
    annotation (Line(points={{22,165},{64,165},{64,-10},{78,-10}},
      color={0,0,127}));
  connect(zerOrdHol1[1].y, chiIsoVal1.u1)
    annotation (Line(points={{102,-10},{106,-10},{106,-40},{-180,-40},{-180,-62},
          {-162,-62}}, color={0,0,127}));
  connect(chiIsoVal1.y, endUp1.uChiWatIsoVal[1])
    annotation (Line(points={{-138,-70},{-44,-70},{-44,157.5},{-2,157.5}},
      color={0,0,127}));
  connect(enaHeaCon.y, chiOneHeaCon.u3)
    annotation (Line(points={{-218,-160},{-200,-160},{-200,-168},{-162,-168}},
      color={255,0,255}));
  connect(staUp1.y, chiOneHeaCon.u2)
    annotation (Line(points={{-178,90},{-170,90},{-170,-160},{-162,-160}},
      color={255,0,255}));
  connect(endUp1.yChiHeaCon[1], chiOneHea1.u)
    annotation (Line(points={{22,160.5},{60,160.5},{60,-120},{78,-120}},
      color={255,0,255}));
  connect(chiOneHea1.y, chiOneHeaCon.u1)
    annotation (Line(points={{102,-120},{110,-120},{110,-140},{-180,-140},{-180,
          -152},{-162,-152}},   color={255,0,255}));
  connect(chiOneHeaCon.y, endUp1.uChiHeaCon[1])
    annotation (Line(points={{-138,-160},{-28,-160},{-28,153.5},{-2,153.5}},
      color={255,0,255}));
  connect(chiWatFlo1.y, endUp1.VChiWat_flow)
    annotation (Line(points={{-218,-200},{-20,-200},{-20,152},{-2,152}},
      color={0,0,127}));
  connect(fulOpe.y, endUp1.uChiWatIsoVal[2])
    annotation (Line(points={{-218,-70},{-200,-70},{-200,-100},{-40,-100},{-40,158.5},
          {-2,158.5}}, color={0,0,127}));
  connect(enaHeaCon.y, endUp1.uChiHeaCon[2])
    annotation (Line(points={{-218,-160},{-200,-160},{-200,-180},{-24,-180},{-24,
          154.5},{-2,154.5}}, color={255,0,255}));
  connect(chiWatFlo2.y, endUp1.VMinChiWat_setpoint)
    annotation (Line(points={{-218,-240},{-16,-240},{-16,150},{-2,150}}, color={0,0,127}));
  connect(staUp1.y, lat.u) annotation (Line(points={{-178,90},{-170,90},{-170,120},
          {-122,120}},color={255,0,255}));
  connect(endUp1.endStaTri, lat.clr) annotation (Line(points={{22,151},{40,151},
          {40,80},{-140,80},{-140,114},{-122,114}}, color={255,0,255}));
  connect(lat.y, endUp1.uStaUp) annotation (Line(points={{-98,120},{-76,120},{-76,
          170},{-2,170}}, color={255,0,255}));
  connect(endUp1.yChi[2], chiTwoSta.y1) annotation (Line(points={{22,169.5},{70,
          169.5},{70,90},{78,90}}, color={255,0,255}));
  connect(chiTwoSta.y1_actual, endUp1.uChi[2]) annotation (Line(points={{102,90},
          {110,90},{110,60},{-68,60},{-68,166.5},{-2,166.5}}, color={255,0,255}));
  connect(chiTwoSta.y1_actual, endUp1.uChiWatReq[2]) annotation (Line(points={{102,
          90},{110,90},{110,60},{-52,60},{-52,160.5},{-2,160.5}}, color={255,0,255}));
  connect(con2.y, chiOneSta.u3) annotation (Line(points={{102,170},{170,170},{170,
          212},{178,212}}, color={255,0,255}));
  connect(truDel.y, chiOneSta.u2)
    annotation (Line(points={{162,220},{178,220}}, color={255,0,255}));
  connect(con2.y, truDel.u) annotation (Line(points={{102,170},{120,170},{120,220},
          {138,220}}, color={255,0,255}));
  connect(chiOneSta.y, endUp1.uChi[1]) annotation (Line(points={{202,220},{210,220},
          {210,50},{-64,50},{-64,165.5},{-2,165.5}}, color={255,0,255}));
  connect(chiOneSta.y, endUp1.uChiWatReq[1]) annotation (Line(points={{202,220},
          {210,220},{210,50},{-48,50},{-48,159.5},{-2,159.5}}, color={255,0,255}));
  connect(chiOneSta.y, endUp1.uConWatReq[1]) annotation (Line(points={{202,220},
          {210,220},{210,50},{-36,50},{-36,155.5},{-2,155.5}}, color={255,0,255}));
  connect(endUp1.yChi[1], chiOneSta1.y1) annotation (Line(points={{22,168.5},{70,
          168.5},{70,240},{78,240}}, color={255,0,255}));
  connect(chiOneSta1.y1_actual, chiOneSta.u1) annotation (Line(points={{102,240},
          {170,240},{170,228},{178,228}}, color={255,0,255}));
  connect(chiTwoSta.y1_actual, endUp1.uConWatReq[2]) annotation (Line(points={{102,
          90},{110,90},{110,60},{-32,60},{-32,156.5},{-2,156.5}}, color={255,0,255}));
annotation (
 experiment(StopTime=2400, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Chillers/Staging/Processes/Subsequences/Validation/UpEndWithOff.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.UpEnd\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.UpEnd</a>.
</p>
<p>
It shows how the staging up process ends when the process requires one chiller
to be enabled and another chiller to be disabled. The instance <code>endUp1</code>
shows the results as below. It stages up from stage 1 which requires smaller chiller
1 to be enabled, to stage 2 which requires larger chiller 2 to be enabled and
chiller 1 to be disabled.
</p>
<ul>
<li>
Before 1000 seconds, the plant is not in staging up process (<code>uStaUp=false</code>).
</li>
<li>
At 1000 seconds, the plant starts staging up (<code>uStaUp=true</code>). However,
it does not yet starts the subprocess of ending the staging process
(<code>uEnaChiWatIsoVal=false</code>).
</li>
<li>
At 1125 seconds, the ending process starts (<code>uEnaChiWatIsoVal=true</code>).
The chiller 2 is enabled (<code>uChi[2]=true</code>, <code>uChiWatReq[2]=true</code>,
<code>uConWatReq[2]=true</code>).
</li>
<li>
After 300 seconds at 1425 seconds, the chiller 1 becomes disabled
(<code>uChi[1]=false</code>). The chiller 1 becomes not requiring the chilled water
and condenser water (<code>uChiWatReq[1]=false</code>, <code>uConWatReq[1]=false</code>).
It starts slowly closing the chilled water isolation valve of chiller 1.
</li>
<li>
After 300 seconds (<code>chaChiWatIsoTim</code>) at 1725 seconds, the chilled water
isolation valve of chiller 1 is fully closed. The head pressure control of chiller
1 becomes disabled (<code>yChiHeaCon[1]</code>). The chilled water minimum flow
setpoint changes to the new setpoint.
</li>
<li>
After 60 seconds (<code>aftByPasSetTim</code>) at 1785 seconds, the ending process
is done (<code>yEndSta=true</code>).
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 30, 2019, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-260},{220,260}}),
        graphics={
        Text(
          extent={{-242,250},{-210,242}},
          textColor={0,0,127},
          textString="Stage up:"),
        Text(
          extent={{-236,236},{-76,226}},
          textColor={0,0,127},
          textString="from stage 1 which has small chiller 1 being enabled, "),
        Text(
          extent={{-240,224},{22,210}},
          textColor={0,0,127},
          textString="to stage 2 which has small chiller 1 being disabled and large chiller 2 being enabled.")}));
end UpEndWithOff;
