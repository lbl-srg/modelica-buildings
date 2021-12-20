within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
partial model AHUParameters "Essential parameters for air handling unit"

  parameter Modelica.SIunits.ThermalConductance UA_nominal
    "Thermal conductance at nominal flow for sensible heat, used to compute time constant"
    annotation (Dialog(group="Cooling coil"));
  parameter Real r_nominal=2/3
    "Ratio between air-side and water-side convective heat transfer coefficient"
    annotation (Dialog(group="Cooling coil"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

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
