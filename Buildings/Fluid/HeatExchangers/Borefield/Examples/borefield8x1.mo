within Buildings.Fluid.HeatExchangers.Borefield.Examples;
model borefield8x1
  "Model of a borefield in a 8x1 boreholes line configuration and a constant heat injection rate"

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter Data.BorefieldData.SandStone_Bentonite_c8x1_h110_b5_d3600_T283
    bfData
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  parameter Integer lenSim=3600*24*366 "length of the simulation";

  MultipleBoreHoles multipleBoreholes(
    lenSim=lenSim,
    redeclare package Medium = Medium,
    bfData=bfData) "borefield"
    annotation (Placement(transformation(extent={{-20,-60},{20,-20}})));
  Modelica.Blocks.Sources.Step load(height=1, startTime=36000)
    "load for the borefield"
    annotation (Placement(transformation(extent={{26,-18},{40,-4}})));

  HeaterCoolerPrescribed hea(
    redeclare package Medium = Medium,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    T_start=bfData.gen.T_start,
    m_flow_nominal=bfData.m_flow_nominal,
    m_flow(start=bfData.m_flow_nominal),
    Q_flow_nominal=bfData.gen.q_ste*bfData.gen.nbBh*bfData.gen.hBor,
    p_start=100000)
    annotation (Placement(transformation(extent={{30,22},{10,2}})));
  Modelica.Fluid.Sources.Boundary_pT boundary(          redeclare package
      Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal,
    T_start=bfData.gen.T_start)
    annotation (Placement(transformation(extent={{38,-50},{58,-30}})));
  Movers.FlowMachine_m_flow pum(
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.gen.m_flow_nominal_bh,
    dynamicBalance=false,
    T_start=bfData.gen.T_start)
    annotation (Placement(transformation(extent={{-16,22},{-36,2}})));
  Modelica.Blocks.Sources.Constant mFlo(k=bfData.gen.m_flow_nominal_bh)
    annotation (Placement(transformation(extent={{-60,-18},{-48,-6}})));
equation
  connect(load.y, hea.u) annotation (Line(
      points={{40.7,-11},{52,-11},{52,6},{32,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hea.port_a, senTem.port_b) annotation (Line(
      points={{30,12},{70,12},{70,-40},{58,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.port_a, multipleBoreholes.port_b) annotation (Line(
      points={{38,-40},{20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mFlo.y, pum.m_flow_in) annotation (Line(
      points={{-47.4,-12},{-25.8,-12},{-25.8,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pum.port_a, hea.port_b) annotation (Line(
      points={{-16,12},{10,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_b, multipleBoreholes.port_a) annotation (Line(
      points={{-36,12},{-78,12},{-78,-40},{-20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boundary.ports[1], pum.port_b) annotation (Line(
      points={{-40,50},{-36,50},{-36,12}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                    graphics),
    experiment(StopTime=1.7e+006, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput);
end borefield8x1;
