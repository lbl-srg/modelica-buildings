within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle;
model TableData2D "Performance data based on condenser outlet and evaporator inlet temperature"
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle(
    final devIde=datTab.devIde,
    PEle_nominal=Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
        tabIdePEle,
        TCon_nominal,
        TEva_nominal) * scaFac);
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialTableData2D(
    final useInRevDev=not useInHeaPum,
    scaFac=QHea_flow_nominal/QHeaNoSca_flow_nominal,
    final valTabQEva_flow = valTabQCon_flow .- valTabPEle,
    final valTabQCon_flow = {{tabQUse_flow.table[j, i] for i in 2:numCol} for j in 2:numRow},
    final mCon_flow_max=max(valTabQCon_flow) * scaFac / cpCon / dTMin,
    final mCon_flow_min=min(valTabQCon_flow) * scaFac / cpCon / dTMax,
    final mEva_flow_min=min(valTabQEva_flow) * scaFac / cpEva / dTMax,
    final mEva_flow_max=max(valTabQEva_flow) * scaFac / cpEva / dTMin,
    mEva_flow_nominal=datTab.mEva_flow_nominal*scaFac,
    mCon_flow_nominal=datTab.mCon_flow_nominal*scaFac,
    final use_TConOutForTab=datTab.use_TConOutForTab,
    final use_TEvaOutForTab=datTab.use_TEvaOutForTab,
    tabQUse_flow(final table=datTab.tabQCon_flow),
    tabPEle(final table=datTab.tabPEle));
  parameter Modelica.Units.SI.HeatFlowRate QHeaNoSca_flow_nominal=Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
        tabIdeQUse_flow,
        TCon_nominal,
        TEva_nominal)
    "Unscaled nominal heating capacity "
    annotation (Dialog(group="Nominal condition"));

  replaceable parameter Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump datTab
    "Data Table of HP" annotation (choicesAllMatching=true);

equation

  connect(scaFacTimPel.y, PEle) annotation (Line(points={{-40,-9},{-40,-24},{0,
          -24},{0,-130}}, color={0,0,127}));
  connect(scaFacTimPel.y, redQCon.u2) annotation (Line(points={{-40,-9},{-40,-24},
          {64,-24},{64,-78}}, color={0,0,127}));
  connect(yMeaTimScaFac.u1, sigBus.yMea) annotation (Line(points={{-54,62},{-54,
          74},{-70,74},{-70,120},{1,120}},
                               color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrTEvaOut.u, sigBus.TEvaOutMea) annotation (Line(points={{-10,102},
          {-10,120},{1,120}},      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrTEvaIn.u, sigBus.TEvaInMea) annotation (Line(points={{-50,102},
          {-50,120},{1,120}},                      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrTConIn.u, sigBus.TConInMea) annotation (Line(points={{50,102},
          {50,120},{1,120}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrTConOut.u, sigBus.TConOutMea) annotation (Line(points={{90,102},
          {90,120},{1,120}},      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  if useInHeaPum then
    connect(reaPasThrTConOut.y, tabPEle.u1)
      annotation (Line(points={{90,79},{90,70},{96,70},{96,62}}, color={0,0,127}));
    connect(reaPasThrTConIn.y, tabPEle.u1)
      annotation (Line(points={{50,79},{50,70},{96,70},{96,62}}, color={0,0,127}));
    connect(reaPasThrTConIn.y, tabQUse_flow.u1)
      annotation (Line(points={{50,79},{50,70},{56,70},{56,62}}, color={0,0,127}));
    connect(reaPasThrTConOut.y, tabQUse_flow.u1)
      annotation (Line(points={{90,79},{90,70},{56,70},{56,62}}, color={0,0,127}));
    connect(reaPasThrTEvaOut.y, tabPEle.u2) annotation (Line(points={{-10,79},{
            -10,70},{84,70},{84,62}},
                              color={0,0,127}));
    connect(reaPasThrTEvaOut.y, tabQUse_flow.u2) annotation (Line(points={{-10,79},
            {-10,70},{44,70},{44,62}},color={0,0,127}));
    connect(reaPasThrTEvaIn.y, tabPEle.u2) annotation (Line(points={{-50,79},{-50,
            70},{84,70},{84,62}},
                              color={0,0,127}));
    connect(reaPasThrTEvaIn.y, tabQUse_flow.u2) annotation (Line(points={{-50,79},
            {-50,70},{44,70},{44,62}},
                                  color={0,0,127}));
  else
    connect(reaPasThrTEvaOut.y, tabPEle.u1) annotation (Line(points={{-10,79},{
            -10,70},{96,70},{96,62}},         color={0,0,127}));
    connect(reaPasThrTEvaOut.y, tabQUse_flow.u1) annotation (Line(points={{-10,79},
            {-10,70},{56,70},{56,62}},                color={0,0,127}));
    connect(reaPasThrTEvaIn.y, tabPEle.u1) annotation (Line(points={{-50,79},{-50,
            70},{96,70},{96,62}},             color={0,0,127}));
    connect(reaPasThrTEvaIn.y, tabQUse_flow.u1) annotation (Line(points={{-50,79},
            {-50,70},{56,70},{56,62}},            color={0,0,127}));
    connect(reaPasThrTConOut.y, tabPEle.u2)
      annotation (Line(points={{90,79},{90,70},{84,70},{84,62}}, color={0,0,127}));
    connect(reaPasThrTConOut.y, tabQUse_flow.u2)
      annotation (Line(points={{90,79},{90,70},{44,70},{44,62}}, color={0,0,127}));
    connect(reaPasThrTConIn.y, tabPEle.u2)
      annotation (Line(points={{50,79},{50,70},{84,70},{84,62}}, color={0,0,127}));
    connect(reaPasThrTConIn.y, tabQUse_flow.u2)
      annotation (Line(points={{50,79},{50,70},{44,70},{44,62}}, color={0,0,127}));
  end if;
  connect(scaFacTimPel.y, feeHeaFloEva.u1) annotation (Line(points={{-40,-9},{-40,
          -24},{-86,-24},{-86,-10},{-78,-10}}, color={0,0,127}));
  connect(scaFacTimQUse_flow.y, feeHeaFloEva.u2) annotation (Line(points={{40,-9},
          {40,-26},{-70,-26},{-70,-18}}, color={0,0,127}));
  annotation (Icon(graphics={
    Line(points={
          {-60.0,40.0},{-60.0,-40.0},{60.0,-40.0},{60.0,40.0},{30.0,40.0},
          {30.0,-40.0},{-30.0,-40.0},{-30.0,40.0},{-60.0,40.0},{-60.0,20.0},
          {60.0,20.0},{60.0,0.0},{-60.0,0.0},{-60.0,-20.0},{60.0,-20.0},
          {60.0,-40.0},{-60.0,-40.0},{-60.0,40.0},{60.0,40.0},{60.0,-40.0}}),
    Line(points={{0.0,40.0},{0.0,-40.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,20.0},{-30.0,40.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,0.0},{-30.0,20.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,-20.0},{-30.0,0.0}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-60.0,-40.0},{-30.0,-20.0}})}), Documentation(revisions="<html>
<ul>
  <li>
    <i>May 21, 2021</i> by Fabian Wuellhorst:<br/>
    Make use of BaseClasses (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/1092\">AixLib #1092</a>)
  </li>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This model uses two-dimensional table data typically given
  by manufacturers as required by e.g. European Norm 14511
  or ASHRAE 205 to calculate
  <code>QCon_flow</code> and <code>PEle</code>.
</p>
<p>
  For different condenser outlet and evaporator inlet temperatures,
  the tables must provide two of the three following values:
  electrical power consumption, evaporator heat flow rate, and COP.
</p>
<p>
  Note that losses are often implicitly included in measured data.
  In this case, the frosting modules should be disabled.
</p>

<h4>Scaling factor</h4>
<p>
For the scaling factor, the table data for condenser heat flow rate
is evaluated at nominal conditions. Then, the table data is scaled linearly.
This implies a constant COP over different design sizes:
</p>
<p><code>QCon_flow = scaFac * tabQCon_flow.y</code> </p>
<p><code>PEle = scaFac * tabPel.y</code></p>


<h4>Known Limitations </h4>
<ul>
<li>
  Manufacturers are not required to provide the compressor speed at which
  the data are measured. Thus, nominal values may be obtained at different
  compressor speeds and, thus, efficiencies.
  To accurately model the available thermal output,
  please check that you use tables of the maximal thermal output,
  which is often provided in the data sheets from the manufacturers.
  This limitation only holds for inverter driven heat pumps.
</li>
<li>
  We assume that the efficiency is contant over the whole
  compressor speed range. Typically, effciencies will drop at minimal
  and maximal compressor speeds.
  To model an inverter controlled heat pump, the relative
  compressor speed <code>yMea</code> is used to scale
  the ouput of the tables linearly.
  For models including the compressor speed, check the SDF-Library
  dependent refrigerant cycle models in the
  <a href=\"https://github.com/RWTH-EBC/AixLib\">AixLib</a>.
</li>
</ul>
<h4>References</h4>
<p>
EN 14511-2018: Air conditioners, liquid chilling packages and heat pumps for space
heating and cooling and process chillers, with electrically driven compressors
<a href=\"https://www.beuth.de/de/norm/din-en-14511-1/298537524\">
https://www.beuth.de/de/norm/din-en-14511-1/298537524</a>
</p>

</html>"));
end TableData2D;
