within Buildings.Fluid.Storage.Plant.Validation;
model ClosedTank
  "Validation model for NetworkConnection with a closed tank"

  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom(
    allowRemoteCharging=true,
    useReturnPump=false,
    mTan_flow_nominal=1,
    mChi_flow_nominal=1,
    dp_nominal=300000,
    T_CHWS_nominal=280.15,
    T_CHWR_nominal=285.15) "Nominal values"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));

  Buildings.Fluid.Storage.Plant.Controls.RemoteChargingSupply conRemCha
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.TimeTable mTanSet_flow(table=[0,0; 600,0; 600,1; 1200,
        1; 1200,0; 1800,0; 1800,-1; 3600,-1]) "Mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Modelica.Blocks.Sources.BooleanTable uAva(final table={600,2400,3000},
    final startValue=false) "Plant availability"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Fluid.Storage.Plant.NetworkConnection netCon(
    redeclare final package Medium = Medium,
    final nom=nom,
    final allowRemoteCharging=nom.allowRemoteCharging,
    useReturnPump=nom.useReturnPump,
    perSup(pressure(V_flow=nom.m_flow_nominal/1000*{0,1,2},
           dp=nom.dp_nominal*{1.14,1,0.42})))
    "Pump and valves connecting the storage plant to the district network"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sensors.MassFlowRate mTanSup_flow(
    redeclare final package Medium = Medium)
    "Tank mass flow rate on the supply side" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-70,20})));
  Buildings.Fluid.Sensors.MassFlowRate mTanRet_flow(
    redeclare final package Medium = Medium)
    "Tank mass flow rate on the return side" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-70,-20})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource idePreSou(
    redeclare final package Medium = Medium,
    final m_flow_small=1E-5,
    final control_m_flow=false,
    final control_dp=true)
    "Ideal pressure source representing a remote chiller plant" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,0})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource ideFloSou(
    redeclare final package Medium = Medium,
    final m_flow_small=1E-5,
    final control_m_flow=true,
    final control_dp=false) "Ideal flow source representing the primary pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-108,6})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroNet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    final dp_nominal=nom.dp_nominal*0.6)
    "Flow resistance in the district network" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={130,0})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroSup(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    final dp_nominal=nom.dp_nominal*0.15)
    "Flow resistance in the district network" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,50})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroRet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    final dp_nominal=nom.dp_nominal*0.15)
    "Flow resistance in the district network" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,-50})));
  Modelica.Blocks.Sources.Constant dp(final k=-nom.dp_nominal*0.6)
    "Constant differential pressure"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  Buildings.Fluid.FixedResistances.Junction junSup1(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final T_start=nom.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,-nom.m_flow_nominal},
    final dp_nominal={0,0,0}) "Junction on the supply side"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
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
        origin={-70,-50})));
  Buildings.Fluid.FixedResistances.Junction junSup2(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,-nom.m_flow_nominal},
    final dp_nominal={0,0,0}) "Junction on the supply side"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
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
        origin={90,-50})));

  Buildings.Fluid.Sources.Boundary_pT bou1(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa") = 101325 + preDroRet.dp_nominal,
    nPorts=1)                                       "Pressure boundary"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={90,-90})));

  Modelica.Blocks.Sources.TimeTable mChiSet_flow(table=[0,0; 600,0; 600,1; 1800,
        1; 1800,2; 2400,2; 2400,1; 3000,1; 3000,0; 3600,0])
    "Mass flow rate setpoint for the primary pump"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Modelica.Blocks.Sources.BooleanTable uRemCha(final table={3000}, final
      startValue=false) "Remote charging status"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Fluid.BaseClasses.ActuatorFilter fil(
    f=20/(2*Modelica.Constants.pi*60),
    final initType=Modelica.Blocks.Types.Init.InitialState,
    final n=2,
    final normalized=true) "Second order filter to improve numerics"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-90})));

equation
  connect(conRemCha.yPum, netCon.yPumSup)
    annotation (Line(points={{1,64},{8,64},{8,11}}, color={0,0,127}));
  connect(conRemCha.yVal, netCon.yVal)
    annotation (Line(points={{1,68},{12,68},{12,11}}, color={0,0,127}));
  connect(mTanSet_flow.y, conRemCha.mTanSet_flow) annotation (Line(points={{-99,70},
          {-90,70},{-90,68},{-21,68}},     color={0,0,127}));
  connect(conRemCha.uAva, uAva.y) annotation (Line(points={{-22,76},{-28,76},{-28,
          110},{-39,110}},
                        color={255,0,255}));
  connect(mTanSup_flow.m_flow, conRemCha.mTan_flow) annotation (Line(points={{-59,
          20},{-40,20},{-40,64},{-21,64}}, color={0,0,127}));
  connect(dp.y, idePreSou.dp_in) annotation (Line(points={{61,-90},{68,-90},{68,
          6},{82,6}}, color={0,0,127}));
  connect(junSup2.port_2, preDroNet.port_a)
    annotation (Line(points={{100,50},{130,50},{130,10}},
                                                       color={0,127,255}));
  connect(preDroNet.port_b, junRet2.port_1)
    annotation (Line(points={{130,-10},{130,-50},{100,-50}},
                                                          color={0,127,255}));
  connect(junRet2.port_3, idePreSou.port_a)
    annotation (Line(points={{90,-40},{90,-10}}, color={0,127,255}));
  connect(idePreSou.port_b, junSup2.port_3)
    annotation (Line(points={{90,10},{90,40}}, color={0,127,255}));
  connect(junSup1.port_2, netCon.port_aFroChi) annotation (Line(points={{-60,50},
          {-6,50},{-6,6},{0,6}}, color={0,127,255}));
  connect(junRet1.port_1, netCon.port_bToChi) annotation (Line(points={{-60,-50},
          {-6,-50},{-6,-6},{0,-6}}, color={0,127,255}));
  connect(mTanSup_flow.port_b, junSup1.port_3)
    annotation (Line(points={{-70,30},{-70,40}}, color={0,127,255}));
  connect(junSup1.port_1, ideFloSou.port_b)
    annotation (Line(points={{-80,50},{-108,50},{-108,16}},
                                                         color={0,127,255}));
  connect(ideFloSou.port_a, junRet1.port_2) annotation (Line(points={{-108,-4},{
          -108,-50},{-80,-50}},color={0,127,255}));
  connect(conRemCha.uRemCha, uRemCha.y) annotation (Line(points={{-22,72},{-80,72},
          {-80,110},{-99,110}},
                              color={255,0,255}));
  connect(mChiSet_flow.y, fil.u) annotation (Line(points={{-99,-90},{-82,-90}},
                                         color={0,0,127}));
  connect(fil.y, ideFloSou.m_flow_in)
    annotation (Line(points={{-59,-90},{-54,-90},{-54,-70},{-122,-70},{-122,6.66134e-16},
          {-116,6.66134e-16}},                               color={0,0,127}));
  connect(netCon.port_bToNet, preDroSup.port_a) annotation (Line(points={{20,6},{
          30,6},{30,50},{40,50}},  color={0,127,255}));
  connect(preDroSup.port_b, junSup2.port_1)
    annotation (Line(points={{60,50},{80,50}}, color={0,127,255}));
  connect(junRet2.port_2, preDroRet.port_a)
    annotation (Line(points={{80,-50},{60,-50}}, color={0,127,255}));
  connect(preDroRet.port_b, netCon.port_aFroNet) annotation (Line(points={{40,-50},
          {30,-50},{30,-6},{20,-6}}, color={0,127,255}));
  connect(bou1.ports[1], preDroNet.port_b) annotation (Line(points={{100,-90},{130,
          -90},{130,-10}}, color={0,127,255}));
  connect(junRet1.port_3, mTanRet_flow.port_a)
    annotation (Line(points={{-70,-40},{-70,-30}}, color={0,127,255}));
  connect(mTanRet_flow.port_b, mTanSup_flow.port_a)
    annotation (Line(points={{-70,-10},{-70,10}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-06, StopTime=3600),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/ClosedTank.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model validates the fulfilment of the control objectives at
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.NetworkConnection\">
Buildings.Fluid.Storage.Plant.NetworkConnection</a>
by
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Controls.RemoteChargingSupply\">
Buildings.Fluid.Storage.Plant.Controls.RemoteChargingSupply</a>.
</p>
<table summary= \"system modes\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Time Slot</th>
    <th>Chiller Flow</th>
    <th>Tank Flow</th>
    <th>Plant Flow</th>
    <th>Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>1</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>No flow</td>
  </tr>
  <tr>
    <td>2</td>
    <td>1</td>
    <td>1</td>
    <td>2</td>
    <td>Both chiller and tank outputting</td>
  </tr>
  <tr>
    <td>3</td>
    <td>1</td>
    <td>0</td>
    <td>1</td>
    <td>Chiller outputting, tank holding</td>
  </tr>
  <tr>
    <td>4</td>
    <td>2</td>
    <td>-1</td>
    <td>0</td>
    <td>Chiller outputting and charging the tank</td>
  </tr>
  <tr>
    <td>5</td>
    <td>1</td>
    <td>-1</td>
    <td>0</td>
    <td>Chiller charging the tank, plant off the network</td>
  </tr>
  <tr>
    <td>6</td>
    <td>0</td>
    <td>-1</td>
    <td>-1</td>
    <td>Chiller off, tank being charged remotely</td>
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
</html>"),
    Diagram(coordinateSystem(extent={{-140,-120},{160,140}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ClosedTank;
