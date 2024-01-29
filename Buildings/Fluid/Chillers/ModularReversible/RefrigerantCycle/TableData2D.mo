within Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle;
model TableData2D
  "Performance data based on condenser outlet and evaporator inlet temperature"
  extends
    Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle(
    final datSou=datTab.devIde,
    mEva_flow_nominal=datTab.mEva_flow_nominal*scaFac,
    mCon_flow_nominal=datTab.mCon_flow_nominal*scaFac,
    PEle_nominal=Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
        tabIdePEle,
        TEva_nominal,
        TCon_nominal) * scaFac * y_nominal,
    QCooNoSca_flow_nominal=
        Modelica.Blocks.Tables.Internal.getTable2DValueNoDer2(
        tabIdeQUse_flow,
        TEva_nominal,
        TCon_nominal) * y_nominal);
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialTableData2D(
    final use_TConOutForTab=datTab.use_TConOutForTab,
    final use_TEvaOutForTab=datTab.use_TEvaOutForTab,
    tabQUse_flow(final table=datTab.tabQEva_flow),
    tabPEle(final table=datTab.tabPEle),
    final valTabQEva_flow = {{-tabQUse_flow.table[j, i] for i in 2:numCol} for j in 2:numRow},
    final valTabQCon_flow = valTabQEva_flow .+ valTabPEle,
    final mCon_flow_nominal_internal=mCon_flow_nominal,
    final mEva_flow_nominal_internal=mEva_flow_nominal,
    final mCon_flow_max=max(valTabQCon_flow) * scaFac / cpCon / dTMin,
    final mCon_flow_min=min(valTabQCon_flow) * scaFac / cpCon / dTMax,
    final mEva_flow_min=min(valTabQEva_flow) * scaFac / cpCon / dTMax,
    final mEva_flow_max=max(valTabQEva_flow) * scaFac / cpCon / dTMin,
    constScaFac(final k=scaFac));
  replaceable parameter Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic datTab
    "Data Table of Chiller" annotation (choicesAllMatching=true);

equation

  connect(scaFacTimPel.y, PEle) annotation (Line(points={{-40,-9},{-40,-26},{-30,
          -26},{-30,-94},{0,-94},{0,-130}}, color={0,0,127}));
  connect(scaFacTimPel.y, redQCon.u2) annotation (Line(points={{-40,-9},{-40,-26},
          {-30,-26},{-30,-48},{64,-48},{64,-78}}, color={0,0,127}));
  connect(scaFacTimQUse_flow.y, proRedQEva.u2) annotation (Line(points={{40,-9},{
          40,-40},{-24,-40},{-24,-78}},  color={0,0,127}));
  connect(ySetTimScaFac.u1, sigBus.ySet) annotation (Line(points={{-54,62},{-54,
          72},{-70,72},{-70,120},{1,120}},   color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(reaPasThrTEvaOut.u, sigBus.TEvaOutMea) annotation (Line(points={{-10,102},
          {-10,120},{1,120}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(reaPasThrTEvaIn.u, sigBus.TEvaInMea) annotation (Line(points={{-50,102},
          {-50,120},{1,120}},                 color={0,0,127}), Text(
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
          {90,120},{1,120}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(scaFacTimPel.y, calEER.PEle) annotation (Line(points={{-40,-9},{-40,-70},
          {-80,-70},{-80,-86},{-88,-86}},                     color={0,0,127}));

  if useInChi then
    connect(reaPasThrTConOut.y, tabPEle.u2)
      annotation (Line(points={{90,79},{90,70},{84,70},{84,62}}, color={0,0,127}));
    connect(reaPasThrTConIn.y, tabPEle.u2)
      annotation (Line(points={{50,79},{50,70},{84,70},{84,62}}, color={0,0,127}));
    connect(reaPasThrTConIn.y, tabQUse_flow.u2)
      annotation (Line(points={{50,79},{50,70},{44,70},{44,62}}, color={0,0,127}));
    connect(reaPasThrTConOut.y, tabQUse_flow.u2)
      annotation (Line(points={{90,79},{90,70},{44,70},{44,62}}, color={0,0,127}));
    connect(reaPasThrTEvaOut.y, tabQUse_flow.u1) annotation (Line(points={{-10,79},
            {-10,70},{56,70},{56,62}},color={0,0,127}));
    connect(reaPasThrTEvaIn.y, tabQUse_flow.u1) annotation (Line(points={{-50,79},
            {-50,70},{56,70},{56,62}},
                                  color={0,0,127}));
    connect(reaPasThrTEvaOut.y, tabPEle.u1) annotation (Line(points={{-10,79},{
            -10,70},{96,70},{96,62}},
                              color={0,0,127}));
    connect(reaPasThrTEvaIn.y, tabPEle.u1) annotation (Line(points={{-50,79},{-50,
            70},{96,70},{96,62}},
                                color={0,0,127}));
  else
    connect(reaPasThrTConOut.y, tabPEle.u1)
      annotation (Line(points={{90,79},{90,70},{96,70},{96,62}}, color={0,0,127}));
    connect(reaPasThrTConOut.y, tabQUse_flow.u1)
      annotation (Line(points={{90,79},{90,70},{56,70},{56,62}}, color={0,0,127}));
    connect(reaPasThrTConIn.y, tabQUse_flow.u1)
      annotation (Line(points={{50,79},{50,70},{56,70},{56,62}}, color={0,0,127}));
    connect(reaPasThrTConIn.y, tabPEle.u1)
      annotation (Line(points={{50,79},{50,70},{96,70},{96,62}}, color={0,0,127}));
    connect(reaPasThrTEvaOut.y, tabPEle.u2) annotation (Line(points={{-10,79},{
            -10,70},{84,70},{84,62}},         color={0,0,127}));
    connect(reaPasThrTEvaOut.y, tabQUse_flow.u2) annotation (Line(points={{-10,79},
            {-10,70},{44,70},{44,62}},                color={0,0,127}));
    connect(reaPasThrTEvaIn.y, tabQUse_flow.u2) annotation (Line(points={{-50,79},
            {-50,70},{44,70},{44,62}},            color={0,0,127}));
    connect(reaPasThrTEvaIn.y, tabPEle.u2) annotation (Line(points={{-50,79},{-50,
            70},{84,70},{84,62}},             color={0,0,127}));
  end if;
  annotation (Icon(graphics={
    Line(points={{-60.0,40.0},{-60.0,-40.0},{60.0,-40.0},{60.0,40.0},
      {30.0,40.0},{30.0,-40.0},{-30.0,-40.0},{-30.0,40.0},{-60.0,40.0},
      {-60.0,20.0},{60.0,20.0},{60.0,0.0},{-60.0,0.0},{-60.0,-20.0},
      {60.0,-20.0},{60.0,-40.0},{-60.0,-40.0},{-60.0,40.0},{60.0,40.0},
      {60.0,-40.0}}),
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
      extent={{-60.0,-40.0},{-30.0,-20.0}})}), Documentation(revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on the discussion in this issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>May 22, 2019,</i> by Julian Matthes:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">AixLib #715</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This model uses two-dimensional table data typically given
  by manufacturers as required by e.g. European Norm 14511
  or ASHRAE 205 to calculate
  <code>QEva_flow</code> and <code>PEle</code>.
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
For the scaling factor, the table data for evaporator heat flow rate
is evaluated at nominal conditions. Then, the table data is scaled linearly.
This implies a constant COP over different design sizes:
<p><code>QEva_flow = scaFac * tabQEva_flow.y</code> </p>
<p><code>PEle = scaFac * tabPel.y</code>


<h4>Known Limitations </h4>
<ul>
<li>
  Manufacturers are not required to provide the compressor speed at which
  the data are measured. Thus, nominal values may be obtained at different
  compressor speeds and, thus, efficiencies.
  To accurately model the available thermal output,
  please check that you use tables of the maximal thermal output,
  which is often provided in the data sheets from the manufacturers.
  This limitation only holds for inverter driven chillers.
</li>
<li>
  We assume that the efficiency is contant over the whole
  compressor speed range. Typically, efficiencies will drop at minimal
  and maximal compressor speeds.
  To model an inverter controlled chiller, the relative
  compressor speed <code>ySet</code> is used to scale
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
