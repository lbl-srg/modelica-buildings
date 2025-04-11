within Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep;
partial record Generic
  "Partial record to specify performance data for load-dependent data-based models"
  extends Modelica.Icons.Record;
  parameter String fileName "Path to file with performance data";
  parameter Real PLRSup[:](each final unit="1", each final min=0)
    "PLR values at which heat flow rate and power data are provided";
  parameter Real PLRCyc_min(final max=min(PLRSup), final min=0, final unit="1")=min(PLRSup)
    "Minimum PLR before cycling last compressor off";
  parameter Real P_min(final min=0)=0
    "Minimum power when system is enabled with compressor cycled off";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate in condenser";
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
    "Nominal mass flow rate in evaporator";
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(displayUnit="Pa")
    "Nominal pressure drop in condenser";
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal(displayUnit="Pa")
    "Nominal pressure drop in evaporator";
  parameter String devIde "Name of the device";
  parameter Boolean use_TEvaOutForTab
    "=true to use evaporator outlet temperature for table data, false for inlet";
  parameter Boolean use_TConOutForTab
    "=true to use condenser outlet temperature for table data, false for inlet";

  annotation (Documentation(info="<html>
<h4>Overview</h4>
<p>
This is the base record class for heat pump and chiller models that use the block
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep</a>
to calculate the capacity and power.
</p>
<p>
This class provides the path to the external data file with the performance
data (parameter <code>fileName</code>) as well as the PLR values at which
capacity and power are specified (parameter <code>PLRSup</code>).
The external data file must be formatted as specified in the documentation 
of the above block. Please also refer to this documentation for the definition 
of the parameters <code>PLRCyc_min</code> and <code>P_min</code>.
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
end Generic;
