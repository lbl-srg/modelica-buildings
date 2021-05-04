within Buildings.Airflow.Multizone.Validation;
model OpenDoorTemperature
  "Model with one open door and only temperature-driven flow"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Medium model";

  Buildings.Airflow.Multizone.DoorOpen doo(
    redeclare package Medium = Medium)
    "Door" annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Fluid.Sources.Boundary_pT bouA(
    redeclare package Medium = Medium,
    nPorts=4) "Boundary condition at side a" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,0})));

  Fluid.Sources.Boundary_pT bouB(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=4) "Boundary condition at side b"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,0})));

  DoorDiscretizedOpen dooDis(
    redeclare package Medium = Medium,
    hA=2.1/2,
    hB=2.1/2) "Door"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Blocks.Sources.TimeTable bouTem(
    table=[
      0.0,0;
      1,0;
      1,5;
      2,5;
      2,10;
      3,10;
      3,15;
      4,15;
      4,20;
      5,20;
      5,25;
      6,25;
      6,30;
      7,30;
      7,35;
      8,35;
      8,40;
      24,40],
    timeScale=3600,
    offset=273.15) "Temperature boundary condition"
    annotation (Placement(transformation(extent={{86,-6},{66,14}})));
equation
  connect(doo.port_b1, bouB.ports[1])
    annotation (Line(points={{10,6},{20,6},{20,3},{30,3}}, color={0,127,255}));
  connect(doo.port_a2, bouB.ports[2]) annotation (Line(points={{10,-6},{20,-6},
          {20,1},{30,1}},  color={0,127,255}));
  connect(doo.port_a1, bouA.ports[1]) annotation (Line(points={{-10,6},{-20,6},
          {-20,3},{-30,3}}, color={0,127,255}));
  connect(doo.port_b2, bouA.ports[2]) annotation (Line(points={{-10,-6},{-20,-6},
          {-20,1},{-30,1}},                       color={0,127,255}));
  connect(bouA.ports[3], dooDis.port_a1) annotation (Line(points={{-30,-1},{-22,
          -1},{-22,-24},{-10,-24}}, color={0,127,255}));
  connect(bouA.ports[4], dooDis.port_b2) annotation (Line(points={{-30,-3},{-24,
          -3},{-24,-36},{-10,-36}}, color={0,127,255}));
  connect(dooDis.port_b1, bouB.ports[3]) annotation (Line(points={{10,-24},{22,
          -24},{22,-1},{30,-1}}, color={0,127,255}));
  connect(dooDis.port_a2, bouB.ports[4]) annotation (Line(points={{10,-36},{24,
          -36},{24,-3},{30,-3}}, color={0,127,255}));
  connect(bouTem.y, bouB.T_in)
    annotation (Line(points={{65,4},{52,4}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Validation/OpenDoorTemperature.mos"
        "Simulate and plot"),
    experiment(
      StopTime=28800,
      Interval=600,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model validates the door model for the situation where there is only temperature-driven air flow.
</p>
</html>", revisions="<html>
<ul>
<li>
October 9, 2020 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OpenDoorTemperature;
