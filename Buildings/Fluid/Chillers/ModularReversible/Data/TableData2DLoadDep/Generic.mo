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
      revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on IPBSA guidelines <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>May 7, 2020</i> by Philipp Mehrfeld:<br/>
    Add description of how to calculate m_flows
  </li>
  <li>
    <i>December 10, 2013</i> by Ole Odendahl:<br/>
    Formatted documentation appropriately
  </li>
</ul>
</html>
"), Icon);
end Generic;
