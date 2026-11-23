within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.Validation;
model GroundingTransformerFault
  "Validation model for zig-zag grounding transformer under single-line-to-ground fault"
  extends Modelica.Icons.Example;

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.FixedVoltage sou(
    f=60,
    V=480)
    "Primary voltage source"
    annotation(Placement(transformation(extent={{-90,0},{-70,20}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.ACACTransformerDD tra(
    VHigh=480,
    VLow=480,
    VABase=1000e3,
    XoverR=6,
    Zperc=0.04)
    "Delta-delta isolation transformer"
    annotation(Placement(transformation(extent={{-54,0},{-34,20}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.GeneralizedSensor senGnd
    "Sensor measuring grounding transformer voltages, currents, and powers"
    annotation(Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=270,
      origin={-14,-18})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.GroundingTransformer groTra(
    R=25)
    "Resistance-grounded zig-zag grounding transformer"
    annotation(Placement(transformation(extent={{-24,-58},{-4,-38}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.GeneralizedSensor senFau
    "Sensor measuring single-line-to-ground fault current"
    annotation(Placement(transformation(extent={{10,0},{30,20}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.Impedance fau(
    loadConn=Buildings.Electrical.Types.LoadConnection.wye_to_wyeg,
    plugPhase1=true,
    plugPhase2=false,
    plugPhase3=false,
    inductive=true,
    L=0,
    use_R_in=true,
    RMin=5,
    RMax=100)
    "Single-line-to-ground fault impedance on phase 1"
    annotation(Placement(transformation(extent={{60,0},{80,20}})));

  Modelica.Blocks.Sources.Ramp ramR(
    height=-1.0,
    duration=1.0,
    offset=1.0)
    "Ramp decreasing fault resistance from RMax to RMin"
    annotation(Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeDelta senDel(
    perUnit=false,
    V_nominal=480,
    V(each unit="V"))
    "Line-to-line voltage probe on delta bus"
    annotation(Placement(transformation(extent={{-24,36},{-4,56}})));

  Modelica.Units.SI.Voltage VPh[3]
    "Phase-to-ground RMS voltages on secondary bus";

  Modelica.Units.SI.Voltage VNeuRMS
    "Neutral-to-ground RMS voltage";

  Modelica.Units.SI.Current INeuRMS
    "Neutral-to-ground RMS current";

  Modelica.Units.SI.Current IFauRMS
    "Single-line-to-ground fault RMS current";

  Modelica.Units.SI.ActivePower PTerminal
    "Total active power entering the three AC terminals of the grounding transformer";

equation
  connect(sou.terminal, tra.terminal_n)
    annotation(Line(points={{-70,10},{-54,10}}, color={0,120,120}));
  connect(tra.terminal_p, senGnd.terminal_n)
    annotation(Line(points={{-34,10},{-14,10},{-14,-8}}, color={0,120,120}));
  connect(senGnd.terminal_p, groTra.terminal)
    annotation(Line(points={{-14,-28},{-14,-38}}, color={0,120,120}));
  connect(senDel.term, tra.terminal_p)
    annotation(Line(points={{-14,37},{-14,10},{-34,10}}, color={0,120,120}));
  connect(tra.terminal_p, senFau.terminal_n)
    annotation(Line(points={{-34,10},{10,10}}, color={0,120,120}));
  connect(senFau.terminal_p, fau.terminal)
    annotation(Line(points={{30,10},{60,10}}, color={0,120,120}));
  connect(ramR.y, fau.y_R)
    annotation(Line(points={{41,70},{66,70},{66,20}}, color={0,0,127}));

  VPh = senGnd.V;
  VNeuRMS = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(groTra.vNeu);
  INeuRMS = Buildings.Electrical.PhaseSystems.OnePhase.systemCurrent(groTra.iNeu);
  IFauRMS = senFau.I[1];
  PTerminal = sum(senGnd.S[:, 1]);

  assert(abs(INeuRMS - IFauRMS) < 1e-5,
    "Neutral return RMS current must equal single-line-to-ground fault RMS current.");
  assert(abs(senGnd.I[1] - senGnd.I[2]) < 1e-6 and abs(senGnd.I[1] - senGnd.I[3]) < 1e-6,
    "Zero-sequence current must divide equally across all three phases.");
  assert(abs(PTerminal - groTra.P) < 1e-6,
    "Three-phase terminal input power must equal power dissipated in neutral resistance.");
  assert(abs(groTra.P - groTra.R*(groTra.iNeu*groTra.iNeu)) < 1e-6,
    "Active power dissipated in grounding transformer must equal R*|iNeu|^2.");

  annotation(
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Sources/Validation/GroundingTransformerFault.mos"
      "Simulate and plot"),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}})),
    Documentation(
      info="<html>
<p>
This model validates the zero-sequence behavior of
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.GroundingTransformer\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.GroundingTransformer</a>
during a resistive single-line-to-ground fault on phase 1 of a delta-connected
secondary network.
</p>
<p>
As the fault resistance decreases from <code>RMax</code> to <code>RMin</code>,
phase 1 shifts toward earth potential while the unfaulted phase-to-ground
voltages <code>VPh[2]</code> and <code>VPh[3]</code> rise toward the
line-to-line voltage magnitude. The fault current returns entirely through
the grounding transformer neutral resistance <code>R</code>, dividing equally
as <code>i0 = iNeu/3</code> across the three zig-zag phases while preserving
the balanced line-to-line voltages measured by <code>senDel</code>.
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
end GroundingTransformerFault;
