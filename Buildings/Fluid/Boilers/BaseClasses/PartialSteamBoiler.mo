within Buildings.Fluid.Boilers.BaseClasses;
partial model PartialSteamBoiler
  "Partial model for a steam boiler with a polynomial efficiency curve and phase change between the ports"
//  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium;
//  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
//    port_a(h_outflow(start=h_outflow_start)),
//    port_b(h_outflow(start=h_outflow_start)));
//  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
//    final computeFlowResistance=true);

  replaceable package Medium_a =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium model for port_a (inlet)";
  replaceable package Medium_b =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium model for port_b (outlet)";

  parameter Modelica.SIunits.Time tau = 30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));

  // Advanced
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Initialization
  parameter Medium_a.AbsolutePressure p_start = Medium_a.p_default
    "Start value of inflow pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium_a.Temperature T_start = Medium_a.T_default
    "Start value of inflow temperature"
    annotation(Dialog(tab = "Initialization"));

  parameter Medium_a.MassFraction X_start[Medium_a.nX](
    final quantity=Medium_a.substanceNames) = Medium_a.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium_a.nXi > 0));
  parameter Medium_a.ExtraProperty C_start[Medium_a.nC](
    final quantity=Medium_a.extraPropertiesNames)=fill(0, Medium_a.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium_a.nC > 0));

  // Nominal Conditions
//  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
//    "Nominal mass flow rate"
//    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.Power Q_flow_nominal
    "Nominal heating power"
    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.AbsolutePressure pOut_nominal
    "Nominal pressure of boiler"
    annotation(Dialog(group = "Nominal condition"));


  parameter Modelica.SIunits.Temperature TIn_nominal
    "Nominal temperature of inflowing water"
    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=Q_flow_nominal/dh_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
    //Q_flow_nominal / dh_nominal
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow";

  parameter Modelica.SIunits.Temperature TOut_nominal = Medium_b.saturationTemperature(pOut_nominal)
    "Nominal temperature leaving the boiler";

  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    cp_default*(TOut_nominal - TIn_nominal) +
    Medium_b.dewEnthalpy(Medium_b.setSat_p(pOut_nominal)) -
    Medium_b.bubbleEnthalpy(Medium_b.setSat_p(pOut_nominal))
   "Nominal change in enthalpy of boiler";

  // Assumptions
  parameter Buildings.Fluid.Types.EfficiencyCurves effCur=Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear
    "Curve used to compute the efficiency";
  parameter Real a[:] = {0.9} "Coefficients for efficiency curve";

  parameter Buildings.Fluid.Data.Fuels.Generic fue "Fuel type"
   annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.ThermalConductance UA=0.05*Q_flow_nominal/30
    "Overall UA value";
  parameter Modelica.SIunits.Volume VWat = 1.5E-6*Q_flow_nominal
    "Water volume of boiler"
    annotation(Dialog(tab = "Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Mass mDry =   1.5E-3*Q_flow_nominal
    "Mass of boiler that will be lumped to water heat capacity"
    annotation(Dialog(tab = "Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));

  Modelica.SIunits.Efficiency eta=
    if effCur ==Buildings.Fluid.Types.EfficiencyCurves.Constant then
      a[1]
    elseif effCur ==Buildings.Fluid.Types.EfficiencyCurves.Polynomial then
      Buildings.Utilities.Math.Functions.polynomial(a=a, x=y)
   elseif effCur ==Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear then
      Buildings.Utilities.Math.Functions.quadraticLinear(a=aQuaLin, x1=y, x2=T)
   else
      0
  "Boiler efficiency";
  Modelica.SIunits.Power QFue_flow = y * Q_flow_nominal/eta_nominal
    "Heat released by fuel";
  Modelica.SIunits.Power QWatTot_flow = eta * QFue_flow
    "Heat transfer from gas into water";
//  Modelica.SIunits.Power QWatSen_flow = 0
//    "Sensible heat transfer";
//  Modelica.SIunits.Power QWatLat_flow = 0
//    "Latent heat transfer";
  Modelica.SIunits.MassFlowRate mFue_flow = QFue_flow/fue.h
    "Fuel mass flow rate";
  Modelica.SIunits.VolumeFlowRate VFue_flow = mFue_flow/fue.d
    "Fuel volume flow rate";

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare final package Medium = Medium_a,
    V=m_flow_nominal*tau/rho_default,
    final allowFlowReversal=false,
    final mSenFac=1,
    final m_flow_nominal = m_flow_nominal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    nPorts=2)              "Volume for fluid stream"
     annotation (Placement(transformation(extent={{11,0},{31,-20}})));

  Evaporation eva(
    redeclare package Medium_a = Medium_a,
    redeclare package Medium_b = Medium_b,
    show_T=true)  "Evaporation process"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Movers.FlowControlled_dp dpCon(
    redeclare package Medium = Medium_a,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    constantHead=pOut_nominal)
    "Flow controller with specifiied pressure change between ports"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) "Part load ratio"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-120,100},{-100,120}})));

  Modelica.Blocks.Interfaces.RealOutput T(final quantity="ThermodynamicTemperature",
                                          final unit = "K", displayUnit = "degC", min=0)
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port, can be used to connect to ambient"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapDry(
    C=500*mDry,
    T(start=T_start)) if not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "heat capacity of boiler metal"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W",
    displayUnit="kW") "Total heat transfer rate of boiler" annotation (
      Placement(transformation(extent={{100,100},{120,120}}),iconTransformation(
          extent={{100,100},{120,120}})));
  Sensors.TemperatureTwoPort temSen_out(redeclare package Medium = Medium_b,
      m_flow_nominal=m_flow_nominal) "Outflowing temperature sensor"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));




  // States and properties
//protected
  parameter Medium_a.ThermodynamicState sta_a_default=Medium_a.setState_pTX(
      T=Medium_a.T_default, p=Medium_a.p_default, X=Medium_a.X_default);
  parameter Medium_b.ThermodynamicState sta_b_default=Medium_b.setState_pTX(
      T=Medium_b.T_default, p=Medium_b.p_default, X=Medium_b.X_default);
  parameter Modelica.SIunits.Density rho_default=Medium_a.density(sta_a_default)
    "Density, used to compute fluid volume";
  parameter Medium_a.ThermodynamicState sta_a_start=Medium_a.setState_pTX(
      T=T_start, p=p_start, X=X_start);
  parameter Medium_b.ThermodynamicState sta_b_start=Medium_b.setState_pTX(
      T=T_start, p=p_start, X=X_start);
  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_start = Medium_b.specificEnthalpy(sta_b_start)
    "Start value for outflowing enthalpy";
  parameter Modelica.SIunits.SpecificHeatCapacityAtConstantPressure cp_default=
    Medium_a.specificHeatCapacityCp(sta_a_default)
    "Default value for specific heat";

  // Boiler
  parameter Real eta_nominal(fixed=false) "Boiler efficiency at nominal condition";
  parameter Real aQuaLin[6] = if size(a, 1) == 6 then a else fill(0, 6)
  "Auxiliary variable for efficiency curve because quadraticLinear requires exactly 6 elements";

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(extent={{-21,-50},{-1,-30}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSenVol
    "Temperature of fluid volume"
    annotation (Placement(transformation(extent={{50,70},{70,90}})));
  Modelica.Blocks.Math.Gain cp(k=cp_default) "Specific heat"
    annotation (Placement(transformation(extent={{-80,-56},{-60,-36}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor UAOve(G=UA)
    "Overall thermal conductance (if heatPort is connected)"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Modelica.Blocks.Math.Product QSen_flow_mea
    "Measured sensible heat transfer rate"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Modelica.Blocks.Math.Add dTSen(k1=-1)
    "Change in temperature between volume and outflowing port"
    annotation (Placement(transformation(extent={{60,20},{40,40}})));

  Modelica.Blocks.Sources.RealExpression Q_flow_out(y=QWatTot_flow)
    "Total heat transfer rate"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Movers.FlowControlled_m_flow mCon_flow(
    redeclare package Medium = Medium_a,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true) "Mass flow controller"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Math.Gain mSet_flow(k=m_flow_nominal) "Set mass flow rate"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));


initial equation


  // Energy and mass balance
  assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau > Modelica.Constants.eps,
"The parameter tau, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau = " + String(tau) + "\n");
  assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau > Modelica.Constants.eps,
"The parameter tau, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau = " + String(tau) + "\n");

  // Boiler efficiency
  if  effCur == Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear then
    assert(size(a, 1) == 6,
    "The boiler has the efficiency curve set to 'Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear',
    and hence the parameter 'a' must have exactly 6 elements.
    However, only " + String(size(a, 1)) + " elements were provided.");
  end if;

  if effCur ==Buildings.Fluid.Types.EfficiencyCurves.Constant then
    eta_nominal = a[1];
  elseif effCur ==Buildings.Fluid.Types.EfficiencyCurves.Polynomial then
    eta_nominal = Buildings.Utilities.Math.Functions.polynomial(a=a, x=1);
  elseif effCur ==Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear then
    // For this efficiency curve, a must have 6 elements.
    eta_nominal = Buildings.Utilities.Math.Functions.quadraticLinear(a=aQuaLin, x1=1, x2=TOut_nominal);
  else
     eta_nominal = 999;
  end if;


equation

  assert(eta > 0.001, "Efficiency curve is wrong.");

  connect(UAOve.port_b, vol.heatPort)            annotation (Line(
      points={{0,80},{6,80},{6,-10},{11,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(UAOve.port_a, heatPort) annotation (Line(
      points={{-20,80},{-26,80},{-26,100},{0,100},{0,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCapDry.port, vol.heatPort) annotation (Line(
      points={{30,50},{30,40},{6,40},{6,-10},{11,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSenVol.T, T) annotation (Line(
      points={{70,80},{110,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFlo.port, vol.heatPort) annotation (Line(
      points={{-1,-40},{6,-40},{6,-10},{11,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort, temSenVol.port) annotation (Line(
      points={{11,-10},{6,-10},{6,80},{50,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dpCon.port_b, vol.ports[1])
    annotation (Line(points={{0,0},{19,0}},   color={0,127,255}));
  connect(vol.ports[2], eva.port_a)
    annotation (Line(points={{23,0},{40,0}}, color={0,127,255}));
  connect(Q_flow_out.y, Q_flow)
    annotation (Line(points={{81,110},{110,110}},
                                                color={0,0,127}));
  connect(heatPort, heatPort)
    annotation (Line(points={{0,120},{0,120}}, color={191,0,0}));
  connect(eva.port_b, temSen_out.port_a)
    annotation (Line(points={{60,0},{70,0}}, color={0,127,255}));
  connect(QSen_flow_mea.y, preHeaFlo.Q_flow)
    annotation (Line(points={{-29,-40},{-21,-40}}, color={0,0,127}));
  connect(temSenVol.T, dTSen.u1) annotation (Line(points={{70,80},{80,80},{80,36},
          {62,36}}, color={0,0,127}));
  connect(temSen_out.T, dTSen.u2)
    annotation (Line(points={{80,11},{80,24},{62,24}}, color={0,0,127}));
  connect(mCon_flow.port_b, dpCon.port_a)
    annotation (Line(points={{-30,0},{-20,0}}, color={0,127,255}));
  connect(dTSen.y, QSen_flow_mea.u1) annotation (Line(points={{39,30},{-64,30},{
          -64,-34},{-52,-34}}, color={0,0,127}));
  connect(mSet_flow.y, mCon_flow.m_flow_in)
    annotation (Line(points={{-59,100},{-40,100},{-40,12}}, color={0,0,127}));
  connect(cp.y, QSen_flow_mea.u2)
    annotation (Line(points={{-59,-46},{-52,-46}}, color={0,0,127}));
  connect(mSet_flow.u, y)
    annotation (Line(points={{-82,100},{-120,100}}, color={0,0,127}));
  connect(mSet_flow.y, cp.u) annotation (Line(points={{-59,100},{-40,100},{-40,40},
          {-90,40},{-90,-46},{-82,-46}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},
            {100,120}}),                                        graphics={
        Rectangle(
          extent={{-80,100},{80,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-138,172},{-102,142}},
          lineColor={0,0,127},
          textString="y"),
        Text(
          extent={{102,64},{140,34}},
          lineColor={0,0,127},
          textString="T"),
      Line(
        points={{38,68},{18,58},{38,38},{18,28}},
        color={238,46,47},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
      Line(
        points={{60,68},{40,58},{60,38},{40,28}},
        color={238,46,47},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
        Ellipse(
          extent={{-58,60},{-46,72}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-38,44},{-26,56}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-54,30},{-42,42}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-34,20},{-22,32}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{84,152},{220,124}},
          lineColor={0,0,127},
          textString="Q_flow")}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,120}})));
end PartialSteamBoiler;
