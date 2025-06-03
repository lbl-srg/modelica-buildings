within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.Validation;
model HoldIntegerArray
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul[3](
    width={1,2,3}/4,
    each period=3.5,
    shift={1,2,3})
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.HoldIntegerArray
    holdIntegerArray(holdDuration=2,
    u_max=10,                        nin=3)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(intPul.y, holdIntegerArray.u)
    annotation (Line(points={{-58,0},{-12,0}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HoldIntegerArray;
