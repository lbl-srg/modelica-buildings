within Buildings.Fluid.MixingVolumes.Validation;
model TraceSubstanceConservationSteadyState
  "This test checks if trace substance mass flow rates are conserved when steady state"
  extends
    Buildings.Fluid.MixingVolumes.Validation.BaseClasses.TraceSubstanceConservation(
     sou(X={0,1}));
  Modelica.Blocks.Math.Add cheEquTra2(k2=-1)
    "Check for equality of trace substances"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Modelica.Blocks.Math.Add cheEquTra1(k2=-1)
    "Check for equality of trace substances"
    annotation (Placement(transformation(extent={{80,-70},{100,-90}})));
  Modelica.Blocks.Sources.Constant const(k=sou.m_flow*sou.C[1])
    "Set point of trace substance concentration"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
equation
  connect(const.y,cheEquTra1. u1) annotation (Line(
      points={{61,-90},{70,-90},{70,-86},{78,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheEquTra1.u2, CfloIn.y) annotation (Line(
      points={{78,-74},{-46,-74},{-46,-41}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheEquTra2.u2, CfloIn.y) annotation (Line(
      points={{78,-56},{-46,-56},{-46,-41}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheEquTra2.u1, CfloOut.y) annotation (Line(
      points={{78,-44},{46,-44},{46,-41}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (    experiment(Tolerance=1e-6, StopTime=2),
    Documentation(info="<html>
<p>
This test checks if the trace substance flow rate is conserved
when adding moisture to a mixing volume that is configured to steady state.<br/>
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
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/TraceSubstanceConservationSteadyState.mos"
        "Simulate and plot"));
end TraceSubstanceConservationSteadyState;
