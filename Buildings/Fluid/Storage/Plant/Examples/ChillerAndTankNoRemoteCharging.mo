within Buildings.Fluid.Storage.Plant.Examples;
model ChillerAndTankNoRemoteCharging "(Draft)"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  Buildings.Fluid.Storage.Plant.ChillerAndTankNoRemoteCharging cat(
    dp_nominal=sin.p-sou.p,
    vol1(p_start=sin.p,
         T_start=sin.T),
    vol2(p_start=sin.p,
         T_start=sin.T),
    TChiEnt(T_start=sou.T),
    TChiLea(T_start=sin.T))
    "Plant with chiller and tank"
    annotation (Placement(transformation(extent={{-16,-10},{16,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    p=300000,
    T=285.15,
    nPorts=1)
    "Source, CHW return line"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,0})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p=800000,
    T=280.15,
    nPorts=1)
    "Sink, CHW supply line"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={60,0})));
equation
  connect(sou.ports[1], cat.port_a)
    annotation (Line(points={{-50,0},{-16,0}}, color={0,127,255}));
  connect(cat.port_b, sin.ports[1]) annotation (Line(points={{16,0},{33,0},{33,4.44089e-16},
          {50,4.44089e-16}}, color={0,127,255}));

  annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,120}})));
end ChillerAndTankNoRemoteCharging;
