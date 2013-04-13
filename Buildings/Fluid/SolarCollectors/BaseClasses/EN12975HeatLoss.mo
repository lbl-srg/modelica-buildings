within Buildings.Fluid.SolarCollectors.BaseClasses;
block EN12975HeatLoss
  "Calculate the heat loss of a solar collector per EN12975"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  // fixme: ASHRAEHeatLoss and EN12975HeatLoss contain too much copied code.
  //        Use a common base class, and just implement in these classes
  //        what is different between the models.
  extends SolarCollectors.BaseClasses.PartialParameters;
  Modelica.Blocks.Interfaces.RealInput TEnv(
    quantity="Temperature",
    unit="K") "Temperature of environment"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  parameter Integer nSeg(min=3) = 3 "Number of segments in the collector model";

  Modelica.Blocks.Interfaces.RealInput TFlu[nSeg](
    quantity="Temperature",
    unit = "K") "Temperature of the heat transfer fluid"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput QLos[nSeg](
    quantity = "HeatFlowRate",
    unit = "W")
    "Rate at which heat is lost to ambient from a given segment at current conditions"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer C1
    "C1 from ratings data";
  parameter Real C2(
  final unit = "W/(m2.K2)") "C2 from ratings data";
  parameter Modelica.SIunits.Irradiance I_nominal
    "Irradiance at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TMean_nominal
    "Inlet temperature at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TEnv_nominal
    "Ambient temperature at nomincal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Fluid flow rate at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  // This should be cp_nominal
  parameter Modelica.SIunits.SpecificHeatCapacity Cp
    "Specific heat capacity of the fluid";
protected
  final parameter Modelica.SIunits.HeatFlowRate QUse_nominal(fixed = false)
    "Useful heat gain at nominal conditions";
  final parameter Modelica.SIunits.HeatFlowRate QLos_nominal(fixed = false)
    "Heat loss at nominal conditions";
  final parameter Modelica.SIunits.HeatFlowRate QLosUA_nominal[nSeg](fixed = false)
    "Heat loss at current conditions";
  final parameter Modelica.SIunits.Temperature TFlu_nominal[nSeg](fixed = false)
    "Temperature of the fluid in each semgent in the collector at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UA_nominal(
     fixed = false,
     start=QLos_nominal/(TMean_nominal - TEnv_nominal))
    "Coefficient describing heat loss to ambient conditions";
initial equation
   //Identifies QUse at nominal conditions
   QUse_nominal = I_nominal * A_c * y_intercept -C1 * A_c *
      (TMean_nominal - TEnv_nominal) - C2 * A_c * (TMean_nominal - TEnv_nominal)^2;
   //Identifies TFlu[nSeg] at nominal conditions
   m_flow_nominal * Cp * (TFlu_nominal[nSeg] - TMean_nominal) = QUse_nominal;
   //Identifies QLos at nominal conditions
   QLos_nominal = -C1 * A_c * (TMean_nominal - TEnv_nominal)-C2 * A_c * (TMean_nominal - TEnv_nominal)^2;
   //Governing equation for the first segment (i=1)
   I_nominal * y_intercept * A_c/nSeg - UA_nominal/nSeg * (TMean_nominal - TEnv_nominal)
     = m_flow_nominal * Cp * (TFlu_nominal[1] - TMean_nominal);
   //Loop with the governing equations for segments 2:nSeg-1
   for i in 2:nSeg-1 loop
     I_nominal * y_intercept * A_c/nSeg - UA_nominal/nSeg * (TFlu_nominal[i-1] - TEnv_nominal)
      = m_flow_nominal * Cp * (TFlu_nominal[i] - TFlu_nominal[i-1]);
   end for;
   for i in 1:nSeg loop
     nSeg * QLosUA_nominal[i] = UA_nominal * (TFlu_nominal[i] - TEnv_nominal);
   end for;
   sum(QLosUA_nominal) = QLos_nominal;
equation
   for i in 1:nSeg loop
     QLos[i] * nSeg = UA_nominal * (TFlu[i] - TEnv);
   end for;
  annotation (
    defaultComponentName="heaLos",
    Documentation(info="<html>
<p>
This component computes the heat loss from the flat plate solar collector to the environment. It is designed anticipating ratings data collected in accordance with EN12975.
A negative QLos[i] indicates that heat is being lost to the environment.
</p>
<h4>Equations</h4>
<p>
This model calculates the heat lost from a multiple-segment model using ratings data based solely on the inlet temperature. As a result, the slope from the ratings data must be converted to a UA value which,
for a given number of segments, returns the same heat loss as the ratings data would at nominal conditions. The equations used to identify the UA value are shown below:
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>Use,nom</sub> = I<sub>nom</sub>*A<sub>c</sub> * F<sub>R</sub>(&tau;&alpha;) - C<sub>1</sub>*A<sub>c</sub>*(T<sub>Mean,nom</sub> - T<sub>Env,nom</sub>)-C<sub>2</sub>*A<sub>c</sub>*(T<sub>Mean,nom</sub>-T<sub>Env,nom</sub>)^2<br>
T<sub>Fluid,nom</sub>[nSeg]=T<sub>Mean,nom</sub>+Q<sub>Use,nom</sub>/(m<sub>flow,nom</sub>*C<sub>p</sub>)<br>
Q<sub>Los,nom</sub>=-C<sub>1</sub>*A<sub>c</sub>*(T<sub>Mean,nom</sub>-T<sub>Env,nom</sub>)-C<sub>2</sub>*A<sub>c</sub>*(T<sub>Mean,nom</sub>-T<sub>Env,nom</sub>)^2<br>
T<sub>Fluid,nom</sub>[i] = T<sub>Fluid,nom</sub>[i-1] + (G<sub>nom</sub>*F<sub>R</sub>(&tau;&alpha;) * A<sub>c</sub>/nSeg - UA/nSeg*(T<sub>Fluid,nom</sub>[i-1]-T<sub>Env,nom</sub>))/(m<sub>Flow,nom</sub>*c<sub>p</sub>)<br>
Q<sub>Loss,UA</sub>=UA/nSeg * (T<sub>Fluid,nom</sub>[i]-T<sub>Env,nom</sub>)<br>
sum(Q<sub>Loss,UA</sub>[1:nSeg])=Q<sub>Loss,nom</sub>
</p>
<p>
The effective UA value is calculated at the beginning of the simulation and used as a constant through the rest of the simulation. The actual heat loss from the collector is calculated using:
</p>
<p align=\"center\" style=\"font-style:italic;\">
-Q<sub>Loss</sub>[i] = UA/nSeg * (T<sub>Fluid</sub>[i] - T<sub>Env</sub>)
</p>

<h4>References</h4>
<p>
J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition), John Wiley & Sons, Inc.  
</p>
</html>", revisions="<html>
<ul>
<li>
Jan 16, 2012, by Peter Grant:<br>
First implementation
</li>
</ul>
</html>"),
    Diagram(graphics),
    Icon(graphics={Text(
          extent={{-48,-32},{36,-66}},
          lineColor={0,0,255},
          textString="%name")}));
end EN12975HeatLoss;
