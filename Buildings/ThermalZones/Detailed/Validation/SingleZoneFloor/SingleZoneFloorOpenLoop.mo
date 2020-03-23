within Buildings.ThermalZones.Detailed.Validation.SingleZoneFloor;
model SingleZoneFloorOpenLoop
  "Open loop validation for the base class SingleZoneFloor"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Buildings library air media package";
  parameter Modelica.SIunits.Angle lat=41.98*3.14159/180 "Latitude of site location";

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

  Buildings.Examples.VAVReheat.ThermalZones.Floor flo(
    redeclare package Medium = Medium, lat=lat) "Five-zone floor model"
    annotation (Placement(transformation(extent={{12,-18},{68,42}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.ThermalZones.Detailed.Validation.SingleZoneFloor.BaseClasses.SingleZoneFloor sinZonFlo(
    redeclare package Medium = Medium, lat=lat) "Single-zone floor model"
    annotation (Placement(transformation(extent={{-8,56},{32,96}})));
  Fluid.FixedResistances.PressureDrop duc(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=VRoo*6/3600*1.2)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-20,10},{-40,30}})));
  Fluid.Sources.MassFlowSource_T bou(
    redeclare package Medium = Medium,
    m_flow=0,
    T=293.15,
    nPorts=6)
    "Boundary condition"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Fluid.Sources.Boundary_pT freAir(redeclare package Medium = Medium, nPorts=6)
    "Boundary condition"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Fluid.FixedResistances.PressureDrop ducSou(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=VRooSou*6/3600*1.2)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-20,-30},{-40,-10}})));
  Fluid.FixedResistances.PressureDrop ducEas(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=VRooEas*6/3600*1.2)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-20,-50},{-40,-30}})));
  Fluid.FixedResistances.PressureDrop ducNor(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=VRooNor*6/3600*1.2)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-20,-70},{-40,-50}})));
  Fluid.FixedResistances.PressureDrop ducWes(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=VRooWes*6/3600*1.2)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-20,-90},{-40,-70}})));
  Fluid.FixedResistances.PressureDrop ducCor(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=VRooCor*6/3600*1.2)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-20,-110},{-40,-90}})));
equation
  connect(weaDat.weaBus, flo.weaBus) annotation (Line(
      points={{80,80},{88,80},{88,12},{49,12}},
      color={255,204,51},
      thickness=0.5));
  connect(freAir.ports[1], duc.port_b) annotation (Line(points={{-60,23.3333},{
          -50,23.3333},{-50,20},{-40,20}},
                                       color={0,127,255}));
  connect(duc.port_a, sinZonFlo.ports[1]) annotation (Line(points={{-20,20},{-0.2,
          20},{-0.2,64}}, color={0,127,255}));
  connect(bou.ports[1], sinZonFlo.ports[1]) annotation (Line(points={{-60,
          53.3333},{-2,53.3333},{-2,64},{-0.2,64}},
                                 color={0,127,255}));
  connect(ducSou.port_a, flo.portsSou[1]) annotation (Line(points={{-20,-20},{
          32,-20},{32,-12},{36,-12},{36,-11.4}},
                            color={0,127,255}));
  connect(ducEas.port_a, flo.portsEas[1]) annotation (Line(points={{-20,-40},{
          62,-40},{62,-4.4},{60.4,-4.4}},
                                       color={0,127,255}));
  connect(ducNor.port_a, flo.portsNor[1]) annotation (Line(points={{-20,-60},{
          50,-60},{50,4},{44,4},{44,4.6},{36,4.6}},
                                   color={0,127,255}));
  connect(ducWes.port_a, flo.portsWes[1]) annotation (Line(points={{-20,-80},{
          22,-80},{22,-4},{24,-4},{24,-3.4}},
                                     color={0,127,255}));
  connect(ducCor.port_a, flo.portsCor[1]) annotation (Line(points={{-20,-100},{44,
          -100},{44,-3.4},{36,-3.4}}, color={0,127,255}));
  connect(freAir.ports[2], ducSou.port_b) annotation (Line(points={{-60,22},{-52,
          22},{-52,-20},{-40,-20}}, color={0,127,255}));
  connect(freAir.ports[3], ducEas.port_b) annotation (Line(points={{-60,20.6667},
          {-52,20.6667},{-52,-40},{-40,-40}}, color={0,127,255}));
  connect(freAir.ports[4], ducNor.port_b) annotation (Line(points={{-60,19.3333},
          {-52,19.3333},{-52,-60},{-40,-60}}, color={0,127,255}));
  connect(freAir.ports[5], ducWes.port_b) annotation (Line(points={{-60,18},{-52,
          18},{-52,-80},{-40,-80}}, color={0,127,255}));
  connect(freAir.ports[6], ducCor.port_b) annotation (Line(points={{-60,16.6667},
          {-52,16.6667},{-52,-100},{-40,-100}}, color={0,127,255}));
  connect(bou.ports[2], flo.portsWes[2]) annotation (Line(points={{-60,52},{22,
          52},{22,-3.4},{26,-3.4}},         color={0,127,255}));
  connect(bou.ports[3], flo.portsNor[2]) annotation (Line(points={{-60,50.6667},
          {-60,52},{50,52},{50,4},{38,4},{38,4.6}},
                                     color={0,127,255}));
  connect(bou.ports[4], flo.portsCor[2]) annotation (Line(points={{-60,49.3333},
          {44,49.3333},{44,-4},{38,-4},{38,-3.4}},
                                      color={0,127,255}));
  connect(bou.ports[5], flo.portsEas[2]) annotation (Line(points={{-60,48},{
          62.4,48},{62.4,-4.4}},       color={0,127,255}));
  connect(bou.ports[6], flo.portsSou[2]) annotation (Line(points={{-60,46.6667},
          {-60,44},{32,44},{32,-11.4},{38,-11.4}},               color={0,127,255}));
  connect(weaDat.weaBus, sinZonFlo.weaBus) annotation (Line(
      points={{80,80},{88,80},{88,108},{-1.2,108},{-1.2,93}},
      color={255,204,51},
      thickness=0.5));
  annotation (
  experiment(
      StopTime=86400,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/SingleZoneFloor/SingleZoneFloorOpenLoop.mos"
        "Simulate and plot"),
  Documentation(info="
  <html>
  <p>
  This model compares the outputs of the single-zone building model 
  <a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.SingleZoneFloor.BaseClasses.SingleZoneFloor\">
  Buildings.ThermalZones.Detailed.Validation.SingleZoneFloor.BaseClasses.SingleZoneFloor</a> 
  with the outputs of the five-zone building model
  <a href=\"modelica://Buildings.Examples.VAVReheat.ThermalZones.Floor\">
  Buildings.Examples.VAVReheat.ThermalZones.Floor</a>.
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
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,120}})));
end SingleZoneFloorOpenLoop;
