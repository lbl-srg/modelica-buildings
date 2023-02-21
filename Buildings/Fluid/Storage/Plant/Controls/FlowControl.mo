within Buildings.Fluid.Storage.Plant.Controls;
block FlowControl
  "This block controls the flow at the primary and secondary pumps"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.MassFlowRate mChi_flow_nominal
    "Nominal mass flow rate of the chiller loop";
  parameter Modelica.Units.SI.MassFlowRate mTan_flow_nominal
    "Nominal mass flow rate of the tank branch";

  Modelica.Blocks.Interfaces.IntegerInput tanCom
    "Command to tank: 1 = charge, 2 = hold, 3 = discharge" annotation (
      Placement(transformation(extent={{-120,70},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Interfaces.BooleanInput chiIsOnl "Chiller is online"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealOutput mPriPum_flow
    "Primary pump mass flow rate" annotation (Placement(transformation(extent={{340,30},
            {360,50}}),         iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput mSecPum_flow
    "Primary pump and valve mass flow rate" annotation (Placement(
        transformation(extent={{340,-50},{360,-30}}), iconTransformation(extent
          ={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.BooleanInput tanIsFul "Tank is full" annotation (
      Placement(transformation(extent={{-120,30},{-100,50}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Interfaces.BooleanInput tanIsDep "Tank is depleted"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{240,80},{260,100}})));
  Modelica.StateGraph.InitialStep allOff(nOut=1, nIn=1) "Initial step, all off"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.StateGraph.Alternative alt(nBranches=4)
                                      "Alternative"
    annotation (Placement(transformation(extent={{-18,-100},{160,100}})));
  Modelica.Blocks.Interfaces.BooleanInput hasLoa "True: Has load"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));
  Modelica.StateGraph.Transition traTanChaAndchiIsOnl(condition=tanCom == 1 and
        chiIsOnl) "Transition: Tank charging and chiller is online"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.StateGraph.Step steLocCha(nIn=1, nOut=1) "Step: Local charging"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.StateGraph.Transition traTanFulOrNotTanCha1(condition=tanIsFul or
        tanCom <> 1) "Transition: Tank is full or not tank charging"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Modelica.StateGraph.Transition traTanChaAndChiOff(condition=tanCom == 1 and
        not chiIsOnl) "Transition: Tank charging and chiller is offline"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.StateGraph.Step steRemCha(nIn=1, nOut=1) "Step: Remote charging"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.StateGraph.Transition traTanFulOrNotTanCha2(condition=tanIsFul or
        tanCom <> 1) "Transition: Tank is full or not tank charging"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Modelica.StateGraph.Transition traHasLoaAndTanUna(condition=hasLoa and ((not
        tanCom == 3) or tanIsDep))
    "Transition: There is load but tank unavailable (no discharge command or depleted)"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.StateGraph.Step steChiOut(nIn=1, nOut=1) "Step: Chiller output"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Modelica.StateGraph.Transition traLoaLowOrChiOff(condition=(not hasLoa) or (
        not chiIsOnl)) "Transition: Load is low or chiller commanded offline"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Modelica.StateGraph.Transition traTanDisAndNotDep(condition=tanCom == 3 and (
        not tanIsDep))
    "Transition: Tank commanded to discharge and is not depleted"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.StateGraph.Step steTanOut(nIn=1, nOut=1) "Step: Tank output"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Modelica.StateGraph.Transition traLoaLowOrTanDep(condition=(not hasLoa) or
        tanIsDep) "Transition: Load is low or tank depleted"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
  Modelica.Blocks.Sources.BooleanExpression expPriPumFlo(y=steLocCha.active or
        steChiOut.active) "Boolean expression for primary pump flow"
    annotation (Placement(transformation(extent={{180,30},{200,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal swiPriPum(realTrue=
        mChi_flow_nominal, realFalse=0) "Switch for primary pump flow"
    annotation (Placement(transformation(extent={{220,30},{240,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal swiTanCha(realTrue=-
        mTan_flow_nominal, realFalse=0) "Switch for tank charging"
    annotation (Placement(transformation(extent={{220,-20},{240,0}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal swiPriPum2(realTrue=
        mChi_flow_nominal, realFalse=0) "Switch for tank discharging"
    annotation (Placement(transformation(extent={{220,-80},{240,-60}})));
  Modelica.Blocks.Sources.BooleanExpression expTanCha(y=steLocCha.active or
        steRemCha.active) "Boolean expression for tank charging"
    annotation (Placement(transformation(extent={{180,-20},{200,0}})));
  Modelica.Blocks.Sources.BooleanExpression expTanDis(y=steTanOut.active)
    "Boolean expression for tank discharging"
    annotation (Placement(transformation(extent={{180,-80},{200,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add tanFlo "Flow rate of the tank"
    annotation (Placement(transformation(extent={{260,-60},{280,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add tanFlo1 "Flow rate of the tank"
    annotation (Placement(transformation(extent={{300,-40},{320,-20}})));
equation
  connect(allOff.outPort[1], alt.inPort)
    annotation (Line(points={{-39.5,0},{-20.67,0}},
                                                 color={0,0,0}));
  connect(alt.outPort, allOff.inPort[1]) annotation (Line(points={{161.78,0},{166,
          0},{166,-106},{-66,-106},{-66,0},{-61,0}}, color={0,0,0}));
  connect(traTanChaAndchiIsOnl.outPort, steLocCha.inPort[1])
    annotation (Line(points={{31.5,70},{59,70}}, color={0,0,0}));
  connect(steLocCha.outPort[1], traTanFulOrNotTanCha1.inPort)
    annotation (Line(points={{80.5,70},{106,70}},  color={0,0,0}));
  connect(traTanChaAndchiIsOnl.inPort, alt.split[1]) annotation (Line(points={{26,70},
          {0,70},{0,-37.5},{0.69,-37.5}},color={0,0,0}));
  connect(traTanFulOrNotTanCha1.outPort, alt.join[1]) annotation (Line(points={{111.5,
          70},{140,70},{140,-37.5},{141.31,-37.5}},
                                                  color={0,0,0}));
  connect(traTanChaAndChiOff.inPort, alt.split[2]) annotation (Line(points={{26,30},
          {0,30},{0,-12.5},{0.69,-12.5}},color={0,0,0}));
  connect(traTanChaAndChiOff.outPort, steRemCha.inPort[1])
    annotation (Line(points={{31.5,30},{59,30}}, color={0,0,0}));
  connect(steRemCha.outPort[1], traTanFulOrNotTanCha2.inPort)
    annotation (Line(points={{80.5,30},{106,30}},  color={0,0,0}));
  connect(traTanFulOrNotTanCha2.outPort, alt.join[2]) annotation (Line(points={{111.5,
          30},{142,30},{142,-12.5},{141.31,-12.5}},
                                                  color={0,0,0}));
  connect(traHasLoaAndTanUna.inPort, alt.split[3]) annotation (Line(points={{26,-30},
          {0,-30},{0,12.5},{0.69,12.5}},   color={0,0,0}));
  connect(traHasLoaAndTanUna.outPort, steChiOut.inPort[1])
    annotation (Line(points={{31.5,-30},{59,-30}}, color={0,0,0}));
  connect(steChiOut.outPort[1], traLoaLowOrChiOff.inPort)
    annotation (Line(points={{80.5,-30},{106,-30}},  color={0,0,0}));
  connect(traLoaLowOrChiOff.outPort, alt.join[3]) annotation (Line(points={{111.5,
          -30},{142,-30},{142,12.5},{141.31,12.5}},
                                              color={0,0,0}));
  connect(traTanDisAndNotDep.outPort, steTanOut.inPort[1])
    annotation (Line(points={{31.5,-70},{59,-70}}, color={0,0,0}));
  connect(traTanDisAndNotDep.inPort, alt.split[4]) annotation (Line(points={{26,-70},
          {0,-70},{0,37.5},{0.69,37.5}},   color={0,0,0}));
  connect(steTanOut.outPort[1], traLoaLowOrTanDep.inPort)
    annotation (Line(points={{80.5,-70},{106,-70}},  color={0,0,0}));
  connect(traLoaLowOrTanDep.outPort, alt.join[4]) annotation (Line(points={{111.5,
          -70},{140,-70},{140,37.5},{141.31,37.5}},
                                              color={0,0,0}));
  connect(expPriPumFlo.y, swiPriPum.u)
    annotation (Line(points={{201,40},{218,40}}, color={255,0,255}));
  connect(swiPriPum.y, mPriPum_flow)
    annotation (Line(points={{242,40},{350,40}}, color={0,0,127}));
  connect(expTanCha.y, swiTanCha.u)
    annotation (Line(points={{201,-10},{218,-10}}, color={255,0,255}));
  connect(expTanDis.y, swiPriPum2.u)
    annotation (Line(points={{201,-70},{218,-70}}, color={255,0,255}));
  connect(swiTanCha.y, tanFlo.u1) annotation (Line(points={{242,-10},{250,-10},{
          250,-44},{258,-44}}, color={0,0,127}));
  connect(swiPriPum2.y, tanFlo.u2) annotation (Line(points={{242,-70},{250,-70},
          {250,-56},{258,-56}}, color={0,0,127}));
  connect(tanFlo.y, tanFlo1.u2) annotation (Line(points={{282,-50},{290,-50},{290,
          -36},{298,-36}}, color={0,0,127}));
  connect(swiPriPum.y, tanFlo1.u1) annotation (Line(points={{242,40},{290,40},{290,
          -24},{298,-24}}, color={0,0,127}));
  connect(tanFlo1.y, mSecPum_flow) annotation (Line(points={{322,-30},{330,-30},
          {330,-40},{350,-40}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-120},{340,120}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end FlowControl;
