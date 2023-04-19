within Buildings.Fluid.Storage.Plant.Controls;
block TankStatus "Block that returns the status of the tank"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Temperature TLow
    "Lower temperature threshold";
  parameter Modelica.Units.SI.Temperature THig
    "Higher temperature threshold";
  parameter Modelica.Units.SI.TemperatureDifference dTUnc = 0.1
    "Temperature sensor uncertainty";
  parameter Modelica.Units.SI.TemperatureDifference dTHys = 1
    "Deadband for hysteresis";

  Modelica.Blocks.Interfaces.RealInput TTan[2](
    each final quantity="Temperature",
    each displayUnit="C")
    "Temperatures at the tank 1: top and 2: bottom" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));

  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.StateGraph.InitialStep iniSte(nOut=1, nIn=1)
    "Initial step, also active when none of the other steps apply"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.StateGraph.Transition traDep(condition=TTan[2] > THig - dTUnc)
    "Transition: Tank is depleted"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.StateGraph.Transition traCoo(condition=TTan[1] < TLow + dTHys)
    "Transition: Tank is cooled"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.StateGraph.StepWithSignal steDep(nIn=1, nOut=1)
    "Step: Tank is depleted"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Modelica.StateGraph.Alternative altDepOrCoo(nBranches=2)
    "Alternative: Tank is depleted or cooled"
    annotation (Placement(transformation(extent={{-18,-120},{338,60}})));
  Modelica.StateGraph.StepWithSignal steCoo(nIn=1, nOut=1)
    "Step: Tank is cooled"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Modelica.StateGraph.Alternative altOveCoo(nBranches=2)
    "Alternative: Reset or tank is overcooled"
    annotation (Placement(transformation(extent={{112,-100},{276,0}})));
  Modelica.StateGraph.Transition traRes1(condition=TTan[2] < THig - dTHys)
    "Transition: Reset to initial step"
    annotation (Placement(transformation(extent={{180,20},{200,40}})));
  Modelica.StateGraph.Transition traCoo2(condition=TTan[1] < TLow + dTUnc)
    "Transition: Tank is cooled"
    annotation (Placement(transformation(extent={{140,-80},{160,-60}})));
  Modelica.StateGraph.Transition traRes2(condition=TTan[1] > TLow + dTHys*2)
    "Transition: Reset to initial step"
    annotation (Placement(transformation(extent={{180,-40},{200,-20}})));
  Modelica.StateGraph.StepWithSignal steOveCoo(nIn=1, nOut=1)
    "Step: Tank is overcooled (and is still cooled)"
    annotation (Placement(transformation(extent={{180,-80},{200,-60}})));
  Modelica.StateGraph.Transition traRes3(condition=traRes2.condition)
    "Transition: Reset to initial step"
    annotation (Placement(transformation(extent={{220,-80},{240,-60}})));
  Modelica.Blocks.Interfaces.BooleanOutput y[3]
    "Tank status - 1: is depleted; 2: is cooled; 3: is overcooled"
    annotation (Placement(transformation(extent={{440,-10},{460,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Or"
    annotation (Placement(transformation(extent={{380,-10},{400,10}})));
equation
  connect(iniSte.outPort[1], altDepOrCoo.inPort)
    annotation (Line(points={{-39.5,-30},{-23.34,-30}}, color={0,0,0}));
  connect(traDep.inPort, altDepOrCoo.split[1]) annotation (Line(points={{46,30},
          {19.38,30},{19.38,-52.5}}, color={0,0,0}));
  connect(traCoo.inPort, altDepOrCoo.split[2]) annotation (Line(points={{46,-50},
          {19.38,-50},{19.38,-7.5}}, color={0,0,0}));
  connect(traDep.outPort, steDep.inPort[1])
    annotation (Line(points={{51.5,30},{79,30}}, color={0,0,0}));
  connect(steDep.outPort[1], traRes1.inPort)
    annotation (Line(points={{100.5,30},{186,30}}, color={0,0,0}));
  connect(traRes1.outPort, altDepOrCoo.join[1]) annotation (Line(points={{191.5,
          30},{300.62,30},{300.62,-52.5}}, color={0,0,0}));
  connect(steCoo.outPort[1], altOveCoo.inPort)
    annotation (Line(points={{100.5,-50},{109.54,-50}}, color={0,0,0}));
  connect(traCoo.outPort, steCoo.inPort[1])
    annotation (Line(points={{51.5,-50},{79,-50}}, color={0,0,0}));
  connect(traRes2.inPort, altOveCoo.split[1]) annotation (Line(points={{186,-30},
          {129.22,-30},{129.22,-62.5}}, color={0,0,0}));
  connect(traRes2.outPort, altOveCoo.join[1]) annotation (Line(points={{191.5,-30},
          {258.78,-30},{258.78,-62.5}}, color={0,0,0}));
  connect(altOveCoo.outPort, altDepOrCoo.join[2]) annotation (Line(points={{277.64,
          -50},{300.62,-50},{300.62,-7.5}}, color={0,0,0}));
  connect(traCoo2.inPort, altOveCoo.split[2]) annotation (Line(points={{146,-70},
          {129.22,-70},{129.22,-37.5}}, color={0,0,0}));
  connect(steOveCoo.inPort[1], traCoo2.outPort)
    annotation (Line(points={{179,-70},{151.5,-70}}, color={0,0,0}));
  connect(steOveCoo.outPort[1], traRes3.inPort)
    annotation (Line(points={{200.5,-70},{226,-70}}, color={0,0,0}));
  connect(traRes3.outPort, altOveCoo.join[2]) annotation (Line(points={{231.5,-70},
          {258.78,-70},{258.78,-37.5}}, color={0,0,0}));
  connect(altDepOrCoo.outPort, iniSte.inPort[1]) annotation (Line(points={{341.56,
          -30},{350,-30},{350,68},{-66,68},{-66,-30},{-61,-30}}, color={0,0,0}));
  connect(steDep.active, y[1]) annotation (Line(points={{90,19},{90,8},{340,8},{
          340,20},{420,20},{420,0},{450,0},{450,-3.33333}}, color={255,0,255}));
  connect(or2.y, y[2])
    annotation (Line(points={{402,0},{450,0}}, color={255,0,255}));
  connect(steOveCoo.active, y[3]) annotation (Line(points={{190,-81},{190,-136},
          {420,-136},{420,0},{450,0},{450,3.33333}}, color={255,0,255}));
  connect(steOveCoo.active, or2.u1) annotation (Line(points={{190,-81},{190,
          -124},{364,-124},{364,0},{378,0}}, color={255,0,255}));
  connect(steCoo.active, or2.u2) annotation (Line(points={{90,-61},{90,-130},{
          370,-130},{370,-8},{378,-8}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-40,72},{42,-72}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-28,-64},{30,-28}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-28,-20},{30,16}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-22,54},{24,30}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}), Diagram(coordinateSystem(extent={{-100,-140},
            {440,100}})),
    defaultComponentName="tanSta",
    Documentation(info="<html>
<p>
This block outputs tank status signals using the temperature signals
from the storage tank top (<i>T<sub>1</sub></i>) and the bottom
(<i>T<sub>2</sub></i>). The status is output as an array of three boolean
signals indicating whether the tank is (1) depleted, (2) cooled, and
(3) overcooled.
</p>
<p>
This block is implemented as a state graph with transition conditions
listed in the table below. Note that when the \"overcooled\" step is active,
the tank is considered both \"cooled\" and \"overcooled\".
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
    <td>Initial Step</td>
    <td>Initial step of the system or when none of the other steps apply</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Depleted</td>
    <td>The chill in the tank is depleted. The tank is warm.</td>
    <td><i>T<sub>2</sub> &gt; T<sub>Hig</sub> - &Delta; T<sub>Unc</sub></i></td>
    <td><i>T<sub>2</sub> &lt; T<sub>Hig</sub> - &Delta; T<sub>Hys</sub></i></td>
  </tr>
  <tr>
    <td>Cooled</td>
    <td>The tank is cooled, but there is still capacity left for further chilling.</td>
    <td><i>T<sub>1</sub> &lt; T<sub>Low</sub> + &Delta; T<sub>Hys</sub></i></td>
    <td><i>T<sub>1</sub> &gt; T<sub>Low</sub> + &Delta; T<sub>Hys</sub>*2</i></td>
  </tr>
  <tr>
    <td>Overcooled</td>
    <td>The tank is cooled to the maximum of its capacity.</td>
    <td><i>T<sub>1</sub> &lt; T<sub>Low</sub> + &Delta; T<sub>Unc</sub></i></td>
    <td><i>T<sub>1</sub> &gt; T<sub>Low</sub> + &Delta; T<sub>Hys</sub>*2</i></td>
  </tr>
</tbody>
</table>
</html>"),
revisions="<html>
<ul>
<li>
April 19, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>");
end TankStatus;
