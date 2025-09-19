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
    Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.OperationalEnvelope opeEnv
      if safCtrPar.use_opeEnv constrainedby
        Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.PartialOperationalEnvelope(
          final use_TConOutHea=safCtrPar.use_TConOutHea,
          final use_TEvaOutHea=safCtrPar.use_TEvaOutHea,
          final use_TConOutCoo=safCtrPar.use_TConOutCoo,
          final use_TEvaOutCoo=safCtrPar.use_TEvaOutCoo,
          final tabUppHea=safCtrPar.tabUppHea,
          final tabLowCoo=safCtrPar.tabLowCoo,
          final dTHys=safCtrPar.dTHysOpeEnv) "Block for operational envelope"
    annotation (Placement(transformation(extent={{20,80},{40,100}})),
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
    final ySetRed=safCtrPar.ySetRed)
      if safCtrPar.use_minOnTime or safCtrPar.use_minOffTime
     or safCtrPar.use_maxCycRat "On off control block"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.AntiFreeze antFre(
    final TAntFre=safCtrPar.TAntFre,
    final dTHys=safCtrPar.dTHysAntFre)
    if safCtrPar.use_antFre "Antifreeze control"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Interfaces.IntegerOutput opeEnvErr if safCtrPar.use_opeEnv
    "Number of errors from violating the operational envelope"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,-130})));
  Modelica.Blocks.Interfaces.IntegerOutput antFreErr if safCtrPar.use_antFre
    "Number of errors from antifreeze control"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-130})));

  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.MinimalFlowRate minVolFloRatSaf(
    final mEvaMin_flow=safCtrPar.r_mEvaMinPer_flow*mEva_flow_nominal,
    final mConMin_flow=safCtrPar.r_mConMinPer_flow*mCon_flow_nominal)
      if safCtrPar.use_minFlowCtr
    "Block to ensure minimal flow rates"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Modelica.Blocks.Interfaces.IntegerOutput minFlowErr
    if safCtrPar.use_minFlowCtr
    "Number of errors from violating minimum flow rates"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={100,-130})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrOnOff if not (safCtrPar.use_minOnTime
     or safCtrPar.use_minOffTime or safCtrPar.use_maxCycRat)
    "No on off control" annotation (
                         choicesAllMatching=true, Placement(transformation(
          extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Logical.Hysteresis ySetOn(
    final pre_y_start=safCtrPar.onOffMea_start,
    final uHigh=ySet_small,
    final uLow=ySet_small/2) "=true if device is set on after on off control"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Logical.Switch swiErr
    "Switches to zero when an error occurs"
    annotation (Placement(transformation(extent={{94,-10},{114,10}})));
  Modelica.Blocks.Sources.Constant conZer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Modelica.Blocks.MathBoolean.And andCanOpe(final nu=3) "Can operate"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.BooleanConstant conCanOpeAntFre(final k=true)
    if not safCtrPar.use_antFre "Constant can operate"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.BooleanConstant conCanOpeMinFlo(final k=true)
    if not safCtrPar.use_minFlowCtr "Constant can operate"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Modelica.Blocks.Sources.BooleanConstant conCanOpeOpeEnv(final k=true)
    if not safCtrPar.use_opeEnv "Constant can operate"
    annotation (Placement(transformation(extent={{20,48},{40,68}})));
  Modelica.Blocks.Interfaces.RealInput ySet
    "Input for relative compressor speed from 0 to 1"
    annotation (Placement(transformation(extent={{-152,-16},{-120,16}}),
        iconTransformation(extent={{-152,-16},{-120,16}})));
  Modelica.Blocks.Interfaces.RealOutput yOut
    "Output for relative compressor speed from 0 to 1"
    annotation (Placement(transformation(extent={{120,-10},{140,10}}),
        iconTransformation(extent={{120,-10},{140,10}})));
equation

  connect(sigBus, onOffCtr.sigBus) annotation (Line(
      points={{-119,-61},{-122,-61},{-122,-60},{-90,-60},{-90,23.9167},{
          -79.9167,23.9167}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(antFre.err, antFreErr) annotation (Line(points={{40.8333,21.6667},{54,
          21.6667},{54,-112},{60,-112},{60,-130}},
                                    color={255,127,0}));
  connect(opeEnv.err, opeEnvErr) annotation (Line(points={{40.8333,81.6667},{54,
          81.6667},{54,-112},{20,-112},{20,-130}},
                                      color={255,127,0}));

  connect(minVolFloRatSaf.err, minFlowErr) annotation (Line(points={{40.8333,
          -38.3333},{54,-38.3333},{54,-112},{100,-112},{100,-130}},
                                             color={255,127,0}));

  connect(ySet, onOffCtr.ySet) annotation (Line(
      points={{-136,0},{-92,0},{-92,30},{-81.3333,30}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ySet, reaPasThrOnOff.u) annotation (Line(
      points={{-136,0},{-92,0},{-92,70},{-82,70}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ySetOn.u, onOffCtr.yOut) annotation (Line(points={{-42,50},{-56,50},{
          -56,30},{-59.1667,30}},
                              color={0,0,127}));
  connect(ySetOn.u, reaPasThrOnOff.y) annotation (Line(points={{-42,50},{-56,50},
          {-56,70},{-59,70}}, color={0,0,127}));
  connect(conZer.y,swiErr. u3) annotation (Line(points={{81,-30},{84,-30},{84,-8},
          {92,-8}},         color={0,0,127}));
  connect(swiErr.y, yOut)
    annotation (Line(points={{115,0},{130,0}}, color={0,0,127}));
  connect(onOffCtr.yOut, swiErr.u1) annotation (Line(points={{-59.1667,30},{-56,
          30},{-56,112},{86,112},{86,8},{92,8}}, color={0,0,127}));
  connect(reaPasThrOnOff.y, swiErr.u1) annotation (Line(points={{-59,70},{-56,70},
          {-56,112},{86,112},{86,8},{92,8}}, color={0,0,127}));
  connect(andCanOpe.y, swiErr.u2)
    annotation (Line(points={{81.5,0},{92,0}}, color={255,0,255}));
  connect(ySetOn.y, opeEnv.onOffSet) annotation (Line(points={{-19,50},{6,50},{
          6,90},{18.3333,90}},            color={255,0,255}));
  connect(ySetOn.y, antFre.onOffSet) annotation (Line(points={{-19,50},{6,50},{
          6,30},{18.3333,30}},            color={255,0,255}));
  connect(ySetOn.y, minVolFloRatSaf.onOffSet) annotation (Line(points={{-19,50},
          {6,50},{6,-30},{18.3333,-30}},             color={255,0,255}));
  connect(sigBus, minVolFloRatSaf.sigBus) annotation (Line(
      points={{-119,-61},{14,-61},{14,-36.0833},{20.0833,-36.0833}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigBus, antFre.sigBus) annotation (Line(
      points={{-119,-61},{14,-61},{14,24},{16,24},{16,23.9167},{20.0833,23.9167}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigBus, opeEnv.sigBus) annotation (Line(
      points={{-119,-61},{14,-61},{14,84},{16,84},{16,83.9167},{20.0833,83.9167}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(opeEnv.canOpe, andCanOpe.u[1]) annotation (Line(points={{40.8333,90},
          {50,90},{50,-2.33333},{60,-2.33333}},      color={255,0,255}));
  connect(conCanOpeOpeEnv.y, andCanOpe.u[1]) annotation (Line(points={{41,58},{50,
          58},{50,-2.33333},{60,-2.33333}},
                                      color={255,0,255}));
  connect(antFre.canOpe, andCanOpe.u[2]) annotation (Line(points={{40.8333,30},
          {50,30},{50,0},{60,0},{60,0}},              color={255,0,255}));
  connect(conCanOpeAntFre.y, andCanOpe.u[2])
    annotation (Line(points={{41,0},{60,0},{60,0}},        color={255,0,255}));
  connect(minVolFloRatSaf.canOpe, andCanOpe.u[3]) annotation (Line(points={{40.8333,
          -30},{50,-30},{50,0},{60,0},{60,2.33333}},        color={255,0,255}));
  connect(conCanOpeMinFlo.y, andCanOpe.u[3]) annotation (Line(points={{41,-60},{
          50,-60},{50,0},{60,0},{60,2.33333}},                   color={255,0,255}));
  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>May 27, 2025</i> by Fabian Wuellhorst:<br/>
    Make safety checks parallel (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/2015\">IBPSA #2015</a>)
  </li>
  <li>
    <i>May 26, 2025</i> by Fabian Wuellhorst and Michael Wetter:<br/>
    Increase error counter only when device should turn on (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/2011\">IBPSA #2011</a>)
  </li>
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
