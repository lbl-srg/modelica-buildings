within Buildings.Fluid.Storage.Plant.Validation.BaseClasses;
partial model PartialPlant "Base class for validation models"

  package Medium = Buildings.Media.Water "Medium model";

  parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom(
    mTan_flow_nominal=1,
    mChi_flow_nominal=1E-5,
    dp_nominal=300000,
    T_CHWS_nominal=280.15,
    T_CHWR_nominal=285.15) "Nominal values"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  Buildings.Fluid.Storage.Plant.Controls.RemoteCharging conRemCha(
    final plaTyp=nom.plaTyp)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.TimeTable mSet_flow(table=[0,0; 900,0; 900,1; 1800,1;
        1800,-1; 2700,-1; 2700,1; 3600,1]) "Mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isRemCha(t=1E-5)
    "Tank is being charged when the flow setpoint is negative"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Sources.BooleanTable uAva(
    final table={900},
    final startValue=false)
    "Plant availability"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroSup(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    final dp_nominal=nom.dp_nominal*0.3)
    "Flow resistance in the district network" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,30})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroRet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    final dp_nominal=nom.dp_nominal*0.3)
    "Flow resistance in the district network" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-30})));
  Buildings.Fluid.Storage.Plant.NetworkConnection netCon(
    redeclare final package Medium = Medium,
    final nom=nom,
    final plaTyp=nom.plaTyp,
    perPumSup(pressure(V_flow=nom.m_flow_nominal/1.2*{0,2}, dp=nom.dp_nominal*{2,
            0})))
    "Pump and valves connecting the storage plant to the district network"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = Medium)
    "Mass flow rate to the supply line"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource idePreSou(
    redeclare final package Medium = Medium,
    final m_flow_small=1E-5,
    final control_m_flow=false,
    final control_dp=true)
    "Ideal pressure source representing a remote chiller plant" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,0})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroNet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    final dp_nominal=nom.dp_nominal*0.3)
    "Flow resistance in the district network" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,0})));
  Modelica.Blocks.Sources.Constant dp(final k=-nom.dp_nominal*0.3)
    "Constant differential pressure"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Fluid.FixedResistances.Junction junSup(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,-nom.m_flow_nominal},
    dp_nominal={0,0,0}) "Junction on the supply side"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Fluid.FixedResistances.Junction junRet(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,nom.m_flow_nominal},
    dp_nominal={0,0,0}) "Junction on the return side" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-30})));

equation
  connect(conRemCha.yPumSup, netCon.yPumSup)
    annotation (Line(points={{-32,39},{-32,11}},
                                             color={0,0,127}));
  connect(conRemCha.yValSup, netCon.yValSup)
    annotation (Line(points={{-28,39},{-28,11}},
                                               color={0,0,127}));
  connect(mSet_flow.y, conRemCha.mTanSet_flow) annotation (Line(points={{-79,90},
          {-50,90},{-50,58},{-41,58}},color={0,0,127}));
  connect(mSet_flow.y, isRemCha.u)
    annotation (Line(points={{-79,90},{-42,90}},color={0,0,127}));
  connect(isRemCha.y, conRemCha.uRemCha) annotation (Line(points={{-18,90},{-12,
          90},{-12,58},{-18,58}},
                            color={255,0,255}));
  connect(conRemCha.uAva, uAva.y) annotation (Line(points={{-18,54},{26,54},{26,
          90},{21,90}}, color={255,0,255}));
  connect(senMasFlo.m_flow, conRemCha.mTan_flow)
    annotation (Line(points={{-70,21},{-70,54},{-41,54}}, color={0,0,127}));
  connect(netCon.port_bToNet,preDroSup. port_a) annotation (Line(points={{-20,6},
          {-6,6},{-6,30},{0,30}},  color={0,127,255}));
  connect(netCon.port_aFroNet,preDroRet. port_a) annotation (Line(points={{-20,-6},
          {-6,-6},{-6,-30},{0,-30}},  color={0,127,255}));
  connect(netCon.port_aFroChi,senMasFlo. port_b) annotation (Line(points={{-40,6},
          {-54,6},{-54,10},{-60,10}}, color={0,127,255}));
  connect(dp.y, idePreSou.dp_in) annotation (Line(points={{21,-70},{30,-70},{30,
          6},{42,6}}, color={0,0,127}));
  connect(preDroSup.port_b, junSup.port_1)
    annotation (Line(points={{20,30},{40,30}}, color={0,127,255}));
  connect(junSup.port_2, preDroNet.port_a)
    annotation (Line(points={{60,30},{90,30},{90,10}}, color={0,127,255}));
  connect(preDroNet.port_b, junRet.port_1)
    annotation (Line(points={{90,-10},{90,-30},{60,-30}}, color={0,127,255}));
  connect(junRet.port_2, preDroRet.port_b)
    annotation (Line(points={{40,-30},{20,-30}}, color={0,127,255}));
  connect(junRet.port_3, idePreSou.port_a)
    annotation (Line(points={{50,-20},{50,-10}}, color={0,127,255}));
  connect(idePreSou.port_b, junSup.port_3)
    annotation (Line(points={{50,10},{50,20}}, color={0,127,255}));
  connect(netCon.port_bToChi, senMasFlo.port_a) annotation (Line(points={{-40,-6},
          {-84,-6},{-84,10},{-80,10}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This is a base class for the validation models
whose storage tank can be charged remotely.
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
