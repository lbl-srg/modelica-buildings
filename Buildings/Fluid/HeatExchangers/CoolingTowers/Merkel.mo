within Buildings.Fluid.HeatExchangers.CoolingTowers;
model Merkel "Cooling tower model based on merkel theory"
    extends Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTower(
    final m_flow_nominal = m2_flow_nominal,
    final QWat_flow(y=-eps*QMax_flow));

  import con = Buildings.Fluid.Types.HeatExchangerConfiguration;
  import flo = Buildings.Fluid.Types.HeatExchangerFlowRegime;
  import cha =
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics;

 parameter Modelica.SIunits.MassFlowRate m1_flow_nominal
   "Nominal mass flow rate of medium 1"
   annotation (Dialog(group="Nominal condition"));
 parameter Modelica.SIunits.MassFlowRate m2_flow_nominal
   "Nominal mass flow rate of medium 2"
   annotation (Dialog(group="Nominal condition"));
 parameter  Modelica.SIunits.Temperature TAirInWB_nominal
   "Nominal outdoor wetbulb temperature"
   annotation (Dialog(group="Nominal condition"));
 parameter  Modelica.SIunits.Temperature TWatIn_nominal
   "Nominal water inlet temperature"
   annotation (Dialog(group="Nominal condition"));
 parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(min=0)
   "Nominal heat transfer,positive"
   annotation (Dialog(group="Nominal condition"));
 parameter Modelica.SIunits.Power PFan_nominal(min=0)
   "Fan power"
   annotation (Dialog(group="Nominal condition"));

 final parameter  Modelica.SIunits.Temperature T_a1_nominal = TAirInWB_nominal
    "Nominal temperature at port a1"
    annotation (Dialog(group="Nominal condition"));
 final parameter Modelica.SIunits.Temperature T_a2_nominal = TWatIn_nominal
    "Nominal temperature at port a2"
    annotation (Dialog(group="Nominal condition"));

 parameter con configuration "Heat exchanger configuration"
    annotation (Evaluate=true,Dialog(group="Nominal condition"));

 parameter Real yMin(min=0.01, max=1) = 0.3
    "Minimum control signal until fan is switched off (used for smoothing between forced and free convection regime)";
 parameter Real fraFreCon(min=0, max=1) = 0.125
    "Fraction of tower capacity in free convection regime";
 parameter cha.fan fanRelPow(
       r_V = {0, 0.1,   0.3,   0.6,   1},
       r_P = {0, 0.1^3, 0.3^3, 0.6^3, 1})
    "Fan relative power consumption as a function of control signal, fanRelPow=P(y)/P(y=1)"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
 parameter Correlations.corUAMerkel UACor
    "UA correction curves"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  final parameter Modelica.SIunits.ThermalConductance UA_nominal(fixed=false)
    "Thermal conductance at nominal flow, used to compute heat capacity";
  final parameter Real eps_nominal(fixed=false)
    "Nominal heat transfer effectiveness";

  Modelica.Blocks.Interfaces.RealInput TAir(
    min=0,
    unit="K",
    displayUnit="degC")
    "Entering air wet bulb temperature"
     annotation (Placement(transformation(
          extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput y(unit="1") "Fan control signal"
     annotation (Placement(transformation(
          extent={{-140,60},{-100,100}})));
  Modelica.SIunits.Power PFan "Fan power";

  Modelica.SIunits.SpecificHeatCapacity cpw
    "Heat capacity of water";

  Modelica.SIunits.SpecificHeatCapacity cpa = 1006
    "Heat capacity of air";

  Modelica.SIunits.MassFlowRate m2_flow = m_flow
    "Mass flow rate from port_a to port_b (mWat_flow > 0 is design flow direction)";

  Modelica.SIunits.Temperature Ta1 = TAir "Inlet temperature medium 1";
  Modelica.SIunits.Temperature Ta2 "Inlet temperature medium 2";
  Modelica.SIunits.Temperature Tb1 "Outlet temperature medium 1";
  Modelica.SIunits.Temperature Tb2 "Outlet temperature medium 2";

  Modelica.SIunits.ThermalConductance C1_flow
    "Heat capacity flow rate medium 1";
  Modelica.SIunits.ThermalConductance C2_flow
    "Heat capacity flow rate medium 2";
  Modelica.SIunits.ThermalConductance CMin_flow(min=0)
    "Minimum heat capacity flow rate";
  Modelica.SIunits.HeatFlowRate QMax_flow
    "Maximum heat flow rate into medium 1";
//  flo flowRegime=flo.CounterFlow
//    "Heat exchanger flow regime";
  Modelica.SIunits.ThermalConductance UAe(min=0)
    "Thermal conductance for equivalent fluid";
  Real eps(min=0, max=1) "Heat exchanger effectiveness";
//  Real Z(min=0) "Ratio of capacity flow rate (CMin/CMax)";
  Modelica.SIunits.MassFlowRate m1_flow "Air mass flowrate";
  Modelica.SIunits.ThermalConductance UA "Thermal conductance";

protected
  final package Air = Buildings.Media.Air "Package of medium air";
  final parameter Real NTU_nominal(min=0, fixed=false)
    "Nominal number of transfer units";
  final parameter Real fanRelPowDer[size(fanRelPow.r_V,1)](each fixed=false)
    "Coefficients for fan relative power consumption as a function of control signal";
  final parameter Air.ThermodynamicState sta1_default = Air.setState_pTX(
     T=TAirInWB_nominal,
     p=Air.p_default,
     X=Air.X_default[1:Air.nXi]) "Default state for medium 1";
  final parameter Medium.ThermodynamicState sta2_default = Medium.setState_pTX(
     T=TWatIn_nominal,
     p=Medium.p_default,
     X=Medium.X_default[1:Medium.nXi]) "Default state for medium 2";

  parameter Real delta=1E-3 "Parameter used for smoothing";
  parameter Modelica.SIunits.SpecificHeatCapacity cpe_nominal(fixed=false)
    "Specific heat capacity of the equivalent medium on medium 1 side";
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal(fixed=false)
    "Specific heat capacity of medium 1 at nominal condition";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal(fixed=false)
    "Specific heat capacity of medium 2 at nominal condition";
  parameter Modelica.SIunits.ThermalConductance C1_flow_nominal(fixed=false)
    "Nominal capacity flow rate of Medium 1";
  parameter Modelica.SIunits.ThermalConductance C2_flow_nominal(fixed=false)
    "Nominal capacity flow rate of Medium 2";
  parameter Modelica.SIunits.ThermalConductance CMin_flow_nominal(fixed=false)
    "Minimal capacity flow rate at nominal condition";
  parameter Modelica.SIunits.ThermalConductance CMax_flow_nominal(fixed=false)
    "Maximum capacity flow rate at nominal condition";
  parameter Real Z_nominal(
    min=0,
    max=1,
    fixed=false) "Ratio of capacity flow rate at nominal condition";
  parameter Modelica.SIunits.Temperature T_b1_nominal(fixed=false)
    "Nominal temperature at port b1";
  parameter Modelica.SIunits.Temperature T_b2_nominal(fixed=false)
    "Nominal temperature at port b2";
  parameter flo flowRegime_nominal(fixed=false)
    "Heat exchanger flow regime at nominal flow rates";

  flo flowRegime(fixed=false, start=flowRegime_nominal)
    "Heat exchanger flow regime";
  Real FRAirAct "Actual air flow ratio";
  Real FRWatAct "Actual water flow ratio";
  Real UA_FAir "UA correction factor as function of air flow ratio";
  Real UA_FWat "UA correction factor as function of water flow ratio";
  Real UA_DifWB "UA correction factor as function of differential wetbulb temperature";
  Real corFac_FAir "Smooth factor as function of air flow ratio";
  Real corFac_FWat "Smooth factor as function of water flow ratio";
  Modelica.SIunits.SpecificHeatCapacity cpe "Specific heat capacity of the equivalent fluid";

initial equation
  cp1_nominal = Air.specificHeatCapacityCp(sta1_default);
  cp2_nominal = Medium.specificHeatCapacityCp(sta2_default);
  cpe_nominal = Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.cpe(T_a1_nominal,T_b1_nominal);

  // Heat transferred from fluid 1 to 2 at nominal condition
  Q_flow_nominal = -m1_flow_nominal*cpe_nominal*(T_a1_nominal - T_b1_nominal);
  Q_flow_nominal =  m2_flow_nominal*cp2_nominal*(T_a2_nominal - T_b2_nominal);
  C1_flow_nominal = m1_flow_nominal*cpe_nominal;
  C2_flow_nominal = m2_flow_nominal*cp2_nominal;
  CMin_flow_nominal = min(C1_flow_nominal, C2_flow_nominal);
  CMax_flow_nominal = max(C1_flow_nominal, C2_flow_nominal);
  Z_nominal = CMin_flow_nominal/CMax_flow_nominal;
  eps_nominal = abs(Q_flow_nominal/((T_a1_nominal - T_a2_nominal)*
    CMin_flow_nominal));
  assert(eps_nominal > 0 and eps_nominal < 1,
    "eps_nominal out of bounds, eps_nominal = " + String(eps_nominal) +
    "\n  To achieve the required heat transfer rate at epsilon=0.8, set |T_a1_nominal-T_a2_nominal| = "
     + String(abs(Q_flow_nominal/0.8*CMin_flow_nominal)) +
    "\n  or increase flow rates. The current parameters result in " +
    "\n  CMin_flow_nominal = " + String(CMin_flow_nominal) +
    "\n  CMax_flow_nominal = " + String(CMax_flow_nominal));
  // Assign the flow regime for the given heat exchanger configuration and capacity flow rates
  if (configuration == con.CrossFlowStream1MixedStream2Unmixed) then
    flowRegime_nominal = if (C1_flow_nominal < C2_flow_nominal) then flo.CrossFlowCMinMixedCMaxUnmixed
       else flo.CrossFlowCMinUnmixedCMaxMixed;
  elseif (configuration == con.CrossFlowStream1UnmixedStream2Mixed) then
    flowRegime_nominal = if (C1_flow_nominal < C2_flow_nominal) then flo.CrossFlowCMinUnmixedCMaxMixed
       else flo.CrossFlowCMinMixedCMaxUnmixed;
  elseif (configuration == con.ParallelFlow) then
    flowRegime_nominal = flo.ParallelFlow;
  elseif (configuration == con.CounterFlow) then
    flowRegime_nominal = flo.CounterFlow;
  elseif (configuration == con.CrossFlowUnmixed) then
    flowRegime_nominal = flo.CrossFlowUnmixed;
  else
    // Invalid flow regime. Assign a value to flowRegime_nominal, and stop with an assert
    flowRegime_nominal = flo.CrossFlowUnmixed;
    assert(configuration >= con.ParallelFlow and configuration <= con.CrossFlowStream1UnmixedStream2Mixed,
      "Invalid heat exchanger configuration.");
  end if;

  NTU_nominal = if (eps_nominal > 0 and eps_nominal < 1) then
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
    eps=eps_nominal,
    Z=Z_nominal,
    flowRegime=Integer(flowRegime_nominal)) else 0;
  UA_nominal = NTU_nominal*CMin_flow_nominal;

  // Initialize fan power
  // Derivatives for spline that interpolates the fan relative power
  fanRelPowDer = Buildings.Utilities.Math.Functions.splineDerivatives(
            x=fanRelPow.r_V,
            y=fanRelPow.r_P,
            ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
              x=fanRelPow.r_P,
              strict=false));
  // Check validity of relative fan power consumption at y=yMin and y=1
  assert(cha.normalizedPower(per=fanRelPow, r_V=yMin, d=fanRelPowDer) > -1E-4,
    "The fan relative power consumption must be non-negative for y=0."
  + "\n   Obtained fanRelPow(0) = " + String(cha.normalizedPower(per=fanRelPow, r_V=yMin, d=fanRelPowDer))
  + "\n   You need to choose different values for the parameter fanRelPow.");
  assert(abs(1-cha.normalizedPower(per=fanRelPow, r_V=1, d=fanRelPowDer))<1E-4, "The fan relative power consumption must be one for y=1."
  + "\n   Obtained fanRelPow(1) = " + String(cha.normalizedPower(per=fanRelPow, r_V=1, d=fanRelPowDer))
  + "\n   You need to choose different values for the parameter fanRelPow."
  + "\n   To increase the fan power, change fraPFan_nominal or PFan_nominal.");

equation

  // Assign the flow regime for the given heat exchanger configuration and capacity flow rates
  if (configuration == con.ParallelFlow) then
    flowRegime = if (C1_flow*C2_flow >= 0) then flo.ParallelFlow else flo.CounterFlow;
  elseif (configuration == con.CounterFlow) then
    flowRegime = if (C1_flow*C2_flow >= 0) then flo.CounterFlow else flo.ParallelFlow;
  elseif (configuration == con.CrossFlowUnmixed) then
    flowRegime = flo.CrossFlowUnmixed;
  elseif (configuration == con.CrossFlowStream1MixedStream2Unmixed) then
    flowRegime = if (C1_flow < C2_flow) then flo.CrossFlowCMinMixedCMaxUnmixed
       else flo.CrossFlowCMinUnmixedCMaxMixed;
  else
    // have ( configuration == con.CrossFlowStream1UnmixedStream2Mixed)
    flowRegime = if (C1_flow < C2_flow) then flo.CrossFlowCMinUnmixedCMaxMixed
       else flo.CrossFlowCMinMixedCMaxUnmixed;
  end if;

  // REVERSE FLOW
   if allowFlowReversal then
    if homotopyInitialization then
      Ta2=Medium.temperature(Medium.setState_phX(p=port_a.p,
                                 h=homotopy(actual=actualStream(port_a.h_outflow),
                                            simplified=inStream(port_a.h_outflow)),
                                 X=homotopy(actual=actualStream(port_a.Xi_outflow),
                                            simplified=inStream(port_a.Xi_outflow))));
      Tb2=Medium.temperature(Medium.setState_phX(p=port_b.p,
                                 h=homotopy(actual=actualStream(port_b.h_outflow),
                                            simplified=port_b.h_outflow),
                                 X=homotopy(actual=actualStream(port_b.Xi_outflow),
                                            simplified=port_b.Xi_outflow)));
      cpw=Medium.specificHeatCapacityCp(Medium.setState_phX(p=port_a.p,
                                 h=homotopy(actual=actualStream(port_a.h_outflow),
                                            simplified=inStream(port_a.h_outflow)),
                                 X=homotopy(actual=actualStream(port_a.Xi_outflow),
                                            simplified=inStream(port_a.Xi_outflow))));
    else
      Ta2=Medium.temperature(Medium.setState_phX(p=port_a.p,
                                 h=actualStream(port_a.h_outflow),
                                 X=actualStream(port_a.Xi_outflow)));
      Tb2=Medium.temperature(Medium.setState_phX(p=port_b.p,
                                 h=actualStream(port_b.h_outflow),
                                 X=actualStream(port_b.Xi_outflow)));
      cpw=Medium.specificHeatCapacityCp(Medium.setState_phX(p=port_a.p,
                                 h=actualStream(port_a.h_outflow),
                                 X=actualStream(port_a.Xi_outflow)));
    end if; // homotopyInitialization

  else // reverse flow not allowed
    Ta2=Medium.temperature(Medium.setState_phX(p=port_a.p,
                               h=inStream(port_a.h_outflow),
                               X=inStream(port_a.Xi_outflow)));
    Tb2=Medium.temperature(Medium.setState_phX(p=port_b.p,
                               h=inStream(port_b.h_outflow),
                               X=inStream(port_b.Xi_outflow)));
    cpw=Medium.specificHeatCapacityCp(Medium.setState_phX(p=port_a.p,
                               h=inStream(port_a.h_outflow),
                               X=inStream(port_a.Xi_outflow)));
   end if;

  // Determine the airflow based on fan speed signal
  m1_flow = Buildings.Utilities.Math.Functions.spliceFunction(
        pos = y*m1_flow_nominal,
        neg = fraFreCon*m1_flow_nominal,
        x=y-yMin+yMin/20,
        deltax=yMin/20);
  FRAirAct = m1_flow/m1_flow_nominal;
  FRWatAct = m2_flow/m2_flow_nominal;

  // UA for equivalent fluid
  // Adjust UA
  UA_FAir = Buildings.Fluid.Utilities.extendedPolynomial(
    x = FRAirAct,
    c = UACor.UAFunAirFra,
    xMin = UACor.FRAirMin,
    xMax = UACor.FRAirMax)
    "UA correction factor as function of air flow fraction";
  UA_FWat = Buildings.Fluid.Utilities.extendedPolynomial(
    x = FRWatAct,
    c = UACor.UAFunWatFra,
    xMin = UACor.FRWatMin,
    xMax = UACor.FRWatMax)
    "UA correction factor as function of water flow fraction";
  UA_DifWB = Buildings.Fluid.Utilities.extendedPolynomial(
    x = TAirInWB_nominal - Ta1,
    c = UACor.UAFunDifWB,
    xMin = UACor.TDiffWBMin,
    xMax = UACor.TDiffWBMax)
    "UA correction factor as function of differential wet bulb temperature";
  corFac_FAir = Buildings.Utilities.Math.Functions.smoothHeaviside(
       x = FRAirAct - UACor.FRAirMin/4,
       delta = UACor.FRAirMin/4);
  corFac_FWat = Buildings.Utilities.Math.Functions.smoothHeaviside(
       x = FRWatAct - UACor.FRWatMin/4,
       delta = UACor.FRWatMin/4);

  UA = UA_nominal*UA_FAir*UA_FWat*UA_DifWB*corFac_FAir*corFac_FWat;
  cpa*UAe = UA*cpe;

  // Capacity for air and water
  C1_flow = abs(m1_flow)*cpe;
  C2_flow = abs(m2_flow)*cpw;
  CMin_flow = Buildings.Utilities.Math.Functions.smoothMin(
    C1_flow, C2_flow,delta*CMin_flow_nominal);

  // Calculate epsilon
  eps = Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_C(
    UA=UAe,
    C1_flow=C1_flow,
    C2_flow=C2_flow,
    flowRegime=Integer(flowRegime),
    CMin_flow_nominal=CMin_flow_nominal,
    CMax_flow_nominal=CMax_flow_nominal,
    delta=delta);
  // QMax_flow is maximum heat transfer into medium air: positive means heating
    QMax_flow = CMin_flow*(Ta2 - Ta1);
    TAppAct=Tb2-TAir;
    TAirHT=TAir;
    eps*QMax_flow = C1_flow*(Tb1 - Ta1);

  // Power consumption
  PFan = Buildings.Utilities.Math.Functions.spliceFunction(
        pos=cha.normalizedPower(per=fanRelPow, r_V=y, d=fanRelPowDer) * PFan_nominal,
        neg=0,
        x=y-yMin+yMin/20,
        deltax=yMin/20);

  cpe = Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.cpe(Ta1,Tb1);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-102,112},{-68,74}},
          lineColor={0,0,127},
          textString="yFan"),
        Text(
          extent={{-104,70},{-70,32}},
          lineColor={0,0,127},
          textString="TWB"),
        Rectangle(
          extent={{-100,81},{-70,78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-44,6},{68,-114}},
          lineColor={255,255,255},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          textString="Merkel")}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Merkel;
