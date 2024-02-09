within Buildings.Templates.Components.HeatPumps.Controls;
block IdealModularReversibleTableData2D
  "Ideal controller for modular model of reversible heat pump with 2D table performance data"
  extends Buildings.Templates.Components.Interfaces.PartialHeatPumpModularController;
  replaceable Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D hea(
    final calEff=false)
    "Compute performance in heating mode"
    annotation (Placement(transformation(extent={{10,-36},{30,-16}})));
  Modelica.Blocks.Math.InverseBlockConstraints inverseBlockConstraints
    annotation (Placement(transformation(extent={{-4,-44},{42,-8}})));
  Modelica.Blocks.Sources.RealExpression QReqHea_flow(
    y(
      start=0,
      final unit="W",
      final min=0)=if (u1 and u1Hea) then max(0, dTFlo.y * hea.cpCon) else 0)
    "Required heating capacity"
    annotation (Placement(transformation(extent={{-40,-36},{-20,-16}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dT
    "DeltaT across load side heat exchanger"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply dTFlo
    "DeltaT times flow rate"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Modelica.Blocks.Routing.RealPassThrough TEvaInMea
    "Evaporator (source side) inlet temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={-40,80})));
  Modelica.Blocks.Routing.RealPassThrough TConInMea
    "Condenser (load side) inlet temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={-80,80})));
  Modelica.Blocks.Sources.RealExpression QReqCoo_flow(
    y(
      start=0,
      final unit="W",
      final min=0)=if (u1 and not u1Hea) then min(0, dTFlo.y * coo.cpEva) else 0)
    "Required cooling capacity"
    annotation (Placement(transformation(extent={{-40,-76},{-20,-56}})));
  replaceable Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D coo(
    final calEff=false)
    "Compute performance in cooling mode"
    annotation (Placement(transformation(extent={{10,-74},{30,-54}})));
  Modelica.Blocks.Math.InverseBlockConstraints inverseBlockConstraints1
    annotation (Placement(transformation(extent={{-4,-84},{42,-48}})));
  Buildings.Controls.OBC.CDL.Reals.Max maxHeaCoo
    "Maximum between heating and cooling signal"
    annotation (Placement(transformation(extent={{70,-56},{90,-36}})));
  Modelica.Blocks.Routing.RealPassThrough TEvaOutMea
    "Evaporator (source side) outlet temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={0,80})));
  Utilities.Math.SmoothLimit lim(
    deltaX=1E-3,
    final upper=1,
    final lower=0)
    "Limit output"
    annotation (Placement(transformation(extent={{100,-56},{120,-36}})));
  replaceable Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D heaMax(
    final dTEva_nominal=hea.dTEva_nominal,
    final calEff=hea.calEff,
    final TCon_nominal=hea.TCon_nominal,
    final dTCon_nominal=hea.dTCon_nominal,
    final scaFac=hea.scaFac,
    final y_nominal=hea.y_nominal,
    final useInHeaPum=hea.useInHeaPum,
    final extrapolation=hea.extrapolation,
    final TEva_nominal=hea.TEva_nominal,
    final QHeaNoSca_flow_nominal=hea.QHeaNoSca_flow_nominal,
    final mEva_flow_nominal=hea.mEva_flow_nominal,
    final cpEva=hea.cpEva,
    final cpCon=hea.cpCon,
    final PEle_nominal=hea.PEle_nominal,
    final QHea_flow_nominal=hea.QHea_flow_nominal,
    final datTab=hea.datTab,
    final smoothness=hea.smoothness,
    final mCon_flow_nominal=hea.mCon_flow_nominal)
    "Compute performance in heating mode at maximum compressor speed"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    k=1)
    "Constant"
    annotation (Placement(transformation(extent={{-150,-110},{-130,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));
  Modelica.Blocks.Sources.BooleanExpression enaHeaAndNoCapMar(
    y=u1 and u1Hea and not isCapMarHea.y)
    "Return true if heating enabled and required capacity unmet at current conditions"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  Modelica.Blocks.Routing.RealPassThrough TConOut
    "Condenser (load side) outlet temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={-120,80})));
  replaceable Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D cooMax(
    final dTEva_nominal=coo.dTEva_nominal,
    final calEff=coo.calEff,
    final TCon_nominal=coo.TCon_nominal,
    final dTCon_nominal=coo.dTCon_nominal,
    final scaFac=coo.scaFac,
    final y_nominal=coo.y_nominal,
    final extrapolation=coo.extrapolation,
    final TEva_nominal=coo.TEva_nominal,
    final QCooNoSca_flow_nominal=coo.QCooNoSca_flow_nominal,
    final mEva_flow_nominal=coo.mEva_flow_nominal,
    final cpEva=coo.cpEva,
    final cpCon=coo.cpCon,
    final PEle_nominal=coo.PEle_nominal,
    final QCoo_flow_nominal=coo.QCoo_flow_nominal,
    final datTab=coo.datTab,
    final smoothness=coo.smoothness,
    final useInChi=coo.useInChi,
    final mCon_flow_nominal=coo.mCon_flow_nominal)
    "Compute performance in cooling mode at maximum compressor speed"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  Modelica.Blocks.Sources.BooleanExpression enaCooAndNoCapMar(
    y=u1 and not u1Hea and not isCapMarCoo.y)
    "Return true if cooling enabled and required capacity unmet at current conditions"
    annotation (Placement(transformation(extent={{80,-170},{100,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaAndNoCapMar
    "Return true if cooling or heating enabled and required capacity unmet at current conditions"
    annotation (Placement(transformation(extent={{110,-130},{130,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis isCapMarHea(
    uLow=0,
    uHigh=1E2)
    "Return true if there is some capacity margin"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract capMarHea
    "Compute heating capacity margin: >0 means capacity reserve"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract capMarCoo
    "Compute cooling capacity margin: >0 means capacity reserve"
    annotation (Placement(transformation(extent={{0,-170},{20,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis isCapMarCoo(
    uLow=0,
    uHigh=1E2)
    "Return true if there is some capacity margin"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));
protected
  Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus busHea
    "Internal control bus for heating mode"
    annotation (Placement(transformation(extent={{0,-20},{40,20}}),
      iconTransformation(extent={{-20,80},{20,120}})));
  Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus busCoo
    "Internal control bus for cooling mode"
    annotation (Placement(transformation(extent={{40,-20},{80,20}}),
      iconTransformation(extent={{-20,80},{20,120}})));
  Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus busHeaMax
    "Internal control bus for heating mode"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
      iconTransformation(extent={{-20,80},{20,120}})));
  Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus busCooMax
    "Internal control bus for cooling mode"
    annotation (Placement(transformation(extent={{-80,-20},{-40,20}}),
      iconTransformation(extent={{-20,80},{20,120}})));
equation
  connect(hea.QCon_flow, inverseBlockConstraints.u2)
    annotation (Line(points={{13.3333,-36.8333},{13.3333,-40},{6,-40},{6,-26},{0.6,-26}},
      color={0,0,127}));
  connect(dT.y, dTFlo.u2)
    annotation (Line(points={{62,80},{70,80},{70,74},{88,74}},color={0,0,127}));
  connect(bus.mConMea_flow, dTFlo.u1)
    annotation (Line(points={{0,180},{0,100},{80,100},{80,86},{88,86}},color={255,204,51},thickness=0.5));
  connect(u1Hea, y1Hea)
    annotation (Line(points={{-180,80},{-150,80},{-150,120},{170,120},{170,80},{200,80}},
      color={255,0,255}));
  connect(hea.sigBus, busHea)
    annotation (Line(points={{20.0833,-16},{20,-16},{20,0}},color={255,204,51},thickness=0.5));
  connect(bus.TEvaInMea, TEvaInMea.u)
    annotation (Line(points={{0,180},{0,100},{-40,100},{-40,92}},color={255,204,51},thickness=0.5));
  connect(bus.TConInMea, TConInMea.u)
    annotation (Line(points={{0,180},{0,100},{-80,100},{-80,92}},color={255,204,51},thickness=0.5));
  connect(QReqCoo_flow.y, inverseBlockConstraints1.u1)
    annotation (Line(points={{-19,-66},{-6.3,-66}},color={0,0,127}));
  connect(inverseBlockConstraints.y1, maxHeaCoo.u1)
    annotation (Line(points={{43.15,-26},{50,-26},{50,-40},{68,-40}},color={0,0,127}));
  connect(inverseBlockConstraints1.y1, maxHeaCoo.u2)
    annotation (Line(points={{43.15,-66},{50,-66},{50,-52},{68,-52}},color={0,0,127}));
  connect(busCoo, coo.sigBus)
    annotation (Line(points={{60,0},{60,-54},{20.0833,-54}},color={255,204,51},thickness=0.5));
  connect(bus.TEvaOutMea, TEvaOutMea.u)
    annotation (Line(points={{0,180},{0,92}},color={255,204,51},thickness=0.5));
  connect(TEvaInMea.y, busHea.TEvaInMea)
    annotation (Line(points={{-40,69},{-40,40},{20,40},{20,0}},color={0,0,127}));
  connect(TConInMea.y, busCoo.TConInMea)
    annotation (Line(points={{-80,69},{-80,50},{60,50},{60,0}},color={0,0,127}));
  connect(QReqHea_flow.y, inverseBlockConstraints.u1)
    annotation (Line(points={{-19,-26},{-6.3,-26}},color={0,0,127}));
  connect(coo.QEva_flow, inverseBlockConstraints1.u2)
    annotation (Line(points={{26.6667,-74.8333},{26.6667,-80},{6,-80},{6,-66},{0.6,-66}},
      color={0,0,127}));
  connect(inverseBlockConstraints.y2, busHea.ySet)
    annotation (Line(points={{38.55,-26},{34,-26},{34,0},{20,0}},color={0,0,127}));
  connect(inverseBlockConstraints1.y2, busCoo.ySet)
    annotation (Line(points={{38.55,-66},{36,-66},{36,0},{60,0}},color={0,0,127}));
  connect(maxHeaCoo.y, lim.u)
    annotation (Line(points={{92,-46},{98,-46}},color={0,0,127}));
  connect(one.y, busHeaMax.ySet)
    annotation (Line(points={{-128,-100},{-120,-100},{-120,0},{-100,0}},color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{172,0},{200,0}},color={0,0,127}));
  connect(u1, y1)
    annotation (Line(points={{-180,160},{200,160}},color={255,0,255}));
  connect(TSupSet, TConOut.u)
    annotation (Line(points={{-180,0},{-140,0},{-140,100},{-120,100},{-120,92}},
      color={0,0,127}));
  connect(TConOut.y, dT.u1)
    annotation (Line(points={{-120,69},{-120,60},{20,60},{20,86},{38,86}},color={0,0,127}));
  connect(TConInMea.y, dT.u2)
    annotation (Line(points={{-80,69},{-80,50},{30,50},{30,74},{38,74}},color={0,0,127}));
  connect(TEvaInMea.y, busCoo.TEvaInMea)
    annotation (Line(points={{-40,69},{-40,40},{60,40},{60,0}},color={0,0,127}));
  connect(TConInMea.y, busHea.TConInMea)
    annotation (Line(points={{-80,69},{-80,50},{20,50},{20,0}},color={0,0,127}));
  connect(busHeaMax, heaMax.sigBus)
    annotation (Line(points={{-100,0},{-100,-16},{-100,-30},{-99.9167,-30}},
      color={255,204,51},thickness=0.5));
  connect(busCooMax, cooMax.sigBus)
    annotation (Line(points={{-60,0},{-60,-30},{-59.9167,-30}},color={255,204,51},thickness=0.5));
  connect(TConOut.y, busHeaMax.TConOutMea)
    annotation (Line(points={{-120,69},{-120,60},{-100,60},{-100,0}},color={0,0,127}));
  connect(TConOut.y, busCooMax.TConOutMea)
    annotation (Line(points={{-120,69},{-120,60},{-60,60},{-60,0}},color={0,0,127}));
  connect(TConOut.y, busCoo.TConOutMea)
    annotation (Line(points={{-120,69},{-120,60},{60,60},{60,0}},color={0,0,127}));
  connect(TConInMea.y, busHeaMax.TConInMea)
    annotation (Line(points={{-80,69},{-80,50},{-100,50},{-100,0}},color={0,0,127}));
  connect(TConInMea.y, busCooMax.TConInMea)
    annotation (Line(points={{-80,69},{-80,50},{-60,50},{-60,0}},color={0,0,127}));
  connect(TEvaInMea.y, busHeaMax.TEvaInMea)
    annotation (Line(points={{-40,69},{-40,40},{-100,40},{-100,0}},color={0,0,127}));
  connect(TEvaInMea.y, busCooMax.TEvaInMea)
    annotation (Line(points={{-40,69},{-40,40},{-60,40},{-60,0}},color={0,0,127}));
  connect(TEvaOutMea.y, busHeaMax.TEvaOutMea)
    annotation (Line(points={{0,69},{0,30},{-100,30},{-100,0}},color={0,0,127}));
  connect(TEvaOutMea.y, busCooMax.TEvaOutMea)
    annotation (Line(points={{0,69},{0,30},{-60,30},{-60,0}},color={0,0,127}));
  connect(TEvaOutMea.y, busHea.TEvaOutMea)
    annotation (Line(points={{0,69},{0,30},{20,30},{20,0}},color={0,0,127}));
  connect(TEvaOutMea.y, busCoo.TEvaOutMea)
    annotation (Line(points={{0,69},{0,30},{60,30},{60,0}},color={0,0,127}));
  connect(enaHeaAndNoCapMar.y, enaAndNoCapMar.u1)
    annotation (Line(points={{101,-120},{108,-120}},color={255,0,255}));
  connect(enaCooAndNoCapMar.y, enaAndNoCapMar.u2)
    annotation (Line(points={{101,-160},{104,-160},{104,-128},{108,-128}},color={255,0,255}));
  connect(enaAndNoCapMar.y, swi.u2)
    annotation (Line(points={{132,-120},{136,-120},{136,0},{148,0}},color={255,0,255}));
  connect(one.y, busCooMax.ySet)
    annotation (Line(points={{-128,-100},{-80,-100},{-80,0},{-60,0}},color={0,0,127}));
  connect(TConOut.y, busHea.TConOutMea)
    annotation (Line(points={{-120,69},{-120,60},{20,60},{20,0}},color={0,0,127}));
  connect(heaMax.QCon_flow, capMarHea.u1)
    annotation (Line(points={{-106.667,-50.8333},{-106.667,-114},{-2,-114}},
      color={0,0,127}));
  connect(QReqHea_flow.y, capMarHea.u2)
    annotation (Line(points={{-19,-26},{-12,-26},{-12,-126},{-2,-126}},color={0,0,127}));
  connect(QReqCoo_flow.y, capMarCoo.u1)
    annotation (Line(points={{-19,-66},{-16,-66},{-16,-154},{-2,-154}},color={0,0,127}));
  connect(cooMax.QEva_flow, capMarCoo.u2)
    annotation (Line(points={{-53.3333,-50.8333},{-53.3333,-166},{-2,-166}},
      color={0,0,127}));
  connect(capMarCoo.y, isCapMarCoo.u)
    annotation (Line(points={{22,-160},{38,-160}},color={0,0,127}));
  connect(capMarHea.y, isCapMarHea.u)
    annotation (Line(points={{22,-120},{38,-120}},color={0,0,127}));
  connect(lim.y, swi.u3)
    annotation (Line(points={{121,-46},{140,-46},{140,-8},{148,-8}},color={0,0,127}));
  connect(one.y, swi.u1)
    annotation (Line(points={{-128,-100},{132,-100},{132,8},{148,8}},color={0,0,127}));
  annotation (
    defaultComponentName="ctl",
    Documentation(
      info="<html>
<p>
FIXME: doc
</p>
</html>"));
end IdealModularReversibleTableData2D;
