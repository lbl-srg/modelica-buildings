within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model DisableChiller
  "Validate sequence of disabling chiller during stage-down process"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DisableChiller
    chiOnOff(
    final nChi=3,
    final proOnTim=300) "Disable a chiller and enable another chiller"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DisableChiller
    chiOff(
    final nChi=3,
    final proOnTim=300) "Disable chiller"
    annotation (Placement(transformation(extent={{102,70},{122,90}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not staCha "Stage change command"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.20,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not upsDevSta "Upstream device status"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOne(
    final k=true) "Operating chiller one"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaChi(final k=3)
    "Enabling chiller index"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiTwo "Chiller two status"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onOff(final k=true)
    "Requires one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant disChi(
    final k=2) "Disabling chiller index"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaChi1(final k=0)
    "No Chiller needs to be enabled"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noOnOff(final k=false)
    "Does not requires one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiTwo1 "Chiller two status"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noUpDev(final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiStaRet[2]
    "Chiller status return value"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiStaRet1[2]
    "Chiller status return value"
    annotation (Placement(transformation(extent={{140,70},{160,90}})));

equation
  connect(booPul.y, staCha.u)
    annotation (Line(points={{-178,60},{-162,60}}, color={255,0,255}));
  connect(booPul1.y, upsDevSta.u)
    annotation (Line(points={{-178,20},{-162,20}}, color={255,0,255}));
  connect(enaChi.y, chiOnOff.nexEnaChi)
    annotation (Line(points={{-138,100},{-100,100},{-100,89},{-82,89}},
      color={255,127,0}));
  connect(staCha.y, chiOnOff.uStaDow)
    annotation (Line(points={{-138,60},{-124,60},{-124,86},{-82,86}},
      color={255,0,255}));
  connect(upsDevSta.y, chiOnOff.uEnaChiWatIsoVal)
    annotation (Line(points={{-138,20},{-116,20},{-116,82},{-82,82}},
      color={255,0,255}));
  connect(chiOne.y, chiOnOff.uChi[1])
    annotation (Line(points={{-138,-20},{-108,-20},{-108,77.3333},{-82,77.3333}},
      color={255,0,255}));
  connect(upsDevSta.y, chiTwo.u2)
    annotation (Line(points={{-138,20},{-116,20},{-116,-40},{-42,-40}},
      color={255,0,255}));
  connect(chiOne.y, chiTwo.u3)
    annotation (Line(points={{-138,-20},{-108,-20},{-108,-48},{-42,-48}},
      color={255,0,255}));
  connect(chiOnOff.yChi[2], chiStaRet[1].u)
    annotation (Line(points={{-58,80},{-42,80}}, color={255,0,255}));
  connect(chiOnOff.yChi[3], chiStaRet[2].u) annotation (Line(points={{-58,
          80.6667},{-50,80.6667},{-50,80},{-42,80}}, color={255,0,255}));
  connect(chiStaRet[1].y, chiTwo.u1) annotation (Line(points={{-18,80},{-10,80},
          {-10,0},{-50,0},{-50,-32},{-42,-32}}, color={255,0,255}));
  connect(chiStaRet[2].y, chiOnOff.uChi[3]) annotation (Line(points={{-18,80},{
          -10,80},{-10,40},{-112,40},{-112,78.6667},{-82,78.6667}}, color={255,
          0,255}));
  connect(chiTwo.y, chiOnOff.uChi[2])
    annotation (Line(points={{-18,-40},{-10,-40},{-10,-70},{-120,-70},{-120,78},
      {-82,78}}, color={255,0,255}));
  connect(disChi.y, chiOnOff.nexDisChi)
    annotation (Line(points={{-138,-60},{-104,-60},{-104,75},{-82,75}},
      color={255,127,0}));
  connect(onOff.y, chiOnOff.uOnOff)
    annotation (Line(points={{-138,-100},{-100,-100},{-100,71},{-82,71}},
      color={255,0,255}));
  connect(enaChi1.y, chiOff.nexEnaChi)
    annotation (Line(points={{42,100},{80,100},{80,89},{100,89}},
      color={255,127,0}));
  connect(staCha.y, chiOff.uStaDow)
    annotation (Line(points={{-138,60},{56,60},{56,86},{100,86}},
      color={255,0,255}));
  connect(chiOne.y, chiOff.uChi[1])
    annotation (Line(points={{-138,-20},{64,-20},{64,77.3333},{100,77.3333}},
      color={255,0,255}));
  connect(disChi.y, chiOff.nexDisChi)
    annotation (Line(points={{-138,-60},{76,-60},{76,75},{100,75}},
      color={255,127,0}));
  connect(noOnOff.y, chiOff.uOnOff)
    annotation (Line(points={{42,-100},{80,-100},{80,71},{100,71}},
      color={255,0,255}));
  connect(chiOff.yChi[2], chiStaRet1[1].u)
    annotation (Line(points={{124,80},{138,80}}, color={255,0,255}));
  connect(chiOff.yChi[3], chiStaRet1[2].u) annotation (Line(points={{124,
          80.6667},{132,80.6667},{132,80},{138,80}}, color={255,0,255}));
  connect(staCha.y, chiTwo1.u2)
    annotation (Line(points={{-138,60},{56,60},{56,-40},{138,-40}},
      color={255,0,255}));
  connect(chiOne.y, chiTwo1.u3)
    annotation (Line(points={{-138,-20},{64,-20},{64,-48},{138,-48}},
      color={255,0,255}));
  connect(chiStaRet1[1].y, chiTwo1.u1) annotation (Line(points={{162,80},{170,
          80},{170,-20},{130,-20},{130,-32},{138,-32}}, color={255,0,255}));
  connect(chiTwo1.y, chiOff.uChi[2])
    annotation (Line(points={{162,-40},{170,-40},{170,-70},{68,-70},
      {68,78},{100,78}}, color={255,0,255}));
  connect(chiStaRet1[2].y, chiOff.uChi[3]) annotation (Line(points={{162,80},{
          170,80},{170,40},{72,40},{72,78.6667},{100,78.6667}}, color={255,0,
          255}));
  connect(noUpDev.y, chiOff.uEnaChiWatIsoVal)
    annotation (Line(points={{42,20},{60,20},{60,82},{100,82}},
      color={255,0,255}));

annotation (
 experiment(StopTime=3600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/DisableChiller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DisableChiller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DisableChiller</a>.
It shows the substeps of disabling chillers when the plant is in staging down process.
</p>
<p>
The instance <code>chiOnOff</code> shows how to enable and disable chillers when
the staging down process requires one chiller being enabled and another chiller
being disabled. The instance <code>chiOff</code> shows how the chiller being
disable when the staging down process does not require other chiller being enabled.
</p>
<p>
For the instance <code>chiOnOff</code>, initially the plant has chiller 1 and 2
operating. When staging down, it requires chiller 3 being enabled and chiller 2
being disabled.
</p>
<ul>
<li>
Before 540 seconds, it does not require the plant staging down (<code>uStaDow=false</code>).
The chiller 1 and 2 are operating, and chiller 3 is not operating.
</li>
<li>
At period between 540 seconds and 720 seconds, the plant is in staing down process.
However, the process is not yet requiring the chiller being enabled or disabled,
as <code>uEnaChiWatIsoVal=false</code>.
</li>
<li>
At 720 seconds, the staging down process requires chiller 2 being diabled and chiller
3 being enabled (<code>nexEnaChi=3</code>, <code>nexDisChi=2</code>). The chiller
3 becomes enabled.
</li>
<li>
At 1020 seconds, which is 5 mintes after enabling chiller 3 (specified by
<code>proOnTim</code>), chiller 2 becomes disabled and the chiller demand limit
can be released (<code>yRelDemLim=true</code>).
</li>
</ul>
<p>
For the instance <code>chiOff</code>, initially the plant has chiller 1 and 2
operating. When staging down, it disables chiller 2.
</p>
<ul>
<li>
Before 540 seconds, it does not require the plant staging down
(<code>uStaDow=false</code>). The chiller 1 and 2 are operating, and chiller 3
is not operating.
</li>
<li>
At 540 seconds, the plant starts staging down (<code>uStaDow=true</code>).
The chiller 2 is disabled immediately.
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
end DisableChiller;
