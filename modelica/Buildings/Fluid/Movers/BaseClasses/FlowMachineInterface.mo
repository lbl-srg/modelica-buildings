within Buildings.Fluid.Movers.BaseClasses;
partial model FlowMachineInterface
  "Partial model with performance curves for fans or pumps"
  extends Buildings.Fluid.Movers.BaseClasses.PowerInterface;

  import Modelica.Constants;

  // Characteristics
  replaceable function flowCharacteristic =
      Characteristics.baseFlow
    "Total pressure vs. V_flow characteristic at nominal speed"
    annotation(Dialog(group="Characteristics"), choicesAllMatching=true);
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm
    N_nominal = 1500 "Nominal rotational speed for flow characteristic"
    annotation(Dialog(group="Characteristics"));

  replaceable function powerCharacteristic =
        Characteristics.quadraticPower (
       V_flow_nominal={0,0,0},P_nominal={0,0,0})
    "Power consumption vs. V_flow at nominal speed and density"
    annotation(Dialog(group="Characteristics", enable = use_powerCharacteristic),
               choicesAllMatching=true);

  // Variables
  Modelica.SIunits.Density rho "Medium density";
  Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm N(min=0, start = N_nominal)
    "Shaft rotational speed";
  Real r_N(min=0, start=1) "Ratio N/N_nominal";

initial equation
  // Equation to compute V_flow_max
  0 = flowCharacteristic(V_flow=V_flow_max, r_N=1);

equation
  r_N = N/N_nominal;
  dpMachine = flowCharacteristic(V_flow=VMachine_flow, r_N=r_N);

  // Power consumption
  if use_powerCharacteristic then
    PEle = (rho/rho_nominal)*powerCharacteristic(V_flow=VMachine_flow, r_N=r_N);
    // In this configuration, we only now the total power consumption.
    // Hence, we assign the efficiency in equal parts to the motor and the hydraulic losses
    etaMot = sqrt(eta);
  else
    etaHyd = hydraulicEfficiency(r_V=r_V);
    etaMot = motorEfficiency(r_V=r_V);
  end if;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
            graphics),
    Documentation(info="<html>
<p>
This is an interface that implements the functions to compute the head, power draw 
and efficiency of fans and pumps. It is used by the model 
<a href=\"modelica://Buildings.Fluids.Movers.BaseClasses.PrescribedFlowMachine\">PrescribedFlowMachine</a>.
</p>
The nominal hydraulic characteristic (total pressure vs. volume flow rate) is given by the the replaceable function <code>flowCharacteristic</code>.
<p>The fan or pump energy balance can be specified in two alternative ways: </p>
<p><ul>
<li>
If <code>use_powerCharacteristic = false</code>, the replaceable function
<code>efficiencyCharacteristic</code>
(efficiency vs. normalized volume flow rate) is used to determine the efficiency, 
and then the power consumption. The default is a constant efficiency of 0.8.
</li>
<li>
If <code>use_powerCharacteristic = true</code>, the replaceable function
<code>powerCharacteristic</code> (power consumption vs. normalized volume flow rate 
at nominal conditions) 
is used to determine the power consumption, and then the efficiency. 
Use
<code>powerCharacteristic</code> to specify a non-zero power consumption for zero flow rate.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 23 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end FlowMachineInterface;
