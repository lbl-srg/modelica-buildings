within Buildings.Electrical.AC.OnePhase.Lines;
model TwoPortRLC "Model of an RLC element with two electrical ports"
  extends Buildings.Electrical.Transmission.BaseClasses.PartialTwoPortRLC(
    V_nominal = 120,
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal_n(redeclare package PhaseSystem =
          PhaseSystem_n),
    redeclare Interfaces.Terminal_p terminal_p(redeclare package PhaseSystem =
          PhaseSystem_p));
  parameter Buildings.Electrical.Types.Assumption mode(
    min=Buildings.Electrical.Types.Assumption.FixedZ_steady_state,
    max=Buildings.Electrical.Types.Assumption.FixedZ_dynamic)=Buildings.Electrical.Types.Assumption.FixedZ_steady_state
    annotation(Evaluate=true,Dialog(group="Modelling assumption"));
protected
  Modelica.SIunits.Voltage Vc[2](start = {V_nominal,0});
  Modelica.SIunits.Current Ic[2];
  Modelica.SIunits.AngularVelocity omega;
equation

  omega = der(PhaseSystem_p.thetaRef(terminal_p.theta));

  terminal_p.i + terminal_n.i = Ic;

  L/2*omega*Buildings.Electrical.PhaseSystems.OnePhase.j(terminal_p.i) +
    terminal_p.i*diagonal(ones(PhaseSystem_p.n)*R_actual/2) = terminal_p.v - Vc;
  L/2*omega*Buildings.Electrical.PhaseSystems.OnePhase.j(terminal_n.i) +
    terminal_n.i*diagonal(ones(PhaseSystem_n.n)*R_actual/2) = terminal_n.v - Vc;

  if C > 0 then
    if mode == Buildings.Electrical.Types.Assumption.FixedZ_dynamic then
      // Dynamic of the system
      C*der(Vc) + omega*C*Buildings.Electrical.PhaseSystems.OnePhase.j(Vc) = Ic;
    else
      // steady state relationship
      omega*C*Buildings.Electrical.PhaseSystems.OnePhase.j(Vc) = Ic;
    end if;
  else
    // No capacitive effect, the voltage in the middle of the line is the linear
    // interpolation of the two phasors
    Vc = (terminal_p.v + terminal_n.v)/2;
  end if;

  annotation (Diagram(graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,0}),
          Line(points={{-90,0},{-70,0}}, color={0,0,0}),
          Line(points={{70,0},{90,0}}, color={0,0,0})}),     Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-140,80},{140,40}},
            lineColor={0,120,120},
          textString="%name")}),
    Documentation(info="<html>
<p>
This model represents a series of two resistive-inductive impedances and a capacitance
that connect two AC single phase interfaces.
This model can be used to represent a cable in a AC grid.
</p>
<p>
The model represents the lumped resistances and capacity (T-model) as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/OnePhase/Lines/twoPortRLC.png\"/>
</p>
<p>
As can be seen in the figure, the resistance <i>R</i> and the inductance <i>L</i> are split in two halves
and the capacitance is located in the center.
The capacitance in the center is optional and can be selected using the
boolean flag <code>use_C = true</code>. The model is either dynamic or static depending on the
presence of the capacitive effect.
</p>
</html>"));
end TwoPortRLC;
