within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
partial model AHUParameters "Essential parameters for air handling unit"

  parameter Modelica.Units.SI.ThermalConductance UA_nominal
    "Thermal conductance at nominal flow for sensible heat, used to compute time constant"
    annotation (Dialog(group="Cooling coil"));
  parameter Real r_nominal=2/3
    "Ratio between air-side and water-side convective heat transfer coefficient"
    annotation (Dialog(group="Cooling coil"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  annotation (
Documentation(info="<html>
<p>
This  block declares parameters that are required by most classes in the package
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Equipment\">
Buildings.Applications.DataCenters.ChillerCooled.Equipment</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 3, 2022, by Michael Wetter:<br/>
Moved <code>massDynamics</code> to <code>Advanced</code> tab,
added assertion for correct combination of energy and mass dynamics and
changed type from <code>record</code> to <code>block</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">issue 1542</a>.
</li>
<li>
June 30, 2021, by Antoine Gautier:<br/>
Removed unused parameters. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2549\">issue #2549</a>.
</li>
<li>
April 08, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end AHUParameters;
