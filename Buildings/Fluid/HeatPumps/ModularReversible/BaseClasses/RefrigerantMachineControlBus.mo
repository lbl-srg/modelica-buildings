within Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses;
expandable connector RefrigerantMachineControlBus
  "Bus connector for reversible heat pump and chiller model"
  extends Modelica.Icons.SignalBus;
  annotation (Documentation(info="<html>
<p>
  Bus connector for a refrigerant machine.
</p>
<p>
  Used in the reversbile modular approaches for chiller
  and heat pump in the models
  <a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.Modular\">
  Buildings.Fluid.Chillers.ModularReversible.Modular</a> and
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Modular\">
  Buildings.Fluid.HeatPumps.ModularReversible.Modular</a>.
</p>
</html>", revisions="<html><ul>
<li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  Adapted based on Buildings implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
<li>
  <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
</li>
</ul>
</html>"));
end RefrigerantMachineControlBus;
