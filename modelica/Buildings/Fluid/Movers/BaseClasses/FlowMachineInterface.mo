within Buildings.Fluid.Movers.BaseClasses;
partial model FlowMachineInterface
  "Partial model with performance curves for fans or pumps"
  extends Buildings.Fluid.Movers.BaseClasses.PowerInterface;

  import Modelica.Constants;

  // Characteristics
  replaceable function flowCharacteristic =
      Buildings.Fluid.Movers.BaseClasses.Characteristics.baseFlow
    "Total pressure vs. V_flow characteristic at nominal speed"
    annotation(Dialog(group="Characteristics"), choicesAllMatching=true);
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm
    N_nominal = 1500 "Nominal rotational speed for flow characteristic"
    annotation(Dialog(group="Characteristics"));
  parameter Modelica.SIunits.VolumeFlowRate V_flow_nominal
    "Nominal volume flow rate, used for homotopy";

  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  replaceable function powerCharacteristic =
        Buildings.Fluid.Movers.BaseClasses.Characteristics.quadraticPower (
       V_flow_nominal={0,0,0},P_nominal={0,0,0})
    "Power consumption vs. V_flow at nominal speed and density"
    annotation(Dialog(group="Characteristics", enable = use_powerCharacteristic),
               choicesAllMatching=true);

  // Variables
  Modelica.SIunits.Density rho "Medium density";
  Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm N(min=0, start = N_nominal)
    "Shaft rotational speed";
  Real r_N(min=0, start=1, unit="1") "Ratio N/N_nominal";

protected
  constant Real delta = 0.01 "Constant used in finite difference approximation to derivative";
initial equation
  // Equation to compute V_flow_max
  0 = flowCharacteristic(V_flow=V_flow_max, r_N=1);

equation
  r_N = N/N_nominal;
  // For the homotopy method, we approximate dpMachine by a finite difference equation 
  // that is linear in VMachine_flow, and that goes linearly to 0 as r_N goes to 0.
  if homotopyInitialization then
     dpMachine = homotopy(actual=flowCharacteristic(V_flow=VMachine_flow, r_N=r_N),
                          simplified=r_N*
                              (flowCharacteristic(V_flow=V_flow_nominal, r_N=1)
                               +(VMachine_flow-V_flow_nominal)*
                                (flowCharacteristic(V_flow=(1+delta)*V_flow_nominal, r_N=1)
                                -flowCharacteristic(V_flow=(1-delta)*V_flow_nominal, r_N=1))
                                 /(2*delta*V_flow_nominal)));

   else
     dpMachine = flowCharacteristic(V_flow=VMachine_flow, r_N=r_N);
   end if;

  // Power consumption
  if use_powerCharacteristic then
    // For the homotopy, we want PEle/V_flow to be bounded as V_flow -> 0 to avoid a very high medium 
    // temperature near zero flow.
    if homotopyInitialization then
      PEle = homotopy(actual=powerCharacteristic(V_flow=VMachine_flow, r_N=r_N),
                      simplified=VMachine_flow/V_flow_nominal*powerCharacteristic(V_flow=V_flow_nominal, r_N=1));
    else
      PEle = (rho/rho_nominal)*powerCharacteristic(V_flow=VMachine_flow, r_N=r_N);
    end if;
    // In this configuration, we only now the total power consumption.
    // Hence, we assign the efficiency in equal parts to the motor and the hydraulic losses
    etaMot = sqrt(eta);
  else
    if homotopyInitialization then
      etaHyd = homotopy(actual=hydraulicEfficiency(r_V=r_V), simplified=hydraulicEfficiency(r_V=1));
      etaMot = homotopy(actual=motorEfficiency(r_V=r_V),     simplified=motorEfficiency(r_V=r_V));
    else
      etaHyd = hydraulicEfficiency(r_V=r_V);
      etaMot = motorEfficiency(r_V=r_V);
    end if;
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
March 28 2011, by Michael Wetter:<br>
Added <code>homotopy</code> operator.
</li>
<li>
March 23 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end FlowMachineInterface;
