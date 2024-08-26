within Buildings.Fluid.AirFilters.Examples;
model SpaceCooling
  "Space cooling system"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air(extraPropertiesNames={"CO2"}) "Medium for air";
  replaceable package MediumW = Buildings.Media.Water "Medium for water";

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    V=V,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    mSenFac=3)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  parameter Modelica.Units.SI.Volume V=6*10*3 "Room volume";
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
  parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=1000
    "Internal heat gains of the room";
  parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal=-QRooInt_flow -
      10E3/30*(TOut_nominal - TRooSet) "Nominal cooling load of the room";
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

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow=
        QRooInt_flow) "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumA,
    per(etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.NotProvided,
        etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided),
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mA_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Supply air fan"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(redeclare package
      Medium1 =
        MediumA, redeclare package Medium2 = MediumA,
    m1_flow_nominal=mA_flow_nominal,
    m2_flow_nominal=mA_flow_nominal,
    dp1_nominal=200,
    dp2_nominal=200,
    eps=eps) "Heat recovery"
    annotation (Placement(transformation(extent={{-70,-36},{-50,-16}})));
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
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Cooling coil"
   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-12,-26})));
  Buildings.Fluid.Sources.Outside out(
    redeclare package Medium = MediumA,
    use_C_in=true,
      nPorts=2)
    annotation (Placement(transformation(extent={{-162,-32},{-142,-12}})));
  Buildings.Fluid.Sources.MassFlowSource_T souWat(
    nPorts=1,
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    T=TWSup_nominal) "Source for water flow rate"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(nPorts=1, redeclare package Medium =
        MediumW) "Sink for water circuit"
    annotation (Placement(transformation(extent={{-80,-76},{-60,-56}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=TOut_nominal,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mAir_flow(k=mA_flow_nominal)
    "Fan air flow rate"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHXOut(redeclare package
      Medium =
        MediumA, m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for heat recovery outlet on supply side"
    annotation (Placement(transformation(extent={{-38,-26},{-26,-14}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(redeclare package
      Medium =
        MediumA, m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{6,-26},{18,-14}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRooSetPoi(k=TRooSet)
    "Room temperature set point"
    annotation (Placement(transformation(extent={{-142,-102},{-122,-82}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRoo
    "Room temperature sensor"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Buildings.Controls.Continuous.LimPID conRoo(
    k=0.1,
    Ti=60,
    yMax=mW_flow_nominal,
    reverseActing=false)
    "Room controller"
    annotation (Placement(transformation(extent={{-100,-102},{-80,-82}})));
  Buildings.Fluid.AirFilters.Empirical airFil(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    dp_nominal(displayUnit="Pa") = 50,
    per=per)
    annotation (Placement(transformation(extent={{-128,-10},{-108,10}})));
  Buildings.Fluid.AirFilters.BaseClasses.Data.Generic per(
    mCon_nominal=5,
    filterationEfficiencyParameters(rat={{0,0.5,1}}, eps={{0.5,0.4,0.2}}),   b=1.2)
    "Performance dataset of the air filter"
    annotation (Placement(transformation(extent={{-80,64},{-60,84}})));
  Modelica.Blocks.Sources.Ramp C_inflow(
    duration=87600/2,
    height=50/1000000*1.53,
    offset=100/1000000*1.53,
    startTime=15552000 + 87600/2)
    "Contaminant mass flow rate fraction"
    annotation (Placement(transformation(extent={{-170,-70},{-150,-50}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort C_out(redeclare package
    Medium =MediumA,
    m_flow_nominal=mA_flow_nominal)
    "Trace substance sensor of outlet air"
    annotation (Placement(transformation(extent={{-102,-10},{-82,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant repSig(k=false)
    "Filter replacement signal"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
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
  connect(vol.ports[2], hex.port_a2) annotation (Line(
      points={{71,20},{71,-46},{-50,-46},{-50,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souWat.ports[1], cooCoi.port_a1)   annotation (Line(
      points={{0,-100},{20,-100},{20,-32},{-2,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b1, sinWat.ports[1])    annotation (Line(
      points={{-22,-32},{-30,-32},{-30,-66},{-60,-66}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, out.weaBus) annotation (Line(
      points={{-140,50},{-136,50},{-136,30},{-170,30},{-170,-21.8},{-162,-21.8}},
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
  connect(hex.port_b1, senTemHXOut.port_a) annotation (Line(
      points={{-50,-20},{-38,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemHXOut.port_b, cooCoi.port_a2) annotation (Line(
      points={{-26,-20},{-22,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b2, senTemSupAir.port_a) annotation (Line(
      points={{-2,-20},{6,-20}},
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
  connect(conRoo.y, souWat.m_flow_in)
    annotation (Line(points={{-79,-92},{-22,-92}}, color={0,0,127}));
  connect(conRoo.u_s, TRooSetPoi.y)
    annotation (Line(points={{-102,-92},{-120,-92}}, color={0,0,127}));
  connect(conRoo.u_m, senTemRoo.T) annotation (Line(points={{-90,-104},{-90,-142},
          {100,-142},{100,80},{91,80}}, color={0,0,127}));
  connect(out.ports[1], airFil.port_a) annotation (Line(points={{-142,-23},{
          -136,-23},{-136,0},{-128,0}},
                            color={0,127,255}));
  connect(out.ports[2], hex.port_b2) annotation (Line(points={{-142,-21},{-136,
          -21},{-136,-46},{-70,-46},{-70,-32}},
                                             color={0,127,255}));
  connect(C_inflow.y, out.C_in[1]) annotation (Line(points={{-149,-60},{-144,-60},
          {-144,-42},{-170,-42},{-170,-30},{-164,-30}}, color={0,0,127}));
  connect(airFil.port_b, C_out.port_a)
    annotation (Line(points={{-108,0},{-102,0}}, color={0,127,255}));
  connect(C_out.port_b, hex.port_a1) annotation (Line(points={{-82,0},{-76,0},{
          -76,-20},{-70,-20}}, color={0,127,255}));
  connect(repSig.y, airFil.uRep)
    annotation (Line(points={{-138,10},{-138,6},{-130,6}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This block is identical to
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>,
except that an air filter is added.
</p>
<p>
The major input signals for the air filter are configured as follows:
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
June 30, 2024, by Sen Huang:<br/>
First implementation based on <a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-180,-160},{120,
            100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/SpaceCooling/System3.mos"
        "Simulate and plot"),
    experiment(StartTime=15552000, Tolerance=1e-6, StopTime=15638400));
end SpaceCooling;
