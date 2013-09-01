within Districts.Electrical.AC.OnePhase.Loads;
model Impedance "Model of a generic impedance"
  extends Districts.Electrical.Interfaces.PartialLoad(redeclare package
      PhaseSystem = Districts.Electrical.PhaseSystems.OnePhase, redeclare
      Interfaces.Terminal_n terminal,
      final mode=1,
      final P_nominal=0,
      final V_nominal = 220);
  parameter Modelica.SIunits.Resistance R(start = 1,min=0) "Resistance";
  parameter Boolean inductive=true
    "If =true the load is inductive, otherwise it is capacitive"
    annotation (Evaluate=true);
  parameter Modelica.SIunits.Inductance L(start=0, min=0) "Inductance"
    annotation (Dialog(enable=inductive));
  parameter Modelica.SIunits.Capacitance C(start=0,min=0) "Capacitance"  annotation (Dialog(enable=not inductive));
protected
  Modelica.SIunits.AngularVelocity omega;
  Modelica.SIunits.Reactance X(start = 1);
equation
  omega = der(PhaseSystem.thetaRef(terminal.theta));
  if inductive then
    X = omega*L;
  else
    X = -1/(omega*C);
  end if;
  terminal.v = {{R,-X}*terminal.i, {X,R}*terminal.i};
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
Model of a resistive load. It may be used to model a load that has
a power factor of one.
</p>
<p>
The model computes the power as
<i>P = real(v &sdot; i<sup>*</sup>)</i>,
where <i>i<sup>*</sup></i> is the complex conjugate of the current.
Complex voltage and complex current are related as <i>v = R &nbsp; i</i>.
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
