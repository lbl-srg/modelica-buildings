within Districts.Electrical.AC.OnePhase.Loads;
model CapacitiveLoadP "Model of a capacitive and resistive load"
  extends Districts.Electrical.Interfaces.PartialCapacitiveLoad(
    redeclare package PhaseSystem = Districts.Electrical.PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal, V_nominal = 220);
equation
  omega = der(PhaseSystem.thetaRef(terminal.theta));

  // Electric charge
  q = Y[2]*{v[1], v[2]}/omega;

  if mode == Districts.Electrical.Types.Assumption.FixedZ_dynamic then

    // Use the dynamic phasorial representation
    Y[1] = (P_nominal/pf)*pf/V_nominal^2;
    Y[2] = (P_nominal/pf)*sqrt(1 - pf^2)/V_nominal^2;

    // Dynamic of the system
    der(q) + omega*j(q) + Y[1]*v = i;

  else

    // Use the power specified by the parameter or inputs
    if linear then
      i[1] = (v[2]*Q + v[1]*P)/(V_nominal^2);
      i[2] = (v[2]*P - v[1]*Q)/(V_nominal^2);
    else
      //PhaseSystem.phasePowers_vi(terminal.v, terminal.i) = PhaseSystem.phasePowers(P, Q);
      i[1] = (v[2]*Q + v[1]*P)/(v[1]^2 + v[2]^2);
      i[2] = (v[2]*P - v[1]*Q)/(v[1]^2 + v[2]^2);
    end if;

    // steady state relationship
    omega*j(q)  + Y[1]*v = i;

  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),      graphics={
        Rectangle(
          extent={{-80,40},{80,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,28},{0,-28}},
          color={0,0,0},
          origin={48,0},
          rotation=180),
        Line(
          points={{0,28},{0,-28}},
          color={0,0,0},
          origin={40,0},
          rotation=180),
          Line(points={{-42,-5.14335e-15},{10,0}},
                                         color={0,0,0},
          origin={-2,0},
          rotation=180),
          Line(points={{-26,-3.18398e-15},{6.85214e-44,8.39117e-60}},
                                         color={0,0,0},
          origin={48,0},
          rotation=180),
          Line(points={{-10,-1.22461e-15},{10,0}},
                                         color={0,0,0},
          origin={-82,0},
          rotation=180),
        Rectangle(
          extent={{-11,30},{11,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-42,1},
          rotation=90),
        Text(
          extent={{-120,80},{120,40}},
          lineColor={0,120,120},
          textString="%name")}), Documentation(info="<html>
<p>
Model of a capacitive load. It may be used to model a bank of capacitors.
</p>
<p>
A parameter or input to the model is the real power <i>P</i>, and a parameter
is the power factor <i>pf=cos(&phi;)</i>.
In this model, current leads voltage, as is the case for a capacitor bank.
For an inductive load, use
<a href=\"modelica://Districts.Electrical.AC.Loads.InductorResistor\">
Districts.Electrical.AC.Loads.InductorResistor</a>.</p>
<p>
The model computes the phase angle of the power <i>&phi;</i>
and assigns the complex power <i>S = -P/pf &ang; &phi;</i>.
The relation between complex power, complex voltage and complex current is computed
as 
<i>S = v &sdot; i<sup>*</sup></i>,
where <i>i<sup>*</sup></i> is the complex conjugate of the current.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 2, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CapacitiveLoadP;
