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
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal
    "Heating heat flow rate - All modules"
    annotation (Dialog(group="Nominal condition - Heating"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal
    "Cooling heat flow rate - All modules"
    annotation (Dialog(group="Nominal condition - Cooling"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaShc_flow_nominal
    "Heating heat flow rate - All modules"
    annotation (Dialog(group="Nominal condition - SHC"));
  parameter Modelica.Units.SI.HeatFlowRate QCooShc_flow_nominal
    "Cooling heat flow rate - All modules"
    annotation (Dialog(group="Nominal condition - SHC"));
  parameter Modelica.Units.SI.Temperature TConCoo_nominal
    "CHW temperature: leaving if dat.use_TEvaOutForTab=true, entering otherwise"
    annotation (Dialog(group="Nominal condition - Cooling"));
  parameter Modelica.Units.SI.Temperature TEvaCoo_nominal
    "Condenser cooling fluid temperature: leaving if dat.use_TAmbOutForTab=true, entering otherwise"
    annotation (Dialog(group="Nominal condition - Cooling"));
  replaceable parameter Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDepSHC.Generic dat
    "Record with performance data"
    annotation (choicesAllMatching=true);
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cp[2](
    k={cpEva, cpCon})
    "Specific heat capacity"
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  BaseClasses.TableData2DLoadDepSHC calQUseP(
    final nUni=nUni,
    final use_TLoaLvgForCtl=use_TLoaLvgForCtl,
    final use_TEvaOutForTab=dat.use_TEvaOutForTab,
    final use_TConOutForTab=dat.use_TConOutForTab,
    final PLRHeaSup=dat.PLRHeaSup,
    final PLRCooSup=dat.PLRCooSup,
    final PLRShcSup=dat.PLRShcSup,
    final fileNameHea=dat.fileNameHea,
    final fileNameCoo=dat.fileNameCoo,
    final fileNameShc=dat.fileNameShc,
    final tabNamQHea=dat.tabNamQHea,
    final tabNamPHea=dat.tabNamPHea,
    final tabNamQCoo=dat.tabNamQCoo,
    final tabNamPCoo=dat.tabNamPCoo,
    final tabNamQShc=dat.tabNamQShc,
    final tabNamPShc=dat.tabNamPShc,
    final THw_nominal=TCon_nominal,
    final TChw_nominal=TConCoo_nominal,
    final TAmbHea_nominal=TEva_nominal,
    final QHea_flow_nominal=QHea_flow_nominal,
    final TAmbCoo_nominal=TEvaCoo_nominal,
    final QCoo_flow_nominal=QCoo_flow_nominal,
    final QHeaShc_flow_nominal=QHeaShc_flow_nominal,
    final QCooShc_flow_nominal=QCooShc_flow_nominal)
    "Compute heat flow rate and input power"
    annotation (Placement(transformation(extent={{90,24},{110,56}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cst(final k=0) "Constant"
    annotation (Placement(transformation(extent={{-136,-30},{-116,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Add addQEvaQCon "Add QEva_flow to QCon_flow"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-60})));
equation
  connect(cp[1].y, calQUseP.cpChw) annotation (Line(points={{72,100},{80,100},{80,
          28},{88,28}}, color={0,0,127}));
  connect(cp[2].y, calQUseP.cpHw) annotation (Line(points={{72,100},{80,100},{80,
          36},{88,36}}, color={0,0,127}));
  connect(sigBus.THwSet, calQUseP.THwSet) annotation (Line(
      points={{1,120},{0,120},{0,50},{88,50}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.TChwSet, calQUseP.TChwSet) annotation (Line(
      points={{1,120},{0,120},{0,48},{88,48}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.TAmbInMea, calQUseP.TAmbEnt) annotation (Line(
      points={{1,120},{0,120},{0,46},{88,46}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.TConInMea, calQUseP.THwEnt) annotation (Line(
      points={{1,120},{0,120},{0,42},{88,42}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.TConOutMea, calQUseP.THwLvg) annotation (Line(
      points={{1,120},{0,120},{0,40},{88,40}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.mConMea_flow, calQUseP.mHw_flow) annotation (Line(
      points={{1,120},{0,120},{0,38},{88,38}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.TEvaInMea, calQUseP.TChwEnt) annotation (Line(
      points={{1,120},{0,120},{0,34},{88,34}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.TEvaOutMea, calQUseP.TChwLvg) annotation (Line(
      points={{1,120},{0,120},{0,32},{88,32}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.mEvaMea_flow, calQUseP.mChw_flow) annotation (Line(
      points={{1,120},{0,120},{0,30},{88,30}},
      color={255,204,51},
      thickness=0.5));
  connect(calQUseP.QCoo_flow, feeHeaFloEva.u1) annotation (Line(points={{112,50},
          {120,50},{120,0},{-90,0},{-90,-10},{-78,-10}}, color={0,0,127}));
  connect(calQUseP.P, PEle) annotation (Line(points={{112,42},{116,42},{116,4},{
          0,4},{0,-130}}, color={0,0,127}));
  connect(cst.y, feeHeaFloEva.u2) annotation (Line(points={{-114,-20},{-70,-20},
          {-70,-18}}, color={0,0,127}));
  connect(proRedQEva.y, addQEvaQCon.u2) annotation (Line(points={{-30,-101},{-30,
          -108},{2,-108},{2,-66},{28,-66}}, color={0,0,127}));
  connect(addQEvaQCon.y, redQCon.u2)
    annotation (Line(points={{52,-60},{64,-60},{64,-78}}, color={0,0,127}));
  connect(calQUseP.QHea_flow, addQEvaQCon.u1) annotation (Line(points={{112,54},
          {124,54},{124,-4},{20,-4},{20,-54},{28,-54}}, color={0,0,127}));
  connect(sigBus.onOffMea, calQUseP.on) annotation (Line(
      points={{1,120},{0,120},{0,54},{88,54}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.mode, calQUseP.mode) annotation (Line(
      points={{1,120},{0,120},{0,52},{88,52}},
      color={255,204,51},
      thickness=0.5));
  connect(calQUseP.QAmb_flow, sigBus.QAmb_flow) annotation (Line(points={{112,46},
          {126,46},{126,118},{2,118},{2,120},{1,120}}, color={0,0,127}));
  connect(calQUseP.nUniHea, sigBus.nUniHea) annotation (Line(points={{112,34},{128,
          34},{128,120},{1,120}}, color={255,127,0}));
  connect(calQUseP.nUniCoo, sigBus.nUniCoo) annotation (Line(points={{112,30},{130,
          30},{130,120},{1,120}}, color={255,127,0}));
  connect(calQUseP.nUniShc, sigBus.nUniShc) annotation (Line(points={{112,26},{132,
          26},{132,120},{1,120}}, color={255,127,0}));
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
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC</a>
into heat pump models.
For a complete description of all modeling assumptions, 
please refer to the documentation of this latter block.
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-120},{140,120}}, grid={2,2})));
end TableData2DLoadDepSHC;
