within Buildings.Fluid.FMI.Examples.FMUs;
block HVACCoolingOnlyConvective "Simple convective only HVAC system"
  extends Buildings.Fluid.FMI.HVACConvective(
    redeclare final package Medium = MediumA, theZonAda(nPorts=2));

  replaceable package MediumA = Buildings.Media.Air "Medium for air";
  replaceable package MediumW = Buildings.Media.Water "Medium for water";

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
  /////////////////////////////////////////////////////////
  // HVAC models
  Modelica.Blocks.Sources.Constant zero(k=0) "Zero output signal"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal) "Supply air fan"
    annotation (Placement(transformation(extent={{48,90},{68,110}})));
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
    annotation (Placement(transformation(extent={{-102,80},{-82,100}})));
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
        origin={-22,90})));
  Sources.Outside out(
    nPorts=2,
    redeclare package Medium = MediumA) "Outside air boundary condition"
    annotation (Placement(transformation(extent={{-132,84},{-112,104}})));
  Sources.MassFlowSource_T souWat(
    nPorts=1,
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    T=TWSup_nominal) "Source for water flow rate"
    annotation (Placement(transformation(extent={{-32,6},{-12,26}})));
  Sources.FixedBoundary sinWat(
    nPorts=2,
    redeclare package Medium = MediumW) "Sink for water circuit"
    annotation (Placement(transformation(extent={{-72,40},{-52,60}})));
  Modelica.Blocks.Sources.Constant mAir_flow(k=mA_flow_nominal)
    "Fan air flow rate"
    annotation (Placement(transformation(extent={{8,116},{28,136}})));
  Sensors.TemperatureTwoPort senTemHXOut(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    allowFlowReversal=allowFlowReversal)
    "Temperature sensor for heat recovery outlet on supply side"
    annotation (Placement(transformation(extent={{-68,94},{-56,106}})));
  Sensors.TemperatureTwoPort senTemSupAir(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{14,94},{26,106}})));
  Modelica.Blocks.Logical.OnOffController con(bandwidth=1)
    "Controller for coil water flow rate"
    annotation (Placement(transformation(extent={{-112,6},{-92,26}})));
  Modelica.Blocks.Sources.Constant TRooSetPoi(k=TRooSet)
    "Room temperature set point"
    annotation (Placement(transformation(extent={{-158,12},{-138,32}})));
  Modelica.Blocks.Math.BooleanToReal mWat_flow(
    realTrue = 0,
    realFalse = mW_flow_nominal)
    "Conversion from boolean to real for water flow rate"
    annotation (Placement(transformation(extent={{-72,6},{-52,26}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=TOut_nominal,
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,
    computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{-152,130},{-132,150}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-70,130},{-50,150}}),
        iconTransformation(extent={{-142,94},{-122,114}})));
  Modelica.Blocks.Interfaces.RealOutput TOut(final unit="K")
    "Outdoor temperature" annotation (Placement(transformation(extent={{-20,-20},
            {20,20}},
        rotation=90,
        origin={-60,178}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-80,140})));
equation
  connect(zero.y, QGaiRad_flow) annotation (Line(points={{121,-90},{140,-90},{140,
          -40},{180,-40}}, color={0,0,127}));
  connect(zero.y, QGaiCon_flow)
    annotation (Line(points={{121,-90},{180,-90}},         color={0,0,127}));
  connect(zero.y, QGaiLat_flow) annotation (Line(points={{121,-90},{140,-90},{140,
          -140},{180,-140}},
                           color={0,0,127}));
  connect(out.ports[1],hex. port_a1) annotation (Line(
      points={{-112,96},{-102,96}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(out.ports[2],hex. port_b2) annotation (Line(
      points={{-112,92},{-102,92},{-102,84}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souWat.ports[1],cooCoi. port_a1)   annotation (Line(
      points={{-12,16},{8,16},{8,84},{-12,84}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b1,sinWat. ports[1])    annotation (Line(
      points={{-32,84},{-42,84},{-42,52},{-52,52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus,out. weaBus) annotation (Line(
      points={{-132,140},{-112,140},{-112,120},{-152,120},{-152,94},{-140,94},{
          -140,94.2},{-132,94.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fan.m_flow_in,mAir_flow. y) annotation (Line(
      points={{57.8,112},{57.8,126},{29,126}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b1,senTemHXOut. port_a) annotation (Line(
      points={{-82,96},{-72,96},{-72,100},{-68,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemHXOut.port_b,cooCoi. port_a2) annotation (Line(
      points={{-56,100},{-42,100},{-42,96},{-32,96}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b2,senTemSupAir. port_a) annotation (Line(
      points={{-12,96},{2,96},{2,100},{14,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSupAir.port_b,fan. port_a) annotation (Line(
      points={{26,100},{48,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TRooSetPoi.y,con. reference) annotation (Line(
      points={{-137,22},{-114,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y,mWat_flow. u) annotation (Line(
      points={{-91,16},{-74,16}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(mWat_flow.y,souWat. m_flow_in) annotation (Line(
      points={{-51,16},{-42,16},{-42,24},{-32,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{-132,140},{-60,140}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TOut,weaBus. TDryBul)
    annotation (Line(points={{-60,178},{-60,178},{-60,140}},
                                                   color={0,0,127}));
  connect(fan.port_b, theZonAda.ports[1])
    annotation (Line(points={{68,100},{82,100},{110,100}}, color={0,127,255}));
  connect(hex.port_a2, theZonAda.ports[2]) annotation (Line(points={{-82,84},{
          -70,84},{-56,84},{-56,74},{98,74},{98,100},{110,100}}, color={0,127,
          255}));
  connect(con.u, theZonAda.TZon) annotation (Line(points={{-114,10},{-120,10},{
          -120,-18},{120,-18},{120,84},{152,84},{152,100},{132,100}}, color={0,
          0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},
            {160,160}}), graphics={Line(points={{-80,160},{-80,146}}, color={28,
              108,200}),
        Text(
          extent={{-62,152},{-12,132}},
          lineColor={0,0,127},
          textString="TOut")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})),
    Documentation(info="<html>
<p>
This example demonstrates how to export a model of an HVAC system
that only provides convective cooling to a thermal zone.
The HVAC system is taken from
<a href=\"modelica://Buildings.Fluid.FMI.Examples.FMUs.Validation.RoomConvectiveHVACConvectiveNative\">
Buildings.Fluid.FMI.Examples.FMUs.Validation.RoomConvectiveHVACConvectiveNative</a> which is 
similar to the example provided in the Tutorial in 
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>. For details
about the system model, refer to <a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>.
</p>
<p>
The example extends from
<a href=\"modelica://Buildings.Fluid.FMI.HVACConvective\">
Buildings.Fluid.FMI.HVACConvective</a>
which provides the input and output signals that are needed to interface
the acausal HVAC system model with causal connectors of FMI.
The instance <code>theZonAda</code> is the thermal zone adapter
that contains on the left a fluid port, and on the right signal ports
which are then used to connect at the top-level of the model to signal
ports which are exposed at the FMU interface.
</p>
</html>", revisions="<html>
<ul>
<li>
April 16, 2016 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FMUs/HVACCoolingOnlyConvective.mos"
        "Export FMU"));
end HVACCoolingOnlyConvective;
