within Buildings.Fluid.HydronicConfigurations.Controls;
package OperatingModes "Package with operating mode definitions"
  constant Integer disabled = 0 "Disabled";
  constant Integer enabled = 1 "Enabled (cooling mode for change-over circuits)";
  constant Integer heating = 2 "Heating mode for change-over circuits only";
  annotation (Documentation(info="<html>
<p>
This package contains definitions of operating modes used in the models from 
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations\">
Buildings.Fluid.HydronicConfigurations</a>.
Each operating mode resolves into an integer constant.
</p>
</html>"));
end OperatingModes;
