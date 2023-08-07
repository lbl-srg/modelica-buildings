within Buildings.Fluid.CHPs.Rankine.BaseClasses.Validation;
model WetFluid "Organic Rankine cycle with a wet working fluid"
  extends DryFluid(equ(
        dTSup=2,
        etaExp=0.75),
    redeclare parameter
                Buildings.Fluid.CHPs.Rankine.Data.WorkingFluids.R134a pro);
annotation (experiment(StopTime=1, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/Rankine/BaseClasses/Validation/DryFluid.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model demonstrates the handling of wet working fluids by
<a href=\"Modelica://Buildings.Fluid.CHPs.Rankine.BaseClasses.Equations\">
Buildings.Fluid.CHPs.Rankine.BaseClasses.Equations</a>.
If the user modifies the expander efficiency <code>equ.etaExp</code> to be
a large number (e.g. 0.95), it will trigger an error with a message
that the expander outlet state will be under the dome.
</p>
</html>",revisions="<html>
<ul>
<li>
June 13, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end WetFluid;
