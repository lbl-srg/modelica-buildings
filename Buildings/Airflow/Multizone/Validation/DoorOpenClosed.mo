within Buildings.Airflow.Multizone.Validation;
model DoorOpenClosed
  "Model with operable door and door that is always open"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Medium model";

  Fluid.Sources.Boundary_pT bouA(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101330,
    T=294.15,
    nPorts=5) "Boundary condition at side a" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,0})));

  Fluid.Sources.Boundary_pT bouB(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325,
    T=293.15,
    nPorts=5) "Boundary condition at side b"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={80,0})));

  Buildings.Airflow.Multizone.DoorOpen doo(
    redeclare package Medium = Medium)
    "Open door that is always open"
           annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  EffectiveAirLeakageArea lea(
    redeclare package Medium = Medium,
    m=0.65,
    dp_turbulent=0.01,
    L=20*1E-4) "Leakage flow element"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  DoorOperable dooOpeClo(
    redeclare package Medium = Medium,
    LClo=20*1E-4)
               "Operable door"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Sources.Step yDoo(startTime=0.5) "Door opening signal"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Fluid.Sensors.MassFlowRate senMasFlo1(redeclare package Medium = Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{10,-12},{30,8}})));
  Fluid.Sensors.MassFlowRate senMasFlo2(
    redeclare package Medium = Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{30,-46},{50,-26}})));
  Modelica.Blocks.Math.Add mNet_flow(y(final unit="kg/s"))
    "Net air flow rate from A to B through the operable door"
    annotation (Placement(transformation(extent={{60,32},{80,52}})));
  Modelica.Blocks.Sources.Step yDooCom(
    height=-1,
    offset=1,
    startTime=0.5) "Outputs 1 if door is closed"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Math.Product mNetClo_flow(y(final unit="kg/s"))
    "Mass flow rate if door is closed"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
equation
  connect(bouA.ports[1], doo.port_a1) annotation (Line(points={{-60,3.2},{-40,3.2},
          {-40,56},{-20,56}}, color={0,127,255}));
  connect(bouA.ports[2], doo.port_b2) annotation (Line(points={{-60,1.6},{-38,1.6},
          {-38,44},{-20,44}}, color={0,127,255}));
  connect(bouA.ports[3], lea.port_a) annotation (Line(points={{-60,0},{-36,0},{-36,
          20},{-20,20}}, color={0,127,255}));
  connect(bouA.ports[4], dooOpeClo.port_a1) annotation (Line(points={{-60,-1.6},
          {-36,-1.6},{-36,-24},{-20,-24}}, color={0,127,255}));
  connect(bouA.ports[5], dooOpeClo.port_b2) annotation (Line(points={{-60,-3.2},
          {-40,-3.2},{-40,-36},{-20,-36}}, color={0,127,255}));
  connect(doo.port_b1, bouB.ports[1]) annotation (Line(points={{0,56},{50,56},{50,
          3.2},{70,3.2}},    color={0,127,255}));
  connect(doo.port_a2, bouB.ports[2]) annotation (Line(points={{0,44},{48,44},{48,
          1.6},{70,1.6}},    color={0,127,255}));
  connect(lea.port_b, bouB.ports[3]) annotation (Line(points={{0,20},{46,20},{46,
          0},{70,0}}, color={0,127,255}));
  connect(yDoo.y, dooOpeClo.y)
    annotation (Line(points={{-59,-30},{-21,-30}}, color={0,0,127}));
  connect(dooOpeClo.port_b1, senMasFlo1.port_a) annotation (Line(points={{0,-24},
          {6,-24},{6,-2},{10,-2}}, color={0,127,255}));
  connect(senMasFlo1.port_b, bouB.ports[4])
    annotation (Line(points={{30,-2},{70,-2},{70,-1.6}}, color={0,127,255}));
  connect(dooOpeClo.port_a2,senMasFlo2. port_a)
    annotation (Line(points={{0,-36},{30,-36}}, color={0,127,255}));
  connect(senMasFlo2.port_b, bouB.ports[5]) annotation (Line(points={{50,-36},{62,
          -36},{62,-3.2},{70,-3.2}}, color={0,127,255}));
  connect(senMasFlo1.m_flow, mNet_flow.u1)
    annotation (Line(points={{20,9},{20,48},{58,48}}, color={0,0,127}));
  connect(senMasFlo2.m_flow, mNet_flow.u2)
    annotation (Line(points={{40,-25},{40,36},{58,36}}, color={0,0,127}));
  connect(yDooCom.y, mNetClo_flow.u2) annotation (Line(points={{-59,-80},{-32,
          -80},{-32,-86},{-2,-86}}, color={0,0,127}));
  connect(mNet_flow.y, mNetClo_flow.u1) annotation (Line(points={{81,42},{94,42},
          {94,-60},{-12,-60},{-12,-74},{-2,-74}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Validation/DoorOpenClosed.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model validates the door model that takes as an input a signal
that determines whether the door is open or closed.
In this validation, the instance <code>dooOpeClo</code> is either open or closed,
depending on its input signal <code>y</code>.
If the door is open, its air flow rate is identical to the air flow rate of the
instance <code>doo</code>.
If the door is closed, its air flow rate is identical to the air flow rate of the
instance <code>lea</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2021 by Michael Wetter:<br/>
Updated comments for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/515\">IBPSA, #515</a>.
</li>
<li>
October 12, 2020 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{80,100}})));
end DoorOpenClosed;
