within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety;
model Safety "Model including all safety levels"
  extends BaseClasses.PartialSafety;
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
    "Nominal mass flow rate in evaporator medium"
    annotation (Dialog(group="Mass flow rates"));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate in condenser medium"
    annotation (Dialog(group="Mass flow rates"));
  parameter Real ySet_small
    "Threshold for relative speed for the device to be considered on";

  replaceable parameter Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Generic
    safCtrPar constrainedby
    Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Generic
    "Safety control parameters" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-106,92},{-92,108}})));
  replaceable
    Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.OperationalEnvelope
    opeEnv if safCtrPar.use_opeEnv constrainedby
    Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.PartialOperationalEnvelope(
    final tabUppHea=safCtrPar.tabUppHea,
    final tabLowCoo=safCtrPar.tabLowCoo,
    final use_TUseSidOut=safCtrPar.use_TUseSidOut,
    final use_TAmbSidOut=safCtrPar.use_TAmbSidOut,
    final dTHys=safCtrPar.dTHysOpeEnv) "Block for operational envelope"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})),
      choicesAllMatching=true);
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.OnOff onOffCtr(
    final minOnTime=safCtrPar.minOnTime,
    final minOffTime=safCtrPar.minOffTime,
    final use_minOnTime=safCtrPar.use_minOnTime,
    final use_minOffTime=safCtrPar.use_minOffTime,
    final use_maxCycRat=safCtrPar.use_maxCycRat,
    final maxCycRat=safCtrPar.maxCycRat,
    final onOffMea_start=safCtrPar.onOffMea_start,
    final ySet_small=ySet_small,
    final ySetRed=safCtrPar.ySetRed) if safCtrPar.use_minOnTime or safCtrPar.use_minOffTime
     or safCtrPar.use_maxCycRat "On off control block"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.AntiFreeze antFre(final TAntFre=
        safCtrPar.TAntFre, final dTHys=safCtrPar.dTHysAntFre)
    if safCtrPar.use_antFre "Antifreeze control"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Interfaces.IntegerOutput opeEnvErr if safCtrPar.use_opeEnv
    "Number of errors from violating the operational envelope"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,-130})));
  Modelica.Blocks.Interfaces.IntegerOutput antFreErr if safCtrPar.use_antFre
    "Number of errors from antifreeze control"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-130})));

  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.MinimalFlowRate
    minVolFloRatSaf(final mEvaMin_flow=safCtrPar.r_mEvaMinPer_flow*
        mEva_flow_nominal, final mConMin_flow=safCtrPar.r_mConMinPer_flow*
        mCon_flow_nominal) if safCtrPar.use_minFlowCtr
    "Block to ensure minimal flow rates"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Modelica.Blocks.Interfaces.IntegerOutput minFlowErr
    if safCtrPar.use_minFlowCtr
    "Number of errors from violating minimum flow rates"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,-130})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrOnOff if not (safCtrPar.use_minOnTime
     or safCtrPar.use_minOffTime or safCtrPar.use_maxCycRat)
    "No on off control" annotation (
                         choicesAllMatching=true, Placement(transformation(
          extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrOpeEnv
    if not safCtrPar.use_opeEnv "No operational envelope control"  annotation (
                                                           choicesAllMatching=true,
      Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrAntFre
    if not safCtrPar.use_antFre "No antifreeze control"  annotation (
                                                   choicesAllMatching=true,
      Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrMinVolRat
    if not safCtrPar.use_minFlowCtr  "No minimum flow rate control"
    annotation (
      choicesAllMatching=true, Placement(transformation(extent={{60,60},{80,80}})));
equation

  connect(sigBus, onOffCtr.sigBus) annotation (Line(
      points={{-119,-61},{-112,-61},{-112,-10},{-66,-10},{-66,23.9167},{
          -59.9167,23.9167}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(sigBus, opeEnv.sigBus) annotation (Line(
      points={{-119,-61},{-112,-61},{-112,-10},{-28,-10},{-28,23.9167},{
          -19.9167,23.9167}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(sigBus, antFre.sigBus) annotation (Line(
      points={{-119,-61},{-112,-61},{-112,-10},{14,-10},{14,23.9167},{20.0833,
          23.9167}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(antFre.err, antFreErr) annotation (Line(points={{40.8333,21.6667},{
          40.8333,22},{46,22},{46,-54},{30,-54},{30,-130}},
                                    color={255,127,0}));
  connect(opeEnv.err, opeEnvErr) annotation (Line(points={{0.833333,21.6667},{
          0.833333,22},{6,22},{6,-54},{-10,-54},{-10,-130}},
                                      color={255,127,0}));
  connect(minVolFloRatSaf.yOut, yOut) annotation (Line(
      points={{80.8333,30},{92,30},{92,0},{130,0}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(sigBus, minVolFloRatSaf.sigBus) annotation (Line(
      points={{-119,-61},{-112,-61},{-112,-10},{56,-10},{56,23.9167},{60.0833,
          23.9167}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(minVolFloRatSaf.err, minFlowErr) annotation (Line(points={{80.8333,
          21.6667},{80.8333,22},{84,22},{84,-54},{70,-54},{70,-130}},
                                             color={255,127,0}));
  connect(reaPasThrOnOff.y, reaPasThrOpeEnv.u)
    annotation (Line(points={{-39,70},{-22,70}}, color={0,0,127}));
  connect(reaPasThrOpeEnv.y, reaPasThrAntFre.u)
    annotation (Line(points={{1,70},{18,70}}, color={0,0,127}));
  connect(reaPasThrAntFre.y, reaPasThrMinVolRat.u)
    annotation (Line(points={{41,70},{58,70}}, color={0,0,127}));
  connect(reaPasThrMinVolRat.y, yOut) annotation (Line(
      points={{81,70},{92,70},{92,0},{130,0}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(onOffCtr.yOut, opeEnv.ySet) annotation (Line(points={{-39.1667,30},{
          -21.3333,30}},                          color={0,0,127}));
  connect(opeEnv.yOut, antFre.ySet) annotation (Line(points={{0.833333,30},{
          18.6667,30}},                                               color={0,0,
          127}));
  connect(antFre.yOut, minVolFloRatSaf.ySet) annotation (Line(points={{40.8333,
          30},{58.6667,30}},                                            color={0,
          0,127}));
  connect(antFre.yOut, reaPasThrMinVolRat.u) annotation (Line(
      points={{40.8333,30},{40.8333,30},{52,30},{52,70},{58,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(reaPasThrAntFre.y, minVolFloRatSaf.ySet) annotation (Line(
      points={{41,70},{52,70},{52,30},{58.6667,30}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(opeEnv.yOut, reaPasThrAntFre.u) annotation (Line(
      points={{0.833333,30},{12,30},{12,70},{18,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(reaPasThrOpeEnv.y, antFre.ySet) annotation (Line(
      points={{1,70},{12,70},{12,30},{18.6667,30}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(onOffCtr.yOut, reaPasThrOpeEnv.u) annotation (Line(
      points={{-39.1667,30},{-39.1667,30},{-32,30},{-32,70},{-22,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(reaPasThrOnOff.y, opeEnv.ySet) annotation (Line(
      points={{-39,70},{-32,70},{-32,30},{-21.3333,30}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(ySet, onOffCtr.ySet) annotation (Line(
      points={{-136,0},{-80,0},{-80,30},{-61.3333,30}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ySet, reaPasThrOnOff.u) annotation (Line(
      points={{-136,0},{-80,0},{-80,70},{-62,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on the discussion in this issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Aggregation of the four main safety controls
  of a refrigerant machine (heat pump or chiller).
</p>
<p>
  The order is based on the relevance to a real system.
  Antifreeze control and mininmum flow rate control are put
  last because of the relevance for the simulation.
  If the medium temperature falls below or rises above the
  critical values, the simulation will fail.
</p>
<p>
All used functions are optional. See the used models for more
information on each safety function:
</p>
<ul>
<li><a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.OnOff\">
Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.OnOff</a> </li>
<li><a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.OperationalEnvelope\">
Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.OperationalEnvelope</a> </li>
<li><a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.AntiFreeze\">
Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.AntiFreeze</a> </li>
<li><a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.MinimalFlowRate\">
Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.MinimalFlowRate</a> </li>
</ul>
</html>"));
end Safety;
