within Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep;
record GenericHeatPump
  "Record to specify performance data for load-dependent data-based HP models"
  extends Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.Generic;
  parameter Real tabUppBou[:, 2]
    "Points to define upper boundary for sink temperature";
  parameter Boolean use_TEvaOutForOpeEnv=false
    "=true to use evaporator outlet temperature for operational envelope, false for inlet";
  parameter Boolean use_TConOutForOpeEnv=true
    "=true to use condenser outlet temperature for operational envelope, false for inlet";
  annotation (Documentation(info="<html>
<p>
This is the base record class to specify the parameters of the model
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep</a>.
</p>
<p>
In addition to the parameters defined in 
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.Generic\">
Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.Generic</a>
table data for upper temperature limits is included.
Please refer to the documentation of 
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.PartialOperationalEnvelope\">
Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.PartialOperationalEnvelope</a>
for guidance on how to populate this table.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 21, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>
"),Icon);
end GenericHeatPump;
