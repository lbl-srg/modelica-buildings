within Buildings.HeatTransfer.Examples;
model ConductorSingleLayer "Test model for heat conductor"
  import Buildings;
  Buildings.HeatTransfer.ConductorSingleLayer con(
    mat=Buildings.HeatTransfer.Data.Brick(),
    x=0.2,
    n=5,
    A=1) annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TB(T=293.15) 
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TA 
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), Commands(file=
          "HeatTransfer/Examples/ConductorSingleLayer.mos" "run"));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=293.15,
    startTime=3600) 
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection 
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.Constant step1(k=10) 
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.HeatTransfer.ConductorSingleLayer con1(
    mat=Buildings.HeatTransfer.Data.Brick(),
    A=1,
    x=0.1,
    n=3) annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TB1(
                                                            T=293.15) 
    annotation (Placement(transformation(extent={{100,-40},{80,-20}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection1 
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TA1 
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.HeatTransfer.ConductorSingleLayer con2(
    mat=Buildings.HeatTransfer.Data.Brick(),
    A=1,
    x=0.1,
    n=3) annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
equation
  connect(con.port_b, TB.port) annotation (Line(
      points={{40,10},{60,10}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(TA.port, convection.solid) annotation (Line(
      points={{-40,10},{-20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(step.y, TA.T) annotation (Line(
      points={{-79,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convection.fluid, con.port_a) annotation (Line(
      points={{0,10},{20,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(step1.y, convection.Gc) annotation (Line(
      points={{-39,50},{-10,50},{-10,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convection1.fluid, con1.port_a) annotation (Line(
      points={{0,-30},{20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(step1.y, convection1.Gc) annotation (Line(
      points={{-39,50},{-30,50},{-30,-12},{-10,-12},{-10,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TA1.port, convection1.solid) annotation (Line(
      points={{-40,-30},{-20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(step.y, TA1.T) annotation (Line(
      points={{-79,10},{-72,10},{-72,-30},{-62,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con1.port_b, con2.port_a) annotation (Line(
      points={{40,-30},{50,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con2.port_b, TB1.port) annotation (Line(
      points={{70,-30},{80,-30}},
      color={191,0,0},
      smooth=Smooth.None));
end ConductorSingleLayer;
