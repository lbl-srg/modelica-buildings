within Buildings.Fluid.Movers.BaseClasses;
partial model PartialFlowMachine "Base model for fans or pumps"
//    import Modelica.SIunits.Conversions.NonSIunits.*;
  import Modelica.Constants;

  extends Modelica.Fluid.Interfaces.PartialTwoPort(
    port_b_exposesState = energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState or 
         massDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    port_a(
      p(start=p_a_start),
      m_flow(start = m_flow_start,
             min = if allowFlowReversal and not checkValve then -Constants.inf else 0)),
    port_b(
      p(start=p_b_start),
      m_flow(start = -m_flow_start,
             max = if allowFlowReversal and not checkValve then +Constants.inf else 0)));

  // Initialization
  parameter Medium.AbsolutePressure p_a_start=system.p_start
    "Guess value for inlet pressure" 
    annotation(Dialog(tab="Initialization"));
  parameter Medium.AbsolutePressure p_b_start=p_a_start
    "Guess value for outlet pressure" 
    annotation(Dialog(tab="Initialization"));
  parameter Medium.MassFlowRate m_flow_start = 1
    "Guess value of m_flow = port_a.m_flow" 
    annotation(Dialog(tab = "Initialization"));

  // Characteristics
  parameter Integer nParallel(min=1) = 1 "Number of fans or pumps in parallel" 
    annotation(Dialog(group="Characteristics"));
  replaceable function flowCharacteristic = 
      Characteristics.baseFlow
    "Total pressure vs. V_flow characteristic at nominal speed" 
    annotation(Dialog(group="Characteristics"), choicesAllMatching=true);
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm
    N_nominal = 1500 "Nominal rotational speed for flow characteristic" 
    annotation(Dialog(group="Characteristics"));
  parameter Medium.Density rho_nominal = Medium.density_pTX(Medium.p_default, Medium.T_default, Medium.X_default)
    "Nominal fluid density" 
    annotation(Dialog(group="Characteristics"));
  parameter Boolean use_powerCharacteristic = false
    "Use powerCharacteristic (vs. efficiencyCharacteristic)" 
     annotation(Evaluate=true,Dialog(group="Characteristics"));
  replaceable function powerCharacteristic = 
        Characteristics.quadraticPower (
       V_flow_nominal={0,0,0},W_nominal={0,0,0})
    "Power consumption vs. V_flow at nominal speed and density" 
    annotation(Dialog(group="Characteristics", enable = use_powerCharacteristic),
               choicesAllMatching=true);
  replaceable function efficiencyCharacteristic = 
    Characteristics.constantEfficiency(eta_nominal = 0.8) constrainedby
    Characteristics.baseEfficiency
    "Efficiency vs. V_flow at nominal speed and density" 
    annotation(Dialog(group="Characteristics",enable = not use_powerCharacteristic),
               choicesAllMatching=true);

  // Assumptions
  parameter Boolean checkValve=false "= true to prevent reverse flow" 
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.SIunits.Volume V=0 "Volume inside the pump" 
    annotation(Dialog(tab="Assumptions"),Evaluate=true);

  // Energy and mass balance
  extends Modelica.Fluid.Interfaces.PartialLumpedVolume(
      final fluidVolume = V,
      energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState,
      massDynamics = energyDynamics,
      final p_start = p_b_start);

  // Heat transfer through boundary, e.g. to add a housing
  parameter Boolean use_HeatTransfer = false
    "= true to use a HeatTransfer model, e.g. for a housing" 
      annotation (Dialog(tab="Assumptions",group="Heat transfer"));
  replaceable model HeatTransfer = 
      Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer 
    constrainedby
    Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.PartialVesselHeatTransfer
    "Wall heat transfer" 
      annotation (Dialog(tab="Assumptions",group="Heat transfer",enable=use_HeatTransfer),choicesAllMatching=true);
  HeatTransfer heatTransfer(
    redeclare final package Medium = Medium,
    final n=1,
    surfaceAreas={4*Modelica.Constants.pi*(3/4*V/Modelica.Constants.pi)^(2/3)},
    final states = {medium.state},
    final use_k = use_HeatTransfer) 
      annotation (Placement(transformation(
        extent={{-10,-10},{30,30}},
        rotation=180,
        origin={50,-10})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if use_HeatTransfer 
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));

  // Variables
//  final parameter Modelica.SIunits.Acceleration g=system.g;
//  Medium.Density rho = medium.d;
  Modelica.SIunits.Pressure dp(displayUnit="Pa")=port_b.p - port_a.p
    "Pressure increase";
//  Modelica.SIunits.Height head=dp_pump/(medium.d*g) "Pump head";
  Modelica.SIunits.MassFlowRate m_flow=port_a.m_flow "Mass flow rate (total)";
  Modelica.SIunits.MassFlowRate m_flow_single=m_flow/nParallel
    "Mass flow rate (single pump)";
  Modelica.SIunits.VolumeFlowRate V_flow=m_flow/medium.d
    "Volume flow rate (total)";
  Modelica.SIunits.VolumeFlowRate V_flow_single(start=m_flow_start/rho_nominal/
          nParallel)=V_flow/nParallel "Volume flow rate (single pump)";
  Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm N(min=0, start = N_nominal)
    "Shaft rotational speed";
  Modelica.SIunits.Power W_single "Power consumption (single fan or pump)";
  Modelica.SIunits.Power W_total=W_single*nParallel "Power consumption (total)";
  Real eta "Global efficiency";
  Real s(start = m_flow_start)
    "Curvilinear abscissa for the flow curve in parametric form (either mass flow rate or total pressure)";

  // Diagnostics
  parameter Boolean show_NPSHa = false
    "= true to compute Net Positive Suction Head available" 
    annotation(Dialog(tab="Advanced", group="Diagnostics"));
  Medium.ThermodynamicState state_a=
    Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow)) if 
       show_NPSHa "state for medium inflowing through port_a";
  Medium.Density rho_in = Medium.density(state_a) if show_NPSHa
    "Liquid density at the inlet port_a";
  Modelica.SIunits.Length NPSHa=NPSPa/(rho_in*system.g) if show_NPSHa
    "Net Positive Suction Head available";
  Modelica.SIunits.Pressure NPSPa=assertPositiveDifference(
        port_a.p,
        Medium.saturationPressure(Medium.temperature(state_a)),
        "Cavitation occurs at the pump inlet") if show_NPSHa
    "Net Positive Suction Pressure available";
  Modelica.SIunits.Pressure NPDPa=assertPositiveDifference(
        port_b.p,
        Medium.saturationPressure(medium.T),
        "Cavitation occurs in the pump") if show_NPSHa
    "Net Positive Discharge Pressure available";
  // constant Modelica.SIunits.Height unitHead=1;

protected
  constant Modelica.SIunits.Pressure unitPressure=1;
  constant Modelica.SIunits.MassFlowRate unitMassFlowRate=1;

equation
  // Flow equations
  if not checkValve then
    // Regular flow characteristics without check valve
    // With a replaceable function, Dymola 7.3 does not find the derivative function.
    // Support request: Dynasim #10872
    dp = (N/N_nominal)^2*flowCharacteristic(V_flow_single*(N_nominal/N));
    // With the statement below, Dymola 7.3 finds the derivative function
   // dp = (N/N_nominal)^2*Buildings.Fluid.Movers.BaseClasses.Characteristics.quadraticFlow(V_flow_nominal={0,1.8,3}, dp_nominal={1000,600,0},
   //  V_flow=V_flow_single*(N_nominal/N));
    s = 0;
  elseif s > 0 then
    // Flow characteristics when check valve is open
    dp = (N/N_nominal)^2*flowCharacteristic(V_flow_single*(N_nominal/N));
    V_flow_single = s*unitMassFlowRate/medium.d;
  else
    // Flow characteristics when check valve is closed
    dp = (N/N_nominal)^2*flowCharacteristic(0) - s*unitPressure;
    V_flow_single = 0;
  end if;

  // Power consumption
  if use_powerCharacteristic then
    W_single = (N/N_nominal)^3*(medium.d/rho_nominal)*powerCharacteristic(V_flow_single*(N_nominal/N));
    eta = dp*V_flow_single/W_single;
  else
    eta = efficiencyCharacteristic(V_flow_single*(N_nominal/N));
    W_single = dp*V_flow_single/eta;
  end if;

  // Energy balance
  Wb_flow = W_total;
  Qb_flow = heatTransfer.Q_flows[1];
  Hb_flow = port_a.m_flow*actualStream(port_a.h_outflow) +
            port_b.m_flow*actualStream(port_b.h_outflow);

  // Ports
  port_a.h_outflow = medium.h;
  port_b.h_outflow = medium.h;
  port_b.p = medium.p
    "outlet pressure is equal to medium pressure, which includes Wb_flow";

  // Mass balance
  mb_flow = port_a.m_flow + port_b.m_flow;

  mbXi_flow = port_a.m_flow*actualStream(port_a.Xi_outflow) +
              port_b.m_flow*actualStream(port_b.Xi_outflow);
  port_a.Xi_outflow = medium.Xi;
  port_b.Xi_outflow = medium.Xi;

  mbC_flow = port_a.m_flow*actualStream(port_a.C_outflow) +
             port_b.m_flow*actualStream(port_b.C_outflow);
  port_a.C_outflow = C;
  port_b.C_outflow = C;

  connect(heatTransfer.heatPorts[1], heatPort) annotation (Line(
      points={{40,-34},{40,-60}},
      color={127,0,0},
      smooth=Smooth.None));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,46},{100,-46}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Polygon(
          points={{-48,-60},{-72,-100},{72,-100},{48,-60},{-48,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Ellipse(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,68},{0,-68},{70,2},{0,68}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
            graphics),
    Documentation(info="<HTML>
<p>This is the base model for fans and pumps.
<p>The model is similar to <a href=\"Modelica.Fluid.Machines.BaseClasses.PartialPump\">
Modelica.Fluid.Machines.BaseClasses.PartialPump</a>, except for the parameterization which
has been changed so that the model is also applicable for fans.
See the revision notes of this model for details.
<p>The model describes a fan or pump, or a group of <tt>nParallel</tt> identical fans or pumps. The model is based on the theory of kinematic similarity: the fan or pump characteristics are given for nominal operating conditions (rotational speed and fluid density), and then adapted to actual operating condition, according to the similarity equations.

<p><b>Fan or pump characteristics</b></p>
<p> The nominal hydraulic characteristic (total pressure vs. volume flow rate) is given by the the replaceable function <tt>flowCharacteristic</tt>.
<p> The fan or pump energy balance can be specified in two alternative ways:
<ul>
<li><tt>use_powerCharacteristic = false</tt> (default option): the replaceable function <tt>efficiencyCharacteristic</tt> (efficiency vs. volume flow rate in nominal conditions) is used to determine the efficiency, and then the power consumption.
    The default is a constant efficiency of 0.8.</li>
<li><tt>use_powerCharacteristic = true</tt>: the replaceable function <tt>powerCharacteristic</tt> (power consumption vs. volume flow rate in nominal conditions) is used to determine the power consumption, and then the efficiency.
    Use <tt>powerCharacteristic</tt> to specify a non-zero power consumption for zero flow rate.
</ul>
<p>
Several functions are provided in the package <tt>Characteristics</tt> to specify the characteristics as a function of some operating points at nominal conditions.
<p>Depending on the value of the <tt>checkValve</tt> parameter, the model either supports reverse flow conditions, or includes a built-in check valve to avoid flow reversal.
</p>
<p>It is possible to take into account the heat capacity of the fluid inside the fan or pump by specifying its volume <tt>V</tt>;
this is necessary to avoid singularities in the computation of the outlet enthalpy in case of zero flow rate.
If zero flow rate conditions are always avoided, this dynamic effect can be neglected by leaving the default value <tt>V = 0</tt>, thus avoiding a fast state variable in the model.
</p>

<p><b>Dynamics options</b></p>
<p>
Steady-state mass and energy balances are assumed per default, neglecting the holdup of fluid in the fan or pump.
Dynamic mass and energy balance can be used by setting the corresponding dynamic parameters.
This might be desirable if the fan or pump is assembled together with valves before port_a and behind port_b.
If both valves are closed, then the fluid is useful to define the thermodynamic state and in particular the absolute pressure in the fan or pump.
Note that the <tt>flowCharacteristic</tt> only specifies a pressure difference.
</p>

<p><b>Heat transfer</b></p>
<p>
The boolean paramter <tt>use_HeatTransfer</tt> can be set to true if heat exchanged with the environment
should be taken into account or to model a housing. This might be desirable if a fan or pump with realistic
<tt>powerCharacteristic</tt> for zero flow operates while a valve prevents fluid flow.
</p>

<p><b>Diagnostics of Cavitation</b></p>
<p>The boolean parameter show_NPSHa can set true to compute the Net Positive Suction Head available and check for cavitation,
provided a two-phase medium model is used.
</p>
</HTML>",
      revisions="<html>
<ul>
<li><i>October 1, 2009</i>
    by Michael Wetter:<br>
    Changed model so that it is based on total pressure in Pascals instead of the pump head in meters.
    This change is needed if the device is used with air as a medium. The original formulation in Modelica.Fluid
    converts head to pressure using the density medium.d. Therefore, for fans, head would be converted to pressure
    using the density of air. However, for fans, manufacturers typically publish the head in 
    millimeters water (mmH20). Therefore, to avoid confusion and to make this model applicable for any medium,
    the model has been changed to use total pressure in Pascals instead of head in meters.
</li>
<li><i>Dec 2008</i>
    by R&uuml;diger Franke:<br>
    <ul>
    <li>Replaced simplified mass and energy balances with rigorous formulation (base class PartialLumpedVolume)</li>
    <li>Introduced optional HeatTransfer model defining Qb_flow</li>
    <li>Enabled events when the checkValve is operating to support the opening of a discrete valve before port_a</li>
    </ul></li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Model added to the Fluid library</li>
</ul>
</html>"));

end PartialFlowMachine;
