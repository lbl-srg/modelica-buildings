within Buildings.Fluid.Movers.Examples;
model FlowMachine
  extends Modelica.Icons.Example;
  import Buildings;

   package Medium = Buildings.Media.IdealGases.SimpleAir;
    Modelica.Blocks.Sources.Ramp P(
    height=-1500,
    offset=101325,
    duration=1.5)
                 annotation (Placement(transformation(extent={{-80,-2},{-60,18}},
          rotation=0)));
  Buildings.Fluid.Movers.FlowMachinePolynomial fan(
    D=0.6858,
    a={4.2904,-1.387,4.2293,-3.92920,0.8534},
    b={0.1162,1.5404,-1.4825,0.7664,-0.1971},
    mNorMin_flow=1,
    mNorMax_flow=2,
    redeclare package Medium = Medium,
    m_flow_nominal=10)     annotation (Placement(transformation(extent={{0,-10},{20,10}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant N(k=22.3333)
                                         annotation (Placement(transformation(
          extent={{-40,30},{-20,50}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      = Medium,
    use_p_in=true,
    nPorts=1,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{-42,-10},{-22,10}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    use_p_in=true,
    nPorts=1,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{60,-10},{40,10}}, rotation=0)));
    Modelica.Blocks.Sources.Constant PAtm(k=101325)
      annotation (Placement(transformation(extent={{40,32},{60,52}}, rotation=0)));
  Buildings.Utilities.Reports.Printer printer(
    nin=6,
    header="time dp dpNorm mNorm m_flow power")
    annotation (Placement(transformation(extent={{16,-42},{36,-22}}, rotation=0)));
  Modelica.Blocks.Sources.RealExpression fan_mFlow(y=fan.m_flow)
    annotation (Placement(transformation(extent={{-40,-94},{-20,-74}}, rotation=
           0)));
  Modelica.Blocks.Sources.RealExpression simTim2(y=time)
    annotation (Placement(transformation(extent={{-40,-32},{-20,-12}}, rotation=
           0)));
  Modelica.Blocks.Sources.RealExpression fan_dp(y=fan.dp)
    annotation (Placement(transformation(extent={{-40,-48},{-20,-28}}, rotation=
           0)));
  Modelica.Blocks.Sources.RealExpression fan_dpNor(y=fan.pNor)
    annotation (Placement(transformation(extent={{-40,-64},{-20,-44}}, rotation=
           0)));
  Modelica.Blocks.Sources.RealExpression fan_mNor(y=fan.mNor_flow)
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}}, rotation=
           0)));
  Modelica.Blocks.Sources.RealExpression fan_PSha(y=fan.PSha)
    annotation (Placement(transformation(extent={{-40,-106},{-20,-86}},
          rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Buildings.Fluid.Sensors.Temperature TIn(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,54},{10,74}})));
  Buildings.Fluid.Sensors.Temperature TOut(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{10,66},{30,86}})));
  Buildings.Utilities.Diagnostics.AssertInequality assertInequality
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation

  connect(simTim2.y, printer.x[1]) annotation (Line(points={{-19,-22},{-2,-22},
          {-2,-33.6667},{14,-33.6667}}, color={0,0,127}));
  connect(fan_dp.y, printer.x[2]) annotation (Line(points={{-19,-38},{-4,-38},{
          -4,-33},{14,-33}}, color={0,0,127}));
  connect(fan_dpNor.y, printer.x[3]) annotation (Line(points={{-19,-54},{-8,-54},
          {-8,-32.3333},{14,-32.3333}}, color={0,0,127}));
  connect(fan_mNor.y, printer.x[4]) annotation (Line(points={{-19,-70},{-8,-70},
          {-8,-31.6667},{14,-31.6667}}, color={0,0,127}));
  connect(fan_PSha.y, printer.x[6]) annotation (Line(points={{-19,-96},{0,-96},
          {0,-30.3333},{14,-30.3333}}, color={0,0,127}));
  connect(fan_mFlow.y, printer.x[5]) annotation (Line(points={{-19,-84},{-6,-84},
          {-6,-31},{14,-31}}, color={0,0,127}));
  connect(N.y, fan.N_in) annotation (Line(points={{-19,40},{10,40},{10,7}},
               color={0,0,127}));
  connect(P.y, sou.p_in) annotation (Line(points={{-59,8},{-44,8},{-44,8}},
                                            color={0,0,127}));
  connect(PAtm.y, sin.p_in) annotation (Line(points={{61,42},{74,42},{74,8},{62,
          8}}, color={0,0,127}));
  connect(sou.ports[1], fan.port_a) annotation (Line(
      points={{-22,6.66134e-16},{-16.5,6.66134e-16},{-16.5,1.27676e-15},{-11,
          1.27676e-15},{-11,6.10623e-16},{-5.55112e-16,6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan.port_b, sin.ports[1]) annotation (Line(
      points={{20,6.10623e-16},{25,6.10623e-16},{25,1.27676e-15},{30,
          1.27676e-15},{30,6.66134e-16},{40,6.66134e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan.port_a, TIn.port) annotation (Line(
      points={{-5.55112e-16,6.10623e-16},{-5.55112e-16,13.5},{5.55107e-17,13.5},
          {5.55107e-17,27},{6.10623e-16,27},{6.10623e-16,54}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan.port_b, TOut.port) annotation (Line(
      points={{20,6.10623e-16},{20,66}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.T, assertInequality.u1) annotation (Line(
      points={{27,76},{58,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn.T, assertInequality.u2) annotation (Line(
      points={{7,64},{58,64}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                        graphics),
            __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/FlowMachine.mos" "Simulate and plot"),
              Diagram);
end FlowMachine;
