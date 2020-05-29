within Buildings.Fluid.Boilers.BaseClasses;
partial model PartialSteamBoiler
  "Partial model for a steam boiler with a polynomial efficiency curve and 
  phase change between the working fluid's ports"

  replaceable package Medium_a =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model (liquid state) for port_a (inlet)";
  replaceable package Medium_b =
      IBPSA.Media.Interfaces.PartialPureSubstanceWithSat
    "Medium model (vapor state) for port_b (outlet)";

  // Advanced
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  // Dynamics
  parameter Modelica.SIunits.Time tau = 30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Diagnostics
   parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

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
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Power Q_flow_nominal
    "Nominal heating power"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.AbsolutePressure pOut_nominal
    "Nominal pressure of boiler"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature TOut_nominal = Medium_b.saturationTemperature_p(pOut_nominal)
    "Nominal temperature leaving the boiler";

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
  Modelica.SIunits.MassFlowRate mFue_flow = QFue_flow/fue.h
    "Fuel mass flow rate";
  Modelica.SIunits.VolumeFlowRate VFue_flow = mFue_flow/fue.d
    "Fuel volume flow rate";

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) "Part load ratio"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-120,80},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput T(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Temperature of fluid in boiler volume"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
        iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W",
    displayUnit="kW") "Total heat transfer rate of boiler"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port, can be used to connect to ambient"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

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
    nPorts=2)  "Volume for fluid stream"
     annotation (Placement(transformation(extent={{19,0},{39,-20}})));

  Evaporation eva(
    redeclare package Medium_a = Medium_a,
    redeclare package Medium_b = Medium_b,
    final show_T=show_T)  "Evaporation process"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Movers.FlowControlled_dp dpCon(
    redeclare package Medium = Medium_a,
    m_flow_nominal=m_flow_nominal,
    final show_T=show_T,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    constantHead=pOut_nominal)
    "Flow controller with specifiied pressure change between ports"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapDry(
    C=500*mDry,
    T(start=T_start)) if not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "heat capacity of boiler metal"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  // States and properties
protected
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
  parameter Real eta_nominal(fixed=false, start=0.9) "Boiler efficiency at nominal condition";
  parameter Real aQuaLin[6] = if size(a, 1) == 6 then a else fill(0, 6)
  "Auxiliary variable for efficiency curve because quadraticLinear requires exactly 6 elements";

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed (sensible) heat flow into fluid volume"
    annotation (Placement(transformation(extent={{-11,-46},{9,-26}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSenVol
    "Temperature of fluid volume"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Modelica.Blocks.Math.Gain cp(k=cp_default) "Specific heat"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor UAOve(G=UA)
    "Overall thermal conductance (if heatPort is connected)"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Modelica.Blocks.Math.Product QSen_flow_mea
    "Measured sensible heat transfer rate"
    annotation (Placement(transformation(extent={{-40,-46},{-20,-26}})));
  Modelica.Blocks.Math.Add dTSen(k1=-1)
    "Change in temperature between inflowing and outflowing fluids"
    annotation (Placement(transformation(extent={{40,-60},{20,-40}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_out(y=QWatTot_flow)
    "Total heat transfer rate"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium_a)
    "Measured mass flow rate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Sensors.Pressure senPre(redeclare package Medium = Medium_a)
    "Measured absolute pressure of inflowing fluid"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Math.Add dpSen(k2=-1)
    "Change in pressure needed to meet setpoint"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  Modelica.Blocks.Sources.RealExpression pOutSet(y=pOut_nominal)
    "Pressure setpoint for outgoing fluid"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Sensors.TemperatureTwoPort temSen_in(redeclare package Medium = Medium_a,
      m_flow_nominal=m_flow_nominal) "Inflowing temperature sensor"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Sensors.TemperatureTwoPort temSen_out(redeclare package Medium = Medium_b,
      m_flow_nominal=m_flow_nominal) "Outflowing temperature sensor"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

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

  connect(UAOve.port_b, vol.heatPort)
    annotation (Line(
      points={{0,60},{16,60},{16,-10},{19,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(UAOve.port_a, heatPort)
    annotation (Line(
      points={{-20,60},{-26,60},{-26,80},{0,80},{0,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCapDry.port, vol.heatPort)
    annotation (Line(
      points={{30,70},{30,60},{16,60},{16,-10},{19,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSenVol.T, T)
    annotation (Line(
      points={{70,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFlo.port, vol.heatPort)
    annotation (Line(
      points={{9,-36},{16,-36},{16,-10},{19,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort, temSenVol.port)
    annotation (Line(
      points={{19,-10},{16,-10},{16,60},{50,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dpCon.port_b, vol.ports[1])
    annotation (Line(points={{10,0},{27,0}},  color={0,127,255}));
  connect(vol.ports[2], eva.port_a)
    annotation (Line(points={{31,0},{40,0}}, color={0,127,255}));
  connect(Q_flow_out.y, Q_flow)
    annotation (Line(points={{81,90},{110,90}}, color={0,0,127}));
  connect(heatPort, heatPort)
    annotation (Line(points={{0,100},{0,100}}, color={191,0,0}));
  connect(eva.port_b, temSen_out.port_a)
    annotation (Line(points={{60,0},{70,0}}, color={0,127,255}));
  connect(QSen_flow_mea.y, preHeaFlo.Q_flow)
    annotation (Line(points={{-19,-36},{-11,-36}}, color={0,0,127}));
  connect(temSen_out.T, dTSen.u2)
    annotation (Line(points={{80,11},{80,18},{66,18},{66,-56},{42,-56}},
        color={0,0,127}));
  connect(senMasFlo.m_flow, cp.u)
    annotation (Line(points={{-70,11},{-70,20},{-86,20},{-86,-30},{-82,-30}},
        color={0,0,127}));
  connect(cp.y, QSen_flow_mea.u1)
    annotation (Line(points={{-59,-30},{-42,-30}}, color={0,0,127}));
  connect(dTSen.y, QSen_flow_mea.u2)
    annotation (Line(points={{19,-50},{-50,-50},{-50,-42},{-42,-42}},
        color={0,0,127}));
  connect(pOutSet.y, dpSen.u1)
    annotation (Line(points={{-39,40},{-36,40},{-36,36},{-32,36}},
        color={0,0,127}));
  connect(senPre.p, dpSen.u2)
    annotation (Line(points={{-39,20},{-36,20},{-36,24},{-32,24}},
        color={0,0,127}));
  connect(senPre.port, senMasFlo.port_b)
    annotation (Line(points={{-50,10},{-50,0},{-60,0}}, color={0,127,255}));
  connect(dpSen.y, dpCon.dp_in)
    annotation (Line(points={{-9,30},{0,30},{0,12}}, color={0,0,127}));
  connect(senMasFlo.port_b, temSen_in.port_a)
    annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(temSen_in.port_b, dpCon.port_a)
    annotation (Line(points={{-20,0},{-10,0}}, color={0,127,255}));
  connect(temSen_in.T, dTSen.u1)
    annotation (Line(points={{-30,11},{-30,18},{64,18},{64,-44},{42,-44}},
        color={0,0,127}));


  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-138,138},{-102,108}},
          lineColor={0,0,127},
          textString="y"),
        Text(
          extent={{100,48},{138,18}},
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
          extent={{82,134},{218,106}},
          lineColor={0,0,127},
          textString="Q_flow")}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})));
end PartialSteamBoiler;
