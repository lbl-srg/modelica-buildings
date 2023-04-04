within Buildings.Fluid.Movers.BaseClasses;
model FlowMachineInterface
  "Partial model with performance curves for fans or pumps"
  extends Modelica.Blocks.Icons.Block;

  import cha = Buildings.Fluid.Movers.BaseClasses.Characteristics;

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Buildings.Fluid.Movers.Data.Generic per
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{60,-80},{80,-60}})));

  parameter Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable preVar=
    Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed "Type of prescribed variable";
  parameter Boolean computePowerUsingSimilarityLaws
    "= true, compute power exactly, using similarity laws. Otherwise approximate.";

  final parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal=per.pressure.V_flow[
      nOri] "Nominal volume flow rate, used for homotopy";

  parameter Modelica.Units.SI.Density rho_default
    "Fluid density at medium default state";

  final parameter Boolean haveVMax = (abs(per.pressure.dp[nOri]) < Modelica.Constants.eps)
    "Flag, true if user specified data that contain V_flow_max";

  final parameter Modelica.Units.SI.VolumeFlowRate V_flow_max=
    if per.V_flow_max>Modelica.Constants.eps
      then per.V_flow_max
    else
      V_flow_nominal
    "Maximum volume flow rate, used for smoothing";

  parameter Integer nOri(min=1) "Number of data points for pressure curve"
    annotation(Evaluate=true);

 // Normalized speed
  Modelica.Blocks.Interfaces.RealInput y_in(final unit="1") if preSpe
    "Prescribed mover speed"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,120})));

  Modelica.Blocks.Interfaces.RealOutput y_out(
    final unit="1") "Mover speed (prescribed or computed)"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));

  Modelica.Blocks.Interfaces.RealInput m_flow(
    final quantity="MassFlowRate",
    final unit="kg/s") "Mass flow rate"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput rho(
    final quantity="Density",
    final unit="kg/m3",
    min=0.0) "Medium density"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealOutput V_flow(
    quantity="VolumeFlowRate",
    final unit="m3/s") "Volume flow rate"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
        iconTransformation(extent={{100,50},{120,70}})));

  Modelica.Blocks.Interfaces.RealInput dp_in(
    quantity="PressureDifference",
    final unit="Pa") if prePre "Prescribed pressure increase"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,120})));

  Modelica.Blocks.Interfaces.RealOutput dp(
    quantity="Pressure",
    final unit="Pa") if not prePre "Pressure increase (computed or prescribed)"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.Blocks.Interfaces.RealOutput WFlo(
    quantity="Power",
    final unit="W") "Flow work"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));

  Modelica.Blocks.Interfaces.RealOutput WHyd(
    quantity="Power",
    final unit="W") "Hydraulic work (shaft work, brake horsepower)"
    annotation (Placement(
        transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={
            {100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput PEle(
    quantity="Power",
    final unit="W") "Electrical power consumed"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-30},{120,-10}})));

  Modelica.Blocks.Interfaces.RealOutput eta(
    final quantity="Efficiency",
    final unit="1",
    start = 0.49) "Overall efficiency"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
  // A start value is given to suppress the following translation warning:
  //   "Some variables are iteration variables of the initialization problem:
  //   but they are not given any explicit start values. Zero will be used."

  Modelica.Blocks.Interfaces.RealOutput etaHyd(
    final quantity="Efficiency",
    final unit="1") "Hydraulic efficiency"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
        iconTransformation(extent={{100,-90},{120,-70}})));

  Modelica.Blocks.Interfaces.RealOutput etaMot(
    final quantity="Efficiency",
    final unit="1") "Motor efficiency"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}}),
        iconTransformation(extent={{100,-110},{120,-90}})));

  // "Shaft rotational speed";
  Modelica.Blocks.Interfaces.RealOutput r_N(unit="1")
    "Ratio N_actual/N_nominal";
  Real r_V(start=1, unit="1") "Ratio V_flow/V_flow_max";

protected
  final parameter Boolean preSpe=
    preVar == Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed
    "True if speed is a prescribed variable of this block";
  final parameter Boolean prePre=
    preVar == Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.PressureDifference or
    preVar == Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.FlowRate
    "True if pressure head is a prescribed variable of this block";

  // Derivatives for cubic spline
  final parameter Real etaDer[size(per.efficiency.V_flow,1)]=
    if not per.etaHydMet==Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Efficiency_VolumeFlowRate
      then zeros(size(per.efficiency.V_flow,1))
    elseif (size(per.efficiency.V_flow, 1) == 1)
      then {0}
    else
      Buildings.Utilities.Math.Functions.splineDerivatives(
        x=per.efficiency.V_flow,
        y=per.efficiency.eta,
        ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
          x=per.efficiency.eta,
          strict=false))
    "Coefficients for cubic spline of total or hydraulic efficiency vs. volume flow rate";
  final parameter Real motDer[size(per.motorEfficiency.V_flow, 1)]=
    if not per.etaMotMet==Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_VolumeFlowRate
      then zeros(size(per.motorEfficiency.V_flow,1))
    elseif (size(per.motorEfficiency.V_flow, 1) == 1)
      then {0}
    else
      Buildings.Utilities.Math.Functions.splineDerivatives(
        x=per.motorEfficiency.V_flow,
        y=per.motorEfficiency.eta,
        ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
          x=per.motorEfficiency.eta,
          strict=false))
    "Coefficients for cubic spline of motor efficiency vs. volume flow rate";
  final parameter Real motDer_yMot[size(per.motorEfficiency_yMot.y,1)]=
    if not per.etaMotMet==
      Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_MotorPartLoadRatio
      then zeros(size(per.motorEfficiency_yMot.y,1))
    elseif (size(per.motorEfficiency_yMot.y,1) == 1)
      then {0}
    else
      Buildings.Utilities.Math.Functions.splineDerivatives(
        x=per.motorEfficiency_yMot.y,
        y=per.motorEfficiency_yMot.eta,
        ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
          x=per.motorEfficiency_yMot.eta,
          strict=false))
    "Coefficients for cubic spline of motor efficiency vs. motor PLR";
  final parameter Real motDer_yMot_generic[9]=
    if per.etaMotMet==
      Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve
      or  (per.etaMotMet==
      Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided
           and per.haveWMot_nominal)
      then Buildings.Utilities.Math.Functions.splineDerivatives(
             x=per.motorEfficiency_yMot_generic.y,
             y=per.motorEfficiency_yMot_generic.eta,
             ensureMonotonicity=true)
    else zeros(9)
    "Coefficients for cubic spline of motor efficiency vs. motor PLR with generic curves";

  parameter Modelica.Units.SI.PressureDifference dpMax(displayUnit="Pa")=
    per.dpMax "Maximum head";

  parameter Real delta = 0.05
    "Small value used to for regularization and to approximate an internal flow resistance of the fan";

  parameter Real kRes(min=0, unit="kg/(s.m4)") =  dpMax/V_flow_max*delta^2/10
    "Coefficient for internal pressure drop of the fan or pump";

  parameter Integer curve=
     if (haveVMax and haveDPMax) or (nOri == 2) then 1
     elseif haveVMax or haveDPMax then 2
     else 3
    "Flag, used to pick the right representation of the fan or pump's pressure curve";

  final parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParametersInternal pCur1(
    final n = nOri,
    final V_flow = if (haveVMax and haveDPMax) or (nOri == 2) then
             {per.pressure.V_flow[i] for i in 1:nOri}
             else
             zeros(nOri),
    final dp = if (haveVMax and haveDPMax) or (nOri == 2) then
             {(per.pressure.dp[i] + per.pressure.V_flow[i] * kRes) for i in 1:nOri}
             else
             zeros(nOri))
    "Volume flow rate vs. total pressure rise with correction for fan or pump's resistance added";

  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParametersInternal pCur2(
    final n = nOri + 1,
    V_flow = if (haveVMax and haveDPMax) or (nOri == 2) then
                zeros(nOri + 1)
             elseif haveVMax then
              cat(1, {0}, {per.pressure.V_flow[i] for i in 1:nOri})
             elseif haveDPMax then
              cat(1, { per.pressure.V_flow[i] for i in 1:nOri}, {V_flow_max})
             else
              zeros(nOri + 1),
    dp = if (haveVMax and haveDPMax) or (nOri == 2) then
                zeros(nOri + 1)
             elseif haveVMax then
              cat(1, {dpMax}, {per.pressure.dp[i] + per.pressure.V_flow[i] * kRes for i in 1:nOri})
             elseif haveDPMax then
              cat(1, {per.pressure.dp[i] + per.pressure.V_flow[i] * kRes for i in 1:nOri}, {0})
             else
               zeros(nOri+1))
    "Volume flow rate vs. total pressure rise with correction for fan or pump's resistance added";
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParametersInternal pCur3(
    final n = nOri + 2,
    V_flow = if (haveVMax and haveDPMax) or (nOri == 2) then
               zeros(nOri + 2)
             elseif haveVMax or haveDPMax then
               zeros(nOri + 2)
             else
               cat(1, {0}, {per.pressure.V_flow[i] for i in 1:nOri}, {V_flow_max}),
    dp =     if (haveVMax and haveDPMax) or (nOri == 2) then
               zeros(nOri + 2)
             elseif haveVMax or haveDPMax then
               zeros(nOri + 2)
             else
               cat(1, {dpMax}, {per.pressure.dp[i] + per.pressure.V_flow[i] * kRes for i in 1:nOri}, {0}))
    "Volume flow rate vs. total pressure rise with correction for fan or pump's resistance added";

  parameter Real preDer1[nOri](each fixed=false)
    "Derivatives of flow rate vs. pressure at the support points";
  parameter Real preDer2[nOri+1](each fixed=false)
    "Derivatives of flow rate vs. pressure at the support points";
  parameter Real preDer3[nOri+2](each fixed=false)
    "Derivatives of flow rate vs. pressure at the support points";
  parameter Real powDer[size(per.power.V_flow,1)]=
   if per.etaHydMet==
      Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate then
     Buildings.Utilities.Math.Functions.splineDerivatives(
                   x=per.power.V_flow,
                   y=per.power.P,
                   ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(x=per.power.P,
                                                                                     strict=false))
   else
     zeros(size(per.power.V_flow,1))
    "Coefficients for polynomial of power vs. flow rate";

  final parameter Buildings.Fluid.Movers.BaseClasses.Euler.powerWithDerivative powEu_internal=
    if (curve == 1) then
      Buildings.Fluid.Movers.BaseClasses.Euler.power(peak=per.peak,pressure=pCur1)
    elseif (curve == 2) then
      Buildings.Fluid.Movers.BaseClasses.Euler.power(peak=per.peak,pressure=pCur2)
    else
      Buildings.Fluid.Movers.BaseClasses.Euler.power(peak=per.peak,pressure=pCur3)
    "Intermediate parameter";
  final parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters powEu(
    V_flow = powEu_internal.V_flow,
    P = powEu_internal.P)
    "Power vs. volumetric flow rate computed from Euler number";
  final parameter Real powEuDer[:] = powEu_internal.d
    "Power derivative with respect to volumetric flow rate computed from Euler number";

  parameter Boolean haveMinimumDecrease=
    if nOri<2 then false
    else
      Modelica.Math.BooleanVectors.allTrue({(per.pressure.dp[i + 1] -
      per.pressure.dp[i])/(per.pressure.V_flow[i + 1] - per.pressure.V_flow[
      i]) < -kRes for i in 1:nOri - 1}) "Flag used for reporting";

  parameter Boolean haveDPMax = (abs(per.pressure.V_flow[1])  < Modelica.Constants.eps)
    "Flag, true if user specified data that contain dpMax";

  Modelica.Blocks.Interfaces.RealOutput dp_internal
    "If dp is prescribed, use dp_in and solve for r_N, otherwise compute dp using r_N";

  Modelica.Units.SI.Efficiency eta_internal
    "Either eta or etaHyd";

  Modelica.Units.SI.Power P_internal
    "Either PEle or WHyd";

  parameter Real deltaP = 1E-4 * V_flow_max * dpMax
    "Small value for regularisation of power";

  Real yMot(final min=0, final start=0.833)=
    if per.haveWMot_nominal
      then WHyd/per.WMot_nominal
    else 1
    "Motor part load ratio";

function getPerformanceDataAsString
  input Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters pressure
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

initial equation
  // Check validity of data
  assert(nOri > 1, "Must have at least two data points for pressure.V_flow.");
  assert(Buildings.Utilities.Math.Functions.isMonotonic(x=per.pressure.V_flow, strict=true) and
  per.pressure.V_flow[1] > -Modelica.Constants.eps,
  "The fan pressure rise must be a strictly decreasing sequence with respect to the volume flow rate,
  with the first element for the fan pressure raise being non-zero.
The following performance data have been entered:
" + getArrayAsString(per.pressure.V_flow, "pressure.V_flow"));

  if not haveVMax then
    assert(nOri>=2,
      "When the maximum flow is not specified,
      at least two points are needed for the power curve.");
    if nOri>=2 then
      assert((per.pressure.V_flow[nOri]-per.pressure.V_flow[nOri-1])
           /((per.pressure.dp[nOri]-per.pressure.dp[nOri-1]))<0,
    "The last two pressure points for the fan or pump's performance curve must be decreasing.
Received
" + getArrayAsString(per.pressure.dp, "dp"));
    end if;
  end if;

  // Write warning if the volumetric flow rate versus pressure curve does not satisfy
  // the minimum decrease condition
  if (not haveMinimumDecrease) then
    Modelica.Utilities.Streams.print("
Warning:
========
It is recommended that the volume flow rate versus pressure relation
of the fan or pump satisfy the minimum decrease condition

        (per.pressure.dp[i+1]-per.pressure.dp[i])
d[i] = ------------------------------------------------- < " + String(-kRes) + "
       (per.pressure.V_flow[i+1]-per.pressure.V_flow[i])

 is
" + getArrayAsString({(per.pressure.dp[i+1]-per.pressure.dp[i])
        /(per.pressure.V_flow[i+1]-per.pressure.V_flow[i]) for i in 1:nOri-1}, "d") + "
Otherwise, a solution to the equations may not exist if the fan or pump's speed is reduced.
In this situation, the solver will fail due to non-convergence and
the simulation stops.");
  end if;

  // Correction for flow resistance of the fan or pump
  if curve == 1 then  // ----- Curve 1
    // V_flow_max and dpMax are provided by the user, or we only have two data points
    preDer1= Buildings.Utilities.Math.Functions.splineDerivatives(x=pCur1.V_flow,
      y=pCur1.dp);
    preDer2= zeros(nOri + 1);
    preDer3= zeros(nOri + 2);
  elseif curve == 2 then  // ----- Curve 2
    // V_flow_max or dpMax is provided by the user, but not both
    preDer1= zeros(nOri);
    preDer2= Buildings.Utilities.Math.Functions.splineDerivatives(x=pCur2.V_flow,
      y=pCur2.dp);
    preDer3= zeros(nOri + 2);
  else  // ----- Curve 3
    // Neither V_flow_max nor dpMax are provided by the user
    preDer1= zeros(nOri);
    preDer2= zeros(nOri + 1);
    preDer3= Buildings.Utilities.Math.Functions.splineDerivatives(x=pCur3.V_flow,
      y=pCur3.dp);
  end if;

  assert(not ((per.etaMotMet==
           Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_MotorPartLoadRatio
           or  per.etaMotMet==
           Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve)
         and not per.haveWMot_nominal),
         "In " + getInstanceName() + ": etaMotMet is set to
         .Efficiency_MotorPartLoadRatio or .GenericCurve which requires
         the motor's rated power, but per.WMot_nominal is not assigned or
         cannot be estimated because no power curve is provided.");

  assert(max(per.power.P)<1E-6 or per.WMot_nominal>max(per.power.P)*0.99,
         "In " + getInstanceName() + ": The rated motor power provided in
         per.WMot_nominal is smaller than the maximum power provided in per.power.
         Use a larger value for per.WMot_nominal or leave it blank to allow the
         model to assume a default value.");

  assert(homotopyInitialization, "In " + getInstanceName() +
         ": The constant homotopyInitialization has been modified from its default
         value. This constant will be removed in future releases.",
         level = AssertionLevel.warning);

equation
  // Assign values of dp and r_N, depending on which variable exists and is prescribed
  connect(dp_internal,dp);
  connect(dp_internal,dp_in);
  connect(r_N, y_in);
  y_out=r_N;

  // Flow rate conversion
  V_flow = m_flow / rho;

  // Hydraulic equations
  r_V = V_flow/V_flow_max;

  // If the speed is not prescribed and we do not require exact power computations, we set r_N = 1.
  // Similarity laws are then not used, meaning the power computation is less accurate.
  // This however has the advantage that no non-linear algebraic loop is formed and
  // it allows an implementation when the pressure curve is unknown.
  if (computePowerUsingSimilarityLaws == false) and preVar <> Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed then
    r_N=1;
  else
  // For the homotopy method, we approximate dp by an equation
  // that is linear in V_flow, and that goes linearly to 0 as r_N goes to 0.
  // The three branches below are identical, except that we pass either
  // pCur1, pCur2 or pCur3, and preDer1, preDer2 or preDer3
  if (curve == 1) then
    if homotopyInitialization then
       V_flow*kRes + dp_internal = homotopy(actual=cha.pressure(
                                                     V_flow=V_flow,
                                                     r_N=r_N,
                                                     dpMax=dpMax,
                                                     V_flow_max=V_flow_max,
                                                     d=preDer1,
                                                     per=pCur1),
                                           simplified=r_N * (cha.pressure(
                                                     V_flow=V_flow_nominal,
                                                     r_N=1,
                                                     dpMax=dpMax,
                                                     V_flow_max=V_flow_max,
                                                     d=preDer1,
                                                     per=pCur1)
                               +(V_flow-V_flow_nominal) * (cha.pressure(
                                                     V_flow=(1+delta)*V_flow_nominal,
                                                     r_N=1,
                                                     dpMax=dpMax,
                                                     V_flow_max=V_flow_max,
                                                     d=preDer1,
                                                     per=pCur1)
                                       -cha.pressure(V_flow=(1-delta)*V_flow_nominal,
                                                     r_N=1,
                                                     dpMax=dpMax,
                                                     V_flow_max=V_flow_max,
                                                     d=preDer1,
                                                     per=pCur1))
                                                    /(2*delta*V_flow_nominal)));

    else
       V_flow*kRes + dp_internal= cha.pressure(V_flow=V_flow,
                                               r_N=r_N,
                                               dpMax=dpMax,
                                                     V_flow_max=V_flow_max,
                                               d=preDer1,
                                               per=pCur1);
    end if;     // end of computation for this branch
   elseif (curve == 2) then
    if homotopyInitialization then
       V_flow*kRes + dp_internal = homotopy(actual=cha.pressure(
                                                     V_flow=V_flow,
                                                     r_N=r_N,
                                                     dpMax=dpMax,
                                                     V_flow_max=V_flow_max,
                                                     d=preDer2,
                                                     per=pCur2),
                                            simplified=r_N * (cha.pressure(
                                                     V_flow=V_flow_nominal,
                                                     r_N=1,
                                                     dpMax=dpMax,
                                                     V_flow_max=V_flow_max,
                                                     d=preDer2,
                                                     per=pCur2)
                               +(V_flow-V_flow_nominal) * (cha.pressure(
                                                     V_flow=(1+delta)*V_flow_nominal,
                                                     r_N=1,
                                                     dpMax=dpMax,
                                                     V_flow_max=V_flow_max,
                                                     d=preDer2,
                                                     per=pCur2)
                                       -cha.pressure(V_flow=(1-delta)*V_flow_nominal,
                                                     r_N=1,
                                                     dpMax=dpMax,
                                                     V_flow_max=V_flow_max,
                                                     d=preDer2,
                                                     per=pCur2))
                                                    /(2*delta*V_flow_nominal)));

    else
       V_flow*kRes + dp_internal= cha.pressure(V_flow=V_flow,
                                                      r_N=r_N,
                                                      dpMax=dpMax,
                                                      V_flow_max=V_flow_max,
                                                      d=preDer2,
                                                      per=pCur2);
    end if;     // end of computation for this branch
  else
    if homotopyInitialization then
       V_flow*kRes + dp_internal = homotopy(actual=cha.pressure(
                                                     V_flow=V_flow,
                                                     r_N=r_N,
                                                     dpMax=dpMax,
                                                     V_flow_max=V_flow_max,
                                                     d=preDer3,
                                                     per=pCur3),
                          simplified=r_N * (cha.pressure(
                                                     V_flow=V_flow_nominal,
                                                     r_N=1,
                                                     dpMax=dpMax,
                                                     V_flow_max=V_flow_max,
                                                     d=preDer3,
                                                     per=pCur3)
                               +(V_flow-V_flow_nominal)*
                                       (cha.pressure(V_flow=(1+delta)*V_flow_nominal,
                                                     r_N=1,
                                                     dpMax=dpMax,
                                                     V_flow_max=V_flow_max,
                                                     d=preDer3,
                                                     per=pCur3)
                                       -cha.pressure(V_flow=(1-delta)*V_flow_nominal,
                                                     r_N=1,
                                                     dpMax=dpMax,
                                                     V_flow_max=V_flow_max,
                                                     d=preDer3,
                                                     per=pCur3))
                                                    /(2*delta*V_flow_nominal)));

    else
       V_flow*kRes + dp_internal= cha.pressure(V_flow=V_flow,
                                                      r_N=r_N,
                                                      dpMax=dpMax,
                                                      V_flow_max=V_flow_max,
                                                      d=preDer3,
                                                      per=pCur3);
    end if;
    // end of computation for this branch
  end if;
    // end of if/else choosing between exact/simplified power computation
  end if;

  // Power and efficiency
  WFlo = Buildings.Utilities.Math.Functions.smoothMax(
           x1=dp_internal*V_flow,
           x2=0,
           deltaX=deltaP/2);
  if per.powerOrEfficiencyIsHydraulic then
    eta = etaHyd * etaMot;
  else
    etaHyd = Buildings.Utilities.Math.Functions.smoothMin(
               x1=eta/etaMot, x2=1, deltaX=1E-3);
  end if;

  // Hydraulic efficiency etaHyd and hydraulic work WHyd
  //   or total efficiency eta and total electric power PEle
  //   depending on the information provided
  if per.powerOrEfficiencyIsHydraulic then
    P_internal=WHyd;
    eta_internal=etaHyd;
    PEle = WFlo / Buildings.Utilities.Math.Functions.smoothMax(
                    x1=eta, x2=1E-2, deltaX=1E-3);
  else
    P_internal=PEle;
    eta_internal=eta;
    WHyd = WFlo / Buildings.Utilities.Math.Functions.smoothMax(
                    x1=etaMot, x2=1E-2, deltaX=1E-3);
  end if;
  if per.etaHydMet==
       Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate then
    if homotopyInitialization then
      P_internal = homotopy(actual=cha.power(per=per.power, V_flow=V_flow, r_N=r_N, d=powDer, delta=delta),
                      simplified=V_flow/V_flow_nominal*
                            cha.power(per=per.power, V_flow=V_flow_nominal, r_N=1, d=powDer, delta=delta));
    else
      P_internal = (rho/rho_default)*cha.power(per=per.power, V_flow=V_flow, r_N=r_N, d=powDer, delta=delta);
    end if;
    eta_internal = WFlo/Buildings.Utilities.Math.Functions.smoothMax(
                     x1=P_internal, x2=deltaP, deltaX=deltaP/2);
  elseif per.etaHydMet==
       Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber then
    if homotopyInitialization then
      P_internal = homotopy(actual=cha.power(per=powEu, V_flow=V_flow, r_N=r_N, d=powEuDer, delta=delta),
                      simplified=V_flow/V_flow_nominal*
                            cha.power(per=powEu, V_flow=V_flow_nominal, r_N=1, d=powEuDer, delta=delta));
    else
      P_internal = (rho/rho_default)*cha.power(per=powEu, V_flow=V_flow, r_N=r_N, d=powEuDer, delta=delta);
    end if;
    eta_internal = WFlo / Buildings.Utilities.Math.Functions.smoothMax(
                            x1=P_internal, x2=deltaP, deltaX=deltaP/2);
  elseif per.etaHydMet == Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Efficiency_VolumeFlowRate then
    if homotopyInitialization then
      eta_internal = homotopy(actual=cha.efficiency(per=per.efficiency,     V_flow=V_flow, d=etaDer, r_N=r_N, delta=delta),
                        simplified=cha.efficiency(per=per.efficiency, V_flow=V_flow_max,   d=etaDer, r_N=r_N, delta=delta));
    else
      eta_internal = cha.efficiency(per=per.efficiency, V_flow=V_flow, d=etaDer, r_N=r_N, delta=delta);
    end if;
    if per.powerOrEfficiencyIsHydraulic then
      P_internal=WFlo/Buildings.Utilities.Math.Functions.smoothMax(
                        x1=eta_internal, x2=1E-2, deltaX=1E-3);
    else
      P_internal=WHyd/Buildings.Utilities.Math.Functions.smoothMax(
                        x1=eta_internal, x2=1E-2, deltaX=1E-3);
    end if;
  else // Not provided
    if per.powerOrEfficiencyIsHydraulic then
      eta_internal=0.7;
      P_internal=WFlo/eta_internal;
    else
      eta_internal=0.49;
      P_internal=WHyd/eta_internal;
    end if;
  end if;

  // Motor efficiency etaMot
  if per.etaMotMet == Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_VolumeFlowRate then
    if homotopyInitialization then
      etaMot = homotopy(actual=cha.efficiency(per=per.motorEfficiency,     V_flow=V_flow, d=motDer, r_N=r_N, delta=delta),
                        simplified=cha.efficiency(per=per.motorEfficiency, V_flow=V_flow_max,   d=motDer, r_N=r_N, delta=delta));
    else
      etaMot = cha.efficiency(per=per.motorEfficiency,     V_flow=V_flow, d=motDer, r_N=r_N, delta=delta);
    end if;
  elseif per.etaMotMet==
       Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_MotorPartLoadRatio then
    if homotopyInitialization then
      etaMot =homotopy(actual=cha.efficiency_yMot(
        per=per.motorEfficiency_yMot,
        y=yMot,
        d=motDer_yMot), simplified=cha.efficiency_yMot(
        per=per.motorEfficiency_yMot,
        y=1,
        d=motDer_yMot));
    else
      etaMot =cha.efficiency_yMot(
        per=per.motorEfficiency_yMot,
        y=yMot,
        d=motDer_yMot);
    end if;
  elseif per.etaMotMet==
       Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve then
      if homotopyInitialization then
        etaMot =homotopy(actual=cha.efficiency_yMot(
          per=per.motorEfficiency_yMot_generic,
          y=yMot,
          d=motDer_yMot_generic), simplified=cha.efficiency_yMot(
          per=per.motorEfficiency_yMot_generic,
          y=1,
          d=motDer_yMot_generic));
      else
        etaMot =cha.efficiency_yMot(
          per=per.motorEfficiency_yMot_generic,
          y=yMot,
          d=motDer_yMot_generic);
      end if;
  else // Not provided
    etaMot = 0.7;
  end if;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                    graphics={
        Text(extent={{56,84},{106,70}},
          textColor={0,0,127},
          textString="dp"),
        Text(extent={{56,-10},{106,-24}},
          textColor={0,0,127},
          textString="PEle"),
        Text(extent={{48,-48},{98,-62}},
          textColor={0,0,127},
          textString="eta"),
        Text(extent={{50,-68},{100,-82}},
          textColor={0,0,127},
          textString="etaHyd"),
        Text(extent={{50,-86},{100,-100}},
          textColor={0,0,127},
          textString="etaMot"),
        Ellipse(
          extent={{-78,34},{44,-88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-62,18},{28,-72}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-26,-18},{-8,-36}},
          lineColor={0,0,0},
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-26,-22},{-32,-8},{-30,10},{-8,20},{-6,14},{-24,6},{-24,-8},{
              -18,-20},{-26,-22}},
          lineColor={0,0,0},
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-8,-32},{-2,-46},{-4,-64},{-26,-74},{-28,-68},{-10,-60},{-10,
              -46},{-16,-34},{-8,-32}},
          lineColor={0,0,0},
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{7,21},{13,7},{11,-11},{-11,-21},{-13,-15},{5,-7},{5,7},{-1,19},
              {7,21}},
          lineColor={0,0,0},
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier,
          origin={9,-23},
          rotation=90),
        Polygon(
          points={{-7,-21},{-13,-7},{-11,11},{11,21},{13,15},{-5,7},{-5,-7},{1,-19},
              {-7,-21}},
          lineColor={0,0,0},
          fillColor={100,100,100},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier,
          origin={-43,-31},
          rotation=90),
        Text(extent={{56,28},{106,14}},
          textColor={0,0,127},
          textString="WFlo"),
        Text(extent={{56,66},{106,52}},
          textColor={0,0,127},
          textString="V_flow"),
        Line(
          points={{-74,92},{-74,40}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-74,40},{46,40}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-70,86},{-40,84},{8,68},{36,42}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Text(extent={{56,102},{106,88}},
          textColor={0,0,127},
          textString="y_out"),
        Text(extent={{56,8},{106,-6}},
          textColor={0,0,127},
          textString="WHyd")}),
    Documentation(info="<html>
<p>
This is an interface that implements the functions to compute the head, power draw
and efficiency of fans and pumps.
</p>
<p>
The nominal hydraulic characteristic (total pressure rise versus volume flow rate)
is given by a set of data points
using the data record <code>per</code>, which is an instance of
<a href=\"modelica://Buildings.Fluid.Movers.Data.Generic\">
Buildings.Fluid.Movers.Data.Generic</a>.
A cubic hermite spline with linear extrapolation is used to compute
the performance at other operating points.
</p>
<p>
The model computes the power and efficiency items in the list below.
</p>
<ul>
<li>
Flow work:<br/>
<i>W&#775;<sub>flo</sub> = V&#775; &sdot; &Delta;p</i>
</li>
<li>
Total efficiency and consumed electric power:<br/>
<i>&eta; = W&#775;<sub>flo</sub> &frasl; P<sub>ele</sub></i>
</li>
<li>
Hydraulic effiency and hydraulic work (shaft work, brake horsepower):<br/>
<i>&eta;<sub>hyd</sub> = W&#775;<sub>flo</sub> &frasl; W&#775;<sub>hyd</sub></i>
</li>
<li>
Motor efficiency:<br/>
<i>&eta;<sub>mot</sub> = W&#775;<sub>hyd</sub> &frasl; P<sub>ele</sub></i>
</li>
</ul>
<p>
See
<a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
Buildings.Fluid.Movers.UsersGuide</a>
for how the user can provide power and efficiency information to the model.
</p>
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
<p>
In order to prevent the model from producing negative mover power
when either the flow rate or pressure rise is forced to be negative,
the flow work <i>W&#775;<sub>flo</sub></i> is constrained to be non-negative.
The regularisation starts around 0.01% of the characteristic maximum power
<i>W&#775;<sub>max</sub> = V&#775;<sub>max</sub> &Delta;p<sub>max</sub></i>.
See discussions and an example of this situation in
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1621\">IBPSA, #1621</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 8, 2022, by Hongxiang Fu:<br/>
<ul>
<li>
Modified the power and efficiency computation to allow computing
the hydraulic efficiency <code>etaHyd</code> and
the motor efficiency <code>etaMot</code> separately;
</li>
<li>
Implemented the option to compute the total efficiency <code>eta</code>
or the hydraulic efficiency <code>etaHyd</code> using the Euler number.
</li>
<li>
Implemented the option for the user to provide the motor efficiency
<code>etaMot</code> as a function of part load ratio <i>y</i>. Also allowed generic
curves to be used.
</li>
<li>
Moved <code>haveVMax</code> here from
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine\">
Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine</a>.
</li>
<li>
Now it passes <code>WHyd</code> instead of <code>etaHyd</code> to
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.PowerInterface\">
Buildings.Fluid.Movers.BaseClasses.PowerInterface</a>.
</li>
<li>
Now the flow work <code>WFlo</code> is bounded to be non-negative.
</li>
</ul>
These are for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
June 6, 2022, by Hongxiang Fu:<br/>
Added a constraint that <i>W<sub>flo</sub> = V&#775; &Delta;p &ge; 0</i>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1621\">IBPSA, #1621</a>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
December 2, 2016, by Michael Wetter:<br/>
Removed <code>min</code> attribute as otherwise numerical noise can cause
the assertion on the limit to fail.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/606\">#606</a>.
</li>
<li>
February 19, 2016, by Michael Wetter and Filip Jorissen:<br/>
Refactored model to make implementation clearer.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/417\">#417</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference and reformatted code.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 2, 2015, by Michael Wetter:<br/>
Corrected computation of
<code>etaMot = cha.efficiency(per=per.motorEfficiency, V_flow=V_flow, d=motDer, r_N=r_N, delta=1E-4)</code>
which previously used <code>V_flow_max</code> instead of <code>V_flow</code>.
</li>
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised model for OpenModelica.
</li>
<li>
November 22, 2014, by Michael Wetter:<br/>
Removed in <code>N_actual</code> and <code>N_filtered</code>
the <code>max</code> attribute to
avoid a translation warning.
</li>
<li>
April 21, 2014, by Filip Jorissen and Michael Wetter:<br/>
Changed model to use
<a href=\"modelica://Buildings.Fluid.Movers.Data.Generic\">
Buildings.Fluid.Movers.Data.Generic</a>.
April 19, 2014, by Filip Jorissen:<br/>
Passed extra parameters to power() and efficiency()
to be able to properly evaluate the
scaling law. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/202\">#202</a>
for a discussion and validation.
</li>
<li>
September 27, 2013, by Michael Wetter:<br/>
Reformulated <code>per=if (curve == 1) then pCur1 elseif (curve == 2) then pCur2 else pCur3</code>
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
Assigned value to nominal attribute of <code>V_flow</code>.
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
