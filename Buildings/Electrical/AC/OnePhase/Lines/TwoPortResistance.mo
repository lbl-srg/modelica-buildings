within Buildings.Electrical.AC.OnePhase.Lines;
model TwoPortResistance "Model of a resistance with two electrical ports"
  extends
    Buildings.Electrical.Transmission.BaseClasses.PartialTwoPortResistance(
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal_n(
      redeclare package PhaseSystem = PhaseSystem_n),
    redeclare Interfaces.Terminal_p terminal_p(
      redeclare package PhaseSystem = PhaseSystem_p));
equation

  terminal_p.v - terminal_n.v = terminal_p.i*diagonal(ones(PhaseSystem_p.n)*R_actual);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,0}),
          Line(points={{-90,0},{-70,0}}, color={0,0,0}),
          Line(points={{70,0},{90,0}}, color={0,0,0})}),     Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-140,80},{140,40}},
            lineColor={0,120,120},
          textString="%name")}),
    Documentation(
    defaultComponentName="res",
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
August 5, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
</ul>
</html>"));
end TwoPortResistance;
