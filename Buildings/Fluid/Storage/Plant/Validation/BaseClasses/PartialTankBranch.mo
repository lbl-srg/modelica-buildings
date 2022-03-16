within Buildings.Fluid.Storage.Plant.Validation.BaseClasses;
partial model PartialTankBranch "(Draft)"

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.AbsolutePressure p_CHWS_nominal=800000
    "Nominal pressure of the CHW supply line";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWR_nominal=300000
    "Nominal pressure of the CHW return line";
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal=7+273.15
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal=12+273.15
    "Nominal temperature of CHW return";

  Buildings.Fluid.Storage.Plant.TankBranch tanBra(
    cheVal(final dpValve_nominal=tanBra.dp_nominal*0.1, final dpFixed_nominal=
          tanBra.dp_nominal*0.1),
    redeclare final package Medium = Medium,
    final m_flow_nominal=2,
    final mTan_flow_nominal=1,
    final dp_nominal=p_CHWS_nominal - p_CHWR_nominal,
    final T_CHWS_nominal=T_CHWS_nominal,
    final T_CHWR_nominal=T_CHWR_nominal,
    final preDroTan(final dp_nominal=tanBra.dp_nominal*0.1),
    final valCha(final dpValve_nominal=tanBra.dp_nominal*0.1),
    final valDis(final dpValve_nominal=tanBra.dp_nominal*0.1)) "Tank branch"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare final package Medium = Medium,
    final p=p_CHWR_nominal,
    final T=T_CHWR_nominal,
    nPorts=1)
    "Source representing CHW return line"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,-30})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = Medium,
    final p=p_CHWS_nominal,
    final T=T_CHWS_nominal,
    nPorts=1) "Sink representing CHW supply line"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={20,-30})));
  Buildings.Fluid.Sources.MassFlowSource_T souChi(
    redeclare package Medium = Medium,
    final T=T_CHWS_nominal,
    nPorts=1) "Source representing chiller branch outlet"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,30})));
  Buildings.Fluid.Sources.MassFlowSource_T sinChi(
    redeclare package Medium = Medium,
    final use_m_flow_in=true,
    final T=T_CHWR_nominal,
    nPorts=1) "Sink representing chiller branch inlet" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,30})));
  Modelica.Blocks.Sources.RealExpression mSinChi_flow(
    final y=souChi.ports[1].m_flow)
    "Mass flow rate"
    annotation (Placement(transformation(extent={{-40,38},{-20,58}})));
equation

  connect(sou.ports[1], tanBra.port_1)
    annotation (Line(points={{-20,-20},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(sin.ports[1], tanBra.port_2)
    annotation (Line(points={{20,-20},{20,-6},{10,-6}}, color={0,127,255}));
  connect(tanBra.port_4, souChi.ports[1]) annotation (Line(points={{4,10.2},{4,
          16},{20,16},{20,20}}, color={0,127,255}));
  connect(sinChi.ports[1], tanBra.port_3) annotation (Line(points={{-20,20},{-20,
          16},{-4,16},{-4,10}}, color={0,127,255}));
  connect(mSinChi_flow.y, sinChi.m_flow_in)
    annotation (Line(points={{-19,48},{-12,48},{-12,42}}, color={0,0,127}));
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
end PartialTankBranch;
