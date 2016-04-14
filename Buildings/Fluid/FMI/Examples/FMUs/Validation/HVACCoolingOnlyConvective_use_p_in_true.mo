within Buildings.Fluid.FMI.Examples.FMUs.Validation;
block HVACCoolingOnlyConvective_use_p_in_true
  "Validation model for simple convective only HVAC system with use_p_in = true"
  extends HVACCoolingOnlyConvective(use_p_in=true);
annotation (
    Documentation(info="<html>
<p>
This example validates that
<a href=\"modelica://Buildings.Fluid.FMI.Examples.FMUs.HVACCoolingOnlyConvective\">
Buildings.Fluid.FMI.Examples.FMUs.HVACCoolingOnlyConvective</a>
translates correctly if <code>us_p_in = true</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2016 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FMUs/Validation/HVACCoolingOnlyConvective_use_p_in_true.mos"
        "Export FMU"));
end HVACCoolingOnlyConvective_use_p_in_true;
