within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.Validation;
model UpEndWithoutOff
  "Validate sequence of end staging up process which does not require chiller OFF"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.UpEnd
    endUp(
    final nChi=2,
    final chaChiWatIsoTim=300,
    final byPasSetTim=300,
    final minFloSet={0.5,1},
    final maxFloSet={1,1.5})
    "End staging up process which does not require one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    freqHz=1/1200)
    "Real source for showing the ending edge"
    annotation (Placement(transformation(extent={{-14,210},{6,230}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Staging end indicator"
    annotation (Placement(transformation(extent={{56,210},{76,230}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.4,
    final period=2500)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,70},{-180,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp "Stage up command"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant nexDisChi(
    final k=0) "Next disabling chiller"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onOff(
    final k=false) "Chiller on-off command"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiHea[2](
    final k=fill(true,2)) "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{-200,-170},{-180,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatFlo(final k=1.667)
    "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,-250},{-180,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant nexEnaChi(
    final k=2) "Next enable chiller"
    annotation (Placement(transformation(extent={{-200,160},{-180,180}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer2(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-200,120},{-180,140}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.45,
    final period=2500)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not upStrDev "Upstream device status"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatIsoVal[2](
    final k=fill(1, 2))
    "Constant one"
    annotation (Placement(transformation(extent={{-200,-90},{-180,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Staging up"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Templates.Components.Controls.StatusEmulator chiTwoSta(
    final delayTime=0)
    "Chiller two status"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=true)
    "Constant true"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=1,
    final delayOnInit=true)
    "Check if it has passed initial time"
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiOneSta1
    "Chiller one status"
    annotation (Placement(transformation(extent={{180,160},{200,180}})));
  Buildings.Templates.Components.Controls.StatusEmulator chiOneSta(
    final delayTime=0)
    "Chiller one status"
    annotation (Placement(transformation(extent={{80,180},{100,200}})));

equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-178,80},{-162,80}}, color={255,0,255}));
  connect(staUp.y, swi2.u2)
    annotation (Line(points={{-138,80},{-130,80},{-130,150},{-122,150}},
      color={255,0,255}));
  connect(nexEnaChi.y, swi2.u1)
    annotation (Line(points={{-178,170},{-160,170},{-160,158},{-122,158}},
      color={0,0,127}));
  connect(zer2.y, swi2.u3)
    annotation (Line(points={{-178,130},{-160,130},{-160,142},{-122,142}},
      color={0,0,127}));
  connect(swi2.y, reaToInt.u)
    annotation (Line(points={{-98,150},{-82,150}}, color={0,0,127}));
  connect(booPul1.y, upStrDev.u)
    annotation (Line(points={{-178,40},{-162,40}}, color={255,0,255}));
  connect(reaToInt.y, endUp.nexEnaChi)
    annotation (Line(points={{-58,150},{-40,150},{-40,162},{38,162}},
      color={255,127,0}));
  connect(upStrDev.y, endUp.uEnaChiWatIsoVal)
    annotation (Line(points={{-138,40},{-32,40},{-32,158},{38,158}},
      color={255,0,255}));
  connect(onOff.y, endUp.uOnOff)
    annotation (Line(points={{-178,0},{-20,0},{-20,154},{38,154}},
      color={255,0,255}));
  connect(nexDisChi.y, endUp.nexDisChi)
    annotation (Line(points={{-178,-40},{-16,-40},{-16,152},{38,152}},
      color={255,127,0}));
  connect(chiWatFlo.y, endUp.VChiWat_flow)
    annotation (Line(points={{-178,-240},{12,-240},{12,142},{38,142}},
      color={0,0,127}));
  connect(chiWatIsoVal.y, endUp.uChiWatIsoVal)
    annotation (Line(points={{-178,-80},{-4,-80},{-4,148},{38,148}},
      color={0,0,127}));
  connect(chiHea.y, endUp.uChiHeaCon)
    annotation (Line(points={{-178,-160},{8,-160},{8,144},{38,144}},
      color={255,0,255}));
  connect(chiWatFlo.y, endUp.VMinChiWat_setpoint)
    annotation (Line(points={{-178,-240},{12,-240},{12,140},{38,140}},
      color={0,0,127}));
  connect(endUp.endStaTri, triSam.trigger) annotation (Line(points={{62,141},{66,
          141},{66,208}}, color={255,0,255}));
  connect(sin.y, triSam.u)
    annotation (Line(points={{8,220},{54,220}}, color={0,0,127}));
  connect(staUp.y, lat.u) annotation (Line(points={{-138,80},{-130,80},{-130,110},
          {-82,110}},color={255,0,255}));
  connect(endUp.endStaTri, lat.clr) annotation (Line(points={{62,141},{66,141},{
          66,88},{-90,88},{-90,104},{-82,104}},   color={255,0,255}));
  connect(lat.y, endUp.uStaUp) annotation (Line(points={{-58,110},{-36,110},{-36,
          160},{38,160}}, color={255,0,255}));
  connect(endUp.yChi[2], chiTwoSta.y1) annotation (Line(points={{62,159.5},{70,159.5},
          {70,60},{78,60}}, color={255,0,255}));
  connect(con2.y, truDel.u) annotation (Line(points={{102,120},{130,120},{130,170},
          {138,170}}, color={255,0,255}));
  connect(con2.y, chiOneSta1.u3) annotation (Line(points={{102,120},{170,120},{170,
          162},{178,162}}, color={255,0,255}));
  connect(truDel.y, chiOneSta1.u2)
    annotation (Line(points={{162,170},{178,170}}, color={255,0,255}));
  connect(chiOneSta.y1_actual, chiOneSta1.u1) annotation (Line(points={{102,190},
          {170,190},{170,178},{178,178}}, color={255,0,255}));
  connect(endUp.yChi[1], chiOneSta.y1) annotation (Line(points={{62,158.5},{70,158.5},
          {70,190},{78,190}}, color={255,0,255}));
  connect(chiOneSta1.y, endUp.uChi[1]) annotation (Line(points={{202,170},{210,170},
          {210,100},{-28,100},{-28,155.5},{38,155.5}}, color={255,0,255}));
  connect(chiTwoSta.y1_actual, endUp.uChi[2]) annotation (Line(points={{102,60},
          {110,60},{110,80},{-24,80},{-24,156.5},{38,156.5}}, color={255,0,255}));
  connect(chiOneSta1.y, endUp.uChiWatReq[1]) annotation (Line(points={{202,170},
          {210,170},{210,100},{-12,100},{-12,149.5},{38,149.5}}, color={255,0,255}));
  connect(chiTwoSta.y1_actual, endUp.uChiWatReq[2]) annotation (Line(points={{102,
          60},{110,60},{110,80},{-8,80},{-8,150.5},{38,150.5}}, color={255,0,255}));
  connect(chiOneSta1.y, endUp.uConWatReq[1]) annotation (Line(points={{202,170},
          {210,170},{210,100},{0,100},{0,145.5},{38,145.5}}, color={255,0,255}));
  connect(chiTwoSta.y1_actual, endUp.uConWatReq[2]) annotation (Line(points={{102,
          60},{110,60},{110,80},{4,80},{4,146.5},{38,146.5}}, color={255,0,255}));
annotation (
 experiment(StopTime=2400, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Chillers/Staging/Processes/Subsequences/Validation/UpEndWithoutOff.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.UpEnd\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences.UpEnd</a>.
</p>
<p>
It shows how the staging up process ends when the process does not require one chiller
to be enabled and another chiller to be disabled. The instance <code>endUp</code>
shows the results as below. It stages up from stage 1 which requires chiller 1 to be
enabled, to stage 2 which requires chiller 1 and chiller 2 to be enabled.
</p>
<ul>
<li>
Before 1000 seconds, the plant is not in the staging up process (<code>uStaUp=false</code>).
</li>
<li>
At 1000 seconds, the plant starts staging up (<code>uStaUp=true</code>). However,
it does not yet start the subprocess of ending the staging process
(<code>uEnaChiWatIsoVal=false</code>).
</li>
<li>
At 1125 seconds, the ending process starts (<code>uEnaChiWatIsoVal=true</code>).
The chiller 2 is enabled (<code>yChi[2]=true</code>). The ending process is done
(the output <code>yEndSta</code> has a rising edge).
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
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-260},{220,260}}),
        graphics={
        Text(
          extent={{-202,240},{-170,232}},
          textColor={0,0,127},
          textString="Stage up:"),
        Text(
          extent={{-198,226},{-38,216}},
          textColor={0,0,127},
          textString="from stage 1 which has only chiller 1 being enabled, "),
        Text(
          extent={{-198,214},{-44,200}},
          textColor={0,0,127},
          textString="to stage 2 which has chiller 1 and 2 being enabled.")}));
end UpEndWithoutOff;
