within Buildings.Fluid.MixingVolumes.Validation;
model MoistureMixingConservationSteadyState
  "This test checks if mass and energy is conserved when mixing fluid streams using steady state balances"
  extends
    Buildings.Fluid.MixingVolumes.Validation.BaseClasses.MoistureMixingConservation(
    mWatFloSol(k=0),
    mFloSol(k=sou1.m_flow + sou2.m_flow),
    hSol(k=Medium.h_default*(sou1.m_flow + sou2.m_flow)));

equation
  connect(cheMasFra.u2, senMasFra.X) annotation (Line(
      points={{138,-44},{110,-44},{110,9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheMasFlo.u2, senMasFlo.m_flow) annotation (Line(
      points={{138,-124},{70,-124},{70,9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheSpeEnt.u2, senSpeEnt.H_flow) annotation (Line(
      points={{138,-204},{30,-204},{30,9}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-120,-280},{180,120}}), graphics),
    experiment(Tolerance=1e-6, StopTime=1),
    Documentation(info="<html>
<p>
This test checks if water vapour mass is conserved.
Two air streams with different mass flow rate are humidified
by a mixing volume with two different vapor mass flow rates.
These flows are then mixed.
Afterwards the added water is removed again.
The final water concentration, mass flow rate and enthalpy
flow rate should then be equal to the initial values.
</p>
<p>
Note, however, that there is some approximation error because
in its default configuration, the conservation balance
models simplify the treatment of the water that is added
to the fluid.
See <a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquation\">
Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation</a>
and
<a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquation\">
Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation</a>
for a discussion.
</p>
</html>", revisions="<html>
<ul>
<li>
November 2, 2016, by Michael Wetter:<br/>
Changed assertions to blocks that compute the difference,
and added the difference to the regression results.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/564\">issue 564</a>.
</li>
<li>
May 22 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/MoistureMixingConservationSteadyState.mos"
        "Simulate and plot"));
end MoistureMixingConservationSteadyState;
