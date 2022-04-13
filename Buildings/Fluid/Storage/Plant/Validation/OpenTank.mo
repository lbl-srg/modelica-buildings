within Buildings.Fluid.Storage.Plant.Validation;
model OpenTank "(Draft)"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialPlant(
      souChi(final use_m_flow_in=true),
      nom(final tankIsOpen=true,
          final dp_nominal=300000));

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
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.PumpValveControl conPumVal(
    final tankIsOpen=nom.tankIsOpen)
    "Control block for the secondary pump and near-by valves"
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Modelica.Blocks.Sources.Constant set_pCHWS(k=sin.p - 0.3*nom.dp_nominal)
    "PSV setpoint on the supply line"
    annotation (Placement(transformation(extent={{80,80},{60,100}})));
  Modelica.Blocks.Sources.Constant set_pCHWR(k=sou.p + 0.3*nom.dp_nominal)
    "PSV setpoint on the return line"
    annotation (Placement(transformation(extent={{80,40},{60,60}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroSup(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.mTan_flow_nominal,
    dp_nominal=0.3*nom.dp_nominal) "Flow resistance"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,20})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroRet(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.mTan_flow_nominal,
    dp_nominal=0.3*nom.dp_nominal) "Flow resistance" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={60,-20})));
  Buildings.Fluid.Storage.Plant.SupplyPumpOpenTank supPum(
    redeclare final package Medium = Medium,
    final nom=nom) "Supply pump and valves"
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
equation
  connect(set_mChi_flow.y, souChi.m_flow_in)
    annotation (Line(points={{-79,30},{-70,30},{-70,28},{-62,28}},
                                                       color={0,0,127}));
  connect(set_mTan_flow.y,conPumVal. mTanSet_flow)
    annotation (Line(points={{-79,70},{-72,70},{-72,52},{9,52}},
                                                             color={0,0,127}));
  connect(conPumVal.uOnl, uOnl.y) annotation (Line(points={{32,56},{36,56},{36,90},
          {-39,90}},    color={255,0,255}));
  connect(conPumVal.uRemCha, uRemCha.y)
    annotation (Line(points={{32,60},{32,70},{-19,70}},color={255,0,255}));
  connect(tanBra.mTan_flow,conPumVal. mTan_flow)
    annotation (Line(points={{-12,11},{-12,48},{9,48}}, color={0,0,127}));
  connect(supPum.yValDis_actual,conPumVal. yValDis_actual) annotation (Line(
        points={{8,11},{8,16},{-2,16},{-2,44},{9,44}}, color={0,0,127}));
  connect(supPum.yValCha_actual,conPumVal. yValCha_actual) annotation (Line(
        points={{12,11},{12,20},{2,20},{2,40},{9,40}}, color={0,0,127}));
  connect(supPum.yPum, conPumVal.yPum) annotation (Line(points={{16,11},{16,24},
          {16,24},{16,39}}, color={0,0,127}));
  connect(supPum.yValChaMod, conPumVal.yValChaMod) annotation (Line(points={{20,11},
          {20,28},{20,28},{20,39}},     color={0,0,127}));
  connect(conPumVal.yValChaOn, supPum.yValChaOn) annotation (Line(points={{22,39},
          {22,30},{22,30},{22,11}}, color={0,0,127}));
  connect(supPum.yValDisMod, conPumVal.yValDisMod) annotation (Line(points={{26,11},
          {26,34},{26,34},{26,39}},     color={0,0,127}));
  connect(conPumVal.yValDisOn, supPum.yValDisOn) annotation (Line(points={{28,39},
          {28,11}},                 color={0,0,127}));
  connect(conPumVal.pCHWS, supPum.pCHWS)
    annotation (Line(points={{31,40},{36,40},{36,3},{29,3}}, color={0,0,127}));
  connect(supPum.pCHWR, conPumVal.pCHWR) annotation (Line(points={{29,-3},{40,
          -3},{40,44},{31,44}},
                            color={0,0,127}));
  connect(conPumVal.pCHWSSet, set_pCHWS.y) annotation (Line(points={{31,52},{50,
          52},{50,90},{59,90}}, color={0,0,127}));
  connect(conPumVal.pCHWRSet, set_pCHWR.y) annotation (Line(points={{31,48},{54,
          48},{54,50},{59,50}}, color={0,0,127}));
  connect(preDroSup.port_b, sin.ports[1])
    annotation (Line(points={{70,20},{80,20}}, color={0,127,255}));
  connect(preDroSup.port_a, supPum.port_CHWS) annotation (Line(points={{50,20},
          {44,20},{44,6},{28,6}},color={0,127,255}));
  connect(supPum.port_CHWR, preDroRet.port_b) annotation (Line(points={{28,-6},
          {44,-6},{44,-20},{50,-20}},color={0,127,255}));
  connect(preDroRet.port_a, sou.ports[1])
    annotation (Line(points={{70,-20},{80,-20}}, color={0,127,255}));
  connect(tanBra.port_CHWS, supPum.port_chiOut)
    annotation (Line(points={{-10,6},{8,6}}, color={0,127,255}));
  connect(supPum.port_chiInl, tanBra.port_CHWR)
    annotation (Line(points={{8,-6},{-10,-6}}, color={0,127,255}));
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
