within Buildings.ThermalZones.Detailed.Validation.SingleZoneFloor;
model SingleZoneFloorClosedLoop
  "Closed-loop validation for the base class SingleZoneFloor"
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

  Buildings.Examples.VAVReheat.ThermalZones.Floor flo(
    redeclare package Medium = Medium, lat=lat) "Five-zone floor model"
    annotation (Placement(transformation(extent={{12,38},{68,98}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  Buildings.ThermalZones.Detailed.Validation.SingleZoneFloor.BaseClasses.SingleZoneFloor sinZonFlo(
    redeclare package Medium = Medium, lat=lat) "Single-zone floor model"
    annotation (Placement(transformation(extent={{16,96},{56,136}})));
  Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=VRoo*6/3600*1.2,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    nominalValuesDefineDefaultPressureCurve=true) "Fan"
    annotation (Placement(transformation(extent={{-58,78},{-38,98}})));
  Controls.OBC.CDL.Continuous.LimPID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=480,
    yMax=1,
    yMin=0,
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC")) "Controller for heater"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Fluid.HeatExchangers.Heater_T hea(
    redeclare final package Medium = Medium,
    m_flow_nominal=VRoo*6/3600*1.2,
    dp_nominal=200,
    tau=0,
    show_T=true) "Ideal heater"
    annotation (Placement(transformation(extent={{-20,78},{0,98}})));
  Controls.OBC.CDL.Continuous.AddParameter addPar[6](
    each p=273.15 + 24,
    each k=60) "Compute the leaving water setpoint temperature"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Controls.OBC.CDL.Continuous.LimPID conPIDSou(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=480,
    yMax=1,
    yMin=0,
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC"))
    "Controller for heater in the south zone"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Fluid.HeatExchangers.Heater_T heaSou(
    redeclare final package Medium = Medium,
    m_flow_nominal=VRooSou*6/3600*1.2,
    dp_nominal=200,
    tau=0,
    show_T=true) "Ideal heater for south zone"
    annotation (Placement(transformation(extent={{-20,18},{0,38}})));
  Controls.OBC.CDL.Continuous.LimPID conPIDEas(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=480,
    yMax=1,
    yMin=0,
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC"))
    "Controller for heater in the east zone"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Fluid.HeatExchangers.Heater_T heaEas(
    redeclare final package Medium = Medium,
    m_flow_nominal=VRooNor*6/3600*1.2,
    dp_nominal=200,
    tau=0,
    show_T=true) "Ideal heater for east zone"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Controls.OBC.CDL.Continuous.LimPID conPIDNor(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=480,
    yMax=1,
    yMin=0,
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC"))
    "Controller for heater in the north zone"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Fluid.HeatExchangers.Heater_T heaNor(
    redeclare final package Medium = Medium,
    m_flow_nominal=VRooNor*6/3600*1.2,
    dp_nominal=200,
    tau=0,
    show_T=true) "Ideal heater for north zone"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Controls.OBC.CDL.Continuous.LimPID conPIDWes(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=480,
    yMax=1,
    yMin=0,
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC"))
    "Controller for heater in the west zone"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Fluid.HeatExchangers.Heater_T heaWes(
    redeclare final package Medium = Medium,
    m_flow_nominal=VRooWes*6/3600*1.2,
    dp_nominal=200,
    tau=0,
    show_T=true) "Ideal heater for west zone"
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  Controls.OBC.CDL.Continuous.LimPID conPIDCor(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=480,
    yMax=1,
    yMin=0,
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC"))
    "Controller for heater in the core zone"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Fluid.HeatExchangers.Heater_T heaCor(
    redeclare final package Medium = Medium,
    m_flow_nominal=VRooCor*6/3600*1.2,
    dp_nominal=200,
    tau=0,
    show_T=true) "Ideal heater for core zone"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  Fluid.Movers.FlowControlled_m_flow fanSou(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=VRooSou*6/3600*1.2,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    nominalValuesDefineDefaultPressureCurve=true) "Fan for the south zone"
    annotation (Placement(transformation(extent={{-60,18},{-40,38}})));
  Fluid.Movers.FlowControlled_m_flow fanEas(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=VRooEas*6/3600*1.2,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    nominalValuesDefineDefaultPressureCurve=true) "Fan for east zone"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Fluid.Movers.FlowControlled_m_flow fanNor(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=VRooNor*6/3600*1.2,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    nominalValuesDefineDefaultPressureCurve=true) "Fan for north zone"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Fluid.Movers.FlowControlled_m_flow fanWes(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=VRooWes*6/3600*1.2,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    nominalValuesDefineDefaultPressureCurve=true) "Fan for west zone"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Fluid.Movers.FlowControlled_m_flow fanCor(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=VRooCor*6/3600*1.2,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    nominalValuesDefineDefaultPressureCurve=true) "Fan for core zone"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSetRoo(k=273.15 + 22,
    y(unit="K", displayUnit="degC")) "Setpoint for room air"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Modelica.Blocks.Continuous.Integrator EHeaSinZon
    "Heating energy of single zone floor"
    annotation (Placement(transformation(extent={{88,86},{108,106}})));
  Modelica.Blocks.Continuous.Integrator EHeaSou
    "South zone heating energy"
    annotation (Placement(transformation(extent={{90,26},{110,46}})));
  Modelica.Blocks.Continuous.Integrator EHeaEas
    "East zone heating energy"
    annotation (Placement(transformation(extent={{90,-12},{110,8}})));
  Modelica.Blocks.Continuous.Integrator EHeaNor
    "North zone heating energy"
    annotation (Placement(transformation(extent={{90,-52},{110,-32}})));
  Modelica.Blocks.Continuous.Integrator EHeaWes
    "West zone heating energy"
    annotation (Placement(transformation(extent={{90,-92},{110,-72}})));
  Modelica.Blocks.Continuous.Integrator EHeaCor
    "Core zone heating energy"
    annotation (Placement(transformation(extent={{90,-132},{110,-112}})));
  Controls.OBC.CDL.Continuous.MultiSum EHeaFlo(nin=5)
    "Heating energy of five-zone floor"
    annotation (Placement(transformation(extent={{130,-52},{150,-32}})));
equation
  connect(weaDat.weaBus, flo.weaBus) annotation (Line(
      points={{0,140},{16,140},{16,68},{49,68}},
      color={255,204,51},
      thickness=0.5));
  connect(conPID.y,addPar[1].u)  annotation (Line(points={{-78,90},{-68,90},{-68,
          130},{-62,130}},                         color={0,0,127}));
  connect(addPar[1].y,hea.TSet) annotation (Line(points={{-38,130},{-30,130},{
          -30,96},{-22,96}},
                     color={0,0,127}));
  connect(fan.port_b,hea. port_a)   annotation (Line(points={{-38,88},{-20,88}},  color={0,127,
          255},
      thickness=0.5));
  connect(hea.port_b, sinZonFlo.ports[1]) annotation (Line(points={{0,88},{20,
          88},{20,104},{23.8,104}},
                                color={0,127,255},
      thickness=0.5));
  connect(fan.port_a, sinZonFlo.ports[2]) annotation (Line(points={{-58,88},{
          -64,88},{-64,106},{20,106},{20,104},{25.8,104}},
                                                       color={0,127,255},
      thickness=0.5));
  connect(flo.TRooAir[1], conPIDSou.u_m) annotation (Line(points={{67,63.2},{72,
          63.2},{72,10},{-90,10},{-90,18}},  color={0,0,127}));
  connect(flo.TRooAir[2], conPIDEas.u_m) annotation (Line(points={{67,63.6},{72,
          63.6},{72,-26},{-90,-26},{-90,-22}},  color={0,0,127}));
  connect(flo.TRooAir[3], conPIDNor.u_m) annotation (Line(points={{67,64},{72,64},
          {72,-66},{-90,-66},{-90,-62}},  color={0,0,127}));
  connect(flo.TRooAir[4], conPIDWes.u_m) annotation (Line(points={{67,64.4},{72,
          64.4},{72,-106},{-90,-106},{-90,-102}},  color={0,0,127}));
  connect(flo.TRooAir[5], conPIDCor.u_m) annotation (Line(points={{67,64.8},{72,
          64.8},{72,-148},{-90,-148},{-90,-142}},  color={0,0,127}));
  connect(conPIDSou.y, addPar[2].u) annotation (Line(points={{-78,30},{-68,30},{
          -68,130},{-62,130}}, color={0,0,127}));
  connect(fanSou.port_b, heaSou.port_a)   annotation (Line(points={{-40,28},{-20,
          28}},                                                                      color={0,127,
          255},
      thickness=0.5));
  connect(fanEas.port_b, heaEas.port_a)   annotation (Line(points={{-40,-10},{-20,
          -10}},                                                                     color={0,127,
          255},
      thickness=0.5));
  connect(fanNor.port_b, heaNor.port_a)   annotation (Line(points={{-40,-50},{-20,
          -50}},                                                                        color={0,127,
          255},
      thickness=0.5));
  connect(fanWes.port_b, heaWes.port_a)   annotation (Line(points={{-40,-90},{-20,
          -90}},                                                                       color={0,127,
          255},
      thickness=0.5));
  connect(fanCor.port_b, heaCor.port_a)   annotation (Line(points={{-40,-130},{-20,
          -130}},                                                                        color={0,127,
          255},
      thickness=0.5));
  connect(conPIDEas.y, addPar[3].u) annotation (Line(points={{-78,-10},{-68,-10},
          {-68,130},{-62,130}}, color={0,0,127}));
  connect(addPar[3].y, heaEas.TSet) annotation (Line(points={{-38,130},{-30,130},
          {-30,-2},{-22,-2}},
                           color={0,0,127}));
  connect(addPar[2].y, heaSou.TSet) annotation (Line(points={{-38,130},{-30,130},
          {-30,36},{-22,36}},color={0,0,127}));
  connect(addPar[4].y, heaNor.TSet) annotation (Line(points={{-38,130},{-30,130},
          {-30,-42},{-22,-42}},color={0,0,127}));
  connect(addPar[5].y, heaWes.TSet) annotation (Line(points={{-38,130},{-30,130},
          {-30,-82},{-22,-82}},color={0,0,127}));
  connect(addPar[6].y, heaCor.TSet) annotation (Line(points={{-38,130},{-30,130},
          {-30,-122},{-22,-122}},color={0,0,127}));
  connect(conPIDNor.y, addPar[4].u) annotation (Line(points={{-78,-50},{-68,-50},
          {-68,130},{-62,130}}, color={0,0,127}));
  connect(conPIDWes.y, addPar[5].u) annotation (Line(points={{-78,-90},{-68,-90},
          {-68,130},{-62,130}}, color={0,0,127}));
  connect(conPIDCor.y, addPar[6].u) annotation (Line(points={{-78,-130},{-68,-130},
          {-68,130},{-62,130}}, color={0,0,127}));
  connect(heaSou.port_b, flo.portsSou[1]) annotation (Line(points={{0,28},{36,28},
          {36,44.6}},                                                                           color={0,127,
          255},
      thickness=0.5));
  connect(fanSou.port_a, flo.portsSou[2]) annotation (Line(points={{-60,28},{-64,
          28},{-64,46},{38,46},{38,44.6}}, color={0,127,255},
      thickness=0.5));
  connect(heaEas.port_b, flo.portsEas[1]) annotation (Line(points={{0,-10},{60.4,
          -10},{60.4,51.6}},color={0,127,255},
      thickness=0.5));
  connect(fanEas.port_a, flo.portsEas[2]) annotation (Line(points={{-60,-10},{-64,
          -10},{-64,6},{62.4,6},{62.4,51.6}},color={0,127,255},
      thickness=0.5));
  connect(heaNor.port_b, flo.portsNor[1]) annotation (Line(points={{0,-50},{44,-50},
          {44,60.6},{36,60.6}},      color={0,127,255},
      thickness=0.5));
  connect(fanNor.port_a, flo.portsNor[2]) annotation (Line(points={{-60,-50},{-64,
          -50},{-64,-34},{44,-34},{44,60.6},{38,60.6}}, color={0,127,255},
      thickness=0.5));
  connect(heaWes.port_b, flo.portsWes[1]) annotation (Line(points={{0,-90},{26,-90},
          {26,52.6},{24,52.6}},      color={0,127,255},
      thickness=0.5));
  connect(fanWes.port_a, flo.portsWes[2]) annotation (Line(points={{-60,-90},{-64,
          -90},{-64,-74},{26,-74},{26,52.6}}, color={0,127,255},
      thickness=0.5));
  connect(heaCor.port_b, flo.portsCor[1]) annotation (Line(points={{0,-130},{54,
          -130},{54,54},{36,54},{36,52.6}}, color={0,127,255},
      thickness=0.5));
  connect(fanCor.port_a, flo.portsCor[2]) annotation (Line(points={{-60,-130},{-64,
          -130},{-64,-114},{54,-114},{54,52.6},{38,52.6}}, color={0,127,255},
      thickness=0.5));
  connect(sinZonFlo.TRooAir, conPID.u_m) annotation (Line(points={{53,126.2},{60,
          126.2},{60,72},{-90,72},{-90,78}},    color={0,0,127}));
  connect(TSetRoo.y, conPID.u_s)    annotation (Line(points={{-118,90},{-102,90}},
                                                                                 color={0,0,127}));
  connect(TSetRoo.y, conPIDSou.u_s) annotation (Line(points={{-118,90},{-110,90},
          {-110,30},{-102,30}},
                             color={0,0,127}));
  connect(TSetRoo.y, conPIDEas.u_s) annotation (Line(points={{-118,90},{-110,90},
          {-110,-10},{-102,-10}},
                               color={0,0,127}));
  connect(TSetRoo.y, conPIDNor.u_s) annotation (Line(points={{-118,90},{-110,90},
          {-110,-50},{-102,-50}},
                               color={0,0,127}));
  connect(TSetRoo.y, conPIDWes.u_s) annotation (Line(points={{-118,90},{-110,90},
          {-110,-90},{-102,-90}},
                               color={0,0,127}));
  connect(TSetRoo.y, conPIDCor.u_s) annotation (Line(points={{-118,90},{-110,90},
          {-110,-130},{-102,-130}},
                                 color={0,0,127}));
  connect(hea.Q_flow,EHeaSinZon. u)   annotation (Line(points={{1,96},{86,96}},               color={0,0,127},
      pattern=LinePattern.Dot));
  connect(weaDat.weaBus, sinZonFlo.weaBus) annotation (Line(
      points={{0,140},{22.8,140},{22.8,133}},
      color={255,204,51},
      thickness=0.5));
  connect(heaSou.Q_flow, EHeaSou.u)  annotation (Line(points={{1,36},{88,36}}, color={0,0,127},
      pattern=LinePattern.Dot));
  connect(heaEas.Q_flow, EHeaEas.u)  annotation (Line(points={{1,-2},{88,-2}}, color={0,0,127},
      pattern=LinePattern.Dot));
  connect(heaNor.Q_flow, EHeaNor.u)  annotation (Line(points={{1,-42},{88,-42}}, color={0,0,127},
      pattern=LinePattern.Dot));
  connect(heaWes.Q_flow, EHeaWes.u)  annotation (Line(points={{1,-82},{88,-82}}, color={0,0,127},
      pattern=LinePattern.Dot));
  connect(heaCor.Q_flow, EHeaCor.u)  annotation (Line(points={{1,-122},{88,-122}}, color={0,0,127},
      pattern=LinePattern.Dot));
  connect(EHeaSou.y, EHeaFlo.u[1]) annotation (Line(points={{111,36},{120,36},{
          120,-40.4},{128,-40.4}}, color={0,0,127},
      pattern=LinePattern.Dot));
  connect(EHeaEas.y, EHeaFlo.u[2]) annotation (Line(points={{111,-2},{120,-2},{
          120,-41.2},{128,-41.2}}, color={0,0,127},
      pattern=LinePattern.Dot));
  connect(EHeaNor.y, EHeaFlo.u[3]) annotation (Line(points={{111,-42},{120,-42},
          {120,-42},{128,-42}}, color={0,0,127},
      pattern=LinePattern.Dot));
  connect(EHeaWes.y, EHeaFlo.u[4]) annotation (Line(points={{111,-82},{120,-82},
          {120,-43.3333},{128,-43.3333},{128,-42.8}}, color={0,0,127},
      pattern=LinePattern.Dot));
  connect(EHeaCor.y, EHeaFlo.u[5]) annotation (Line(points={{111,-122},{120,-122},
          {120,-41.5},{128,-41.5},{128,-43.6}}, color={0,0,127},
      pattern=LinePattern.Dot));
  annotation (
  experiment(
      StopTime=604800,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/SingleZoneFloor/SingleZoneFloorClosedLoop.mos"
        "Simulate and plot"),
  Documentation(info="
  <html>
  <p>
  This model compares the heating demand of the single-zone building model 
  <a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.SingleZoneFloor.BaseClasses.SingleZoneFloor\">
  Buildings.ThermalZones.Detailed.Validation.SingleZoneFloor.BaseClasses.SingleZoneFloor</a> 
  with the total heating demand of the five-zone building model
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})));
end SingleZoneFloorClosedLoop;
