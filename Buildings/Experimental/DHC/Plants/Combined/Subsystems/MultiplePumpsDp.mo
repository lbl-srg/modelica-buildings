within Buildings.Experimental.DHC.Plants.Combined.Subsystems;
model MultiplePumpsDp
  "Model of multiple identical pumps in parallel with dp-controlled pump model"
  extends BaseClasses.PartialMultiplePumps(
    redeclare final Buildings.Fluid.Movers.FlowControlled_dp pum(
      final m_flow_nominal=mPum_flow_nominal,
      final dp_nominal=dpPum_nominal),
    cst(final k=dpPum_nominal));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dp_in(
    final unit="Pa",
    final min=0)
    if have_var
    "Differential pressure setpoint"
    annotation (
    Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
equation
  connect(dp_in, inp.u1) annotation (Line(points={{-120,60},{-40,60},{-40,34},{
          -32,34}}, color={0,0,127}));
  connect(inp.y, pum.dp_in)
    annotation (Line(points={{-8,40},{0,40},{0,12}}, color={0,0,127}));
  annotation (
    defaultComponentName="pum");
end MultiplePumpsDp;
