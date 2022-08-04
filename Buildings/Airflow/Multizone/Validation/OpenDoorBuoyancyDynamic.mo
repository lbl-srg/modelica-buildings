within Buildings.Airflow.Multizone.Validation;
model OpenDoorBuoyancyDynamic
  "Model with open door and buoyancy driven flow only"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Medium model";

  Buildings.Airflow.Multizone.DoorOpen doo(
    redeclare package Medium = Medium)
    "Door" annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1) "Pressure boundary"
    annotation (Placement(transformation(extent={{-50,18},{-30,38}})));

  Fluid.MixingVolumes.MixingVolume bouA(
    redeclare package Medium = Medium,
    T_start=292.15,
    V=2.5*5*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.01,
    nPorts=3) "Boundary condition at side a" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,0})));

  Buildings.Fluid.MixingVolumes.MixingVolume bouB(
    redeclare package Medium = Medium,
    T_start=294.15,
    V=2.5*5*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.01,
    nPorts=2) "Boundary condition at side b"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,0})));
  DoorDiscretizedOpen dooDis(
    forceErrorControlOnFlow=false,
    redeclare package Medium = Medium,
    vZer=0.000001) "Door"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    nPorts=1) "Pressure boundary"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Fluid.MixingVolumes.MixingVolume bouADis(
    redeclare package Medium = Medium,
    T_start=292.15,
    V=2.5*5*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.01,
    nPorts=3) "Boundary condition at side a" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-70})));
  Fluid.MixingVolumes.MixingVolume bouBDis(
    redeclare package Medium = Medium,
    T_start=294.15,
    V=2.5*5*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.01,
    nPorts=2) "Boundary condition at side b" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,-70})));
equation
  connect(doo.port_b1, bouB.ports[1])
    annotation (Line(points={{10,6},{20,6},{20,2},{30,2}}, color={0,127,255}));
  connect(doo.port_a2, bouB.ports[2]) annotation (Line(points={{10,-6},{20,-6},
          {20,-2},{30,-2}},color={0,127,255}));
  connect(doo.port_a1, bouA.ports[1]) annotation (Line(points={{-10,6},{-20,6},
          {-20,2.66667},{-30,2.66667}},
                            color={0,127,255}));
  connect(doo.port_b2, bouA.ports[2]) annotation (Line(points={{-10,-6},{-18,-6},
          {-18,-8.88178e-16},{-30,-8.88178e-16}}, color={0,127,255}));
  connect(bou.ports[1], bouA.ports[3])
    annotation (Line(points={{-30,28},{-30,-2.66667}}, color={0,127,255}));
  connect(bou1.ports[1], bouADis.ports[1])
    annotation (Line(points={{-30,-40},{-30,-67.3333}}, color={0,127,255}));
  connect(dooDis.port_a1, bouADis.ports[2]) annotation (Line(points={{-10,-64},
          {-20,-64},{-20,-70},{-30,-70}}, color={0,127,255}));
  connect(dooDis.port_b2, bouADis.ports[3]) annotation (Line(points={{-10,-76},
          {-20,-76},{-20,-72.6667},{-30,-72.6667}}, color={0,127,255}));
  connect(dooDis.port_b1, bouBDis.ports[1]) annotation (Line(points={{10,-64},{
          20,-64},{20,-68},{30,-68}}, color={0,127,255}));
  connect(dooDis.port_a2, bouBDis.ports[2]) annotation (Line(points={{10,-76},{
          22,-76},{22,-72},{30,-72}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Validation/OpenDoorBuoyancyDynamic.mos"
        "Simulate and plot"),
    experiment(
      StopTime=14400,
      Tolerance=1e-08),
    Documentation(info="<html>
<p>
This model validates the door model for the situation where there is only buoyancy-driven air flow.
Initially the volume is at a different temperature than the pressure source, leading to an airflow that eventually decays to zero.
</p>
</html>", revisions="<html>
<ul>
<li>
October 9, 2020 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OpenDoorBuoyancyDynamic;
