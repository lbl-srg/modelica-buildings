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
      Placement(transformation(extent={{-120,50},{-100,70}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.BooleanInput chiIsOnl "Chiller is online"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealOutput mPriPum_flow
    "Primary pump mass flow rate"
    annotation (Placement(transformation(extent={{580,40},
            {600,60}}),iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput ySecPum
    "Secondary pump normalised speed" annotation (Placement(transformation(
          extent={{580,-20},{600,0}}), iconTransformation(extent={{100,-10},{
            120,10}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{420,80},{440,100}})));
  Modelica.StateGraph.InitialStep allOff(nOut=1, nIn=1) "Initial step, all off"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Interfaces.BooleanInput hasLoa "True: Has load"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));
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
  Modelica.StateGraph.Transition traChiOut(condition=hasLoa and (((tanCom <> 3
         or tanSta[1]) and chiIsOnl) and not tanSta[3]))
    "Transition: District has load, tank is unavailable but chiller is available"
    annotation (Placement(transformation(extent={{180,-80},{200,-60}})));
  Modelica.StateGraph.Step steChiOut(nIn=1, nOut=1) "Step: Chiller output"
    annotation (Placement(transformation(extent={{220,-80},{240,-60}})));
  Modelica.StateGraph.Transition traRes4(condition=not traChiOut.condition)
    "Transition: Reset to initial step"
    annotation (Placement(transformation(extent={{260,-80},{280,-60}})));
  Modelica.StateGraph.Transition traTanOut(condition=hasLoa and (tanCom == 3
         and (not tanSta[1]) or tanSta[3]))
    "Transition: District has load, tank commanded to discharge and is not depleted"
    annotation (Placement(transformation(extent={{180,-40},{200,-20}})));
  Modelica.StateGraph.Step steTanOut(nIn=1, nOut=1) "Step: Tank output"
    annotation (Placement(transformation(extent={{220,-40},{240,-20}})));
  Modelica.StateGraph.Transition traRes3(condition=not traTanOut.condition)
    "Transition: Reset to initial step"
    annotation (Placement(transformation(extent={{260,-40},{280,-20}})));
  Modelica.Blocks.Sources.BooleanExpression expPriPumFlo(y=steLocCha.active or
        steChiOut.active) "Expression for local charging OR chiller output"
    annotation (Placement(transformation(extent={{420,40},{440,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal swiPriPum(realTrue=
        mChi_flow_nominal, realFalse=0) "Switch for primary pump flow"
    annotation (Placement(transformation(extent={{460,40},{480,60}})));
  Modelica.Blocks.Sources.BooleanExpression expSecPum(y=steTanOut.active or
        steChiOut.active) "Expression for tank output or chiller output"
    annotation (Placement(transformation(extent={{420,-20},{440,0}})));
  Modelica.Blocks.Sources.BooleanExpression expVal(y=steRemCha.active)
    "Boolean expression for remotely charging the tank"
    annotation (Placement(transformation(extent={{420,-80},{440,-60}})));
  Modelica.StateGraph.Alternative altTanCha(nBranches=2)
    "Alternative: Tank charging locally or remotely"
    annotation (Placement(transformation(extent={{142,10},{318,90}})));
  Modelica.StateGraph.Transition traChaTan(condition=tanCom == 1 and not tanSta[
        2])       "Transition: Tank commanded to charge and is not full"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.StateGraph.Step steChaTan(nIn=1, nOut=1) "Step: Charge tank"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Modelica.StateGraph.Alternative alt(nBranches=3)
    "Alternative: Tank charging or plant outputting CHW"
    annotation (Placement(transformation(extent={{0,-100},{378,100}})));
  Modelica.Blocks.Interfaces.RealOutput yVal "Valve normalised mass flow rate"
    annotation (Placement(transformation(extent={{580,-80},{600,-60}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Interfaces.RealInput yPum(final unit="1")
    "Normalised speed signal for pump"
                              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,100}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,100})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiSecPum
    annotation (Placement(transformation(extent={{460,-20},{480,0}})));
  Modelica.Blocks.Sources.Constant zero(final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{420,-50},{440,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal swiVal(realTrue=
        mTan_flow_nominal, realFalse=0) "Switch for valve flow"
    annotation (Placement(transformation(extent={{460,-80},{480,-60}})));
  Modelica.Blocks.Interfaces.BooleanInput tanSta[3]
    "Tank status - 1: is depleted; 2: is cooled; 3: is overcooled" annotation (
      Placement(transformation(extent={{-120,-10},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
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
    annotation (Line(points={{441,50},{458,50}}, color={255,0,255}));
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
    annotation (Line(points={{590,50},{482,50}}, color={0,0,127}));
  connect(traTanOut.inPort, alt.split[2]) annotation (Line(points={{186,-30},{
          40,-30},{40,1.06581e-14},{39.69,1.06581e-14}}, color={0,0,0}));
  connect(traChiOut.inPort, alt.split[3]) annotation (Line(points={{186,-70},{
          40,-70},{40,33.3333},{39.69,33.3333}}, color={0,0,0}));
  connect(traRes3.outPort, alt.join[2]) annotation (Line(points={{271.5,-30},{
          338.31,-30},{338.31,0}}, color={0,0,0}));
  connect(traRes4.outPort, alt.join[3]) annotation (Line(points={{271.5,-70},{
          338,-70},{338,33.3333},{338.31,33.3333}}, color={0,0,0}));
  connect(expSecPum.y, swiSecPum.u2)
    annotation (Line(points={{441,-10},{458,-10}}, color={255,0,255}));
  connect(swiSecPum.u1, yPum) annotation (Line(points={{458,-2},{450,-2},{450,
          24},{400,24},{400,114},{-80,114},{-80,100},{-110,100}}, color={0,0,
          127}));
  connect(ySecPum, swiSecPum.y)
    annotation (Line(points={{590,-10},{482,-10}}, color={0,0,127}));
  connect(zero.y, swiSecPum.u3) annotation (Line(points={{441,-40},{450,-40},{
          450,-18},{458,-18}}, color={0,0,127}));
  connect(swiVal.u, expVal.y)
    annotation (Line(points={{458,-70},{441,-70}}, color={255,0,255}));
  connect(swiVal.y, yVal)
    annotation (Line(points={{482,-70},{590,-70}}, color={0,0,127}));
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
          lineColor={0,0,0})}),
Documentation(info="<html>
<p>
This block implements a finite state machine to control the flows of the
storage plant.
The system transitions among the following states:
</p>
<ul>
<li>
All Off - The system is off. No flow rate at the primary pump,
the secondary pump, or the tank.
</li>
<li>
Charge Tank - The tank is ready to be charged.
The transition into this state fires when the tank receives a charge command
AND the tank is not full.
<ul>
<li>
Local Charging - The local chiller charges the tank.
The transition into this state fires when the local chiller is available.
Its outward transition fires when the condition of either of the two prior
transitions becomes false.
</li>
<li>
Remote Charging - The tank is charged by the district network while
the local chiller is shut off.
The transition into this state fires when the local chiller is offline.
Its outward transition fires when the condition of either of the two prior
transitions becomes false.
</li>
</ul>
</li>
<li>
Tank Output - The tank outputs CHW to the district network.
The transition into this state fires when the district network has sufficient
load AND the tank receives a discharge command AND the tank is not depleted.
Its outward transition fires when the condition above becomes false.
</li>
<li>
Chiller Output - The chiller outputs CHW to the district network.
The transition into this state fires when the district network has sufficient
load AND the tank is unavailable (no discharge command OR is depleted)
AND the chiller is available.
Its outward transition fires when the condition above becomes false.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
February 23, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end FlowControl;
