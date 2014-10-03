within Buildings.Electrical.AC.OnePhase.Lines;
model TwoPortRL
  "Model of a resistive-inductive element with two electrical ports"
  extends Buildings.Electrical.Transmission.BaseClasses.PartialTwoPortRLC(
    V_nominal(start = 120),
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p,
    final C=0);
  parameter Buildings.Electrical.Types.Load mode(
    min=Buildings.Electrical.Types.Load.FixedZ_steady_state,
    max=Buildings.Electrical.Types.Load.FixedZ_dynamic) = Buildings.Electrical.Types.Load.FixedZ_steady_state
    "Parameter that specifies the type model (e.g., steady state, dynamic, prescribed power consumption, etc.)"
    annotation (Evaluate=true, Dialog(group="Modelling assumption"));
protected
  Modelica.SIunits.AngularVelocity omega
    "Frequency of the quasi-stationary sine waves";
equation

  omega = der(PhaseSystem_p.thetaRef(terminal_p.theta));

  terminal_p.i = - terminal_n.i;

  if mode==Buildings.Electrical.Types.Load.FixedZ_dynamic then
    // Dynamics of the system
    der(L*terminal_p.i) + L*omega*PhaseSystem_p.j(terminal_p.i) +
      terminal_p.i*diagonal(ones(PhaseSystem_p.n)*R_actual)
       = terminal_p.v - terminal_n.v;

  else
    // steady state relationship
    L*omega*PhaseSystem_p.j(terminal_p.i) +
      terminal_p.i*diagonal(ones(PhaseSystem_p.n)*R_actual)
      = terminal_p.v - terminal_n.v;
  end if;

  annotation (
defaultComponentName="lineRL",
Diagram(graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,0}),
          Line(points={{-90,0},{-70,0}}, color={0,0,0}),
          Line(points={{70,0},{90,0}}, color={0,0,0})}),     Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-140,80},{140,40}},
            lineColor={0,0,0},
          textString="%name")}),
    Documentation(info="<html>
<p>
This model represents a resistance and an inductance connected in series with
two AC one phase interfaces. This model can be used
to represent a single phase cable in a AC grid.
</p>
<p>
The model represents the lumped RL cable as shown in the figure below.
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/OnePhase/Lines/twoPortRL.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
August 5, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
</ul>
</html>"));
end TwoPortRL;
