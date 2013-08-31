within Districts.Electrical.AC.OnePhase.Loads;
model InductiveLoadP "Model of an inductive and resistive load"
  extends Districts.Electrical.Interfaces.PartialInductiveLoad(
    redeclare package PhaseSystem = Districts.Electrical.PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal, V_nominal = 220);

equation
  omega = der(PhaseSystem.thetaRef(terminal.theta));

  // Magnetic flux
  psi = Z[2]*{i[1], i[2]}/omega;

  if mode == Districts.Electrical.Types.Assumption.FixedZ_dynamic then

    // Use the dynamic phasorial representation
    Z[1] = pf*(V_nominal^2)/(P_nominal/pf);
    Z[2] = sqrt(1-pf^2)*(V_nominal^2)/(P_nominal/pf);

    // Dynamic of the system
    der(psi) + omega*j(psi) + Z[1]*i = v;

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
    omega*j(psi)  + Z[1]*i = v;

  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-80,40},{80,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                   Rectangle(extent={{-100,100},{100,-100}},
            lineColor={255,255,255}),
        Ellipse(extent={{-10,-10},{10,10}},
          origin={10,0},
          rotation=360),
        Ellipse(extent={{40,-10},{60,10}}),
        Ellipse(extent={{20,-10},{40,10}}),
        Rectangle(
          extent={{0,0},{60,-12}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Line(points={{0,0},{12,1.46953e-15}},
                                         color={0,0,0},
          origin={0,0},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{10,1.22461e-15}},
                                         color={0,0,0},
          origin={70,0},
          rotation=180),
        Rectangle(
          extent={{-11,30},{11,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-42,1},
          rotation=90),
          Line(points={{-10,-1.22461e-15},{10,0}},
                                         color={0,0,0},
          origin={-82,0},
          rotation=180),
        Text(
          extent={{-120,80},{120,40}},
          lineColor={0,120,120},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p>
Model of an inductive load. It may be used to model an inductive motor.
</p>
<p>
A parameter or input to the model is the real power <i>P</i>, and a parameter
is the power factor <i>pf=cos(&phi;)</i>.
In this model, current lags voltage, as is the case for an inductive motor.
For a capacitive load, use
<a href=\"modelica://Districts.Electrical.AC.Loads.CapacitorResistor\">
Districts.Electrical.AC.Loads.SinglePhase.CapacitorResistor</a>.
</p>
<p>
The model computes the phase angle of the power <i>&phi;</i>
and assigns the complex power <i>S = -P/pf &ang; &phi;</i>.
The relation between complex power, complex voltage and complex current is computed
as 
<i>S = v &sdot; i<sup>*</sup></i>,
where <i>i<sup>*</sup></i> is the complex conjugate of the current.
</p>
</html>", revisions="<html>
<ul>
<li>
January 2, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end InductiveLoadP;
