within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
partial model AHUParameters "Essential parameters for air handling unit"

  parameter Modelica.SIunits.ThermalConductance UA_nominal
    "Thermal conductance at nominal flow for sensible heat, used to compute time constant"
    annotation (Dialog(group="Cooling coil"));
  parameter Real r_nominal=2/3
    "Ratio between air-side and water-side convective heat transfer coefficient"
    annotation (Dialog(group="Cooling coil"));
  parameter Modelica.SIunits.Time tau1 = 20 "Time constant at nominal flow of medium 1"
   annotation (Dialog(group="Cooling coil",
     enable=not (energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Time tau2 = 1 "Time constant at nominal flow of medium 2"
   annotation (Dialog(group="Cooling coil",
     enable=not (energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Time tau_m(min=0) = 20
    "Time constant of metal at nominal UA value"
   annotation(Dialog(tab="General", group="Cooling coil"));
  parameter Integer nEle(min=1) = 4
    "Number of pipe segments used for discretization in the cooling coil"
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
<a href=\"modelica://Buildings.Applications.DataCenters.AHUs\">Buildings.Applications.DataCenters.AHUs</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 08, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end AHUParameters;
