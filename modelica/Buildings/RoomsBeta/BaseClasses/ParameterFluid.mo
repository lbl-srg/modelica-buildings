within Buildings.RoomsBeta.BaseClasses;
record ParameterFluid "Parameter declaration for fluid model"
  import Modelica.Fluid.Types;
  import Modelica.Fluid.Types.Dynamics;

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  // Assumptions
  parameter Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Types.Dynamics massDynamics=energyDynamics
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Types.Dynamics substanceDynamics=energyDynamics
    "Formulation of substance balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Types.Dynamics traceDynamics=energyDynamics
    "Formulation of trace substance balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Boolean use_T_start = true "= true, use T_start, otherwise h_start"
    annotation(Dialog(tab = "Initialization"), Evaluate=true);
  parameter Medium.Temperature T_start=
    if use_T_start then 293.15 else Medium.temperature_phX(p_start,h_start,X_start)
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", enable = use_T_start));
  parameter Medium.SpecificEnthalpy h_start=
    if use_T_start then Medium.specificEnthalpy_pTX(p_start, T_start, X_start) else Medium.h_default
    "Start value of specific enthalpy"
    annotation(Dialog(tab = "Initialization", enable = not use_T_start));
  parameter Medium.MassFraction X_start[Medium.nX] = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
       quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
  parameter Medium.ExtraProperty C_nominal[Medium.nC](
       quantity=Medium.extraPropertiesNames) = fill(1E-2, Medium.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
annotation (
Documentation(
info="<html>
<p>
Base class that defines the parameters that are needed 
to model fluid systems inside the room model.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 4, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

end ParameterFluid;

