within Buildings.Fluid.Storage.Plant.Validation;
model PlantFlowControl
  "This simple model validates the charging and discharging of the tank"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model for CHW";

  Buildings.Fluid.Storage.Plant.BaseClasses.IdealTemperatureSource chi(
    redeclare package Medium = Medium,
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
  Buildings.Fluid.Storage.Plant.BaseClasses.StateOfCharge SOC(TLow=nom.T_CHWS_nominal,
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
  Buildings.Fluid.Storage.Plant.Controls.FlowControl flowControl(
    mChi_flow_nominal=nom.mChi_flow_nominal,
    mTan_flow_nominal=nom.mTan_flow_nominal)
    "Block for primary and secondary pump and valve flow control"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.IntegerTable tanCom(table=[0,2; 200,1; 1000,2; 1200,3;
        2000,2; 2200,1])
    "Command for tank: 1 = charge, 2 = hold, 3 = discharge"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Modelica.Blocks.Sources.BooleanTable chiOnl(table={0,2000}, startValue=false)
    "Chiller is online"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Modelica.Blocks.Sources.BooleanTable hasLoa(table={1000,2000}, startValue=
        false) "The system has load"
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
          {22,-43.8},{40,-43.8}}, color={191,0,0}));
  connect(tanBra.heaPorBot, SOC.tanBot)
    annotation (Line(points={{2,-14},{2,-56.2},{40,-56.2}}, color={191,0,0}));
  connect(pumSec.port_b, bouSup.ports[1])
    annotation (Line(points={{40,10},{60,10}}, color={0,127,255}));
  connect(bouRet.ports[1], tanBra.port_aRetNet) annotation (Line(points={{60,
          -30},{16,-30},{16,-16},{10,-16}}, color={0,127,255}));
  connect(flowControl.mPriPum_flow, pumPri.m_flow_in)
    annotation (Line(points={{-59,54},{-36,54},{-36,18}}, color={0,0,127}));
  connect(flowControl.mSecPum_flow, pumSec.m_flow_in)
    annotation (Line(points={{-59,46},{24,46},{24,18}}, color={0,0,127}));
  connect(SOC.isFul, flowControl.tanIsFul) annotation (Line(points={{61,-44},{68,
          -44},{68,-68},{-94,-68},{-94,54},{-81,54}}, color={255,0,255}));
  connect(SOC.isDep, flowControl.tanIsDep) annotation (Line(points={{61,-56},{64,
          -56},{64,-64},{-90,-64},{-90,50},{-81,50}}, color={255,0,255}));
  connect(tanCom.y, flowControl.tanCom) annotation (Line(points={{-119,90},{-86,
          90},{-86,58},{-81,58}}, color={255,127,0}));
  connect(chiOnl.y, flowControl.chiIsOnl) annotation (Line(points={{-119,50},{
          -98,50},{-98,46},{-81,46}}, color={255,0,255}));
  connect(hasLoa.y, flowControl.hasLoa) annotation (Line(points={{-119,10},{-98,
          10},{-98,42},{-81,42}}, color={255,0,255}));
    annotation(experiment(Tolerance=1e-06, StopTime=3000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/PlantFlowControl.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates the charging and discharging of the tank.
At the start of the simulation, the tank is fully depleted,
meaning the whole tank is at nominal CHW return temperature.
Then, it is then charged to full,
where the whole tank is at nominal CHW supply temperature.
Finally, it is discharged and depleted by the user,
where the whole tank is at nominal CHW return temperature again.
</p>
</html>", revisions="<html>
<ul>
<li>
January 13, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end PlantFlowControl;
