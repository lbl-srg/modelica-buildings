within Buildings.ThermalZones.Detailed.Validation;
model SingleZoneFloorWithHeating
  "Validation model for SingleZoneFloor with heating and control"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Buildings library air media package";
  parameter Modelica.SIunits.Angle lat=41.98*3.14159/180
    "Latitude of site location";

  parameter Modelica.SIunits.Area AFloCor=flo.cor.AFlo "Floor area corridor";
  parameter Modelica.SIunits.Area AFloSou=flo.sou.AFlo "Floor area south";
  parameter Modelica.SIunits.Area AFloNor=flo.nor.AFlo "Floor area north";
  parameter Modelica.SIunits.Area AFloEas=flo.eas.AFlo "Floor area east";
  parameter Modelica.SIunits.Area AFloWes=flo.wes.AFlo "Floor area west";

  parameter Modelica.SIunits.Volume VRooCor=AFloCor*flo.hRoo
    "Room volume corridor";
  parameter Modelica.SIunits.Volume VRooSou=AFloSou*flo.hRoo
    "Room volume south";
  parameter Modelica.SIunits.Volume VRooNor=AFloNor*flo.hRoo
    "Room volume north";
  parameter Modelica.SIunits.Volume VRooEas=AFloEas*flo.hRoo
    "Room volume east";
  parameter Modelica.SIunits.Volume VRooWes=AFloWes*flo.hRoo
    "Room volume west";
  parameter Modelica.SIunits.Volume VRoo=VRooSou+VRooEas+VRooNor+VRooWes+VRooCor
    "Total floor volume";

  Buildings.Examples.VAVReheat.BaseClasses.Floor flo(
    redeclare package Medium = Medium,
    use_windPressure=false,
    lat=lat,
    gai(K=0*[0.4; 0.4; 0.2])) "Five-zone floor model"
    annotation (Placement(transformation(extent={{-8,48},{48,108}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false)
    "Weather data"
    annotation (Placement(transformation(extent={{-40,134},{-20,154}})));
  Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor sinZonFlo(
    redeclare package Medium = Medium,
    use_windPressure=false,
    lat=lat,
    gai(K=0*[0.4; 0.4; 0.2]))
    "Single-zone floor model"
    annotation (Placement(transformation(extent={{66,106},{106,146}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRoo(k=273.15 + 22,
      y(unit="K", displayUnit="degC")) "Setpoint for room air"
    annotation (Placement(transformation(extent={{-120,84},{-100,104}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum EHeaFlo(nin=5)
    "Heating energy of the five-zone floor"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloorHeater heaAndCon(
    redeclare package Medium=Medium,
    m_flow_nominal=VRoo*3/3600*1.2,
    VRoo=VRoo) "Heater and controller for the singleZoneFloor"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloorHeater heaAndConNor(
    redeclare package Medium = Medium,
    m_flow_nominal=VRooNor*3/3600*1.2,
    VRoo=VRooNor) "Heater and controller for the north zone"
    annotation (Placement(transformation(extent={{-60,22},{-40,42}})));
  Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloorHeater heaAndConWes(
    redeclare package Medium = Medium,
    m_flow_nominal=VRooWes*3/3600*1.2,
    VRoo=VRooWes) "Heater and controller for the west zone"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloorHeater heaAndConCor(
    redeclare package Medium = Medium,
    m_flow_nominal=VRooCor*3/3600*1.2,
    VRoo=VRooCor) "Heater and controller for the core zone"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloorHeater heaAndConSou(
    redeclare package Medium = Medium,
    m_flow_nominal=VRooSou*6/3600*1.2,
    VRoo=VRooSou) "Heater and controller for the south zone"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloorHeater heaAndConEas(
    redeclare package Medium = Medium,
    m_flow_nominal=VRooEas*3/3600*1.2,
    VRoo=VRooEas) "Heater and controller for the east zone"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
equation
  connect(weaDat.weaBus, flo.weaBus) annotation (Line(
      points={{-20,144},{28,144},{28,112.615},{27.3043,112.615}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, sinZonFlo.weaBus) annotation (Line(
      points={{-20,144},{72.8,144},{72.8,143}},
      color={255,204,51},
      thickness=0.5));
  connect(TSetRoo.y, heaAndCon.TSetRoo)   annotation (Line(points={{-98,94},{
          -62,94}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(heaAndCon.port_a, sinZonFlo.ports[1]) annotation (Line(points={{-60,100},
          {-66,100},{-66,118},{74,118},{74,114},{73.8,114}},
                                          color={0,127,255}));
  connect(heaAndCon.port_b, sinZonFlo.ports[2]) annotation (Line(points={{-40,100},
          {-30,100},{-30,118},{74,118},{74,114},{75.8,114}},
                                                           color={0,127,255}));
  connect(heaAndConNor.port_b, flo.portsNor[2]) annotation (Line(points={{-40,32},
          {-20,32},{-20,93.2308},{14.887,93.2308}},
                                                 color={0,127,255}));
  connect(heaAndConWes.port_a, flo.portsWes[1]) annotation (Line(points={{-60,-10},
          {-68,-10},{-68,6},{-8,6},{-8,77.5385},{-2.64348,77.5385}},
                                              color={0,127,255}));
  connect(heaAndConWes.port_b, flo.portsWes[2]) annotation (Line(points={{-40,-10},
          {-4,-10},{-4,77.5385},{-0.208696,77.5385}},
                                                  color={0,127,255}));
  connect(heaAndConCor.port_a, flo.portsCor[1]) annotation (Line(points={{-60,-50},
          {-68,-50},{-68,-34},{8,-34},{8,77.5385},{12.4522,77.5385}},
                                                 color={0,127,255}));
  connect(heaAndConCor.port_b, flo.portsCor[2]) annotation (Line(points={{-40,-50},
          {10,-50},{10,77.5385},{14.887,77.5385}}, color={0,127,255}));
  connect(heaAndConSou.port_a, flo.portsSou[1]) annotation (Line(points={{-60,-90},
          {-68,-90},{-68,-74},{12.4522,-74},{12.4522,60.9231}},
                                         color={0,127,255}));
  connect(heaAndConSou.port_b, flo.portsSou[2]) annotation (Line(points={{-40,-90},
          {14.887,-90},{14.887,60.9231}},  color={0,127,255}));
  connect(heaAndConEas.port_a, flo.portsEas[1]) annotation (Line(points={{-60,
          -130},{-68,-130},{-68,-114},{40.2087,-114},{40.2087,77.5385}},
                                               color={0,127,255}));
  connect(heaAndConEas.port_b, flo.portsEas[2]) annotation (Line(points={{-40,
          -130},{44,-130},{44,77.5385},{42.6435,77.5385}},
                                                       color={0,127,255}));
  connect(TSetRoo.y, heaAndConNor.TSetRoo) annotation (Line(points={{-98,94},{
          -80,94},{-80,26},{-62,26}},
                                  color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TSetRoo.y, heaAndConWes.TSetRoo) annotation (Line(points={{-98,94},{
          -80,94},{-80,-16},{-62,-16}},
                                    color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TSetRoo.y, heaAndConCor.TSetRoo) annotation (Line(points={{-98,94},{
          -80,94},{-80,-56},{-62,-56}},
                                    color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TSetRoo.y, heaAndConSou.TSetRoo) annotation (Line(points={{-98,94},{
          -80,94},{-80,-96},{-62,-96}},
                                    color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TSetRoo.y, heaAndConEas.TSetRoo) annotation (Line(points={{-98,94},{
          -80,94},{-80,-136},{-62,-136}},
                                      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(flo.TRooAir[3], heaAndConNor.TRooMea) annotation (Line(points={{49.2174,
          78},{56,78},{56,14},{-68,14},{-68,23},{-62,23}},
                                                     color={0,0,127},
      pattern=LinePattern.Dash));
  connect(flo.TRooAir[4], heaAndConWes.TRooMea) annotation (Line(points={{49.2174,
          78.9231},{56,78.9231},{56,-28},{-66,-28},{-66,-19},{-62,-19}},
                                                             color={0,0,127},
      pattern=LinePattern.Dash));
  connect(flo.TRooAir[5], heaAndConCor.TRooMea) annotation (Line(points={{49.2174,
          79.8462},{56,79.8462},{56,-68},{-66,-68},{-66,-59},{-62,-59}},
                                                             color={0,0,127},
      pattern=LinePattern.Dash));
  connect(flo.TRooAir[1], heaAndConSou.TRooMea) annotation (Line(points={{49.2174,
          76.1538},{56,76.1538},{56,-108},{-66,-108},{-66,-99},{-62,-99}},
                                                                 color={0,0,127},
      pattern=LinePattern.Dash));
  connect(flo.TRooAir[2], heaAndConEas.TRooMea) annotation (Line(points={{49.2174,
          77.0769},{56,77.0769},{56,-148},{-66,-148},{-66,-139},{-62,-139}},
                                                                 color={0,0,127},
      pattern=LinePattern.Dash));
  connect(heaAndConNor.yEHea, EHeaFlo.u[1]) annotation (Line(points={{-38,24},{70,
          24},{70,-38.4},{78,-38.4}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(heaAndConWes.yEHea, EHeaFlo.u[2]) annotation (Line(points={{-38,-18},{
          70,-18},{70,-39.2},{78,-39.2}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(heaAndConCor.yEHea, EHeaFlo.u[3]) annotation (Line(points={{-38,-58},{
          70,-58},{70,-40},{78,-40}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(heaAndConSou.yEHea, EHeaFlo.u[4]) annotation (Line(points={{-38,-98},{
          70,-98},{70,-40.8},{78,-40.8}},   color={0,0,127},
      pattern=LinePattern.Dash));
  connect(heaAndConEas.yEHea, EHeaFlo.u[5]) annotation (Line(points={{-38,-138},
          {70,-138},{70,-40.5},{78,-40.5},{78,-41.6}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(heaAndConNor.port_a, flo.portsNor[1]) annotation (Line(points={{-60,32},
          {-68,32},{-68,60},{-26,60},{-26,93.2308},{12.4522,93.2308}},
                                          color={0,127,255}));
  connect(sinZonFlo.TRooAir, heaAndCon.TRooMea) annotation (Line(
      points={{103,136.2},{106,136.2},{106,136},{108,136},{108,158},{-68,158},{
          -68,91},{-62,91}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (
  experiment(
      StopTime=604800,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/SingleZoneFloorWithHeating.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This model compares the heating energy demand of a single-zone floor model
<a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor\">
Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor</a>
with the total heating energy demand of a five-zone floor model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Floor\">
Buildings.Examples.VAVReheat.BaseClasses.Floor</a>.
</p>
<p>
The nominal mass flowrate of the single zone floor model is consistent with the
total nominal flowrate of the five-zone floor model. The heating energy is
calculated via an ideal heater.
</p>
</html>",
revisions="
<html>
<ul>
<li>
March 10, 2020, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{120,160}})));
end SingleZoneFloorWithHeating;
