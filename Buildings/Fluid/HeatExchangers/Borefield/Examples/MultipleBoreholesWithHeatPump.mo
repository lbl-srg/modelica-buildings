within Buildings.Fluid.HeatExchangers.Borefield.Examples;
model MultipleBoreholesWithHeatPump
  "Model of a borefield with axb borefield and a constant heat injection rate"

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter Modelica.SIunits.HeatFlowRate q = 30
    "heat flow rate which is injected per meter depth of borehole";

  parameter Data.BorefieldData.SandStone_Bentonite_c8x1_h110_b5_d600_T283
    bfData
    annotation (Placement(transformation(extent={{-90,74},{-70,94}})));
  parameter Integer lenSim=3600*24*20 "length of the simulation";

  MultipleBoreHoles multipleBoreholes(lenSim=lenSim, bfData=bfData,
    redeclare package Medium = Medium) "borefield"
    annotation (Placement(transformation(extent={{12,-78},{-28,-38}})));

  Movers.Pump                           pum(
    redeclare package Medium = Medium,
    useInput=true,
    T_start=bfData.gen.T_start,
    m_flow(start=bfData.m_flow_nominal),
    m_flow_nominal=bfData.m_flow_nominal)
    annotation (Placement(transformation(extent={{-38,4},{-18,-16}})));
  Modelica.Blocks.Sources.Constant mFlo(k=1)
    annotation (Placement(transformation(extent={{-8,-30},{-20,-18}})));
  Modelica.Fluid.Sources.Boundary_pT boundary(          redeclare package
      Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{-94,-68},{-74,-48}})));
  Production.HeatPumpOnOff heatPumpOnOff(
    redeclare package MediumBrine = Medium,
    redeclare package MediumFluid = Medium,
    allowFlowReversal=false,
    onOff=true,
    use_scaling=true,
    redeclare Buildings.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA45
      heatPumpData,
    use_onOffSignal=true,
    P_the_nominal=bfData.PThe_nominal/2)
                     annotation (Placement(transformation(
        extent={{-15,-17},{15,17}},
        rotation=90,
        origin={1,25})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(width=50, period=100000)
    annotation (Placement(transformation(extent={{-80,12},{-60,32}})));
  Sensors.TemperatureTwoPort TSen_sec(
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal,
    tau=60,
    T_start=bfData.gen.T_start) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-24,54})));
  Movers.Pump       pump(
    m=1,
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal)
    annotation (Placement(transformation(extent={{12,60},{-8,80}})));
  Sources.Boundary_pT bou(          redeclare package Medium = Medium,
    nPorts=3,
    use_T_in=true,
    p=200000)
    annotation (Placement(transformation(extent={{52,58},{32,78}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/5000,
    amplitude=4,
    offset=273.15 + 30,
    startTime=2000)
    annotation (Placement(transformation(extent={{90,62},{70,82}})));
  Sensors.TemperatureTwoPort TSen_pri(
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal,
    tau=60,
    T_start=bfData.gen.T_start) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-62,-26})));
equation
  connect(mFlo.y,pum. m_flowSet) annotation (Line(
      points={{-20.6,-24},{-28,-24},{-28,-16.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundary.ports[1], multipleBoreholes.port_b) annotation (Line(
      points={{-74,-58},{-28,-58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(booleanPulse.y,heatPumpOnOff. on) annotation (Line(
      points={{-59,22},{-17.36,22}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(pump.port_b,TSen_sec. port_a) annotation (Line(
      points={{-8,70},{-24,70},{-24,64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.ports[1],pump. port_a) annotation (Line(
      points={{32,70.6667},{22,70.6667},{22,70},{12,70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPumpOnOff.fluidIn,bou. ports[2]) annotation (Line(
      points={{7.8,40},{32,40},{32,68}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_sec.port_b, heatPumpOnOff.fluidOut) annotation (Line(
      points={{-24,44},{-24,40},{-5.8,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_b, heatPumpOnOff.brineIn) annotation (Line(
      points={{-18,-6},{-5.8,-6},{-5.8,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPumpOnOff.brineOut, multipleBoreholes.port_a) annotation (Line(
      points={{7.8,10},{8,10},{8,-6},{36,-6},{36,-58},{12,-58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.T_in, sine.y) annotation (Line(
      points={{54,72},{69,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pum.port_a, TSen_pri.port_b) annotation (Line(
      points={{-38,-6},{-62,-6},{-62,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_pri.port_a, multipleBoreholes.port_b) annotation (Line(
      points={{-62,-36},{-62,-58},{-28,-58}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=1.7e+006, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput);
end MultipleBoreholesWithHeatPump;
