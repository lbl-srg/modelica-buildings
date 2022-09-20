within Buildings.Fluid.Storage.Plant.Validation.BaseClasses;
partial model PartialPlant "Base class for validation models"

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.AbsolutePressure pBouRet=300000
    "Constant pressure at the CHW return line";
  final parameter Modelica.Units.SI.AbsolutePressure pBouSup=pBouRet+nom.dp_nominal
    "Constant pressure at the CHW supply line";

  parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom(
    mTan_flow_nominal=1,
    mChi_flow_nominal=1E-5,
    dp_nominal=300000,
    T_CHWS_nominal=280.15,
    T_CHWR_nominal=285.15) "Nominal values"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  Buildings.Fluid.Sources.Boundary_pT bouSup(
    redeclare final package Medium = Medium,
    final p=pBouSup,
    nPorts=1) "Pressure boundary representing the CHW supply line"
    annotation (Placement(transformation(extent={{100,20},{80,40}})));
  Buildings.Fluid.Sources.Boundary_pT bouRet(
    redeclare final package Medium = Medium,
    final p=pBouRet,
    nPorts=1) "Pressure boundary representing the CHW return line"
    annotation (Placement(transformation(extent={{100,-40},{80,-20}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroSup(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    final dp_nominal=nom.dp_nominal*0.4)
    "Flow resistance in the district network" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,30})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroRet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    final dp_nominal=nom.dp_nominal*0.4)
    "Flow resistance in the district network" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-30})));
  Buildings.Fluid.Storage.Plant.NetworkConnection netCon(
    redeclare final package Medium = Medium,
    final nom=nom,
    final plaTyp=nom.plaTyp,
    perPumSup(pressure(V_flow=nom.m_flow_nominal/1.2*{0,2},
                       dp=nom.dp_nominal*{2,0})))
    "Pump and valves connecting the storage plant to the district network"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = Medium)
    "Mass flow rate to the supply line"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  connect(preDroSup.port_b, bouSup.ports[1])
    annotation (Line(points={{60,30},{80,30}}, color={0,127,255}));
  connect(preDroRet.port_b, bouRet.ports[1])
    annotation (Line(points={{60,-30},{80,-30}}, color={0,127,255}));
  connect(netCon.port_bToNet, preDroSup.port_a) annotation (Line(points={{20,6},
          {34,6},{34,30},{40,30}}, color={0,127,255}));
  connect(netCon.port_aFroNet, preDroRet.port_a) annotation (Line(points={{20,-6},
          {34,-6},{34,-30},{40,-30}}, color={0,127,255}));
  connect(netCon.port_aFroChi, senMasFlo.port_b) annotation (Line(points={{0,6},{
          -10,6},{-10,30},{-40,30}},  color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This is a base class for the validation models.
</p>
</html>", revisions="<html>
<ul>
<li>
September 20, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end PartialPlant;
