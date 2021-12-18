within Buildings.Electrical.AC.OnePhase.Lines;
model TwoPortRLC "Model of an RLC element with two electrical ports"
  extends Buildings.Electrical.Transmission.BaseClasses.PartialTwoPortRLC(
    V_nominal(start = 110),
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal_n(
      redeclare package PhaseSystem = PhaseSystem_n),
    redeclare replaceable Interfaces.Terminal_p terminal_p(
      redeclare package PhaseSystem = PhaseSystem_p));
  parameter Modelica.Units.SI.Voltage Vc_start[2]={V_nominal,0}
    "Initial voltage phasor of the capacitance located in the middle of the line"
    annotation (Dialog(enable=(mode == Buildings.Electrical.Types.Load.FixedZ_dynamic)));
  parameter Buildings.Electrical.Types.Load mode(
    min=Buildings.Electrical.Types.Load.FixedZ_steady_state,
    max=Buildings.Electrical.Types.Load.FixedZ_dynamic)=
    Buildings.Electrical.Types.Load.FixedZ_steady_state
    "Type of model (e.g., steady state, dynamic, prescribed power consumption, etc.)"
    annotation (Evaluate=true, Dialog(group="Modeling assumption"));
protected
  Modelica.Units.SI.Voltage Vc[2](start=Vc_start, each stateSelect=StateSelect.prefer)
    "Voltage of the Capacitance located in the middle of the line";
  Modelica.Units.SI.Current Ic[2]
    "Currenbt of the capacitance located in the middle of the line";
  Modelica.Units.SI.AngularVelocity omega
    "Frequency of the quasi-stationary sine waves";
  Modelica.Units.SI.Angle theRef "Absolute angle of rotating reference system";

initial equation
  if C > 0 and mode == Buildings.Electrical.Types.Load.FixedZ_dynamic then
    Vc = Vc_start;
  end if;
equation
  theRef = PhaseSystem_p.thetaRef(terminal_p.theta);
  omega = der(theRef);

  terminal_p.i + terminal_n.i = Ic;

  L/2*omega*Buildings.Electrical.PhaseSystems.OnePhase.j(terminal_p.i) +
    terminal_p.i*diagonal(ones(PhaseSystem_p.n)*R_actual/2) = terminal_p.v - Vc;
  L/2*omega*Buildings.Electrical.PhaseSystems.OnePhase.j(terminal_n.i) +
    terminal_n.i*diagonal(ones(PhaseSystem_n.n)*R_actual/2) = terminal_n.v - Vc;

  if C > 0 then
    if mode == Buildings.Electrical.Types.Load.FixedZ_dynamic then
      // Dynamics of the system
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

  // Joule losses
  LossPower = R_actual/2*(terminal_p.i[1]^2 + terminal_p.i[2]^2) +
              R_actual/2*(terminal_n.i[1]^2 + terminal_n.i[2]^2);

  annotation (
  defaultComponentName="lineRLC",
Diagram(graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,0}),
          Line(points={{-90,0},{-70,0}}, color={0,0,0}),
          Line(points={{70,0},{90,0}}, color={0,0,0})}),     Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-140,80},{140,40}},
            textColor={0,0,0},
          textString="%name")}),
    Documentation(info="<html>
<p>
This model represents a series of two resistive-inductive impedances and a capacitance
that connects two AC single phase interfaces.
This model can be used to represent a cable in a AC grid.
</p>
<p>
The model represents the lumped resistances and capacity, as a T-model, as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/OnePhase/Lines/twoPortRLC.png\"/>
</p>
<p>
As can be seen in the figure, the resistance <i>R</i> and the inductance <i>L</i> are split in two halves
and the capacitance is located in the center.
The capacitance in the center is optional. If it is not present, set the
parameter <code>C=0</code>.
The model is either dynamic or static depending on the
presence of the capacitive effect.
</p>
</html>", revisions="<html>
<ul>
<li>
November 8, 2016, by Michael Wetter:<br/>
Added <code>replaceable</code> to terminal redeclaration as they are redeclared by
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Lines.TwoPortRLC\">
Buildings.Electrical.AC.ThreePhasesBalanced.Lines.TwoPortRLC</a>.
</li>
<li>
May 26, 2016, by Michael Wetter:<br/>
Moved function call to <code>PhaseSystem.thetaRef</code> out of
derivative operator as this is not yet supported by JModelica.
</li>
<li>
March 9, 2015, by Marco Bonvini:<br/>
Added parameter for start value of the voltage.
</li>
<li>
August 5, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
</ul>
</html>"));
end TwoPortRLC;
