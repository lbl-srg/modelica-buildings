within Buildings.Fluid.Storage.Plant.Controls;
block FlowControl
  "This block controls the flow at the primary and secondary pumps"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.MassFlowRate mChi_flow_nominal
    "Nominal mass flow rate of the chiller loop"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.MassFlowRate mTan_flow_nominal
    "Nominal mass flow rate of the tank branch"
    annotation(Dialog(group="Nominal values"));

  parameter Boolean use_outFil=true
    "= true, if output is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filter"));

  Modelica.Blocks.Interfaces.IntegerInput tanCom
    "Command to tank: 1 = charge, 2 = hold, 3 = discharge" annotation (
      Placement(transformation(extent={{-120,70},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Interfaces.BooleanInput chiIsOnl "Chiller is online"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealOutput mPriPum_flow
    "Primary pump mass flow rate" annotation (Placement(transformation(extent={{580,30},
            {600,50}}),         iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput mSecPum_flow
    "Primary pump and valve mass flow rate" annotation (Placement(
        transformation(extent={{580,-50},{600,-30}}), iconTransformation(extent
          ={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.BooleanInput tanIsFul "Tank is full" annotation (
      Placement(transformation(extent={{-120,30},{-100,50}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Interfaces.BooleanInput tanIsDep "Tank is depleted"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{420,80},{440,100}})));
  Modelica.StateGraph.InitialStep allOff(nOut=1, nIn=1) "Initial step, all off"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Interfaces.BooleanInput hasLoa "True: Has load"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));
  Modelica.StateGraph.Transition traChiOnl(condition=chiIsOnl)
    "Transition: Chiller is online"
    annotation (Placement(transformation(extent={{180,60},{200,80}})));
  Modelica.StateGraph.Step steLocCha(nIn=1, nOut=1) "Step: Local charging"
    annotation (Placement(transformation(extent={{220,60},{240,80}})));
  Modelica.StateGraph.Transition traTanFulOrNotTanChaOrChiOff(condition=
        tanIsFul or tanCom <> 1 or not chiIsOnl)
    "Transition: Tank is full or not charging or chiller offline"
    annotation (Placement(transformation(extent={{260,60},{280,80}})));
  Modelica.StateGraph.Transition traChiOff(condition=not chiIsOnl)
    "Transition: Chiller is offline"
    annotation (Placement(transformation(extent={{180,20},{200,40}})));
  Modelica.StateGraph.Step steRemCha(nIn=1, nOut=1) "Step: Remote charging"
    annotation (Placement(transformation(extent={{220,20},{240,40}})));
  Modelica.StateGraph.Transition traTanFulOrNotTanCha(condition=tanIsFul or
        tanCom <> 1) "Transition: Tank is full or not tank charging"
    annotation (Placement(transformation(extent={{260,20},{280,40}})));
  Modelica.StateGraph.Transition traTanUna(condition=(not tanCom == 3) or
        tanIsDep)
    "Transition: Tank is unavailable (no discharge command or depleted)"
    annotation (Placement(transformation(extent={{180,-40},{200,-20}})));
  Modelica.StateGraph.Step steChiOut(nIn=1, nOut=1) "Step: Chiller output"
    annotation (Placement(transformation(extent={{220,-40},{240,-20}})));
  Modelica.StateGraph.Transition traLoaLowOrChiOffOrTanAva(condition=(not
        hasLoa) or (not chiIsOnl) or (tanCom == 3 and not tanIsDep))
    "Transition: Load is low or chiller commanded offline or tank becomes available"
    annotation (Placement(transformation(extent={{260,-40},{280,-20}})));
  Modelica.StateGraph.Transition traTanAva(condition=tanCom == 3 and (not
        tanIsDep))
    "Transition: Tank commanded to discharge and is not depleted"
    annotation (Placement(transformation(extent={{180,-80},{200,-60}})));
  Modelica.StateGraph.Step steTanOut(nIn=1, nOut=1) "Step: Tank output"
    annotation (Placement(transformation(extent={{220,-80},{240,-60}})));
  Modelica.StateGraph.Transition traLoaLowOrTanUna(condition=(not hasLoa) or
        tanIsDep or tanCom <> 3)
    "Transition: Load is low or tank becomes unavailable"
    annotation (Placement(transformation(extent={{260,-80},{280,-60}})));
  Modelica.Blocks.Sources.BooleanExpression expPriPumFlo(y=steLocCha.active or
        steChiOut.active) "Boolean expression for primary pump flow"
    annotation (Placement(transformation(extent={{420,30},{440,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal swiPriPum(realTrue=
        mChi_flow_nominal, realFalse=0) "Switch for primary pump flow"
    annotation (Placement(transformation(extent={{460,30},{480,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal swiTanCha(realTrue=-
        mTan_flow_nominal, realFalse=0) "Switch for tank charging"
    annotation (Placement(transformation(extent={{460,-20},{480,0}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal swiTanDis(realTrue=
        mTan_flow_nominal, realFalse=0) "Switch for tank discharging"
    annotation (Placement(transformation(extent={{460,-80},{480,-60}})));
  Modelica.Blocks.Sources.BooleanExpression expTanCha(y=steLocCha.active or
        steRemCha.active) "Boolean expression for tank charging"
    annotation (Placement(transformation(extent={{420,-20},{440,0}})));
  Modelica.Blocks.Sources.BooleanExpression expTanDis(y=steTanOut.active)
    "Boolean expression for tank discharging"
    annotation (Placement(transformation(extent={{420,-80},{440,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add tanFlo "Flow rate of the tank"
    annotation (Placement(transformation(extent={{500,-60},{520,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add secPumFlo
    "Flow rate at the secondary pump and valve connection"
    annotation (Placement(transformation(extent={{540,-40},{560,-20}})));
  Modelica.StateGraph.Alternative altTanCha(nBranches=2)
    "Alternative: Tank charging locally or remotely"
    annotation (Placement(transformation(extent={{142,10},{318,90}})));
  Modelica.StateGraph.Transition traTanChaAndNotFul(condition=tanCom == 1 and
        not tanIsFul) "Transition: Tank commanded to charge and is not full"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.StateGraph.Step steTanCha(nIn=1, nOut=1) "Step: Tank charging"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Modelica.StateGraph.Alternative alt(nBranches=2)
    "Alternative: Tank charging or plant outputting CHW"
    annotation (Placement(transformation(extent={{0,-100},{378,100}})));
  Modelica.StateGraph.Transition traHasLoaAndPlaAva(condition=hasLoa and (
        chiIsOnl or (tanCom == 3 and not tanIsDep)))
    "Transition: District system has load and plant available (chiller online or tank available)"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Modelica.StateGraph.Step steOutCHW(nIn=1, nOut=1) "Step: Plant outputs CHW"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.StateGraph.Alternative altOutCHW(nBranches=2)
    "Alternative: Outputting CHW from the chiller or the tank"
    annotation (Placement(transformation(extent={{142,-90},{318,-10}})));
equation
  connect(traChiOnl.outPort, steLocCha.inPort[1])
    annotation (Line(points={{191.5,70},{219,70}}, color={0,0,0}));
  connect(steLocCha.outPort[1], traTanFulOrNotTanChaOrChiOff.inPort)
    annotation (Line(points={{240.5,70},{266,70}}, color={0,0,0}));
  connect(traChiOff.outPort, steRemCha.inPort[1])
    annotation (Line(points={{191.5,30},{219,30}}, color={0,0,0}));
  connect(steRemCha.outPort[1], traTanFulOrNotTanCha.inPort)
    annotation (Line(points={{240.5,30},{266,30}}, color={0,0,0}));
  connect(traTanUna.outPort, steChiOut.inPort[1])
    annotation (Line(points={{191.5,-30},{219,-30}}, color={0,0,0}));
  connect(steChiOut.outPort[1], traLoaLowOrChiOffOrTanAva.inPort)
    annotation (Line(points={{240.5,-30},{266,-30}}, color={0,0,0}));
  connect(traTanAva.outPort, steTanOut.inPort[1])
    annotation (Line(points={{191.5,-70},{219,-70}}, color={0,0,0}));
  connect(steTanOut.outPort[1],traLoaLowOrTanUna. inPort)
    annotation (Line(points={{240.5,-70},{266,-70}}, color={0,0,0}));
  connect(expPriPumFlo.y, swiPriPum.u)
    annotation (Line(points={{441,40},{458,40}}, color={255,0,255}));
  connect(expTanCha.y, swiTanCha.u)
    annotation (Line(points={{441,-10},{458,-10}}, color={255,0,255}));
  connect(expTanDis.y, swiTanDis.u)
    annotation (Line(points={{441,-70},{458,-70}}, color={255,0,255}));
  connect(swiTanCha.y, tanFlo.u1) annotation (Line(points={{482,-10},{490,-10},{
          490,-44},{498,-44}}, color={0,0,127}));
  connect(swiTanDis.y, tanFlo.u2) annotation (Line(points={{482,-70},{490,-70},{
          490,-56},{498,-56}}, color={0,0,127}));
  connect(tanFlo.y, secPumFlo.u2) annotation (Line(points={{522,-50},{530,-50},{
          530,-36},{538,-36}}, color={0,0,127}));
  connect(swiPriPum.y, secPumFlo.u1) annotation (Line(points={{482,40},{530,40},
          {530,-24},{538,-24}}, color={0,0,127}));
  connect(traTanChaAndNotFul.outPort, steTanCha.inPort[1])
    annotation (Line(points={{71.5,50},{99,50}}, color={0,0,0}));
  connect(steTanCha.outPort[1], altTanCha.inPort)
    annotation (Line(points={{120.5,50},{139.36,50}}, color={0,0,0}));
  connect(traTanFulOrNotTanChaOrChiOff.outPort, altTanCha.join[1]) annotation (
      Line(points={{271.5,70},{299.52,70},{299.52,40}}, color={0,0,0}));
  connect(traTanFulOrNotTanCha.outPort, altTanCha.join[2]) annotation (Line(
        points={{271.5,30},{299.52,30},{299.52,60}}, color={0,0,0}));
  connect(traTanChaAndNotFul.inPort, alt.split[1])
    annotation (Line(points={{66,50},{39.69,50},{39.69,-25}}, color={0,0,0}));
  connect(altTanCha.outPort, alt.join[1]) annotation (Line(points={{319.76,50},{
          340,50},{340,-25},{338.31,-25}}, color={0,0,0}));
  connect(alt.inPort, allOff.outPort[1])
    annotation (Line(points={{-5.67,0},{-39.5,0}}, color={0,0,0}));
  connect(traChiOnl.inPort, altTanCha.split[1]) annotation (Line(points={{186,70},
          {160,70},{160,40},{160.48,40}}, color={0,0,0}));
  connect(traChiOff.inPort, altTanCha.split[2]) annotation (Line(points={{186,30},
          {160,30},{160,60},{160.48,60}}, color={0,0,0}));
  connect(alt.outPort, allOff.inPort[1]) annotation (Line(points={{381.78,0},{390,
          0},{390,108},{-66,108},{-66,0},{-61,0}}, color={0,0,0}));
  connect(steOutCHW.inPort[1], traHasLoaAndPlaAva.outPort)
    annotation (Line(points={{99,-50},{71.5,-50}}, color={0,0,0}));
  connect(traHasLoaAndPlaAva.inPort, alt.split[2]) annotation (Line(points={{66,
          -50},{40,-50},{40,25},{39.69,25}}, color={0,0,0}));
  connect(steOutCHW.outPort[1], altOutCHW.inPort)
    annotation (Line(points={{120.5,-50},{139.36,-50}}, color={0,0,0}));
  connect(traTanAva.inPort, altOutCHW.split[2]) annotation (Line(points={{186,-70},
          {160.48,-70},{160.48,-40}}, color={0,0,0}));
  connect(traLoaLowOrChiOffOrTanAva.outPort, altOutCHW.join[1]) annotation (
      Line(points={{271.5,-30},{299.52,-30},{299.52,-60}}, color={0,0,0}));
  connect(traLoaLowOrTanUna.outPort, altOutCHW.join[2]) annotation (Line(points
        ={{271.5,-70},{300,-70},{300,-40},{299.52,-40}}, color={0,0,0}));
  connect(altOutCHW.outPort, alt.join[2]) annotation (Line(points={{319.76,-50},
          {338,-50},{338,25},{338.31,25}}, color={0,0,0}));
  connect(traTanUna.inPort, altOutCHW.split[1]) annotation (Line(points={{186,-30},
          {160,-30},{160,-60},{160.48,-60}}, color={0,0,0}));
  connect(mPriPum_flow, swiPriPum.y)
    annotation (Line(points={{590,40},{482,40}}, color={0,0,127}));
  connect(mSecPum_flow, secPumFlo.y) annotation (Line(points={{590,-40},{570,-40},
          {570,-30},{562,-30}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-120},{580,120}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-20,80},{20,40}}, lineColor={28,108,200}),
        Line(points={{-40,-20},{-40,20},{40,20},{40,-20}}, color={28,108,200}),

        Line(points={{0,40},{0,20}}, color={28,108,200}),
        Polygon(
          points={{-6,2},{2.74617e-16,-16},{-12,-16},{-6,2}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={34,-16},
          rotation=180),
        Polygon(
          points={{-6,2},{2.74617e-16,-16},{-12,-16},{-6,2}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={-46,-16},
          rotation=180),
        Rectangle(
          extent={{-80,-38},{80,-42}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{20,-20},{60,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{58,-40},{28,-24},{28,-56},{58,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None),
        Ellipse(
          extent={{-60,-20},{-20,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-22,-40},{-52,-24},{-52,-56},{-22,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None),
        Rectangle(
          extent={{-2,-42},{2,-80}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}));
end FlowControl;
