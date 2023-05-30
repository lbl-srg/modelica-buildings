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

  Modelica.Blocks.Interfaces.IntegerInput com
    "Command: 1 = charge tank, 2 = hold tank, 3 = discharge from tank"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Interfaces.BooleanInput chiEnaSta
    "Chiller enable status, true if chiller is enabled"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealOutput mPriPum_flow
    "Primary pump mass flow rate"
    annotation (Placement(transformation(extent={{780,40},{800,60}}),
                       iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput ySecPum
    "Secondary pump normalised speed" annotation (Placement(transformation(
          extent={{780,-20},{800,0}}), iconTransformation(extent={{100,-10},{
            120,10}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.StateGraph.InitialStep allOff(nOut=1, nIn=1) "Initial step, all off"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput hasLoa "True: Has load"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
  Modelica.StateGraph.Transition traChaLoc(condition=com == 1 and (not tanSta[2])
         and chiEnaSta)
    "Transition: Charge tank command AND tank not cooled AND chiller enabled"
    annotation (Placement(transformation(extent={{260,60},{280,80}})));
  Modelica.StateGraph.Step steChaLoc(nIn=1, nOut=1) "Step: Local charging"
    annotation (Placement(transformation(extent={{300,60},{320,80}})));
  Modelica.StateGraph.Transition traRes1(condition=not traChaLoc.condition)
                                       "Transition: Reset to initial step"
    annotation (Placement(transformation(extent={{340,60},{360,80}})));
  Modelica.StateGraph.Transition traChaRem(condition=com == 1 and (not tanSta[2])
         and not chiEnaSta)
    "Transition: Charge tank command AND tank not cooled AND chiller not enabled"
    annotation (Placement(transformation(extent={{260,20},{280,40}})));
  Modelica.StateGraph.Step steChaRem(nIn=1, nOut=1) "Step: Remote charging"
    annotation (Placement(transformation(extent={{300,20},{320,40}})));
  Modelica.StateGraph.Transition traRes2(condition=not traChaRem.condition)
                                       "Transition: Reset to initial step"
    annotation (Placement(transformation(extent={{340,20},{360,40}})));
  Modelica.StateGraph.Transition traProChi(condition=chiEnaSta)
    "Transition: Chiller enabled"
    annotation (Placement(transformation(extent={{260,-160},{280,-140}})));
  Modelica.StateGraph.Step steProChi(nIn=2, nOut=2)
    "Step: Chiller produces CHW"
    annotation (Placement(transformation(extent={{300,-160},{320,-140}})));
  Modelica.StateGraph.Transition traRes4(condition=not traPro.condition)
    "Transition: Reset to initial step"
    annotation (Placement(transformation(extent={{340,-160},{360,-140}})));
  Modelica.StateGraph.Transition traProTan(condition=(com == 3 and (not tanSta[
        1])) or tanSta[3])
    "Transition: Tank commanded to discharge and is not depleted, or the tank is overcooled"
    annotation (Placement(transformation(extent={{260,-80},{280,-60}})));
  Modelica.StateGraph.Step steProTan(nIn=2, nOut=2) "Step: Tank produces CHW"
    annotation (Placement(transformation(extent={{300,-80},{320,-60}})));
  Modelica.StateGraph.Transition traRes3(condition=not traPro.condition)
    "Transition: Reset to initial step"
    annotation (Placement(transformation(extent={{340,-80},{360,-60}})));
  Modelica.Blocks.Sources.BooleanExpression expPriPumFlo(
    y=steChaLoc.active or steProChi.active)
                          "Expression for local charging OR chiller output"
    annotation (Placement(transformation(extent={{700,40},{720,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal swiPriPum(realTrue=
        mChi_flow_nominal, realFalse=0) "Switch for primary pump flow"
    annotation (Placement(transformation(extent={{740,40},{760,60}})));
  Modelica.Blocks.Sources.BooleanExpression expSecPum(y=stePumSecOn.active)
                          "Expression for tank output or chiller output"
    annotation (Placement(transformation(extent={{700,-20},{720,0}})));
  Modelica.Blocks.Sources.BooleanExpression expVal(y=steChaRem.active)
    "Boolean expression for remotely charging the tank"
    annotation (Placement(transformation(extent={{700,-80},{720,-60}})));
  Modelica.StateGraph.Alternative alt(nBranches=3)
    "Alternative: Tank charging or plant outputting CHW"
    annotation (Placement(transformation(extent={{-8,-200},{646,100}})));
  Modelica.Blocks.Interfaces.RealOutput yVal "Valve normalised mass flow rate"
    annotation (Placement(transformation(extent={{780,-80},{800,-60}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Interfaces.RealInput yPum(final unit="1")
    "Normalised speed signal for the secondary pump"
                              annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,130}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,80})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiSecPum
    "Switch for secondary pump flow"
    annotation (Placement(transformation(extent={{740,-20},{760,0}})));
  Modelica.Blocks.Sources.Constant zer(final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{700,-50},{720,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal swiVal(realTrue=
        mTan_flow_nominal, realFalse=0) "Switch for valve flow"
    annotation (Placement(transformation(extent={{740,-80},{760,-60}})));
  Modelica.Blocks.Interfaces.BooleanInput tanSta[3]
    "Tank status - 1: is depleted; 2: is cooled; 3: is overcooled" annotation (
      Placement(transformation(extent={{-120,-130},{-100,-110}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));
  Modelica.StateGraph.Step stePumSecOn(nOut=1, nIn=1) "Step: Secondary pump on"
    annotation (Placement(transformation(extent={{300,-40},{320,-20}})));
  Modelica.StateGraph.Transition traPro(condition=hasLoa and (traProTan.condition
         or traProChi.condition))
    "Transition: Has load and the plant can produce CHW via either the chiller or the tank"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Modelica.StateGraph.Parallel parallel(nBranches=2)
    annotation (Placement(transformation(extent={{116,-174},{510,-6}})));
  Modelica.StateGraph.Transition traTanToChi(condition=(tanSta[1] or (com <> 3
         and not tanSta[3])) and chiEnaSta)
    "Transition: Tank is depleted OR tank is no longer overcooled while no discharge command, AND chiller enabled"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={290,-110})));
  Modelica.StateGraph.Alternative altTanCha1(nBranches=2)
    "Alternative: Tank charging locally or remotely"
    annotation (Placement(transformation(extent={{222,-170},{398,-50}})));
  Modelica.StateGraph.Step steRou1(nIn=1, nOut=1) "A step for routing only"
    annotation (Placement(transformation(extent={{180,-120},{200,-100}})));
  Modelica.StateGraph.Step steRou2(nIn=1, nOut=1) "A step for routing only"
    annotation (Placement(transformation(extent={{420,-120},{440,-100}})));
  Modelica.StateGraph.Transition traRou(final condition=true)
    "A routing transition, always true"
    annotation (Placement(transformation(extent={{540,-100},{560,-80}})));
  Modelica.StateGraph.Transition traChiToTan(condition=traProTan.condition)
    "Transition: Tank takes priority when it can produce CHW" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={330,-110})));
equation
  connect(traChaLoc.outPort,steChaLoc. inPort[1])
    annotation (Line(points={{271.5,70},{299,70}}, color={0,0,0}));
  connect(steChaLoc.outPort[1], traRes1.inPort)
    annotation (Line(points={{320.5,70},{346,70}}, color={0,0,0}));
  connect(traChaRem.outPort,steChaRem. inPort[1])
    annotation (Line(points={{271.5,30},{299,30}}, color={0,0,0}));
  connect(steChaRem.outPort[1], traRes2.inPort)
    annotation (Line(points={{320.5,30},{346,30}}, color={0,0,0}));
  connect(traProChi.outPort,steProChi. inPort[1])
    annotation (Line(points={{271.5,-150},{286,-150},{286,-150.25},{299,-150.25}},
                                                     color={0,0,0}));
  connect(steProChi.outPort[1], traRes4.inPort)
    annotation (Line(points={{320.5,-150.125},{334,-150.125},{334,-150},{346,-150}},
                                                     color={0,0,0}));
  connect(traProTan.outPort,steProTan. inPort[1])
    annotation (Line(points={{271.5,-70},{286,-70},{286,-70.25},{299,-70.25}},
                                                     color={0,0,0}));
  connect(steProTan.outPort[1], traRes3.inPort)
    annotation (Line(points={{320.5,-70.125},{334,-70.125},{334,-70},{346,-70}},
                                                     color={0,0,0}));
  connect(expPriPumFlo.y, swiPriPum.u)
    annotation (Line(points={{721,50},{738,50}}, color={255,0,255}));
  connect(alt.inPort, allOff.outPort[1])
    annotation (Line(points={{-17.81,-50},{-39.5,-50}},
                                                   color={0,0,0}));
  connect(alt.outPort, allOff.inPort[1]) annotation (Line(points={{652.54,-50},{
          652.54,114},{-80,114},{-80,-50},{-61,-50}},
                                                   color={0,0,0}));
  connect(mPriPum_flow, swiPriPum.y)
    annotation (Line(points={{790,50},{762,50}}, color={0,0,127}));
  connect(expSecPum.y, swiSecPum.u2)
    annotation (Line(points={{721,-10},{738,-10}}, color={255,0,255}));
  connect(swiSecPum.u1, yPum) annotation (Line(points={{738,-2},{730,-2},{730,
          20},{680,20},{680,130},{-110,130}},                     color={0,0,
          127}));
  connect(ySecPum, swiSecPum.y)
    annotation (Line(points={{790,-10},{762,-10}}, color={0,0,127}));
  connect(zer.y, swiSecPum.u3)
    annotation (Line(points={{721,-40},{738,-40},{738,-18}}, color={0,0,127}));
  connect(swiVal.u, expVal.y)
    annotation (Line(points={{738,-70},{721,-70}}, color={255,0,255}));
  connect(swiVal.y, yVal)
    annotation (Line(points={{762,-70},{790,-70}}, color={0,0,127}));
  connect(traPro.outPort, parallel.inPort)
    annotation (Line(points={{91.5,-90},{110.09,-90}},color={0,0,0}));
  connect(parallel.split[1], stePumSecOn.inPort[1]) annotation (Line(points={{160.325,
          -111},{160.325,-70},{160,-70},{160,-30},{299,-30}},
                                                   color={0,0,0}));
  connect(stePumSecOn.outPort[1], parallel.join[1]) annotation (Line(points={{320.5,
          -30},{466,-30},{466,-111},{465.675,-111}}, color={0,0,0}));
  connect(steProTan.outPort[2], traTanToChi.inPort) annotation (Line(points={{320.5,
          -69.875},{320,-69.875},{320,-70},{326,-70},{326,-100},{290,-100},{290,
          -106}},
        color={0,0,0}));
  connect(traTanToChi.outPort, steProChi.inPort[2]) annotation (Line(points={{290,
          -111.5},{290,-149.75},{299,-149.75}},     color={0,0,0}));
  connect(traProTan.inPort, altTanCha1.split[1]) annotation (Line(points={{266,-70},
          {240,-70},{240,-98},{240.48,-98},{240.48,-125}},
                                                      color={0,0,0}));
  connect(traRes3.outPort, altTanCha1.join[1]) annotation (Line(points={{351.5,-70},
          {379.52,-70},{379.52,-125}},                color={0,0,0}));
  connect(traProChi.inPort, altTanCha1.split[2]) annotation (Line(points={{266,-150},
          {240,-150},{240,-106},{240.48,-106},{240.48,-95}},
                                                      color={0,0,0}));
  connect(traRes4.outPort, altTanCha1.join[2]) annotation (Line(points={{351.5,-150},
          {379.52,-150},{379.52,-95}},                              color={0,0,
          0}));
  connect(steRou1.outPort[1], altTanCha1.inPort)
    annotation (Line(points={{200.5,-110},{219.36,-110}}, color={0,0,0}));
  connect(altTanCha1.outPort,steRou2. inPort[1])
    annotation (Line(points={{399.76,-110},{419,-110}}, color={0,0,0}));
  connect(steRou1.inPort[1], parallel.split[2]) annotation (Line(points={{179,-110},
          {160,-110},{160,-70},{160.325,-70},{160.325,-69}}, color={0,0,0}));
  connect(steRou2.outPort[1], parallel.join[2]) annotation (Line(points={{440.5,
          -110},{465.675,-110},{465.675,-69}}, color={0,0,0}));
  connect(parallel.outPort, traRou.inPort)
    annotation (Line(points={{513.94,-90},{546,-90}}, color={0,0,0}));
  connect(steProChi.outPort[2], traChiToTan.inPort) annotation (Line(points={{320.5,
          -149.875},{330,-149.875},{330,-114}}, color={0,0,0}));
  connect(traChiToTan.outPort, steProTan.inPort[2]) annotation (Line(points={{330,
          -108.5},{330,-92},{290,-92},{290,-69.75},{299,-69.75}}, color={0,0,0}));
  connect(traChaLoc.inPort, alt.split[1]) annotation (Line(points={{266,70},{60,
          70},{60,-100},{60.67,-100}},   color={0,0,0}));
  connect(traChaRem.inPort, alt.split[2]) annotation (Line(points={{266,30},{60.67,
          30},{60.67,-50}},         color={0,0,0}));
  connect(traRes1.outPort, alt.join[1]) annotation (Line(points={{351.5,70},{578,
          70},{578,-100},{577.33,-100}},       color={0,0,0}));
  connect(traRes2.outPort, alt.join[2]) annotation (Line(points={{351.5,30},{577.33,
          30},{577.33,-50}},          color={0,0,0}));
  connect(traPro.inPort, alt.split[3]) annotation (Line(points={{86,-90},{60.67,
          -90},{60.67,1.42109e-14}},
                             color={0,0,0}));
  connect(traRou.outPort, alt.join[3]) annotation (Line(points={{551.5,-90},{576,
          -90},{576,1.42109e-14},{577.33,1.42109e-14}},
                                            color={0,0,0}));
  annotation (Diagram(coordinateSystem(extent={{-100,-220},{780,140}})), Icon(
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
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{58,-40},{40,-20},{40,-60},{58,-40}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,-20},{-20,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{-22,-40},{-40,-20},{-40,-60},{-22,-40}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,-42},{2,-80}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}),
Documentation(info="<html>
<p>
This block implements a state graph to control the flows of the storage plant.
The system transitions among the following states:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<thead>
  <tr>
    <th>Step</th>
    <th>Description</th>
    <th>Transition in</th>
    <th>Transition out</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>All Off<br>(Initial Step)</td>
    <td>All off. This is the initial step.</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Local Charging</td>
    <td>Charge the tank with the local chiller.</td>
    <td>\"Charge tank\" command<br>AND tank is not cooled yet<br>AND chiller is online.<br>This transition takes priority<br>over the one below.<sup>1</sup></td>
    <td>The in-transition condition becomes false.</td>
  </tr>
  <tr>
    <td>Remote Charging</td>
    <td>Charge the tank with the remote chiller.</td>
    <td>Same as above except that<br>the chiller is offline.</td>
    <td>The in-transition condition becomes false.</td>
  </tr>
  <tr>
    <td>Secondary Pump On</td>
    <td>Turn on the secondary pump.<br>This step is in parallel with the two below.<sup>2</sup></td>
    <td>The district has load AND<br>the additional conditions of<br>either step below become true.</td>
    <td>Implicit, when both steps below are no longer active.</td>
  </tr>
  <tr>
    <td rowspan=\"2\">Tank Producing</td>
    <td rowspan=\"2\">The tank produces CHW to the district.<br>This step is in parallel with \"secondary pump on\".</td>
    <td rowspan=\"2\">The district has load AND<br>any one of:<br>(a) \"Tank produce\" command<br>AND tank not depleted;<br>(b) Tank is overcooled.<br>This transition takes priority<br>over the one below.</td>
    <td>To initial step: No load OR the in-transition conditions<br>of \"tank producing\" and \"chiller producing\" are both false.<br>This transition takes priority over the one below.</td>
  </tr>
  <tr>
    <td>To \"chiller producing\": Chiller is online AND any one of:<br>(a) Tank is depleted;<br>(b) No \"tank produce\" command AND tank not overcooled.</td>
  </tr>
  <tr>
    <td rowspan=\"2\">Chiller Producing</td>
    <td rowspan=\"2\">The chiller produces CHW to the district.<br>This step is in parallel with \"secondary pump on\".</td>
    <td rowspan=\"2\">The district has load AND<br>the chiller is online.</td>
    <td>To initial step: No load OR the in-transition conditions<br>of \"tank producing\" and \"chiller producing\" are both false.<br>This transition takes priority over the one below.</td>
  </tr>
  <tr>
    <td>To \"tank producing\": The condition for in-transition of<br>\"tank producing\" becomes true.</td>
  </tr>
</tbody>
</table>
<p>
Notes:
</p>
<ol>
<li>
Out-transitions from the same step have priorities. When the conditions of
more than one of them become true, the transition connected by a connector
with the lowest index in the array fires.
For example, even when the in-transition condition of \"chiller producing\"
becomes true, as long as the in-transition condition of \"tank producing\"
is also true, it will not fire because of priority.
</li>
<li>
Steps that are in parallel are active at the same time.
When \"secondary pump on\" is active, either \"tank producing\"
or \"chiller producing\" is also active.
</li>
</ol>
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
