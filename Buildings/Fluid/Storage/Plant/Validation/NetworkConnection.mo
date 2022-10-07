within Buildings.Fluid.Storage.Plant.Validation;
model NetworkConnection
  "Validation model for the pump, valves, and their control"

  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  final parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom(
    allowRemoteCharging=true,
    mTan_flow_nominal=1,
    mChi_flow_nominal=1,
    dp_nominal=300000,
    T_CHWS_nominal=280.15,
    T_CHWR_nominal=285.15) "Nominal values"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));

  Buildings.Fluid.Storage.Plant.Controls.RemoteCharging conRemCha
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.TimeTable mTanSet_flow(table=[0,0; 600,0; 600,1; 1200,
        1; 1200,0; 1800,0; 1800,-1; 3600,-1]) "Mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.BooleanTable uAva(final table={600,2400,3000},
    final startValue=false) "Plant availability"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Fluid.Storage.Plant.NetworkConnection netCon(
    redeclare final package Medium = Medium,
    final nom=nom,
    final allowRemoteCharging=nom.allowRemoteCharging,
    final per(pressure(V_flow=nom.m_flow_nominal/1.2*{0,2},
                 dp=nom.dp_nominal*{2,0})))
    "Pump and valves connecting the storage plant to the district network"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sensors.MassFlowRate mTan_flow(
    redeclare final package Medium = Medium) "Mass flow rate at the tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-18})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource idePreSou(
    redeclare final package Medium = Medium,
    final m_flow_small=1E-5,
    final control_m_flow=false,
    final control_dp=true)
    "Ideal pressure source representing a remote chiller plant" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,0})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroNet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    final dp_nominal=nom.dp_nominal*0.9)
    "Flow resistance in the district network" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,0})));
  Modelica.Blocks.Sources.Constant dp(final k=-nom.dp_nominal*0.3)
    "Constant differential pressure"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Fluid.FixedResistances.Junction junSup2(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,-nom.m_flow_nominal},

    final dp_nominal={0,0,0}) "Junction on the supply side"
    annotation (Placement(transformation(extent={{50,20},{70,40}})));
  Buildings.Fluid.FixedResistances.Junction junRet2(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,nom.m_flow_nominal},

    final dp_nominal={0,0,0}) "Junction on the return side" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,-30})));

  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa") = 101325,
    nPorts=1) "Pressure boundary"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,-80})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource ideFloSou(
    redeclare final package Medium = Medium,
    final m_flow_small=1E-5,
    final control_m_flow=true,
    final control_dp=false) "Ideal flow source representing the primary pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-10})));
  Buildings.Fluid.FixedResistances.Junction junSup1(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final T_start=nom.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,-nom.m_flow_nominal},
    final dp_nominal={0,0,0}) "Junction on the supply side"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Fluid.FixedResistances.Junction junRet1(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,nom.m_flow_nominal},
    final dp_nominal={0,0,0}) "Junction on the return side" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-50})));

  Modelica.Blocks.Sources.TimeTable mChiSet_flow(table=[0,0; 600,0; 600,1; 1800,
        1; 1800,2; 2400,2; 2400,1; 3000,1; 3000,0; 3600,0])
    "Mass flow rate setpoint for the primary pump"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Modelica.Blocks.Sources.BooleanTable uRemCha(final table={3000}, final
      startValue=false) "Remote charging status"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
equation
  connect(conRemCha.yPum, netCon.yPum)
    annotation (Line(points={{1,24},{8,24},{8,11}}, color={0,0,127}));
  connect(conRemCha.yVal, netCon.yVal)
    annotation (Line(points={{1,28},{12,28},{12,11}}, color={0,0,127}));
  connect(mTanSet_flow.y, conRemCha.mTanSet_flow) annotation (Line(points={{-79,30},
          {-74,30},{-74,28},{-21,28}},     color={0,0,127}));
  connect(conRemCha.uAva, uAva.y) annotation (Line(points={{-22,36},{-28,36},{-28,
          70},{-39,70}},color={255,0,255}));
  connect(mTan_flow.m_flow, conRemCha.mTan_flow)
    annotation (Line(points={{-41,-18},{-48,-18},{-48,24},{-21,24}},
                                                          color={0,0,127}));
  connect(dp.y, idePreSou.dp_in) annotation (Line(points={{41,-70},{46,-70},{46,
          6},{52,6}}, color={0,0,127}));
  connect(junSup2.port_2, preDroNet.port_a)
    annotation (Line(points={{70,30},{90,30},{90,10}}, color={0,127,255}));
  connect(preDroNet.port_b, junRet2.port_1)
    annotation (Line(points={{90,-10},{90,-30},{70,-30}}, color={0,127,255}));
  connect(junRet2.port_3, idePreSou.port_a)
    annotation (Line(points={{60,-20},{60,-10}}, color={0,127,255}));
  connect(idePreSou.port_b, junSup2.port_3)
    annotation (Line(points={{60,10},{60,20}}, color={0,127,255}));
  connect(netCon.port_bToNet, junSup2.port_1) annotation (Line(points={{20,6},{
          26,6},{26,30},{50,30}}, color={0,127,255}));
  connect(junRet2.port_2, netCon.port_aFroNet) annotation (Line(points={{50,-30},
          {26,-30},{26,-6},{20,-6}}, color={0,127,255}));
  connect(junSup1.port_2, netCon.port_aFroChi) annotation (Line(points={{-20,10},
          {-6,10},{-6,6},{0,6}}, color={0,127,255}));
  connect(junRet1.port_1, netCon.port_bToChi) annotation (Line(points={{-20,-50},
          {-6,-50},{-6,-6},{0,-6}}, color={0,127,255}));
  connect(junRet1.port_3, mTan_flow.port_a)
    annotation (Line(points={{-30,-40},{-30,-28}}, color={0,127,255}));
  connect(mTan_flow.port_b, junSup1.port_3)
    annotation (Line(points={{-30,-8},{-30,0}}, color={0,127,255}));
  connect(junSup1.port_1, ideFloSou.port_b)
    annotation (Line(points={{-40,10},{-70,10},{-70,0}}, color={0,127,255}));
  connect(ideFloSou.port_a, junRet1.port_2) annotation (Line(points={{-70,-20},{
          -70,-50},{-40,-50}}, color={0,127,255}));
  connect(mChiSet_flow.y, ideFloSou.m_flow_in) annotation (Line(points={{-79,-70},
          {-74,-70},{-74,-24},{-84,-24},{-84,-16},{-78,-16}}, color={0,0,127}));
  connect(conRemCha.uRemCha, uRemCha.y) annotation (Line(points={{-22,32},{-66,
          32},{-66,70},{-79,70}},
                              color={255,0,255}));
  connect(bou.ports[1], junRet1.port_1) annotation (Line(points={{-20,-80},{-14,
          -80},{-14,-50},{-20,-50}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-06, StopTime=3600),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/NetworkConnection.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
[fixme: Update documentation]
This model validates the control of reversible flow at
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.NetworkConnection\">
Buildings.Fluid.Storage.Plant.NetworkConnection</a>
by
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Controls.RemoteCharging\">
Buildings.Fluid.Storage.Plant.Controls.RemoteCharging</a>.
</p>
<table summary= \"system modes\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Time slot</th>
    <th>Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>1</td>
    <td>No flow</td>
  </tr>
  <tr>
    <td>2</td>
    <td>Outputting CHW</td>
  </tr>
  <tr>
    <td>3</td>
    <td>Being charged remotely</td>
  </tr>
  <tr>
    <td>4</td>
    <td>Outputting CHW</td>
  </tr>
</tbody>
</table>
</html>", revisions="<html>
<ul>
<li>
September 28, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end NetworkConnection;
