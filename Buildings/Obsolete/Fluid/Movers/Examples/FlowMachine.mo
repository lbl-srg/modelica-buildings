within Buildings.Obsolete.Fluid.Movers.Examples;
model FlowMachine "Fan with polynomial performance curve"
  extends Modelica.Icons.Example;

   package Medium = Buildings.Media.Air;
    Modelica.Blocks.Sources.Ramp P(
    height=-1500,
    offset=101325,
    duration=1.5)
                 annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
  Buildings.Obsolete.Fluid.Movers.FlowMachinePolynomial fan(
    D=0.6858,
    a={4.2904,-1.387,4.2293,-3.92920,0.8534},
    b={0.1162,1.5404,-1.4825,0.7664,-0.1971},
    mNorMin_flow=1,
    mNorMax_flow=2,
    redeclare package Medium = Medium,
    m_flow_nominal=10)     annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Constant N(k=22.3333)
                                         annotation (Placement(transformation(
          extent={{-60,30},{-40,50}})));
  Buildings.Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      = Medium,
    use_p_in=true,
    T=293.15,
    nPorts=1)                                       annotation (Placement(
        transformation(extent={{-62,-10},{-42,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    use_p_in=true,
    T=293.15,
    nPorts=1)                                       annotation (Placement(
        transformation(extent={{80,-10},{60,10}})));
    Modelica.Blocks.Sources.Constant PAtm(k=101325)
      annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Utilities.Reports.Printer printer(
    nin=6,
    header="time dp dpNorm mNorm m_flow power",
    samplePeriod=0.1)
    annotation (Placement(transformation(extent={{16,-42},{36,-22}})));
  Modelica.Blocks.Sources.RealExpression fan_mFlow(y=fan.m_flow)
    annotation (Placement(transformation(extent={{-40,-94},{-20,-74}})));
  Modelica.Blocks.Sources.RealExpression modTim2(y=time)
    annotation (Placement(transformation(extent={{-40,-32},{-20,-12}})));
  Modelica.Blocks.Sources.RealExpression fan_dp(y=fan.dp)
    annotation (Placement(transformation(extent={{-40,-48},{-20,-28}})));
  Modelica.Blocks.Sources.RealExpression fan_dpNor(y=fan.pNor)
    annotation (Placement(transformation(extent={{-40,-64},{-20,-44}})));
  Modelica.Blocks.Sources.RealExpression fan_mNor(y=fan.mNor_flow)
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.RealExpression fan_PSha(y=fan.PSha)
    annotation (Placement(transformation(extent={{-40,-106},{-20,-86}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      TIn(redeclare package Medium = Medium,
      m_flow_nominal=10)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                      TOut(redeclare package Medium = Medium,
      m_flow_nominal=10)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
equation

  connect(modTim2.y, printer.x[1]) annotation (Line(points={{-19,-22},{-2,-22},
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
  connect(N.y, fan.N_in) annotation (Line(points={{-39,40},{10,40},{10,7}},
               color={0,0,127}));
  connect(P.y, sou.p_in) annotation (Line(points={{-79,8},{-71.5,8},{-71.5,8},{
          -64,8}},                          color={0,0,127}));
  connect(PAtm.y, sin.p_in) annotation (Line(points={{81,40},{90,40},{90,8},{82,
          8}}, color={0,0,127}));
  connect(sou.ports[1], TIn.port_a) annotation (Line(
      points={{-42,6.66134e-16},{-38,6.66134e-16},{-38,6.10623e-16},{-30,
          6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn.port_b, fan.port_a) annotation (Line(
      points={{-10,6.10623e-16},{-6,-3.36456e-22},{-6,6.10623e-16},{
          -5.55112e-16,6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan.port_b, TOut.port_a) annotation (Line(
      points={{20,6.10623e-16},{26,-3.36456e-22},{26,6.10623e-16},{30,
          6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b, sin.ports[1]) annotation (Line(
      points={{50,6.10623e-16},{56,6.10623e-16},{56,6.66134e-16},{60,
          6.66134e-16}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Fluid/Movers/Examples/FlowMachine.mos"
        "Simulate and plot"));
end FlowMachine;
