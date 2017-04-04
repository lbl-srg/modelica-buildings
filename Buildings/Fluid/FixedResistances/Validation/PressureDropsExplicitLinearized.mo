within Buildings.Fluid.FixedResistances.Validation;
model PressureDropsExplicitLinearized
  "Test of multiple linearized resistances in series"
  extends PressureDropsExplicit(
    res11(linearized=true),
    res12(linearized=true),
    res21(linearized=true),
    res22(linearized=true),
    res31(linearized=true),
    res32(linearized=true),
    res41(linearized=true),
    res42(linearized=true));
  annotation (
experiment(StartTime=-1, Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Validation/PressureDropsExplicitLinearized.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests multiple linearized flow resistances in series.
</p>
</html>", revisions="<html>
<ul>
<li>
December 1, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end PressureDropsExplicitLinearized;
