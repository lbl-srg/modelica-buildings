within Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep;
record Generic
  "Partial heat pump data"
  extends Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.Generic;
  parameter Real tabLowBou[:, 2]
    "Points to define lower boundary of operating envelope";
  parameter Boolean use_TEvaOutForOpeEnv=use_TEvaOutForTab
    "=true to use evaporator outlet temperature for operational envelope, false for inlet";
  parameter Boolean use_TConOutForOpeEnv=use_TConOutForTab
    "=true to use condenser outlet temperature for operational envelope, false for inlet";
  annotation (
    Documentation(
      info="<html>
<p>
This is the base record class to specify the parameters of the model
<a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.TableData2DLoadDep\">
Buildings.Fluid.Chillers.ModularReversible.TableData2DLoadDep</a>.
</p>
<p>
In addition to the parameters defined in
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.Generic\">
Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.Generic</a>
table data for lower temperature limits is included.
Please refer to the documentation of
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.PartialOperationalEnvelope\">
Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.PartialOperationalEnvelope</a>
for guidance on how to populate this table.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 17, 2025, by Michael Wetter:<br/>
Corrected typo in annotation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4406\">Buildings, #4406</a>.
</li>
<li>
March 21, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
