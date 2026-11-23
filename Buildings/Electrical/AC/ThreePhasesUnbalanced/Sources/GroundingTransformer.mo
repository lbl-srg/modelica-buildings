within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;

model GroundingTransformer "Three-phase zig-zag grounding transformer with optional neutral resistance"
  parameter Modelica.Units.SI.Resistance R(min = 0) = 0 "Neutral-to-ground resistance";
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Terminal_n terminal "Three-phase electrical connector" annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {0, 100}), iconTransformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {0, 100})));
  Modelica.Units.SI.Voltage vNeu[2] "Derived neutral-to-ground voltage phasor";
  Modelica.Units.SI.Current i0[2] "Zero-sequence current phasor entering each phase";
  Modelica.Units.SI.Current iNeu[2] "Neutral current phasor flowing to ground";
  Modelica.Units.SI.ActivePower P "Active power dissipated in the neutral grounding resistance";
equation
  for k in 1:3 loop
    terminal.phase[k].i = i0;
  end for;
  iNeu = 3*i0;
  3*vNeu = terminal.phase[1].v + terminal.phase[2].v + terminal.phase[3].v;
  vNeu = R*iNeu;
  P = Buildings.Electrical.PhaseSystems.OnePhase.activePower(vNeu, iNeu);
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Ellipse(extent = {{-50, 60}, {50, -40}}, lineColor = {0, 120, 120}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Line(points = {{0, 90}, {0, 60}}, color = {0, 120, 120}, smooth = Smooth.None), Line(points = {{0, 10}, {0, 32}, {12, 38}}, color = {0, 120, 120}, smooth = Smooth.None), Line(points = {{0, 10}, {-18, -2}, {-18, -16}}, color = {0, 120, 120}, smooth = Smooth.None), Line(points = {{0, 10}, {18, -2}, {6, -14}}, color = {0, 120, 120}, smooth = Smooth.None), Line(points = {{0, -40}, {0, -60}}, color = {0, 120, 120}, smooth = Smooth.None), Line(points = {{-40, -60}, {40, -60}}, color = {0, 120, 120}, smooth = Smooth.None), Line(points = {{-28, -74}, {28, -74}}, color = {0, 120, 120}, smooth = Smooth.None), Line(points = {{-16, -88}, {16, -88}}, color = {0, 120, 120}, smooth = Smooth.None), Text(extent = {{-120, -92}, {120, -132}}, textColor = {0, 0, 255}, textString = "%name")}),
    defaultComponentName = "groTra",
    Documentation(info = "<html>
<p>
This model represents an ideal three-phase zig-zag grounding transformer
that establishes a derived neutral reference to earth ground for three-wire
three-phase AC networks without a neutral conductor, such as delta-connected
transformer secondaries. An unloaded grounded-wye to delta grounding
transformer bank obeys the same terminal equations.
</p>
<p>
In a three-limb zig-zag grounding transformer, each phase terminal is connected
to the common neutral point through two identical half-windings placed on
different magnetic core limbs and wound in phase opposition. Neglecting core
magnetizing current and winding leakage impedance, Faraday's law across the
three interconnected phase paths yields
</p>
<p align=\"center\" style=\"font-style:italic;\">
3 v<sub>Neu</sub> = v<sub>1</sub> + v<sub>2</sub> + v<sub>3</sub>,
</p>
<p>
where <code>vNeu</code> is the derived neutral-to-ground voltage phasor and
<code>v<sub>k</sub></code> is the phase-to-ground voltage phasor at
<code>terminal.phase[k].v</code>. Magnetomotive force balance on each of the
three core limbs requires equal zero-sequence currents in all three phases,
</p>
<p align=\"center\" style=\"font-style:italic;\">
i<sub>1</sub> = i<sub>2</sub> = i<sub>3</sub> = i<sub>0</sub>,
</p>
<p>
with total neutral current <code>iNeu = 3*i0</code> flowing to earth ground
through the neutral grounding resistance <code>R</code> according to
</p>
<p align=\"center\" style=\"font-style:italic;\">
v<sub>Neu</sub> = R i<sub>Neu</sub>.
</p>
<p>
Consequently, the component presents infinite impedance to positive-sequence
and negative-sequence currents and draws zero current and zero power during
normal balanced or unbalanced phase-to-phase operation. For zero-sequence
currents, the opposing half-winding magnetomotive forces cancel on every core
limb. Setting <code>R = 0</code> models a solidly grounded zig-zag transformer
with <code>vNeu = {0, 0}</code>. Setting <code>R &gt; 0</code> models a
low-resistance or high-resistance grounded zig-zag transformer that limits
zero-sequence current during single-line-to-ground faults. Because winding
leakage impedance is neglected, at most one solidly grounded instance with
<code>R = 0</code> should be connected directly to a given bus unless separated
by line or transformer impedance.
</p>
</html>", revisions = "<html>
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
</html>"));end GroundingTransformer;