within Buildings.Fluid.Sensors.Examples;
model TemperatureDryBulb "Test model for the dry bulb temperature sensor"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Air "Medium model";
  Buildings.Fluid.Sources.Boundary_pT amb(
    redeclare package Medium = Medium,
    T=298.15,
    nPorts=1)
    "Ambient conditions, used to test the relative temperature sensor"
     annotation (Placement(
        transformation(extent={{10,-10},{-10,10}},
                                                 rotation=180,
        origin={-2,-60})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloRat(
    redeclare package Medium = Medium,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1) "Flow boundary condition"  annotation (Placement(transformation(
          extent={{-30,-22},{-10,-2}})));
  Modelica.Blocks.Sources.Ramp TDryBul(
    height=10,
    duration=1,
    offset=273.15 + 30) "Dry bulb temperature"
                 annotation (Placement(transformation(extent={{-100,-18},{-80,2}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSteSta(
   redeclare package Medium = Medium,
   m_flow_nominal=2,
   tau=0) "Steady state temperature sensor"
    annotation (Placement(transformation(extent={{0,-22},{20,-2}})));

    Modelica.Blocks.Sources.Pulse m_flow1(
    period=30,
    offset=0,
    amplitude=-1) "Mass flow rate"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temDyn(
    redeclare package Medium = Medium,
    m_flow_nominal=2,
    initType=Modelica.Blocks.Types.Init.InitialState,
    T_start=293.15) "Dynamic temperature sensor"
    annotation (Placement(transformation(extent={{30,-22},{50,-2}})));
  RelativeTemperature senRelTem(redeclare package Medium = Medium)
    "Temperature difference sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={40,-60})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=293.15,
    nPorts=2) "Flow boundary condition"
     annotation (Placement(
        transformation(extent={{110,-24},{90,-4}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temDynLoss(
    redeclare package Medium = Medium,
    m_flow_nominal=2,
    initType=Modelica.Blocks.Types.Init.InitialState,
    transferHeat=true,
    T_start=293.15,
    TAmb=293.15,
    tauHeaTra=30) "Dynamic temperature sensor with heat transfer"
    annotation (Placement(transformation(extent={{56,-22},{76,-2}})));
  Modelica.Blocks.Math.Add add_m_flow
    "Add two pulse functions for mass flow rate"
    annotation (Placement(transformation(extent={{-68,40},{-48,60}})));
    Modelica.Blocks.Sources.Pulse m_flow2(
    amplitude=1,
    offset=0,
    period=45) "Mass flow rate"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
equation
  connect(TDryBul.y, masFloRat.T_in)    annotation (Line(points={{-79,-8},{-60,-8},
          {-32,-8}},          color={0,0,127}));
  connect(masFloRat.ports[1], temSteSta.port_a) annotation (Line(
      points={{-10,-12},{0,-12}},
      color={0,127,255}));
  connect(temSteSta.port_b, temDyn.port_a) annotation (Line(
      points={{20,-12},{30,-12}},
      color={0,127,255}));
  connect(amb.ports[1], senRelTem.port_a) annotation (Line(
      points={{8,-60},{30,-60}},
      color={0,127,255}));
  connect(temDyn.port_b, temDynLoss.port_a)
    annotation (Line(points={{50,-12},{56,-12}},
                                             color={0,127,255}));
  connect(masFloRat.m_flow_in, add_m_flow.y) annotation (Line(points={{-32,-4},
          {-32,-4},{-40,-4},{-40,50},{-47,50}}, color={0,0,127}));
  connect(add_m_flow.u1, m_flow1.y)
    annotation (Line(points={{-70,56},{-70,56},{-74,56},{-74,70},{-79,70}},
                                                          color={0,0,127}));
  connect(m_flow2.y, add_m_flow.u2) annotation (Line(points={{-79,40},{-76,40},{
          -76,44},{-70,44}},  color={0,0,127}));
  connect(sin.ports[1], temDynLoss.port_b)
    annotation (Line(points={{90,-15},{84,-12},{76,-12}}, color={0,127,255}));
  connect(sin.ports[2], senRelTem.port_b) annotation (Line(points={{90,-13},{80,
          -13},{80,-60},{50,-60}}, color={0,127,255}));
    annotation (experiment(Tolerance=1e-6, StopTime=60),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sensors/Examples/TemperatureDryBulb.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests the dry bulb temperature sensors.
One sensor is configured to be a steady-state model,
a second sensor is configured to be a dynamic sensor and
the third sensors is a dynamic sensor with heat transfer.
There is also a sensor that measures the temperature difference.
</p>
</html>", revisions="<html>
<ul>
<li>
June 19, 2015 by Filip Jorissen:<br/>
Extended example with demonstration of thermal losses.
</li>
<li>
September 10, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,
            100}})));
end TemperatureDryBulb;
