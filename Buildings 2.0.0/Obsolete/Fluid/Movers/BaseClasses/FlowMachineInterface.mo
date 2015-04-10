within Buildings.Obsolete.Fluid.Movers.BaseClasses;
partial model FlowMachineInterface
  "Partial model with performance curves for fans or pumps"
  extends Buildings.Obsolete.Fluid.Movers.BaseClasses.PowerInterface(
    VMachine_flow(nominal=V_flow_nominal, start=V_flow_nominal),
    V_flow_max(nominal=V_flow_nominal, start=V_flow_nominal));

  import Modelica.Constants;
  import cha = Buildings.Obsolete.Fluid.Movers.BaseClasses.Characteristics;

  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm
    N_nominal = 1500 "Nominal rotational speed for flow characteristic"
    annotation(Dialog(group="Characteristics"));
  final parameter Modelica.SIunits.VolumeFlowRate V_flow_nominal=
    pressure.V_flow[size(pressure.V_flow,1)]
    "Nominal volume flow rate, used for homotopy";
  parameter Buildings.Obsolete.Fluid.Movers.BaseClasses.Characteristics.flowParameters pressure
    "Volume flow rate vs. total pressure rise"
    annotation(Placement(transformation(extent={{20,-80},{40,-60}})),
               Dialog(group="Characteristics"));
  parameter Buildings.Obsolete.Fluid.Movers.BaseClasses.Characteristics.powerParameters power
    "Volume flow rate vs. electrical power consumption"
    annotation(Placement(transformation(extent={{20,-40},{40,-20}})),
               Dialog(group="Characteristics", enable = use_powerCharacteristic));

  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  // Classes used to implement the filtered speed
  parameter Boolean filteredSpeed=true
    "= true, if speed is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered speed"));
  parameter Modelica.SIunits.Time riseTime=30
    "Rise time of the filter (time to reach 99.6 % of the speed)"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));
  parameter Real N_start=0 "Initial value of speed"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));

  // Speed
  Modelica.Blocks.Interfaces.RealOutput N_actual(min=0, max=N_nominal,
                                                 final quantity="AngularVelocity",
                                                 final unit="1/min",
                                                 nominal=N_nominal)
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,40},{120,60}})));

  // "Shaft rotational speed in rpm";
  Real r_N(min=0, start=N_start/N_nominal, unit="1") "Ratio N_actual/N_nominal";
  Real r_V(start=1, unit="1") "Ratio V_flow/V_flow_max";

protected
  Modelica.Blocks.Interfaces.RealOutput N_filtered(min=0, start=N_start, max=N_nominal) if
     filteredSpeed "Filtered speed in the range 0..N_nominal"
    annotation (Placement(transformation(extent={{40,78},{60,98}}),
        iconTransformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Continuous.Filter filter(
     order=2,
     f_cut=5/(2*Modelica.Constants.pi*riseTime),
     final init=init,
     final y_start=N_start,
     x(each stateSelect=StateSelect.always),
     u_nominal=N_nominal,
     u(final quantity="AngularVelocity", final unit="1/min", nominal=N_nominal),
     y(final quantity="AngularVelocity", final unit="1/min", nominal=N_nominal),
     final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
     final filterType=Modelica.Blocks.Types.FilterType.LowPass) if
        filteredSpeed
    "Second order filter to approximate valve opening time, and to improve numerics"
    annotation (Placement(transformation(extent={{20,81},{34,95}})));
  parameter Modelica.SIunits.VolumeFlowRate VDelta_flow(fixed=false, start=delta*V_flow_nominal)
    "Small volume flow rate";
  parameter Modelica.SIunits.Pressure dpDelta(fixed=false, start=100)
    "Small pressure";
  parameter Real delta = 0.05
    "Small value used to transition to other fan curve";
  parameter Real cBar[2](each fixed=false)
    "Coefficients for linear approximation of pressure vs. flow rate";
  parameter Modelica.SIunits.Pressure dpMax(min=0, fixed=false);
  parameter Real kRes(min=0, unit="kg/(s.m4)", fixed=false)
    "Coefficient for internal pressure drop of fan or pump";

  parameter Integer curve(min=1, max=3, fixed=false)
    "Flag, used to pick the right representatio of the fan or pump pressure curve";
  parameter Integer nOri = size(pressure.V_flow,1)
    "Number of data points for pressure curve";
  parameter
    Buildings.Obsolete.Fluid.Movers.BaseClasses.Characteristics.flowParametersInternal pCur1(
    final n = nOri,
    V_flow(each fixed=false), dp(each fixed=false))
    "Volume flow rate vs. total pressure rise with correction for pump resistance added";
  parameter
    Buildings.Obsolete.Fluid.Movers.BaseClasses.Characteristics.flowParametersInternal pCur2(
   final n = nOri + 1,
    V_flow(each fixed=false), dp(each fixed=false))
    "Volume flow rate vs. total pressure rise with correction for pump resistance added";
  parameter
    Buildings.Obsolete.Fluid.Movers.BaseClasses.Characteristics.flowParametersInternal pCur3(
   final n = nOri + 2,
    V_flow(each fixed=false), dp(each fixed=false))
    "Volume flow rate vs. total pressure rise with correction for pump resistance added";
  parameter Real preDer1[nOri](each fixed=false)
    "Derivatives of flow rate vs. pressure at the support points";
  parameter Real preDer2[nOri+1](each fixed=false)
    "Derivatives of flow rate vs. pressure at the support points";
  parameter Real preDer3[nOri+2](each fixed=false)
    "Derivatives of flow rate vs. pressure at the support points";
  parameter Real powDer[size(power.V_flow,1)]=
   if use_powerCharacteristic then
     Buildings.Utilities.Math.Functions.splineDerivatives(
                   x=power.V_flow,
                   y=power.P,
                   ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(x=power.P,
                                                                                     strict=false))
   else
     zeros(size(power.V_flow,1))
    "Coefficients for polynomial of pressure vs. flow rate";

  parameter Boolean haveMinimumDecrease(fixed=false) "Flag used for reporting";
  parameter Boolean haveDPMax(fixed=false)
    "Flag, true if user specified data that contain dpMax";
  parameter Boolean haveVMax(fixed=false)
    "Flag, true if user specified data that contain V_flow_max";

  // Variables
  Modelica.SIunits.Density rho "Medium density";

function getPerformanceDataAsString
  input Buildings.Obsolete.Fluid.Movers.BaseClasses.Characteristics.flowParameters pressure
      "Performance data";
  input Real derivative[:](unit="kg/(s.m4)") "Derivative";
  input Integer minimumLength =  6 "Minimum width of result";
  input Integer significantDigits = 6 "Number of significant digits";
  output String str "String representation";
algorithm
  str :="";
  for i in 1:size(derivative, 1) loop
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

function getArrayAsString
  input Real array[:] "Array to be printed";
  input String varName "Variable name";
  input Integer minimumLength =  6 "Minimum width of result";
  input Integer significantDigits = 6 "Number of significant digits";
  output String str "String representation";
algorithm
  str :="";
  for i in 1:size(array, 1) loop
    str :=str + "  " + varName + "[" + String(i) + "]=" + String(
        array[i],
        minimumLength=minimumLength,
        significantDigits=significantDigits) + "\n";
  end for;
end getArrayAsString;

initial algorithm
  // Check validity of data
  assert(size(pressure.V_flow, 1) > 1, "Must have at least two data points for pressure.V_flow.");
  assert(Buildings.Utilities.Math.Functions.isMonotonic(x=pressure.V_flow, strict=true) and
  pressure.V_flow[1] > -Modelica.Constants.eps,
  "The volume flow rate for the fan pressure rise must be a strictly decreasing sequence
  with the first element being non-zero.
The following performance data have been entered:
" + getArrayAsString(pressure.V_flow, "pressure.V_flow"));

  // Check if V_flow_max or dpMax are provided by user
  haveVMax  :=(abs(pressure.dp[nOri])   < Modelica.Constants.eps);
  haveDPMax :=(abs(pressure.V_flow[1])  < Modelica.Constants.eps);
  // Assign V_flow_max and dpMax
  if haveVMax then
    V_flow_max :=pressure.V_flow[nOri];
  else
    assert((pressure.V_flow[nOri]-pressure.V_flow[nOri-1])/((pressure.dp[nOri]-pressure.dp[nOri-1]))<0,
    "The last two pressure points for the fan or pump performance curve must be decreasing.
    You need to set more reasonable parameters.
Received
" + getArrayAsString(pressure.dp, "dp"));
    V_flow_max :=pressure.V_flow[nOri] - (pressure.V_flow[nOri] - pressure.V_flow[
      nOri - 1])/((pressure.dp[nOri] - pressure.dp[nOri - 1]))*pressure.dp[nOri];
  end if;
  if haveDPMax then
    dpMax :=pressure.dp[1];
  else
    dpMax :=pressure.dp[1] - ((pressure.dp[2] - pressure.dp[1])/(pressure.V_flow[
      2] - pressure.V_flow[1]))*pressure.V_flow[1];
  end if;

  // Check if minimum decrease condition is satisfied
  haveMinimumDecrease :=true;
  kRes :=dpMax/V_flow_max*delta^2/10;
  for i in 1:nOri-1 loop
    if ((pressure.dp[i+1]-pressure.dp[i])/(pressure.V_flow[i+1]-pressure.V_flow[i]) >= -kRes) then
      haveMinimumDecrease :=false;
    end if;
  end for;
  // Write warning if the volumetric flow rate versus pressure curve does not satisfy
  // the minimum decrease condition
  if (not haveMinimumDecrease) then
    Modelica.Utilities.Streams.print("
Warning:
========
It is recommended that the volume flow rate versus pressure relation
of the fan or pump satisfies the minimum decrease condition

        (pressure.dp[i+1]-pressure.dp[i])
d[i] = ----------------------------------------- < " + String(-kRes) + "
       (pressure.V_flow[i+1]-pressure.V_flow[i])

is " + getArrayAsString({(pressure.dp[i+1]-pressure.dp[i])/(pressure.V_flow[i+1]-pressure.V_flow[i]) for i in 1:nOri-1}, "d") + "
Otherwise, a solution to the equations may not exist if the fan or pump speed is reduced.
In this situation, the solver will fail due to non-convergence and
the simulation stops.");
  end if;

  // Correction for flow resistance of pump or fan
  // Case 1:
  if (haveVMax and haveDPMax) or (nOri == 2) then  // ----- Curve 1
    curve :=1; // V_flow_max and dpMax are provided by the user, or we only have two data points
    for i in 1:nOri loop
      pCur1.dp[i]  :=pressure.dp[i] + pressure.V_flow[i] * kRes;
      pCur1.V_flow[i] := pressure.V_flow[i];
    end for;
    pCur2.V_flow := zeros(nOri + 1);
    pCur2.dp     := zeros(nOri + 1);
    pCur3.V_flow := zeros(nOri + 2);
    pCur3.dp     := zeros(nOri + 2);
    preDer1:=Buildings.Utilities.Math.Functions.splineDerivatives(x=pCur1.V_flow, y=pCur1.dp);
    preDer2:=zeros(nOri+1);
    preDer3:=zeros(nOri+2);

    // Equation to compute dpDelta
    dpDelta :=cha.pressure(
      data=pCur1,
      V_flow=0,
      r_N=delta,
      VDelta_flow=0,
      dpDelta=0,
      V_flow_max=Modelica.Constants.eps,
      dpMax=0,
      delta=0,
      d=preDer1,
      cBar=zeros(2),
      kRes=  kRes);

    // Equation to compute VDelta_flow. By the affinity laws, the volume flow rate is proportional to the speed.
    VDelta_flow :=V_flow_max*delta;

    // Linear equations to determine cBar
    // Conditions for r_N=delta, V_flow = VDelta_flow
    // Conditions for r_N=delta, V_flow = 0
    cBar[1] :=cha.pressure(
      data=pCur1,
      V_flow=0,
      r_N=delta,
      VDelta_flow=0,
      dpDelta=0,
      V_flow_max=Modelica.Constants.eps,
      dpMax=0,
      delta=0,
      d=preDer1,
      cBar=zeros(2),
      kRes=  kRes) * (1-delta)/delta^2;

    cBar[2] :=((cha.pressure(
      data=pCur1,
      V_flow=VDelta_flow,
      r_N=delta,
      VDelta_flow=0,
      dpDelta=0,
      V_flow_max=Modelica.Constants.eps,
      dpMax=0,
      delta=0,
      d=preDer1,
      cBar=zeros(2),
      kRes=  kRes) - delta*dpDelta)/delta^2 - cBar[1])/VDelta_flow;

  elseif haveVMax or haveDPMax then  // ----- Curve 2
    curve :=2; // V_flow_max or dpMax is provided by the user, but not both
    if haveVMax then
      pCur2.V_flow[1] := 0;
      pCur2.dp[1]     := dpMax;
      for i in 1:nOri loop
        pCur2.dp[i+1]  :=pressure.dp[i] + pressure.V_flow[i] * kRes;
        pCur2.V_flow[i+1] := pressure.dp[i];
      end for;
    else
      for i in 1:nOri loop
        pCur2.dp[i]  :=pressure.dp[i] + pressure.V_flow[i] * kRes;
        pCur2.V_flow[i] := pressure.V_flow[i];
      end for;
      pCur2.V_flow[nOri+1] := V_flow_max;
      pCur2.dp[nOri+1]     := 0;
    end if;
    pCur1.V_flow := zeros(nOri);
    pCur1.dp     := zeros(nOri);
    pCur3.V_flow := zeros(nOri + 2);
    pCur3.dp     := zeros(nOri + 2);
    preDer1:=zeros(nOri);
    preDer2:=Buildings.Utilities.Math.Functions.splineDerivatives(x=pCur2.V_flow, y=pCur2.dp);
    preDer3:=zeros(nOri+2);

    // Equation to compute dpDelta
    dpDelta :=cha.pressure(
      data=pCur2,
      V_flow=0,
      r_N=delta,
      VDelta_flow=0,
      dpDelta=0,
      V_flow_max=Modelica.Constants.eps,
      dpMax=0,
      delta=0,
      d=preDer2,
      cBar=zeros(2),
      kRes=  kRes);

    // Equation to compute VDelta_flow. By the affinity laws, the volume flow rate is proportional to the speed.
    VDelta_flow :=V_flow_max*delta;

    // Linear equations to determine cBar
    // Conditions for r_N=delta, V_flow = VDelta_flow
    // Conditions for r_N=delta, V_flow = 0
    cBar[1] :=cha.pressure(
      data=pCur2,
      V_flow=0,
      r_N=delta,
      VDelta_flow=0,
      dpDelta=0,
      V_flow_max=Modelica.Constants.eps,
      dpMax=0,
      delta=0,
      d=preDer2,
      cBar=zeros(2),
      kRes=  kRes) * (1-delta)/delta^2;

    cBar[2] :=((cha.pressure(
      data=pCur2,
      V_flow=VDelta_flow,
      r_N=delta,
      VDelta_flow=0,
      dpDelta=0,
      V_flow_max=Modelica.Constants.eps,
      dpMax=0,
      delta=0,
      d=preDer2,
      cBar=zeros(2),
      kRes=  kRes) - delta*dpDelta)/delta^2 - cBar[1])/VDelta_flow;

  else  // ----- Curve 3
    curve :=3; // Neither V_flow_max nor dpMax are provided by the user
    pCur3.V_flow[1] := 0;
    pCur3.dp[1]     := dpMax;
    for i in 1:nOri loop
      pCur3.dp[i+1]  :=pressure.dp[i] + pressure.V_flow[i] * kRes;
      pCur3.V_flow[i+1] := pressure.V_flow[i];
    end for;
    pCur3.V_flow[nOri+2] := V_flow_max;
    pCur3.dp[nOri+2]     := 0;
    pCur1.V_flow := zeros(nOri);
    pCur1.dp     := zeros(nOri);
    pCur2.V_flow := zeros(nOri + 1);
    pCur2.dp     := zeros(nOri + 1);
    preDer1:=zeros(nOri);
    preDer2:=zeros(nOri+1);
    preDer3:=Buildings.Utilities.Math.Functions.splineDerivatives(x=pCur3.V_flow, y=pCur3.dp);

    // Equation to compute dpDelta
    dpDelta :=cha.pressure(
      data=pCur3,
      V_flow=0,
      r_N=delta,
      VDelta_flow=0,
      dpDelta=0,
      V_flow_max=Modelica.Constants.eps,
      dpMax=0,
      delta=0,
      d=preDer3,
      cBar=zeros(2),
      kRes=  kRes);

    // Equation to compute VDelta_flow. By the affinity laws, the volume flow rate is proportional to the speed.
    VDelta_flow :=V_flow_max*delta;

    // Linear equations to determine cBar
    // Conditions for r_N=delta, V_flow = VDelta_flow
    // Conditions for r_N=delta, V_flow = 0
    cBar[1] :=cha.pressure(
      data=pCur3,
      V_flow=0,
      r_N=delta,
      VDelta_flow=0,
      dpDelta=0,
      V_flow_max=Modelica.Constants.eps,
      dpMax=0,
      delta=0,
      d=preDer3,
      cBar=zeros(2),
      kRes=  kRes) * (1-delta)/delta^2;

    cBar[2] :=((cha.pressure(
      data=pCur3,
      V_flow=VDelta_flow,
      r_N=delta,
      VDelta_flow=0,
      dpDelta=0,
      V_flow_max=Modelica.Constants.eps,
      dpMax=0,
      delta=0,
      d=preDer3,
      cBar=zeros(2),
      kRes=  kRes) - delta*dpDelta)/delta^2 - cBar[1])/VDelta_flow;

  end if;

equation

  // Hydraulic equations
  r_N = N_actual/N_nominal;
  r_V = VMachine_flow/V_flow_max;
  // For the homotopy method, we approximate dpMachine by an equation
  // that is linear in VMachine_flow, and that goes linearly to 0 as r_N goes to 0.
  // The three branches below are identical, except that we pass either
  // pCur1, pCur2 or pCur3, and preDer1, preDer2 or preDer3
  if (curve == 1) then
    if homotopyInitialization then
       dpMachine = homotopy(actual=cha.pressure(data=pCur1,
                                                    V_flow=VMachine_flow, r_N=r_N,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDer1, cBar=cBar, kRes=kRes),
                          simplified=r_N*
                              (cha.pressure(data=pCur1,
                                                    V_flow=V_flow_nominal, r_N=1,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDer1, cBar=cBar, kRes=kRes)
                               +(VMachine_flow-V_flow_nominal)*
                                (cha.pressure(data=pCur1,
                                                    V_flow=(1+delta)*V_flow_nominal, r_N=1,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDer1, cBar=cBar, kRes=kRes)
                                -cha.pressure(data=pCur1,
                                                    V_flow=(1-delta)*V_flow_nominal, r_N=1,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDer1, cBar=cBar, kRes=kRes))
                                 /(2*delta*V_flow_nominal)));

     else
       dpMachine = cha.pressure(data=pCur1, V_flow=VMachine_flow, r_N=r_N,
                                                VDelta_flow=VDelta_flow, dpDelta=dpDelta, V_flow_max=V_flow_max, dpMax=dpMax,
                                                delta=delta, d=preDer1, cBar=cBar, kRes=kRes);
     end if;
     // end of computation for this branch
   elseif (curve == 2) then
    if homotopyInitialization then
       dpMachine = homotopy(actual=cha.pressure(data=pCur2,
                                                    V_flow=VMachine_flow, r_N=r_N,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDer2, cBar=cBar, kRes=kRes),
                          simplified=r_N*
                              (cha.pressure(data=pCur2,
                                                    V_flow=V_flow_nominal, r_N=1,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDer2, cBar=cBar, kRes=kRes)
                               +(VMachine_flow-V_flow_nominal)*
                                (cha.pressure(data=pCur2,
                                                    V_flow=(1+delta)*V_flow_nominal, r_N=1,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDer2, cBar=cBar, kRes=kRes)
                                -cha.pressure(data=pCur2,
                                                    V_flow=(1-delta)*V_flow_nominal, r_N=1,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDer2, cBar=cBar, kRes=kRes))
                                 /(2*delta*V_flow_nominal)));

     else
       dpMachine = cha.pressure(data=pCur2, V_flow=VMachine_flow, r_N=r_N,
                                                VDelta_flow=VDelta_flow, dpDelta=dpDelta, V_flow_max=V_flow_max, dpMax=dpMax,
                                                delta=delta, d=preDer2, cBar=cBar, kRes=kRes);
     end if;
     // end of computation for this branch
  else
    if homotopyInitialization then
       dpMachine = homotopy(actual=cha.pressure(data=pCur3,
                                                    V_flow=VMachine_flow, r_N=r_N,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDer3, cBar=cBar, kRes=kRes),
                          simplified=r_N*
                              (cha.pressure(data=pCur3,
                                                    V_flow=V_flow_nominal, r_N=1,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDer3, cBar=cBar, kRes=kRes)
                               +(VMachine_flow-V_flow_nominal)*
                                (cha.pressure(data=pCur3,
                                                    V_flow=(1+delta)*V_flow_nominal, r_N=1,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDer3, cBar=cBar, kRes=kRes)
                                -cha.pressure(data=pCur3,
                                                    V_flow=(1-delta)*V_flow_nominal, r_N=1,
                                                    VDelta_flow=VDelta_flow, dpDelta=dpDelta,
                                                    V_flow_max=V_flow_max, dpMax=dpMax,
                                                    delta=delta, d=preDer3, cBar=cBar, kRes=kRes))
                                 /(2*delta*V_flow_nominal)));

     else
       dpMachine = cha.pressure(data=pCur3, V_flow=VMachine_flow, r_N=r_N,
                                                VDelta_flow=VDelta_flow, dpDelta=dpDelta, V_flow_max=V_flow_max, dpMax=dpMax,
                                                delta=delta, d=preDer3, cBar=cBar, kRes=kRes);
     end if;
     // end of computation for this branch
  end if;
  // Power consumption
  if use_powerCharacteristic then
    // For the homotopy, we want P/V_flow to be bounded as V_flow -> 0 to avoid a very high medium
    // temperature near zero flow.
    if homotopyInitialization then
      P = homotopy(actual=cha.power(data=power, V_flow=VMachine_flow, r_N=r_N, d=powDer),
                      simplified=VMachine_flow/V_flow_nominal*
                            cha.power(data=power, V_flow=V_flow_nominal, r_N=1, d=powDer));
    else
      P = (rho/rho_default)*cha.power(data=power, V_flow=VMachine_flow, r_N=r_N, d=powDer);
    end if;
    // To compute the efficiency, we set a lower bound on the electricity consumption.
    // This is needed because WFlo can be close to zero when P is zero, thereby
    // causing a division by zero.
    // Earlier versions of the model computed WFlo = eta * P, but this caused
    // a division by zero.
    eta = WFlo / Buildings.Utilities.Math.Functions.smoothMax(x1=P, x2=1E-5, deltaX=1E-6);
    // In this configuration, we only now the total power consumption.
    // Because nothing is known about etaMot versus etaHyd, we set etaHyd=1. This will
    // cause etaMot=eta, because eta=etaHyd*etaMot.
    // Earlier versions used etaMot=sqrt(eta), but as eta->0, this function has
    // and infinite derivative.
    etaHyd = 1;
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
    // To compute the electrical power, we set a lower bound for eta to avoid
    // a division by zero.
    P = WFlo / Buildings.Utilities.Math.Functions.smoothMax(x1=eta, x2=1E-5, deltaX=1E-6);

  end if;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Line(
          points={{0,50},{100,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(extent={{64,68},{114,54}},
          lineColor={0,0,127},
          textString="N")}),
    Documentation(info="<html>
<p>
This is an interface that implements the functions to compute the head, power draw
and efficiency of fans and pumps. It is used by the model
<a href=\"modelica://Buildings.Fluids.Movers.BaseClasses.PrescribedFlowMachine\">PrescribedFlowMachine</a>.
</p>
<p>
The nominal hydraulic characteristic (volume flow rate versus total pressure) is given by a set of data points.
A cubic hermite spline with linear extrapolation is used to compute the performance at other
operating points.
</p>
<p>The fan or pump energy balance can be specified in two alternative ways: </p>

<ul>
<li>
If <code>use_powerCharacteristic = false</code>, then the data points for
normalized volume flow rate versus efficiency is used to determine the efficiency,
and then the power consumption. The default is a constant efficiency of 0.8.
</li>
<li>
If <code>use_powerCharacteristic = true</code>, then the data points for
normalized volume flow rate versus power consumption
is used to determine the power consumption, and then the efficiency
is computed based on the actual power consumption and the flow work.
</li>
</ul>

<h4>Implementation</h4>
<p>
For numerical reasons, the user-provided data points for volume flow rate
versus pressure rise are modified to add a fan internal flow resistance.
Because this flow resistance is subtracted during the simulation when
computing the fan pressure rise, the model reproduces the exact points
that were provided by the user.
</p>
<p>
Also for numerical reasons, the pressure rise at zero flow rate and
the flow rate at zero pressure rise is added to the user-provided data,
unless the user already provides these data points.
Since Modelica 3.2 does not allow dynamic memory allocation, this
implementation required the use of three different arrays for the
situation where no additional point is added, where one additional
point is added and where two additional points are added.
The parameter <code>curve</code> causes the correct data record
to be used during the simulation.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 27, 2013, by Michael Wetter:<br/>
Reformulated <code>data=if (curve == 1) then pCur1 elseif (curve == 2) then pCur2 else pCur3</code>
by moving the computation into the idividual logical branches because OpenModelica generates an
error when assign the statement to <code>data</code>
as <code>pCur1</code>, <code>pCur2</code> and <code>pCur3</code> have different dimensions.
</li>
<li>
September 17, 2013, by Michael Wetter:<br/>
Added missing <code>each</code> keyword in declaration of parameters
that are an array.
</li>
<li>
March 20, 2013, by Michael Wetter:<br/>
Removed assignment in declaration of <code>pCur?.V_flow</code> as
these parameters have the attribute <code>fixed=false</code> set.
</li>
<li>
October 11, 2012, by Michael Wetter:<br/>
Added implementation of <code>WFlo = eta * P</code> with
guard against division by zero.
Changed implementation of <code>etaMot=sqrt(eta)</code> to
<code>etaHyd = 1</code> to avoid infinite derivative as <code>eta</code>
converges to zero.
</li>
<li>
February 20, 2012, by Michael Wetter:<br/>
Assigned value to nominal attribute of <code>VMachine_flow</code>.
</li>
<li>
February 14, 2012, by Michael Wetter:<br/>
Added filter for start-up and shut-down transient.
</li>
<li>
October 4 2011, by Michael Wetter:<br/>
Revised the implementation of the pressure drop computation as a function
of speed and volume flow rate.
The new implementation avoids a singularity near zero volume flow rate and zero speed.
</li>
<li>
March 28 2011, by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
March 23 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowMachineInterface;
