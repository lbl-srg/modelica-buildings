within Buildings.Electrical.AC.OnePhase.Lines;
model TwoPortRL
  "Model of a resistive-inductive element with two electrical ports"
  extends Buildings.Electrical.Transmission.BaseClasses.PartialTwoPortRLC(
    final V_nominal=0,
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal_n,
    redeclare replaceable Interfaces.Terminal_p terminal_p,
    final C=0);
  parameter Modelica.Units.SI.Current i_start[PhaseSystem_p.n]=zeros(
      PhaseSystem_p.n)
    "Initial current phasor of the line (positive if entering from terminal p)"
    annotation (Dialog(enable=(mode == Buildings.Electrical.Types.Load.FixedZ_dynamic)));
  parameter Buildings.Electrical.Types.Load mode(
    min=Buildings.Electrical.Types.Load.FixedZ_steady_state,
    max=Buildings.Electrical.Types.Load.FixedZ_dynamic)=
    Buildings.Electrical.Types.Load.FixedZ_steady_state
    "Type of model (e.g., steady state, dynamic, prescribed power consumption, etc.)"
    annotation (Evaluate=true, Dialog(group="Modeling assumption"));
protected
  Modelica.Units.SI.Current i_p[2](start=i_start, each stateSelect=StateSelect.prefer)
    "Current phasor at terminal p";
  Modelica.Units.SI.AngularVelocity omega
    "Frequency of the quasi-stationary sine waves";
  Modelica.Units.SI.Angle theRef "Absolute angle of rotating reference system";

initial equation
  if mode==Buildings.Electrical.Types.Load.FixedZ_dynamic then
    i_p = i_start;
  end if;
equation
  theRef = PhaseSystem_p.thetaRef(terminal_p.theta);
  omega = der(theRef);

  terminal_p.i = - terminal_n.i;
  i_p = terminal_p.i;

  if mode==Buildings.Electrical.Types.Load.FixedZ_dynamic then
    // Dynamics of the system
    der(L*i_p) + L*omega*PhaseSystem_p.j(i_p) +
      i_p*diagonal(ones(PhaseSystem_p.n)*R_actual)
       = terminal_p.v - terminal_n.v;

  else
    // steady state relationship
    L*omega*PhaseSystem_p.j(i_p) +
      i_p*diagonal(ones(PhaseSystem_p.n)*R_actual)
      = terminal_p.v - terminal_n.v;
  end if;

  // Joule losses
  LossPower = R_actual*(i_p[1]^2 + i_p[2]^2);

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
            textColor={0,0,0},
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
January 29, 2019, by Michael Wetter:<br/>
Added <code>replaceable</code> for terminal.
</li>
<li>
May 26, 2016, by Michael Wetter:<br/>
Moved function call to <code>PhaseSystem.thetaRef</code> out of
derivative operator as this is not yet supported by JModelica.
</li>
<li>
March 9, 2015, by Marco Bonvini:<br/>
Added parameter for start value of the current.
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
end TwoPortRL;
