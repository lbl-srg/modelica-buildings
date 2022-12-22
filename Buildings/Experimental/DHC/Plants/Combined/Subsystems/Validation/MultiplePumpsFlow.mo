within Buildings.Experimental.DHC.Plants.Combined.Subsystems.Validation;
model MultiplePumpsFlow
  "Validation of the multiple pumps model with flow-controlled pump model"
  extends BaseClasses.MultiplePumps(
    redeclare Subsystems.MultiplePumpsFlow pum,
    redeclare Buildings.Fluid.Movers.FlowControlled_m_flow pum1(
      final m_flow_nominal=mPum_flow_nominal,
      final dp_nominal=dpPum_nominal),
    redeclare Buildings.Fluid.Movers.FlowControlled_m_flow pum2(
      final m_flow_nominal=mPum_flow_nominal,
      final dp_nominal=dpPum_nominal));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp floSet(height=
        mPum_flow_nominal, duration=500) "Mass flow rate setpoint (each pump)"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add floTotSet
    "Compute total flow rate setpoint (all pumps)" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={80,0})));
equation
  connect(floSet.y, inp1.u1)
    annotation (Line(points={{-98,40},{114,40},{114,14}}, color={0,0,127}));
  connect(floSet.y, inp2.u1) annotation (Line(points={{-98,40},{100,40},{100,-26},
          {114,-26},{114,-30}}, color={0,0,127}));
  connect(inp2.y, pum2.m_flow_in) annotation (Line(points={{120,-54},{120,-60},
          {0,-60},{0,-68}}, color={0,0,127}));
  connect(inp1.y, pum1.m_flow_in) annotation (Line(points={{120,-10},{120,-20},
          {0,-20},{0,-28}}, color={0,0,127}));
  connect(floTotSet.y, pum.m_flow_in) annotation (Line(points={{80,12},{80,44},
          {-16,44},{-16,64},{-12,64}}, color={0,0,127}));
  connect(inp1.y, floTotSet.u1) annotation (Line(points={{120,-10},{120,-20},{
          86,-20},{86,-12}}, color={0,0,127}));
  connect(inp2.y, floTotSet.u2) annotation (Line(points={{120,-54},{120,-60},{
          74,-60},{74,-12}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Combined/Subsystems/Validation/MultiplePumpsFlow.mos"
      "Simulate and plot"),
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})));
end MultiplePumpsFlow;
