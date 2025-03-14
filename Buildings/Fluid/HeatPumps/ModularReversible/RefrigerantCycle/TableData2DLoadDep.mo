within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle;
model TableData2DLoadDep
  "Data-based model dependent on condenser and evaporator entering or leaving temperarure and PLR"
  extends Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle(
    final devIde=dat.devIde,
    PEle_nominal=calQUseP.P_nominal * scaFac);
  final parameter Real scaFac=QHea_flow_nominal / calQUseP.Q_flow_nominal
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
      origin={90,30})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cp[2](
    k={cpEva, cpCon})
    "Specific heat capacity"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extBusSig[6](
    each final nin=2)
    "Extract bus signals depending on application"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={70,80})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[2](
    k={1, 2})
    "Constants"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Selection index: 1 to use evaporator as load side, 2 to use condenser"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    nout=6)
    "Replicate selection index"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant use_inHp(
    final k=useInHeaPum)
    "Constant Boolean"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
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
    annotation (Line(points={{42,100},{69.5,100},{69.5,92}},color={0,0,127}));
  connect(cp[2].y, extBusSig[6].u[2])
    annotation (Line(points={{42,100},{70.5,100},{70.5,92}},color={0,0,127}));
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
  connect(calQUseP.PLR, sigBus.PLRHea)
    annotation (Line(points={{96,18},{96,10},{110,10},{110,120},{1,120}},color={0,0,127}));
  connect(sigBus.yMea, calQUseP.yMea)
    annotation (Line(points={{1,120},{90,120},{90,80},{93,80},{93,42}},color={255,204,51},thickness=0.5));
  connect(calQUseP.P, feeHeaFloEva.u1)
    annotation (Line(points={{84,18},{84,0},{-82,0},{-82,-10},{-78,-10}},color={0,0,127}));
  connect(calQUseP.P, PEle)
    annotation (Line(points={{84,18},{84,0},{0,0},{0,-130}},color={0,0,127}));
  connect(calQUseP.Q_flow, feeHeaFloEva.u2)
    annotation (Line(points={{90,18},{90,10},{-92,10},{-92,-22},{-70,-22},{-70,-18}},
      color={0,0,127}));
  connect(calQUseP.P, redQCon.u2)
    annotation (Line(points={{84,18},{84,0},{64,0},{64,-78}},color={0,0,127}));
  connect(intScaRep.y, extBusSig.index)
    annotation (Line(points={{42,60},{50,60},{50,80},{58,80}},color={255,127,0}));
  connect(intSwi.y, intScaRep.u)
    annotation (Line(points={{12,60},{18,60}},color={255,127,0}));
  connect(use_inHp.y, intSwi.u2)
    annotation (Line(points={{-28,60},{-12,60}},color={255,0,255}));
  connect(cst[1].y, intSwi.u3)
    annotation (Line(points={{-28,30},{-20,30},{-20,52},{-12,52}},color={255,127,0}));
  connect(cst[2].y, intSwi.u1)
    annotation (Line(points={{-28,30},{-20,30},{-20,68},{-12,68}},color={255,127,0}));
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
</html>"));
end TableData2DLoadDep;
