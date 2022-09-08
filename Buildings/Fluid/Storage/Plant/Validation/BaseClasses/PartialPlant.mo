within Buildings.Fluid.Storage.Plant.Validation.BaseClasses;
partial model PartialPlant "Partial model of a storage plant validation model"

  package Medium = Buildings.Media.Water "Medium model";

  Buildings.Fluid.Storage.Plant.Data.NominalValues nom(
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
  Buildings.Fluid.Sources.PropertySource_T temSou(
    redeclare final package Medium = Medium,
    final use_T_in=true)
    "Ideal temperature source acting as thermal load"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,30})));
  Modelica.Blocks.Sources.Constant set_TRet(final k=nom.T_CHWR_nominal)
    "Sets temperature to nominal CHW return temperature"
                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,70})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=nom.dp_nominal,
    final m_flow_nominal=nom.m_flow_nominal) "Flow resistance of the network"
    annotation (Placement(transformation(extent={{80,-40},{60,-20}})));
equation

  connect(tanBra.port_bToNet, netCon.port_aFroChi)
    annotation (Line(points={{-10,6},{10,6}}, color={0,127,255}));
  connect(tanBra.port_aFroNet, netCon.port_bToChi)
    annotation (Line(points={{-10,-6},{10,-6}}, color={0,127,255}));
  connect(ideChiBra.port_b, tanBra.port_aFroChi)
    annotation (Line(points={{-50,6},{-30,6}}, color={0,127,255}));
  connect(ideChiBra.port_a, tanBra.port_bToChi)
    annotation (Line(points={{-50,-6},{-30,-6}}, color={0,127,255}));
  connect(set_TRet.y, temSou.T_in)
    annotation (Line(points={{61,70},{66,70},{66,42}}, color={0,0,127}));
  connect(netCon.port_bToNet, temSou.port_a) annotation (Line(points={{30,6},{
          54,6},{54,30},{60,30}}, color={0,127,255}));
  connect(netCon.port_aFroNet, preDro.port_b) annotation (Line(points={{30,-6},
          {54,-6},{54,-30},{60,-30}}, color={0,127,255}));
  connect(preDro.port_a, temSou.port_b) annotation (Line(points={{80,-30},{84,
          -30},{84,30},{80,30}}, color={0,127,255}));
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
