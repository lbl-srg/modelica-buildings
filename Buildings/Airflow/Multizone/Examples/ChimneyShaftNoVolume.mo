within Buildings.Airflow.Multizone.Examples;
model ChimneyShaftNoVolume
  "Model that demonstrates the chimney effect with a steady-state model of a shaft"
  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Air.SimpleAir;

  Buildings.Fluid.MixingVolumes.MixingVolume roo(
    V=2.5*5*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 20,
    redeclare package Medium = Medium,
    m_flow_nominal=0.05,
    p_start=101325,
    nPorts=3) "Air volume of a room"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Airflow.Multizone.Orifice oriChiTop(
    m=0.5,
    redeclare package Medium = Medium,
    A=0.01) annotation (Placement(transformation(
        origin={70,11},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Fluid.Sources.Boundary_pT bou0(
    redeclare package Medium = Medium,
    T=273.15,
    nPorts=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,50})));
  Buildings.Airflow.Multizone.Orifice oriBot(
    m=0.5,
    redeclare package Medium = Medium,
    A=0.01) annotation (Placement(transformation(
        origin={110,-20},
        extent={{10,-10},{-10,10}},
        rotation=90)));
  Modelica.Blocks.Sources.CombiTimeTable mRoo_flow(tableOnFile=false, table=[0,
        0.05; 600,0.05; 601,0; 1800,0; 1801,-0.05; 2400,-0.05; 2401,0; 3600,0])
    "Mass flow into and out of room to fill the medium column with air of different temperature"
    annotation (Placement(transformation(extent={{-90,-82},{-70,-62}})));
  MediumColumn staOut(
    redeclare package Medium = Medium,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop,
    h=1.5) "Model for stack effect outside the room"
    annotation (Placement(transformation(extent={{100,-1},{120,19}})));
  Buildings.Airflow.Multizone.Orifice oriChiBot(
    m=0.5,
    redeclare package Medium = Medium,
    A=0.01) annotation (Placement(transformation(
        origin={70,-49},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,10})));
  Modelica.Blocks.Continuous.LimPID con(
    Td=10,
    yMax=1,
    yMin=-1,
    Ti=60,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=5) "Controller to maintain volume temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant TSet(k=293.15) "Temperature set point"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Temperature sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-80,0})));
  Modelica.Blocks.Math.Gain gain(k=3000)
    annotation (Placement(transformation(extent={{-28,20},{-8,40}})));
  Buildings.Airflow.Multizone.MediumColumn sha(redeclare package Medium = Medium,
      densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.actual) "Shaft of chimney"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  MediumColumn staIn(
    redeclare package Medium = Medium,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom,
    h=1.5) "Model for stack effect inside the room"
    annotation (Placement(transformation(extent={{100,-59},{120,-39}})));

equation
  connect(TSet.y, con.u_s) annotation (Line(
      points={{-69,30},{-62,30}},
      color={0,0,127}));
  connect(temSen.T, con.u_m) annotation (Line(
      points={{-70,6.10623e-16},{-50,6.10623e-16},{-50,18}},
      color={0,0,127}));
  connect(gain.u, con.y) annotation (Line(
      points={{-30,30},{-39,30}},
      color={0,0,127}));
  connect(gain.y, preHea.Q_flow) annotation (Line(
      points={{-7,30},{2.50304e-15,30},{2.50304e-15,20}},
      color={0,0,127}));
  connect(sha.port_a, oriChiTop.port_a) annotation (Line(
      points={{70,-10},{70,1}},
      color={0,127,255}));
  connect(sha.port_b, oriChiBot.port_b) annotation (Line(
      points={{70,-30},{70,-39}},
      color={0,127,255}));
  connect(staOut.port_b, oriBot.port_a) annotation (Line(
      points={{110,-1},{110,-10}},
      color={0,127,255}));
  connect(preHea.port, roo.heatPort) annotation (Line(
      points={{-1.22629e-15,1.22125e-15},{-1.22629e-15,-20},{0,-20},{0,-50},{20,
          -50}},
      color={191,0,0}));
  connect(roo.heatPort, temSen.port) annotation (Line(
      points={{20,-50},{-40,-50},{-40,-20},{-96,-20},{-96,6.10623e-16},{-90,
          6.10623e-16}},
      color={191,0,0}));
  connect(bou0.ports[1], oriChiTop.port_b)  annotation (Line(
      points={{92,40},{88,40},{88,34},{70,34},{70,21}},
      color={0,127,255}));
  connect(bou0.ports[2], staOut.port_a) annotation (Line(
      points={{88,40},{92,40},{92,34},{110,34},{110,19}},
      color={0,127,255}));
  connect(oriBot.port_b, staIn.port_a)   annotation (Line(
      points={{110,-30},{110,-39}},
      color={0,127,255}));
  connect(mRoo_flow.y[1], boundary.m_flow_in) annotation (Line(
      points={{-69,-72},{-40,-72}},
      color={0,0,127}));
  connect(boundary.ports[1], roo.ports[1]) annotation (Line(
      points={{-20,-80},{27.3333,-80},{27.3333,-60}},
      color={0,127,255}));
  connect(roo.ports[2], staIn.port_b)   annotation (Line(
      points={{30,-60},{30,-80},{110,-80},{110,-59}},
      color={0,127,255}));
  connect(roo.ports[3], oriChiBot.port_a) annotation (Line(
      points={{32.6667,-60},{32.6667,-72},{70,-72},{70,-59}},
      color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {140,100}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/ChimneyShaftNoVolume.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model demonstrate buoyancy-induced air flow
through a vertical shaft.
On the right, there are two flow paths that are connected
to a volume, which is kept at 20&deg;C through a feedback
controller, and to the ambient, which is at
0&deg;C.
The flow path on the very right consists of an orifice
and two models that compute the pressure difference
<i>&Delta;p</i>
between
the bottom and top of the medium column using <i>&Delta;p=h &rho; g</i>,
where
<i>h</i> is the height of the medium column,
<i>&rho;</i> is the density of the medium column and
<i>g</i> is the gravity constant.
</p>
<p>
The top model is parameterized to use the
density from the ambient,
whereas the bottom model is parameterized to use
the density from the room volume, regardless of
the flow direction.
In the other flow path, the model <code>sha</code>
is parameterized to use the density of the inflowing
medium.
Thus, these models can be thought of as a chimney to the left,
and a roof with a leakage on the right. The chimney height starts
<i>1.5</i> m below the roof, and ends <i>1.5</i> m above the roof.
</p>
<p>
The flow boundary condition of the model
<code>boundary</code> is such that at the start
of the simulation, air flows from <code>boundary</code>
to <code>roo</code> until <i>t=600</i> seconds. Then, the flow rate
is set to zero until <i>t=1800</i> seconds.
Since the shaft <code>sha</code> is filled with
20&deg;C air, there is a circulation in the clock-wise
direction; up the shaft, and down the other flow path.
Next, until <i>t=2400</i> seconds, air is extracted from
the volume <code>roo</code>, and then the flow rate
of <code>boundary</code> is set to zero. Since the
shaft <code>sha</code> is now filed with air at 0&deg;C,
there is a counter clock-wise flow; down the shaft, and
up the other flow path.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2015 by Michael Wetter:<br/>
Changed media to
<a href=\"modelica://Modelica.Media.Air.SimpleAir\">
Modelica.Media.Air.SimpleAir</a>
in order to test the medium column for a media that has no moisture.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
November 10, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end ChimneyShaftNoVolume;
