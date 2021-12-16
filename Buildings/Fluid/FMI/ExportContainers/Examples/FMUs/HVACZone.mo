within Buildings.Fluid.FMI.ExportContainers.Examples.FMUs;
block HVACZone
  "Declaration of an FMU that exports a simple convective only HVAC system"
  extends Buildings.Fluid.FMI.ExportContainers.HVACZone(
    redeclare final package Medium = MediumA, hvacAda(nPorts=2));

  replaceable package MediumA = Buildings.Media.Air "Medium for air";
  replaceable package MediumW = Buildings.Media.Water "Medium for water";

  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  //////////////////////////////////////////////////////////
  // Heat recovery effectiveness
  parameter Real eps = 0.8 "Heat recovery effectiveness";

  /////////////////////////////////////////////////////////
  // Design air conditions
  parameter Modelica.Units.SI.Temperature TASup_nominal=291.15
    "Nominal air temperature supplied to room";
  parameter Modelica.Units.SI.DimensionlessRatio wASup_nominal=0.012
    "Nominal air humidity ratio supplied to room [kg/kg] assuming 90% relative humidity";
  parameter Modelica.Units.SI.Temperature TRooSet=297.15
    "Nominal room air temperature";
  parameter Modelica.Units.SI.Temperature TOut_nominal=303.15
    "Design outlet air temperature";
  parameter Modelica.Units.SI.Temperature THeaRecLvg=TOut_nominal - eps*(
      TOut_nominal - TRooSet) "Air temperature leaving the heat recovery";
  parameter Modelica.Units.SI.DimensionlessRatio wHeaRecLvg=0.0135
    "Air humidity ratio leaving the heat recovery [kg/kg]";

  /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Real UA(unit="W/K") = 10E3 "Average UA-value of the room";
  parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=1000
    "Internal heat gains of the room";
  parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal=-QRooInt_flow -
      UA/30*(TOut_nominal - TRooSet) "Nominal cooling load of the room";
  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=1.3*
      QRooC_flow_nominal/1006/(TASup_nominal - TRooSet)
    "Nominal air mass flow rate, increased by factor 1.3 to allow for recovery after temperature setback";
  parameter Modelica.Units.SI.TemperatureDifference dTFan=2
    "Estimated temperature raise across fan that needs to be made up by the cooling coil";
  parameter Modelica.Units.SI.HeatFlowRate QCoiC_flow_nominal=mA_flow_nominal*(
      TASup_nominal - THeaRecLvg - dTFan)*1006 + mA_flow_nominal*(wASup_nominal
       - wHeaRecLvg)*2458.3e3
    "Cooling load of coil, taking into account outside air sensible and latent heat removal";

  /////////////////////////////////////////////////////////
  // Water temperatures and mass flow rates
  parameter Modelica.Units.SI.Temperature TWSup_nominal=285.15
    "Water supply temperature";
  parameter Modelica.Units.SI.Temperature TWRet_nominal=289.15
    "Water return temperature";
  parameter Modelica.Units.SI.MassFlowRate mW_flow_nominal=-QCoiC_flow_nominal/
      (TWRet_nominal - TWSup_nominal)/4200 "Nominal water mass flow rate";
  /////////////////////////////////////////////////////////
  // HVAC models
  Modelica.Blocks.Sources.Constant zero(k=0) "Zero output signal"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal,
    nominalValuesDefineDefaultPressureCurve=true)
                                         "Supply air fan"
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
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
    annotation (Placement(transformation(extent={{-82,80},{-62,100}})));

  replaceable Buildings.Fluid.HeatExchangers.ConstantEffectiveness cooCoi(
    dp1_nominal=6000,
    dp2_nominal=200,
    show_T=true,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal) constrainedby
    Buildings.Fluid.Interfaces.PartialFourPortInterface(
        redeclare package Medium1 = MediumW,
        redeclare package Medium2 = MediumA,
        m1_flow_nominal=mW_flow_nominal,
        m2_flow_nominal=mA_flow_nominal)
    "Cooling coil (with sensible cooling only)"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-18,94})));

  Buildings.Fluid.Sources.Outside out(
    redeclare package Medium = MediumA,
    nPorts=2) "Outside air boundary condition"
    annotation (Placement(transformation(extent={{-112,84},{-92,104}})));
  Sources.MassFlowSource_T souWat(
    redeclare package Medium = MediumW,
    nPorts=1,
    use_m_flow_in=true,
    T=TWSup_nominal) "Source for water flow rate"
    annotation (Placement(transformation(extent={{-30,6},{-10,26}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumW, nPorts=1) "Sink for water circuit"
    annotation (Placement(transformation(extent={{-72,40},{-52,60}})));
  Modelica.Blocks.Sources.Constant mAir_flow(k=mA_flow_nominal)
    "Fan air flow rate"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Sensors.TemperatureTwoPort senTemHXOut(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    allowFlowReversal=allowFlowReversal)
    "Temperature sensor for heat recovery outlet on supply side"
    annotation (Placement(transformation(extent={{-54,90},{-34,110}})));
  Sensors.TemperatureTwoPort senTemSupAir(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Modelica.Blocks.Logical.OnOffController con(bandwidth=1)
    "Controller for coil water flow rate"
    annotation (Placement(transformation(extent={{-112,6},{-92,26}})));
  Modelica.Blocks.Sources.Constant TRooSetPoi(k=TRooSet)
    "Room temperature set point"
    annotation (Placement(transformation(extent={{-150,12},{-130,32}})));
  Modelica.Blocks.Math.BooleanToReal mWat_flow(
    realTrue = 0,
    realFalse = mW_flow_nominal)
    "Conversion from boolean to real for water flow rate"
    annotation (Placement(transformation(extent={{-72,6},{-52,26}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=TOut_nominal,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,
    computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{-152,130},{-132,150}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-70,130},{-50,150}}),
        iconTransformation(extent={{-142,94},{-122,114}})));
  Modelica.Blocks.Interfaces.RealOutput TOut(final unit="K")
    "Outdoor temperature" annotation (Placement(transformation(extent={{20,-20},
            {-20,20}},
        rotation=90,
        origin={0,-180}),  iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-180})));
  FixedResistances.PressureDrop resSup1(
    redeclare package Medium = MediumA,
    linearized=true,
    dp_nominal=10,
    m_flow_nominal=mA_flow_nominal) "Fixed resistance for supply air inlet"
    annotation (Placement(transformation(extent={{86,130},{106,150}})));
  FixedResistances.PressureDrop resRet1(
    redeclare package Medium = MediumA,
    dp_nominal=200,
    linearized=true,
    m_flow_nominal=mA_flow_nominal) "Fixed resistance for return air duct"
    annotation (Placement(transformation(extent={{70,60},{50,80}})));
equation
  connect(zero.y, QGaiRad_flow) annotation (Line(points={{121,-90},{140,-90},{140,
          -40},{180,-40}}, color={0,0,127}));
  connect(zero.y, QGaiSenCon_flow)
    annotation (Line(points={{121,-90},{180,-90}},         color={0,0,127}));
  connect(zero.y, QGaiLat_flow) annotation (Line(points={{121,-90},{140,-90},{140,
          -140},{180,-140}},
                           color={0,0,127}));
  connect(out.ports[1],hex. port_a1) annotation (Line(
      points={{-92,96},{-82,96}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(out.ports[2],hex. port_b2) annotation (Line(
      points={{-92,92},{-88,92},{-88,84},{-82,84}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souWat.ports[1],cooCoi. port_a1)   annotation (Line(
      points={{-10,16},{10,16},{10,88},{-8,88}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan.m_flow_in,mAir_flow. y) annotation (Line(
      points={{60,112},{60,140},{21,140}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b1,senTemHXOut. port_a) annotation (Line(
      points={{-62,96},{-60,96},{-60,100},{-54,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemHXOut.port_b,cooCoi. port_a2) annotation (Line(
      points={{-34,100},{-28,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b2,senTemSupAir. port_a) annotation (Line(
      points={{-8,100},{20,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSupAir.port_b,fan. port_a) annotation (Line(
      points={{40,100},{50,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TRooSetPoi.y,con. reference) annotation (Line(
      points={{-129,22},{-114,22}},
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
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TOut,weaBus. TDryBul)
    annotation (Line(points={{0,-180},{0,-180},{0,-140},{0,120},{-60,120},{-60,
          140}},                                   color={0,0,127}));
  connect(sinWat.ports[1], cooCoi.port_b1) annotation (Line(points={{-52,50},{
          -52,50},{-28,50},{-28,88},{-28,88}}, color={0,127,255}));
  connect(con.u, hvacAda.TAirZon[1]) annotation (Line(points={{-114,10},{-124,10},
          {-124,-10},{124,-10},{124,128}}, color={0,0,127}));
  connect(resSup1.port_b, hvacAda.ports[1]) annotation (Line(points={{106,140},{
          113,140},{120,140}}, color={0,127,255}));
  connect(resRet1.port_a, hvacAda.ports[2]) annotation (Line(points={{70,70},{110,
          70},{110,140},{120,140}}, color={0,127,255}));
  connect(fan.port_b, resSup1.port_a) annotation (Line(points={{70,100},{74,100},
          {80,100},{80,140},{86,140}}, color={0,127,255}));
  connect(resRet1.port_b, hex.port_a2) annotation (Line(points={{50,70},{50,72},
          {-60,72},{-60,84},{-62,84}},color={0,127,255}));
  connect(out.weaBus, weaBus) annotation (Line(
      points={{-112,94.2},{-116,94.2},{-116,94},{-120,94},{-120,120},{-60,120},
          {-60,140}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},
            {160,160}}), graphics={
        Text(
          extent={{-24,-132},{26,-152}},
          textColor={0,0,127},
          textString="TOut")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})),
    Documentation(info="<html>
<p>
This example demonstrates how to export a model of an HVAC system
that only provides convective cooling to a single thermal zone.
The HVAC system is adapted from
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>,
but flow resistances have been added to have the same configuration as
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZones\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZones</a>.
Having the same configuration is needed for the validation test
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Validation.RoomHVAC\">
Buildings.Fluid.FMI.ExportContainers.Validation.RoomHVAC</a>.
</p>
<p>
The example extends from
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.HVACZone\">
Buildings.Fluid.FMI.ExportContainers.HVACZone
</a>
which provides the input and output signals that are needed to interface
the acausal HVAC system model with causal connectors of FMI.
The instance <code>hvacAda</code> is the HVAC adapter
that contains on the left a fluid port, and on the right signal ports
which are then used to connect at the top-level of the model to signal
ports which are exposed at the FMU interface.
</p>
</html>", revisions="<html>
<ul>
<li>
September 21, 2021 by David Blum:<br/>
Correct supply and return water parameterization.<br/>
Use explicit calculation of sensible and latent load to determine design load
on cooling coil.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2624\">#2624</a>.
</li>
<li>
May 15, 2019, by Jianjun Hu:<br/>
Replaced fluid source. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
November 11, 2016, by Michael Wetter:<br/>
Made the cooling coil replaceable because the Buildings library
uses the model for validation with a cooling coil model that is not
in the Annex 60 library.
</li>
<li>
April 16, 2016 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Examples/FMUs/HVACZone.mos"
        "Export FMU"));
end HVACZone;
