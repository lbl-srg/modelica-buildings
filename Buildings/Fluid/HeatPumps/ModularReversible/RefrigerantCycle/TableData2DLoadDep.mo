within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle;
model TableData2DLoadDep
  "Data-based model dependent on condenser and evaporator entering or leaving temperarure and PLR"
  extends Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle(
    final devIde=dat.devIde,
    PEle_nominal=calQUseP.P_nominal * scaFac);
  parameter Boolean use_rev
    "True if the refrigerant machine is reversible";
  final parameter Real scaFac(final unit="1")=QHea_flow_nominal / calQUseP.Q_flow_nominal
    "Scaling factor";
  final parameter Boolean use_TEvaOutForTab=dat.use_TEvaOutForTab
    "=true to use evaporator outlet temperature, false for inlet";
  final parameter Boolean use_TConOutForTab=dat.use_TConOutForTab
    "=true to use condenser outlet temperature, false for inlet";
  parameter Boolean use_TLoaLvgForCtl=true
    "Set to true for leaving temperature control, false for entering temperature control"
    annotation (Evaluate=true);
  replaceable parameter Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.GenericHeatPump dat
    "Table with performance data"
    annotation (choicesAllMatching=true);
  BaseClasses.TableData2DLoadDep calQUseP(
    final typ=3,
    final scaFac=scaFac,
    final TLoa_nominal=TCon_nominal,
    final TSou_nominal=TEva_nominal,
    final use_TEvaOutForTab=use_TEvaOutForTab,
    final use_TConOutForTab=use_TConOutForTab,
    final use_TLoaLvgForCtl=use_TLoaLvgForCtl,
    final PLRSup=dat.PLRSup,
    final PLRCyc_min=dat.PLRCyc_min,
    final P_min=dat.P_min,
    final fileName=dat.fileName)
    "Compute heat flow rate and input power"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={120,0})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cp[2](
    k={cpEva, cpCon})
    "Specific heat capacity"
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extBusSig[6](
    each final nin=2)
    "Extract bus signals depending on application"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={100,80})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[2](
    k={1, 2})
    "Constants"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Selection index: 1 to use evaporator as load side, 2 to use condenser"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    nout=6)
    "Replicate selection index"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant use_inHp(
    final k=useInHeaPum) "Constant Boolean"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not notCoo if not useInHeaPum and use_rev
    "Cooling disabled (if used in chiller)"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator hea
    if useInHeaPum and use_rev
    "Heating enable (if used in reversible heat pump)"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru(final k=true)
    if not use_rev "Placeholder signal for heating-only system"
    annotation (Placement(transformation(extent={{-100,22},{-80,42}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndHea
    "True if enabled in heating mode"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
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
    annotation (Line(points={{72,100},{99.5,100},{99.5,92}},color={0,0,127}));
  connect(cp[2].y, extBusSig[6].u[2])
    annotation (Line(points={{72,100},{100.5,100},{100.5,92}},
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
  connect(calQUseP.PLR, sigBus.PLRHea)
    annotation (Line(points={{126,-12},{126,-20},{136,-20},{136,120},{1,120}},
                                                                         color={0,0,127}));
  connect(sigBus.yMea, calQUseP.yMea)
    annotation (Line(points={{1,120},{123,120},{123,12}},              color={255,204,51},thickness=0.5));
  connect(calQUseP.P, feeHeaFloEva.u1)
    annotation (Line(points={{114,-12},{114,-20},{-84,-20},{-84,-10},{-78,-10}},
                                                                         color={0,0,127}));
  connect(calQUseP.P, PEle)
    annotation (Line(points={{114,-12},{114,-20},{0,-20},{0,-130}},
                                                            color={0,0,127}));
  connect(calQUseP.Q_flow, feeHeaFloEva.u2)
    annotation (Line(points={{120,-12},{120,-24},{-70,-24},{-70,-18}},
      color={0,0,127}));
  connect(calQUseP.P, redQCon.u2)
    annotation (Line(points={{114,-12},{114,-20},{64,-20},{64,-78}},
                                                             color={0,0,127}));
  connect(intScaRep.y, extBusSig.index)
    annotation (Line(points={{72,60},{80,60},{80,80},{88,80}},color={255,127,0}));
  connect(intSwi.y, intScaRep.u)
    annotation (Line(points={{42,60},{48,60}},color={255,127,0}));
  connect(use_inHp.y, intSwi.u2)
    annotation (Line(points={{2,60},{18,60}},   color={255,0,255}));
  connect(cst[1].y, intSwi.u3)
    annotation (Line(points={{2,90},{10,90},{10,52},{18,52}},     color={255,127,0}));
  connect(cst[2].y, intSwi.u1)
    annotation (Line(points={{2,90},{10,90},{10,68},{18,68}},     color={255,127,0}));
  connect(sigBus.hea, hea.u) annotation (Line(
      points={{1,120},{-120,120},{-120,60},{-102,60}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.onOffMea, onAndHea.u1) annotation (Line(
      points={{1,120},{-60,120},{-60,40},{-52,40}},
      color={255,204,51},
      thickness=0.5));
  connect(hea.y[1], onAndHea.u2) annotation (Line(points={{-78,60},{-70,60},{
          -70,32},{-52,32}},
                         color={255,0,255}));
  connect(tru.y, onAndHea.u2) annotation (Line(points={{-78,32},{-52,32}},
                         color={255,0,255}));
  connect(onAndHea.y, calQUseP.on)
    annotation (Line(points={{-28,40},{129,40},{129,12}},
                                                        color={255,0,255}));
  connect(sigBus.coo, notCoo.u) annotation (Line(
      points={{1,120},{-120,120},{-120,90},{-102,90}},
      color={255,204,51},
      thickness=0.5));
  connect(notCoo.y, onAndHea.u2) annotation (Line(points={{-78,90},{-68,90},{
          -68,32},{-52,32}}, color={255,0,255}));
  annotation (Icon(graphics={
    Line(points={{-44,90},{-44,40}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-104,70},{-74,90}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-104,50},{-74,70}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-104,30},{-74,50}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-104,10},{-74,30}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60,20},{-30,40}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60,0},{-30,20}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60,-20},{-30,0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60,-40},{-30,-20}}),
    Line(points={{-16,-10},{-16,-90},{104,-90},{104,-10},{74,-10},{74,-90},{14,
              -90},{14,-10},{-16,-10},{-16,-30},{104,-30},{104,-50},{-16,-50},{
              -16,-70},{104,-70},{104,-90},{-16,-90},{-16,-10},{104,-10},{104,
              -90}}),
    Line(points={{44,-10},{44,-90}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-16,-30},{14,-10}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-16,-50},{14,-30}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-16,-70},{14,-50}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-16,-90},{14,-70}}),
    Line(points={{-14,90},{-14,40}}),
    Line(points={{14,90},{14,40}}),
    Line(points={{-74,90},{14,90}}),
    Line(points={{30,40},{30,-10}}),
    Line(points={{-74,70},{14,70}}),
    Line(points={{-74,50},{14,50}}),
    Line(points={{-74,30},{-60,30}}),
    Line(points={{-74,10},{-60,10}}),
    Line(points={{-30,-20},{-16,-20}}),
    Line(points={{-30,-40},{-16,-40}}),
    Line(points={{-30,40},{14,40}}),
    Line(points={{0,40},{0,-10}}),
    Line(points={{58,40},{58,-10}}),
    Line(points={{-30,40},{58,40}}),
    Line(points={{-30,20},{58,20}}),
    Line(points={{-30,0},{58,0}})}), Documentation(revisions="<html>
<ul>
<li>
March 21, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model serves as a wrapper class to integrate the block
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep</a>
into heat pump models.
For a complete description of all modeling assumptions, 
please refer to the documentation of this block.
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-120},{140,120}})));
end TableData2DLoadDep;
