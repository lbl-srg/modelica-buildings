within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Examples.BaseClasses;
model MultipleBoreholesWithHeatPump
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);
  parameter Integer lenSim=3600*24*20;
  MultipleBoreHoles multipleBoreholes(lenSim=lenSim, bfData=bfData,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-24,-48},{24,0}})));
  Production.HeatPumpTset  heatPumpOnOff(
    redeclare package MediumBrine = Medium,
    redeclare package MediumFluid = Medium,
    allowFlowReversal=false,
    use_scaling=true,
    redeclare IDEAS.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA45
      heatPumpData,
    P_the_nominal=bfData.P_the_nominal/2)
                     annotation (Placement(transformation(
        extent={{-15,-17},{15,17}},
        rotation=90,
        origin={1,31})));
  Movers.Pump pump_pri(
    m=1,
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal) "pump of the primary circuit"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-44,-6})));
  Sensors.TemperatureTwoPort TSen_pri(
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal,
    tau=60,
    T_start=bfData.steRes.T_ini) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={46,-8})));
  parameter Data.BorefieldData.example_accurate
    bfData
    annotation (Placement(transformation(extent={{-90,-88},{-70,-68}})));
  Modelica.Fluid.Interfaces.FluidPort_b fluidOut1(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  Modelica.Fluid.Interfaces.FluidPort_a fluidIn1(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{30,90},{50,110}})));
  Modelica.Blocks.Interfaces.RealInput Tset1 "Condensor temperature setpoint"
    annotation (Placement(transformation(extent={{-128,-20},{-88,20}})));
equation
  connect(heatPumpOnOff.P_evap_val,multipleBoreholes. Q_flow) annotation (Line(
      points={{1,14.5},{1,-1.02857},{0,-1.02857}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multipleBoreholes.flowPort_b,pump_pri. port_a) annotation (Line(
      points={{-24,-24},{-44,-24},{-44,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_pri.port_b,heatPumpOnOff. brineIn) annotation (Line(
      points={{-44,4},{-44,16},{-5.8,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPumpOnOff.brineOut,TSen_pri. port_a) annotation (Line(
      points={{7.8,16},{46,16},{46,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_pri.port_b,multipleBoreholes. flowPort_a) annotation (Line(
      points={{46,-18},{46,-24},{24,-24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPumpOnOff.fluidOut, fluidOut1) annotation (Line(
      points={{-5.8,46},{-40,46},{-40,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPumpOnOff.fluidIn, fluidIn1) annotation (Line(
      points={{7.8,46},{40,46},{40,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPumpOnOff.Tset, Tset1) annotation (Line(
      points={{-17.36,28},{-80,28},{-80,0},{-108,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end MultipleBoreholesWithHeatPump;
