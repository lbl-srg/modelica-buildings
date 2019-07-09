within Buildings.Fluid.Interfaces;
model SixPortHeatMassExchanger
  "Model transporting four fluid streams between six ports with storing mass or energy"
  extends Buildings.Fluid.Interfaces.PartialSixPortInterface(
    final h_outflow_a1_start = h1_outflow_start,
    final h_outflow_b1_start = h1_outflow_start,
    final h_outflow_a2_start = h2_outflow_start,
    final h_outflow_b2_start = h2_outflow_start,
    final h_outflow_a3_start = h3_outflow_start,
    final h_outflow_b3_start = h3_outflow_start);

  extends Buildings.Fluid.Interfaces.SixPortFlowResistanceParameters(
     final computeFlowResistance1=true,
     final computeFlowResistance2=true,
     final computeFlowResistance3=true);

  parameter Modelica.SIunits.Time tau1 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  parameter Modelica.SIunits.Time tau2 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  parameter Modelica.SIunits.Time tau3 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));

  // Advanced
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Initialization
  parameter Medium1.AbsolutePressure p1_start = Medium1.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter Medium1.Temperature T1_start = Medium1.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter Medium1.MassFraction X1_start[Medium1.nX] = Medium1.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nXi > 0));
  parameter Medium1.ExtraProperty C1_start[Medium1.nC](
       quantity=Medium1.extraPropertiesNames)=fill(0, Medium1.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nC > 0));
  parameter Medium1.ExtraProperty C1_nominal[Medium1.nC](
       quantity=Medium1.extraPropertiesNames) = fill(1E-2, Medium1.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nC > 0));

  parameter Medium2.AbsolutePressure p2_start = Medium2.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter Medium2.Temperature T2_start = Medium2.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter Medium2.MassFraction X2_start[Medium2.nX] = Medium2.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nXi > 0));
  parameter Medium2.ExtraProperty C2_start[Medium2.nC](
       quantity=Medium2.extraPropertiesNames)=fill(0, Medium2.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nC > 0));
  parameter Medium2.ExtraProperty C2_nominal[Medium2.nC](
       quantity=Medium2.extraPropertiesNames) = fill(1E-2, Medium2.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nC > 0));

  parameter Medium3.AbsolutePressure p3_start = Medium3.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 3"));
  parameter Medium3.Temperature T3_start = Medium3.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 3"));
  parameter Medium3.MassFraction X3_start[Medium3.nX] = Medium3.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 3", enable=Medium3.nXi > 0));
  parameter Medium3.ExtraProperty C3_start[Medium3.nC](
       quantity=Medium3.extraPropertiesNames)=fill(0, Medium3.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 3", enable=Medium3.nC > 0));
  parameter Medium3.ExtraProperty C3_nominal[Medium3.nC](
       quantity=Medium3.extraPropertiesNames) = fill(1E-2, Medium3.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 3", enable=Medium3.nC > 0));

 Modelica.SIunits.HeatFlowRate  Q1_flow = vol1.heatPort.Q_flow
    "Heat flow rate into medium 1";
  Modelica.SIunits.HeatFlowRate Q2_flow = vol2.heatPort.Q_flow
    "Heat flow rate into medium 2";
  Modelica.SIunits.HeatFlowRate Q3_flow = vol3.heatPort.Q_flow
    "Heat flow rate into medium 3";

  Buildings.Fluid.MixingVolumes.MixingVolume vol1(
    redeclare final package Medium = Medium1,
    V=m1_flow_nominal*tau1/rho1_nominal,
    final m_flow_nominal=m1_flow_nominal,
    energyDynamics=if tau1 > Modelica.Constants.eps
                         then energyDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=if tau1 > Modelica.Constants.eps
                         then massDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
    final p_start=p1_start,
    final T_start=T1_start,
    final X_start=X1_start,
    final C_start=C1_start,
    final C_nominal=C1_nominal,
    nPorts=2)
     "Volume for fluid 1"
      annotation (Placement(transformation(extent={{-10,80},
            {10,60}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol2(
    redeclare final package Medium = Medium2,
    energyDynamics=if tau2 > Modelica.Constants.eps
                         then energyDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=if tau2 > Modelica.Constants.eps
                         then massDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
    final p_start=p2_start,
    final T_start=T2_start,
    final X_start=X2_start,
    final C_start=C2_start,
    final C_nominal=C2_nominal,
    final m_flow_nominal=m2_flow_nominal,
    V=m2_flow_nominal*tau2/rho2_nominal,
    nPorts=2)
    "Volume for fluid 2"
     annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol3(
    redeclare final package Medium = Medium3,
    energyDynamics=if tau3 > Modelica.Constants.eps
                         then energyDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=if tau3 > Modelica.Constants.eps
                         then massDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
    final p_start=p3_start,
    final T_start=T3_start,
    final X_start=X3_start,
    final C_start=C3_start,
    final C_nominal=C3_nominal,
    final m_flow_nominal=m3_flow_nominal,
    V=m3_flow_nominal*tau3/rho3_nominal,
    nPorts=2)
    "Volume for fluid 3"
     annotation (Placement(transformation(
        origin={0,-70},
        extent={{10,10},{-10,-10}},
        rotation=180)));
  Buildings.Fluid.FixedResistances.PressureDrop preDro1(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final deltaM=deltaM1,
    final allowFlowReversal=allowFlowReversal1,
    final show_T=false,
    final from_dp=from_dp1,
    final linearized=linearizeFlowResistance1,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp1_nominal)
    "Pressure drop model for fluid 1"
    annotation (Placement(transformation(extent={{-44,70},{-64,90}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro2(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    final deltaM=deltaM2,
    final allowFlowReversal=allowFlowReversal2,
    final show_T=false,
    final from_dp=from_dp2,
    final linearized=linearizeFlowResistance2,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp2_nominal)
    "Pressure drop model for fluid 2"
    annotation (Placement(transformation(extent={{48,-10},{68,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro3(
    redeclare final package Medium = Medium3,
    final m_flow_nominal=m3_flow_nominal,
    final deltaM=deltaM3,
    final allowFlowReversal=allowFlowReversal3,
    final show_T=false,
    final from_dp=from_dp3,
    final linearized=linearizeFlowResistance3,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp3_nominal)
    "Pressure drop model for fluid 3"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));

protected
  parameter Medium1.ThermodynamicState sta1_nominal=Medium1.setState_pTX(
      T=Medium1.T_default, p=Medium1.p_default, X=Medium1.X_default);
  parameter Modelica.SIunits.Density rho1_nominal=Medium1.density(sta1_nominal)
    "Density, used to compute fluid volume";
  parameter Medium2.ThermodynamicState sta2_nominal=Medium2.setState_pTX(
      T=Medium2.T_default, p=Medium2.p_default, X=Medium2.X_default);
  parameter Modelica.SIunits.Density rho2_nominal=Medium2.density(sta2_nominal)
    "Density, used to compute fluid volume";
  parameter Medium1.ThermodynamicState sta3_nominal=Medium3.setState_pTX(
      T=Medium3.T_default, p=Medium3.p_default, X=Medium3.X_default);
  parameter Modelica.SIunits.Density rho3_nominal=Medium3.density(sta3_nominal)
    "Density, used to compute fluid volume";

  parameter Medium1.ThermodynamicState sta1_start=Medium1.setState_pTX(
      T=T1_start, p=p1_start, X=X1_start);
  parameter Modelica.SIunits.SpecificEnthalpy h1_outflow_start = Medium1.specificEnthalpy(sta1_start)
    "Start value for outflowing enthalpy";
  parameter Medium2.ThermodynamicState sta2_start=Medium2.setState_pTX(
      T=T2_start, p=p2_start, X=X2_start);
  parameter Modelica.SIunits.SpecificEnthalpy h2_outflow_start = Medium2.specificEnthalpy(sta2_start)
    "Start value for outflowing enthalpy";
  parameter Medium3.ThermodynamicState sta3_start=Medium3.setState_pTX(
      T=T3_start, p=p3_start, X=X3_start);
  parameter Modelica.SIunits.SpecificEnthalpy h3_outflow_start = Medium3.specificEnthalpy(sta3_start)
    "Start value for outflowing enthalpy";

initial algorithm
  // Check for tau1
  assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau1 > Modelica.Constants.eps,
"The parameter tau1, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau1 = " + String(tau1) + "\n");
  assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau1 > Modelica.Constants.eps,
"The parameter tau1, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau1 = " + String(tau1) + "\n");

 // Check for tau2
  assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau2 > Modelica.Constants.eps,
"The parameter tau2, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau2 = " + String(tau2) + "\n");
  assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau2 > Modelica.Constants.eps,
"The parameter tau2, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau2 = " + String(tau2) + "\n");

  // Check for tau3
  assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau3 > Modelica.Constants.eps,
"The parameter tau3, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau3 = " + String(tau3) + "\n");
  assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau3 > Modelica.Constants.eps,
"The parameter tau3, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau3 = " + String(tau3) + "\n");

equation
  connect(vol1.ports[1], port_b1) annotation (Line(points={{-2,80},{100,80}},
                                     color={0,127,255}));
  connect(vol2.ports[1], port_b2)
    annotation (Line(points={{-2,0},{-100,0}},color={0,127,255}));
  connect(port_a3, preDro3.port_b)
    annotation (Line(points={{100,-80},{70,-80}}, color={0,127,255}));
  connect(vol3.ports[1], preDro3.port_a) annotation (Line(points={{-2,-80},{50,
          -80}},                           color={0,127,255}));
  connect(vol3.ports[2], port_b3) annotation (Line(points={{2,-80},{-100,-80}},
                            color={0,127,255}));
  connect(port_a1, preDro1.port_b)
    annotation (Line(points={{-100,80},{-64,80}}, color={0,127,255}));
  connect(preDro1.port_a, vol1.ports[2])
    annotation (Line(points={{-44,80},{2,80}}, color={0,127,255}));
  connect(preDro2.port_b, port_a2)
    annotation (Line(points={{68,0},{100,0}}, color={0,127,255}));
  connect(preDro2.port_a, vol2.ports[2])
    annotation (Line(points={{48,0},{2,0}}, color={0,127,255}));
  annotation (
    Documentation(info="<html>
<p>This component transports four fluid streams between eight ports. It provides the basic model for implementing a dynamic heat exchanger. </p>
<p>The model can be used as-is, although there will be no heat or mass transfer between the four fluid streams. To add heat transfer, heat flow can be added to the heat port of the four volumes.</p>
<h4>Implementation</h4>
<p>The variable names follow the conventions used in <a href=\"modelica://Modelica.Fluid.Examples.HeatExchanger.BaseClasses.BasicHX\">Modelica.Fluid.Examples.HeatExchanger.BaseClasses.BasicHX</a>. </p>
</html>", revisions="<html>
<ul>
<li>July 18, 2018, by Massimo Cimmino:
<br/>Remove start values of m_flow and dp variables.
</li>
</ul>
<ul>
<li>July 2014, by Damien Picard:<br/>First implementation. </li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{-71,90},{70,-90}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={212,212,212},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,85},{102,75}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-97,4},{104,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,-76},{102,-86}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end SixPortHeatMassExchanger;
