within Buildings.Fluid.AirFilters.Examples;
model SpaceCooling
  "Space cooling system"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air(extraPropertiesNames={"PM10"})
  "Medium for air";
  replaceable package MediumW = Buildings.Media.Water "Medium for water";

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

  parameter Buildings.Fluid.AirFilters.Data.Generic per(
    mCon_nominal=5,
    mCon_reset=0,
    namCon={"PM10"},
    filEffPar(rat={{0,0.5,1}},
    eps={{0.5,0.4,0.2}}),
    b=1.3,
    m_flow_nominal=mA_flow_nominal,
    dp_nominal=50)
    "Performance dataset of the air filter"
    annotation (Placement(transformation(extent={{-80,64},{-60,84}})));

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    V=V,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    mSenFac=3)
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
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
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=mA_flow_nominal,
    m2_flow_nominal=mA_flow_nominal,
    dp1_nominal=200,
    dp2_nominal=200,
    eps=eps) "Heat recovery"
    annotation (Placement(transformation(extent={{-60,-36},{-40,-16}})));
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
        origin={10,-26})));
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
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    nPorts=1,
    redeclare package Medium = MediumW) "Sink for water circuit"
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
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHXOut(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for heat recovery outlet on supply side"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRooSetPoi(k=TRooSet)
    "Room temperature set point"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRoo
    "Room temperature sensor"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.Continuous.LimPID conRoo(
    k=0.1,
    Ti=60,
    yMax=mW_flow_nominal,
    reverseActing=false)
    "Room controller"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Buildings.Fluid.AirFilters.Empirical airFil(
    redeclare package Medium = MediumA,
    per=per)
    annotation (Placement(transformation(extent={{-128,-10},{-108,10}})));
  Modelica.Blocks.Sources.Ramp C_inflow(
    duration=87600/2,
    height=5/1000000000/1.293,
    offset=10/1000000000/1.293,
    startTime=15552000 + 87600/2)
    "Contaminant mass flow rate fraction"
    annotation (Placement(transformation(extent={{-170,-70},{-150,-50}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort C_out(
    redeclare package Medium =MediumA,
    m_flow_nominal=mA_flow_nominal,
    substanceName="PM10")
    "Trace substance sensor of outlet air"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant repSig(k=false)
    "Filter replacement signal"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
equation
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{60,50},{80,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{40,80},{70,80},{70,50},{80,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fan.port_b, vol.ports[1]) annotation (Line(
      points={{80,-20},{89,-20},{89,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], hex.port_a2) annotation (Line(
      points={{91,40},{91,-46},{-32,-46},{-32,-32},{-40,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souWat.ports[1], cooCoi.port_a1)   annotation (Line(
      points={{0,-120},{26,-120},{26,-32},{20,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b1, sinWat.ports[1])    annotation (Line(
      points={{0,-32},{-6,-32},{-6,-66},{-60,-66}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, out.weaBus) annotation (Line(
      points={{-140,50},{-120,50},{-120,30},{-170,30},{-170,-21.8},{-162,-21.8}},
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
      points={{-109.95,50.05},{-66,50.05},{-66,50},{-2,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(fan.m_flow_in, mAir_flow.y) annotation (Line(
      points={{70,-8},{70,20},{62,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b1, senTemHXOut.port_a) annotation (Line(
      points={{-40,-20},{-30,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemHXOut.port_b, cooCoi.port_a2) annotation (Line(
      points={{-10,-20},{0,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b2, senTemSupAir.port_a) annotation (Line(
      points={{20,-20},{30,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSupAir.port_b, fan.port_a) annotation (Line(
      points={{50,-20},{60,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port, theCon.port_a) annotation (Line(
      points={{20,50},{40,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort, senTemRoo.port) annotation (Line(
      points={{80,50},{70,50},{70,80},{80,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conRoo.y, souWat.m_flow_in)
    annotation (Line(points={{-79,-110},{-40,-110},{-40,-112},{-22,-112}}, color={0,0,127}));
  connect(conRoo.u_s, TRooSetPoi.y)
    annotation (Line(points={{-102,-110},{-118,-110}}, color={0,0,127}));
  connect(conRoo.u_m, senTemRoo.T) annotation (Line(points={{-90,-122},{-90,-142},
          {110,-142},{110,80},{101,80}},color={0,0,127}));
  connect(out.ports[1], airFil.port_a) annotation (Line(points={{-142,-23},{
          -136,-23},{-136,0},{-128,0}}, color={0,127,255}));
  connect(out.ports[2], hex.port_b2) annotation (Line(points={{-142,-21},{-136,-21},
          {-136,-32},{-60,-32}}, color={0,127,255}));
  connect(C_inflow.y, out.C_in[1]) annotation (Line(points={{-149,-60},{-140,-60},
          {-140,-42},{-170,-42},{-170,-30},{-164,-30}}, color={0,0,127}));
  connect(airFil.port_b, C_out.port_a)
    annotation (Line(points={{-108,0},{-100,0}}, color={0,127,255}));
  connect(C_out.port_b, hex.port_a1) annotation (Line(points={{-80,0},{-68,0},{-68,
          -20},{-60,-20}}, color={0,127,255}));
  connect(repSig.y,airFil.uRes)
    annotation (Line(points={{-138,10},{-138,6},{-130,6}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This block is identical to
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>,
except that an air filter is added to the cooling system.
</p>
<p>
The major input signals for the air filter are configured as follows:
</p>
<ul>
<li>
The input trace substance <i>C_inflow.y</i> changes from 10 &#181;g/m&sup3; (7.73e-9 kg/kg) to 15 &#181;g/m&sup3;
(1.15e-8 kg/kg) at 12:00 (15552000+12*3600 seconds).
</li>
<li>
the filter replacement signal <code>repSig</code> is false.
</li>
</ul>
<p>
The expected output are:
</p>
<ul>
<li>
The ratio of the outlet trace substance <i>C_out.C</i> to the <i>C_inflow.y</i> slightly decreases. 
</li>
<li>
The fan power  <i>fan.P</i> slightly increases. 
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
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/AirFilters/Examples/SpaceCooling.mos"
        "Simulate and plot"),
    experiment(StartTime=15552000, Tolerance=1e-6, StopTime=15638400));
end SpaceCooling;
