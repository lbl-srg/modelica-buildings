within Buildings.ChillerWSE;
model FlowMachine_y "Identical speed controlled flow machines"
  extends Buildings.ChillerWSE.BaseClasses.PartialPumpParallel(
    redeclare Buildings.Fluid.Movers.SpeedControlled_y pum,
    rhoStd=Medium.density_pTX(101325, 273.15+4, Medium.X_default));

equation
  connect(u, pum.y)
    annotation (Line(points={{-120,40},{0,40},{0,12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
July 27, 2017, by Yangyang Fu:<br>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This model implements a parallel of identical pumps with speed being controlled.
The shutoff valves are used to avoid circulating flow among pumps.
</p>
</html>"));
end FlowMachine_y;
