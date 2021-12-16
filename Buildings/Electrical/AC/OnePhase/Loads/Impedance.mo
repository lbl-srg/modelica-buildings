within Buildings.Electrical.AC.OnePhase.Loads;
model Impedance "Model of a generic impedance"
  extends Buildings.Electrical.Interfaces.Impedance(
    redeclare replaceable package PhaseSystem = PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal);

protected
  Modelica.Units.SI.Angle theRef "Absolute angle of rotating reference system";
  Modelica.Units.SI.AngularVelocity omega
    "Frequency of the quasi-stationary sine waves";
  Modelica.Units.SI.Reactance X(start=1) "Complex component of the impedance";
equation
  theRef = PhaseSystem.thetaRef(terminal.theta);
  omega = der(theRef);

  if inductive then
    X = omega*L_internal;
  else
    X = -1/(omega*C_internal);
  end if;

  terminal.v = {{R_internal,-X}*terminal.i, {X,R_internal}*terminal.i};
  annotation (
    defaultComponentName="imp",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={255,255,255}),
          Rectangle(
            extent={{-80,40},{80,-40}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
          origin={0,3.55271e-15},
          rotation=180),
          Line(points={{0,0},{12,0}},  color={0,0,0},
          origin={-80,0},
          rotation=180),
        Text(
          extent={{-120,-40},{120,-80}},
          textColor={0,0,0},
          textString="%name")}),
          Documentation(info="<html>
<p>
Model of an impedance. This model can be used to represent any type
of resistive, inductive or capacitive load.
</p>
<p>
Note that the power consumed by the impedance model will drecrease if its voltage
decreases.
</p>
<p>
The model of the impedance is
</p>

<p align=\"center\" style=\"font-style:italic;\">
V = Z i,
</p>

<p>
where <i>Z = R + j X</i> is the impedance. The value of the resistance <i>R</i> and the
reactance <i>X</i> depend on the type of impedance. Different types of impedances
can be selected using the boolean parameters <code>inductive</code>, <code>use_R_in</code>,
<code>use_L_in</code>, and <code>use_C_in</code>. See
<a href=\"modelica://Buildings.Electrical.Interfaces.Impedance\">
Buildings.Electrical.Interfaces.Impedance</a> for more details.
</p>
</html>", revisions="<html>
<ul>
<li>
May 26, 2016, by Michael Wetter:<br/>
Moved function call to <code>PhaseSystem.thetaRef</code> out of
derivative operator as this is not yet supported by JModelica.
</li>
<li>
March 30, 2015, by Michael Wetter:<br/>
Made <code>PhaseSystem</code> and <code>terminal</code> replaceable. This was detected
by the OpenModelica regression tests.
</li>
<li>September 4, 2014, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>August 5, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
January 2, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Impedance;
