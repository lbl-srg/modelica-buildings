within Buildings.Airflow.Multizone.Examples;
model TrickleVent
  "Model with a trickle vent modelled using the models with flow based on tabulated data"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));
  Fluid.Sources.Outside_CpLowRise west(
    redeclare package Medium = Medium,
    s=5,
    azi=Buildings.Types.Azimuth.W,
    Cp0=0.6,
    nPorts=1) "Model with outside conditions"
    annotation (Placement(transformation(extent={{90,-40},{70,-20}})));
  Fluid.Sources.Outside_CpLowRise east(
    redeclare package Medium = Medium,
    s=5,
    azi=Buildings.Types.Azimuth.E,
    Cp0=0.6,
    nPorts=1) "Model with outside conditions"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Fluid.MixingVolumes.MixingVolume room(
    redeclare package Medium = Medium,
    V=2.5*5*5,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.01) "Room model"
    annotation (Placement(transformation(extent={{10,-20},{30,0}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,50})));
  Modelica.Blocks.Continuous.LimPID con(
    Td=10,
    yMax=1,
    yMin=-1,
    Ti=60,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=5) "Controller to maintain volume temperature"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Sources.Constant TSet(k=293.15) "Temperature set point"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Temperature sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-50,40})));
  Modelica.Blocks.Math.Gain gain(k=3000) "Gain block"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Airflow.Multizone.Table_m_flow tabDat_m_flow(
    redeclare package Medium = Medium,
    dpMea_nominal = {-50,  -25,  -10,  -5,  -3,  -2,  -1,  0,  1,  2,  3,  4.5,  50},
    mMea_flow_nominal = {-0.08709, -0.06158, -0.03895, -0.02754, -0.02133, -0.01742, -0.01232, 0, 0.01232, 0.01742, 0.02133, 0.02613, 0.02614})
    "Self regulating trickle vent"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Airflow.Multizone.Table_V_flow tabDat_V_flow(
    redeclare package Medium = Medium,
    dpMea_nominal = {-50,  -25,  -10,  -5,  -3,  -2,  -1,  0,  1,  2,  3,  4.5,  50},
    VMea_flow_nominal = {-0.104508, -0.073896, -0.04674, -0.033048, -0.025596, -0.020904, -0.014784, 0, 0.014784, 0.020904, 0.025596, 0.031356,  0.031368})
   "Self regulating trickle vent"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
equation
  connect(weaDat.weaBus, west.weaBus) annotation (Line(
      points={{-70,-30},{-50,-30},{-50,-60},{90,-60},{90,-29.8}},
      color={255,204,51},
      thickness=0.5));
  connect(east.weaBus, weaDat.weaBus) annotation (Line(
      points={{-50,-29.8},{-50,-30},{-70,-30}},
      color={255,204,51},
      thickness=0.5));
  connect(TSet.y,con. u_s) annotation (Line(
      points={{-59,70},{-42,70}},
      color={0,0,127}));
  connect(temSen.T,con. u_m) annotation (Line(
      points={{-39,40},{-30,40},{-30,58}},
      color={0,0,127}));
  connect(gain.u,con. y) annotation (Line(
      points={{-2,70},{-19,70}},
      color={0,0,127}));
  connect(gain.y,preHea. Q_flow) annotation (Line(
      points={{21,70},{30,70},{30,60}},
      color={0,0,127}));
  connect(room.heatPort, temSen.port) annotation (Line(points={{10,-10},{10,20},
          {-60,20},{-60,40}},         color={191,0,0}));
  connect(preHea.port,room. heatPort) annotation (Line(points={{30,40},{30,20},
          {10,20},{10,-10}},        color={191,0,0}));
  connect(east.ports[1], tabDat_m_flow.port_a)
    annotation (Line(points={{-30,-30},{-20,-30}}, color={0,127,255}));
  connect(tabDat_m_flow.port_b,room. ports[1])
    annotation (Line(points={{0,-30},{19,-30},{19,-20}},  color={0,127,255}));
  connect(tabDat_V_flow.port_a,room. ports[2]) annotation (Line(points={{40,-30},{24,
          -30},{24,-20},{21,-20}}, color={0,127,255}));
  connect(tabDat_V_flow.port_b, west.ports[1])
    annotation (Line(points={{60,-30},{70,-30}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/TrickleVent.mos"
        "Simulate and plot"),
        experiment(
      StopTime=2592000,
      Interval=600,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model illustrates the use of the models
<a href=\"modelica://Buildings.Airflow.Multizone.Table_V_flow\">
Buildings.Airflow.Multizone.Table_V_flow</a>
and
<a href=\"modelica://Buildings.Airflow.Multizone.Table_m_flow\">
Buildings.Airflow.Multizone.Table_m_flow</a>
to model self regulating inlet vents.
The models are connected to a common volume that emulates a room on one side and
to outside conditions on the other side (east and west orientation respectively).
</p>
</html>", revisions="<html>
<ul>
<li>
February 2, 2022, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
</li>
<li>
May 03, 2021 by Klaas De Jonge:<br/>
Added example for simulating a trickle vent using the TableData models
</li>
</ul>
</html>"));
end TrickleVent;
