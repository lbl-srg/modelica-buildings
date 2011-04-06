within Buildings.Airflow.Multizone.Examples;
model Orifice
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.PerfectGases.MoistAirUnsaturated;
  Buildings.Airflow.Multizone.Orifice ori(redeclare package Medium = Medium, A=
        0.2) annotation (Placement(transformation(extent={{0,14},{20,34}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT roo1(
    redeclare package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{-60,14},{-40,34}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT roo2(
    redeclare package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(
        origin={70,24},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Modelica.Blocks.Sources.Ramp Ramp1(
    duration=0.5,
    height=2,
    offset=-1,
    startTime=0.25) annotation (Placement(transformation(extent={{-4,-48},{16,-28}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant Pre(k=100000) annotation (Placement(
        transformation(extent={{-100,-20},{-80,0}},  rotation=0)));
  Modelica.Blocks.Math.Add Add1 annotation (Placement(transformation(extent={{
            44,-30},{64,-10}}, rotation=0)));
  Modelica.Blocks.Sources.Constant Tem1(k=273.15 + 5) annotation (Placement(
        transformation(extent={{-100,20},{-80,40}},rotation=0)));
  Modelica.Blocks.Sources.Constant Tem2(k=273.15 + 20) annotation (Placement(
        transformation(extent={{58,48},{78,68}}, rotation=0)));

  Fluid.Sensors.DensityTwoPort    den1(redeclare package Medium = Medium,
      m_flow_nominal=0.1) "Density sensor"
                     annotation (Placement(transformation(extent={{-30,14},{-10,
            34}}, rotation=0)));
  Fluid.Sensors.DensityTwoPort    den2(redeclare package Medium = Medium,
      m_flow_nominal=0.1) "Density sensor"
                     annotation (Placement(transformation(extent={{30,14},{50,
            34}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
equation
  connect(Pre.y, Add1.u1) annotation (Line(points={{-79,-10},{-42,-10},{-42,-14},
          {42,-14}}, color={0,0,255}));
  connect(Ramp1.y, Add1.u2) annotation (Line(points={{17,-38},{26,-38},{26,-26},
          {42,-26}}, color={0,0,255}));
  connect(Tem1.y, roo1.T_in) annotation (Line(
      points={{-79,30},{-62,30},{-62,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Pre.y, roo1.p_in) annotation (Line(
      points={{-79,-10},{-70,-10},{-70,32},{-62,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Add1.y, roo2.p_in) annotation (Line(
      points={{65,-20},{90,-20},{90,16},{82,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tem2.y, roo2.T_in) annotation (Line(
      points={{79,58},{90,58},{90,20},{82,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo1.ports[1], den1.port_a) annotation (Line(
      points={{-40,24},{-30,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(den1.port_b, ori.port_a) annotation (Line(
      points={{-10,24},{0,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ori.port_b, den2.port_a) annotation (Line(
      points={{20,24},{30,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(den2.port_b, roo2.ports[1]) annotation (Line(
      points={{50,24},{60,24}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Commands(file="Orifice.mos" "run"),
    Diagram);
end Orifice;
