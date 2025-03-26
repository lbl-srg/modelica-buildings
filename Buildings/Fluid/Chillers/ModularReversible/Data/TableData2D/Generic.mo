within Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D;
record Generic "Basic chiller data"
  extends Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.Generic;

  parameter Real tabQEva_flow[:,:]
    "Cooling power consumption table, T in K, Q_flow in W";
  parameter Real tabLowBou[:,2]
    "Points to define lower boundary for source temperature";
  parameter Boolean use_TEvaOutForOpeEnv=false
    "=true to use evaporator outlet temperature for operational envelope, false for inlet";
  parameter Boolean use_TConOutForOpeEnv=false
    "=true to use condenser outlet temperature for operational envelope, false for inlet";
  annotation (Documentation(info="<html>

  <h4>Overview</h4>
<p>
  Base data definition used in the chiller model.
</p>
<p>
  It extends <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.Generic\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2DData.RefrigerantCycle2DBaseDataDefinition</a>
  to restrict to intended selections.</p>
<p>
  It adds the table data for lower temperature limits
  which serves as the operational envelope of the compressor.
</p>
</html>",
        revisions="<html><ul>
  <li>
    <i>November 26, 2018,</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"),
   Icon);
end Generic;
