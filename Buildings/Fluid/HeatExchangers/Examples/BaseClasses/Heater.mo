within Buildings.Fluid.HeatExchangers.Examples.BaseClasses;
partial model Heater "Base class for example model for the heater and cooler"

  package Medium = Buildings.Media.Air "Medium model";

  parameter Modelica.SIunits.Volume VRoo = 6*6*2.7 "Room volume";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = VRoo*1.2*6/3600
    "Nominal mass flow rate";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 30*6*6
    "Nominal heat loss of the room";

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    V=VRoo,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    mSenFac=2,
    nPorts=3)
         annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(
    G=Q_flow_nominal/20) "Thermal conductance to the outside"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBou
    "Fixed temperature boundary condition"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TVol
    "Sensor for volume temperature"
    annotation (Placement(transformation(extent={{20,-10},{0,10}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Fan"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  Modelica.Blocks.Sources.RealExpression TOut(y=273.15 + 16 - 5*cos(time/86400*
        2*Modelica.Constants.pi)) "Outdoor temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Pulse TSet(
    amplitude=4,
    period=86400,
    offset=273.15 + 16,
    startTime=7*3600) "Setpoint for room temperature"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  Controls.Continuous.LimPID conPI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    yMax=1,
    yMin=0,
    Ti=120) "Controller"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant mFan_flow(k=m_flow_nominal)
    "Mass flow rate of the fan"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Sources.FixedBoundary bou(redeclare package Medium = Medium, nPorts=1)
    "Fixed pressure boundary condition, required to set a reference pressure"
    annotation (Placement(transformation(extent={{90,-30},{70,-10}})));
  Sensors.TemperatureTwoPort THeaOut(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal) "Outlet temperature of the heater"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
equation
  connect(theCon.port_a, TBou.port) annotation (Line(
      points={{0,70},{-20,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort, theCon.port_b) annotation (Line(
      points={{40,0},{30,0},{30,70},{20,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort, TVol.port) annotation (Line(
      points={{40,0},{20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOut.y, TBou.T) annotation (Line(
      points={{-59,70},{-42,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TVol.T, conPI.u_m) annotation (Line(
      points={{0,0},{-50,0},{-50,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet.y, conPI.u_s) annotation (Line(
      points={{-69,30},{-62,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mFan_flow.y, fan.m_flow_in) annotation (Line(
      points={{-69,-10},{-60.2,-10},{-60.2,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(THeaOut.port_b, vol.ports[1]) annotation (Line(
      points={{40,-40},{48,-40},{48,-10},{47.3333,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], fan.port_a) annotation (Line(
      points={{50,-10},{50,-70},{-80,-70},{-80,-40},{-70,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.ports[1], vol.ports[3]) annotation (Line(
      points={{70,-20},{52,-20},{52,-10},{52.6667,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation ( Documentation(info="<html>
<p>
This partial model is used to construct the models
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.Heater_T\">
Buildings.Fluid.HeatExchangers.Examples.Heater_T</a>
and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.Heater_u\">
Buildings.Fluid.HeatExchangers.Examples.Heater_u</a>.
It consists of an air volume with heat loss to the ambient,
a fan,
a set point for the room air temperature and a PI controller.
</p>
<p>
The instance <code>bou</code> is required to set a reference pressure
for system models in which the air is modelled as an incompressible fluid.
</p>
</html>", revisions="<html>
<ul>
<li>
November 12, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Heater;
