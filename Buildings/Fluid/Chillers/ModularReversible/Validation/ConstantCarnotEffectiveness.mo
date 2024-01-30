within Buildings.Fluid.Chillers.ModularReversible.Validation;
model ConstantCarnotEffectiveness
  "Validation case for modular Carnot approach"
  extends BaseClasses.PartialModularComparison(chi(redeclare model
        RefrigerantCycleChillerCooling =
          Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantCarnotEffectiveness
          (etaCarnot_nominal=etaCarnot_nominal)));
  extends Modelica.Icons.Example;

  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/ModularReversible/Validation/ConstantCarnotEffectiveness.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
November 13, 2023 by Fabian Wuellhorst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Validation case for <a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantCarnotEffectiveness\">
Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantCarnotEffectiveness</a>.
</p>
</html>"));
end ConstantCarnotEffectiveness;
