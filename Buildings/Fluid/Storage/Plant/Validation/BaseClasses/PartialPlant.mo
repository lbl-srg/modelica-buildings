within Buildings.Fluid.Storage.Plant.Validation.BaseClasses;
partial model PartialPlant "(Draft)"

  package Medium = Buildings.Media.Water "Medium model";

  Buildings.Fluid.Storage.Plant.BaseClasses.NominalValues nom(
    mTan_flow_nominal=1,
    mChi_flow_nominal=1,
    dp_nominal=500000,
    T_CHWS_nominal=280.15,
    T_CHWR_nominal=285.15) "Nominal values"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  Buildings.Fluid.Storage.Plant.TankBranch tanBra(
    redeclare final package Medium = Medium,
    final nom=nom,
    final preDroTan(final dp_nominal=nom.dp_nominal*0.1)) "Tank branch"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare final package Medium = Medium,
    final nPorts=1,
    final p=300000,
    final T=nom.T_CHWR_nominal)
    "Source representing CHW return line"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,-20})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = Medium,
    final nPorts=1,
    final p=300000+nom.dp_nominal,
    final T=nom.T_CHWS_nominal)
              "Sink representing CHW supply line"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,20})));
  Buildings.Fluid.Sources.MassFlowSource_T souChi(
    redeclare package Medium = Medium,
    final T=nom.T_CHWS_nominal,
    nPorts=1) "Source representing chiller branch outlet"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,20})));
  Buildings.Fluid.Sources.MassFlowSource_T sinChi(
    redeclare package Medium = Medium,
    final use_m_flow_in=true,
    final T=nom.T_CHWR_nominal,
    nPorts=1) "Sink representing chiller branch inlet" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-20})));
  Modelica.Blocks.Sources.RealExpression mSinChi_flow(
    final y=souChi.ports[1].m_flow)
    "Mass flow rate"
    annotation (Placement(transformation(extent={{-90,-22},{-70,-2}})));

equation

  connect(mSinChi_flow.y, sinChi.m_flow_in)
    annotation (Line(points={{-69,-12},{-62,-12}},        color={0,0,127}));
  connect(souChi.ports[1], tanBra.port_chiOut) annotation (Line(points={{-40,20},
          {-36,20},{-36,6},{-30,6}}, color={0,127,255}));
  connect(tanBra.port_chiInl, sinChi.ports[1]) annotation (Line(points={{-30,-6},
          {-36,-6},{-36,-20},{-40,-20}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
Documentation pending.
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
