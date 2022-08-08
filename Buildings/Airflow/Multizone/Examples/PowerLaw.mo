within Buildings.Airflow.Multizone.Examples;
model PowerLaw "Model with powerlaw models"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;
  Coefficient_m_flow pow_m_flow(
    redeclare package Medium = Medium,
    m=0.59,
    k=3.33e-5) "Mass flow rate based on powerlaw, direct input for m and C"
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
  Buildings.Fluid.Sources.Boundary_pT roo1(
    redeclare package Medium = Medium,
    use_p_in=true,
    nPorts=1,
    T=278.15) "Room 1"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Fluid.Sources.Boundary_pT roo2(
    redeclare package Medium = Medium,
    use_p_in=true,
    nPorts=1,
    T=293.15) "Room 2"
    annotation (Placement(transformation(
        origin={90,70},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=0.5,
    height=6,
    offset=-3,
    startTime=0.25) "Ramp"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Modelica.Blocks.Sources.Constant pressure(k=100000) "Pressure"
    annotation (Placement(transformation(extent={{-110,-80},{-90,-60}})));
  Modelica.Blocks.Math.Add add "Add"
    annotation (Placement(transformation(extent={{40,-86},{60,-66}})));
  Buildings.Fluid.Sensors.DensityTwoPort den1(
    redeclare package Medium = Medium,
    m_flow_nominal=0.1,
    tau=0,
    initType=Modelica.Blocks.Types.Init.InitialState) "Density sensor"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Fluid.Sensors.DensityTwoPort den2(
    redeclare package Medium = Medium,
    m_flow_nominal=0.1,
    tau=0,
    initType=Modelica.Blocks.Types.Init.InitialState) "Density sensor"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Coefficient_V_flow pow_V_flow(
    redeclare package Medium = Medium,
    m=0.59,
    C=3.33e-5/1.2)
    "Volume flow rate based on powerlaw, direct input for m and C"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Point_m_flow pow_1dat(
    redeclare package Medium = Medium,
    dpMea_nominal = 50,
    m=0.59,
    mMea_flow_nominal=1.2/3600)
    "Mass flow rate based on powerlaw, input of m and 1 test data point."
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Points_m_flow pow_2dat(
    redeclare package Medium = Medium,
    dpMea_nominal = {1, 50},
    mMea_flow_nominal={0.12, 1.2}/3600)
    "Mass flow rate based on powerlaw, input of 2 test data points."
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
equation
  connect(pressure.y, add.u1)
    annotation (Line(points={{-89,-70},{38,-70}}, color={0,0,255}));
  connect(ramp1.y, add.u2) annotation (Line(points={{21,-90},{26,-90},{26,-82},{
          38,-82}}, color={0,0,255}));
  connect(pressure.y, roo1.p_in) annotation (Line(points={{-89,-70},{-50,-70},{
          -50,-40},{-110,-40},{-110,78},{-102,78}},
                                        color={0,0,127}));
  connect(add.y, roo2.p_in) annotation (Line(points={{61,-76},{112,-76},{112,62},
          {102,62}}, color={0,0,127}));
  connect(roo1.ports[1], den1.port_a) annotation (Line(
      points={{-80,70},{-60,70}},
      color={0,127,255}));
  connect(den1.port_b, pow_m_flow.port_a)
    annotation (Line(points={{-40,70},{-40,90},{-10,90}},
                                                color={0,127,255}));
  connect(pow_m_flow.port_b, den2.port_a)
    annotation (Line(points={{10,90},{40,90},{40,70}},
                                               color={0,127,255}));
  connect(den2.port_b, roo2.ports[1]) annotation (Line(
      points={{60,70},{80,70}},
      color={0,127,255}));
  connect(den1.port_b, pow_V_flow.port_a) annotation (Line(points={{-40,70},{-40,
          50},{-10,50}},        color={0,127,255}));
  connect(pow_V_flow.port_b, den2.port_a) annotation (Line(points={{10,50},{40,50},
          {40,70}},         color={0,127,255}));
  connect(den1.port_b, pow_1dat.port_a) annotation (Line(points={{-40,70},{
          -40,10},{-10,10}},         color={0,127,255}));
  connect(den1.port_b, pow_2dat.port_a)
    annotation (Line(points={{-40,70},{-40,-30},{-10,-30}},color={0,127,255}));
  connect(pow_1dat.port_b, den2.port_a) annotation (Line(points={{10,10},{40,
          10},{40,70}},         color={0,127,255}));
  connect(pow_2dat.port_b, den2.port_a)
    annotation (Line(points={{10,-30},{40,-30},{40,70}}, color={0,127,255}));
  annotation (
experiment(
      StopTime=1,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/PowerLaw.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model demonstrates the use of the 4 PowerLaw models present in the multizone package.
The input data is fit so that all models have equivalent output.

The pressure difference across the models changes
between <i>-1</i> Pascal and <i>+1</i> Pascal, which
causes air to flow through the orifice.
</p>
</html>", revisions="<html>
<ul>
<li>
May 3, 2021 by Klaas De Jonge:<br/>
Added example for the four 'Powerlaw' models in the Multizone package.
</li>

</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-120},{120,100}})));
end PowerLaw;
