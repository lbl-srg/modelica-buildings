within Buildings.Fluid.HeatExchangers.Examples.BaseClasses;
partial model Heater "Base class for example model for the heater and cooler"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model";

  parameter Modelica.Units.SI.Volume V=6*6*2.7 "Volume";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=V*1.2*6/3600
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=30*6*6
    "Nominal heat loss of the room";

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    T_start=289.15,
    V=V,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
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
  Buildings.Fluid.Movers.FlowControlled_m_flow mov(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Fan or pump"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  Modelica.Blocks.Sources.RealExpression TOut(
    y(final unit="K", displayUnit="degC")=
      273.15 + 16 - 5*cos(time/86400*2*Modelica.Constants.pi))
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Pulse TSet(
    amplitude=4,
    period=86400,
    offset=273.15 + 16,
    startTime=7*3600,
    y(final unit="K", displayUnit="degC")) "Setpoint for room temperature"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  Controls.Continuous.LimPID conPI(
    k=1,
    yMax=1,
    yMin=0,
    Ti=120) "Controller"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant mFan_flow(k=m_flow_nominal)
    "Mass flow rate of the fan"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1)
    "Fixed pressure boundary condition, required to set a reference pressure"
    annotation (Placement(transformation(extent={{110,-30},{90,-10}})));
  Sensors.TemperatureTwoPort THeaOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    T_start=289.15) "Outlet temperature of the heater"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=100,
    linearized=true) "Flow resistance to decouple pressure state from boundary"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
equation
  connect(theCon.port_a, TBou.port) annotation (Line(
      points={{0,70},{-20,70}},
      color={191,0,0}));
  connect(vol.heatPort, theCon.port_b) annotation (Line(
      points={{40,0},{30,0},{30,70},{20,70}},
      color={191,0,0}));
  connect(vol.heatPort, TVol.port) annotation (Line(
      points={{40,0},{20,0}},
      color={191,0,0}));
  connect(TOut.y, TBou.T) annotation (Line(
      points={{-59,70},{-42,70}},
      color={0,0,127}));
  connect(TVol.T, conPI.u_m) annotation (Line(
      points={{0,0},{-50,0},{-50,18}},
      color={0,0,127}));
  connect(TSet.y, conPI.u_s) annotation (Line(
      points={{-69,30},{-62,30}},
      color={0,0,127}));
  connect(mFan_flow.y,mov. m_flow_in) annotation (Line(
      points={{-69,-10},{-60,-10},{-60,-28}},
      color={0,0,127}));
  connect(THeaOut.port_b, vol.ports[1]) annotation (Line(
      points={{40,-40},{48,-40},{48,-10},{47.3333,-10}},
      color={0,127,255}));
  connect(vol.ports[2],mov. port_a) annotation (Line(
      points={{50,-10},{50,-70},{-80,-70},{-80,-40},{-70,-40}},
      color={0,127,255}));
  connect(res.port_b, bou.ports[1])
    annotation (Line(points={{80,-20},{85,-20},{90,-20}}, color={0,127,255}));
  connect(res.port_a, vol.ports[3]) annotation (Line(points={{60,-20},{52.6667,
          -20},{52.6667,-10}},
                          color={0,127,255}));
  annotation ( Documentation(info="<html>
<p>
This partial model is used to construct the models
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.AirHeater_T\">
Buildings.Fluid.HeatExchangers.Examples.AirHeater_T</a>
and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.AirHeater_u\">
Buildings.Fluid.HeatExchangers.Examples.AirHeater_u</a> and
the similar models
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.WaterHeater_T\">
Buildings.Fluid.HeatExchangers.Examples.WaterHeater_T</a>
and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.WaterHeater_u\">
Buildings.Fluid.HeatExchangers.Examples.WaterHeater_u</a>.
It consists of a volume with heat loss to the ambient,
a fan,
a set point for the temperature of the volume and a PI controller.
</p>
<p>
The instance <code>bou</code> is required to set a reference pressure
for system models in which the fluid is modelled as an incompressible fluid,
and it also is required to account for a variation of density of the fluid.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2019, by Jianjun Hu:<br/>
Replaced fluid source. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
May 8, 2017, by Michael Wetter:<br/>
Updated model for new heater model.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">
Buildings, #763</a>.
</li>
<li>February 20, 2016, by Ruben Baetens:<br/>
Removal of <code>dynamicBalance</code> as parameter for <code>massDynamics</code> and <code>energyDynamics</code>.
</li>
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
November 12, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{120,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{120,100}})));
end Heater;
