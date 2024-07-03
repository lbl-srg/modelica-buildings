within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model CHWIsoVal
  "Validate isolation valve enable and disable sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal
    enaChiIsoVal(
    final nChi=2,
    final chaChiWatIsoTim=300,
    final iniValPos=0,
    final endValPos=1) "Enable isolation valve"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal
    disChiIsoVal(
    final nChi=2,
    final chaChiWatIsoTim=300,
    final iniValPos=1,
    final endValPos=0) "Disable isolation valve"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not staCha "Stage change command"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.20,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,-40},{-180,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not upsDevSta "Upstream device status"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant valOne(
    final k=1) "Valve one position, fully open"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaChi(
    final k=2) "Enabling chiller index"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(
    final samplePeriod=2)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant valOne1(
    final k=1)
    "Valve one position, fully open"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant disChi(
    final k=2)
    "Disabling chiller index"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1(
    final samplePeriod=2)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{160,-20},{180,0}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Second chiller isolation valve position"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));

equation
  connect(booPul.y, staCha.u)
    annotation (Line(points={{-178,-70},{-162,-70}}, color={255,0,255}));
  connect(booPul1.y, upsDevSta.u)
    annotation (Line(points={{-178,-30},{-162,-30}}, color={255,0,255}));
  connect(enaChi.y, enaChiIsoVal.nexChaChi)
    annotation (Line(points={{-138,80},{-120,80},{-120,18},{-102,18}},
      color={255,127,0}));
  connect(valOne.y, enaChiIsoVal.uChiWatIsoVal[1])
    annotation (Line(points={{-178,20},{-160,20},{-160,14.5},{-102,14.5}},
      color={0,0,127}));
  connect(upsDevSta.y, enaChiIsoVal.uUpsDevSta)
    annotation (Line(points={{-138,-30},{-120,-30},{-120,5},{-102,5}},
      color={255,0,255}));
  connect(staCha.y, enaChiIsoVal.uStaPro) annotation (Line(points={{-138,-70},{-110,
          -70},{-110,2},{-102,2}}, color={255,0,255}));
  connect(enaChiIsoVal.yChiWatIsoVal[2], zerOrdHol.u)
    annotation (Line(points={{-78,4.5},{-70,4.5},{-70,0},{-62,0}}, color={0,0,127}));
  connect(zerOrdHol.y, enaChiIsoVal.uChiWatIsoVal[2])
    annotation (Line(points={{-38,0},{-20,0},{-20,60},{-140,60},{-140,15.5},{-102,
          15.5}}, color={0,0,127}));
  connect(disChi.y, disChiIsoVal.nexChaChi)
    annotation (Line(points={{82,80},{110,80},{110,8},{118,8}},
      color={255,127,0}));
  connect(valOne1.y, disChiIsoVal.uChiWatIsoVal[1])
    annotation (Line(points={{42,20},{60,20},{60,4.5},{118,4.5}}, color={0,0,127}));
  connect(disChiIsoVal.yChiWatIsoVal[2], zerOrdHol1.u)
    annotation (Line(points={{142,-5.5},{150,-5.5},{150,-10},{158,-10}},
      color={0,0,127}));
  connect(valOne1.y, swi.u3)
    annotation (Line(points={{42,20},{60,20},{60,32},{158,32}}, color={0,0,127}));
  connect(zerOrdHol1.y, swi.u1)
    annotation (Line(points={{182,-10},{200,-10},{200,20},{150,20},{150,48},
      {158,48}}, color={0,0,127}));
  connect(swi.y, disChiIsoVal.uChiWatIsoVal[2])
    annotation (Line(points={{182,40},{200,40},{200,60},{80,60},{80,5.5},{118,5.5}},
      color={0,0,127}));
  connect(upsDevSta.y, disChiIsoVal.uUpsDevSta)
    annotation (Line(points={{-138,-30},{100,-30},{100,-5},{118,-5}},
      color={255,0,255}));
  connect(staCha.y, disChiIsoVal.uStaPro) annotation (Line(points={{-138,-70},{110,
          -70},{110,-8},{118,-8}}, color={255,0,255}));
  connect(upsDevSta.y, swi.u2)
    annotation (Line(points={{-138,-30},{100,-30},{100,40},{158,40}},
      color={255,0,255}));

annotation (
 experiment(StopTime=3600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/CHWIsoVal.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal</a>.
</p>
<p>
It has two instances <code>enaChiIsoVal</code> and <code>disChiIsoVal</code> that
shows the process of controlling chiller chilled water isolation valves during the
chiller staging process.
</p>
<p>
Note that when using the subsequences, 
</p>
<ul>
<li>
specify the parameter <code>iniValPos=0</code> and <code>endValPos=1</code>
if instantiates the class in the staging up process controller, and
</li>
<li>
specify the parameter <code>iniValPos=1</code> and <code>endValPos=0</code>
if instantiates the class in the staging down process controller.
</li>
</ul>
<p>
For instance <code>enaChiIsoVal</code>,
</p>
<ul>
<li>
Before 540 seconds, the plant is not in staging up process. The isolation value 1
is fully open (<code>yChiWatIsoVal[1]=1</code>) and the valve 2 is closed
(<code>yChiWatIsoVal[2]=0</code>).
</li>
<li>
Between 540 seconds and 720 seconds, the plant is in staging process. However, the
process is not yet requiring the chilled water isolation values changing their
status, as the <code>uUpsDevSta=false</code>.
</li>
<li>
Since 720 seconds, the plant staging process requires the isolation valve changing
their status (<code>uUpsDevSta=true</code>), and the chiller 2 is being enabled.
Thus the process starts opening the isolation valve 2. As specified by
<code>chaChiWatIsoTim=300 seconds</code>, it takes 5 minutes to fully open isolation
valve 2 at 1020 seconds, and <code>yEnaChiWatIsoVal</code> becomes <code>true</code>.
</li>
</ul>
<p>
For instance <code>disChiIsoVal</code>,
</p>
<ul>
<li>
Before 540 seconds, the plant is not in staging down process. Both the isolation
value 1 and 2 are fully open (<code>yChiWatIsoVal[1]=1</code>,
<code>yChiWatIsoVal[2]=1</code>).
</li>
<li>
Between 540 seconds and 720 seconds, the plant is in staging process. However,
the process is not yet requiring the chilled water isolation values changing their
status, as the <code>uUpsDevSta=false</code>.
</li>
<li>
Since 720 seconds, the plant staging process requires the isolation valve changing
their status (<code>uUpsDevSta=true</code>), and the chiller 2 is being disabled.
Thus the process starts closing the isolation valve 2. As specified by
<code>chaChiWatIsoTim=300 seconds</code>, it takes 5 minutes to fully close isolation
valve 2 at 1020 seconds, and <code>yEnaChiWatIsoVal</code> becomes <code>true</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 24, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-120},{220,120}})));
end CHWIsoVal;
