within Buildings.Experimental.DHC.BaseClasses.Steam;
partial model PartialSaturatedControlVolume
  "Partial control volume for evaporation/condensation processes"
  extends Buildings.Experimental.DHC.BaseClasses.Steam.PartialTwoPortTwoMedium(
    redeclare final package Medium_a=MediumWat,
    redeclare final package Medium_b=MediumSte,
    p_start=1000000,
    T_start=453.15);

  // Medium declarations
  replaceable package MediumWat =
    Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Liquid water medium - port_a(inlet)";
  replaceable package MediumSte = Buildings.Media.Steam
     "Steam medium - port_b(oulet)";

  // Input
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort(
    T(start=T_start)) if not steadyDynamics "Heat port"
  annotation (Placement(transformation(extent={{-10,-90},{10,-110}})));
  //Output
  Modelica.Blocks.Interfaces.RealOutput VLiq(unit="m3") "Liquid volume"
  annotation (Placement(transformation(
        origin={110,70},
        extent={{-10,-10},{10,10}},
        rotation=0), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,70})));

  // Parameter
  parameter Modelica.Units.SI.Volume V "Total volume";

// Variables
  MediumWat.ThermodynamicState state_saturated
    "Saturated state";
  MediumSte.AbsolutePressure p(
    start=p_start,
    stateSelect=if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState
    then StateSelect.default else StateSelect.prefer)
    "Pressure inside volume";
  MediumSte.Temperature T(start=T_start) "Temperature inside volume";
  Modelica.Units.SI.Volume VSte(final start=VSte_start) "Volume of steam vapor";
  Modelica.Units.SI.Volume VWat(
    start=VWat_start,
    stateSelect=if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState
    then StateSelect.default else StateSelect.prefer)
    "Volume of liquid water phase";
  MediumSte.SpecificEnthalpy hSte "Specific enthalpy of steam vapor";
  MediumWat.SpecificEnthalpy hWat "Specific enthalpy of liquid water";
  MediumSte.Density rhoSte "Density of steam vapor";
  MediumWat.Density rhoWat "Density of liquid water";
  Modelica.Units.SI.Mass m "Total mass of volume";
  Modelica.Units.SI.Energy U(final start=U_start) "Internal energy";
  Modelica.Units.SI.MassFlowRate mWat_flow "Feed water mass flow rate";
  Modelica.Units.SI.MassFlowRate mSte_flow "Steam mass flow rate";

  // Initialization
  parameter Modelica.Units.SI.Volume VWat_start=V/2
    "Start value of liquid volume"
    annotation (Dialog(tab="Initialization"));
  final parameter Modelica.Units.SI.Volume VSte_start= V-VWat_start
  "Start value of steam vapor volume";
  final parameter MediumWat.ThermodynamicState state_start = MediumWat.setState_pTX(
      T=T_start,
      p=p_start,
      X=MediumWat.X_default) "Medium state at default values";
  final parameter Modelica.Units.SI.Density rhoWat_start=MediumWat.density(
    state=state_start) "Density, used to compute fluid mass";
  final parameter Modelica.Units.SI.Density rhoSte_start=MediumSte.density(
    state=state_start) "Density, used to compute fluid mass";
  final parameter Modelica.Units.SI.SpecificEnthalpy hSteStart=
    MediumSte.specificEnthalpy_pTX(p_start, T_start, MediumSte.X_default)
    "Start value for specific enthalpy";
  final parameter Modelica.Units.SI.Energy U_start=
    VWat_start*rhoWat_start*MediumWat.specificEnthalpy(state_start) +
    VSte_start*rhoSte_start*MediumSte.specificEnthalpy(state_start) -
    p_start*V
    "Starting internal energy";

protected
  final parameter Boolean steadyDynamics=
    if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then true
      else false
    "= true, if steady state formulation";

  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem if not steadyDynamics
    "Prescribed temperature"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.RealExpression portT(y=T)  if not steadyDynamics
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
  elseif energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
    der(T) = 0;
  end if;

  if massDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
     VWat = VWat_start;
  elseif massDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
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
  port_b.p = p;

// outputs
  VLiq = VWat;

// Check that evaporation is actually possible
  assert(VSte >= 0, "There is no more steam vapor in the volume.");
  assert(VWat >= 0, "There is no more liquid water in the volume.");

    connect(portT.y,preTem. T)
      annotation (Line(points={{-69,-50},{-62,-50}},color={0,0,127}));
    connect(heaFloSen.port_b,preTem. port)
      annotation (Line(points={{-30,-50},{-40,-50}},color={191,0,0}));
    connect(heaFloSen.port_a, heatPort)
      annotation (Line(points={{-10,-50},{0,-50},{0,-100}}, color={191,0,0}));

annotation (defaultComponentName="vol",
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
          fillColor=DynamicSelect({170,213,255},
          min(1, max(0, (1-(T-273.15)/50)))*{28,108,200}
          +min(1, max(0, (T-273.15)/50))*{255,0,0})),
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
February 26, 2022 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model represents a partial control volume for either condensation or 
evaporation processes of water with liquid and vapor phases in equilibrium
and at a saturated state. 
Models that extend this base class need to assign the mass flow rate at 
each port and the enthlapy at each port, as exemplifed in the evaporation
and condensation models listed below.
The volume can exchange heat through 
its <code>heatPort</code> when configured with dynamic mass and 
energy balances. In steady state, the heat port is conditionally removed
in order to maintain a consistent set of equations.
</p>
<p>
This model is similar to 
<a href=\"modelica://Modelica.Fluid.Examples.DrumBoiler.BaseClasses.EquilibriumDrumBoiler\">
Modelica.Fluid.Examples.DrumBoiler.BaseClasses.EquilibriumDrumBoiler</a> 
with the following exceptions:
</p>
<ul>
<li>
Rather than a two-phase medium, fluid mediums are modeled as two
single-state fluids, with liquid water at the up-stream port<code>(port_a)</code>, and
steam vapor at the downstream port <code>(port_b)</code> for instances of this 
base class that model evaporation (the opposite for condensation);
</li>
<li>
The metal drum is excluded from the mass and energy balances;
</li>
</ul>

<h4> Implementation</h4>
<p>
This model is configured to allow both steady state and dynamic mass 
and energy balances. The heat transfer through the 
<code>heatPort</code> is disabled in steady state balance.
This is required because the fluid is restricted to a saturated state;
thus, the heat transfer rate is a function of mass flow rate only
if the volume is steady. The fluid mass <i>m</i> in the volume is 
calculated as
</p>

<p align = \"center\" style = \"font-style:italic;\">
m = ρ<sub>s</sub>V<sub>s</sub> + ρ<sub>w</sub>V<sub>w</sub>
</p>
<p>
where <i>ρ</i> is density,<i>V</i> is volume, and subscripts represent 
the steam and liquid water components, respectively. 
The total internal energy <i>U</i> is
</p>
<p align = \"center\" style = \"font-style:italic;\">
U = ρ<sub>s</sub>V<sub>s</sub>h<sub>s</sub> + ρ<sub>w</sub>V<sub>w</sub> − pV
</p>
<p>
where <i>h</i> is specific enthalpy, <i>p</i> is pressure, and the 
total volume of fluid <i>V=V<sub>s</sub>+V<sub>w</sub></i>.
</p>

<p>The steady state mass balance is given as</p>
<p align = \"center\" style = \"font-style:italic;\">
m&#775;<sub>s</sub> + m&#775;<sub>w</sub> = 0,
</p>
<p>
while no additional equation is given for the steady state energy 
balance, since the heat flow rate into the water must be removed
from the system in which the control volume is used.
</p>

<p>The dynamic mass and energy balances are given as</p>
<p align = \"center\" style = \"font-style:italic;\">
dm/dt = m&#775;<sub>s</sub> + m&#775;<sub>w</sub><Br>
dU/dt = Q&#775; + m&#775;<sub>s</sub> h<sub>s</sub> + m&#775;
<sub>w</sub> h<sub>w</sub></p> 

<p>
where ̇<i>m&#775;<sub>s</sub></i> and <i>m&#775;<sub>w</sub></i> 
are the mass flow rates of steam and liquid water
respectively; <i>Q&#775;</i> is the heat flow rate 
into the control volume; 
<i>h<sub>s</sub></i> and <i>h<sub>w</sub></i> are the specific 
enthalpies of steam and liquid water, respectively. 
Note that with an evaporation process, the liquid
phase (water) is always assigned at the <code>port_a</code> (inlet), 
while the vapor phase (steam) is always at the <code>port_b</code> (outlet).
The opposite holds for a condensation process.
</p> 

<h4>Assumptions</h4>
<p>
Three principal assumptions are made with this model:
</p>
<ul>
<li>
The fluid within the volume is wet steam
</li>
<li>
Liquid and vapor subcomponents are at equilibrium; and
</li>
<li>
Fluid is discharged from the volume as either saturated 
liquid or saturated vapor.
</li>

</ul>
<p>
Models that extend this base class include
<a href = \"modelica://Buildings.Experimental.DHC.Plants.Steam.BaseClasses.ControlVolumeEvaporation\">
Buildings.Experimental.DHC.Plants.Steam.BaseClasses.ControlVolumeEvaporation</a> and
<a href = \"modelica://Buildings.Experimental.DHC.Loads.Steam.BaseClasses.ControlVolumeCondensation\">
Buildings.Experimental.DHC.Loads.Steam.BaseClasses.ControlVolumeCondensation</a>.
</p>

<h4>Reference</h4>
<p>
Hinkelman, Kathryn, Saranya Anbarasu, Michael Wetter, 
Antoine Gautier, and Wangda Zuo. 2022. “A Fast and Accurate Modeling 
Approach for Water and Steam Thermodynamics with Practical 
Applications in District Heating System Simulation.” Preprint. February 24. 
<a href=\"http://dx.doi.org/10.13140/RG.2.2.20710.29762\">doi:10.13140/RG.2.2.20710.29762</a>.
</p>

</html>"));
end PartialSaturatedControlVolume;
