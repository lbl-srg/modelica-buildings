within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
model TwoPortMatrixRL
  "Model of an RL line parameterized with impedance matrices"
  extends Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.TwoPort(
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
  parameter Modelica.Units.SI.Impedance Z22[2]
    "Element [2,2] of impedance matrix";
  parameter Modelica.Units.SI.Impedance Z23[2]
    "Element [2,3] of impedance matrix";
  parameter Modelica.Units.SI.Impedance Z33[2]
    "Element [3,3] of impedance matrix";
  final parameter Modelica.Units.SI.Impedance[2] Z21=Z12
    "Element [2,1] of impedance matrix";
  final parameter Modelica.Units.SI.Impedance[2] Z31=Z13
    "Element [3,1] of impedance matrix";
  final parameter Modelica.Units.SI.Impedance[2] Z32=Z23
    "Element [3,1] of impedance matrix";

  Modelica.Units.SI.Current i1[2](each stateSelect=StateSelect.prefer)=
    terminal_n.phase[1].i "Current in line 1";
  Modelica.Units.SI.Current i2[2](each stateSelect=StateSelect.prefer)=
    terminal_n.phase[2].i "Current in line 2";
  Modelica.Units.SI.Current i3[2](each stateSelect=StateSelect.prefer)=
    terminal_n.phase[3].i "Current in line 3";
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

protected
  function productAC1p = Buildings.Electrical.PhaseSystems.OnePhase.product
    "Product between complex quantities";
equation

  // Link the connectors to propagate the overdetermined variable
  for i in 1:3 loop
      Connections.branch(terminal_p.phase[i].theta, terminal_n.phase[i].theta);
      terminal_p.phase[i].theta = terminal_n.phase[i].theta;

      // No current losses, they are preserved in each line
      terminal_p.phase[i].i = - terminal_n.phase[i].i;
  end for;

  // Voltage drop caused by the impedance matrix
  v1_n - v1_p = productAC1p(Z11, i1) + productAC1p(Z12, i2) + productAC1p(Z13, i3);
  v2_n - v2_p = productAC1p(Z21, i1) + productAC1p(Z22, i2) + productAC1p(Z23, i3);
  v3_n - v3_p = productAC1p(Z31, i1) + productAC1p(Z32, i2) + productAC1p(Z33, i3);

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
        Rectangle(
          extent={{-26,16},{10,4}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
            extent={{-140,100},{140,60}},
            textColor={0,0,0},
          textString="%name"),
          Text(
            extent={{-70,10},{70,-10}},
            textColor={0,0,0},
          textString="R+jX 3x3")}),
    Documentation(revisions="<html>
<ul>
<li>
April 5, 2022, by Michael Wetter:<br/>
Set nominal attribute for voltage at terminals.
This is required for
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.UnbalancedStepUp.DD\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.UnbalancedStepUp.DD</a>
to converge with Dymola 2023 beta3.
Inspecting the homotopy trajectory showed that this variable diverged to an unreasonable value.
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
Made current and voltage public to allow setting start values.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/584\">#584</a>.
</li>
<li>
October 6, 2014, by Marco Bonvini:<br/>
Revised documentation and model.
</li>
<li>
June 5, 2014, by Marco Bonvini:<br/>
Added model.
</li>
</ul>
</html>", info="<html>
<p>
Resistive-inductive model that connects two AC three-phase
unbalanced interfaces. This model can be used to represent a
cable in a three-phase unbalanced AC system.
The voltage between the ports is
</p>

<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Lines/twoPortRLMatrix.png\"/>
</p>

<p>
where <i>V<sub>i</sub><sup>{p,n}</sup></i> is the voltage phasor at the connector <code>p</code> or
<code>n</code> of the <i>i</i>-th phase, while <i>I<sub>i</sub><sup>p</sup></i>
the current phasor entering from the connector <code>p</code> of the <i>i</i>-th phase.
</p>

<p>
The model is parameterized with an impedance matrix <i>Z</i>.
The matrix is symmetric thus just the upper triangular
part of it has to be defined.
</p>

</html>"));
end TwoPortMatrixRL;
