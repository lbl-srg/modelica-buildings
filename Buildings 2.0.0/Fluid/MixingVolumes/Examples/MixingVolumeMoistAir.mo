within Buildings.Fluid.MixingVolumes.Examples;
model MixingVolumeMoistAir
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.001
    "Nominal mass flow rate";

  Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol1(
    redeclare package Medium = Medium,
    V=1,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal) "Volume"
          annotation (Placement(transformation(extent={{50,0},{70,20}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSen
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-68,82},{-48,102}})));
  Modelica.Blocks.Sources.Constant XSet(k=0.005)
    "Set point for water mass fraction" annotation (Placement(transformation(
          extent={{-80,-60},{-60,-40}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(extent={{36,120},{56,140}})));
  Modelica.Blocks.Sources.Constant TSet(k=273.15 + 20)
    "Set point for temperature" annotation (Placement(transformation(extent={{
            -80,120},{-60,140}})));
  Buildings.Utilities.Psychrometrics.pW_X humRat(           use_p_in=false)
    "Conversion from humidity ratio to partial water vapor pressure"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Utilities.Psychrometrics.TDewPoi_pW dewPoi "Dew point temperature"
                            annotation (Placement(transformation(extent={{12,-120},
            {32,-100}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
    annotation (Placement(transformation(extent={{64,120},{84,140}})));
  Modelica.Blocks.Continuous.Integrator QSen "Sensible heat transfer"
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
  Modelica.Blocks.Continuous.Integrator QLat "Enthalpy of extracted water"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));
  Modelica.Blocks.Sources.RealExpression QLat_flow(y=vol1.QLat_flow.y)
    "MoistAir heat flow rate" annotation (Placement(transformation(extent={{112,
            60},{132,80}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    T=293.15)    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(        redeclare package Medium =
        Medium,
    T=293.15,
    nPorts=1)             annotation (Placement(transformation(
        origin={160,0},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Buildings.Controls.Continuous.LimPID PI(
    Ni=0.1,
    yMax=1000,
    k=1,
    Ti=1,
    Td=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    wd=0,
    yMin=-1000)
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  Buildings.Controls.Continuous.LimPID PI1(
    Ni=0.1,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=10,
    yMax=1,
    yMin=-1,
    Td=1)
    annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));
  Buildings.Fluid.Sensors.MassFlowRate mIn_flow(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{6,-10},{26,10}})));
  Buildings.Fluid.Sensors.MassFlowRate mOut_flow(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{84,-10},{104,10}})));
  Modelica.Blocks.Math.Add dM_flow(k2=-1) annotation (Placement(transformation(
          extent={{140,20},{160,40}})));
  Modelica.Blocks.Math.Gain gai(k=200) annotation (Placement(transformation(
          extent={{2,120},{22,140}})));
  Modelica.Blocks.Math.Gain gai1(k=0.1) annotation (Placement(transformation(
          extent={{-20,-60},{0,-40}})));

    Buildings.Fluid.FixedResistances.FixedResistanceDpM res1(
    redeclare each package Medium = Medium,
    from_dp=true,
    dp_nominal=2.5,
    m_flow_nominal=m_flow_nominal)
             annotation (Placement(transformation(extent={{120,-10},{140,10}})));
equation
  connect(preHeaFlo.port, heatFlowSensor.port_a)
    annotation (Line(points={{56,130},{64,130}}, color={191,0,0}));
  connect(heatFlowSensor.Q_flow, QSen.u) annotation (Line(points={{74,120},{74,
          110},{138,110}}, color={0,0,127}));
  connect(QLat_flow.y,QLat. u) annotation (Line(points={{133,70},{138,70}},
        color={0,0,127}));
  connect(TSet.y, PI.u_s)
    annotation (Line(points={{-59,130},{-42,130}}, color={0,0,127}));
  connect(TSen.T, PI.u_m) annotation (Line(points={{-48,92},{-30,92},{-30,118}},
        color={0,0,127}));
  connect(XSet.y, PI1.u_s) annotation (Line(points={{-59,-50},{-52,-50}}, color=
         {0,0,127}));
  connect(mOut_flow.m_flow, dM_flow.u1) annotation (Line(points={{94,11},{94,36},
          {138,36}},       color={0,0,127}));
  connect(mIn_flow.m_flow, dM_flow.u2) annotation (Line(points={{16,11},{16,11},
          {16,24},{138,24}},                 color={0,0,127}));
  connect(gai.y, preHeaFlo.Q_flow)
    annotation (Line(points={{23,130},{36,130}}, color={0,0,127}));
  connect(PI1.y, gai1.u) annotation (Line(points={{-29,-50},{-22,-50}}, color={
          0,0,127}));
  connect(gai1.y, vol1.mWat_flow) annotation (Line(points={{1,-50},{32,-50},{32,
          18},{48,18}}, color={0,0,127}));
  connect(dewPoi.T, vol1.TWat) annotation (Line(points={{33,-110},{42,-110},{42,
          -66},{42,14.8},{48,14.8}}, color={0,0,255}));
  connect(vol1.X_w, PI1.u_m) annotation (Line(points={{72,6},{80,6},{80,-134},
          {-40,-134},{-40,-62}}, color={0,0,127}));
  connect(vol1.X_w, humRat.X_w) annotation (Line(points={{72,6},{80,6},{80,
          -134},{-28,-134},{-28,-110},{-21,-110}}, color={0,0,127}));
  connect(sou.ports[1], mIn_flow.port_a) annotation (Line(
      points={{-20,0},{-13.5,0},{-13.5,1.27676e-015},{-7,1.27676e-015},{-7,0},{
          6,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatFlowSensor.port_b, vol1.heatPort) annotation (Line(
      points={{84,130},{86,130},{86,40},{50,40},{50,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TSen.port, vol1.heatPort) annotation (Line(
      points={{-68,92},{-72,92},{-72,40},{50,40},{50,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mIn_flow.port_b, vol1.ports[1]) annotation (Line(
      points={{26,0},{58,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mOut_flow.port_a, vol1.ports[2]) annotation (Line(
      points={{84,0},{62,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PI.y, gai.u) annotation (Line(
      points={{-19,130},{0,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(humRat.p_w, dewPoi.p_w) annotation (Line(
      points={{1,-110},{11,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mOut_flow.port_b, res1.port_a) annotation (Line(
      points={{104,0},{120,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, sin.ports[1]) annotation (Line(
      points={{140,0},{150,0}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -160},{180,160}}),      graphics),
experiment(StopTime=600,
           Tolerance=1e-6),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Examples/MixingVolumeMoistAir.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir\">
Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir</a>.
After an initial transient, the temperature and humidity of the volume
stabilizes.
</p>
</html>", revisions="<html>
<ul>
<li>
February 11, 2014 by Michael Wetter:<br/>
Changed
<code>HWat_flow(y=vol1.HWat_flow</code> to
<code>QLat_flow(y=vol1.QLat_flow.y)</code>
and
<code>QWat</code> to <code>QLat</code>.
</li>
<li>
October 12, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MixingVolumeMoistAir;
