within Buildings.Fluid.HeatExchangers;
model WetEffectivenessNTU
  "Heat exchanger with effectiveness - NTU relation and moisture condensation"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialEffectiveness(
  sensibleOnly1 = true,
  sensibleOnly2 = false,
  redeclare package Medium2 =
      Modelica.Media.Interfaces.PartialCondensingGases);
  // redeclare Medium with a more restricting base class. This improves the error
  // message if a user selects a medium without water vapor
  import con = Buildings.Fluid.Types.HeatExchangerConfiguration;
  import flo = Buildings.Fluid.Types.HeatExchangerFlowRegime;
  import psy = Buildings.Utilities.Psychrometrics.Functions;
  parameter Modelica.SIunits.Temperature T_a1_nominal
    "Nominal temperature at port a1" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a2_nominal
    "Nominal temperature at port a2" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b2_nominal
    "Nominal temperature at port b2" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFraction XW_a2_nominal
    "Nominal humidity mass fraction at port a2" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFraction XW_b2_nominal
    "Nominal humidity mass fraction at port b2" annotation (Dialog(group="Nominal condition"));
  parameter con configuration "Heat exchanger configuration"
    annotation (Evaluate=true);
  final parameter Real SHR_nominal = -QSen2_flow_nominal/Q_flow_nominal
    "Sensible to total heat ratio";
  Real eps(min=0, max=1) "Heat exchanger effectiveness";
  Real Z(min=0, max=1) "Ratio of capacity flow rate (CMin/CMax)";
  Real NTU(min=0) "Number of transfer units";
  Modelica.SIunits.MassFraction X_in2 "Mass fraction of air inlet";
  Modelica.SIunits.MassFraction X_out2 "Mass fraction of air outlet";
  Modelica.SIunits.Temperature Tdp_in2 "Dewpoint temperature of air inlet";
  Modelica.SIunits.HeatFlowRate QSen2_flow
    "Sensible heat input into air stream (negative if air is cooled)";
  Modelica.SIunits.HeatFlowRate QLat2_flow
    "Latent heat input into air (negative if air is dehumidified)";
  Real SHR(min=0, max=1, unit="1") "Sensible to total heat ratio";
  Modelica.SIunits.MassFraction dX2
    "Change in species concentration of medium 2";
protected
  Modelica.SIunits.MassFlowRate CWetMin_flow
    "Minimum capacity flow rate for wet coil";
  Real ZWet(min=0, max=1) "Ratio of capacity flow rates for wet coil";
  Real NTUWet(min=0) "Number of transfer units for wet coil";
  Real epsWet(min=0, max=1) "Effectiveness of wet coil";
protected
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
  parameter Modelica.SIunits.MassFlowRate CWet1_flow_nominal(fixed=false)
    "Capacity flow rate medium 1 for wet coil at nominal condition";
  parameter Modelica.SIunits.MassFlowRate CWetMin_flow_nominal(fixed=false)
    "Minimum capacity flow rate for wet coil at nominal condition";
  parameter Modelica.SIunits.MassFlowRate CWetMax_flow_nominal(fixed=false)
    "Maximum capacity flow rate for wet coil at nominal condition";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(fixed=false)
    "Nominal heat transfer (positive for cooling coil)";
  parameter Modelica.SIunits.HeatFlowRate QSen2_flow_nominal(fixed=false)
    "Nominal sensible heat transfer into medium 2 (negative for cooling coil)";
  parameter Modelica.SIunits.HeatFlowRate QMax_flow_nominal(fixed=false)
    "Maximum possible heat transfer rate at nominal condition (positive for cooling coil)";
  parameter Real Z_nominal(min=0, max=1, fixed=false)
    "Ratio of capacity flow rate at nominal condition";
  parameter Modelica.SIunits.Temperature T_b1_nominal(fixed=false)
    "Nominal temperature at port b1";
  parameter Modelica.SIunits.SpecificEnthalpy h_a2_nominal(fixed=false)
    "Specific enthalpy at port a2";
  parameter Modelica.SIunits.SpecificEnthalpy h_b2_nominal(fixed=false)
    "Specific enthalpy at port b2";
  parameter Modelica.SIunits.MassFraction XWSatOut_nominal(fixed=false)
    "Water vapor concentration if air outlet were at water inlet temperature and saturated";
  parameter Modelica.SIunits.SpecificEnthalpy hSatOut_nominal(fixed=false)
    "Specific enthalpy if air outlet were at water inlet temperature and saturated";
  parameter Modelica.SIunits.SpecificHeatCapacity cpSat_nominal(fixed=false)
    "Specific heat capacity along saturation line";
  parameter Real mMax(unit="1/K", fixed=false)
    "Upper bound for slope that is used to compute apparatus dewpoint temperature";
  parameter Real m_nominal(unit="1/K", fixed=false)
    "Slope based on nominal conditions, used to compute apparatus dewpoint temperature";
  parameter Real m(unit="1/K", fixed=false)
    "Slope, used to compute apparatus dewpoint temperature";
  parameter Modelica.SIunits.Temperature TAppDP_nominal(fixed=false, min=T_a1_nominal, start=283.15)
    "Apparatus dewpoint temperature";
  parameter Modelica.SIunits.MassFraction XAppDP_nominal(fixed=false, start=XW_b2_nominal)
    "Apparatus dewpoint humidity ratio";
  parameter Modelica.SIunits.SpecificEnthalpy hAppDP_nominal(fixed=false)
    "Apparatus dewpoint specific enthalpy";
  parameter Real byPasUncon_nominal(fixed=false)
    "Heat exchanger bypass, prior to constraining it to reasonable range";
  parameter Real byPas_nominal(fixed=false, min=0, max=1)
    "Heat exchanger bypass";
  parameter Modelica.SIunits.MassFlowRate UAEnt_nominal(fixed=false)
    "UA value based on enthalpy difference (with units of mass flow rate)";
  parameter Modelica.SIunits.ThermalConductance UA1_nominal(min=1, fixed=false)
    "Water-side UA value";
  parameter Modelica.SIunits.ThermalConductance UA2_nominal(min=1, fixed=false)
    "Air-side UA value";
  parameter Modelica.SIunits.ThermalConductance UA_nominal(fixed=false)
    "Nominal UA value";
  parameter Real NTU_nominal(min=0, fixed=false)
    "Nominal number of transfer units";
  parameter Real eps_nominal(fixed=false) "Nominal heat transfer effectiveness";
  parameter flo flowRegime_nominal(fixed=false)
    "Heat exchanger flow regime at nominal flow rates";
  flo flowRegime(fixed=false) "Heat exchanger flow regime";
  // Quantities to compute condensate temperature
  Modelica.SIunits.MassFraction XSat_in1
    "Water vapor concentration if air is saturated at water inlet temperature";
  Modelica.SIunits.SpecificEnthalpy hSat_in1
    "Specific enthalpy of air if it is saturated at water inlet temperature";
  Modelica.SIunits.SpecificEnthalpy h_in2 "Specific enthalpy of air inlet";
  Modelica.SIunits.SpecificEnthalpy h_out2 "Specific enthalpy of air outlet";
  Modelica.SIunits.SpecificHeatCapacity cpSat
    "Specific heat capacity along saturation line";
  Modelica.SIunits.MassFlowRate CWet1_flow
    "Capacity flow rate medium 1 for wet coil";
  Modelica.SIunits.HeatFlowRate QWetMax_flow
    "Maximum heat flow rate for completely wet coil";
  Modelica.SIunits.SpecificHeatCapacity cp_in2
    "Specific heat capacity of water/moisture mixture at air inlet";
  Modelica.SIunits.SpecificEnthalpy hCon_out2
    "Specific enthalpy of air outlet if at condensation temperature";
  Modelica.SIunits.Temperature TCon_out2
    "Temperature of air outlet if at condensation temperature";
  Modelica.SIunits.MassFraction XConSat_out2
    "Species concentration of air outlet if at condensation temperature";
  Real epsTCon(min=0, max=1)
    "Effectiveness for computing condensate temperature";
  Modelica.SIunits.Temperature T_out2
    "Outlet air temperature (only used when condensate occurs)";
  Integer state_fixme;
initial equation
  assert(m1_flow_nominal > 0, "m1_flow_nominal must be positive, m1_flow_nominal = " + realString(m1_flow_nominal));
  assert(m2_flow_nominal > 0, "m2_flow_nominal must be positive, m2_flow_nominal = " + realString(m2_flow_nominal));
  assert(T_a1_nominal < T_a2_nominal, "Water inlet temperature must be smaller than water outlet temperature."
      + "\n  T_a1_nominal = " + realString(T_a1_nominal)
      + "\n  T_a2_nominal = " + realString(T_a2_nominal));
  assert(XWSatOut_nominal < XW_a2_nominal, "Saturation enthalpy at Water inlet temperature must be smaller than inlet air humidity."
      + "\n  To fix, increase XW_a2_nominal or decrease T_a1_nominal."
      + "\n  T_a1_nominal = " + realString(T_a1_nominal)
      + "\n  XW_a2_nominal = " + realString(XW_a2_nominal)
      + "\n  XWSatOut_nominal = XSat(T_a1_nominal) = " + realString(XWSatOut_nominal));
  assert(m_nominal < mMax,
      "The line between air inlet and outlet state at nominal condition"
    + "\n  does not intersect the saturation line above the water inlet temperature T_a1_nominal."
    + "\n  For m_nominal=(XW_a2_nominal-XW_b2_nominal)/(T_a2_nominal-T_b2_nominal),"
    + "\n  the maximum slope is  mMax      = " + realString(mMax) + " [(kg/kg)/K]"
    + "\n  The computed slope is m_nominal = " + realString(m_nominal) + " [(kg/kg)/K]"
    + "\n  The theoretical maximum dehumidification for m_nominal = mMax is " +
      realString((T_a2_nominal-T_b2_nominal)*mMax) + "[kg/kg]."
    + "\n  To fix this problem, adjust some of the following model parameters"
    + "\n     T_a2_nominal  = " + realString(T_a2_nominal)
    + "\n     T_b2_nominal  = " + realString(T_b2_nominal)
    + "\n     XW_a2_nominal = " + realString(XW_a2_nominal)
    + "\n     XW_b2_nominal = " + realString(XW_b2_nominal));
  cp1_nominal = Medium1.specificHeatCapacityCp(
      Medium1.setState_pTX(p=Medium1.p_default, T=T_a1_nominal, X=Medium1.X_default));
  cp2_nominal = Medium2.specificHeatCapacityCp(
      Medium2.setState_pTX(p=Medium2.p_default, T=T_a2_nominal, X={XW_a2_nominal, 1-XW_a2_nominal}));
  h_a2_nominal = Medium2.h_pTX(p=Medium2.p_default, T=T_a2_nominal, X={XW_a2_nominal, 1-XW_a2_nominal});
  h_b2_nominal = Medium2.h_pTX(p=Medium2.p_default, T=T_b2_nominal, X={XW_b2_nominal, 1-XW_b2_nominal});
  // heat transfered from fluid 2 to 1 at nominal condition
  // Since Q=Q1=-Q2=-(QSen2+QLat2), it follows that QSen2<0 and QLat2<0 for cooling and dehumidification
  // of the air stream
  Q_flow_nominal     = m1_flow_nominal * cp1_nominal * (T_b1_nominal-T_a1_nominal);
  QSen2_flow_nominal = m2_flow_nominal * cp2_nominal * (T_b2_nominal-T_a2_nominal);
 -Q_flow_nominal     = m2_flow_nominal *               (h_b2_nominal-h_a2_nominal);
  C1_flow_nominal   = m1_flow_nominal * cp1_nominal;
  C2_flow_nominal   = m2_flow_nominal * cp2_nominal;
  CMin_flow_nominal = min(C1_flow_nominal, C2_flow_nominal);
  CMax_flow_nominal = max(C1_flow_nominal, C2_flow_nominal);
  Z_nominal         = CMin_flow_nominal/CMax_flow_nominal;
  cpSat_nominal = Buildings.Fluid.HeatExchangers.BaseClasses.cpSat(T1=T_a1_nominal, XW2=XW_a2_nominal);
  // QMax_flow_nominal is computed using the difference in enthalpy between the air inlet and the air outlet, assuming the
  // air outlet is at the water inlet temperature and at saturation.
  // Note that XSaturation() takes as an argument the state, which requires X. However, X is not used in Xsaturation().
  XWSatOut_nominal = Medium2.Xsaturation(Medium2.setState_pTX(p=Medium2.p_default, T=T_a1_nominal));
  hSatOut_nominal = Medium2.h_pTX(p=Medium2.p_default, T=T_a1_nominal,
                                           X={XWSatOut_nominal, 1-XWSatOut_nominal});
  assert(h_a2_nominal > hSatOut_nominal, "Error in model parameters.");
  // Note: since Q_flow_nominal < 0, we compute QMax_flow_nominal so that it is smaller than zero.
  CWet1_flow_nominal = m1_flow_nominal*cp1_nominal/cpSat_nominal;
  CWetMin_flow_nominal = min(CWet1_flow_nominal, m2_flow_nominal);
  CWetMax_flow_nominal = max(CWet1_flow_nominal, m2_flow_nominal);
  QMax_flow_nominal = CWetMin_flow_nominal * (h_a2_nominal-hSatOut_nominal);
  // The following function determines iteratively the apparatus dew point temperature at nominal conditions.
  // mMax is the maximum slope needed for the line between air inlet and outlet temperature
  // to intersect the saturation line above the water inlet temperature T_a1_nominal.
  mMax      = (XW_a2_nominal-psy.X_pW(psy.pW_Tdp(T_a1_nominal)))/(T_a2_nominal-T_a1_nominal);
  m_nominal = (XW_a2_nominal-XW_b2_nominal)                     /(T_a2_nominal-T_b2_nominal);
  (TAppDP_nominal, XAppDP_nominal, m) = Buildings.Fluid.HeatExchangers.BaseClasses.appartusDewPoint(
                                           TAir_in=T_a2_nominal,
                                           TAir_out=T_b2_nominal,
                                           XW_in=XW_a2_nominal, XW_out=XW_b2_nominal);
//  TAppDP_nominal = T_a2_nominal - (XW_a2_nominal-XAppDP_nominal)/m;
//  XAppDP_nominal = max(XWSatOut_nominal, psy.X_pW(psy.pW_Tdp(TAppDP_nominal)));
  hAppDP_nominal = Medium2.h_pTX(p=Medium2.p_default, T=TAppDP_nominal, X={XAppDP_nominal, 1-XAppDP_nominal});
  assert(TAppDP_nominal < T_b2_nominal, "Apparatus dewpoint temperature must be smaller than air outlet temperature."
    + "\n   Obtained TAppDP_nominal = " + realString(TAppDP_nominal)
    + "\n            T_b2_nominal   = " + realString(T_b2_nominal)
    + "\n   Check model for correct parameters.");
  assert(TAppDP_nominal > T_a1_nominal, "Apparatus dewpoint temperature must be bigger than water inlet temperature."
    + "\n   Obtained TAppDP_nominal = " + realString(TAppDP_nominal)
    + "\n            T_a1_nominal   = " + realString(T_a1_nominal)
    + "\n   Check model for correct parameters.");
  assert(m>0, "Slope for apparatus dewpoint temperature calculation must be positive."
    + "\n   Check model for correct parameters.");
  // Bypass factor
  // Original and constrained to 0 to 0.5
  byPasUncon_nominal = (h_b2_nominal-hAppDP_nominal)/(h_a2_nominal-hAppDP_nominal);
  byPas_nominal = max(min(0.5, byPasUncon_nominal), 0);
  eps_nominal = Q_flow_nominal/QMax_flow_nominal;
  assert(eps_nominal > 0 and eps_nominal < 1, "eps_nominal out of bounds, eps_nominal = " + realString(eps_nominal) +
    "\n  To achieve the required heat transfer rate at epsilon=0.8, set |T_a1_nominal-T_a2_nominal| = " +
    realString(abs(Q_flow_nominal/0.8*CMin_flow_nominal)) +
    "\n  or increase flow rates. The current parameters result in " +
    "\n  CMin_flow_nominal = " + realString(CMin_flow_nominal) +
    "\n  CMax_flow_nominal = " + realString(CMax_flow_nominal) +
    "\n  Q_flow_nominal    = " + realString(Q_flow_nominal) +
    "\n  QMax_flow_nominal = " + realString(QMax_flow_nominal));
  // Assign the flow regime for the given heat exchanger configuration and capacity flow rates
  if ( configuration == con.CrossFlowStream1MixedStream2Unmixed) then
    flowRegime_nominal = if ( C1_flow_nominal < C2_flow_nominal) then
        flo.CrossFlowCMinMixedCMaxUnmixed else
        flo.CrossFlowCMinUnmixedCMaxMixed;
  elseif ( configuration == con.CrossFlowStream1UnmixedStream2Mixed) then
    flowRegime_nominal = if ( C1_flow_nominal < C2_flow_nominal) then
        flo.CrossFlowCMinUnmixedCMaxMixed else
        flo.CrossFlowCMinMixedCMaxUnmixed;
  elseif (configuration == con.ParallelFlow) then
      flowRegime_nominal = flo.ParallelFlow;
  elseif (configuration == con.CounterFlow) then
      flowRegime_nominal = flo.CounterFlow;
  elseif (configuration == con.CrossFlowUnmixed) then
      flowRegime_nominal = flo.CrossFlowUnmixed;
  else
    flowRegime_nominal = 0;
    assert(configuration > 0 and configuration < 6, "Invalid heat exchanger configuration.");
  end if;
  // This equation defines UAEnt_nominal as the value that will achieve Q_flow_nominal
  // for the air inlet enthalpy minus the saturation enthalpy at the water temperature,
  // and for the given capacity flow rates.
  Q_flow_nominal = BaseClasses.epsilon_ntuZ(NTU=UAEnt_nominal/CWetMin_flow_nominal,
                                            Z=CWetMin_flow_nominal/CWetMax_flow_nominal,
                                            flowRegime=flowRegime_nominal)
                   * CWetMin_flow_nominal * (h_a2_nominal-hSatOut_nominal);
  // Air side UA value
  if ( hAppDP_nominal <= hSatOut_nominal) then
    UA2_nominal = UAEnt_nominal * cp2_nominal;
  else
    Modelica.Utilities.Streams.print("Warning: There is no condensation in cooling coil at nominal conditions."
            + "\n         hAppDP_nominal  = " + realString(hAppDP_nominal)
            + "\n         hSatOut_nominal = " + realString(hSatOut_nominal));
    UA2_nominal = -Modelica.Math.log(byPas_nominal) * C2_flow_nominal;
  end if;
  // Relation for enthalpy-based UA value
  1/UAEnt_nominal=cpSat_nominal/UA1_nominal+cp2_nominal/UA2_nominal;
  // Nominal UA value that will be used in the dry coil computation
  UA_nominal = 1/(1/UA1_nominal+1/UA2_nominal);
  // Nominal NTU value (not used in any computation)
  NTU_nominal = UA_nominal/CMin_flow_nominal;
  assert(UAEnt_nominal > 0, "Obtained a negative value for UAEnt_nominal."
    + "\n   Obtained UA1_nominal   = " + realString(UA1_nominal)
    + "\n   Obtained UA2_nominal   = " + realString(UA2_nominal)
    + "\n   Obtained UA_nominal    = " + realString(UA_nominal)
    + "\n   Obtained UAEnt_nominal = " + realString(UAEnt_nominal)
    + "\n   CMin_flow_nominal      = " + realString(CMin_flow_nominal)
    + "\n   CMax_flow_nominal      = " + realString(CMax_flow_nominal)
    + "\n   Q_flow_nominal         = " + realString(Q_flow_nominal)
    + "\n   QMax_flow_nominal      = " + realString(QMax_flow_nominal)
    + "\n   Check model for realistic parameters.");
  assert(UA1_nominal > 0, "Obtained a negative value for UA1_nominal."
    + "\n   Obtained UA1_nominal   = " + realString(UA1_nominal)
    + "\n   Obtained UA2_nominal   = " + realString(UA2_nominal)
    + "\n   Obtained UA_nominal    = " + realString(UA_nominal)
    + "\n   Obtained UAEnt_nominal = " + realString(UAEnt_nominal)
    + "\n   CMin_flow_nominal      = " + realString(CMin_flow_nominal)
    + "\n   CMax_flow_nominal      = " + realString(CMax_flow_nominal)
    + "\n   Q_flow_nominal         = " + realString(Q_flow_nominal)
    + "\n   QMax_flow_nominal      = " + realString(QMax_flow_nominal)
    + "\n   Check model for realistic parameters.");
  assert(UA2_nominal > 0, "Obtained a negative value for UA2_nominal."
    + "\n   Obtained UA1_nominal   = " + realString(UA1_nominal)
    + "\n   Obtained UA2_nominal   = " + realString(UA2_nominal)
    + "\n   Obtained UA_nominal    = " + realString(UA_nominal)
    + "\n   Obtained UAEnt_nominal = " + realString(UAEnt_nominal)
    + "\n   CMin_flow_nominal      = " + realString(CMin_flow_nominal)
    + "\n   CMax_flow_nominal      = " + realString(CMax_flow_nominal)
    + "\n   Q_flow_nominal         = " + realString(Q_flow_nominal)
    + "\n   QMax_flow_nominal      = " + realString(QMax_flow_nominal)
    + "\n   Check model for realistic parameters.");
  /////////////////////////////////////////////////////////////////////////////////////////////
equation
  // Assign the flow regime for the given heat exchanger configuration and capacity flow rates
  if ( configuration == con.ParallelFlow) then
    flowRegime = if ( C1_flow * C2_flow >= 0) then
       flo.ParallelFlow else flo.CounterFlow;
  elseif ( configuration == con.CounterFlow) then
    flowRegime = if ( C1_flow * C2_flow > 0) then
       flo.CounterFlow else flo.ParallelFlow;
  elseif ( configuration == con.CrossFlowUnmixed) then
      flowRegime = flo.CrossFlowUnmixed;
  elseif ( configuration == con.CrossFlowStream1MixedStream2Unmixed) then
    flowRegime = if ( C1_flow < C2_flow) then
        flo.CrossFlowCMinMixedCMaxUnmixed else
        flo.CrossFlowCMinUnmixedCMaxMixed;
  else // have ( configuration == con.CrossFlowStream1UnmixedStream2Mixed)
    flowRegime = if ( C1_flow < C2_flow) then
        flo.CrossFlowCMinUnmixedCMaxMixed else
        flo.CrossFlowCMinMixedCMaxUnmixed;
  end if;

  // Effectiveness of dry coil.
  (eps, NTU, Z) =  BaseClasses.epsilon_C(UA=UA_nominal, C1_flow=C1_flow, C2_flow=C2_flow,
                        flowRegime=flowRegime,
                        CMin_flow_nominal=CMin_flow_nominal, CMax_flow_nominal=CMax_flow_nominal,
                        delta=delta);

  // Effectiveness of completely wet coil.
  // The arguments are all multiplied with cp2_nominal to satisfy the unit check
  cpSat = Buildings.Fluid.HeatExchangers.BaseClasses.cpSat(T1=T_in1, XW2=X_in2);
  // gai{1,2} is zero around zero flow. This improves the numerical robustness.
  (epsWet, NTUWet, ZWet) =  BaseClasses.epsilon_C(UA=UAEnt_nominal*cp2_nominal,
                        C1_flow=smooth(1, gai1 * abs(m1_flow))*cp1_nominal/cpSat*cp2_nominal,
                        C2_flow=smooth(1, gai2 * abs(m2_flow))*cp2_nominal,
                        flowRegime=flowRegime,
                        CMin_flow_nominal=CWetMin_flow_nominal*cp2_nominal,
                        CMax_flow_nominal=CWetMax_flow_nominal*cp2_nominal,
                        delta=delta);
  // Maximum wet heat transfer, needed to compute condensate temperature.
  // The maximum heat flow rate assumes air reaches saturation at temperature of water inlet
  XSat_in1 = Medium2.Xsaturation(Medium2.setState_pTX(p=101325, T=T_in1, X=Medium2.X_default)); // X is ignored by this function
  hSat_in1 = Medium2.h_pTX(101325, T_in1, {XSat_in1, 1-XSat_in1});
  h_in2    = Modelica.Fluid.Utilities.regStep(m2_flow, Medium2.specificEnthalpy(state_a2_inflow),
                                                       Medium2.specificEnthalpy(state_b2_inflow),
                                              m2_flow_small);
  h_out2   = Modelica.Fluid.Utilities.regStep(m2_flow, Medium2.specificEnthalpy(state_b2_inflow),
                                                       Medium2.specificEnthalpy(state_a2_inflow),
                                              m2_flow_small);
  cp_in2   = Modelica.Fluid.Utilities.regStep(m2_flow, Medium2.specificHeatCapacityCp(state_a2_inflow),
                                                       Medium2.specificHeatCapacityCp(state_b2_inflow),
                                              m2_flow_small);
  CWet1_flow   = m1_flow*cp1_nominal/cpSat_nominal;
  CWetMin_flow = Buildings.Utilities.Math.Functions.smoothMin(CWet1_flow, m2_flow, delta*(CWet1_flow+m2_flow));
  QWetMax_flow =CWetMin_flow * (h_in2-hSat_in1);
  // Dewpoint temperature of air inlet
  X_in2   = Modelica.Fluid.Utilities.regStep(m2_flow, state_a2_inflow.X[1], state_b2_inflow.X[1], m2_flow_small);
  Tdp_in2 = psy.Tdp_pW(psy.pW_X(X_in2, 101325));
  if (Tdp_in2 < T_in1) then
    state_fixme = 0;
    // **** Branch if no condensation is possible
    Q1_flow = eps * QMax_flow;
    mXi2_flow    = zeros(Medium2.nXi);
    hCon_out2    = 0;      // dummy value
    TCon_out2    = 293.15; // dummy value
    XConSat_out2 = 0.01; // dummy value
    T_out2       = 293.15;   // dummy value
    epsTCon      = 0;
    // Assign variables that are used in the branch of the wet coil
    QSen2_flow = -Q1_flow;
    QLat2_flow = 0;
    X_out2     = X_in2;
    dX2 = 0;
  else
    // **** Branch if condensation is possible.
    //      Compute completely wet coil.
    // Compute condensation temperature
    epsTCon = Buildings.Fluid.HeatExchangers.BaseClasses.epsilonCondensate_WetCoil(
                m_flow=m2_flow, c_p=cp_in2, hA=UA2_nominal);
    // If epsTCon is very small, then hCon_out2 can be below the saturation enthalpy
    // that corresponds to the water inlet temperature.
    // Therefore, we restrict hCon_out2 >= hSat_in1
    hCon_out2 = Buildings.Utilities.Math.Functions.smoothMax(
        hSat_in1,
        h_in2 - (h_in2-h_out2)/epsTCon,
        500);
    XConSat_out2 = Medium2.Xsaturation(Medium2.setState_phX(p=101325, h=hCon_out2, X={X_in2, 1-X_in2}));
    TCon_out2 = Medium2.T_phX(101325, hCon_out2, {XConSat_out2, 1-XConSat_out2});
    if ( XConSat_out2 < X_in2) then
//    if ( TCon_out2 < Tdp_in2) then // fixme: This is probably wrong.
                                   // fixme: Shouldn't we check for XCon_out2 ??
      state_fixme = 1;
      // **** Branch if condensation occurs.
      Q1_flow = epsWet * QMax_flow;
      // air outlet temperature
      T_out2 = T_in2 - (T_in2 - TCon_out2) * epsTCon;
      // heat input into medium 2
      QSen2_flow = m2_flow * cp_in2 * (T_out2-T_in2); // negative for cooling of stream 2
      Q1_flow = -QSen2_flow-QLat2_flow;
      QLat2_flow =  m2_flow * (Medium2.enthalpyOfCondensingGas(T_out2) * X_out2-
          Medium2.enthalpyOfCondensingGas(T_in2)  * X_in2);
      // increase in humidity
      dX2 = X_out2-X_in2;
      assert(dX2 <= 0, "Model error. dX2 = " + realString(dX2));
      mXi2_flow = abs(m2_flow) * {dX2};  // species balance
    else
      state_fixme = 2;
      // **** Branch if no condensation occurs.  Use dry coil results.
      Q1_flow = eps * QMax_flow;
      QSen2_flow = -Q1_flow;
      QLat2_flow = 0;
      X_out2 = X_in2;
      dX2 = 0;
      mXi2_flow = zeros(Medium2.nXi);
      T_out2 = 293.15; // dummy variable
    end if;
  end if;
  Q1_flow * SHR = -QSen2_flow;
  // no heat loss to ambient
  0 = Q1_flow + Q2_flow;
  // no mass exchange in medium 1
  mXi1_flow = zeros(Medium1.nXi);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-70,78},{70,-82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,65},{103,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
          preferedView="info",
Documentation(info="<html>
<p>
FIXME:

Model of a heat exchanger with humidity condensation. 
This model transfers heat using the epsilon-NTU relation.
If there is no condensation, then the transfered heat is
identical to the one computed in the model
<a href=\"\\modelica://Buildings.Fluid.HeatExchangers.DryEffectivenessNTU\">
DryEffectivenessNTU</a>.
</p>
<p>
When parameterizing this model, make sure that the line in the psychrometric chart
that goes through the air inlet and air outlet state intersects the saturation line.
If this is not the case, then the apparatus dewpoint temperature is not defined, and
the simulation will abort with an error message.
</p>
<p>
The model computes the saturation temperature that corresponds to the
water inlet temperature, and compares this temperature to the dew point
temperature of the air inlet. If the dewpoint temperature is below the
saturation temperature, then condensation occurs.
In this situation, the enthalpy is used to compute the total heat transfer
in the epsilon-NTU relation. The potential difference
that determines the sum of sensible and latent heat transfer
are the saturation enthalpy and air inlet enthalpy.
The capacity flow rates are the air mass flow rate and the 
water mass flow rate times the ratio between the water specific heat capacity
and a fictitious specific heat capacity
along the saturation line, <code>cpSat</code>.
After computing the total rate of heat transfer for the wet coil
<code>QWet_flow</code>, the sensible heat transfer is determined as
<code>QSen2_flow = |m2_flow| *cp_in2 * (T_out2-T_in2)</code>,
from which follows that the latent heat transfer is
<code>QLat2_flow = Q2_flow - QSen2_flow</code>.
</p>
<p>
FIXME: Describe partial wet coil.
</p>
<p>
The heat exchanger  can have any 
<code>flowRegime</code>,
such as
parallel flow, cross flow or counter flow.
</p>
<p>
The flow regimes depend on the heat exchanger configuration. All configurations
defined in
<a href=\"modelica://Buildings.Fluid.Types.HeatExchangerConfiguration\">
Buildings.Fluid.Types.HeatExchangerConfiguration</a>
are supported.
</p>
<p>
By definition, <code>Q_flow</code> is positive if heat is transfered into medium 1.
Since in a cooling coil, medium 1 is water and medium 2 is air, we have <code>Q_flow &gt; 0</code>.
</p>
FIXME: Check apparatus dew point temperature at nominal condition.
<p>
For a heat exchanger without humidity condensation, use
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.DryEffectivenessNTU</a>,
instead of this model.
<p>
For a heat and moisture exchanger, use
<a href=\"modelica://Buildings.Fluid.MassExchangers.ConstantEffectiveness\">
Buildings.Fluid.MassExchangers.ConstantEffectiveness</a>
instead of this model.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 12, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics));
end WetEffectivenessNTU;
