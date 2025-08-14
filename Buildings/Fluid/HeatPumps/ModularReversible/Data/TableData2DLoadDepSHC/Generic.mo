within Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDepSHC;
record Generic
  "Partial record to specify performance data for load-dependent data-based models"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.DimensionlessRatio PLRHeaSup[:](each final min=0)
    "PLR values at which heat flow rate and power data are provided - Heating mode";
  parameter Modelica.Units.SI.DimensionlessRatio PLRCooSup[:](each final min=0)
    "PLR values at which heat flow rate and power data are provided - Cooling mode";
  parameter Modelica.Units.SI.DimensionlessRatio PLRShcSup[:](each final min=0)
    "PLR values at which heat flow rate and power data are provided - SHC mode";
  parameter String fileNameHea
    "File where performance data are stored - Heating mode (single module)"
    annotation (Dialog(loadSelector(filter="Text files (*.txt)",caption=
      "Open file in which table is present")));
  parameter String fileNameCoo
    "File where performance data are stored - Cooling mode (single module)"
    annotation (Dialog(loadSelector(filter="Text files (*.txt)",caption=
      "Open file in which table is present")));
  parameter String fileNameShc
    "File where performance data are stored - SHC mode (single module)"
    annotation (Dialog(loadSelector(filter="Text files (*.txt)",caption=
      "Open file in which table is present")));
  parameter String tabNamQHea[nPLRHea]={"q@" + String(p,
    format=".2f") for p in PLRHeaSor}
    "Table names with heat flow rate data - Heating mode"
    annotation (Evaluate=true,
    Dialog(tab="Advanced"));
  parameter String tabNamPHea[nPLRHea]={"p@" + String(p,
    format=".2f") for p in PLRHeaSor}
    "Table names with power data - Heating mode"
    annotation (Evaluate=true,
    Dialog(tab="Advanced"));
  parameter String tabNamQCoo[nPLRCoo]={"q@" + String(p,
    format=".2f") for p in PLRCooSor}
    "Table names with heat flow rate data - Cooling mode"
    annotation (Evaluate=true,
    Dialog(tab="Advanced"));
  parameter String tabNamPCoo[nPLRCoo]={"p@" + String(p,
    format=".2f") for p in PLRCooSor}
    "Table names with power data - Cooling mode"
    annotation (Evaluate=true,
    Dialog(tab="Advanced"));
  parameter String tabNamQShc[nPLRShc]={"q@" + String(p,
    format=".2f") for p in PLRShcSor}
    "Table names with cooling heat flow rate data - SHC mode"
    annotation (Evaluate=true,
    Dialog(tab="Advanced"));
  parameter String tabNamPShc[nPLRShc]={"p@" + String(p,
    format=".2f") for p in PLRShcSor}
    "Table names with power data - SHC mode"
    annotation (Evaluate=true,
    Dialog(tab="Advanced"));

  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Nominal HW mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
    "Nominal CHW mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(displayUnit="Pa")
    "Nominal pressure drop in condenser";
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal(displayUnit="Pa")
    "Nominal pressure drop in evaporator";
  parameter String devIde "Name of the device";
  parameter Boolean use_TEvaOutForTab
    "=true to use CHW temperature at outlet for table data, false for inlet";
  parameter Boolean use_TConOutForTab
    "=true to use HW temperature at outlet for table data, false for inlet";
  final parameter Integer nPLRHea=size(PLRHeaSup, 1)
    "Number of PLR support points - Heating"
    annotation (Evaluate=true);
  final parameter Integer nPLRCoo=size(PLRCooSup, 1)
    "Number of PLR support points - Cooling"
    annotation (Evaluate=true);
  final parameter Integer nPLRShc=size(PLRShcSup, 1)
    "Number of PLR support points - SHC"
    annotation (Evaluate=true);
  final parameter Real PLRHeaSor[nPLRHea]=Modelica.Math.Vectors.sort(PLRHeaSup)
    "PLR values in increasing order - Heating";
  final parameter Real PLRHea_max=PLRHeaSor[nPLRHea]
    "Maximum PLR";
  final parameter Real PLRCooSor[nPLRCoo]=Modelica.Math.Vectors.sort(PLRCooSup)
    "PLR values in increasing order - Cooling";
  final parameter Real PLRCoo_max=PLRCooSor[nPLRCoo]
    "Maximum PLR - Cooling mode";
  final parameter Real PLRShcSor[nPLRShc]=Modelica.Math.Vectors.sort(PLRShcSup)
    "PLR values in increasing order - SHC";
  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="dat",
  Documentation(info="<html>
<h4>Overview</h4>
<p>
This is the base record class for heat pump models that use the block
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC</a>
to calculate the capacity and power.
</p>
<p>
This class provides the path to the external data file with the performance
data (parameter <code>fileName</code>) as well as the PLR values at which
capacity and power are specified (parameter <code>PLRSup</code>).
The external data file must be formatted as specified in the documentation
of the above block.
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
