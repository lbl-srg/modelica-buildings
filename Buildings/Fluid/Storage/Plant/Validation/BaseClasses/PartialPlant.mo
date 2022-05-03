within Buildings.Fluid.Storage.Plant.Validation.BaseClasses;
partial model PartialPlant "Partial model of a storage plant validation model"

  package Medium = Buildings.Media.Water "Medium model";

  Buildings.Fluid.Storage.Plant.BaseClasses.NominalValues nom(
    mTan_flow_nominal=1,
    mChi_flow_nominal=1,
    dp_nominal=300000,
    T_CHWS_nominal=280.15,
    T_CHWR_nominal=285.15) "Nominal values"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  Buildings.Fluid.Storage.Plant.Validation.BaseClasses.IdealChillerBranch
    ideChiBra(
    redeclare final package Medium = Medium,
    final nom=nom)
    "Ideal chiller branch that generates flow rate and sets fluid temperature"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Fluid.Storage.Plant.TankBranch tanBra(
    preDroTanBot(final dp_nominal=nom.dp_nominal*0.05),
    preDroTanTop(final dp_nominal=nom.dp_nominal*0.05),
    redeclare final package Medium = Medium,
    final nom=nom) "Tank branch"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Fluid.Storage.Plant.NetworkConnection netCon(
    redeclare final package Medium = Medium,
    final nom=nom)
    "Supply pump and valves that connect the plant to the district network"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare final package Medium = Medium,
    final p=300000,
    final T=nom.T_CHWR_nominal,
    nPorts=1)
    "Source representing CHW return line"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,-20})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = Medium,
    final p=300000+nom.dp_nominal,
    final T=nom.T_CHWS_nominal,
    nPorts=1) "Sink representing CHW supply line"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,20})));

equation

  connect(tanBra.port_toNet, netCon.port_froChi)
    annotation (Line(points={{-10,6},{10,6}}, color={0,127,255}));
  connect(tanBra.port_froNet, netCon.port_toChi)
    annotation (Line(points={{-10,-6},{10,-6}}, color={0,127,255}));
  connect(ideChiBra.port_b,tanBra.port_froChi)
    annotation (Line(points={{-50,6},{-30,6}}, color={0,127,255}));
  connect(ideChiBra.port_a, tanBra.port_toChi)
    annotation (Line(points={{-50,-6},{-30,-6}}, color={0,127,255}));
  connect(netCon.port_toNet, sin.ports[1]) annotation (Line(points={{30,6},{74,
          6},{74,20},{80,20}}, color={0,127,255}));
  connect(netCon.port_froNet, sou.ports[1]) annotation (Line(points={{30,-6},{
          74,-6},{74,-20},{80,-20}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This is a partial model of a storage plant used for validation.
</p>
</html>", revisions="<html>
<ul>
<li>
March 15, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end PartialPlant;
