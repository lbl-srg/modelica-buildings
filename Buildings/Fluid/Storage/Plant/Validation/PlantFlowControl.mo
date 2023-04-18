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
    dIns=0.3)
    "Tank branch, tank can be charged remotely" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-10})));
  parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom(
    mTan_flow_nominal=1,
    mChi_flow_nominal=1,
    dp_nominal = 300000,
    T_CHWS_nominal=280.15,
    T_CHWR_nominal=285.15) "Nominal values of the storage plant"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Fluid.Storage.Plant.Controls.TankStatus tanSta(
    TLow=nom.T_CHWS_nominal,
    THig=nom.T_CHWR_nominal) "Tank status"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Fluid.Sources.Boundary_pT bouSup(
    p(final displayUnit="Pa") = 101325 + nom.dp_nominal,
    redeclare final package Medium = Medium,
    T=nom.T_CHWS_nominal,
    nPorts=1) "Pressure boundary representing district CHW supply line"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,10})));
  Buildings.Fluid.Sources.Boundary_pT bouRet(
    p(final displayUnit="Pa") = 101325,
    redeclare final package Medium = Medium,
    T=nom.T_CHWR_nominal,
    nPorts=1) "Pressure boundary representing district CHW return line"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,-30})));
  Buildings.Fluid.Storage.Plant.Controls.FlowControl floCon(
    mChi_flow_nominal=nom.mChi_flow_nominal,
    mTan_flow_nominal=nom.mTan_flow_nominal)
    "Block for primary and secondary pump and valve flow control"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.IntegerTable tanCom(table=[0,2; 100,1; 600,2; 1800,3;
        2300,2; 2500,1])
    "Command for tank: 1 = charge, 2 = hold, 3 = discharge"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Modelica.Blocks.Sources.BooleanTable chiOnl(table={0,2300},
    startValue=false)
    "Chiller is online"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Modelica.Blocks.Sources.BooleanTable hasLoa(table={600,2200},
    startValue=false) "The system has load"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  Buildings.Fluid.Storage.Plant.ReversibleConnection revCon(
    redeclare final package Medium = Medium,
     final nom=nom)
                   "Reversible connection"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Fluid.BaseClasses.ActuatorFilter fil(
    u_nominal=nom.m_flow_nominal,
    final n=2,
    final f=5/(2*Modelica.Constants.pi*60),
    final normalized=true,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final y_start=0)       "Second order filter to improve numerics"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Sources.TimeTable y(table=[0,0.96; 1600,0.96; 1500,1; 3000,1])
    "Speed of the secondary pump"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
equation
  connect(chi.port_b, pumPri.port_a)
    annotation (Line(points={{-60,10},{-40,10}}, color={0,127,255}));
  connect(pumPri.port_b, tanBra.port_aSupChi) annotation (Line(points={{-20,10},
          {-16,10},{-16,-4},{-10,-4}},
                                   color={0,127,255}));
  connect(tanBra.port_bRetChi, chi.port_a) annotation (Line(points={{-10,-16},{-88,
          -16},{-88,10},{-80,10}}, color={0,127,255}));
  connect(bouRet.ports[1], tanBra.port_aRetNet) annotation (Line(points={{80,-30},
          {20,-30},{20,-16},{10,-16}},      color={0,127,255}));
  connect(tanCom.y, floCon.tanCom) annotation (Line(points={{-119,50},{-100,50},
          {-100,56},{-81,56}},
                             color={255,127,0}));
  connect(chiOnl.y, floCon.chiIsOnl) annotation (Line(points={{-119,10},{-104,10},
          {-104,44},{-81,44}},color={255,0,255}));
  connect(hasLoa.y, floCon.hasLoa) annotation (Line(points={{-119,-30},{-100,-30},
          {-100,40},{-81,40}},
                             color={255,0,255}));
  connect(tanBra.port_bSupNet, revCon.port_a) annotation (Line(points={{10,-4},{
          20,-4},{20,10},{40,10}}, color={0,127,255}));
  connect(revCon.port_b, bouSup.ports[1])
    annotation (Line(points={{60,10},{80,10}}, color={0,127,255}));
  connect(floCon.ySecPum, revCon.yPum) annotation (Line(points={{-59,50},{34,50},
          {34,16},{39,16}}, color={0,0,127}));
  connect(floCon.yVal, revCon.yVal) annotation (Line(points={{-59,44},{24,44},{24,
          4},{39,4}}, color={0,0,127}));
  connect(floCon.mPriPum_flow, fil.u) annotation (Line(points={{-59,56},{-52,56},
          {-52,90},{-42,90}}, color={0,0,127}));
  connect(fil.y, pumPri.m_flow_in) annotation (Line(points={{-19,90},{-16,90},{-16,
          28},{-36,28},{-36,18}}, color={0,0,127}));
  connect(tanBra.TTan, tanSta.TTan) annotation (Line(points={{11,-20},{16,-20},
          {16,-50},{39,-50}}, color={0,0,127}));
  connect(tanSta.y, floCon.tanSta) annotation (Line(points={{61,-50},{64,-50},{
          64,-66},{-94,-66},{-94,50},{-81,50}}, color={255,0,255}));
  connect(y.y, floCon.yPum) annotation (Line(points={{-119,90},{-100,90},{-100,60},
          {-81,60}}, color={0,0,127}));
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
At <code>time = 100</code>, the system receives the command to charge the
tank. The chiller is online and charges the tank locally.
After some time, the charging stops when the tank reaches the \"cooled\"
status. Note that at this point the tank is not yet full.
</li>
<li>
At <code>time = 600</code>, load appears in the district network and
the storage plant starts producing CHW to the system.
<ul>
<li>
At first, the chiller takes priority in CHW production
as the plant is commanded to hold the tank.
Becasue the chiller and the constant-speed primary pump produces more CHW
than needed by the district, the overflow continues to charge the tank.
</li>
<li>
After some time, the tank is charged to the \"overcooled\" status.
It then overrides the chiller's production priority
until it is no longer overcooled, at which point the tank returns the
production priority to the chiller.
</li>
<li>
The chiller and the tank exchanges the production priority until the system
reaches another state.
</li>
</ul>
</li>
<li>
At <code>time = 1500</code>, the load in the district system increases.
The storage plant primarily uses CHW produced by the chiller, but also uses
the CHW from the tank to make up to the flow needed.
</li>
<li>
At <code>time = 1800</code>, the system is commanded to produce CHW from the
tank. It hence takes priority over the chiller.
After some time, the CHW in the tank is depleted.
The chiller is then turned on and takes over.
</li>
<li>
At <code>time = 2200</code>, there is no longer load in the district system.
The system is back to the all-off state.
</li>
<li>
At <code>time = 2500</code>, the system receives the command to charge
the tank. But the chiller is offline at this time.
The tank is therefore charged remotely by the district.
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
    Diagram(coordinateSystem(extent={{-160,-100},{120,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end PlantFlowControl;
