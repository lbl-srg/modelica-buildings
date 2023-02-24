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
  Modelica.StateGraph.Transition traRes1(condition=(not traChaTan.condition)
         or (not traChiOnl.condition)) "Transition: Reset to initial step"
    annotation (Placement(transformation(extent={{260,60},{280,80}})));
  Modelica.StateGraph.Transition traChiOff(condition=not chiIsOnl)
    "Transition: Chiller is offline"
    annotation (Placement(transformation(extent={{180,20},{200,40}})));
  Modelica.StateGraph.Step steRemCha(nIn=1, nOut=1) "Step: Remote charging"
    annotation (Placement(transformation(extent={{220,20},{240,40}})));
  Modelica.StateGraph.Transition traRes2(condition=(not traChaTan.condition)
         or (not traChiOff.condition)) "Transition: Reset to initial step"
    annotation (Placement(transformation(extent={{260,20},{280,40}})));
  Modelica.StateGraph.Transition traChiOut(condition=hasLoa and ((not tanCom
         == 3) or tanIsDep) and chiIsOnl)
    "Transition: District has load, tank is unavailable but chiller is available"
    annotation (Placement(transformation(extent={{180,-80},{200,-60}})));
  Modelica.StateGraph.Step steChiOut(nIn=1, nOut=1) "Step: Chiller output"
    annotation (Placement(transformation(extent={{220,-80},{240,-60}})));
  Modelica.StateGraph.Transition traRes4(condition=not traChiOut.condition)
    "Transition: Reset to initial step"
    annotation (Placement(transformation(extent={{260,-80},{280,-60}})));
  Modelica.StateGraph.Transition traTanOut(condition=hasLoa and tanCom == 3
         and (not tanIsDep))
    "Transition: District has load, tank commanded to discharge and is not depleted"
    annotation (Placement(transformation(extent={{180,-40},{200,-20}})));
  Modelica.StateGraph.Step steTanOut(nIn=1, nOut=1) "Step: Tank output"
    annotation (Placement(transformation(extent={{220,-40},{240,-20}})));
  Modelica.StateGraph.Transition traRes3(condition=not traTanOut.condition)
    "Transition: Reset to initial step"
    annotation (Placement(transformation(extent={{260,-40},{280,-20}})));
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
  Modelica.StateGraph.Transition traChaTan(condition=tanCom == 1 and not
        tanIsFul) "Transition: Tank commanded to charge and is not full"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.StateGraph.Step steChaTan(nIn=1, nOut=1) "Step: Charge tank"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Modelica.StateGraph.Alternative alt(nBranches=3)
    "Alternative: Tank charging or plant outputting CHW"
    annotation (Placement(transformation(extent={{0,-100},{378,100}})));
equation
  connect(traChiOnl.outPort, steLocCha.inPort[1])
    annotation (Line(points={{191.5,70},{219,70}}, color={0,0,0}));
  connect(steLocCha.outPort[1], traRes1.inPort)
    annotation (Line(points={{240.5,70},{266,70}}, color={0,0,0}));
  connect(traChiOff.outPort, steRemCha.inPort[1])
    annotation (Line(points={{191.5,30},{219,30}}, color={0,0,0}));
  connect(steRemCha.outPort[1], traRes2.inPort)
    annotation (Line(points={{240.5,30},{266,30}}, color={0,0,0}));
  connect(traChiOut.outPort, steChiOut.inPort[1])
    annotation (Line(points={{191.5,-70},{219,-70}}, color={0,0,0}));
  connect(steChiOut.outPort[1], traRes4.inPort)
    annotation (Line(points={{240.5,-70},{266,-70}}, color={0,0,0}));
  connect(traTanOut.outPort, steTanOut.inPort[1])
    annotation (Line(points={{191.5,-30},{219,-30}}, color={0,0,0}));
  connect(steTanOut.outPort[1], traRes3.inPort)
    annotation (Line(points={{240.5,-30},{266,-30}}, color={0,0,0}));
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
  connect(traChaTan.outPort, steChaTan.inPort[1])
    annotation (Line(points={{71.5,50},{99,50}}, color={0,0,0}));
  connect(steChaTan.outPort[1], altTanCha.inPort)
    annotation (Line(points={{120.5,50},{139.36,50}}, color={0,0,0}));
  connect(traRes1.outPort, altTanCha.join[1]) annotation (Line(points={{271.5,
          70},{299.52,70},{299.52,40}}, color={0,0,0}));
  connect(traRes2.outPort, altTanCha.join[2]) annotation (Line(points={{271.5,
          30},{299.52,30},{299.52,60}}, color={0,0,0}));
  connect(traChaTan.inPort, alt.split[1]) annotation (Line(points={{66,50},{
          39.69,50},{39.69,-33.3333}}, color={0,0,0}));
  connect(altTanCha.outPort, alt.join[1]) annotation (Line(points={{319.76,50},
          {340,50},{340,-33.3333},{338.31,-33.3333}},
                                           color={0,0,0}));
  connect(alt.inPort, allOff.outPort[1])
    annotation (Line(points={{-5.67,0},{-39.5,0}}, color={0,0,0}));
  connect(traChiOnl.inPort, altTanCha.split[1]) annotation (Line(points={{186,70},
          {160,70},{160,40},{160.48,40}}, color={0,0,0}));
  connect(traChiOff.inPort, altTanCha.split[2]) annotation (Line(points={{186,30},
          {160,30},{160,60},{160.48,60}}, color={0,0,0}));
  connect(alt.outPort, allOff.inPort[1]) annotation (Line(points={{381.78,0},{390,
          0},{390,108},{-66,108},{-66,0},{-61,0}}, color={0,0,0}));
  connect(mPriPum_flow, swiPriPum.y)
    annotation (Line(points={{590,40},{482,40}}, color={0,0,127}));
  connect(mSecPum_flow, secPumFlo.y) annotation (Line(points={{590,-40},{570,-40},
          {570,-30},{562,-30}}, color={0,0,127}));
  connect(traTanOut.inPort, alt.split[2]) annotation (Line(points={{186,-30},{
          40,-30},{40,1.06581e-14},{39.69,1.06581e-14}}, color={0,0,0}));
  connect(traChiOut.inPort, alt.split[3]) annotation (Line(points={{186,-70},{
          40,-70},{40,33.3333},{39.69,33.3333}}, color={0,0,0}));
  connect(traRes3.outPort, alt.join[2]) annotation (Line(points={{271.5,-30},{
          338.31,-30},{338.31,0}}, color={0,0,0}));
  connect(traRes4.outPort, alt.join[3]) annotation (Line(points={{271.5,-70},{
          338,-70},{338,33.3333},{338.31,33.3333}}, color={0,0,0}));
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
