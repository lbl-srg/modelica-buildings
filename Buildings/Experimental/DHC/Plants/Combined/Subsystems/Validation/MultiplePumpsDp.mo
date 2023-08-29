within Buildings.Experimental.DHC.Plants.Combined.Subsystems.Validation;
model MultiplePumpsDp
  "Validation of multiple pumps model with dp-controlled pump model"
  extends BaseClasses.PartialMultiplePumps(
    redeclare final Subsystems.MultiplePumpsDp pum,
    redeclare final Buildings.Fluid.Movers.FlowControlled_dp pum1(
      final m_flow_nominal=mPum_flow_nominal,
      final dp_nominal=dpPum_nominal),
    redeclare final Buildings.Fluid.Movers.FlowControlled_dp pum2(
      final m_flow_nominal=mPum_flow_nominal,
      final dp_nominal=dpPum_nominal));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp dpSet(
    height=dpPum_nominal, duration=500)
    "Differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
equation
  connect(dpSet.y, inp1.u1)
    annotation (Line(points={{-98,40},{114,40},{114,14}}, color={0,0,127}));
  connect(dpSet.y, inp2.u1) annotation (Line(points={{-98,40},{100,40},{100,-26},
          {114,-26},{114,-30}}, color={0,0,127}));
  connect(inp1.y, pum1.dp_in) annotation (Line(points={{120,-10},{120,-20},{0,-20},
          {0,-28}}, color={0,0,127}));
  connect(inp2.y, pum2.dp_in) annotation (Line(points={{120,-54},{120,-60},{0,-60},
          {0,-68}}, color={0,0,127}));
  connect(dpSet.y, pum.dp_in) annotation (Line(points={{-98,40},{-40,40},{-40,64},
          {-12,64}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Combined/Subsystems/Validation/MultiplePumpsDp.mos"
      "Simulate and plot"),
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
    Documentation(info="<html>
<p>
This model validates 
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Combined.Subsystems.MultiplePumpsDp\">
Buildings.Experimental.DHC.Plants.Combined.Subsystems.MultiplePumpsDp</a>
by comparing an instance of that model with two instances of
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a>
connected in parallel.
The two pumps are commanded On one after the other as they receive
an increasing differential pressure setpoint and work
against a two-way modulating valve that gets progressively opened.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end MultiplePumpsDp;
