within Buildings.Fluid.Boilers;
model BoilerSteamTwoPort
  "Steam boiler model with two ports for water flow with phase change"
  extends Buildings.Fluid.Interfaces.PartialWaterPhaseChange;
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium(
    redeclare final package Medium_a=MediumWat,
    redeclare final package Medium_b=MediumSte);
  extends Buildings.Fluid.Boilers.BaseClasses.PartialBoilerPolynomial;

  // Pressure changes
  parameter Modelica.SIunits.PressureDifference dpSte_nominal=pSatHig-101325
    "Pressure drop at nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dpValve_nominal=6000
    "Pressure drop at nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dpFixed_nominal=0
    "Pressure drop at nominal mass flow rate";

  parameter Modelica.SIunits.ThermalConductance UA=0.05*Q_flow_nominal/30
    "Overall UA value";
  parameter Modelica.SIunits.Volume VWat = 1.5E-6*Q_flow_nominal
    "Water volume of boiler"
    annotation(Dialog(tab = "Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Mass mDry =   1.5E-3*Q_flow_nominal
    "Mass of boiler that will be lumped to water heat capacity"
    annotation(Dialog(tab = "Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));

  parameter Modelica.SIunits.Time tau = 30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab = "Dynamics", group="Nominal condition"));

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  Buildings.Fluid.FixedResistances.CheckValve cheVal(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dpValve_nominal,
    rhoStd=rhoWatStd,
    dpFixed_nominal=dpFixed_nominal)
    "Check valve"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volWat(
    redeclare package Medium = MediumWat,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    m_flow_nominal=m_flow_nominal,
    V=m_flow_nominal*tau/rhoWatStd,
    nPorts=2)
    "Water volume"
    annotation (Placement(transformation(extent={{10,0},{30,-20}})));
  Buildings.Fluid.Boilers.BaseClasses.Evaporation eva(
    redeclare package MediumWat = MediumWat,
    redeclare package MediumSte = MediumSte,
    m_flow_nominal=m_flow_nominal,
    pSatHig=pSatHig)
    "Evaporation"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapDry(C=500*mDry,
      T(start=TSatHig)) if not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "heat capacity of boiler metal"
    annotation (Placement(transformation(extent={{-60,32},{-40,52}})));
protected
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare package Medium = MediumWat)
    "Measured mass flow rate"
    annotation (Placement(transformation(extent={{-90,10},{-70,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSen_in(
    redeclare package Medium = MediumWat,
    m_flow_nominal = m_flow_nominal)
    "Inflowing temperature sensor"
    annotation (Placement(transformation(extent={{-60,10},{-40,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSen_out(
    redeclare package Medium = MediumSte,
    m_flow_nominal = m_flow_nominal)
    "Outflowing temperature sensor"
    annotation (Placement(transformation(extent={{70,10},{90,-10}})));
  Modelica.Blocks.Math.Add dTSen(k1=-1)
    "Change in temperature between inflowing and outflowing fluids"
    annotation (Placement(transformation(extent={{40,-90},{20,-70}})));
  Modelica.Blocks.Math.Product QSen_flow "Sensible heat transfer rate"
    annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));
  Modelica.Blocks.Math.Gain cp(k=cpWatStd) "Specific heat"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed (sensible) heat flow into fluid volume"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
protected
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor UAOve(G=UA)
    "Overall thermal conductance (if heatPort is connected)"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
equation
  connect(cheVal.port_b, volWat.ports[1])
    annotation (Line(points={{-10,0},{18,0}}, color={0,127,255}));
  connect(volWat.ports[2], eva.port_a)
    annotation (Line(points={{22,0},{40,0}},color={0,127,255}));
  connect(temSen.port, volWat.heatPort)
    annotation (Line(points={{20,40},{6,40},{6,-10},{10,-10}},
                                                       color={191,0,0}));
  connect(UAOve.port_b, volWat.heatPort) annotation (Line(points={{-10,40},{6,
          40},{6,-10},{10,-10}},
                             color={191,0,0}));
  connect(heatPort, UAOve.port_a) annotation (Line(points={{0,72},{0,60},{-34,
          60},{-34,40},{-30,40}},
                              color={191,0,0}));
  connect(heaCapDry.port, volWat.heatPort) annotation (Line(points={{-50,32},{
          -50,20},{6,20},{6,-10},{10,-10}},
                                        color={191,0,0}));
  connect(preHeaFlo.port, volWat.heatPort) annotation (Line(points={{0,-50},{6,-50},
          {6,-10},{10,-10}}, color={191,0,0}));
  connect(temSen_out.T, dTSen.u2)
    annotation (Line(points={{80,-11},{80,-86},{42,-86}}, color={0,0,127}));
  connect(temSen_in.T, dTSen.u1) annotation (Line(points={{-50,-11},{-50,-30},{50,
          -30},{50,-74},{42,-74}}, color={0,0,127}));
  connect(port_a, senMasFlo.port_a)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(senMasFlo.port_b, temSen_in.port_a)
    annotation (Line(points={{-70,0},{-60,0}}, color={0,127,255}));
  connect(temSen_in.port_b, cheVal.port_a)
    annotation (Line(points={{-40,0},{-30,0}}, color={0,127,255}));
  connect(eva.port_b, temSen_out.port_a)
    annotation (Line(points={{60,0},{70,0}}, color={0,127,255}));
  connect(temSen_out.port_b, port_b) annotation (Line(points={{90,0},{94,0},{94,
          0},{100,0}}, color={0,127,255}));
  connect(senMasFlo.m_flow, QSen_flow.u1)
    annotation (Line(points={{-80,-11},{-80,-44},{-52,-44}}, color={0,0,127}));
  connect(cp.y, QSen_flow.u2) annotation (Line(points={{-59,-60},{-56,-60},{-56,
          -56},{-52,-56}}, color={0,0,127}));
  connect(dTSen.y, cp.u) annotation (Line(points={{19,-80},{-90,-80},{-90,-60},{
          -82,-60}}, color={0,0,127}));
  connect(QSen_flow.y, preHeaFlo.Q_flow)
    annotation (Line(points={{-29,-50},{-20,-50}}, color={0,0,127}));
  annotation (
    defaultComponentName="boi",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-101,5},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-4},{100,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
      Line(
        points={{-8,54},{-28,44},{-8,24},{-28,14}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
      Line(
        points={{12,54},{-8,44},{12,24},{-8,14}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
      Line(
        points={{32,54},{12,44},{32,24},{12,14}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}})}),                         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end BoilerSteamTwoPort;
