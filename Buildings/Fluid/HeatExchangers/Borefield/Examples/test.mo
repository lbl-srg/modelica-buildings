within Buildings.Fluid.HeatExchangers.Borefield.Examples;
model test
  "Model of a borefield with 8x1 borefield and a constant heat injection rate"

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter Data.BorefieldData.SandStone_Bentonite_c8x1_h110_b5_d600_T283
    bfData
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  parameter Integer lenSim=3600*101 "length of the simulation";

  MultipleBoreHoles multipleBoreholes(lenSim=lenSim, bfData=bfData,
    redeclare package Medium = Medium) "borefield"
    annotation (Placement(transformation(extent={{-20,-60},{20,-20}})));
  Modelica.Blocks.Sources.Step           load(height=1, startTime=0)
    "load for the borefield"
    annotation (Placement(transformation(extent={{26,-18},{40,-4}})));

  Movers.Pump                           pum(
    redeclare package Medium = Medium,
    useInput=true,
    T_start=bfData.gen.T_start,
    m_flow(start=bfData.m_flow_nominal),
    m_flow_nominal=bfData.m_flow_nominal)
    annotation (Placement(transformation(extent={{-10,22},{-30,2}})));
  Modelica.Blocks.Sources.Constant mFlo(k=1)
    annotation (Placement(transformation(extent={{-46,-12},{-34,0}})));
  HeaterCoolerPrescribed                            hea(
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
  Modelica.Fluid.Sources.Boundary_pT boundary(nPorts=1, redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal,
    T_start=bfData.gen.T_start)
    annotation (Placement(transformation(extent={{38,-50},{58,-30}})));
  Modelica.Blocks.Sources.Step           load1(
                                              height=1, startTime=0)
    "load for the borefield"
    annotation (Placement(transformation(extent={{34,-156},{48,-142}})));
  Movers.Pump                           pum1(
    redeclare package Medium = Medium,
    useInput=true,
    T_start=bfData.gen.T_start,
    m_flow(start=bfData.m_flow_nominal/bfData.gen.nbBh),
    m_flow_nominal=bfData.m_flow_nominal/bfData.gen.nbBh*bfData.gen.nbSer)
    annotation (Placement(transformation(extent={{-2,-116},{-22,-136}})));
  Modelica.Blocks.Sources.Constant mFlo1(
                                        k=1)
    annotation (Placement(transformation(extent={{-38,-150},{-26,-138}})));
  HeaterCoolerPrescribed                            hea1(
    redeclare package Medium = Medium,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    T_start=bfData.gen.T_start,
    Q_flow_nominal=bfData.gen.q_ste*bfData.gen.hBor,
    p_start=100000,
    m_flow_nominal=bfData.gen.m_flow_nominal_bh)
    annotation (Placement(transformation(extent={{38,-116},{18,-136}})));
  Modelica.Fluid.Sources.Boundary_pT boundary1(
                                              nPorts=1, redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{-52,-98},{-32,-78}})));
  Sensors.TemperatureTwoPort senTem1(
    redeclare package Medium = Medium,
    T_start=bfData.gen.T_start,
    m_flow_nominal=bfData.gen.m_flow_nominal_bh)
    annotation (Placement(transformation(extent={{46,-188},{66,-168}})));
  BaseClasses.BoreHoles.SingleBoreHolesInSerie borehole(
    soi=bfData.soi,
    gen=bfData.gen,
    redeclare package Medium = Medium,
    fil=bfData.fil)
    annotation (Placement(transformation(extent={{-24,-200},{32,-156}})));
equation
  connect(pum.port_a,hea. port_b) annotation (Line(
      points={{-10,12},{10,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mFlo.y,pum. m_flowSet) annotation (Line(
      points={{-33.4,-6},{-20,-6},{-20,1.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load.y, hea.u) annotation (Line(
      points={{40.7,-11},{52,-11},{52,6},{32,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundary.ports[1], pum.port_a) annotation (Line(
      points={{-40,50},{-10,50},{-10,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_b, multipleBoreholes.port_a) annotation (Line(
      points={{-30,12},{-60,12},{-60,-40},{-20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea.port_a, senTem.port_b) annotation (Line(
      points={{30,12},{70,12},{70,-40},{58,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.port_a, multipleBoreholes.port_b) annotation (Line(
      points={{38,-40},{20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum1.port_a, hea1.port_b) annotation (Line(
      points={{-2,-126},{18,-126}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mFlo1.y, pum1.m_flowSet) annotation (Line(
      points={{-25.4,-144},{-12,-144},{-12,-136.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load1.y, hea1.u) annotation (Line(
      points={{48.7,-149},{60,-149},{60,-132},{40,-132}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundary1.ports[1], pum1.port_a) annotation (Line(
      points={{-32,-88},{-2,-88},{-2,-126}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea1.port_a, senTem1.port_b) annotation (Line(
      points={{38,-126},{78,-126},{78,-178},{66,-178}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(borehole.port_b, senTem1.port_a) annotation (Line(
      points={{32,-178},{46,-178}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(borehole.port_a, pum1.port_b) annotation (Line(
      points={{-24,-178},{-54,-178},{-54,-126},{-22,-126}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-220},{100,
            100}}),     graphics),
    experiment(StopTime=1.7e+006, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-220},{100,100}})));
end test;
