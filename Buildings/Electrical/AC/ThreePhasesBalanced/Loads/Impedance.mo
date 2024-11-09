within Buildings.Electrical.AC.ThreePhasesBalanced.Loads;
model Impedance "Model of a resistive load"
  extends Buildings.Electrical.Interfaces.Impedance(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal);

  parameter Boolean star = true
    "Type of load connection: true = star, false = triangle" annotation(Evaluate=true, choices(
      choice=true "Star",
      choice=false "Triangle",
      __Dymola_radioButtons=true));

protected
  Modelica.Units.SI.Angle theRef "Absolute angle of rotating reference system";
  Modelica.Units.SI.AngularVelocity omega
    "Frequency of the quasi-stationary sine waves";
  Modelica.Units.SI.Reactance X(start=1) "Complex component of the impedance";

equation
  theRef = PhaseSystem.thetaRef(terminal.theta);
  omega = der(theRef);

  // Inductance of each line
  if inductive then
    X = omega*L_internal;
  else
    X = -1/(omega*C_internal);
  end if;

  // Ohm's law
  if star then
    terminal.v = {{R_internal,-X}*terminal.i, {X,R_internal}*terminal.i};
  else
    terminal.v = {{R_internal/3,-X/3}*terminal.i, {X/3,R_internal/3}*terminal.i};
  end if;
  annotation (
  defaultComponentName="loa",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={255,255,255}),
          Rectangle(
            extent={{-80,80},{80,-80}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
          origin={7.10543e-15,7.10543e-15},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{12,1.46953e-15}},
                                       color={0,0,0},
          origin={-80,0},
          rotation=180),
        Text(
          extent={{-120,-80},{120,-120}},
          textColor={0,0,0},
          textString="%name"),
        Rectangle(
          extent={{-11,30},{11,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={2,49},
          rotation=90),
        Rectangle(
          extent={{-11,30},{11,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={2,1},
          rotation=90),
        Rectangle(
          extent={{-11,30},{11,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={2,-49},
          rotation=90),
        Line(
          visible=star == true,
          points={{52,50},{68,0},{52,-50}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(visible = star == true,
          points={{68,0},{52,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-68,50},{-28,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-68,0},{-28,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-68,-50},{-28,-50}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{32,50},{52,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{32,0},{52,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{32,-50},{52,-50}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(visible = star == false,
          points={{52,50},{52,36},{-50,14},{-50,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(visible = star == false,
          points={{52,0},{52,-14},{-50,-36},{-50,-50}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(visible = star == false,
          points={{52,-50},{72,-50},{72,68},{-50,68},{-50,50}},
          color={0,0,0},
          smooth=Smooth.None)}),
          Documentation(info="<html>
<p>
Model of a three-phase balanced impedance.
</p>
<p>
If <code>inductive=true</code>, then the
inductance is a parameter, otherwise
the capacitance is a parameter.
</p>
<p>
The boolean parameter <code>star</code> is used to
select whether the star (Y) or triangle (D)
configuration is used to connect the impedance.
By default, the impedance is assumed to be connected
with a star configuration.
</p>
<p>
When the connection type changes from
<code>star</code> to <code>triangle</code>, the value of the impedance
is recomputed in such a way that the nominal power consumed by the impedance
does not change.
</p>
</html>", revisions="<html>
<ul>
<li>
May 26, 2016, by Michael Wetter:<br/>
Moved function call to <code>PhaseSystem.thetaRef</code> out of
derivative operator as this is not yet supported by JModelica.
</li>
<li>
August 24, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
January 2, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Impedance;
