within Buildings.Fluid.Movers.Validation;
model ComparePowerTotal
  "Compare power estimation with total power curve"
  extends Buildings.Fluid.Movers.Validation.ComparePowerHydraulic(
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos40slash1to12 per);
annotation(experiment(Tolerance=1e-6, StopTime=200),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/ComparePowerTotal.mos"
        "Simulate and plot"),
        Documentation(info="<html>
<p>
This validation model is similar to
<a href=\"modelica://Buildings.Fluid.Movers.Validation.ComparePowerHydraulic\">
Buildings.Fluid.Movers.Validation.ComparePowerHydraulic</a>,
with the difference being the fan components are replaced with pump components
with <code>per.powerOrEfficiencyIsHydraulic=false</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2024, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1880\">IBPSA, #1880</a>.
</li>
</ul>
</html>"));
end ComparePowerTotal;
