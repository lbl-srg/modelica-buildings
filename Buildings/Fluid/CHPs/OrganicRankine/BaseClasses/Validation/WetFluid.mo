within Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Validation;
model WetFluid
  "Organic Rankine cycle with a wet working fluid"
  extends
    Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Validation.DryFluid(
      TEva = 350,
      redeclare parameter
        Buildings.Fluid.CHPs.OrganicRankine.Data.WorkingFluids.R134a pro);
annotation (experiment(StopTime=1, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/OrganicRankine/BaseClasses/Validation/WetFluid.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model is largely the same as
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Validation.DryFluid\">
Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Validation.DryFluid</a>,
except that it validates the handling of wet working fluids.
As a result, a minimum superheating temperature is computed that ensures
the expansion does not land under the dome.
</p>
</html>",revisions="<html>
<ul>
<li>
March 04, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end WetFluid;
