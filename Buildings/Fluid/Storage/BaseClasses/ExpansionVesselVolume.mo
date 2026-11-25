within Buildings.Fluid.Storage.BaseClasses;
model ExpansionVesselVolume
  "Lumped adiabatic fluid volume with variable volume for an expansion vessel"
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final massDynamics=energyDynamics,
    final mSenFac=1);

  parameter Boolean initialize_p = true
    "= true to set up initial equations for mass"
    annotation(HideResult=true, Evaluate=true, Dialog(tab="Advanced"));

  parameter Modelica.Units.SI.Volume V_start(start=1)
    "Volume of liquid stored in the vessel at the start of the simulation";

  parameter Modelica.Units.SI.Volume VTot(min=V_start) = 2*V_start
    "Total volume of vessel (liquid and gas side)";

  parameter Modelica.Units.SI.Pressure pMax = p_start + 3E5
    "Maximum pressure before simulation stops with an error";

  Modelica.Blocks.Interfaces.RealOutput VLiqOut(
    final quantity="Volume",
    final unit="m3",
    start=V_start,
    min=0)
    "Volume of fluid in the vessel"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));

  Modelica.Blocks.Interfaces.RealOutput mOut(
    final quantity="Mass",
    final unit="kg",
    start=V_start*rho_start,
    min=0)
    "Mass of fluid in the vessel"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));

  Modelica.Blocks.Interfaces.RealOutput TOut(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    start=T_start)
    "Temperature of fluid in the vessel"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium,
    p(start=p_start),
    h_outflow(start=h_start, nominal=Medium.h_default),
    Xi_outflow(start=X_start[1:Medium.nXi], each nominal=0.01),
    C_outflow(start=C_start, nominal=C_nominal))
    "Fluid port"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  Modelica.Units.SI.Volume VLiq(
    start=V_start,
    min=0)
    "Volume of liquid in the vessel";

  Modelica.Units.SI.Mass m(
    start=V_start*rho_start,
    nominal=V_start*rho_start,
    stateSelect=StateSelect.prefer)
    "Mass of fluid in the vessel";

  Medium.SpecificEnthalpy h(
    start=h_start,
    nominal=Medium.h_default,
    stateSelect=StateSelect.prefer)
    "Specific enthalpy of fluid in the vessel";

  Medium.MassFraction Xi[Medium.nXi](
    start=X_start[1:Medium.nXi],
    each nominal=0.01,
    each min=0,
    each max=1,
    each stateSelect=StateSelect.prefer)
    "Independent mass fractions of fluid in the vessel";

  Medium.ExtraProperty C[Medium.nC](
    start=C_start,
    nominal=C_nominal,
    each stateSelect=StateSelect.prefer)
    "Trace substance concentrations of fluid in the vessel";

protected
  final parameter Modelica.Units.SI.Volume VGas0 = VTot - V_start
    "Initial volume of gas";
  final parameter Medium.ThermodynamicState state_start = Medium.setState_pTX(
    T=T_start,
    p=p_start,
    X=X_start[1:Medium.nXi])
    "Medium state at start values";
  final parameter Modelica.Units.SI.Density rho_start = Medium.density(
    state=state_start)
    "Fluid density at start values";
  final parameter Medium.SpecificEnthalpy h_start = Medium.specificEnthalpy(
    state=state_start)
    "Specific enthalpy at start values";

  Medium.ThermodynamicState sta
    "Thermodynamic state of the fluid";

initial equation
  assert(energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
    "In " + getInstanceName() + ": energyDynamics cannot be SteadyState for an expansion vessel.");
  assert(V_start > 0,
    "In " + getInstanceName() + ": V_start must be strictly positive.");
  assert(VTot > V_start,
    "In " + getInstanceName() + ": VTot must be strictly greater than V_start.");

  if energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
    if initialize_p then
      m = V_start * rho_start;
    end if;
    h = h_start;
    Xi = X_start[1:Medium.nXi];
    C = C_start;
  elseif energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
    if initialize_p then
      der(m) = 0;
    end if;
    der(h) = 0;
    der(Xi) = zeros(Medium.nXi);
    der(C) = zeros(Medium.nC);
  end if;

equation
  assert(m > 1.0E-8,
    "In " + getInstanceName() + ": Expansion vessel is undersized. You need to increase V_start.");
  assert(port_a.p < pMax,
    "In " + getInstanceName() + ": Pressure exceeds maximum pressure.\n" +
    "You may need to increase V_start or VTot of the ExpansionVessel.");

  sta = Medium.setState_phX(
    p=port_a.p,
    h=h,
    X=if Medium.nXi == 0 then Medium.X_default
      elseif Medium.reducedX then cat(1, Xi, {1 - sum(Xi)})
      else Xi);

  // Conservation equations
  der(m)  = port_a.m_flow;
  der(h)  = port_a.m_flow * (actualStream(port_a.h_outflow) - h) / m;
  der(Xi) = port_a.m_flow * (actualStream(port_a.Xi_outflow) - Xi) / m;
  der(C)  = port_a.m_flow * (actualStream(port_a.C_outflow) - C) / m;

  // Liquid volume and vessel pressure from isothermal ideal gas law of gas cushion
  VLiq = m / Medium.density(sta);
  port_a.p = p_start * VGas0 / (VTot - VLiq);

  // Properties of outgoing flow and outputs
  port_a.h_outflow  = h;
  port_a.Xi_outflow = Xi;
  port_a.C_outflow  = C;

  VLiqOut = VLiq;
  mOut    = m;
  TOut    = Medium.temperature(sta);

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(
      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-80,20},{80,-80}},
          lineColor={0,0,255},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,110},{150,150}},
          textColor={0,0,255},
          textString="%name")}),
    defaultComponentName="vol",
    Documentation(
      info="<html>
<p>
This model represents an ideally mixed, adiabatic fluid volume with a single
fluid port and a time-varying liquid volume for an expansion vessel. It is used by
<a href=\"modelica://Buildings.Fluid.Storage.ExpansionVessel\">
Buildings.Fluid.Storage.ExpansionVessel</a>.
</p>
<p>
Assuming constant gas temperature, the ideal gas law determines the port pressure
</p>
<pre>
  port_a.p = p_start * (VTot - V_start) / (VTot - VLiq)
</pre>
<p>
where <code>VTot</code> is the total volume of the vessel,
<code>VLiq</code> is the volume of liquid in the vessel,
<code>V_start</code> is the initial volume of liquid at <code>p_start</code>, and
<code>VTot - V_start</code> is the initial volume occupied by the gas at <code>p_start</code>.
</p>
<p>
Because all mass and energy exchange occurs through <code>port_a</code> and no
sensible or latent heat is exchanged with the exterior, the conservation
equations are formulated directly in terms of total fluid mass <code>m</code>,
specific enthalpy <code>h</code>, species mass fractions <code>Xi</code>, and
trace substance concentrations <code>C</code> using <code>actualStream</code>.
Using <code>h</code> rather than internal energy avoids nonlinear state
inversions for media whose density depends on temperature, and the outgoing
stream variables equal the states directly without division during outflow.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 23, 2026, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2220\">IBPSA, #2220</a>.
</li>
</ul>
</html>"));
end ExpansionVesselVolume;
