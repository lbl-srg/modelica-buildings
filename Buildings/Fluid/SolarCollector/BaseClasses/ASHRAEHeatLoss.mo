within Buildings.Fluid.SolarCollector.BaseClasses;
block ASHRAEHeatLoss
  "Calculate the heat loss of a solar collector per ASHRAE standard 93"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  extends Buildings.Fluid.SolarCollector.BaseClasses.PartialParameters;
  Modelica.Blocks.Interfaces.RealInput TEnv(
    quantity="Temperature",
    unit="K",
    displayUnit="degC") "Temperature of environment"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  parameter Integer nSeg(min=3) = 3 "Number of segments in the collector model";
public
  Modelica.Blocks.Interfaces.RealInput TFlu[nSeg](
    quantity="Temperature",
    unit = "K",
    displayUnit="degC") "Temperature of the heat transfer fluid"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput QLos[nSeg](
    quantity = "HeatFlowRate",
    unit = "W",
    displayUnit="W")
    "Rate at which heat is lost to ambient from a given segment at current conditions"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer slope
    "slope from ratings data";
  parameter Modelica.SIunits.Irradiance I_nominal
    "Irradiance at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TIn_nominal
    "Inlet temperature at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TEnv_nominal
    "Ambient temperature at nomincal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Fluid flow rate at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.SpecificHeatCapacity Cp
    "Specific heat capacity of the fluid";
protected
  final parameter Modelica.SIunits.HeatFlowRate QUse_nominal(fixed = false)
    "Useful heat gain at nominal conditions";
  final parameter Modelica.SIunits.HeatFlowRate QLos_nominal(fixed = false)
    "Heat loss at nominal conditions";
  final parameter Modelica.SIunits.HeatFlowRate QLosUA[nSeg](fixed = false)
    "Heat loss at current conditions";
  final parameter Modelica.SIunits.Temperature TFlu_nominal[nSeg](each start = 293.15, fixed = false)
    "Temperature of each semgent in the collector at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UA(start = -slope*A_c, fixed = false)
    "Coefficient describing heat loss to ambient conditions";
initial equation
  //Identifies QUse at nominal conditions
  QUse_nominal = I_nominal * A_c * y_intercept +slope * A_c *  (TIn_nominal - TEnv_nominal);
  //Identifies TFlu[nSeg] at nominal conditions
  m_flow_nominal * Cp * (TFlu_nominal[nSeg] - TIn_nominal) = QUse_nominal;
  //Identifies QLost at nominal conditions
  QLos_nominal = -slope * A_c * (TIn_nominal - TEnv_nominal);
   //Governing equation for the first segment (i=1)
   I_nominal * y_intercept * A_c/nSeg - UA/nSeg * (TIn_nominal - TEnv_nominal) = m_flow_nominal * Cp * (TFlu_nominal[1] - TIn_nominal);
   //Loop with the governing equations for segments 2:nSeg-1
   for i in 2:nSeg-1 loop
     I_nominal * y_intercept * A_c/nSeg - UA/nSeg * (TFlu_nominal[i-1] - TEnv_nominal) = m_flow_nominal * Cp * (TFlu_nominal[i] - TFlu_nominal[i-1]);
   end for;
  for i in 1:nSeg loop
    nSeg * QLosUA[i] = UA * (TFlu_nominal[i] - TEnv_nominal);
  end for;
  sum(QLosUA[1:nSeg]) = QLos_nominal;
equation
   for i in 1:nSeg loop
     -QLos[i] * nSeg = UA * (TFlu[i] - TEnv);
   end for;
  annotation (
    defaultComponentName="heaLos",
    Documentation(info="<html>
<p>
This component computes the heat loss from the flat plate solar collector to the environment. It is designed anticipating ratings data collected in accordance with ASHRAE93.
A negative QLos[i] indicates that heat is being lost to the environment.
</p>
<h4>Equations</h4>
<p>
This model calculates the heat lost from a multiple-segment model using ratings data based solely on the inlet temperature. As a resuly, the slope from the ratings data must be converted to a UA value which,
for a given number of segments, returns the same heat loss as the ratings data would at nominal conditions. The equations used to identify the UA value are shown below:
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>Use,nom</sub> = I<sub>nom</sub>*A<sub>c</sub> * F<sub>R</sub>*(&tau;&alpha;) + F<sub>R</sub>U<sub>L</sub>*A<sub>c</sub>*(T<sub>In,nom</sub> - T<sub>Amb,nom</sub>)<br>
T<sub>Fluid,nom</sub>[nSeg]=T<sub>In,nom</sub>+Q<sub>Use,nom</sub>/(m<sub>flow,nom</sub>*C<sub>p</sub>)<br>
Q<sub>Los,nom</sub>=-F<sub>R</sub>U<sub>L</sub>*A<sub>c</sub>*(T<sub>In,nom</sub>-T<sub>Env,nom</sub>)<br>
T<sub>Fluid,nom</sub>[i] = T<sub>Fluid,nom</sub>[i-1] + (G<sub>nom</sub>*F<sub>R</sub>*(&tau;&alpha;) * A<sub>c</sub>/nSeg - UA/nSeg*(T<sub>Fluid,nom</sub>[i-1]-T<sub>Env,nom</sub>))/(m<sub>Flow,nom</sub>*c<sub>p</sub>)<br>
Q<sub>Loss,UA</sub>=UA/nSeg * (T<sub>Fluid,nom</sub>[i]-T<sub>Env,nom</sub>)<br>
sum(Q<sub>Loss,UA</sub>[1:nSeg])=Q<sub>Loss,nom</sub>
</p>
The effective UA value is calculated at the beginning of the simulation and used as a constant through the rest of the simulation. The actual heat loss from the collector is calculated using:
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
end ASHRAEHeatLoss;
