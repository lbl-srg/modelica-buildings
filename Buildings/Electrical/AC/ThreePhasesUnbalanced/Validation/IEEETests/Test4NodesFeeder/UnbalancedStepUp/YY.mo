within Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.UnbalancedStepUp;
model YY
  "IEEE 4 node test feeder model with unbalanced load and Y - Y connection (step up)"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.BaseClasses.IEEE4(
    final line1_use_Z_y=true,
    final line2_use_Z_y=true,
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye
      node1,
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye
      node2,
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye
      node3,
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye
      node4,
    final VLL_side1=12.47e3,
    final VLL_side2=24.9e3,
    final VARbase=6000e3,
    final V2_ref={7161,7120,7128},
    final V3_ref={13839,13663,13655},
    final V4_ref={13815,13614,13615},
    final Theta2_ref=Modelica.Constants.pi/180.0*{-0.1,-120.3,119.3},
    final Theta3_ref=Modelica.Constants.pi/180.0*{-2.1,-123.3,115.1},
    final Theta4_ref=Modelica.Constants.pi/180.0*{-2.2,-123.4,114.9},
    loadRL(use_pf_in=true));
  Modelica.Blocks.Sources.Constant load2(k=-1800e3)
    annotation (Placement(transformation(extent={{30,58},{50,78}})));
  Modelica.Blocks.Sources.Constant load3(k=-2375e3)
    annotation (Placement(transformation(extent={{4,74},{24,94}})));
  Modelica.Blocks.Sources.Constant load1(k=-1275e3)
    annotation (Placement(transformation(extent={{56,30},{76,50}})));
  Modelica.Blocks.Sources.Constant pf1(k=0.85)
    annotation (Placement(transformation(extent={{-6,-28},{14,-8}})));
  Modelica.Blocks.Sources.Constant pf2(k=0.9)
    annotation (Placement(transformation(extent={{12,-54},{32,-34}})));
  Modelica.Blocks.Sources.Constant pf3(k=0.95)
    annotation (Placement(transformation(extent={{34,-78},{54,-58}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformer
    transformer(
    VHigh=VLL_side1,
    VLow=VLL_side2,
    XoverR=6,
    Zperc=sqrt(0.01^2 + 0.06^2),
    VABase=VARbase,
    conv1(V1(start={6.9E3, -250})),
    conv2(V1(start={-3.8E3, -5.7E3})))
    annotation (Placement(transformation(extent={{-28,0},{-8,20}})));
equation
  connect(load2.y, loadRL.Pow2) annotation (Line(
      points={{51,68},{86,68},{86,10},{76,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load3.y, loadRL.Pow3) annotation (Line(
      points={{25,84},{88,84},{88,2},{76,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load1.y, loadRL.Pow1) annotation (Line(
      points={{77,40},{84,40},{84,18},{76,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pf1.y, loadRL.pf_in_1) annotation (Line(
      points={{15,-18},{58,-18},{58,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pf2.y, loadRL.pf_in_2) annotation (Line(
      points={{33,-44},{64,-44},{64,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pf3.y, loadRL.pf_in_3) annotation (Line(
      points={{55,-68},{70.2,-68},{70.2,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(line1.terminal_p, transformer.terminal_n) annotation (Line(
      points={{-48,10},{-28,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(transformer.terminal_p, line2.terminal_n) annotation (Line(
      points={{-8,10},{12,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(node1.term, line1.terminal_n) annotation (Line(
      points={{-74,29},{-74,10},{-68,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(node2.term, transformer.terminal_n) annotation (Line(
      points={{-42,29},{-42,10},{-28,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(node3.term, line2.terminal_n) annotation (Line(
      points={{6,29},{6,10},{12,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(node4.term, loadRL.terminal) annotation (Line(
      points={{38,29},{38,10},{54,10}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0, Tolerance=1e-6),
  __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Validation/IEEETests/Test4NodesFeeder/UnbalancedStepUp/YY.mos"
        "Simulate and plot"),
 Documentation(revisions="<html>
<ul>
<li>
November 28, 2016, by Michael Wetter:<br/>
Set start values.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/584\">#584</a>.
</li>
<li>
October 9, 2014, by Marco Bonvini:<br/>
Added documentation.
</li>
<li>
June 17, 2014, by Marco Bonvini:<br/>
Moved to Examples IEEE package Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.UnbalancedStepUp.YY
</li>
<li>
June 6, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
IEEE 4 nodes validation test case with the following characteristics
</p>
<ul>
<li>balanced load,
  <ul>
  <li>power consumption on phases <i>P<sub>1</sub> = 2375 kW</i>,
  <i>P<sub>2</sub> = 1800 kW</i>, and <i>P<sub>3</sub> = 1275 kW</i></li>
  <li>power factor on phases <i>cos&phi;<sub>1</sub> = 0.85</i>,
  <i>cos&phi;<sub>2</sub> = 0.9</i>, and <i>cos&phi;<sub>3</sub> = 0.95</i></li>
  </ul>
</li>
<li>voltage step-up transformer (<i>V<sub>Pri</sub>=12.47 kV</i>,
<i>V<sub>Sec</sub> = 24.9kV</i>),</li>
<li>Y-Y transformer</li>
</ul>
</html>"));
end YY;
