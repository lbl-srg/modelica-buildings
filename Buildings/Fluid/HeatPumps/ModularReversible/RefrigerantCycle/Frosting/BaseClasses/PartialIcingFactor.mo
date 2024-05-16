within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.BaseClasses;
partial model PartialIcingFactor "Partial model to calculate the icing factor"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus sigBus
    "Bus-connector used in a heat pump" annotation (Placement(transformation(
        extent={{-15,-14},{15,14}},
        rotation=0,
        origin={-101,0})));
  Modelica.Blocks.Interfaces.RealOutput iceFac(final unit="1", min=0, max=1)
    "Icing factor from 0 to 1 to estimate influence of icing"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
   Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Partial model to calculate the icing factor based on the data available in the
  signal bus <code>sigBus</code> of the heat pump.
</p>
<p>
The icing factor is a heat transfer modifier between <i>0</i> and <i>1</i>, whereas
<i>0</i> indicates no heat transfer occurs and
<i>1</i> indicates the heat transfer is unaffected.
</p>
<p>
  See the documentation of <a href=
  \"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle</a>
  for further information.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end PartialIcingFactor;
