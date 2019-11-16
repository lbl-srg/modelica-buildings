within Buildings.Experimental.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice.BaseClasses;
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
        iconTransformation(extent={{-20,-80},{20,-64}})));

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsEas[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{310,28},{350,44}}),
        iconTransformation(extent={{50,-8},{90,8}})));

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsNor[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{70,116},{110,132}}),
        iconTransformation(extent={{-20,60},{20,76}})));

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsWes[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-50,36},{-10,52}}),
        iconTransformation(extent={{-88,-8},{-48,8}})));

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsCor[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{70,38},{110,54}}),
        iconTransformation(extent={{-20,-8},{20,8}})));

  Modelica.Blocks.Interfaces.RealOutput TRooAir[5](
    each unit="K",
    each displayUnit="degC") "Room air temperatures"
    annotation (Placement(transformation(extent={{380,150},{400,170}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput p_rel
    "Relative pressure signal of building static pressure" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-170,220}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,0})));

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

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-100},
            {400,500}}, initialScale=0.1)),
    Documentation(info="<html>
<p>
This is a partial floor model used to constrain the replaceable thermal zone classes and
ensure those are plug compatible.
fixme: this model should live somewhere else as the ThermalZone.Floor also extends it
</p>
</html>",
revisions="<html>
<ul>
<li>
November 15, 2019, by Milica Grahovac:<br/>
First implementation of the partial floor model based on
common floor model elements.
</li>
</ul>
</html>"),
    Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={95,95,95},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}));
end PartialFloor;
