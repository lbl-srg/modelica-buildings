within Buildings.ThermalZones.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice.BaseClasses;
partial model PartialFloor "Interface for a model of a floor of a building"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model for air" annotation (choicesAllMatching=true);

  parameter Boolean use_windPressure=true
    "Set to true to enable wind pressure";

  parameter Real kIntNor(min=0, max=1) = 1
    "Gain factor to scale internal heat gain in north zone";

  parameter Modelica.SIunits.Volume VRooCor "Room volume corridor";
  parameter Modelica.SIunits.Volume VRooSou "Room volume south";
  parameter Modelica.SIunits.Volume VRooNor "Room volume north";
  parameter Modelica.SIunits.Volume VRooEas "Room volume east";
  parameter Modelica.SIunits.Volume VRooWes "Room volume west";

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsSou[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{70,-44},{110,-28}}),
        iconTransformation(extent={{78,-32},{118,-16}})));

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsEas[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{310,28},{350,44}}),
        iconTransformation(extent={{306,40},{346,56}})));

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsNor[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{70,116},{110,132}}),
        iconTransformation(extent={{78,108},{118,124}})));

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsWes[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-50,36},{-10,52}}),
        iconTransformation(extent={{-46,40},{-6,56}})));

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsCor[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{70,38},{110,54}}),
        iconTransformation(extent={{78,40},{118,56}})));

  Modelica.Blocks.Interfaces.RealOutput TRooAir[5](
    each unit="K",
    each displayUnit="degC") "Room air temperatures"
    annotation (Placement(transformation(extent={{380,150},{400,170}}),
        iconTransformation(extent={{380,40},{400,60}})));

  Modelica.Blocks.Interfaces.RealOutput p_rel
    "Relative pressure signal of building static pressure" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-170,220}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-90,50})));

  Modelica.Blocks.Math.MatrixGain gai(K=20*[0.4; 0.4; 0.2])
    "Matrix gain to split up heat gain in radiant, convective and latent gain"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=1)
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather bus"
    annotation (Placement(transformation(extent={{200,190},{220,210}})));

  Buildings.Examples.VAVReheat.ThermalZones.RoomLeakage leaSou(
    redeclare package Medium = Medium,
    VRoo=VRooSou,
    s=49.91/33.27,
    azi=Buildings.Types.Azimuth.S,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-58,380},{-22,420}})));
  Buildings.Examples.VAVReheat.ThermalZones.RoomLeakage leaEas(
    redeclare package Medium = Medium,
    VRoo=VRooEas,
    s=33.27/49.91,
    azi=Buildings.Types.Azimuth.E,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-58,340},{-22,380}})));

  Buildings.Examples.VAVReheat.ThermalZones.RoomLeakage leaNor(
    redeclare package Medium = Medium,
    VRoo=VRooNor,
    s=49.91/33.27,
    azi=Buildings.Types.Azimuth.N,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-56,300},{-20,340}})));

  Buildings.Examples.VAVReheat.ThermalZones.RoomLeakage leaWes(
    redeclare package Medium = Medium,
    VRoo=VRooWes,
    s=33.27/49.91,
    azi=Buildings.Types.Azimuth.W,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-56,260},{-20,300}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirSou
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{290,340},{310,360}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirEas
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{292,310},{312,330}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirNor
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{292,280},{312,300}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirWes
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{292,248},{312,268}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirPer5
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{294,218},{314,238}})));
  Modelica.Blocks.Routing.Multiplex5 multiplex5_1
    annotation (Placement(transformation(extent={{340,280},{360,300}})));

  Airflow.Multizone.DoorDiscretizedOpen opeSouCor(redeclare package Medium =
        Medium, wOpe=10,
    forceErrorControlOnFlow=false)
    "Opening between perimeter1 and core"
    annotation (Placement(transformation(extent={{84,0},{104,20}})));
  Airflow.Multizone.DoorDiscretizedOpen opeEasCor(redeclare package Medium =
        Medium, wOpe=10,
    forceErrorControlOnFlow=false)
    "Opening between perimeter2 and core"
    annotation (Placement(transformation(extent={{250,38},{270,58}})));
  Airflow.Multizone.DoorDiscretizedOpen opeNorCor(redeclare package Medium =
        Medium, wOpe=10,
    forceErrorControlOnFlow=false)
    "Opening between perimeter3 and core"
    annotation (Placement(transformation(extent={{80,74},{100,94}})));
  Airflow.Multizone.DoorDiscretizedOpen opeWesCor(redeclare package Medium =
        Medium, wOpe=10,
    forceErrorControlOnFlow=false)
    "Opening between perimeter3 and core"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiFra(
    table=[0,0.05;
           8,0.05;
           9,0.9;
           12,0.9;
           12,0.8;
           13,0.8;
           13,1;
           17,1;
           19,0.1;
           24,0.05],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Fraction of internal heat gain"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium = Medium)
    "Building pressure measurement"
    annotation (Placement(transformation(extent={{60,240},{40,260}})));
  Buildings.Fluid.Sources.Outside out(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-58,240},{-38,260}})));

  Modelica.Blocks.Math.Gain gaiIntNor[3](each k=kIntNor)
    "Gain for internal heat gain amplification for north zone"
    annotation (Placement(transformation(extent={{-60,134},{-40,154}})));
  Modelica.Blocks.Math.Gain gaiIntSou[3](each k=2 - kIntNor)
    "Gain to change the internal heat gain for south"
    annotation (Placement(transformation(extent={{-60,-38},{-40,-18}})));

equation
  connect(weaBus, leaSou.weaBus) annotation (Line(
      points={{210,200},{-80,200},{-80,400},{-58,400}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus, leaEas.weaBus) annotation (Line(
      points={{210,200},{-80,200},{-80,360},{-58,360}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus, leaNor.weaBus) annotation (Line(
      points={{210,200},{-80,200},{-80,320},{-56,320}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus, leaWes.weaBus) annotation (Line(
      points={{210,200},{-80,200},{-80,280},{-56,280}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(out.weaBus, weaBus) annotation (Line(
      points={{-58,250.2},{-70,250.2},{-70,250},{-80,250},{-80,200},{210,200}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(gai.y, gaiIntSou.u) annotation (Line(
      points={{-79,110},{-68,110},{-68,-28},{-62,-28}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gai.y, gaiIntNor.u) annotation (Line(
      points={{-79,110},{-68,110},{-68,144},{-62,144}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(intGaiFra.y, gai.u) annotation (Line(
      points={{-119,110},{-102,110}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(multiplex5_1.y, TRooAir) annotation (Line(
      points={{361,290},{372,290},{372,160},{390,160}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(temAirSou.T, multiplex5_1.u1[1]) annotation (Line(
      points={{310,350},{328,350},{328,300},{338,300}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(temAirEas.T, multiplex5_1.u2[1]) annotation (Line(
      points={{312,320},{324,320},{324,295},{338,295}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(temAirNor.T, multiplex5_1.u3[1]) annotation (Line(
      points={{312,290},{338,290}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(temAirWes.T, multiplex5_1.u4[1]) annotation (Line(
      points={{312,258},{324,258},{324,285},{338,285}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(temAirPer5.T, multiplex5_1.u5[1]) annotation (Line(
      points={{314,228},{322,228},{322,228},{332,228},{332,280},{338,280}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(uSha.y, replicator.u) annotation (Line(
      points={{-59,180},{-42,180}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(senRelPre.p_rel, p_rel) annotation (Line(
      points={{50,241},{50,220},{-170,220}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(out.ports[1], senRelPre.port_b) annotation (Line(
      points={{-38,250},{40,250}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
        extent={{-160,-100},{380,500}},
        initialScale=0.1)),   Icon(coordinateSystem(extent={{-80,-80},{380,160}},
        preserveAspectRatio=true),
         graphics={Rectangle(
          extent={{-80,160},{380,-80}},
          lineColor={95,95,95},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-118,94},{-96,60}},
          lineColor={0,0,255},
          textString="dP")}),
    Documentation(info="<html>
<p>
This is a partial model of one floor of the DOE reference office building.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 15, 2019, by Milica Grahovac:<br/>
First implementation of the partial floor model based on
elements that are in common for all floor models.
</li>
</ul>
</html>"));
end PartialFloor;
