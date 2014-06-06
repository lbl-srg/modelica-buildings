within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
model TwoPortMatrixRL
  "This model represents a model of a line parametrized using matrices (just RL elements)"
  import Buildings;
  Interfaces.Terminal_n terminal_n
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.Terminal_p terminal_p
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  parameter Modelica.SIunits.Impedance Z11[2] = {1,1}
    "Element [1,1] of impedance matrix";
  parameter Modelica.SIunits.Impedance Z12[2] = {1,1}
    "Element [1,2] of impedance matrix";
  parameter Modelica.SIunits.Impedance Z13[2] = {1,1}
    "Element [1,3] of impedance matrix";
  parameter Modelica.SIunits.Impedance Z22[2] = {1,1}
    "Element [2,2] of impedance matrix";
  parameter Modelica.SIunits.Impedance Z23[2] = {1,1}
    "Element [2,3] of impedance matrix";
  parameter Modelica.SIunits.Impedance Z33[2] = {1,1}
    "Element [3,3] of impedance matrix";
  final parameter Modelica.SIunits.Impedance[2] Z21 = Z12
    "Element [2,1] of impedance matrix";
  final parameter Modelica.SIunits.Impedance[2] Z31 = Z13
    "Element [3,1] of impedance matrix";
  final parameter Modelica.SIunits.Impedance[2] Z32 = Z23
    "Element [3,1] of impedance matrix";
protected
  function product = Buildings.Electrical.PhaseSystems.OnePhase.product
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
  terminal_n.phase[1].v - terminal_p.phase[1].v = product(Z11, terminal_n.phase[1].i)
                                                + product(Z12, terminal_n.phase[2].i)
                                                + product(Z13, terminal_n.phase[3].i);
  terminal_n.phase[2].v - terminal_p.phase[2].v = product(Z21, terminal_n.phase[1].i)
                                                + product(Z22, terminal_n.phase[2].i)
                                                + product(Z23, terminal_n.phase[3].i);
  terminal_n.phase[3].v - terminal_p.phase[3].v = product(Z31, terminal_n.phase[1].i)
                                                + product(Z32, terminal_n.phase[2].i)
                                                + product(Z33, terminal_n.phase[3].i);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
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
            lineColor={0,120,120},
          textString="%name"),
          Text(
            extent={{-70,10},{70,-10}},
            lineColor={0,0,0},
          textString="R+jX 3x3")}),
    Documentation(revisions="<html>
<ul>
<li>
June 5, 2014, by Marco Bonvini:<br/>
Added model.
</li>
</ul>
</html>"));
end TwoPortMatrixRL;
