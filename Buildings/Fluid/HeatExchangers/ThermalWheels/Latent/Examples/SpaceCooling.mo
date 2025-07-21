within Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.Examples;
model SpaceCooling "Space cooling system"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air "Medium for air";
  replaceable package MediumW = Buildings.Media.Water "Medium for water";

  parameter Modelica.Units.SI.Volume V=6*10*3 "Room volume";
  // Heat recovery effectiveness
  parameter Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Generic per(
    mSup_flow_nominal=mA_flow_nominal,
    mExh_flow_nominal=mA_flow_nominal,
    dpSup_nominal=200,
    have_varSpe=false)
    "Performance record for the enthalpy wheel"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  /////////////////////////////////////////////////////////
  // Design air conditions
  parameter Modelica.Units.SI.Temperature TASup_nominal=291.15
    "Nominal air temperature supplied to room";
  parameter Modelica.Units.SI.DimensionlessRatio wASup_nominal=0.012
    "Nominal air humidity ratio supplied to room [kg/kg] assuming 90% relative humidity";
  parameter Modelica.Units.SI.Temperature TRooSet=297.15
    "Nominal room air temperature";
  parameter Modelica.Units.SI.Temperature TMixSet=298.15
    "Nominal mixed air temperature";
  parameter Modelica.Units.SI.Temperature TOut_nominal=303.15
    "Design outlet air temperature";
  parameter Modelica.Units.SI.Temperature THeaRecLvg=
    TOut_nominal - per.epsSen_nominal*(TOut_nominal - TRooSet)
    "Air temperature leaving the heat recovery";
  parameter Modelica.Units.SI.DimensionlessRatio wHeaRecLvg=0.0135
    "Air humidity ratio leaving the heat recovery [kg/kg]";

  /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=1000
    "Internal heat gains of the room";
  parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal=
    -QRooInt_flow -10E3/30*(TOut_nominal - TRooSet)
    "Nominal cooling load of the room";
  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=
    1.3*QRooC_flow_nominal/1006/(TASup_nominal - TRooSet)
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
  parameter Modelica.Units.SI.MassFlowRate mW_flow_nominal=
    -QCoiC_flow_nominal/(TWRet_nominal - TWSup_nominal)/4200
    "Nominal water mass flow rate";


  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    V=V,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    mSenFac=3)
    "Indoor room"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(
    G=10000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(
    Q_flow=QRooInt_flow)
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumA,
    per(etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.NotProvided,
        etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided),
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mA_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Supply air fan"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BypassDampers whe(
    redeclare package Medium = MediumA,
    per=per)
    "Heat recovery with bypass damper"
    annotation (Placement(transformation(extent={{-110,-40},{-88,-18}})));
  Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=mW_flow_nominal,
    m2_flow_nominal=mA_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=200,
    use_Q_flow_nominal=true,
    Q_flow_nominal=QCoiC_flow_nominal,
    T_a1_nominal=TWSup_nominal,
    T_a2_nominal=THeaRecLvg,
    w_a2_nominal=wHeaRecLvg,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooling coil"
   annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180, origin={-30,-26})));
  Buildings.Fluid.Sources.Outside out(
    redeclare package Medium = MediumA,
    nPorts=2)
    "Outdoor"
    annotation (Placement(transformation(extent={{-168,-32},{-148,-12}})));
  Buildings.Fluid.Sources.MassFlowSource_T souWat(
    nPorts=1,
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    T=TWSup_nominal)
    "Source for water flow rate"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    nPorts=1, redeclare package Medium = MediumW)
    "Sink for water circuit"
    annotation (Placement(transformation(extent={{-80,-76},{-60,-56}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=TOut_nominal,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse mAir_flow(
    amplitude=-mA_flow_nominal,
    width=0.5,
    period=87600,
    shift=0.24*87600,
    offset=mA_flow_nominal)
    "Fan air flow rate"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHXOut(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for heat recovery outlet on supply side"
    annotation (Placement(transformation(extent={{-62,-26},{-50,-14}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{6,-26},{18,-14}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRooSetPoi(
    k=TRooSet)
    "Room temperature set point"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRoo
    "Room temperature sensor"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse opeSig(
    width=0.5,
    period=86400,
    shift=0.25*86400)
    "Operating signal"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.Continuous.LimPID conWhe(
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"),
    k=0.1,
    Ti=60)
    "Heat recovery controller"
    annotation (Placement(transformation(extent={{-58,10},{-38,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TMixSetPoi(
    k=TMixSet)
    "Mixed air temperature set point"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemRetAir(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for return air"
    annotation (Placement(transformation(extent={{54,-52},{42,-40}})));
  Buildings.Controls.Continuous.LimPID conRoo(
    k=0.1,
    Ti=60,
    yMax=mW_flow_nominal,
    reverseActing=false)
    "Room controller"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFraHXIn(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    tau=10)
    "Humidity sensor for heat recovery inlet on supply side"
    annotation (Placement(transformation(extent={{-138,-28},{-122,-12}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFraHXOut(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    tau=10)
    "Humidity sensor for heat recovery outlet on supply side"
    annotation (Placement(transformation(extent={{-80,-28},{-64,-12}})));
equation
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{40,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{40,80},{50,80},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fan.port_b, vol.ports[1]) annotation (Line(
      points={{60,-20},{69,-20},{69,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souWat.ports[1], cooCoi.port_a1)   annotation (Line(
      points={{0,-100},{20,-100},{20,-32},{-20,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b1, sinWat.ports[1])    annotation (Line(
      points={{-40,-32},{-48,-32},{-48,-66},{-60,-66}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, out.weaBus) annotation (Line(
      points={{-140,50},{-134,50},{-134,4},{-172,4},{-172,-22},{-168,-22},{-168,
          -21.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-140,50},{-110,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDryBul, TOut.T) annotation (Line(
      points={{-109.95,50.05},{-66,50.05},{-66,50},{-22,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(fan.m_flow_in, mAir_flow.y) annotation (Line(
      points={{50,-8},{50,10},{22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTemHXOut.port_b, cooCoi.port_a2) annotation (Line(
      points={{-50,-20},{-40,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b2, senTemSupAir.port_a) annotation (Line(
      points={{-20,-20},{6,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSupAir.port_b, fan.port_a) annotation (Line(
      points={{18,-20},{40,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port, theCon.port_a) annotation (Line(
      points={{5.55112e-16,50},{20,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort, senTemRoo.port) annotation (Line(
      points={{60,30},{50,30},{50,80},{70,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(whe.port_b2, out.ports[1]) annotation (Line(
      points={{-110,-37.8},{-144,-37.8},{-144,-23},{-148,-23}},
      color={0,127,255}));
  connect(opeSig.y, whe.uRot) annotation (Line(
      points={{-138,-60},{-118,-60},{-118,-33.4},{-112.2,-33.4}},
      color={255,0,255}));
  connect(TMixSetPoi.y, conWhe.u_s)
    annotation (Line(points={{-78,20},{-60,20}}, color={0,0,127}));
  connect(senTemHXOut.T, conWhe.u_m) annotation (Line(points={{-56,-13.4},{-56,2},
          {-48,2},{-48,8}}, color={0,0,127}));
  connect(conWhe.y, whe.uBypDamPos) annotation (Line(points={{-37,20},{-12,20},{
          -12,-80},{-122,-80},{-122,-24.6},{-112.2,-24.6}}, color={0,0,127}));
  connect(vol.ports[2], senTemRetAir.port_a)
    annotation (Line(points={{71,20},{71,-46},{54,-46}}, color={0,127,255}));
  connect(conRoo.u_m, senTemRoo.T) annotation (Line(points={{-80,-112},{-80,-140},
          {100,-140},{100,80},{91,80}}, color={0,0,127}));
  connect(TRooSetPoi.y, conRoo.u_s)
    annotation (Line(points={{-138,-100},{-92,-100}}, color={0,0,127}));
  connect(conRoo.y, souWat.m_flow_in) annotation (Line(points={{-69,-100},{-30,-100},
          {-30,-92},{-22,-92}}, color={0,0,127}));
  connect(whe.port_a2, senTemRetAir.port_b) annotation (Line(points={{-88,-37.8},
          {-60,-37.8},{-60,-46},{42,-46}}, color={0,127,255}));
  connect(senMasFraHXIn.port_a, out.ports[2]) annotation (Line(points={{-138,-20},
          {-138,-21},{-148,-21}}, color={0,127,255}));
  connect(senMasFraHXIn.port_b, whe.port_a1) annotation (Line(points={{-122,-20},
          {-122,-20.42},{-110,-20.42}}, color={0,127,255}));
  connect(whe.port_b1, senMasFraHXOut.port_a) annotation (Line(points={{-88,-20.2},
          {-88,-20},{-80,-20}}, color={0,127,255}));
  connect(senMasFraHXOut.port_b, senTemHXOut.port_a)
    annotation (Line(points={{-64,-20},{-62,-20}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This block is identical to
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>,
except that the heat recovery device is modelled with <a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BypassDampers\">
Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BypassDampers</a>.
</p>
<p>
The major input signals for the heat recovery device are configured as follows:
</p>
<ul>
<li>
The operating signal <i>uRot</i> changes from <code>false</code> to <code>true</code> at 6:00 (15552000+6*3600 seconds)
and from <code>true</code> to <code>false</code> at 18:00 (15552000+18*3600 seconds).
</li>
<li>
The supply air flow rate <i>mAir_flow</i> changes from <i>0</i> to <i>0.646</i> at around 5:00
and from <i>0.646</i> to <i>0</i> at around 17:00.
</li>
<li>
The bypass damper positions are controlled to maintain the temperature of the air leaving the thermal wheel,
<code>senTemHXOut.T</code>, at 298.15 K.
</li>
</ul>
<p>
The expected output is:
</p>
<ul>
<li>
<code>senTemHXOut.T</code> is less or equal to 298.15 K.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
May 3, 2024, by Sen Huang:<br/>
First implementation based on <a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-180,-160},{120,
            100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ThermalWheels/Latent/Examples/SpaceCooling.mos"
        "Simulate and plot"),
    experiment(StartTime=15552000, Tolerance=1e-6, StopTime=15638400));
end SpaceCooling;
