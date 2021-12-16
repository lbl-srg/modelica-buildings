within Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.BalancedStepUp;
model YY
  "IEEE 4 node test feeder model with balanced load and Y - Y connection (step up)"
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
    final V2_ref={7126,7145,7137},
    final V3_ref={13675,13715,13698},
    final V4_ref={13631,13682,13661},
    final Theta2_ref=Modelica.Constants.pi/180.0*{-0.3,-120.4,119.6},
    final Theta3_ref=Modelica.Constants.pi/180.0*{-3.3,-123.4,116.6},
    final Theta4_ref=Modelica.Constants.pi/180.0*{-3.5,-123.5,116.5},
    loadRL(use_pf_in=false));
  Modelica.Blocks.Sources.Constant load(k=-1800e3)
    annotation (Placement(transformation(extent={{54,62},{74,82}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformer
    transformer(
    VHigh=VLL_side1,
    VLow=VLL_side2,
    XoverR=6,
    Zperc=sqrt(0.01^2 + 0.06^2),
    VABase=VARbase)
    annotation (Placement(transformation(extent={{-26,0},{-6,20}})));
equation
  connect(load.y, loadRL.Pow1) annotation (Line(
      points={{75,72},{90,72},{90,18},{76,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load.y, loadRL.Pow2) annotation (Line(
      points={{75,72},{90,72},{90,10},{76,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load.y, loadRL.Pow3) annotation (Line(
      points={{75,72},{90,72},{90,2},{76,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(line1.terminal_p, transformer.terminal_n) annotation (Line(
      points={{-48,10},{-26,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(transformer.terminal_p, line2.terminal_n) annotation (Line(
      points={{-6,10},{12,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(node1.term, source.terminal) annotation (Line(
      points={{-74,29},{-74,30},{-74,30},{-74,10},{-74,10},{-78,10},{-78,10}},
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
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Validation/IEEETests/Test4NodesFeeder/BalancedStepUp/YY.mos"
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
  <li>power consumption on each phase <i>P<sub>1,2,3</sub> = 1800 kW</i></li>
  <li>power factor on each phase <i>cos&phi;<sub>1,2,3</sub> = 0.9</i></li>
  </ul>
</li>
<li>voltage step-up transformer (<i>V<sub>Pri</sub>=12.47 kV</i>,
<i>V<sub>Sec</sub> = 24.9kV</i>),</li>
<li>Y-Y transformer</li>
</ul>
</html>"));
end YY;
