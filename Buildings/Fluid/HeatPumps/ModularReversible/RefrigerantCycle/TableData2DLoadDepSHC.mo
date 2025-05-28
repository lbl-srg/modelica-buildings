within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle;
model TableData2DLoadDepSHC
  "Data-based model dependent on condenser and evaporator entering or leaving temperarure and PLR"
  extends Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle(
    final devIde=dat.devIde,
    final useInHeaPum=true,
    PEle_nominal=calQUseP.P_nominal,
    redeclare final
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting iceFacCal);
  parameter Integer nUni(min=1)=1
    "Number of modules";
  parameter Boolean use_TLoaLvgForCtl=true
    "Set to true for leaving temperature control, false for entering temperature control"
    annotation (Evaluate=true);
  parameter Boolean use_TEvaOutForTab=dat.use_TEvaOutForTab
    "=true to use CHW temperature at outlet for table data, false for inlet";
  parameter Boolean use_TConOutForTab=dat.use_TConOutForTab
    "=true to use HW temperature at outlet for table data, false for inlet";
  parameter Boolean use_TAmbOutForTab
    "=true to use ambient fluid temperature at outlet for table data, false for inlet";

  replaceable parameter Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.GenericHeatPump dat
    "Table with performance data"
    annotation (choicesAllMatching=true);
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cp[2](
    k={cpEva, cpCon})
    "Specific heat capacity"
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndHea
    "True if enabled in heating mode"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  BaseClasses.TableData2DLoadDepSHC calQUseP(
    final use_TLoaLvgForCtl=use_TLoaLvgForCtl,
    final use_TEvaOutForTab=use_TEvaOutForTab,
    final use_TConOutForTab=use_TConOutForTab,
    final use_TAmbOutForTab=use_TAmbOutForTab,
    final PLRHeaSup=dat.PLRHeaSup,
    final PLRCooSup=dat.PLRCooSup,
    final PLRShcSup=PLRShcSup,
    fileNameHea=dat.fileNameHea,
    fileNameCoo=dat.fileNameCoo,
    fileNameShc=dat.fileNameShc,
    THw_nominal=dat.THw_nominal,
    TChw_nominal=dat.TChw_nominal,
    TAmbHea_nominal=dat.TAmbHea_nominal,
    QHea_flow_nominal=dat.QHea_flow_nominal,
    TAmbCoo_nominal=dat.TAmbCoo_nominal,
    QCoo_flow_nominal=dat.QCoo_flow_nominal,
    QHeaShc_flow_nominal=dat.QHeaShc_flow_nominal,
    QCooShc_flow_nominal=dat.QCooShc_flow_nominal)
    "Compute heat flow rate and input power"
    annotation (Placement(transformation(extent={{90,24},{110,56}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isHea "True if mode is Heating"
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxMod[3](final k=
        Integer({Buildings.Fluid.HeatPumps.Types.OperatingMode.Heating,
        Buildings.Fluid.HeatPumps.Types.OperatingMode.Cooling,Buildings.Fluid.HeatPumps.Types.OperatingMode.SHC}))
    "Mode index"
    annotation (Placement(transformation(extent={{-136,30},{-116,50}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndHCoo
    "True if enabled in cooling mode"
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isCoo "True if mode is Cooling"
    annotation (Placement(transformation(extent={{-70,36},{-50,56}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndShc "True if enabled in SHC mode"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isShc "True if mode is SHC"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndHeaOrShc
    "True if enabled in heating or SHC mode"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndCooOrShc
    "True if enabled in cooling or SHC mode"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cst(final k=0) "Constant"
    annotation (Placement(transformation(extent={{-136,-30},{-116,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Add addQEvaQCon "Add QEva_flow to QCon_flow"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-60})));
equation
  connect(sigBus.onOffMea, onAndHea.u1) annotation (Line(
      points={{1,120},{-40,120},{-40,80},{-32,80}},
      color={255,204,51},
      thickness=0.5));
  connect(cp[1].y, calQUseP.cpChw) annotation (Line(points={{72,100},{80,100},{80,
          26},{88,26}}, color={0,0,127}));
  connect(cp[2].y, calQUseP.cpHw) annotation (Line(points={{72,100},{80,100},{80,
          34},{88,34}}, color={0,0,127}));
  connect(sigBus.mode, isHea.u1) annotation (Line(
      points={{1,120},{-80,120},{-80,80},{-72,80}},
      color={255,204,51},
      thickness=0.5));
  connect(idxMod[1].y, isHea.u2) annotation (Line(points={{-114,40},{-100,40},{-100,
          72},{-72,72}}, color={255,127,0}));
  connect(isHea.y, onAndHea.u2) annotation (Line(points={{-48,80},{-44,80},{-44,
          72},{-32,72}}, color={255,0,255}));
  connect(sigBus.onOffMea, onAndHCoo.u1) annotation (Line(
      points={{1,120},{-40,120},{-40,50},{-32,50}},
      color={255,204,51},
      thickness=0.5));
  connect(idxMod[2].y, isCoo.u2) annotation (Line(points={{-114,40},{-100,40},{-100,
          38},{-72,38}}, color={255,127,0}));
  connect(sigBus.mode, isCoo.u1) annotation (Line(
      points={{1,120},{-80,120},{-80,46},{-72,46}},
      color={255,204,51},
      thickness=0.5));
  connect(isCoo.y, onAndHCoo.u2) annotation (Line(points={{-48,46},{-44,46},{-44,
          42},{-32,42}}, color={255,0,255}));
  connect(isShc.y, onAndShc.u2) annotation (Line(points={{-48,20},{-44,20},{-44,
          12},{-32,12}}, color={255,0,255}));
  connect(sigBus.onOffMea, onAndShc.u1) annotation (Line(
      points={{1,120},{-40,120},{-40,20},{-32,20}},
      color={255,204,51},
      thickness=0.5));
  connect(idxMod[3].y, isShc.u2) annotation (Line(points={{-114,40},{-100,40},{-100,
          12},{-72,12}}, color={255,127,0}));
  connect(sigBus.mode, isShc.u1) annotation (Line(
      points={{1,120},{-80,120},{-80,20},{-72,20}},
      color={255,204,51},
      thickness=0.5));
  connect(onAndHea.y, onAndHeaOrShc.u1)
    annotation (Line(points={{-8,80},{8,80}}, color={255,0,255}));
  connect(onAndShc.y, onAndHeaOrShc.u2) annotation (Line(points={{-8,20},{0,20},
          {0,72},{8,72}}, color={255,0,255}));
  connect(onAndHCoo.y, onAndCooOrShc.u1) annotation (Line(points={{-8,50},{-4,50},
          {-4,40},{8,40}}, color={255,0,255}));
  connect(onAndShc.y, onAndCooOrShc.u2) annotation (Line(points={{-8,20},{0,20},
          {0,32},{8,32}}, color={255,0,255}));
  connect(onAndCooOrShc.y, calQUseP.onCoo) annotation (Line(points={{32,40},{36,
          40},{36,52},{88,52}}, color={255,0,255}));
  connect(onAndHeaOrShc.y, calQUseP.onHea) annotation (Line(points={{32,80},{38,
          80},{38,54},{88,54}}, color={255,0,255}));
  connect(sigBus.THwSet, calQUseP.THwSet) annotation (Line(
      points={{1,120},{40,120},{40,48},{88,48}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.TChwSet, calQUseP.TChwSet) annotation (Line(
      points={{1,120},{40,120},{40,46},{88,46}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.TAmbInMea, calQUseP.TAmbEnt) annotation (Line(
      points={{1,120},{40,120},{40,44},{88,44}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.TAmbOutMea, calQUseP.TAmbLvg) annotation (Line(
      points={{1,120},{40,120},{40,42},{88,42}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.TConInMea, calQUseP.THwEnt) annotation (Line(
      points={{1,120},{40,120},{40,40},{88,40}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.TConOutMea, calQUseP.THwLvg) annotation (Line(
      points={{1,120},{40,120},{40,38},{88,38}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.mConMea_flow, calQUseP.mHw_flow) annotation (Line(
      points={{1,120},{40,120},{40,36},{88,36}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.TEvaInMea, calQUseP.TChwEnt) annotation (Line(
      points={{1,120},{40,120},{40,32},{88,32}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.TEvaOutMea, calQUseP.TChwLvg) annotation (Line(
      points={{1,120},{40,120},{40,30},{88,30}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.mEvaMea_flow, calQUseP.mChw_flow) annotation (Line(
      points={{1,120},{40,120},{40,28},{88,28}},
      color={255,204,51},
      thickness=0.5));
  connect(calQUseP.QCoo_flow, feeHeaFloEva.u1) annotation (Line(points={{112,50},
          {120,50},{120,0},{-90,0},{-90,-10},{-78,-10}}, color={0,0,127}));
  connect(calQUseP.P, PEle) annotation (Line(points={{112,46},{116,46},{116,4},{
          0,4},{0,-130}}, color={0,0,127}));
  connect(cst.y, feeHeaFloEva.u2) annotation (Line(points={{-114,-20},{-70,-20},
          {-70,-18}}, color={0,0,127}));
  connect(proRedQEva.y, addQEvaQCon.u2) annotation (Line(points={{-30,-101},{-30,
          -108},{2,-108},{2,-66},{28,-66}}, color={0,0,127}));
  connect(addQEvaQCon.y, redQCon.u2)
    annotation (Line(points={{52,-60},{64,-60},{64,-78}}, color={0,0,127}));
  connect(calQUseP.QHea_flow, addQEvaQCon.u1) annotation (Line(points={{112,54},
          {124,54},{124,-4},{20,-4},{20,-54},{28,-54}}, color={0,0,127}));
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
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep</a>
into heat pump models.
For a complete description of all modeling assumptions, 
please refer to the documentation of this latter block.
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-120},{140,120}}, grid={2,2})));
end TableData2DLoadDepSHC;
