within Buildings.Experimental.DHC.Plants.Combined.Subsystems;
model MultiplePumpsSpeed
  "Model of multiple identical pumps in parallel with speed-controlled pump model"
  extends
    Buildings.Experimental.DHC.Plants.Combined.Subsystems.BaseClasses.PartialMultiplePumps(
    redeclare final Buildings.Fluid.Movers.SpeedControlled_y pum,
    cst(final k=1));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput y(
    final unit="1",
    final min=0)
    if have_var
    "Pump speed (common to all pumps)"
    annotation (
     Placement(transformation(extent={{-140,40},{-100,80}}), iconTransformation(
          extent={{-140,20},{-100,60}})));

equation
  connect(y, inp.u1) annotation (Line(points={{-120,60},{-40,60},{-40,44},{-32,44}},
        color={0,0,127}));
  connect(inp.y, pum.y)
    annotation (Line(points={{-8,50},{0,50},{0,12}}, color={0,0,127}));
  annotation (
    defaultComponentName="pum");
end MultiplePumpsSpeed;
