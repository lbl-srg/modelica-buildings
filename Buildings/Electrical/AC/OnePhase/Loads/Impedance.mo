within Buildings.Electrical.AC.OnePhase.Loads;
model Impedance "Model of a generic impedance"
  extends Buildings.Electrical.Interfaces.PartialImpedance(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal);
protected
  Modelica.SIunits.AngularVelocity omega;
  Modelica.SIunits.Reactance X(start = 1);
equation
  omega = der(PhaseSystem.thetaRef(terminal.theta));
  if inductive then
    X = omega*L_internal;
  else
    X = -1/(omega*C_internal);
  end if;
  terminal.v = {{R_internal,-X}*terminal.i, {X,R_internal}*terminal.i};
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={255,255,255}),
          Rectangle(
            extent={{-80,40},{80,-40}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
          origin={0,3.55271e-15},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{12,1.46953e-15}},
                                       color={0,0,0},
          origin={-80,0},
          rotation=180),
        Text(
          extent={{-120,80},{120,40}},
          lineColor={0,120,120},
          textString="%name")}),
          Documentation(info="<html>
<p>        
Model of an impedance. This model can be used to represent any type
of resistive, inductive or capacitive load.
</p>
<h4>N.B.</h4>
<p>        
The power consumed by the impedance model will drecrease if its voltage
decreases.
</p>
<p>
The model of the impedance is the following
</p>

<p align=\"center\" style=\"font-style:italic;\">
V = Z i
</p>

<p>
where <i>Z = R + jX</i> is the impedance. The value of the resistance <i>R</i> and the
reactance <i>X</i> depend on the type of impedance. Different types of impedances
can be selected using the boolean flags <code>inductive</code>, <code>use_R_in</code>,
<code>use_L_in</code>, and <code>use_C_in</code>. See 
<a href=\"modelica://Buildings.Electrical.Interfaces.PartialImpedance\">
Buildings.Electrical.Interfaces.PartialImpedance</a> for more details.
</p>
</html>", revisions="<html>
<ul>
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
