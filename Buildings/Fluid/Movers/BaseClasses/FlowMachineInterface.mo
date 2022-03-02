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
    if per.havePressureCurve then
    (if haveVMax then
      per.pressure.V_flow[nOri]
     else
      per.pressure.V_flow[nOri] - (per.pressure.V_flow[nOri] - per.pressure.V_flow[
      nOri - 1])/((per.pressure.dp[nOri] - per.pressure.dp[nOri - 1]))*per.pressure.dp[nOri])
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
  final parameter Real etaDer[size(per.totalEfficiency.V_flow,1)](
    each fixed=false)
    "Coefficients for cubic spline of total efficiency vs. volume flow rate";
  final parameter Real hydDer[size(per.hydraulicEfficiency.V_flow,1)](
    each fixed=false)
    "Coefficients for cubic spline of hydraulic efficiency vs. volume flow rate";
  final parameter Real motDer[size(per.motorEfficiency.V_flow, 1)](
    each fixed=false)
    "Coefficients for cubic spline of motor efficiency vs. volume flow rate";

  parameter Modelica.Units.SI.PressureDifference dpMax(displayUnit="Pa") = if
    haveDPMax then per.pressure.dp[1] else per.pressure.dp[1] - ((per.pressure.dp[
    2] - per.pressure.dp[1])/(per.pressure.V_flow[2] - per.pressure.V_flow[1]))
    *per.pressure.V_flow[1] "Maximum head";

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
   if per.use_powerCharacteristic then
     Buildings.Utilities.Math.Functions.splineDerivatives(
                   x=per.power.V_flow,
                   y=per.power.P,
                   ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(x=per.power.P,
                                                                                     strict=false))
   else
     zeros(size(per.power.V_flow,1))
    "Coefficients for polynomial of power vs. flow rate";

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

  Buildings.Controls.OBC.CDL.Continuous.Divide divByRho "Divide by density";

  parameter Buildings.Fluid.Movers.BaseClasses.Euler.lookupTables curEu=
    Buildings.Fluid.Movers.BaseClasses.Euler.computeTables(
      peak=per.peak,
      dpMax=dpMax,
      V_flow_max=V_flow_max,
      use=per.use_eulerNumber)
      "Efficiency and power curves vs. flow rate & pressure rise calculated with Euler number";

  Modelica.Blocks.Tables.CombiTable2Ds effTab(
    final table=curEu.eta,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    if per.use_eulerNumber
    "Look-up table for mover efficiency";
  Modelica.Blocks.Tables.CombiTable2Ds powTab(
    final table=curEu.P,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    if per.use_eulerNumber
    "Look-up table for mover power";

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
  if (haveVMax and haveDPMax) or (nOri == 2) then  // ----- Curve 1
    // V_flow_max and dpMax are provided by the user, or we only have two data points
    preDer1= Buildings.Utilities.Math.Functions.splineDerivatives(x=pCur1.V_flow,
      y=pCur1.dp);
    preDer2= zeros(nOri + 1);
    preDer3= zeros(nOri + 2);
  elseif haveVMax or haveDPMax then  // ----- Curve 2
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

  // Compute derivatives for cubic spline
  etaDer = if not per.effMetInt[1]==2 then zeros(size(per.totalEfficiency.V_flow,
    1)) elseif (size(per.totalEfficiency.V_flow, 1) == 1) then {0} else
    Buildings.Utilities.Math.Functions.splineDerivatives(
    x=per.totalEfficiency.V_flow,
    y=per.totalEfficiency.eta,
    ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
      x=per.totalEfficiency.eta,
      strict=false));
  hydDer = if not per.effMetInt[2]==2 then zeros(size(per.hydraulicEfficiency.V_flow,
    1)) elseif (size(per.hydraulicEfficiency.V_flow, 1) == 1) then {0} else
    Buildings.Utilities.Math.Functions.splineDerivatives(
    x=per.hydraulicEfficiency.V_flow,
    y=per.hydraulicEfficiency.eta);
  motDer = if not per.effMetInt[3]==2 then zeros(size(per.motorEfficiency.V_flow,
    1)) elseif (size(per.motorEfficiency.V_flow, 1) == 1) then {0} else
    Buildings.Utilities.Math.Functions.splineDerivatives(
    x=per.motorEfficiency.V_flow,
    y=per.motorEfficiency.eta,
    ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
      x=per.motorEfficiency.eta,
      strict=false));


  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

  assert(not (per.etaMet==
           Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.PowerCurve
         and per.etaHydMet==
           Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.PowerCurve),
         "Only one of etaMet and etaHydMet can be set to
         Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.PowerCurve");

  assert(not (per.etaMet==
           Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.EulerNumber
         and per.etaHydMet==
           Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.EulerNumber),
         "Only one of etaMet and etaHydMet can be set to
         Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.EulerNumber");

  assert(per.etaMotMet==
           Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.NotProvided
         or per.etaMotMet==
           Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.Values
         or per.etaMotMet==
           Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.ValuesPLR,
         "Only values allowed for etaMet are
         Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.NotProvided,
         Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.Values, or
         Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.ValuesPLR,");

equation
  //assign values of dp and r_N, depending on which variable exists and is prescribed
  connect(dp_internal,dp);
  connect(dp_internal,dp_in);
  connect(r_N, y_in);
  y_out=r_N;

  connect(divByRho.u1,m_flow);
  connect(divByRho.u2,rho);
  connect(divByRho.y,V_flow);

  //For power computation via EulerNumber path.
  connect(effTab.u1, dp_internal);
  connect(effTab.u2, divByRho.y);
  connect(powTab.u1, dp_internal);
  connect(powTab.u2, V_flow);

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

  // Flow work definition
  WFlo = dp_internal*V_flow;

  // Total efficiency eta and consumed electric power PEle
  if per.effMetInt[1]==3 then
  // If power curve is provided for consumed electric power
    eta = Buildings.Utilities.Math.Functions.smoothMax(
            x1=WFlo/Buildings.Utilities.Math.Functions.smoothMax(
                      x1=PEle, x2=1E-5, deltaX=1E-6),
            x2=1E-5, deltaX=1E-6);
    if homotopyInitialization then
      PEle = homotopy(actual=cha.power(per=per.power, V_flow=V_flow, r_N=r_N, d=powDer, delta=delta),
                      simplified=V_flow/V_flow_nominal*
                            cha.power(per=per.power, V_flow=V_flow_nominal, r_N=1, d=powDer, delta=delta));
    else
      PEle = (rho/rho_default)*cha.power(per=per.power, V_flow=V_flow, r_N=r_N, d=powDer, delta=delta);
    end if;
  elseif per.effMetInt[1]==4 then
  // If peak total efficiency is provided
    connect(effTab.y,eta);
    connect(powTab.y,PEle);
  elseif per.effMetInt[1]==2 then
  // If total efficiency is provided as an array
    PEle = WFlo / eta;
    if homotopyInitialization then
      eta = homotopy(actual=cha.efficiency(per=per.totalEfficiency,     V_flow=V_flow, d=etaDer, r_N=r_N, delta=delta),
                        simplified=cha.efficiency(per=per.totalEfficiency, V_flow=V_flow_max,   d=etaDer, r_N=r_N, delta=delta));
    else
      eta = cha.efficiency(per=per.totalEfficiency, V_flow=V_flow, d=etaDer, r_N=r_N, delta=delta);
    end if;
  else
  // Total efficiency not provided
    PEle = WFlo / Buildings.Utilities.Math.Functions.smoothMax(
                    x1=eta, x2=1E-5, deltaX=1E-6);
    if per.effMetInt[2]<>1 and per.effMetInt[3]==1 then
    // If only hydraulic efficiency is provided
      eta = etaHyd;
    elseif per.effMetInt[2]==1 and per.effMetInt[3]<>1 then
    // If only motor efficiency is provided
      eta = etaMot;
    elseif per.effMetInt[2]<>1 and per.effMetInt[3]<>1 then
    // If both
      eta = etaHyd * etaMot;
    else
    // If neither
      eta = 0.49;
    end if;
  end if;

  // Hydraulic efficiency and hydraulic work
  if per.effMetInt[2]==3 then
  // If power curve is provided as hydraulic work
    etaHyd = Buildings.Utilities.Math.Functions.smoothMax(
               x1=WFlo/Buildings.Utilities.Math.Functions.smoothMax(
                         x1=WHyd, x2=1E-5, deltaX=1E-6),
               x2=1E-5, deltaX=1E-6);
    if homotopyInitialization then
      WHyd = homotopy(actual=cha.power(per=per.power, V_flow=V_flow, r_N=r_N, d=powDer, delta=delta),
                      simplified=V_flow/V_flow_nominal*
                            cha.power(per=per.power, V_flow=V_flow_nominal, r_N=1, d=powDer, delta=delta));
    else
      WHyd = (rho/rho_default)*cha.power(per=per.power, V_flow=V_flow, r_N=r_N, d=powDer, delta=delta);
    end if;
  elseif per.effMetInt[2]==4 then
  // If peak total efficiency is provided
    connect(effTab.y,etaHyd);
    connect(powTab.y,WHyd);
  elseif per.effMetInt[2]==2 then
  // If hydraulic effciency is provided as an array
    WHyd = WFlo / etaHyd;
    if homotopyInitialization then
      etaHyd = homotopy(actual=cha.efficiency(per=per.hydraulicEfficiency,     V_flow=V_flow, d=hydDer, r_N=r_N, delta=delta),
                        simplified=cha.efficiency(per=per.hydraulicEfficiency, V_flow=V_flow_max,   d=hydDer, r_N=r_N, delta=delta));
    else
      etaHyd = cha.efficiency(per=per.hydraulicEfficiency, V_flow=V_flow, d=hydDer, r_N=r_N, delta=delta);
    end if;
  else
  // Hydraulic efficiency not provided
    etaHyd = 1;
    WHyd = WFlo;
  end if;

  // Motor efficiency
  if per.effMetInt[3]==2 then
  // If motor efficiency provided as an array
    if homotopyInitialization then
      etaMot = homotopy(actual=cha.efficiency(per=per.motorEfficiency,     V_flow=V_flow, d=motDer, r_N=r_N, delta=delta),
                        simplified=cha.efficiency(per=per.motorEfficiency, V_flow=V_flow_max,   d=motDer, r_N=r_N, delta=delta));
    else
      etaMot = cha.efficiency(per=per.motorEfficiency,     V_flow=V_flow, d=motDer, r_N=r_N, delta=delta);
    end if;
  else
  // Motor efficiency not provided
    if per.effMetInt[1]==1 and per.effMetInt[2]<>1 then
    // Only hydraulic efficiency is provided
      etaMot = 1;
    else
      etaMot = eta;
    end if;
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
The nominal hydraulic characteristic (total pressure versus volume flow rate)
is given by a set of data points
using the data record <code>per</code>, which is an instance of
<a href=\"modelica://Buildings.Fluid.Movers.Data.Generic\">
Buildings.Fluid.Movers.Data.Generic</a>.
A cubic hermite spline with linear extrapolation is used to compute
the performance at other operating points.
</p>
<p>
The fan or pump's energy balance can be specified in three paths:
</p>
<ul>
<li>
If <code>per.use_powerCharacteristic</code>, then the data points for
normalized volume flow rate versus power consumption
is used to determine the power consumption, and then the efficiency
is computed based on the actual power consumption and the flow work.
</li>
<li>
If <code>per.use_eulerNumber</code>, 
then the operation condition at peak efficiency
is used to compute the efficiency and then the power 
by evaluating 
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Euler.correlation\">
Buildings.Fluid.Movers.BaseClasses.Euler.correlation</a>.
</li>
<li>
Else, the data points for
normalized volume flow rate versus efficiency is used to determine the efficiency,
and then the power consumption. The default is a constant efficiency of <i>0.49</i>.
This path corresponds to <code>per.use_motorEfficiency = true</code> 
but is used as the fallback option.
</li>
</ul>
<p>
These <code>use_</code> switches are handled by the enumeration
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod\">
Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod</a>.
For exceptions to this general rule, check the
<a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
User's Guide</a> for more information.
</p>
<p>
The model also takes into consideration that the power data given in
<code>per</code> may correspond to shaft power (brake horsepower)
or consumed power. They are treated differently. The user can specify this
by setting the value of <code>use_hydraulicPerformance</code>.
This is applicable to <code>use_powerCharacteristic</code>
and <code>use_eulerNumber</code>.
</p>
<ul>
<li>
If <code>use_hydraulicPerformance</code>,<br/>
<code>etaHyd = per.dp * per.V_flow / per.P</code>,<br/>
<code>PEle = per.P / etaMot</code>, and<br/>
<code>eta = etaHyd * etaMot</code>,<br/>
where <code>etaHyd</code> is bounded away from zero because it will be used
as denominator in
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.PowerInterface\">
Buildings.Fluid.Movers.BaseClasses.PowerInterface</a>.
However, this bounding increases the non-linearity of the equation system
and is avoided in other situations by simply assigning it as a constant 1.
</li>
<li>
Else,<br/>
<code>eta = per.dp * per.V_flow / per.P</code>,<br/>
<code>etaHyd = 1</code>, and<br/>
<code>etaMot = eta</code>.
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
February 23, 2022, by Hongxiang Fu:<br/>
To support the implementation of
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler\">
Buildings.Fluid.Movers.BaseClasses.Euler</a>:
<ul>
<li>
Added a new <code>elseif</code> branch in power calculation.
</li>
<li>
Moved the specification of <code>haveVMax</code>
and <code>V_flow_max</code> here from
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine\">
Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine</a>.
</li>
<li>
Rewrote statements using <code>not use_powerCharacteristic</code>
with the enumeration
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod\">
Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod</a>.
</li>
<li>
Added a switch <code>use_hydraulicPerformance</code> to differentiate the power
computation for power data given as shaft power (brake horsepower) or consumed
power.
</li>
</ul>
These are for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
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
