within Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Validation;
model WetFluid
  "Organic Rankine cycle with a wet working fluid"
  extends
    Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Validation.DryFluid(
      TEva = 350,
      dTSup = 2,
      etaExp = 0.65,
      redeclare parameter
        Buildings.Fluid.CHPs.OrganicRankine.Data.WorkingFluids.R134a pro);
annotation (experiment(StopTime=1, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/OrganicRankine/BaseClasses/Validation/WetFluid.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the handling of wet working fluids by
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.InterpolateStates\">
Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.InterpolateStates</a>.
If the user modifies the expander efficiency <code>etaExp</code> to
a large number (e.g. 0.95), it will trigger an error with a message
that the expander outlet state will be under the dome.
</p>
</html>",revisions="<html>
<ul>
<li>
December 8, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end WetFluid;
