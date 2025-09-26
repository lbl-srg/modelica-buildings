within Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle;
model TableData2DLoadDep
  "Data-based model dependent on evaporator and condenser entering or leaving temperarure and PLR"
  extends Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle(
    final devIde=dat.devIde,
    PEle_nominal=calQUseP.P_nominal * scaFac);
  parameter Boolean have_switchover=false
    "Set to true for heat recovery chiller with built-in switchover"
    annotation (Evaluate=true);
  final parameter Real scaFac=QCoo_flow_nominal / calQUseP.Q_flow_nominal
    "Scaling factor";
  final parameter Boolean use_TEvaOutForTab=dat.use_TEvaOutForTab
    "=true to use evaporator outlet temperature, false for inlet";
  final parameter Boolean use_TConOutForTab=dat.use_TConOutForTab
    "=true to use condenser outlet temperature, false for inlet";
  parameter Boolean use_TLoaLvgForCtl=true
    "Set to true for leaving temperature control, false for entering temperature control"
    annotation (Evaluate=true);
  replaceable parameter Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic dat
    "Table with performance data"
    annotation (choicesAllMatching=true);
  parameter Modelica.Units.SI.Power P_min(final min=0)=0
    "Minimum power when system is enabled with compressor cycled off";
  HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep calQUseP(
    typ=if have_switchover then 2 else 1,
    final scaFac=scaFac,
    final TLoa_nominal=TEva_nominal,
    final TAmb_nominal=TCon_nominal,
    final use_TEvaOutForTab=use_TEvaOutForTab,
    final use_TConOutForTab=use_TConOutForTab,
    final use_TLoaLvgForCtl=use_TLoaLvgForCtl,
    final PLRSup=dat.PLRSup,
    final PLRCyc_min=dat.PLRCyc_min,
    final P_min=P_min,
    final fileName=dat.fileName,
    final tabNamQ=dat.tabNamQ,
    final tabNamP=dat.tabNamP)
    "Compute heat flow rate and input power"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={120,0})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extBusSig[6](
    each final nin=2)
    "Extract bus signals depending on application and operating mode"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={100,80})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cp[2](
    k={cpEva, cpCon})
    "Specific heat capacity"
    annotation (Placement(transformation(extent={{60,88},{80,108}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator coo(
    nout=1)
    if have_switchover
    "Extract bus signals depending on application"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-50,100})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant have_swi(
    final k=have_switchover)
    "Constant Boolean"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant use_inChi(
    final k=useInChi)
    "Constant Boolean"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant plaCoo(
    final k=true)
    if not have_switchover
    "Placeholder signal"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[2](
    k={1, 2})
    "Constants"
    annotation (Placement(transformation(extent={{-20,-38},{0,-18}})));
  Buildings.Controls.OBC.CDL.Logical.And havSwiAndCoo
    "True if have_switchover and cooling mode enabled"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not notHavSwi
    "True if not have_switchover"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Selection index: 1 to use evaporator as load side, 2 to use condenser"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.And cooLoaAndUseChi
    "True if tracking a CHW setpoint and used in a chiller cycle model"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or cooLoa
    "True if tracking a CHW setpoint"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    nout=6)
    "Replicate selection index"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not notHea if not useInChi
    "Heating disabled (if used in reversible heat pump)"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru(final k=true)
    if useInChi "Placeholder signal for cooling-only system"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndCoo
    "True if on and (used in chiller or used in HP and enabled in cooling mode)"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
equation
  connect(sigBus.TConInMea, extBusSig[1].u[1])
    annotation (Line(points={{1,120},{99.5,120},{99.5,92}},color={255,204,51},thickness=0.5));
  connect(sigBus.TEvaInMea, extBusSig[1].u[2])
    annotation (Line(points={{1,120},{100.5,120},{100.5,92}},
                                                           color={255,204,51},thickness=0.5));
  connect(sigBus.TConOutMea, extBusSig[2].u[1])
    annotation (Line(points={{1,120},{99.5,120},{99.5,92}},color={255,204,51},thickness=0.5));
  connect(sigBus.TEvaOutMea, extBusSig[2].u[2])
    annotation (Line(points={{1,120},{100.5,120},{100.5,92}},
                                                           color={255,204,51},thickness=0.5));
  connect(sigBus.TEvaInMea, extBusSig[3].u[1])
    annotation (Line(points={{1,120},{99.5,120},{99.5,92}},color={255,204,51},thickness=0.5));
  connect(sigBus.TConInMea, extBusSig[3].u[2])
    annotation (Line(points={{1,120},{100.5,120},{100.5,92}},
                                                           color={255,204,51},thickness=0.5));
  connect(sigBus.TEvaOutMea, extBusSig[4].u[1])
    annotation (Line(points={{1,120},{99.5,120},{99.5,92}},color={255,204,51},thickness=0.5));
  connect(sigBus.TConOutMea, extBusSig[4].u[2])
    annotation (Line(points={{1,120},{100.5,120},{100.5,92}},
                                                           color={255,204,51},thickness=0.5));
  connect(sigBus.mEvaMea_flow, extBusSig[5].u[1])
    annotation (Line(points={{1,120},{99.5,120},{99.5,92}},color={255,204,51},thickness=0.5));
  connect(sigBus.mConMea_flow, extBusSig[5].u[2])
    annotation (Line(points={{1,120},{100.5,120},{100.5,92}},
                                                           color={255,204,51},thickness=0.5));
  connect(cp[1].y, extBusSig[6].u[1])
    annotation (Line(points={{82,98},{99.5,98},{99.5,92}},color={0,0,127}));
  connect(cp[2].y, extBusSig[6].u[2])
    annotation (Line(points={{82,98},{100.5,98},{100.5,92}},
                                                          color={0,0,127}));
  connect(extBusSig[1].y,calQUseP.TAmbEnt)
    annotation (Line(points={{100,68},{100,60},{121,60},{121,12}},
                                                              color={0,0,127}));
  connect(extBusSig[2].y,calQUseP.TAmbLvg)
    annotation (Line(points={{100,68},{100,60},{119,60},{119,12}},
                                                              color={0,0,127}));
  connect(extBusSig[3].y, calQUseP.TLoaEnt)
    annotation (Line(points={{100,68},{100,60},{117,60},{117,12}},
                                                              color={0,0,127}));
  connect(extBusSig[4].y, calQUseP.TLoaLvg)
    annotation (Line(points={{100,68},{100,60},{115,60},{115,12}},
                                                              color={0,0,127}));
  connect(extBusSig[5].y, calQUseP.mLoa_flow)
    annotation (Line(points={{100,68},{100,60},{113,60},{113,12}},
                                                              color={0,0,127}));
  connect(extBusSig[6].y, calQUseP.cpLoa)
    annotation (Line(points={{100,68},{100,60},{111,60},{111,12}},
                                                              color={0,0,127}));
  connect(sigBus.TSet, calQUseP.TSet)
    annotation (Line(points={{1,120},{125,120},{125,12}},              color={255,204,51},thickness=0.5));
  connect(calQUseP.PLR, sigBus.PLRCoo)
    annotation (Line(points={{126,-12},{126,-20},{134,-20},{134,120},{1,120}},
                                                                         color={0,0,127}));
  connect(sigBus.yMea, calQUseP.yMea)
    annotation (Line(points={{1,120},{123,120},{123,12}},              color={255,204,51},thickness=0.5));
  connect(calQUseP.P, PEle)
    annotation (Line(points={{114,-12},{114,-60},{0,-60},{0,-130}},
                                                                color={0,0,127}));
  connect(calQUseP.Q_flow, proRedQEva.u2)
    annotation (Line(points={{120,-12},{120,-50},{-24,-50},{-24,-78}},
                                                                   color={0,0,127}));
  connect(calQUseP.P, redQCon.u2)
    annotation (Line(points={{114,-12},{114,-60},{64,-60},{64,-78}},
                                                                 color={0,0,127}));
  connect(sigBus.coo, coo.u)
    annotation (Line(points={{1,120},{-74,120},{-74,100},{-62,100}},  color={255,204,51},thickness=0.5));
  connect(have_swi.y, havSwiAndCoo.u2)
    annotation (Line(points={{-38,40},{-26,40},{-26,62},{-22,62}},color={255,0,255}));
  connect(coo.y[1], havSwiAndCoo.u1)
    annotation (Line(points={{-38,100},{-30,100},{-30,70},{-22,70}},color={255,0,255}));
  connect(plaCoo.y, havSwiAndCoo.u1)
    annotation (Line(points={{-38,70},{-22,70}},color={255,0,255}));
  connect(have_swi.y, notHavSwi.u)
    annotation (Line(points={{-38,40},{-22,40}},color={255,0,255}));
  connect(use_inChi.y, cooLoaAndUseChi.u2)
    annotation (Line(points={{-38,0},{-34,0},{-34,-8},{-22,-8}},color={255,0,255}));
  connect(notHavSwi.y, cooLoa.u2)
    annotation (Line(points={{2,40},{10,40},{10,52},{18,52}},     color={255,0,255}));
  connect(havSwiAndCoo.y, cooLoa.u1)
    annotation (Line(points={{2,70},{10,70},{10,60},{18,60}},     color={255,0,255}));
  connect(cooLoa.y, cooLoaAndUseChi.u1)
    annotation (Line(points={{42,60},{44,60},{44,16},{-30,16},{-30,0},{-22,0}},
      color={255,0,255}));
  connect(cooLoaAndUseChi.y, intSwi.u2)
    annotation (Line(points={{2,0},{18,0}},   color={255,0,255}));
  connect(extBusSig.index, intScaRep.y)
    annotation (Line(points={{88,80},{84,80},{84,60},{82,60}},color={255,127,0}));
  connect(intScaRep.u, intSwi.y)
    annotation (Line(points={{58,60},{50,60},{50,0},{42,0}},color={255,127,0}));
  connect(cst[1].y, intSwi.u1)
    annotation (Line(points={{2,-28},{10,-28},{10,8},{18,8}},     color={255,127,0}));
  connect(cst[2].y, intSwi.u3)
    annotation (Line(points={{2,-28},{10,-28},{10,-8},{18,-8}},     color={255,127,0}));
  connect(coo.y[1], calQUseP.coo)
    annotation (Line(points={{-38,100},{-30,100},{-30,22},{127,22},{127,12}},
      color={255,0,255}));
  connect(sigBus.hea, notHea.u) annotation (Line(
      points={{1,120},{-150,120},{-150,30},{-142,30}},
      color={255,204,51},
      thickness=0.5));
  connect(tru.y, onAndCoo.u2) annotation (Line(points={{-118,0},{-116,0},{-116,
          12},{-102,12}}, color={255,0,255}));
  connect(sigBus.onOffMea, onAndCoo.u1) annotation (Line(
      points={{1,120},{-106,120},{-106,20},{-102,20}},
      color={255,204,51},
      thickness=0.5));
  connect(notHea.y, onAndCoo.u2) annotation (Line(points={{-118,30},{-116,30},{
          -116,12},{-102,12}}, color={255,0,255}));
  connect(onAndCoo.y, calQUseP.on)
    annotation (Line(points={{-78,20},{129,20},{129,12}}, color={255,0,255}));
  annotation (Icon(graphics={
    Line(points={{-46,90},{-46,40}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-106,70},{-76,90}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-106,50},{-76,70}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-106,30},{-76,50}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-106,10},{-76,30}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-62,20},{-32,40}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-62,0},{-32,20}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-62,-20},{-32,0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-62,-40},{-32,-20}}),
    Line(points={{-18,-10},{-18,-90},{102,-90},{102,-10},{72,-10},{72,-90},{12,-90},
              {12,-10},{-18,-10},{-18,-30},{102,-30},{102,-50},{-18,-50},{-18,-70},
              {102,-70},{102,-90},{-18,-90},{-18,-10},{102,-10},{102,-90}}),
    Line(points={{42,-10},{42,-90}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-18,-30},{12,-10}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-18,-50},{12,-30}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-18,-70},{12,-50}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-18,-90},{12,-70}}),
    Line(points={{-16,90},{-16,40}}),
    Line(points={{12,90},{12,40}}),
    Line(points={{-76,90},{12,90}}),
    Line(points={{28,40},{28,-10}}),
    Line(points={{-76,70},{12,70}}),
    Line(points={{-76,50},{12,50}}),
    Line(points={{-76,30},{-62,30}}),
    Line(points={{-76,10},{-62,10}}),
    Line(points={{-32,-20},{-18,-20}}),
    Line(points={{-32,-40},{-18,-40}}),
    Line(points={{-32,40},{12,40}}),
    Line(points={{-2,40},{-2,-10}}),
    Line(points={{56,40},{56,-10}}),
    Line(points={{-32,40},{56,40}}),
    Line(points={{-32,20},{56,20}}),
    Line(points={{-32,0},{56,0}})}), Documentation(info="<html>
<p>
This model serves as a wrapper class to integrate the block
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep</a>
into chiller models.
For a complete description of all modeling assumptions, 
please refer to the documentation of this block.
</p>
</html>", revisions="<html>
<ul>
<li>
March 21, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-160,-120},{140,120}})));
end TableData2DLoadDep;
