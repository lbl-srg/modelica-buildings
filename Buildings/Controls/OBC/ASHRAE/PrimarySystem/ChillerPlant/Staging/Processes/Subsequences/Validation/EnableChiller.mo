within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model EnableChiller
  "Validate sequence of enabling and disabling chiller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableChiller
    enaDisChi(final nChi=3) "Enable larger chiller and disable smaller chiller"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableChiller
    enaOneChi(final nChi=3) "Enable additional chiller"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp "Stage up command"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.20,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not chiIsoVal
    "Chilled water isolation valve resetting status"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaChi(final k=3)
    "Enabling chiller index"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOne(final k=true)
    "Operating chiller one"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onOff(final k=true)
    "Requires one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant disChi(final k=2)
    "Disabling chiller index"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiStaRet[2]
    "Chiller status return value"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiTwo "Chiller two status"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiStaRet1
    "Chiller status return value"
    annotation (Placement(transformation(extent={{140,70},{160,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noOnOff(final k=false)
    "Does not requires one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant disChi1(final k=0)
    "Disabling chiller index"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));

equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-178,60},{-162,60}}, color={255,0,255}));
  connect(booPul1.y,chiIsoVal. u)
    annotation (Line(points={{-178,20},{-162,20}}, color={255,0,255}));
  connect(enaChi.y, enaDisChi.nexEnaChi)
    annotation (Line(points={{-138,100},{-120,100},{-120,89},{-82,89}},
      color={255,127,0}));
  connect(staUp.y, enaDisChi.uStaUp)
    annotation (Line(points={{-138,60},{-120,60},{-120,86},{-82,86}},
      color={255,0,255}));
  connect(chiIsoVal.y, enaDisChi.uEnaChiWatIsoVal)
    annotation (Line(points={{-138,20},{-116,20},{-116,82},{-82,82}},
      color={255,0,255}));
  connect(chiOne.y, enaDisChi.uChi[1])
    annotation (Line(points={{-138,-20},{-112,-20},{-112,77.3333},{-82,77.3333}},
      color={255,0,255}));
  connect(chiIsoVal.y, chiTwo.u2)
    annotation (Line(points={{-138,20},{-116,20},{-116,-40},{-42,-40}},
      color={255,0,255}));
  connect(chiStaRet[1].y, chiTwo.u1)
    annotation (Line(points={{-18,80},{0,80},{0,0},{-60,0},{-60,-32},{-42,-32}},
      color={255,0,255}));
  connect(chiOne.y, chiTwo.u3)
    annotation (Line(points={{-138,-20},{-112,-20},{-112,-48},{-42,-48}},
      color={255,0,255}));
  connect(chiTwo.y, enaDisChi.uChi[2])
    annotation (Line(points={{-18,-40},{0,-40},{0,-70},{-108,-70},{-108,78},
      {-82,78}}, color={255,0,255}));
  connect(enaDisChi.yChi[2], chiStaRet[1].u)
    annotation (Line(points={{-58,88},{-50,88},{-50,80},{-42,80}},
      color={255,0,255}));
  connect(enaDisChi.yChi[3], chiStaRet[2].u)
    annotation (Line(points={{-58,88.6667},{-50,88.6667},{-50,80},{-42,80}},
      color={255,0,255}));
  connect(chiStaRet[2].y, enaDisChi.uChi[3])
    annotation (Line(points={{-18,80},{0,80},{0,40},{-104,40},{-104,78.6667},{
          -82,78.6667}},
                      color={255,0,255}));
  connect(onOff.y, enaDisChi.uOnOff)
    annotation (Line(points={{-138,-60},{-100,-60},{-100,74},{-82,74}},
      color={255,0,255}));
  connect(disChi.y, enaDisChi.nexDisChi)
    annotation (Line(points={{-138,-100},{-96,-100},{-96,71},{-82,71}},
      color={255,127,0}));
  connect(enaChi.y, enaOneChi.nexEnaChi)
    annotation (Line(points={{-138,100},{40,100},{40,89},{98,89}},
      color={255,127,0}));
  connect(staUp.y, enaOneChi.uStaUp)
    annotation (Line(points={{-138,60},{40,60},{40,86},{98,86}},
      color={255,0,255}));
  connect(chiIsoVal.y, enaOneChi.uEnaChiWatIsoVal)
    annotation (Line(points={{-138,20},{44,20},{44,82},{98,82}},
      color={255,0,255}));
  connect(chiOne.y, enaOneChi.uChi[1])
    annotation (Line(points={{-138,-20},{48,-20},{48,77.3333},{98,77.3333}},
      color={255,0,255}));
  connect(chiOne.y, enaOneChi.uChi[2])
    annotation (Line(points={{-138,-20},{48,-20},{48,78},{98,78}},
      color={255,0,255}));
  connect(noOnOff.y, enaOneChi.uOnOff)
    annotation (Line(points={{42,-60},{56,-60},{56,74},{98,74}},
      color={255,0,255}));
  connect(disChi1.y, enaOneChi.nexDisChi)
    annotation (Line(points={{42,-100},{60,-100},{60,71},{98,71}},
      color={255,127,0}));
  connect(enaOneChi.yChi[3], chiStaRet1.u)
    annotation (Line(points={{122,88.6667},{130,88.6667},{130,80},{138,80}},
      color={255,0,255}));
  connect(chiStaRet1.y, enaOneChi.uChi[3])
    annotation (Line(points={{162,80},{180,80},{180,40},{52,40},{52,78.6667},{
          98,78.6667}},
                     color={255,0,255}));

annotation (
 experiment(StopTime=3600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/EnableChiller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableChiller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.EnableChiller</a>.
</p>
<p>
The example has two instances <code>enaDisChi</code> and <code>enaOneChi</code>,
which shows the sub-processes of enabling chillers when the plant is in staging up
process. For the instance <code>enaDisChi</code>, the process requires chiller 3
being enabled and chiller 2 being disabled, while for the instance
<code>enaOneChi</code>, the process just requires chiller 3 being enabled.
</p>
<p>
For the instance <code>enaDisChi</code>,
</p>
<ul>
<li>
Before 540 seconds, the plant is not in staging up process. Chiller 1 and 2 are
operating.
</li>
<li>
For period from 540 seconds to 720 seconds, it is in process up process. However,
it does not yet require enabling chiller (<code>uEnaChiWatIsoVal=false</code>).
</li>
<li>
Since 720 seconds, the process requires new chiller being enabled and the chiller
3 is enabled.
</li>
<li>
After 5 minutes at 1020 seconds, the chiller 2 becomes disabled. The output
<code>yNewChiEna</code> becomes true, indicates that the chiller enabling process
is finished.
</li>
</ul>

<p>
For the instance <code>enaOneChi</code>,
</p>
<ul>
<li>
Before 540 seconds, the plant is not in staging up process. Chiller 1 and 2 are operating.
</li>
<li>
For period from 540 seconds to 720 seconds, it is in process up process. However,
it does not yet require enabling chiller (<code>uEnaChiWatIsoVal=false</code>).
</li>
<li>
Since 720 seconds, the process requires new chiller being enabled and the chiller
3 is enabled. The output <code>yNewChiEna</code> becomes true, indicates that the
chiller enabling process is finished.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 24, 2019, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-140},{220,140}})));
end EnableChiller;
