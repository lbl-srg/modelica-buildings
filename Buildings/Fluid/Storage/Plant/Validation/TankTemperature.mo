within Buildings.Fluid.Storage.Plant.Validation;
model TankTemperature
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
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource pumSec(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_small=nom.m_flow_nominal*1E-6,
    final control_m_flow=true,
    final control_dp=false) "Ideal flow source representing the secondary pump"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.TimeTable mPumPri_flow(table=[0,0; 1200,0; 1200,nom.mChi_flow_nominal;
        2400,nom.mChi_flow_nominal; 2400,0; 3600,0])
                         "Primary pump flow rate"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.TimeTable mPumSec_flow(table=[0,0; 2400,0; 2400,nom.mTan_flow_nominal;
        3600,nom.mTan_flow_nominal]) "Secondary pump flow rate"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
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
  connect(mPumPri_flow.y, pumPri.m_flow_in)
    annotation (Line(points={{-39,70},{-36,70},{-36,18}}, color={0,0,127}));
  connect(mPumSec_flow.y, pumSec.m_flow_in)
    annotation (Line(points={{21,70},{24,70},{24,18}}, color={0,0,127}));
  connect(tanBra.heaPorTop, SOC.tanTop) annotation (Line(points={{2,-6},{22,-6},
          {22,-43.8},{40,-43.8}}, color={191,0,0}));
  connect(tanBra.heaPorBot, SOC.tanBot)
    annotation (Line(points={{2,-14},{2,-56.2},{40,-56.2}}, color={191,0,0}));
  connect(pumSec.port_b, bouSup.ports[1])
    annotation (Line(points={{40,10},{60,10}}, color={0,127,255}));
  connect(bouRet.ports[1], tanBra.port_aRetNet) annotation (Line(points={{60,
          -30},{16,-30},{16,-16},{10,-16}}, color={0,127,255}));
    annotation(experiment(Tolerance=1e-06, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/TankTemperature.mos"
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
end TankTemperature;
