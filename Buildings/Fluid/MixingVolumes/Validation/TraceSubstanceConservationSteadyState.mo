within Buildings.Fluid.MixingVolumes.Validation;
model TraceSubstanceConservationSteadyState
  "This test checks if trace substance mass flow rates are conserved when steady state"
  extends
    Buildings.Fluid.MixingVolumes.Validation.BaseClasses.TraceSubstanceConservation(
     sou(X={0,1}));
  Buildings.Utilities.Diagnostics.AssertEquality assEquTra2(threShold=1E-10,
      message="Measured trace quantities are not equal")
    "Assert equality of trace substances"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEquTra1(threShold=1E-10,
      message="Measured trace quantity does not equal set point")
    "Assert equality of trace substances"
    annotation (Placement(transformation(extent={{80,-70},{100,-90}})));
  Modelica.Blocks.Sources.Constant const(k=sou.m_flow*sou.C[1])
    "Set point of trace substance concentration"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
equation
  connect(const.y, assEquTra1.u1) annotation (Line(
      points={{61,-90},{70,-90},{70,-86},{78,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assEquTra1.u2, CfloIn.y) annotation (Line(
      points={{78,-74},{-46,-74},{-46,-41}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assEquTra2.u2, CfloIn.y) annotation (Line(
      points={{78,-56},{-46,-56},{-46,-41}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assEquTra2.u1, CfloOut.y) annotation (Line(
      points={{78,-44},{46,-44},{46,-41}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    experiment(Tolerance=1e-08),
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
May 22 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/TraceSubstanceConservationSteadyState.mos"
        "Simulate and plot"));
end TraceSubstanceConservationSteadyState;
