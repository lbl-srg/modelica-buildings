within Buildings.Fluid.Storage.Plant.Validation;
model OpenTank "(Draft)"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialPlant(
      nom(
        final plaTyp=Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open,
        final dp_nominal=300000),
    sin(nPorts=1),
    sou(nPorts=1));

  Modelica.Blocks.Sources.TimeTable set_mTan_flow(table=[0,0; 3600/7,0; 3600/7,
        -1; 3600/7*3,-1; 3600/7*3,0; 3600/7*4,0; 3600/7*4,1; 3600/7*6,1; 3600/7
        *6,-1])
            "Tank flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Sources.BooleanTable uRemCha(table={0,3600/7*6}, startValue=
        true) "Tank is being charged remotely"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Sources.BooleanTable uOnl(table={3600/7*2})
    "True = plant online (outputting CHW to the network); False = offline"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Sources.TimeTable set_mChi_flow(table=[0,0; 3600/7,0; 3600/7,
        1; 3600/7*5,1; 3600/7*5,0]) "Chiller flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.PumpValveControl conPumVal(
    final plaTyp = nom.plaTyp)
    "Control block for the secondary pump and near-by valves"
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroSup(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    dp_nominal=0.3*nom.dp_nominal) "Flow resistance"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,20})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroRet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    dp_nominal=0.3*nom.dp_nominal) "Flow resistance" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={60,-20})));
  Buildings.Fluid.Storage.Plant.SupplyPumpValve supPum(
    redeclare final package Medium = Medium,
    final nom=nom,
    pumSup(per(pressure(V_flow=nom.m_flow_nominal*{0,1.6,2},
                        dp=(sin.p-101325)*{2,1.6,0}))),
    pumRet(per(pressure(V_flow=nom.mTan_flow_nominal*{0,1.6,2},
                        dp=(sou.p-101325)*{2,1.6,0})))) "Supply pump and valves"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
equation
  connect(conPumVal.uOnl, uOnl.y) annotation (Line(points={{32,56},{36,56},{36,90},
          {-39,90}},    color={255,0,255}));
  connect(conPumVal.uRemCha, uRemCha.y)
    annotation (Line(points={{32,60},{32,70},{-19,70}},color={255,0,255}));
  connect(tanBra.port_CHWR, supPum.port_chiInl)
    annotation (Line(points={{-10,-6},{10,-6}}, color={0,127,255}));
  connect(supPum.port_chiOut, tanBra.port_CHWS)
    annotation (Line(points={{10,6},{-10,6}}, color={0,127,255}));
  connect(supPum.port_CHWS, preDroSup.port_a) annotation (Line(points={{30,6},{44,
          6},{44,20},{50,20}}, color={0,127,255}));
  connect(supPum.port_CHWR, preDroRet.port_b) annotation (Line(points={{30,-6},{
          44,-6},{44,-20},{50,-20}}, color={0,127,255}));
  connect(tanBra.mTanTop_flow, conPumVal.mTanTop_flow)
    annotation (Line(points={{-16,11},{-16,50},{9,50}}, color={0,0,127}));
  connect(conPumVal.mTanSet_flow, set_mTan_flow.y) annotation (Line(points={{9,54},
          {-72,54},{-72,70},{-79,70}}, color={0,0,127}));
  connect(set_mChi_flow.y, ideChiBra.mPumSet_flow)
    annotation (Line(points={{-79,-30},{-56,-30},{-56,-11}}, color={0,0,127}));
  connect(supPum.yRet_actual, conPumVal.yRet_actual) annotation (Line(points={{10,
          11},{10,32},{2,32},{2,44},{9,44}}, color={0,0,127}));
  connect(conPumVal.ySup_actual, supPum.ySup_actual) annotation (Line(points={{9,
          40},{6,40},{6,36},{14,36},{14,11}}, color={0,0,127}));
  connect(supPum.yPumSup, conPumVal.yPumSup)
    annotation (Line(points={{18,11},{18,39}}, color={0,0,127}));
  connect(conPumVal.yValSup, supPum.yValSup)
    annotation (Line(points={{22,39},{22,11}}, color={0,0,127}));
  connect(conPumVal.yPumRet, supPum.yPumRet)
    annotation (Line(points={{26,39},{26,11}}, color={0,0,127}));
  connect(conPumVal.yRet, supPum.yRet)
    annotation (Line(points={{30,39},{30,11},{29.8,11}}, color={0,0,127}));
  connect(tanBra.mTanBot_flow, conPumVal.mTanBot_flow)
    annotation (Line(points={{-12,11},{-12,48},{9,48}}, color={0,0,127}));
  connect(preDroSup.port_b, sin.ports[1])
    annotation (Line(points={{70,20},{80,20}}, color={0,127,255}));
  connect(preDroRet.port_a, sou.ports[1])
    annotation (Line(points={{70,-20},{80,-20}}, color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/OpenTank.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Documentation pending.
</p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end OpenTank;
