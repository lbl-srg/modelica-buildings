within Districts.Electrical.AC.ThreePhasesBalanced.Loads;
model Impedance "Model of a resistive load"
  extends Districts.Electrical.Interfaces.PartialLoad(
     redeclare package PhaseSystem =
        Districts.Electrical.PhaseSystems.OnePhase,
     redeclare Interfaces.Terminal_n terminal,
     final mode=1,
     final P_nominal=0,
     final V_nominal = 380);
  parameter Boolean star = true
    "Type of load connection: true = star, false = triangle" annotation(evaluate=true);
  parameter Boolean inductive=true
    "If =true the load is inductive, otherwise it is capacitive"
    annotation (Evaluate=true);
  parameter Modelica.SIunits.Resistance R(start = 1,min=0) "Resistance";
  parameter Modelica.SIunits.Inductance L(start=0, min=0) "Inductance"
    annotation (Dialog(enable=inductive));
  parameter Modelica.SIunits.Capacitance C(start=0,min=0) "Capacitance"  annotation (Dialog(enable=not inductive));
protected
  Modelica.SIunits.AngularVelocity omega;
  Modelica.SIunits.Reactance X(start = 1);
equation
  omega = der(PhaseSystem.thetaRef(terminal.theta));

  // Inductance of each line
  if inductive then
    X = omega*L;
  else
    X = -1/(omega*C);
  end if;

  // Ohm's law
  if star then
    terminal.v = {{R,-X}*terminal.i, {X,R}*terminal.i};
  else
    terminal.v = {{R/3,-X/3}*terminal.i, {X/3,R/3}*terminal.i};
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
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
          extent={{-120,120},{120,80}},
          lineColor={0,120,120},
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
          points={{52,50},{68,0},{52,-50}},
          color=DynamicSelect({0,0,0}, if star then {0,0,0}
               else {255,255,255}),
          smooth=Smooth.None),
        Line(
          points={{68,0},{52,0}},
          color=DynamicSelect({0,0,0}, if star then {0,0,0} else {255,255,255}),
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
        Line(
          points={{52,50},{52,36},{-50,14},{-50,0}},
          color=DynamicSelect({0,0,0}, if not star then {0,0,0}
               else {255,255,255}),
          smooth=Smooth.None),
        Line(
          points={{52,0},{52,-14},{-50,-36},{-50,-50}},
          color=DynamicSelect({0,0,0}, if not star then {0,0,0}
               else {255,255,255}),
          smooth=Smooth.None),
        Line(
          points={{52,-50},{72,-50},{72,68},{-50,68},{-50,50}},
          color=DynamicSelect({0,0,0}, if not star then {0,0,0}
               else {255,255,255}),
          smooth=Smooth.None)}),
          Documentation(info="<html>
<p>
Model of a load that is characterized by its resistance, 
inductance or capacitance.
</p>
<p>
If <code>inductive=true</code>, then the
inductance is a parameter, otherwise
the capacitance is a parameter.
The parameter <code>star</code> is used to 
configure the model as a star or triangle circuit.
</p>
</html>", revisions="<html>
<ul>
<li>
January 2, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Impedance;
