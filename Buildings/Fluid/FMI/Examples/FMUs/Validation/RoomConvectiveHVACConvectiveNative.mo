within Buildings.Fluid.FMI.Examples.FMUs.Validation;
block RoomConvectiveHVACConvectiveNative
  "Simple thermal zone with convective HVAC system."
 extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air "Medium for air";
  replaceable package MediumW = Buildings.Media.Water "Medium for water";

  parameter Boolean use_p_in = false
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);
  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";
  //////////////////////////////////////////////////////////
  // Heat recovery effectiveness
  parameter Real eps = 0.8 "Heat recovery effectiveness";

  /////////////////////////////////////////////////////////
  // Air temperatures at design conditions
  parameter Modelica.SIunits.Temperature TASup_nominal = 273.15+18
    "Nominal air temperature supplied to room";
  parameter Modelica.SIunits.Temperature TRooSet = 273.15+24
    "Nominal room air temperature";
  parameter Modelica.SIunits.Temperature TOut_nominal = 273.15+30
    "Design outlet air temperature";
  parameter Modelica.SIunits.Temperature THeaRecLvg=
    TOut_nominal - eps*(TOut_nominal-TRooSet)
    "Air temperature leaving the heat recovery";

  /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow=
     1000 "Internal heat gains of the room";
  parameter Modelica.SIunits.HeatFlowRate QRooC_flow_nominal=
    -QRooInt_flow-10E3/30*(TOut_nominal-TRooSet)
    "Nominal cooling load of the room";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal=
    1.3*QRooC_flow_nominal/1006/(TASup_nominal-TRooSet)
    "Nominal air mass flow rate, increased by factor 1.3 to allow for recovery after temperature setback";
  parameter Modelica.SIunits.TemperatureDifference dTFan = 2
    "Estimated temperature raise across fan that needs to be made up by the cooling coil";
  parameter Modelica.SIunits.HeatFlowRate QCoiC_flow_nominal=4*
    (QRooC_flow_nominal + mA_flow_nominal*(TASup_nominal-THeaRecLvg-dTFan)*1006)
    "Cooling load of coil, taking into account economizer, and increased due to latent heat removal";

  /////////////////////////////////////////////////////////
  // Water temperatures and mass flow rates
  parameter Modelica.SIunits.Temperature TWSup_nominal = 273.15+16
    "Water supply temperature";
  parameter Modelica.SIunits.Temperature TWRet_nominal = 273.15+12
    "Water return temperature";
  parameter Modelica.SIunits.MassFlowRate mW_flow_nominal=
    QCoiC_flow_nominal/(TWRet_nominal-TWSup_nominal)/4200
    "Nominal water mass flow rate";

  Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal) "Supply air fan"
    annotation (Placement(transformation(extent={{-26,56},{-6,76}})));
  HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=mA_flow_nominal,
    m2_flow_nominal=mA_flow_nominal,
    dp1_nominal=200,
    dp2_nominal=200,
    eps=eps,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal) "Heat recovery"
    annotation (Placement(transformation(extent={{-176,46},{-156,66}})));
  HeatExchangers.WetCoilCounterFlow cooCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=mW_flow_nominal,
    m2_flow_nominal=mA_flow_nominal,
    dp1_nominal=6000,
    UA_nominal=-QCoiC_flow_nominal/
        Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1=THeaRecLvg,
        T_b1=TASup_nominal,
        T_a2=TWSup_nominal,
        T_b2=TWRet_nominal),
    dp2_nominal=200,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal) "Cooling coil"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-96,56})));
  Sources.Outside out(
    nPorts=2,
    redeclare package Medium = MediumA) "Outside air boundary condition"
    annotation (Placement(transformation(extent={{-206,50},{-186,70}})));
  Sources.MassFlowSource_T souWat(
    nPorts=1,
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    T=TWSup_nominal) "Source for water flow rate"
    annotation (Placement(transformation(extent={{-106,-28},{-86,-8}})));
  Sources.FixedBoundary sinWat(
    nPorts=1,
    redeclare package Medium = MediumW) "Sink for water circuit"
    annotation (Placement(transformation(extent={{-146,6},{-126,26}})));
  Modelica.Blocks.Sources.Constant mAir_flow(k=mA_flow_nominal)
    "Fan air flow rate"
    annotation (Placement(transformation(extent={{-66,82},{-46,102}})));
  Sensors.TemperatureTwoPort senTemHXOut(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    allowFlowReversal=allowFlowReversal)
    "Temperature sensor for heat recovery outlet on supply side"
    annotation (Placement(transformation(extent={{-142,60},{-130,72}})));
  Sensors.TemperatureTwoPort senTemSupAir(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{-60,60},{-48,72}})));
  Modelica.Blocks.Logical.OnOffController con(bandwidth=1)
    "Controller for coil water flow rate"
    annotation (Placement(transformation(extent={{-186,-28},{-166,-8}})));
  Modelica.Blocks.Sources.Constant TRooSetPoi(k=TRooSet)
    "Room temperature set point"
    annotation (Placement(transformation(extent={{-232,-22},{-212,-2}})));
  Modelica.Blocks.Math.BooleanToReal mWat_flow(
    realTrue = 0,
    realFalse = mW_flow_nominal)
    "Conversion from boolean to real for water flow rate"
    annotation (Placement(transformation(extent={{-146,-28},{-126,-8}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=TOut_nominal,
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,
    computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{-226,96},{-206,116}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-142,94},{-122,114}}),
        iconTransformation(extent={{-142,94},{-122,114}})));
  Modelica.Blocks.Interfaces.RealOutput TOut(final unit="K")
    "Outdoor temperature" annotation (Placement(transformation(extent={{-20,-20},
            {20,20}},
        rotation=90,
        origin={-80,140}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-80,140})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat1(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=TOut_nominal,
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,
    computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{242,98},{222,118}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                         TOut1
    "Outside temperature"
    annotation (Placement(transformation(extent={{124,-10},{144,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{164,-10},{184,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow=
        QRooInt_flow) "Prescribed heat flow"
    annotation (Placement(transformation(extent={{240,40},{220,60}})));
  MixingVolumes.MixingVolumeMoistAir
                                   vol(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    V=V,
    mSenFac=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2)
    annotation (Placement(transformation(extent={{230,-36},{250,-16}})));
  BoundaryConditions.WeatherData.Bus weaBus1 "Weather data bus"
    annotation (Placement(transformation(extent={{132,96},{152,116}}),
        iconTransformation(extent={{132,96},{152,116}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRoo
    "Room temperature sensor"
    annotation (Placement(transformation(extent={{176,-104},{156,-84}})));
  Modelica.Blocks.Sources.Constant mWat_lat(k=0)
    annotation (Placement(transformation(extent={{300,20},{280,40}})));
  Modelica.Blocks.Sources.Constant TWat_lat(k=273.15 + 37)
    annotation (Placement(transformation(extent={{300,-18},{280,2}})));
equation

  connect(out.ports[1],hex. port_a1) annotation (Line(
      points={{-186,62},{-176,62}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(out.ports[2],hex. port_b2) annotation (Line(
      points={{-186,58},{-176,58},{-176,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souWat.ports[1],cooCoi. port_a1)   annotation (Line(
      points={{-86,-18},{-66,-18},{-66,50},{-86,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b1,sinWat. ports[1])    annotation (Line(
      points={{-106,50},{-116,50},{-116,16},{-126,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus,out. weaBus) annotation (Line(
      points={{-206,106},{-186,106},{-186,86},{-226,86},{-226,60},{-214,60},{-214,
          60.2},{-206,60.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fan.m_flow_in,mAir_flow. y) annotation (Line(
      points={{-16.2,78},{-16.2,92},{-45,92}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b1,senTemHXOut. port_a) annotation (Line(
      points={{-156,62},{-146,62},{-146,66},{-142,66}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemHXOut.port_b,cooCoi. port_a2) annotation (Line(
      points={{-130,66},{-116,66},{-116,62},{-106,62}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b2,senTemSupAir. port_a) annotation (Line(
      points={{-86,62},{-72,62},{-72,66},{-60,66}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSupAir.port_b,fan. port_a) annotation (Line(
      points={{-48,66},{-26,66}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TRooSetPoi.y,con. reference) annotation (Line(
      points={{-211,-12},{-188,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y,mWat_flow. u) annotation (Line(
      points={{-165,-18},{-148,-18}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(mWat_flow.y,souWat. m_flow_in) annotation (Line(
      points={{-125,-18},{-116,-18},{-116,-10},{-106,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{-206,106},{-196,106},{-196,104},{-132,104}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TOut,weaBus. TDryBul)
    annotation (Line(points={{-80,140},{-80,104},{-132,104}},
                                                   color={0,0,127}));
  connect(theCon.port_b,vol. heatPort)
    annotation (Line(points={{184,0},{184,-26},{230,-26}},
                                                    color={191,0,0}));
  connect(preHea.port,vol. heatPort)
    annotation (Line(points={{220,50},{200,50},{200,-26},{230,-26}},
                                                            color={191,0,0}));
  connect(TOut1.T, weaBus1.TDryBul) annotation (Line(points={{122,0},{78,0},{78,
          106},{142,106}},      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TOut1.port,theCon. port_a)
    annotation (Line(points={{144,0},{144,0},{164,0}},
                                                     color={191,0,0}));
  connect(fan.port_b, vol.ports[1]) annotation (Line(points={{-6,66},{0,66},{0,58},
          {0,-54},{238,-54},{238,-36}},        color={0,127,255}));
  connect(hex.port_a2, vol.ports[2]) annotation (Line(points={{-156,50},{-158,50},
          {-158,38},{22,38},{22,-70},{242,-70},{242,-36}},color={0,127,255}));
  connect(senTemRoo.T, con.u) annotation (Line(points={{156,-94},{-30,-94},{-208,
          -94},{-208,-24},{-188,-24}},
                                    color={0,0,127}));
  connect(senTemRoo.port, vol.heatPort) annotation (Line(points={{176,-94},{176,
          -94},{200,-94},{200,-26},{230,-26}},
                                             color={191,0,0}));
  connect(vol.mWat_flow, mWat_lat.y) annotation (Line(points={{228,-18},{218,-18},
          {218,30},{279,30}}, color={0,0,127}));
  connect(TWat_lat.y, vol.TWat) annotation (Line(points={{279,-8},{212,-8},{212,
          -20},{228,-20},{228,-21.2}},
                                    color={0,0,127}));
  connect(weaDat1.weaBus, weaBus1) annotation (Line(
      points={{222,108},{142,108},{142,106}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
    annotation(Dialog(tab="Assumptions"), Evaluate=true,
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-280,-120},
            {340,120}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-280,-120},{340,120}})),
    Documentation(info="<html>
<p>This example is a reference model which is used 
to validate the coupling of a convective thermal zone 
with an air-based HVAC system. The model which is validated is in 
<a href=\"modelica://Buildings.Fluid.FMI.Examples.FMUs.Validation.RoomConvectiveHVACConvective\">
Buildings.Fluid.FMI.Examples.FMUs.Validation.RoomConvectiveHVACConvective</a>. </p>
</html>", revisions="<html>
<ul>
<li>May 02, 2016 by Thierry S. Nouidui:<br>First implementation. </li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FMUs/Validation/RoomConvectiveHVACConvectiveNative.mos"
        "Simulate and plot"),
    experiment(StartTime=1.5552e+07, StopTime=15638400));
end RoomConvectiveHVACConvectiveNative;
