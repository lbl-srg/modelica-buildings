within Buildings.Fluid.CHPs.Rankine.Validation;
model WetFluid "Organic Rankine cycle with a wet working fluid"
  extends DryFluid(
    redeclare parameter
                Buildings.Fluid.CHPs.Rankine.Data.WorkingFluids.R134a pro,
    cyc(dTSup=2,
        etaExp=0.75));
end WetFluid;
