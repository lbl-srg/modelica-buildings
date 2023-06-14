within Buildings.Fluid.CHPs.Rankine.Validation;
model WetFluid "Organic Rankine cycle with a wet working fluid"
  extends DryFluid(
    redeclare parameter
                Buildings.Fluid.CHPs.Rankine.Data.WorkingFluids.R134a pro,
    cyc(dTSup=2,
        etaExp=0.75));
  annotation (Documentation(info="<html>
<p>
This model demonstrates the handling of wet working fluids.
If the user modifies the expander efficiency <code>cyc.etaExp</code> to be
a large number (e.g. 0.95), it will trigger an error with a message
that the expander outlet state will be under the dome.
</p>
</html>"));
end WetFluid;
