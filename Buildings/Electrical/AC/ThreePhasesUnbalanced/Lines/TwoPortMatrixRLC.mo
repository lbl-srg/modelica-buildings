within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
model TwoPortMatrixRLC
  "PI model of a line parameterized with impedance and admittance matrices"
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

  parameter Modelica.Units.SI.Admittance B11
    "Element [1,1] of admittance matrix";
  parameter Modelica.Units.SI.Admittance B12
    "Element [1,2] of admittance matrix";
  parameter Modelica.Units.SI.Admittance B13
    "Element [1,3] of admittance matrix";
  parameter Modelica.Units.SI.Admittance B22
    "Element [2,2] of admittance matrix";
  parameter Modelica.Units.SI.Admittance B23
    "Element [2,3] of admittance matrix";
  parameter Modelica.Units.SI.Admittance B33
    "Element [3,3] of admittance matrix";
  final parameter Modelica.Units.SI.Admittance B21=B12
    "Element [2,1] of admittance matrix";
  final parameter Modelica.Units.SI.Admittance B31=B13
    "Element [3,1] of admittance matrix";
  final parameter Modelica.Units.SI.Admittance B32=B23
    "Element [3,2] of admittance matrix";

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
  Modelica.Units.SI.Current Isr[3,2](start=zeros(3, Buildings.Electrical.PhaseSystems.OnePhase.n),
      each stateSelect=StateSelect.prefer)
    "Currents that pass through the lines";
  Modelica.Units.SI.Current Ish_p[3,2](start=zeros(3, Buildings.Electrical.PhaseSystems.OnePhase.n),
      each stateSelect=StateSelect.prefer) "Shunt current on side p";
  Modelica.Units.SI.Current Ish_n[3,2](start=zeros(3, Buildings.Electrical.PhaseSystems.OnePhase.n),
      each stateSelect=StateSelect.prefer) "Shunt current on side n";

equation

  // Link the connectors to propagate the overdetermined variable
  for i in 1:3 loop
      Connections.branch(terminal_p.phase[i].theta, terminal_n.phase[i].theta);
      terminal_p.phase[i].theta = terminal_n.phase[i].theta;
  end for;

  // Kirkoff current law for the terminal n (left side)
  Isr[1,:] = terminal_n.phase[1].i - Ish_n[1,:];
  Isr[2,:] = terminal_n.phase[2].i - Ish_n[2,:];
  Isr[3,:] = terminal_n.phase[3].i - Ish_n[3,:];

  // Kirkoff current law for the terminal p (right side)
  Isr[1,:] + terminal_p.phase[1].i = Ish_p[1,:];
  Isr[2,:] + terminal_p.phase[2].i = Ish_p[2,:];
  Isr[3,:] + terminal_p.phase[3].i = Ish_p[3,:];

  // Voltage drop caused by the impedance matrix
  terminal_n.phase[1].v - terminal_p.phase[1].v = productAC1p(Z11, terminal_n.phase[1].i)
                                                + productAC1p(Z12, terminal_n.phase[2].i)
                                                + productAC1p(Z13, terminal_n.phase[3].i);
  terminal_n.phase[2].v - terminal_p.phase[2].v = productAC1p(Z21, terminal_n.phase[1].i)
                                                + productAC1p(Z22, terminal_n.phase[2].i)
                                                + productAC1p(Z23, terminal_n.phase[3].i);
  terminal_n.phase[3].v - terminal_p.phase[3].v = productAC1p(Z31, terminal_n.phase[1].i)
                                                + productAC1p(Z32, terminal_n.phase[2].i)
                                                + productAC1p(Z33, terminal_n.phase[3].i);

  // Current loss at the terminal n
  Ish_n[1,:] = productAC1p({0, B11/2}, v1_n)
             + productAC1p({0, B12/2}, v2_n)
             + productAC1p({0, B13/2}, v3_n);
  Ish_n[2,:] = productAC1p({0, B21/2}, v1_n)
             + productAC1p({0, B22/2}, v2_n)
             + productAC1p({0, B23/2}, v3_n);
  Ish_n[3,:] = productAC1p({0, B31/2}, v1_n)
             + productAC1p({0, B32/2}, v2_n)
             + productAC1p({0, B33/2}, v3_n);

  // Current loss at the terminal n
  Ish_p[1,:] = productAC1p({0, B11/2}, v1_p)
             + productAC1p({0, B12/2}, v2_p)
             + productAC1p({0, B13/2}, v3_p);
  Ish_p[2,:] = productAC1p({0, B21/2}, v1_p)
             + productAC1p({0, B22/2}, v2_p)
             + productAC1p({0, B23/2}, v3_p);
  Ish_p[3,:] = productAC1p({0, B31/2}, v1_p)
             + productAC1p({0, B32/2}, v2_p)
             + productAC1p({0, B33/2}, v3_p);

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
          textString="R+jX 3x3"),
          Text(
            extent={{-72,-10},{70,-30}},
            textColor={0,0,0},
          textString="C 3x3")}),
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
RLC line model (&pi;-model) that connects two AC three-phase
unbalanced interfaces. This model can be used to represent a
cable in a three-phase unbalanced AC system.
</p>

<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Lines/twoPortRLCMatrix.png\"/>
</p>

<p>
The model is parameterized with an impedance matrix <i>Z</i> and
an admittance matrix <i>B</i>.
The impedance matrix is symmetric, and therefore only the upper triangular
part of the matrix needs to be defined.
</p>

<p>
This model is a more detailed version of the model <a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortMatrixRL\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortMatrixRL</a> that includes
the capacitive effects of the lines.
</p>

</html>"));
end TwoPortMatrixRLC;
