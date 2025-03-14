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
  HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep calQUseP(
    typ=if have_switchover then 2 else 1,
    final scaFac=scaFac,
    final TLoa_nominal=TEva_nominal,
    final TSou_nominal=TCon_nominal,
    final use_TEvaOutForTab=use_TEvaOutForTab,
    final use_TConOutForTab=use_TConOutForTab,
    final use_TLoaLvgForCtl=use_TLoaLvgForCtl,
    final PLRSup=dat.PLRSup,
    final PLRCyc_min=dat.PLRCyc_min,
    final P_min=dat.P_min,
    final fileName=dat.fileName)
    "Compute heat flow rate and input power"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={90,30})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extBusSig[6](
    each final nin=2)
    "Extract bus signals depending on application and operating mode"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={70,80})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cp[2](
    k={cpEva, cpCon})
    "Specific heat capacity"
    annotation (Placement(transformation(extent={{30,88},{50,108}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator coo(
    nout=1)
    if have_switchover
    "Extract bus signals depending on application"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-80,100})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant have_swi(
    final k=have_switchover)
    "Constant Boolean"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant use_inChi(
    final k=useInChi)
    "Constant Boolean"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant plaCoo(
    final k=true)
    if not have_switchover
    "Placeholder signal"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[2](
    k={1, 2})
    "Constants"
    annotation (Placement(transformation(extent={{-50,-38},{-30,-18}})));
  Buildings.Controls.OBC.CDL.Logical.And havSwiAndCoo
    "True if have_switchover and cooling mode enabled"
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not notHavSwi
    "True if not have_switchover"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Selection index: 1 to use evaporator as load side, 2 to use condenser"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.And cooLoaAndUseChi
    "True if tracking a CHW setpoint and used in a chiller cycle model"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or cooLoa
    "True if tracking a CHW setpoint"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    nout=6)
    "Replicate selection index"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
equation
  connect(sigBus.TConInMea, extBusSig[1].u[1])
    annotation (Line(points={{1,120},{69.5,120},{69.5,92}},color={255,204,51},thickness=0.5));
  connect(sigBus.TEvaInMea, extBusSig[1].u[2])
    annotation (Line(points={{1,120},{70.5,120},{70.5,92}},color={255,204,51},thickness=0.5));
  connect(sigBus.TConOutMea, extBusSig[2].u[1])
    annotation (Line(points={{1,120},{69.5,120},{69.5,92}},color={255,204,51},thickness=0.5));
  connect(sigBus.TEvaOutMea, extBusSig[2].u[2])
    annotation (Line(points={{1,120},{70.5,120},{70.5,92}},color={255,204,51},thickness=0.5));
  connect(sigBus.TEvaInMea, extBusSig[3].u[1])
    annotation (Line(points={{1,120},{69.5,120},{69.5,92}},color={255,204,51},thickness=0.5));
  connect(sigBus.TConInMea, extBusSig[3].u[2])
    annotation (Line(points={{1,120},{70.5,120},{70.5,92}},color={255,204,51},thickness=0.5));
  connect(sigBus.TEvaOutMea, extBusSig[4].u[1])
    annotation (Line(points={{1,120},{69.5,120},{69.5,92}},color={255,204,51},thickness=0.5));
  connect(sigBus.TConOutMea, extBusSig[4].u[2])
    annotation (Line(points={{1,120},{70.5,120},{70.5,92}},color={255,204,51},thickness=0.5));
  connect(sigBus.mEvaMea_flow, extBusSig[5].u[1])
    annotation (Line(points={{1,120},{69.5,120},{69.5,92}},color={255,204,51},thickness=0.5));
  connect(sigBus.mConMea_flow, extBusSig[5].u[2])
    annotation (Line(points={{1,120},{70.5,120},{70.5,92}},color={255,204,51},thickness=0.5));
  connect(cp[1].y, extBusSig[6].u[1])
    annotation (Line(points={{52,98},{69.5,98},{69.5,92}},color={0,0,127}));
  connect(cp[2].y, extBusSig[6].u[2])
    annotation (Line(points={{52,98},{70.5,98},{70.5,92}},color={0,0,127}));
  connect(extBusSig[1].y, calQUseP.TSouEnt)
    annotation (Line(points={{70,68},{70,60},{91,60},{91,42}},color={0,0,127}));
  connect(extBusSig[2].y, calQUseP.TSouLvg)
    annotation (Line(points={{70,68},{70,60},{89,60},{89,42}},color={0,0,127}));
  connect(extBusSig[3].y, calQUseP.TLoaEnt)
    annotation (Line(points={{70,68},{70,60},{87,60},{87,42}},color={0,0,127}));
  connect(extBusSig[4].y, calQUseP.TLoaLvg)
    annotation (Line(points={{70,68},{70,60},{85,60},{85,42}},color={0,0,127}));
  connect(extBusSig[5].y, calQUseP.mLoa_flow)
    annotation (Line(points={{70,68},{70,60},{83,60},{83,42}},color={0,0,127}));
  connect(extBusSig[6].y, calQUseP.cpLoa)
    annotation (Line(points={{70,68},{70,60},{81,60},{81,42}},color={0,0,127}));
  connect(sigBus.onOffMea, calQUseP.on)
    annotation (Line(points={{1,120},{90,120},{90,80},{99,80},{99,42}},color={255,204,51},thickness=0.5));
  connect(sigBus.TSet, calQUseP.TSet)
    annotation (Line(points={{1,120},{90,120},{90,80},{95,80},{95,42}},color={255,204,51},thickness=0.5));
  connect(calQUseP.PLR, sigBus.PLRCoo)
    annotation (Line(points={{96,18},{96,10},{110,10},{110,120},{1,120}},color={0,0,127}));
  connect(sigBus.yMea, calQUseP.yMea)
    annotation (Line(points={{1,120},{90,120},{90,80},{93,80},{93,42}},color={255,204,51},thickness=0.5));
  connect(calQUseP.P, PEle)
    annotation (Line(points={{84,18},{84,-60},{0,-60},{0,-130}},color={0,0,127}));
  connect(calQUseP.Q_flow, proRedQEva.u2)
    annotation (Line(points={{90,18},{90,-50},{-24,-50},{-24,-78}},color={0,0,127}));
  connect(calQUseP.P, redQCon.u2)
    annotation (Line(points={{84,18},{84,-60},{64,-60},{64,-78}},color={0,0,127}));
  connect(sigBus.coo, coo.u)
    annotation (Line(points={{1,120},{-100,120},{-100,100},{-92,100}},color={255,204,51},thickness=0.5));
  connect(have_swi.y, havSwiAndCoo.u2)
    annotation (Line(points={{-68,40},{-60,40},{-60,62},{-52,62}},color={255,0,255}));
  connect(coo.y[1], havSwiAndCoo.u1)
    annotation (Line(points={{-68,100},{-60,100},{-60,70},{-52,70}},color={255,0,255}));
  connect(plaCoo.y, havSwiAndCoo.u1)
    annotation (Line(points={{-68,70},{-52,70}},color={255,0,255}));
  connect(have_swi.y, notHavSwi.u)
    annotation (Line(points={{-68,40},{-52,40}},color={255,0,255}));
  connect(use_inChi.y, cooLoaAndUseChi.u2)
    annotation (Line(points={{-68,0},{-64,0},{-64,-8},{-52,-8}},color={255,0,255}));
  connect(notHavSwi.y, cooLoa.u2)
    annotation (Line(points={{-28,40},{-20,40},{-20,52},{-12,52}},color={255,0,255}));
  connect(havSwiAndCoo.y, cooLoa.u1)
    annotation (Line(points={{-28,70},{-20,70},{-20,60},{-12,60}},color={255,0,255}));
  connect(cooLoa.y, cooLoaAndUseChi.u1)
    annotation (Line(points={{12,60},{14,60},{14,20},{-60,20},{-60,0},{-52,0}},
      color={255,0,255}));
  connect(cooLoaAndUseChi.y, intSwi.u2)
    annotation (Line(points={{-28,0},{-12,0}},color={255,0,255}));
  connect(extBusSig.index, intScaRep.y)
    annotation (Line(points={{58,80},{54,80},{54,60},{52,60}},color={255,127,0}));
  connect(intScaRep.u, intSwi.y)
    annotation (Line(points={{28,60},{20,60},{20,0},{12,0}},color={255,127,0}));
  connect(cst[1].y, intSwi.u1)
    annotation (Line(points={{-28,-28},{-20,-28},{-20,8},{-12,8}},color={255,127,0}));
  connect(cst[2].y, intSwi.u3)
    annotation (Line(points={{-28,-28},{-20,-28},{-20,-8},{-12,-8}},color={255,127,0}));
  connect(coo.y[1], calQUseP.coo)
    annotation (Line(points={{-68,100},{-60,100},{-60,114},{97,114},{97,42}},
      color={255,0,255}));
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
</html>"));
end TableData2DLoadDep;
