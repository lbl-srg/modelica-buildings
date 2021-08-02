within Buildings.Fluid.Interfaces;
partial model PartialWaterPhaseChange
  "Partial model with fundamental parameters for water steam-liquid phase change"
  replaceable package MediumSte = Buildings.Media.Steam constrainedby
    Modelica.Media.Interfaces.PartialMedium
     "Steam medium";
  replaceable package MediumWat = Buildings.Media.Water constrainedby
    Modelica.Media.Interfaces.PartialMedium
    "Water medium";

  // Assumptions
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal. Used only if model has two ports."
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Initialization
  parameter MediumSte.AbsolutePressure p_start = MediumSte.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter MediumSte.Temperature T_start=MediumSte.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
A partial class with common parameters needed 
for modeling water phase change.
</p>
</html>", revisions="<html>
<ul>
<li>
July 22, 2021 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialWaterPhaseChange;
