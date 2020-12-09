within Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.UnbalancedStepDown;
model DD
  "IEEE 4 node test feeder model with unbalanced load and D - D connection (step down)"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.BaseClasses.IEEE4(
    final line1_use_Z_y=false,
    final line2_use_Z_y=false,
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeDelta
      node1,
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeDelta
      node2,
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeDelta
      node3,
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeDelta
      node4,
    final VLL_side1=12.47e3,
    final VLL_side2=4.16e3,
    final VARbase=6000e3,
    final V2_ref={12341,12370,12302},
    final V3_ref={3902,3972,3871},
    final V4_ref={3431,3647,3294},
    final Theta2_ref=Modelica.Constants.pi/180.0*{29.8,-90.5,149.5},
    final Theta3_ref=Modelica.Constants.pi/180.0*{27.2,-93.9,145.7},
    final Theta4_ref=Modelica.Constants.pi/180.0*{24.3,-100.4,138.6},
    loadRL(loadConn=Buildings.Electrical.Types.LoadConnection.wye_to_delta,
        use_pf_in=true));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerDD
    transformer(
    VHigh=VLL_side1,
    VLow=VLL_side2,
    XoverR=6,
    Zperc=sqrt(0.01^2 + 0.06^2),
    VABase=VARbase)
    annotation (Placement(transformation(extent={{-26,0},{-6,20}})));
  Modelica.Blocks.Sources.Constant load3(k=-2375e3)
    annotation (Placement(transformation(extent={{8,76},{28,96}})));
  Modelica.Blocks.Sources.Constant load2(k=-1800e3)
    annotation (Placement(transformation(extent={{34,58},{54,78}})));
  Modelica.Blocks.Sources.Constant load1(k=-1275e3)
    annotation (Placement(transformation(extent={{54,30},{74,50}})));
  Modelica.Blocks.Sources.Constant pf1(k=0.85)
    annotation (Placement(transformation(extent={{-6,-30},{14,-10}})));
  Modelica.Blocks.Sources.Constant pf2(k=0.9)
    annotation (Placement(transformation(extent={{16,-50},{36,-30}})));
  Modelica.Blocks.Sources.Constant pf3(k=0.95)
    annotation (Placement(transformation(extent={{38,-70},{58,-50}})));
equation
  connect(line1.terminal_p, transformer.terminal_n) annotation (Line(
      points={{-48,10},{-26,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(transformer.terminal_p, line2.terminal_n) annotation (Line(
      points={{-6,10},{12,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(load1.y, loadRL.Pow1) annotation (Line(
      points={{75,40},{80,40},{80,18},{76,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load2.y, loadRL.Pow2) annotation (Line(
      points={{55,68},{84,68},{84,10},{76,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load3.y, loadRL.Pow3) annotation (Line(
      points={{29,86},{88,86},{88,2},{76,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pf1.y, loadRL.pf_in_1) annotation (Line(
      points={{15,-20},{58,-20},{58,-4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pf2.y, loadRL.pf_in_2) annotation (Line(
      points={{37,-40},{64,-40},{64,-4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pf3.y, loadRL.pf_in_3) annotation (Line(
      points={{59,-60},{70.2,-60},{70.2,-4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(node1.term, line1.terminal_n) annotation (Line(
      points={{-74,29},{-74,10},{-68,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(node2.term, transformer.terminal_n) annotation (Line(
      points={{-42,29},{-42,10},{-26,10}},
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
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Validation/IEEETests/Test4NodesFeeder/UnbalancedStepDown/DD.mos"
        "Simulate and plot"),
 Documentation(revisions="<html><ul>
<li>
October 9, 2014, by Marco Bonvini:<br/>
Added documentation.
</li>
<li>
June 17, 2014, by Marco Bonvini:<br/>
Moved to Examples IEEE package.
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
<li>voltage step-down transformer (<i>V<sub>Pri</sub>=12.47 kV</i>
<i>V<sub>Sec</sub> = 4.16kV</i>),</li>
<li>D-D transformer</li>
</ul>
</html>"));
end DD;
