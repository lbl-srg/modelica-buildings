within Buildings.Experimental.DHC.Plants.Combined.Subsystems;
model MultiplePumpsFlow
  "Model of multiple identical pumps in parallel with flow-controlled pump model"
  extends BaseClasses.PartialMultiplePumps(
    redeclare final Buildings.Fluid.Movers.FlowControlled_m_flow pum(
      final m_flow_nominal=mPum_flow_nominal,
      final dp_nominal=dpPum_nominal),
    cst(final k=mPum_flow_nominal));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow_in(
    final unit="kg/s",
    final min=0) if have_var "Mass flow rate setpoint (total over all pumps)"
    annotation (
    Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div1
    "Divide total flow setpoint by number of pumps commanded On"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(m_flow_in, div1.u1) annotation (Line(points={{-120,60},{-90,60},{-90,66},
          {-82,66}}, color={0,0,127}));
  connect(com.nUniOnBou, mulOut.u) annotation (Line(points={{-68,106},{-68.3333,
          106.25},{-64.1667,106.25},{-64.1667,106},{-64,106},{-64,80},{50,80},{50,
          6},{58,6}}, color={0,0,127}));
  connect(com.nUniOnBou, div1.u2) annotation (Line(points={{-68,106},{-64,106},{
          -64,80},{-86,80},{-86,54},{-82,54}}, color={0,0,127}));
  connect(div1.y, inp.u1) annotation (Line(points={{-58,60},{-40,60},{-40,44},{-32,
          44}}, color={0,0,127}));
  connect(inp.y, pum.m_flow_in)
    annotation (Line(points={{-8,50},{0,50},{0,12}}, color={0,0,127}));
  annotation (
    defaultComponentName="pum");
end MultiplePumpsFlow;
