within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.Validation;
model GroundingTransformer
  "Validation model for zig-zag grounding transformer on unbalanced delta secondary"
  extends Modelica.Icons.Example;

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.FixedVoltage souSol(
    f=60,
    V=12470)
    "Primary voltage source for solidly grounded branch"
    annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerDD traSol(
    VHigh=12470,
    VLow=480,
    VABase=500e3,
    XoverR=6,
    Zperc=0.05)
    "Delta-delta transformer for solidly grounded branch"
    annotation(Placement(transformation(extent={{-70,-10},{-50,10}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.GroundingTransformer groTraSol(
    R=0)
    "Solidly grounded zig-zag grounding transformer"
    annotation(Placement(transformation(extent={{-44,-38},{-24,-18}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortMatrixRL linSol(
    V_nominal=480,
    Z11={0.010, 0.030},
    Z12={0.002, 0.008},
    Z13={0.002, 0.006},
    Z22={0.011, 0.029},
    Z23={0.002, 0.007},
    Z33={0.010, 0.031})
    "Asymmetric three-wire line for solidly grounded branch"
    annotation(Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.Inductive loaSol(
    loadConn=Buildings.Electrical.Types.LoadConnection.wye_to_delta,
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    V_nominal=480,
    pf=0.9,
    use_pf_in=false)
    "Unbalanced delta load for solidly grounded branch"
    annotation(Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeDelta senSol(
    perUnit=false,
    V_nominal=480,
    V(each unit="V"))
    "Line-to-line voltage probe for solidly grounded branch"
    annotation(Placement(transformation(extent={{4,20},{24,40}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.FixedVoltage souRes(
    f=60,
    V=12470)
    "Primary voltage source for resistance-grounded branch"
    annotation(Placement(transformation(extent={{-110,-90},{-90,-70}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerDD traRes(
    VHigh=12470,
    VLow=480,
    VABase=500e3,
    XoverR=6,
    Zperc=0.05)
    "Delta-delta transformer for resistance-grounded branch"
    annotation(Placement(transformation(extent={{-70,-90},{-50,-70}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.GroundingTransformer groTraRes(
    R=400)
    "Resistance-grounded zig-zag grounding transformer"
    annotation(Placement(transformation(extent={{-44,-118},{-24,-98}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortMatrixRL linRes(
    V_nominal=480,
    Z11={0.010, 0.030},
    Z12={0.002, 0.008},
    Z13={0.002, 0.006},
    Z22={0.011, 0.029},
    Z23={0.002, 0.007},
    Z33={0.010, 0.031})
    "Asymmetric three-wire line for resistance-grounded branch"
    annotation(Placement(transformation(extent={{-20,-90},{0,-70}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.Inductive loaRes(
    loadConn=Buildings.Electrical.Types.LoadConnection.wye_to_delta,
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    V_nominal=480,
    pf=0.9,
    use_pf_in=false)
    "Unbalanced delta load for resistance-grounded branch"
    annotation(Placement(transformation(extent={{30,-90},{50,-70}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeDelta senRes(
    perUnit=false,
    V_nominal=480,
    V(each unit="V"))
    "Line-to-line voltage probe for resistance-grounded branch"
    annotation(Placement(transformation(extent={{4,-60},{24,-40}})));

  Modelica.Blocks.Sources.Ramp pow1(
    height=-100e3,
    duration=1.0,
    offset=-50e3)
    "Time-varying power demand on phase 1"
    annotation(Placement(transformation(extent={{60,100},{80,120}})));

  Modelica.Blocks.Sources.Constant pow2(
    k=-100e3)
    "Constant power demand on phase 2"
    annotation(Placement(transformation(extent={{60,60},{80,80}})));

  Modelica.Blocks.Sources.Constant pow3(
    k=-75e3)
    "Constant power demand on phase 3"
    annotation(Placement(transformation(extent={{60,20},{80,40}})));

  Modelica.Units.SI.Voltage vSumSol[2] =
    groTraSol.terminal.phase[1].v + groTraSol.terminal.phase[2].v + groTraSol.terminal.phase[3].v
    "Sum of secondary phase-to-ground voltage phasors for solidly grounded branch";

  Modelica.Units.SI.Voltage vSumRes[2] =
    groTraRes.terminal.phase[1].v + groTraRes.terminal.phase[2].v + groTraRes.terminal.phase[3].v
    "Sum of secondary phase-to-ground voltage phasors for resistance-grounded branch";

  Modelica.Units.SI.Voltage dV[3] = senSol.V - senRes.V
    "Difference in line-to-line RMS voltages between solidly and resistance-grounded branches";

equation
  connect(souSol.terminal, traSol.terminal_n)
    annotation(Line(points={{-90,0},{-70,0}},   color={0,120,120}));
  connect(traSol.terminal_p, linSol.terminal_n)
    annotation(Line(points={{-50,0},{-20,0}}, color={0,120,120}));
  connect(groTraSol.terminal, traSol.terminal_p)
    annotation(Line(points={{-34,-18},{-34,0},{-50,0}},  color={0,120,120}));
  connect(linSol.terminal_p, loaSol.terminal)
    annotation(Line(points={{0,0},{30,0}},    color={0,120,120}));
  connect(senSol.term, loaSol.terminal)
    annotation(Line(points={{14,21},{14,0},{30,0}},   color={0,120,120}));

  connect(souRes.terminal, traRes.terminal_n)
    annotation(Line(points={{-90,-80},{-70,-80}}, color={0,120,120}));
  connect(traRes.terminal_p, linRes.terminal_n)
    annotation(Line(points={{-50,-80},{-20,-80}},
                                                color={0,120,120}));
  connect(groTraRes.terminal, traRes.terminal_p)
    annotation(Line(points={{-34,-98},{-34,-80},{-50,-80}}, color={0,120,120}));
  connect(linRes.terminal_p, loaRes.terminal)
    annotation(Line(points={{0,-80},{30,-80}},  color={0,120,120}));
  connect(senRes.term, loaRes.terminal)
    annotation(Line(points={{14,-59},{14,-80},{30,-80}}, color={0,120,120}));

  connect(pow1.y, loaSol.Pow1)
    annotation(Line(points={{81,110},{108,110},{108,8},{52,8}},
                                                              color={0,0,127}));
  connect(pow2.y, loaSol.Pow2)
    annotation(Line(points={{81,70},{90,70},{90,0},{52,0}},     color={0,0,127}));
  connect(pow3.y, loaSol.Pow3)
    annotation(Line(points={{81,30},{100,30},{100,-8},{52,-8}}, color={0,0,127}));

  connect(pow1.y, loaRes.Pow1)
    annotation(Line(points={{81,110},{108,110},{108,-72},{52,-72}},
                                                                color={0,0,127}));
  connect(pow2.y, loaRes.Pow2)
    annotation(Line(points={{81,70},{90,70},{90,-80},{52,-80}},   color={0,0,127}));
  connect(pow3.y, loaRes.Pow3)
    annotation(Line(points={{81,30},{100,30},{100,-88},{52,-88}}, color={0,0,127}));

  assert(vSumSol*vSumSol < 1e-4,
    "Sum of phase-to-ground voltages on solidly grounded delta secondary must be zero.");
  assert(vSumRes*vSumRes < 1e-4,
    "Sum of phase-to-ground voltages on resistance-grounded delta secondary must be zero.");
  assert(groTraSol.iNeu*groTraSol.iNeu < 1e-4,
    "Neutral current in solidly grounded transformer must be zero during unfaulted operation.");
  assert(groTraRes.iNeu*groTraRes.iNeu < 1e-4,
    "Neutral current in resistance-grounded transformer must be zero during unfaulted operation.");
  assert(abs(groTraSol.P) < 1e-4,
    "Active power dissipated in solidly grounded transformer must be zero.");
  assert(abs(groTraRes.P) < 1e-4,
    "Active power dissipated in resistance-grounded transformer must be zero.");
  assert(dV*dV < 1e-4,
    "Line-to-line load voltages must match between solidly and resistance-grounded branches.");

  annotation(
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Sources/Validation/GroundingTransformer.mos"
      "Simulate and plot"),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-140},{120,140}})),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}})),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.GroundingTransformer\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.GroundingTransformer</a>
on an unbalanced three-wire delta secondary feeder under both solid grounding
with <code>R = 0</code> and high-resistance grounding with <code>R &gt; 0</code>.
</p>
<p>
Each branch consists of a medium-voltage source, a delta-delta step-down
transformer, an asymmetric three-wire line, and a delta-connected inductive
load with time-varying unbalanced power demand across the three phases.
Assertions verify that both grounding configurations fix the zero-sequence
secondary voltage to zero, draw zero phase and neutral current during
unfaulted unbalanced operation, dissipate zero active power, and produce
identical line-to-line voltages at the load.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 22, 2026, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2217\">IBPSA, #2217</a>
and
<a href=\"https://github.com/OpenModelica/OpenModelica/issues/10968\">OpenModelica, #10968</a>.
</li>
</ul>
</html>"));
end GroundingTransformer;
