within Buildings.Fluid.FMI.ExportContainers.Examples.FMUs;
block HVACZones
  "Declaration of an FMU that exports a simple convective only HVAC system for two zones"
  extends Buildings.Fluid.FMI.ExportContainers.HVACZones(
    redeclare final package Medium = MediumA,
    nZon = 2,
    nPorts = 3);

  replaceable package MediumA = Buildings.Media.Air "Medium for air";
  replaceable package MediumW = Buildings.Media.Water "Medium for water";

  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

 // parameter Modelica.Units.SI.Volume V=6*10*3 "Room volume";
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
  Modelica.Blocks.Sources.Constant zer[nZon](each k=0) "Zero output signal"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumA,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mA_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal) "Supply air fan"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
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
    annotation (Placement(transformation(extent={{-88,80},{-68,100}})));

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
    nPorts=3) "Outside air boundary condition"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Sources.MassFlowSource_T souWat(
    nPorts=1,
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    T=TWSup_nominal) "Source for water flow rate"
    annotation (Placement(transformation(extent={{-40,-48},{-20,-28}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumW, nPorts=1) "Sink for water circuit"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-36,72})));
  Modelica.Blocks.Sources.Constant mAir_flow(k=mA_flow_nominal)
    "Fan air flow rate"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Sensors.TemperatureTwoPort senTemHXOut(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    allowFlowReversal=allowFlowReversal)
    "Temperature sensor for heat recovery outlet on supply side"
    annotation (Placement(transformation(extent={{-52,94},{-40,106}})));
  Sensors.TemperatureTwoPort senTemSupAir(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{14,94},{26,106}})));
  Modelica.Blocks.Logical.OnOffController con(bandwidth=1)
    "Controller for coil water flow rate"
    annotation (Placement(transformation(extent={{-98,-40},{-78,-20}})));
  Modelica.Blocks.Sources.Constant TRooSetPoi(k=TRooSet)
    "Room temperature set point"
    annotation (Placement(transformation(extent={{-148,-34},{-128,-14}})));
  Modelica.Blocks.Math.BooleanToReal mWat_flow(
    realTrue = 0,
    realFalse = mW_flow_nominal)
    "Conversion from boolean to real for water flow rate"
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
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
  Modelica.Blocks.Math.Min min
    annotation (Placement(transformation(extent={{-80,-80},{-100,-60}})));
  Movers.FlowControlled_m_flow fan2(
    redeclare package Medium = MediumA,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mA_flow_nominal/10,
    inputType=Buildings.Fluid.Types.InputType.Constant)
    "Supply air fan that extracts a constant amount of outside air"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = MediumA,
    m_flow_nominal=0.1*mA_flow_nominal,
    dp_nominal=200,
    linearized=true) "Fixed resistance for exhaust air duct"
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop resSup1(
    redeclare package Medium = MediumA,
    linearized=true,
    m_flow_nominal=0.5*mA_flow_nominal,
    dp_nominal=10) "Fixed resistance for supply air inlet"
    annotation (Placement(transformation(extent={{70,106},{90,126}})));
  Buildings.Fluid.FixedResistances.PressureDrop resSup2(
    redeclare package Medium = MediumA,
    linearized=true,
    m_flow_nominal=0.5*mA_flow_nominal,
    dp_nominal=10) "Fixed resistance for supply air inlet"
    annotation (Placement(transformation(extent={{70,76},{90,96}})));
  Buildings.Fluid.FixedResistances.PressureDrop resRet1(
    redeclare package Medium = MediumA,
    dp_nominal=200,
    linearized=true,
    m_flow_nominal=0.5*mA_flow_nominal) "Fixed resistance for return air duct"
    annotation (Placement(transformation(extent={{40,50},{20,70}})));
  Buildings.Fluid.FixedResistances.PressureDrop resRet2(
    redeclare package Medium = MediumA,
    dp_nominal=200,
    linearized=true,
    m_flow_nominal=0.5*mA_flow_nominal) "Fixed resistance for return air duct"
    annotation (Placement(transformation(extent={{40,20},{20,40}})));
equation
  connect(zer.y, QGaiRad_flow) annotation (Line(points={{121,-90},{140,-90},{140,
          -40},{180,-40}}, color={0,0,127}));
  connect(zer.y, QGaiSenCon_flow)
    annotation (Line(points={{121,-90},{180,-90}}, color={0,0,127}));
  connect(zer.y, QGaiLat_flow) annotation (Line(points={{121,-90},{140,-90},{140,
          -140},{180,-140}}, color={0,0,127}));
  connect(out.ports[1],hex. port_a1) annotation (Line(
      points={{-100,92.6667},{-98,92.6667},{-98,92},{-92,92},{-92,96},{-88,96}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(out.ports[2],hex. port_b2) annotation (Line(
      points={{-100,90},{-92,90},{-92,84},{-88,84}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souWat.ports[1],cooCoi. port_a1)   annotation (Line(
      points={{-20,-38},{-2,-38},{-2,88},{-8,88}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan.m_flow_in,mAir_flow. y) annotation (Line(
      points={{50,112},{50,140},{21,140}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b1,senTemHXOut. port_a) annotation (Line(
      points={{-68,96},{-60,96},{-60,100},{-52,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemHXOut.port_b,cooCoi. port_a2) annotation (Line(
      points={{-40,100},{-28,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b2,senTemSupAir. port_a) annotation (Line(
      points={{-8,100},{14,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSupAir.port_b,fan. port_a) annotation (Line(
      points={{26,100},{40,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TRooSetPoi.y,con. reference) annotation (Line(
      points={{-127,-24},{-100,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y,mWat_flow. u) annotation (Line(
      points={{-77,-30},{-72,-30}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(mWat_flow.y,souWat. m_flow_in) annotation (Line(
      points={{-49,-30},{-42,-30}},
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
    annotation (Line(points={{0,-180},{0,-174},{0,-140},{0,120},{-60,120},{-60,
          140}},                                   color={0,0,127}));
  connect(sinWat.ports[1], cooCoi.port_b1) annotation (Line(points={{-36,82},{
          -36,88},{-28,88}},                   color={0,127,255}));
  connect(min.y, con.u) annotation (Line(points={{-101,-70},{-110,-70},{-110,
          -36},{-100,-36}},
                      color={0,0,127}));
  connect(fan2.port_b, res.port_a) annotation (Line(points={{60,0},{60,0},{40,0}},
                      color={0,127,255}));
  connect(res.port_b, out.ports[3]) annotation (Line(points={{20,0},{-96,0},{
          -96,42},{-96,87.3333},{-100,87.3333}},
        color={0,127,255}));
  connect(fan.port_b, resSup1.port_a) annotation (Line(points={{60,100},{66,100},
          {66,116},{70,116}}, color={0,127,255}));
  connect(fan.port_b, resSup2.port_a) annotation (Line(points={{60,100},{66,100},
          {66,86},{70,86}}, color={0,127,255}));
  connect(resSup1.port_b, hvacAda[1].ports[1]) annotation (Line(points={{90,116},
          {100,116},{100,140},{120,140}}, color={0,127,255}));
  connect(resSup2.port_b, hvacAda[2].ports[1]) annotation (Line(points={{90,86},
          {102,86},{102,140},{120,140}}, color={0,127,255}));
  connect(hvacAda[1].ports[3], fan2.port_a) annotation (Line(points={{120,140},
          {116,140},{116,0},{80,0}}, color={0,127,255}));
  connect(hvacAda[2].ports[3], fan2.port_a) annotation (Line(points={{120,140},
          {116,140},{116,0},{80,0}}, color={0,127,255}));
  connect(hvacAda[1].TAirZon[1], min.u1) annotation (Line(points={{124,128},{
          124,128},{124,60},{124,-64},{-78,-64}}, color={0,0,127}));
  connect(hvacAda[2].TAirZon[1], min.u2) annotation (Line(points={{124,128},{
          124,128},{124,54},{124,-64},{-60,-64},{-60,-64},{-60,-76},{-78,-76}},
        color={0,0,127}));
  connect(resRet1.port_b, hex.port_a2) annotation (Line(points={{20,60},{20,60},
          {-60,60},{-60,84},{-68,84}}, color={0,127,255}));
  connect(resRet2.port_b, hex.port_a2) annotation (Line(points={{20,30},{-28,30},
          {-60,30},{-60,84},{-68,84}}, color={0,127,255}));
  connect(resRet1.port_a, hvacAda[1].ports[2]) annotation (Line(points={{40,60},
          {70,60},{106,60},{106,140},{120,140}}, color={0,127,255}));
  connect(resRet2.port_a, hvacAda[2].ports[2]) annotation (Line(points={{40,30},
          {72,30},{106,30},{106,140},{120,140}}, color={0,127,255}));
  connect(out.weaBus, weaBus) annotation (Line(
      points={{-120,90.2},{-130,90.2},{-130,90},{-130,120},{-60,120},{-60,140}},
      color={255,204,51},
      thickness=0.5));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},
            {160,180}}), graphics={
        Text(
          extent={{-24,-132},{26,-152}},
          textColor={0,0,127},
          textString="TOut")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,180}})),
    Documentation(info="<html>
<p>
This example demonstrates how to export a model of an HVAC system
that only provides convective cooling to two thermal zones.
The example is similar to
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZone\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZone</a>
except that is serves two thermal zones rather than one.
</p>
<p>
The example extends from
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.HVACZones\">
Buildings.Fluid.FMI.ExportContainers.HVACZones
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
April 9, 2024, by Hongxiang Fu:<br/>
Added nominal curve specification to suppress warning.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
</li>
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
April 4, 2017, by Michael Wetter:<br/>
Removed import statement.
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
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Examples/FMUs/HVACZones.mos"
        "Export FMU"));
end HVACZones;
