within GED.DistrictElectrical.CHP.Validation;
model BottomingCycle_AnnualSim
  extends Modelica.Icons.Example;

  // Medium declarations
  package MediumSte = Buildings.Media.Steam
    "Steam medium - Medium model for port_b (outlet)";
  package MediumWat =
    Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium - Medium model for port_a (inlet)";

  // Parameters for the calculation blocks
  parameter Real a[:]={-0.23380344533,0.220477944738,-0.01476897980}
    "Coefficients for bottoming cycle exergy efficiency function"
    annotation (Dialog(group="Coefficients for functions"));
  parameter Real a_SteMas[:]={0.1140,0,0}
    "Coefficients for bottoming cycle steam mass flow function"
    annotation (Dialog(group="Coefficients for functions"));
  parameter Modelica.Units.NonSI.Temperature_degC TSta=182.486
    "HRSG stack temperature in Celsius";

  // Advanced tab: parameters for the fluid systems
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=56.9972
    "Nominal mass flow rate in fluid ports";
  parameter Modelica.Units.NonSI.Temperature_degC TSte=550
    "Superheated steam temperature in Celsius used for correlation function";
  parameter Modelica.Units.SI.AbsolutePressure p_a_nominal=30000
    "Nominal inlet pressure for predefined pump characteristics";
  parameter Modelica.Units.SI.AbsolutePressure p_b_nominal=3000000
    "Nominal outlet pressure, fixed if not control_m_flow and not use_p_set";
  parameter Modelica.Units.SI.Volume V=12.4
    "Total volume of evaporator";

  // Advanced tab: parameters for PI controller
  parameter Modelica.Units.SI.Volume watLev=V*0.8
    "Water volume setpoint in for PI controller";
  parameter Real k(min=0) = 2
    "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 300
    "Time constant of Integrator block";
  parameter Modelica.Units.SI.Time Td(min=0) = 0
    "Time constant of Derivative block";
  parameter Real yMax(start=1)=1
    "Upper limit of output";
  parameter Real yMin=0
    "Lower limit of output";
  parameter Real Ni(min=100*Modelica.Constants.eps) = 1
    "Ni*Ti is time constant of anti-windup compensation";
  parameter Real Nd(min=100*Modelica.Constants.eps) = 1
    "The higher Nd, the more ideal the derivative block";

  // Assumptions tab
  parameter Boolean allowFlowReversal = false
    "= false to simplify equations, assuming, but not enforcing, no flow reversal. Used only if model has two ports.";

  //Dynamics tab for evaporator energy and mass balance
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state";
  parameter Modelica.Fluid.Types.Dynamics massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of mass balance: dynamic (3 initialization options) or steady state";

  // Initialization tab
  parameter Modelica.Units.SI.AbsolutePressure p_start=3000000
    "Start value of pressure";
  parameter Modelica.Units.SI.Volume VWat_start=V*0.8
    "Start value of liquid volume in the evaporator";
  parameter Modelica.Units.SI.VolumeFlowRate VWat_flow_start=0.055
    "Start value of volumetric flow rate of liquid water";
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)";
  parameter Real y_start=1 "Initial value of output in PI controller";
  parameter Modelica.Units.SI.AbsolutePressure p_a_start=30000
    "Start value of inlet pressure for pump";
  parameter Modelica.Units.SI.AbsolutePressure p_b_start=3000000
    "Start value of outlet pressure for pump";
  parameter Modelica.Units.SI.MassFlowRate m_flow_start=55
    "Start value of mass flow rate for pump";
  parameter Boolean use_T_start=false
    "Boolean to indicate if T_start is used";
  parameter Modelica.Units.NonSI.Temperature_degC T_start=504.475
    "Start value of temperature for pump";
  parameter Modelica.Units.SI.SpecificEnthalpy h_start=1e5
    "Start value of specific enthalpy for pump";

  GED.DistrictElectrical.CHP.BottomingCycle botCyc(
    final a=a,
    final a_SteMas=a_SteMas,
    final TSta=TSta,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final V=V,
    final p_start=p_start,
    final VWat_start=VWat_start,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final initType=initType,
    final yMax=yMax,
    final yMin=yMin,
    final Ni=Ni,
    final Nd=Nd,
    final y_start=y_start,
    final VWat_flow_start=VWat_flow_start,
    final TSte=TSte,
    final watLev=watLev,
    final p_a_start=p_a_start,
    final p_b_start=p_b_start,
    final m_flow_start=m_flow_start,
    final use_T_start=use_T_start,
    final T_start=T_start,
    final h_start=h_start)
    annotation (Placement(transformation(extent={{-10,0},{10,18}})));

  Modelica.Blocks.Sources.Constant ambTemp(k=15)
    "Ambient temperature in Celsius"
    annotation (Placement(transformation(extent={{-80,6},{-60,26}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumWat,
    use_p_in=false,
    p=30000,
    nPorts=1,
    T=504.475)
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Modelica.Fluid.Sources.FixedBoundary bou(
    redeclare package Medium = MediumSte,
    p=1000000,
    T=523.15,
    nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{50,-50},{30,-30}})));
  Modelica.Blocks.Sources.Constant exhTem(k=750 - 273.15)
    "Exhaust gas temperature in Celsius"
    annotation (Placement(transformation(extent={{-80,36},{-60,56}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=-178,
    rising=450,
    width=500,
    falling=450,
    period=1900,
    offset=500,
    startTime=500) "Exhaust mass flow rate changes (kg/s)"
    annotation (Placement(transformation(extent={{-80,-24},{-60,-4}})));
equation
  connect(botCyc.TAmb, ambTemp.y) annotation (Line(points={{-11.3,15.3},{-11.3,
          16},{-59,16}},              color={0,0,127}));
  connect(botCyc.port_a, sou.ports[1]) annotation (Line(points={{-10,10},{-20,
          10},{-20,-40},{-30,-40}},
                                color={0,127,255}));
  connect(botCyc.port_b, bou.ports[1]) annotation (Line(points={{10,10},{20,10},
          {20,-40},{30,-40}},color={0,127,255}));
  connect(botCyc.TExh, exhTem.y) annotation (Line(points={{-11.3,18.3},{-40,
          18.3},{-40,46},{-59,46}},             color={0,0,127}));
  connect(trapezoid.y, botCyc.mExh) annotation (Line(points={{-59,-14},{-40,-14},
          {-40,12},{-12,12},{-12,12.1},{-11.3,12.1}},
                                  color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
October 1, 2024, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This validation model compares the proposed CHP bottoming-cycle model with the high-fidelity model from the ThermoPower Library (TPL), focusing on the regulation of steam drum levels and evaporator void fraction.
</p>
<p>
The ThermoPower Library (TPL) provides an example model for maintaining steam drum level, found in 
<a href=\"modelica://ThermoPower.Examples.RankineCycle.Simulators.ClosedLoop\">
ThermoPower.Examples.RankineCycle.Simulators.ClosedLoop</a>. 
This model simulates a closed-loop control system designed to regulate the evaporator’s void fraction, which represents the proportion of the gas phase within the total drum volume.
</p>
<p>
In this study, the simulation time has been extended from the default 3000 seconds to 31,536,000 seconds (one year) to evaluate the performance for annual simulations. 
</p>
</html>
"));
end BottomingCycle_AnnualSim;
