within Buildings.Airflow.Multizone.Examples;
model Orifice
  extends Modelica.Icons.Example; 

  package Medium = Buildings.Media.PerfectGases.MoistAirUnsaturated;
  Buildings.Airflow.Multizone.Orifice ori(redeclare package Medium = Medium, A=
        0.2) annotation (Placement(transformation(extent={{-4,14},{16,34}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT roo1(
    redeclare package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{-50,14},{-30,34}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT roo2(
    redeclare package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(
        origin={58,24},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Modelica.Blocks.Sources.Ramp Ramp1(
    duration=0.5,
    height=2,
    offset=-1,
    startTime=0.25) annotation (Placement(transformation(extent={{-4,-48},{16,-28}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant Pre(k=100000) annotation (Placement(
        transformation(extent={{-90,-54},{-70,-34}}, rotation=0)));
  Modelica.Blocks.Math.Add Add1 annotation (Placement(transformation(extent={{
            44,-30},{64,-10}}, rotation=0)));
  Modelica.Blocks.Sources.Constant Tem1(k=273.15 + 5) annotation (Placement(
        transformation(extent={{-94,18},{-74,38}}, rotation=0)));
  Modelica.Blocks.Sources.Constant Tem2(k=273.15 + 20) annotation (Placement(
        transformation(extent={{58,48},{78,68}}, rotation=0)));

  Buildings.Fluid.Sensors.Density den1(redeclare package Medium = Medium)
    "Density sensor" annotation (Placement(transformation(extent={{-32,54},{-12,
            74}}, rotation=0)));
  Buildings.Fluid.Sensors.Density den2(redeclare package Medium = Medium)
    "Density sensor" annotation (Placement(transformation(extent={{18,54},{38,
            74}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
equation
  connect(Pre.y, Add1.u1) annotation (Line(points={{-69,-44},{-42,-44},{-42,-14},
          {42,-14}}, color={0,0,255}));
  connect(Ramp1.y, Add1.u2) annotation (Line(points={{17,-38},{26,-38},{26,-26},
          {42,-26}}, color={0,0,255}));
  connect(Tem1.y, roo1.T_in) annotation (Line(
      points={{-73,28},{-52,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Pre.y, roo1.p_in) annotation (Line(
      points={{-69,-44},{-64,-44},{-64,32},{-52,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Add1.y, roo2.p_in) annotation (Line(
      points={{65,-20},{90,-20},{90,16},{70,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tem2.y, roo2.T_in) annotation (Line(
      points={{79,58},{90,58},{90,20},{70,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo1.ports[1], ori.port_a) annotation (Line(
      points={{-30,24},{-4,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ori.port_a, den1.port) annotation (Line(
      points={{-4,24},{-22,24},{-22,54}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ori.port_b, roo2.ports[1]) annotation (Line(
      points={{16,24},{48,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ori.port_b, den2.port) annotation (Line(
      points={{16,24},{28,24},{28,54}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Commands(file="Orifice.mos" "run"),
    Diagram);
end Orifice;
