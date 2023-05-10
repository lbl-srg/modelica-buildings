within Buildings.Fluid.Movers.BaseClasses.Validation;
model TotalEfficiencyMethods
  "Validation model for total efficiency specified via hydraulic efficiency options"
  extends HydraulicEfficiencyMethods(
    per(powerOrEfficiencyIsHydraulic=false),
    eff2(per(efficiency(eta={0,0.35,0.49,0.35,0}))),
    eff3(per(power(P={680,771,730,780,1010}))),
    eff4(per(peak(eta=0.49))));

annotation (
    Documentation(info="<html>
<p>
This model is the same as
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Validation.HydraulicEfficiencyMethods\">
Buildings.Fluid.Movers.BaseClasses.Validation.HydraulicEfficiencyMethods</a>
except that the enumeration is used for total efficiency <i>&eta;</i>
via the parameter <code>per.powerOrEfficiencyIsHydraulic</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
Aug 5, 2022, by Hongxiang Fu:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/BaseClasses/Validation/TotalEfficiencyMethods.mos"
        "Simulate and plot"));
end TotalEfficiencyMethods;
