within Buildings.Fluid.Interfaces;
model ConservationEquationEvaporation
  "Lumped volume with mass and energy balance for water evaporation"
  extends Buildings.Fluid.Interfaces.PartialWaterPhaseChange;
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium(
    redeclare final package Medium_a=MediumWat,
    redeclare final package Medium_b=MediumSte);

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
  Modelica.SIunits.Mass m(start=VWat_start*(rhoWat_start+rhoSte_start))
    "Total mass of volume";
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

  Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W") if not steadyDynamics
    "Sensible plus latent heat flow rate transferred into the medium"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  // Outputs that are needed in models that use this model
  Modelica.Blocks.Interfaces.RealOutput hOut(unit="J/kg", start=hSteStart)
    "Leaving specific enthalpy of the component"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,110})));
  Modelica.Blocks.Interfaces.RealOutput UOut(unit="J")
    "Internal energy of the component" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={110,20}), iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput mOut(min=0, unit="kg")
    "Mass of the component" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={110,60}), iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput VOut(unit="m3") "liquid volume"
  annotation (Placement(transformation(
        origin={20,110},
        extent={{-10,-10},{10,10}},
        rotation=90),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,110})));

protected
  final parameter Boolean steadyDynamics=
    if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then true
    else false
    "= true, if steady state formulation";
  Modelica.Blocks.Interfaces.RealInput Q_flow_internal
    "Needed to use conditional connector Q_flow";

initial equation
  // Make sure that if energyDynamics is SteadyState, then
  // massDynamics is also SteadyState.
  // Otherwise, the system of ordinary differential equations may be inconsistent.
  if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    assert(massDynamics == energyDynamics, "In " + getInstanceName() + ":
         If 'massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState', then it is
         required that 'energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState'.
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
  connect(Q_flow, Q_flow_internal) "Needed because of conditional input";
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
  VOut = VWat;
  hOut = hSte;
  UOut = U;
  mOut = m;

// Check that evaporation is actually possible
  assert(VSte >= 0, "There is no more steam vapor in the volume.");
  assert(VWat >= 0, "There is no more liquid water in the volume.");

  annotation (
    Documentation(info="<html>
<p>Similar to Modelica.Fluid.Examples.DrumBoiler.DrumBoiler except:</p>
<ol>
<li>Rather than a two-phase medium, fluid mediums are modeled as two single-state fluid, with liquid water at the inlet port, and steam vapor at the outlet port.</li>
<li>The metal drum is excluded from the mass and energy balances.</li>
<li>The steady state formulations are modified to enable steady mass and energy balances.</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
July 22, 2021, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={            Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-89,52},{-54,69}},
          lineColor={0,0,127},
          textString="Q_flow"),
        Line(points={{-56,-73},{81,-73}}, color={255,255,255}),
        Line(points={{-42,55},{-42,-84}}, color={255,255,255}),
        Polygon(
          points={{-42,67},{-50,45},{-34,45},{-42,67}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{87,-73},{65,-65},{65,-81},{87,-73}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-42,-28},{-6,-28},{18,4},{40,12},{66,14}},
          color={255,255,255},
          smooth=Smooth.Bezier),
        Text(
          extent={{-155,-120},{145,-160}},
          lineColor={0,0,255},
          textString="%name")}));
end ConservationEquationEvaporation;
