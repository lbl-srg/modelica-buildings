within Buildings.Fluid.Storage.Plant.Validation;
model PlantFlowControl
  "Validation model for flow control of the storage plant"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model for CHW";

  Buildings.Fluid.Storage.Plant.BaseClasses.IdealTemperatureSource chi(
    redeclare final package Medium = Medium,
    m_flow_nominal=nom.mChi_flow_nominal,
    TSet=nom.T_CHWS_nominal)
    "Ideal temperature source representing the chiller"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource pumPri(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_small=nom.mChi_flow_nominal*1E-6,
    final control_m_flow=true,
    final control_dp=false) "Ideal flow source representing the primary pump"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Fluid.Storage.Plant.TankBranch tanBra(
    redeclare final package Medium = Medium,
    final nom=nom,
    VTan=0.2,
    hTan=1,
    dIns=0.3,
    nSeg=3)
    "Tank branch, tank can be charged remotely" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-10})));
  final parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom(
    mTan_flow_nominal=1,
    mChi_flow_nominal=1,
    dp_nominal = 300000,
    T_CHWS_nominal=280.15,
    T_CHWR_nominal=285.15) "Nominal values of the storage plant"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource pumSec(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_small=nom.m_flow_nominal*1E-6,
    final control_m_flow=true,
    final control_dp=false) "Ideal flow source representing the secondary pump"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.StateOfCharge SOC(
    TLow=nom.T_CHWS_nominal,
    THig=nom.T_CHWR_nominal)
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Fluid.Sources.Boundary_pT bouSup(
    p(final displayUnit="Pa") = 101325 + nom.dp_nominal,
    redeclare final package Medium = Medium,
    T=nom.T_CHWS_nominal,
    nPorts=1) "Pressure boundary representing district CHW supply line"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,10})));
  Buildings.Fluid.Sources.Boundary_pT bouRet(
    p(final displayUnit="Pa") = 101325,
    redeclare final package Medium = Medium,
    T=nom.T_CHWR_nominal,
    nPorts=1) "Pressure boundary representing district CHW return line"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,-30})));
  Buildings.Fluid.Storage.Plant.Controls.FlowControl floCon(
    mChi_flow_nominal=nom.mChi_flow_nominal,
    mTan_flow_nominal=nom.mTan_flow_nominal)
    "Block for primary and secondary pump and valve flow control"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.IntegerTable tanCom(
    table=[0,2; 200,1; 1000,2; 1200,3; 2000,2; 2200,1])
    "Command for tank: 1 = charge, 2 = hold, 3 = discharge"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Modelica.Blocks.Sources.BooleanTable chiOnl(
    table={0,2000},
    startValue=false)
    "Chiller is online"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Modelica.Blocks.Sources.BooleanTable hasLoa(
    table={1000,2000},
    startValue=false) "The system has load"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
equation
  connect(chi.port_b, pumPri.port_a)
    annotation (Line(points={{-60,10},{-40,10}}, color={0,127,255}));
  connect(pumPri.port_b, tanBra.port_aSupChi) annotation (Line(points={{-20,10},
          {-16,10},{-16,-4},{-10,-4}},
                                   color={0,127,255}));
  connect(tanBra.port_bRetChi, chi.port_a) annotation (Line(points={{-10,-16},{-86,
          -16},{-86,10},{-80,10}}, color={0,127,255}));
  connect(tanBra.port_bSupNet, pumSec.port_a) annotation (Line(points={{10,-4},{
          16,-4},{16,10},{20,10}}, color={0,127,255}));
  connect(tanBra.heaPorTop, SOC.tanTop) annotation (Line(points={{2,-6},{22,-6},
          {22,-44},{40,-44}},     color={191,0,0}));
  connect(tanBra.heaPorBot, SOC.tanBot)
    annotation (Line(points={{2,-14},{2,-55.8},{40,-55.8}}, color={191,0,0}));
  connect(pumSec.port_b, bouSup.ports[1])
    annotation (Line(points={{40,10},{60,10}}, color={0,127,255}));
  connect(bouRet.ports[1], tanBra.port_aRetNet) annotation (Line(points={{60,
          -30},{16,-30},{16,-16},{10,-16}}, color={0,127,255}));
  connect(floCon.mPriPum_flow, pumPri.m_flow_in)
    annotation (Line(points={{-59,54},{-36,54},{-36,18}}, color={0,0,127}));
  connect(floCon.mSecPum_flow, pumSec.m_flow_in)
    annotation (Line(points={{-59,46},{24,46},{24,18}}, color={0,0,127}));
  connect(SOC.isFul, floCon.tanIsFul) annotation (Line(points={{61,-44},{68,-44},
          {68,-68},{-94,-68},{-94,54},{-81,54}}, color={255,0,255}));
  connect(SOC.isDep, floCon.tanIsDep) annotation (Line(points={{61,-56},{64,-56},
          {64,-64},{-90,-64},{-90,50},{-81,50}}, color={255,0,255}));
  connect(tanCom.y, floCon.tanCom) annotation (Line(points={{-119,90},{-86,90},{
          -86,58},{-81,58}}, color={255,127,0}));
  connect(chiOnl.y, floCon.chiIsOnl) annotation (Line(points={{-119,50},{-98,50},
          {-98,46},{-81,46}}, color={255,0,255}));
  connect(hasLoa.y, floCon.hasLoa) annotation (Line(points={{-119,10},{-98,10},{
          -98,42},{-81,42}}, color={255,0,255}));
    annotation(experiment(Tolerance=1e-06, StopTime=3000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/PlantFlowControl.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates the flow control of the storage plant.
The time table blocks implement the following schedule for the system:
</p>
<ul>
<li>
At <code>time = 0</code>, the system is all off.
</li>
<li>
At <code>time = 200</code>, the tank is commanded to charge. The chiller is
available and charges the tank locally.
After some time, the charging stops when the tank becomes full.
</li>
<li>
At <code>time = 1000</code>, the district system has load and the storage
plant starts to output CHW to the system. Currently the tank is commanded
to hold. Therefore, the CHW is supplied by the chiller.
</li>
<li>
At <code>time = 1200</code>, the tank is commanded to output.
It takes priority over the chiller.
After some time, the outputting stops when the tank is depleted.
Now the CHW is produced by the chiller instead.
</li>
<li>
At <code>time = 2000</code>, there is no longer load in the district system.
The system is back to the all-off state.
</li>
<li>
At <code>time = 2200</code>, the tank is once again commanded to charge.
But the chiller is offline at this time. The tank is therefore charged
remotely by the district.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
February 21, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-160,-100},{100,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end PlantFlowControl;
