within Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D;
record Generic "Partial two-dimensional data of refrigerant machines"
    extends Modelica.Icons.Record;
  parameter Real tabPEle[:,:]
    "Electrical power consumption table, T in K, Q_flow in W";
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
  Base data definition used in the heat pump model.
  It defines the table for <code>tab_PEle</code> which gives the electric power
  consumption of the heat pump or chiller.
  Information on heat flow rates are in the corresponding records for
  heat pumps and chillers, as it is the condenser and evaporator heat flow rate,
  respectively.
</p>
<p>
  Both tables define the power values depending on the ambient side temperature
  (defined in first row, in K) and the useful side temperature
  (defined in first column, in K) in W.
</p>
<p>
  Depending on the type of the device, either inlet or outlet conditions are used.
  This feature could be required for air-air devices. Here, the room temperature
  (inlet) and outdoor air temperature (inlet) are used. For air-to-water devices,
  the outdoor air temperature (inlet) and the supply water temperature (outlet) are
  used instead.
  When adding new data, be sure to check if the datasheet uses inlet or outlet
  conditions. Also, be sure to check if the data is for wet- or dry-bulb
  temperatures. The measured temperatures of the modular approach are taken
  directly from the fluid ports and are, thus, always dry bulb.
</p>
<p>
  The nominal mass flow rates in the condenser and evaporator
  are also defined as parameters. If nominal pressure curves are provided
  in the datasheets, be sure to match the two parameters.
  Aside from that, the nominal mass flow rates are compared to the values specified
  by the user. If the deviation is too great, a warning indicates a possible mismatch of
  system mass flow rate and table data.
</p>
<p>
  The string <code>devIde</code> ensures that if data for heating and cooling are required,
  matching records will be used. This parameter is mainly to avoid manual input
  errors.
</p>
<h4>Where to get the data?</h4>
<p>
  Manufacturers often provide table data for heating or cooling capacity and
  electrical power consumption, e.g. based on EN 14511.
  While the usual datasheets only contain some nominal points,
  the documents for installers and planners are often more specific.
  Keywords for a search should be <i>technical guide</i>, <i>planning handbook</i>,
  or similar, together with the manufacturer and possibly the device id.
</p>
<h4>References</h4>
<p>
EN 14511-2018: Air conditioners, liquid chilling packages and heat pumps for space
heating and cooling and process chillers, with electrically driven compressors
<a href=\"https://www.beuth.de/de/norm/din-en-14511-1/298537524\">
https://www.beuth.de/de/norm/din-en-14511-1/298537524</a>
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
"),Icon);
end Generic;
