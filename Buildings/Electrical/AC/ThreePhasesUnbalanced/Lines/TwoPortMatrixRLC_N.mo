within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
model TwoPortMatrixRLC_N
  "PI model of a line parameterized with impedance and admittance matrices and neutral line"
  extends Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.TwoPort_N(
    terminal_p(phase(v(each nominal = V_nominal))),
    terminal_n(phase(v(each nominal = V_nominal))));

  parameter Modelica.Units.SI.Voltage V_nominal(min=0, start=480)
    "Nominal voltage (V_nominal >= 0)"
    annotation (Evaluate=true, Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.Impedance Z11[2]
    "Element [1,1] of impedance matrix";
  parameter Modelica.Units.SI.Impedance Z12[2]
    "Element [1,2] of impedance matrix";
  parameter Modelica.Units.SI.Impedance Z13[2]
    "Element [1,3] of impedance matrix";
  parameter Modelica.Units.SI.Impedance Z14[2]
    "Element [1,4] of impedance matrix";
  parameter Modelica.Units.SI.Impedance Z22[2]
    "Element [2,2] of impedance matrix";
  parameter Modelica.Units.SI.Impedance Z23[2]
    "Element [2,3] of impedance matrix";
  parameter Modelica.Units.SI.Impedance Z24[2]
    "Element [2,4] of impedance matrix";
  parameter Modelica.Units.SI.Impedance Z33[2]
    "Element [3,3] of impedance matrix";
  parameter Modelica.Units.SI.Impedance Z34[2]
    "Element [3,4] of impedance matrix";
  parameter Modelica.Units.SI.Impedance Z44[2]
    "Element [4,4] of impedance matrix";
  final parameter Modelica.Units.SI.Impedance[2] Z21=Z12
    "Element [2,1] of impedance matrix";
  final parameter Modelica.Units.SI.Impedance[2] Z31=Z13
    "Element [3,1] of impedance matrix";
  final parameter Modelica.Units.SI.Impedance[2] Z32=Z23
    "Element [3,1] of impedance matrix";
  final parameter Modelica.Units.SI.Impedance[2] Z41=Z14
    "Element [4,1] of impedance matrix";
  final parameter Modelica.Units.SI.Impedance[2] Z42=Z24
    "Element [4,2] of impedance matrix";
  final parameter Modelica.Units.SI.Impedance[2] Z43=Z34
    "Element [4,3] of impedance matrix";

  parameter Modelica.Units.SI.Admittance B11
    "Element [1,1] of admittance matrix";
  parameter Modelica.Units.SI.Admittance B12
    "Element [1,2] of admittance matrix";
  parameter Modelica.Units.SI.Admittance B13
    "Element [1,3] of admittance matrix";
  parameter Modelica.Units.SI.Admittance B14
    "Element [1,4] of admittance matrix";
  parameter Modelica.Units.SI.Admittance B22
    "Element [2,2] of admittance matrix";
  parameter Modelica.Units.SI.Admittance B23
    "Element [2,3] of admittance matrix";
  parameter Modelica.Units.SI.Admittance B24
    "Element [2,4] of admittance matrix";
  parameter Modelica.Units.SI.Admittance B33
    "Element [3,3] of admittance matrix";
  parameter Modelica.Units.SI.Admittance B34
    "Element [3,4] of admittance matrix";
  parameter Modelica.Units.SI.Admittance B44
    "Element [4,4] of admittance matrix";
  final parameter Modelica.Units.SI.Admittance B21=B12
    "Element [2,1] of admittance matrix";
  final parameter Modelica.Units.SI.Admittance B31=B13
    "Element [3,1] of admittance matrix";
  final parameter Modelica.Units.SI.Admittance B32=B23
    "Element [3,2] of admittance matrix";
  final parameter Modelica.Units.SI.Admittance B41=B14
    "Element [4,1] of admittance matrix";
  final parameter Modelica.Units.SI.Admittance B42=B24
    "Element [4,2] of admittance matrix";
  final parameter Modelica.Units.SI.Admittance B43=B34
    "Element [4,3] of admittance matrix";

  Modelica.Units.SI.Voltage v1_n[2](
    start=Buildings.Electrical.PhaseSystems.OnePhase.phaseVoltages(V_nominal/
        sqrt(3), phi=0),
    each stateSelect=StateSelect.never) = terminal_n.phase[1].v
    "Voltage in line 1 at connector N";
  Modelica.Units.SI.Voltage v2_n[2](
    start=Buildings.Electrical.PhaseSystems.OnePhase.phaseVoltages(V_nominal/
        sqrt(3), phi=-2*Modelica.Constants.pi/3),
    each stateSelect=StateSelect.never) = terminal_n.phase[2].v
    "Voltage in line 2 at connector N";
  Modelica.Units.SI.Voltage v3_n[2](
    start=Buildings.Electrical.PhaseSystems.OnePhase.phaseVoltages(V_nominal/
        sqrt(3), phi=2*Modelica.Constants.pi/3),
    each stateSelect=StateSelect.never) = terminal_n.phase[3].v
    "Voltage in line 3 at connector N";
  Modelica.Units.SI.Voltage v4_n[2](
    start=Buildings.Electrical.PhaseSystems.OnePhase.phaseVoltages(0),
    each stateSelect=StateSelect.never) = terminal_n.phase[4].v
    "Voltage in line 4 (neutral) at connector N";
  Modelica.Units.SI.Voltage v1_p[2](
    start=Buildings.Electrical.PhaseSystems.OnePhase.phaseVoltages(V_nominal/
        sqrt(3), phi=0),
    each stateSelect=StateSelect.never) = terminal_p.phase[1].v
    "Voltage in line 1 at connector P";
  Modelica.Units.SI.Voltage v2_p[2](
    start=Buildings.Electrical.PhaseSystems.OnePhase.phaseVoltages(V_nominal/
        sqrt(3), phi=-2*Modelica.Constants.pi/3),
    each stateSelect=StateSelect.never) = terminal_p.phase[2].v
    "Voltage in line 2 at connector P";
  Modelica.Units.SI.Voltage v3_p[2](
    start=Buildings.Electrical.PhaseSystems.OnePhase.phaseVoltages(V_nominal/
        sqrt(3), phi=2*Modelica.Constants.pi/3),
    each stateSelect=StateSelect.never) = terminal_p.phase[3].v
    "Voltage in line 3 at connector P";
  Modelica.Units.SI.Voltage v4_p[2](
    start=Buildings.Electrical.PhaseSystems.OnePhase.phaseVoltages(0),
    each stateSelect=StateSelect.never) = terminal_p.phase[4].v
    "Voltage in line 4 (neutral) at connector P";

protected
  function productAC1p = Buildings.Electrical.PhaseSystems.OnePhase.product
    "Product between complex quantities";
  Modelica.Units.SI.Current Isr[4,2](each stateSelect=StateSelect.prefer)
    "Currents that pass through the lines";
  Modelica.Units.SI.Current Ish_p[4,2](each stateSelect=StateSelect.prefer)
    "Shunt current on side p";
  Modelica.Units.SI.Current Ish_n[4,2](each stateSelect=StateSelect.prefer)
    "Shunt current on side n";

equation

  // Link the connectors to propagate the overdetermined variable
  for i in 1:4 loop
      Connections.branch(terminal_p.phase[i].theta, terminal_n.phase[i].theta);
      terminal_p.phase[i].theta = terminal_n.phase[i].theta;
  end for;

  // Kirkoff current law for the terminal n (left side)
  Isr[1,:] = terminal_n.phase[1].i - Ish_n[1,:];
  Isr[2,:] = terminal_n.phase[2].i - Ish_n[2,:];
  Isr[3,:] = terminal_n.phase[3].i - Ish_n[3,:];
  Isr[4,:] = terminal_n.phase[4].i - Ish_n[4,:];

  // Kirkoff current law for the terminal p (right side)
  Isr[1,:] + terminal_p.phase[1].i = Ish_p[1,:];
  Isr[2,:] + terminal_p.phase[2].i = Ish_p[2,:];
  Isr[3,:] + terminal_p.phase[3].i = Ish_p[3,:];
  Isr[4,:] + terminal_p.phase[4].i = Ish_p[4,:];

  // Voltage drop caused by the impedance matrix
  terminal_n.phase[1].v - terminal_p.phase[1].v = productAC1p(Z11, terminal_n.phase[1].i)
                                                + productAC1p(Z12, terminal_n.phase[2].i)
                                                + productAC1p(Z13, terminal_n.phase[3].i)
                                                + productAC1p(Z14, terminal_n.phase[4].i);
  terminal_n.phase[2].v - terminal_p.phase[2].v = productAC1p(Z21, terminal_n.phase[1].i)
                                                + productAC1p(Z22, terminal_n.phase[2].i)
                                                + productAC1p(Z23, terminal_n.phase[3].i)
                                                + productAC1p(Z24, terminal_n.phase[4].i);
  terminal_n.phase[3].v - terminal_p.phase[3].v = productAC1p(Z31, terminal_n.phase[1].i)
                                                + productAC1p(Z32, terminal_n.phase[2].i)
                                                + productAC1p(Z33, terminal_n.phase[3].i)
                                                + productAC1p(Z34, terminal_n.phase[4].i);
  terminal_n.phase[4].v - terminal_p.phase[4].v = productAC1p(Z41, terminal_n.phase[1].i)
                                                + productAC1p(Z42, terminal_n.phase[2].i)
                                                + productAC1p(Z43, terminal_n.phase[3].i)
                                                + productAC1p(Z44, terminal_n.phase[4].i);

  // Current loss at the terminal n
  Ish_n[1,:] = productAC1p({0, B11/2}, v1_n)
             + productAC1p({0, B12/2}, v2_n)
             + productAC1p({0, B13/2}, v3_n)
             + productAC1p({0, B14/2}, v4_n);
  Ish_n[2,:] = productAC1p({0, B21/2}, v1_n)
             + productAC1p({0, B22/2}, v2_n)
             + productAC1p({0, B23/2}, v3_n)
             + productAC1p({0, B24/2}, v4_n);
  Ish_n[3,:] = productAC1p({0, B31/2}, v1_n)
             + productAC1p({0, B32/2}, v2_n)
             + productAC1p({0, B33/2}, v3_n)
             + productAC1p({0, B34/2}, v4_n);
  Ish_n[4,:] = productAC1p({0, B41/2}, v1_n)
             + productAC1p({0, B42/2}, v2_n)
             + productAC1p({0, B43/2}, v3_n)
             + productAC1p({0, B44/2}, v4_n);

  // Current loss at the terminal n
  Ish_p[1,:] = productAC1p({0, B11/2}, v1_p)
             + productAC1p({0, B12/2}, v2_p)
             + productAC1p({0, B13/2}, v3_p)
             + productAC1p({0, B14/2}, v4_p);
  Ish_p[2,:] = productAC1p({0, B21/2}, v1_p)
             + productAC1p({0, B22/2}, v2_p)
             + productAC1p({0, B23/2}, v3_p)
             + productAC1p({0, B24/2}, v4_p);
  Ish_p[3,:] = productAC1p({0, B31/2}, v1_p)
             + productAC1p({0, B32/2}, v2_p)
             + productAC1p({0, B33/2}, v3_p)
             + productAC1p({0, B34/2}, v4_p);
  Ish_p[4,:] = productAC1p({0, B41/2}, v1_p)
             + productAC1p({0, B42/2}, v2_p)
             + productAC1p({0, B43/2}, v3_p)
             + productAC1p({0, B44/2}, v4_p);

  annotation (
  defaultComponentName="line",
 Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                               graphics={
          Line(points={{-92,0},{-72,0}}, color={0,0,0}),
          Line(points={{68,0},{88,0}}, color={0,0,0}),
        Rectangle(
          extent={{-72,40},{70,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Text(
            extent={{-140,100},{140,60}},
            textColor={0,0,0},
          textString="%name"),
          Text(
            extent={{-72,30},{70,10}},
            textColor={0,0,0},
          textString="R+jX 4x4"),
          Text(
            extent={{-72,-10},{70,-30}},
            textColor={0,0,0},
          textString="C 4x4")}),
    Documentation(revisions="<html>
<ul>
<li>
April 5, 2023, by Michael Wetter:<br/>
Set nominal attribute for voltage at terminal.
</li>
<li>
November 28, 2016, by Michael Wetter:<br/>
Made current and voltage public to allow setting start values.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/584\">#584</a>.
</li>
<li>
November 28, 2016, by Michael Wetter:<br/>
Removed zero start value for currents <code>i1</code>, <code>i2</code> and
<code>i3</code>.
Setting a zero start value led Dymola 2017 on Linux to find a different solution
for
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.BalancedStepDown.YD\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.BalancedStepDown.YD</a>.
Also, the current is typically non-zero and zero is anyway the default start value, hence there is no need to set it.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/584\">#584</a>.
</li>
<li>
January 14, 2015, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>", info="<html>
<p>
RLC line model (&pi;-model) that connects two AC three-phase
unbalanced interfaces and neutral line. This model can be used to represent a
cable in a three-phase unbalanced AC system.
</p>

<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Lines/twoPortRLCMatrix_N.png\"/>
</p>

<p>
The model is parameterized with an impedance matrix <i>Z</i> and
an admittance matrix <i>B</i>.
The impedance matrix is symmetric, and therefore only the upper triangular
part of the matrix needs to be defined.
</p>

<p>
This model is a more detailed version of the model <a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortMatrixRL_N\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortMatrixRL_N</a> that includes
the capacitive effects of the lines.
</p>

<h4>Note</h4>
<p>
The fourth line is the neutral one.
</p>

</html>"));
end TwoPortMatrixRLC_N;
