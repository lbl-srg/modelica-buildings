within Buildings.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses;
partial model PartialOneRoomRadiator
  "Simple room model with radiator, without a heat pump"
  replaceable package MediumAir =
      Buildings.Media.Air "Medium model for air";
  replaceable package MediumWat =
      Buildings.Media.Water "Medium model for water";

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=20000
    "Nominal heat flow rate of radiator";
  parameter Modelica.Units.SI.Temperature TRadSup_nominal=273.15 + 50
    "Radiator nominal supply water temperature";
  parameter Modelica.Units.SI.Temperature TRadRet_nominal=273.15 + 45
    "Radiator nominal return water temperature";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=Q_flow_nominal/4200
      /5 "Heat pump nominal mass flow rate in condenser";
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal(min=Modelica.Constants.eps)
    "Heat pump nominal mass flow rate in evaporator";
  parameter Modelica.Units.SI.Volume V=6*10*3 "Room volume";
  parameter Modelica.Units.SI.MassFlowRate mAirRoo_flow_nominal=V*1.2*6/3600
    "Nominal mass flow rate of room air";
  parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=Q_flow_nominal/5
    "Internal heat gains of the room";
  parameter Boolean witCoo=true "=true to simulate cooling behaviour";
//------------------------------------------------------------------------------//

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumAir,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mAirRoo_flow_nominal,
    V=V) annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=
        Q_flow_nominal/40)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(
    C=2*V*1.2*1006)
    "Heat capacity for furniture and walls"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Sources.CombiTimeTable timTab(
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      table=[-6*3600, 0;
              8*3600, QRooInt_flow;
             18*3600, 0]) "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_nominal,
    T_a_nominal=TRadSup_nominal,
    T_b_nominal=TRadRet_nominal,
    m_flow_nominal=mCon_flow_nominal,
    T_start=TRadSup_nominal) "Radiator"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSup(
    redeclare package Medium = MediumWat,
    m_flow_nominal=mCon_flow_nominal,
    T_start=TRadSup_nominal) "Supply water temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-20})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temRoo
    "Room temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={-38,30})));

//----------------------------------------------------------------------------//

  replaceable Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow pumHeaPum(
    redeclare package Medium = MediumWat,
    m_flow_nominal=mCon_flow_nominal,
    m_flow_start=mCon_flow_nominal,
    T_start=TRadSup_nominal,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump for radiator side" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-110})));
//----------------------------------------------------------------------------//

  Buildings.Fluid.Sensors.TemperatureTwoPort temRet(
    redeclare package Medium = MediumWat,
    m_flow_nominal=mCon_flow_nominal,
    T_start=TRadSup_nominal) "Return water temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-20})));

//------------------------------------------------------------------------------------//

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

//--------------------------------------------------------------------------------------//

  Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow pumHeaPumSou(
    redeclare package Medium = MediumWat,
    m_flow_start=mEva_flow_nominal,
    m_flow_nominal=mEva_flow_nominal,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump for heat pump source side" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-180})));
  Modelica.Blocks.Math.BooleanToReal booToReaPumCon(
    realTrue=mCon_flow_nominal,
    y(start=0)) "Pump signal" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-110})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumWat,
    T=281.15,
    nPorts=1) "Fluid source on source side"
    annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = MediumWat,
    T=283.15) "Fluid sink on source side"
    annotation (Placement(transformation(extent={{80,-210},{60,-190}})));
  Buildings.Fluid.Sources.Boundary_pT preSou(
    redeclare package Medium = MediumWat,
    T=TRadSup_nominal,
    nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{90,-130},{70,-110}})));

  Modelica.Blocks.Math.BooleanToReal booToReaPumEva(realTrue=1, y(start=0))
    "Pump signal" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-180})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaCoo if witCoo
    "Prescribed heat flow to trigger cooling"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Sources.Pulse cooLoa(
    amplitude=Q_flow_nominal/2,
    width=10,
    period=86400,
    startTime=86400/2) if witCoo "Cooling load with step" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,70})));
  Buildings.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses.OneRoomRadiatorHeatPumpControl oneRooRadHeaPumCtr(
    final witCoo=witCoo)
    "Control block for single room heat pump control"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Modelica.Blocks.Sources.BooleanConstant conPumAlwOn(final k=true)
    "Let the pumps always run, due to inertia of the heat pump" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-154,-140})));
equation
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{40,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{40,80},{50,80},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCap.port, vol.heatPort) annotation (Line(
      points={{70,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(timTab.y[1], preHea.Q_flow) annotation (Line(
      points={{1,80},{20,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSup.port_b, rad.port_a) annotation (Line(
      points={{-70,-10},{-70,0},{0,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temRoo.port, vol.heatPort) annotation (Line(
      points={{-28,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortCon, vol.heatPort) annotation (Line(
      points={{8,7.2},{8,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortRad, vol.heatPort) annotation (Line(
      points={{12,7.2},{12,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-200,50},{-150,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDryBul, TOut.T) annotation (Line(
      points={{-149.95,50.05},{-86,50.05},{-86,50},{-22,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TOut.port, theCon.port_a) annotation (Line(
      points={{0,50},{20,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumHeaPum.port_b, temSup.port_a)
    annotation (Line(points={{-70,-100},{-70,-30}},color={0,127,255}));
  connect(temRet.port_a, rad.port_b)
    annotation (Line(points={{60,-10},{60,0},{20,0}},     color={0,127,255}));
  connect(booToReaPumCon.y, pumHeaPum.m_flow_in)
    annotation (Line(points={{-99,-110},{-82,-110}}, color={0,0,127}));
  connect(sou.ports[1], pumHeaPumSou.port_a) annotation (Line(points={{-60,-200},
          {-30,-200},{-30,-190}}, color={0,127,255}));
  connect(preSou.ports[1], temRet.port_b) annotation (Line(points={{70,-120},{60,
          -120},{60,-30}}, color={0,127,255}));
  connect(booToReaPumEva.y, pumHeaPumSou.m_flow_in)
    annotation (Line(points={{-99,-180},{-42,-180}}, color={0,0,127}));

  connect(cooLoa.y, preHeaCoo.Q_flow)
    annotation (Line(points={{-119,70},{-100,70}}, color={0,0,127}));
  connect(preHeaCoo.port, heaCap.port) annotation (Line(points={{-80,70},{-60,70},
          {-60,66},{50,66},{50,50},{70,50}}, color={191,0,0}));
  connect(conPumAlwOn.y, booToReaPumEva.u) annotation (Line(points={{-143,-140},
          {-132,-140},{-132,-180},{-122,-180}}, color={255,0,255}));
  connect(conPumAlwOn.y, booToReaPumCon.u) annotation (Line(points={{-143,-140},
          {-132,-140},{-132,-110},{-122,-110}}, color={255,0,255}));
  connect(oneRooRadHeaPumCtr.TRadSup, temSup.T) annotation (Line(points={{
          -161.667,-75.8333},{-188,-75.8333},{-188,-20},{-81,-20}},    color={0,
          0,127}));
  connect(oneRooRadHeaPumCtr.TRooMea, temRoo.T) annotation (Line(points={{
          -161.667,-70},{-180,-70},{-180,30},{-49,30}},          color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
  Motivated by the example
  <a href=\"modelica://Buildings.Fluid.HeatPumps.Examples.ScrollWaterToWater_OneRoomRadiator\">
  Buildings.Fluid.HeatPumps.Examples.ScrollWaterToWater_OneRoomRadiator</a>,
  this example enables the use of the <code>ModularReversible</code>
  approach for heat pumps and chillers.
</p>
<p>
  Both heating and cooling of the room is possible by using
  the reversible approach. For heating, 20 degC room temperature
  is the set point, for cooling 23 degC.
</p>
<p>
  The radiator minimal supply temperature is 23 degC.
</p>
</html>", revisions="<html>
<ul>
<li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
<li>
January 27, 2017, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-240,-220},{100,
            100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/ScrollWaterToWater_OneRoomRadiator.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-08));
end PartialOneRoomRadiator;
