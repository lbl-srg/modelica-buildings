within Buildings.Fluid.MixingVolumes.Validation;
model TraceSubstanceConservationDynamicBalance
  "This test checks if trace substance mass flow rates are conserved when a dynamic balance is used"
  extends
    Buildings.Fluid.MixingVolumes.Validation.BaseClasses.TraceSubstanceConservation(
     vol(massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));

  Modelica.Blocks.Continuous.Integrator intTraSubIn(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Integrator for trace substance inlet"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={-30,-60})));
  Modelica.Blocks.Continuous.Integrator intTraSubOut(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) "Integrator for trace substance outlet"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={10,-40})));
  Modelica.Blocks.Sources.RealExpression reaExp(y=vol.m*vol.C[1])
    "Mixing volume total species mass"
    annotation (Placement(transformation(extent={{-8,-58},{30,-78}})));
  Modelica.Blocks.Math.Add cheConMas(k2=-1) "Check for conservation of mass"
    annotation (Placement(transformation(extent={{80,-88},{100,-68}})));
  Modelica.Blocks.Math.Add3 add3(
    k1=-1,
    k2=+1,
    k3=-1) "Conservation of mass"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Modelica.Blocks.Sources.Constant zero(k=0) "Zero input"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
equation
  connect(reaExp.y, add3.u3) annotation (Line(
      points={{31.9,-68},{38,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intTraSubIn.y, add3.u2) annotation (Line(
      points={{-19,-60},{38,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intTraSubOut.y, add3.u1) annotation (Line(
      points={{21,-40},{21,-52},{38,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add3.y, cheConMas.u1) annotation (Line(
      points={{61,-60},{70,-60},{70,-72},{78,-72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zero.y, cheConMas.u2) annotation (Line(
      points={{61,-90},{70,-90},{70,-84},{78,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intTraSubIn.u, CfloIn.y) annotation (Line(
      points={{-42,-60},{-46,-60},{-46,-41}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(CfloOut.y, intTraSubOut.u) annotation (Line(
      points={{46,-41},{46,-41},{46,-44},{30,-44},{30,-22},{-12,-22},{-12,-40},{
          -2,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (    experiment(Tolerance=1e-08, StopTime=1),
    Documentation(info="<html>
<p>
This test checks if the trace substance flow rate is
conserved when adding moisture to a mixing volume that is configured to steady state.<br/>
The trace substance flow rate at the inlet and outlet should be equal
since the trace substance concentration should not
be affected by the independent mass fraction concentration.
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
November 3, 2016, by Michael Wetter:<br/>
Removed wrong assignment for <code>C_nominal</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/568\">issue 568</a>.
</li>
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
          "Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/TraceSubstanceConservationDynamicBalance.mos"
        "Simulate and plot"));
end TraceSubstanceConservationDynamicBalance;
