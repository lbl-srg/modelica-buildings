within Buildings.Electrical.AC.OnePhase.Lines;
model TwoPortResistance "Model of a resistance with two electrical ports"
  extends
    Buildings.Electrical.Transmission.BaseClasses.PartialTwoPortResistance(
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal_n,
    redeclare replaceable Interfaces.Terminal_p terminal_p);
equation
  terminal_p.v - terminal_n.v = terminal_p.i*diagonal(ones(PhaseSystem_p.n)*R_actual);

  // Joule losses
  LossPower = R_actual*(terminal_p.i[1]^2 + terminal_p.i[2]^2);
  annotation (
    defaultComponentName="lineR",
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,0}),
          Line(points={{-90,0},{-70,0}}, color={0,0,0}),
          Line(points={{70,0},{90,0}}, color={0,0,0})}),     Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-140,80},{140,40}},
            textColor={0,0,0},
          textString="%name")}),
    Documentation(
info="<html>
<p>
This model represents a resistance that connects two AC one phase interfaces.
This model can be used to represent a single phase cable in a AC grid.
</p>
<p>
The model represents the lumped resistance as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/OnePhase/Lines/twoPortR.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
January 29, 2019, by Michael Wetter:<br/>
Added <code>replaceable</code> for terminal.
</li>
<li>
January 14, 2015, by Marco Bonvini:<br/>
Added equation that represents Joule losses
</li>
<li>
August 5, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
</ul>
</html>"));
end TwoPortResistance;
