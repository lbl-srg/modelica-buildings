within Buildings.Fluid.Movers.BaseClasses;
partial model FlowMachineInterface
  "Partial model with performance curves for fans or pumps"
  extends Buildings.Fluid.Movers.BaseClasses.PowerInterface(
    VMachine_flow(start=V_flow_nominal),
    V_flow_max(start=V_flow_nominal));

  import Modelica.Constants;
  import cha = Buildings.Fluid.Movers.BaseClasses.Characteristics;

  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm
    N_nominal = 1500 "Nominal rotational speed for flow characteristic"
    annotation(Dialog(group="Characteristics"));
  final parameter Modelica.SIunits.VolumeFlowRate V_flow_nominal = pressure.V_flow[size(pressure.V_flow,1)]
    "Nominal volume flow rate, used for homotopy";
  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters pressure
    "Volume flow rate vs. total pressure rise"
    annotation(Placement(transformation(extent={{20,-80},{40,-60}})),
               Dialog(group="Characteristics"));
  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters power
    "Volume flow rate vs. electrical power consumption"
    annotation(Placement(transformation(extent={{20,-40},{40,-20}})),
               Dialog(group="Characteristics", enable = use_powerCharacteristic));

  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm N(min=0, start = N_nominal)
    "Shaft rotational speed";
  Real r_N(min=0, start=1, unit="1") "Ratio N/N_nominal";
  Real r_V(start=1, unit="1") "Ratio V_flow/V_flow_max";
protected
  parameter Modelica.SIunits.VolumeFlowRate VDelta_flow(fixed=false, start=delta*V_flow_nominal)
    "Small volume flow rate";
  parameter Modelica.SIunits.Pressure dpDelta(fixed=false, start=100)
    "Small pressure";
  parameter Real delta = 0.05
    "Small value used to transition to other fan curve";
  parameter Real cBar[2](fixed=false)
    "Coefficients for linear approximation of pressure vs. flow rate";
  parameter Modelica.SIunits.Pressure dpMax(min=0, fixed=false);

 parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters pressureCor(V_flow=pressure.V_flow,
   dp(fixed=false))
    "Volume flow rate vs. total pressure rise with correction for pump resistance added";
 parameter Real preDerCor[size(pressure.V_flow,1)]=Buildings.Utilities.Math.Functions.splineDerivatives(
       x=pressureCor.V_flow, y=pressureCor.dp)
    "Coefficients for polynomial of pressure vs. flow rate";

  parameter Real preDer[size(pressure.V_flow,1)](fixed=false)
    "Coefficients for polynomial of pressure vs. flow rate";
  parameter Real powDer[size(power.V_flow,1)]=
   if use_powerCharacteristic then
     Buildings.Utilities.Math.Functions.splineDerivatives(
                   x=power.V_flow,
                   y=power.P)
   else
     zeros(size(power.V_flow,1))
    "Coefficients for polynomial of pressure vs. flow rate";

  // Variables
  Modelica.SIunits.Density rho "Medium density";

function getPerformanceDataAsString
  input Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters pressure
      "Performance data";
  input Real derivative[:](unit="kg/(s.m4)") "Derivative";
  input Integer minimumLength =  6 "Minimum width of result";
  input Integer significantDigits = 6 "Number of significant digits";
  output String str "String representation";
algorithm
  str :="";
  for i in 1:size(pressure.V_flow, 1) loop
    str :=str + "  V_flow[" + String(i) + "]=" + String(
        pressure.V_flow[i],
        minimumLength=minimumLength,
        significantDigits=significantDigits) + "\t" + "dp[" + String(i) + "]=" +
        String(
        pressure.dp[i],
        minimumLength=minimumLength,
        significantDigits=significantDigits) + "\tResulting derivative dp/dV_flow = "
         + String(
        derivative[i],
        minimumLength=minimumLength,
        significantDigits=significantDigits) + "\n";
  end for;
end getPerformanceDataAsString;

initial algorithm
  // Pressure derivatives at support points
  preDer:=Buildings.Utilities.Math.Functions.splineDerivatives(
    x=pressure.V_flow,
    y=pressure.dp);
  // Note that if dpMax=0 in the function calls below, then the value of V_flow_max has no effect on the results.
  // But we need to set V_flow_max to a non-zero number to avoid a division by zero.

  // Write warning if the volumetric flow rate versus pressure curve is non-decreasing
  if (not Buildings.Utilities.Math.Functions.isMonotonic(x=pressure.dp, strict=false)) then
    Modelica.Utilities.Streams.print("
Warning:
========
It is recommended that the volume flow rate versus pressure relation
of the fan or pump is a decreasing sequence. Otherwise, a solution 
to the equations may not exist if the fan or pump speed is reduced.
In this situation, the solver will fail due to non-convergence and 
the simulation stops.
The following performance data have been entered:
" + getPerformanceDataAsString(pressure, preDer));
  end if;

  // Equation to compute V_flow_max.
  assert(preDer[size(preDer,1)] < 0,
  "The pump or fan pressure raise data are such that the performance curve
  is increasing for flow rates greater than " + String(pressure.V_flow[size(preDer,1)]) + " m3/h.
  This is not allowed. You need to provide more reasonable performance data than the following data:\n"
    + getPerformanceDataAsString(pressure, preDer));

  // Maximum flow rate if r_N=1 and dp=0.
  // Since the spline use linear extrapolation, this can be simply computed using a linear function
  V_flow_max :=pressure.V_flow[size(preDer, 1)] + pressure.dp[size(preDer, 1)]/
    preDer[size(preDer, 1)];

  // Equation to compute VDelta_flow. By the affinity laws, the volume flow rate is proportional to the speed.
  VDelta_flow :=V_flow_max*delta;

  // Equation to compute dpDelta
  dpDelta :=cha.pressure(
    data=pressure,
    V_flow=0,
    r_N=delta,
    VDelta_flow=0,
    dpDelta=0,
    V_flow_max=Modelica.Constants.eps,
    dpMax=0,
    delta=0,
    d=preDer,
    cBar=zeros(2));

  dpMax :=cha.pressure(
    data=pressure,
    V_flow=0,
    r_N=1,
    VDelta_flow=0,
    dpDelta=0,
    V_flow_max=Modelica.Constants.eps,
    dpMax=0,
    delta=0,
    d=preDer,
    cBar=zeros(2));

  // Correction for flow resistance of pump or fan
  for i in 1:size(pressure.V_flow, 1) loop
    pressureCor.dp[i]  :=pressure.dp[i] + pressure.V_flow[i]/V_flow_max*dpMax*
      Characteristics.deltaLinear;
  end for;

  // Linear equations to determine cBar
  // Conditions for r_N=delta, V_flow = VDelta_flow
  // Conditions for r_N=delta, V_flow = 0
  cBar[1] :=(cha.pressure(
    data=pressureCor,
    V_flow=0,
    r_N=delta,
    VDelta_flow=0,
    dpDelta=0,
    V_flow_max=Modelica.Constants.eps,
    dpMax=0,
    delta=0,
    d=preDer,
    cBar=zeros(2)) - delta*dpDelta)/delta^2;

  cBar[2] :=((cha.pressure(
    data=pressureCor,
    V_flow=VDelta_flow,
    r_N=delta,
    VDelta_flow=0,
    dpDelta=0,
    V_flow_max=Modelica.Constants.eps,
    dpMax=0,
    delta=0,
    d=preDer,
    cBar=zeros(2)) - delta*dpDelta)/delta^2 - cBar[1])/VDelta_flow;
equation
  r_N = N/N_nominal;
  r_V = VMachine_flow/V_flow_max;
  // For the homotopy method, we approximate dpMachine by an equation
  // that is linear in VMachine_flow, and that goes linearly to 0 as r_N goes to 0.
  if homotopyInitialization then
     dpMachine = homotopy(actual=cha.pressure(data=pressureCor,
                                                    V_flow=VMachine_flow, r_N=r_N,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDerCor, cBar=cBar),
                          simplified=r_N*
                              (cha.pressure(data=pressureCor,
                                                    V_flow=V_flow_nominal, r_N=1,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDerCor, cBar=cBar)
                               +(VMachine_flow-V_flow_nominal)*
                                (cha.pressure(data=pressureCor,
                                                    V_flow=(1+delta)*V_flow_nominal, r_N=1,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDerCor, cBar=cBar)
                                -cha.pressure(data=pressureCor,
                                                    V_flow=(1-delta)*V_flow_nominal, r_N=1,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDerCor, cBar=cBar))
                                 /(2*delta*V_flow_nominal)));

   else
     dpMachine = cha.pressure(data=pressureCor,        V_flow=VMachine_flow, r_N=r_N,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta, V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDerCor, cBar=cBar);
   end if;

  // Power consumption
  if use_powerCharacteristic then
    // For the homotopy, we want PEle/V_flow to be bounded as V_flow -> 0 to avoid a very high medium
    // temperature near zero flow.
    if homotopyInitialization then
      PEle = homotopy(actual=cha.power(data=power, V_flow=VMachine_flow, r_N=r_N, d=powDer),
                      simplified=VMachine_flow/V_flow_nominal*
                            cha.power(data=power, V_flow=V_flow_nominal, r_N=1, d=powDer));
    else
      PEle = (rho/rho_nominal)*cha.power(data=power, V_flow=VMachine_flow, r_N=r_N, d=powDer);
    end if;
    // In this configuration, we only now the total power consumption.
    // Hence, we assign the efficiency in equal parts to the motor and the hydraulic losses
    etaMot = sqrt(eta);
  else
    if homotopyInitialization then
      etaHyd = homotopy(actual=cha.efficiency(data=hydraulicEfficiency,     r_V=r_V, d=hydDer),
                        simplified=cha.efficiency(data=hydraulicEfficiency, r_V=1,   d=hydDer));
      etaMot = homotopy(actual=cha.efficiency(data=motorEfficiency,     r_V=r_V, d=motDer),
                        simplified=cha.efficiency(data=motorEfficiency, r_V=1,   d=motDer));
    else
      etaHyd = cha.efficiency(data=hydraulicEfficiency, r_V=r_V, d=hydDer);
      etaMot = cha.efficiency(data=motorEfficiency,     r_V=r_V, d=motDer);
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
<p>
The nominal hydraulic characteristic (total pressure vs. volume flow rate) is given by the the replaceable function <code>flowCharacteristic</code>.
</p>
<p>The fan or pump energy balance can be specified in two alternative ways: </p>
<p>
<ul>
<li>
If <code>use_powerCharacteristic = false</code>, the replaceable function
<code>efficiencyCharacteristic</code>
(efficiency vs. normalized volume flow rate) is used to determine the efficiency, 
and then the power consumption. The default is a constant efficiency of 0.8.
</li>
<li>
If <code>use_powerCharacteristic = true</code>, the replaceable function
<code>powerCharacteristic</code> (power consumption vs. normalized volume flow rate 
at nominal conditions) is used to determine the power consumption, and then the efficiency
is computed based on the actual power consumption and the flow work. 
</p>
</html>",
revisions="<html>
<ul>
<li>
August 25 2011, by Michael Wetter:<br>
Revised the implementation of the pressure drop computation as a function
of speed and volume flow rate.
The new implementation avoids a singularity near zero volume flow rate and zero speed.
</li>
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
