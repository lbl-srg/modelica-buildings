within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.BaseClasses;
partial model PartialInertia "Partial inertia model"
  extends Modelica.Blocks.Interfaces.SISO;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
  Partial model for inertia.
  This block is identical to
  <a href=\"Modelica://Modelica.Blocks.Interfaces.SISO\">
  Modelica.Blocks.Interfaces.SISO</a>
  and is made to constrain the replaceable inertia module
  within other inertia models.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end PartialInertia;
