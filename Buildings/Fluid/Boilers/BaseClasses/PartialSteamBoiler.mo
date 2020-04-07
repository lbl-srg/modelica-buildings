within Buildings.Fluid.Boilers.BaseClasses;
model PartialSteamBoiler
  "Partial model for a steam boiler with a polynomial efficiency curve and phase change between the ports"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium;
//  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
//    port_a(h_outflow(start=h_outflow_start)),
//    port_b(h_outflow(start=h_outflow_start)));
//  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
//    final computeFlowResistance=true);

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

  replaceable Buildings.Fluid.MixingVolumes.MixingVolume vol(nPorts=2)
  constrainedby Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume(
    redeclare final package Medium = Medium_a,
    nPorts = 2,
    V=m_flow_nominal*tau/rho_default,
    final allowFlowReversal=false,
    final mSenFac=1,
    final m_flow_nominal = m_flow_nominal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start) "Volume for fluid stream"
     annotation (Placement(transformation(extent={{-21,0},{-1,-20}})));

  Evaporation eva(m_flow_nominal=m_flow_nominal)
                  "Evaporation process"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Movers.FlowControlled_dp dpCon
    "Flow controller with specifiied pressure change between ports"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
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

initial algorithm
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


equation
  connect(port_a, vol.ports[1])
    annotation (Line(points={{-100,0},{-13,0}}, color={0,127,255}));
  connect(vol.ports[2], dpCon.port_a)
    annotation (Line(points={{-9,0},{20,0}}, color={0,127,255}));
  connect(dpCon.port_b, eva.port_a)
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(eva.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialSteamBoiler;
