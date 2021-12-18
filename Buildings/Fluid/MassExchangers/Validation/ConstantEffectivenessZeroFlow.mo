within Buildings.Fluid.MassExchangers.Validation;
model ConstantEffectivenessZeroFlow
  "Zero flow test for constants effectiveness mass exchanger"
  extends Buildings.Fluid.MassExchangers.Examples.ConstantEffectiveness(
    PSin_1(
      height=0,
      offset=1E5), PIn(height=0, offset=101325));
  annotation (Documentation(revisions="<html>
<ul>
<li>
April 30, 2018, by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/907\">#907</a>.
</li>
</ul>
</html>", info="<html>
<p>
This model tests whether
<a href=\"modelica://Buildings.Fluid.MassExchangers.ConstantEffectiveness\">ConstantEffectiveness</a>
works correctly at zero flow if one stream is zero.
</p>
</html>"), experiment(Tolerance=1e-06, StopTime=1),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MassExchangers/Validation/ConstantEffectivenessZeroFlow.mos"
        "Simulate and plot"));
end ConstantEffectivenessZeroFlow;
