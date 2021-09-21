within Buildings.Fluid.MixingVolumes;
model MixingVolumeEvaporation_rev
  "Mixing volume for water evaporation at equilibrium(conbining the conservation equation Evaporation)"


  // Package medium declaration
  replaceable package MediumWat = Buildings.Media.Water
    "Water medium - port_a(inlet)";
  replaceable package MediumSte = Buildings.Media.Steam
     "Steam medium - port_b(oulet)";


  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium_rev(
    redeclare final package Medium_a=MediumWat,
    redeclare final package Medium_b=MediumSte,
    p_start=1000000,
    T_start=453.15);


  // Inputs
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort(
    T(start=T_start)) if not steadyDynamics "Heat port"
  annotation (Placement(transformation(extent={{-10,-90},{10,-110}})));

  //Outputs
  Modelica.Blocks.Interfaces.RealOutput VLiq(unit="m3") "Liquid volume"
  annotation (Placement(transformation(
        origin={110,70},
        extent={{-10,-10},{10,10}},
        rotation=0), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,70})));

  parameter Modelica.SIunits.Volume V "Total volume";

// Initialization
  final parameter Modelica.SIunits.SpecificEnthalpy hSteStart=
    MediumSte.specificEnthalpy_pTX(p_start, T_start, MediumSte.X_default)
    "Start value for specific enthalpy";
  parameter Modelica.SIunits.Volume VWat_start=V/2
    "Start value of liquid volumeStart value of volume"
    annotation (Dialog(tab="Initialization"));

// Set nominal attributes where literal values can be used.
  MediumWat.ThermodynamicState state_saturated
    "State vector for saturated conditions";
  MediumSte.AbsolutePressure p(
    start=p_start,
    stateSelect=if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState
    then StateSelect.default else StateSelect.prefer)
    "Pressure inside volume";
  MediumSte.Temperature T(start=T_start) "Temperature inside volume";
  Modelica.SIunits.Volume VSte(start=VWat_start) "Volume of vapor phase";
  Modelica.SIunits.Volume VWat(
    start=VWat_start,
    stateSelect=if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState
    then StateSelect.default else StateSelect.prefer)
    "Volume of liquid phase";

  MediumSte.SpecificEnthalpy hSte "Specific enthalpy of steam vapor";
  MediumWat.SpecificEnthalpy hWat "Specific enthalpy of water liquid";
  MediumSte.Density rhoSte "Density of steam vapor";
  MediumWat.Density rhoWat "Density of liquid water";
  Modelica.SIunits.Mass m "Total mass of volume";

  //  (start=VWat_start*(rhoWat_start+rhoSte_start))

  Modelica.SIunits.Energy U(start=U_start) "Internal energy";
  Modelica.SIunits.MassFlowRate mWat_flow "Feed water mass flow rate";
  Modelica.SIunits.MassFlowRate mSte_flow "Steam mass flow rate";


  final parameter MediumWat.ThermodynamicState state_start = MediumWat.setState_pTX(
      T=T_start,
      p=p_start,
      X=MediumWat.X_default) "Medium state at default values";
  final parameter Modelica.SIunits.Density rhoWat_start=MediumWat.density(
    state=state_start) "Density, used to compute fluid mass";
  final parameter Modelica.SIunits.Density rhoSte_start=MediumSte.density(
    state=state_start) "Density, used to compute fluid mass";
  final parameter Modelica.SIunits.Energy U_start=
    VWat_start*(rhoWat_start*MediumWat.specificEnthalpy(state_start) +
    rhoSte_start*MediumSte.specificEnthalpy(state_start)) -
    p_start*VWat_start*2
    "Starting internal energy";


//  Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W") if not steadyDynamics
//    "Sensible plus latent heat flow rate transferred into the medium"
//    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));


protected
  final parameter Boolean steadyDynamics=
    if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then true
      else false
    "= true, if steady state formulation";

  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem if not steadyDynamics
    "Port temperature"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.RealExpression portT(y=T) if  not steadyDynamics
    "Port temperature"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen if not steadyDynamics
    "Heat flow sensor"
    annotation (Placement(transformation(extent={{-10,-40},{-30,-60}})));

  Modelica.Blocks.Interfaces.RealInput Q_flow_internal
    "Needed to use conditional connector Q_flow";

initial equation
  // Make sure that if energyDynamics is SteadyState, then
  // massDynamics is also SteadyState.
  // Otherwise, the system of ordinary differential equations may be inconsistent.
  if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    assert(massDynamics == energyDynamics, "In " + getInstanceName() + ":
         If 'energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState', then it is
         required that 'massDynamics==Modelica.Fluid.Types.Dynamics.SteadyState'.
         Otherwise, the system of equations may not be consistent.
         You need to select other parameter values.");
  end if;

// Initial conditions
  if energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
    // No intial condition is given here to avoid overspecification in models
    // that use this base class.
  //   p = p_start;
  //   T = T_start;
  elseif energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
    //    der(p) = 0;
    der(T) = 0;
  end if;

  if massDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
     VWat = VWat_start;
  elseif massDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
 //   der(VWat) = 0;
    der(p)=0;
  end if;

equation
 // Total quantities
  m = rhoSte*VSte + rhoWat*VWat "Total mass";
  U = rhoSte*VSte*hSte + rhoWat*VWat*hWat - p*V "Total energy";
  V = VWat + VSte "Total volume";

  // Mass balance
  if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    0 = mWat_flow + mSte_flow "Steady state mass balance";
  else
    der(m) = mWat_flow + mSte_flow "Dynamic mass balance";
  end if;


  // Energy balance
  connect(heaFloSen.Q_flow, Q_flow_internal) "Needed because of conditional input";
  if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    U = U_start;
    Q_flow_internal = 0;
  else
    der(U) = Q_flow_internal
            + port_a.m_flow*actualStream(port_a.h_outflow)
            + port_b.m_flow*actualStream(port_b.h_outflow)
      "Dynamic energy balance";
  end if;


// Properties of saturated liquid and steam
  state_saturated.p = p;
  state_saturated.T = T;
  T = MediumSte.saturationTemperature(p);
  hSte=MediumSte.specificEnthalpy(state_saturated);
  hWat=MediumWat.specificEnthalpy(state_saturated);
  rhoSte=MediumSte.density(state_saturated);
  rhoWat=MediumWat.density(state_saturated);

// boundary conditions at the ports
  port_a.p = p;
  port_a.m_flow = mWat_flow;
  port_a.h_outflow = hWat;
  port_b.p = p;
  port_b.m_flow = mSte_flow;
  port_b.h_outflow = hSte;

  // outputs
  VLiq = VWat;
 // hOut = hSte;
 // UOut = U;
 // mOut = m;

// Check that evaporation is actually possible
  assert(VSte >= 0, "There is no more steam vapor in the volume.");
  assert(VWat >= 0, "There is no more liquid water in the volume.");



    connect(portT.y,preTem. T)
      annotation (Line(points={{-69,-50},{-62,-50}},color={0,0,127}));
    connect(heaFloSen.port_b,preTem. port)
      annotation (Line(points={{-30,-50},{-40,-50}},color={191,0,0}));
    connect(heaFloSen.port_a, heatPort)
      annotation (Line(points={{-10,-50},{0,-50},{0,-100}}, color={191,0,0}));

annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-152,102},{148,142}},
          textString="%name",
          lineColor={0,0,255}),
       Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor=DynamicSelect({170,213,255}, min(1, max(0, (1-(T-273.15)/50)))*{28,108,200}+min(1, max(0, (T-273.15)/50))*{255,0,0})),
      Line(
        points={{0,40},{-40,20},{0,-20},{-40,-40}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
      Line(
        points={{40,40},{0,20},{40,-20},{0,-40}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}})}),
    Documentation(revisions="<html>
<ul>
<li>
July 22, 2021 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Mixing volume with water phase change.
</p>
</html>"));
end MixingVolumeEvaporation_rev;
