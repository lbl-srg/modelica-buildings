within Buildings.Fluid.CHPs.BaseClasses;
model WarmUp "Warm-up operating mode"
  extends Modelica.StateGraph.PartialCompositeStep;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-148,-148},{-128,-128}})));
  Modelica.StateGraph.Interfaces.Step_in inPort1
    annotation (Placement(transformation(extent={{-170,-70},{-150,-90}})));
  Modelica.Blocks.Interfaces.RealInput TEng(unit="K") "Engine temperature"
    annotation (Placement(transformation(
        origin={-160,80},
        extent={{10,-10},{-10,10}},
        rotation=180)));
  Modelica.Blocks.Interfaces.BooleanOutput y "Transition signal" annotation (
      Placement(transformation(extent={{150,-86},{170,-66}}),
        iconTransformation(extent={{150,-88},{170,-68}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Modelica.Blocks.Logical.Xor xor
    annotation (Placement(transformation(extent={{120,-86},{140,-66}})));
  Modelica.StateGraph.StepWithSignal warmUpState(nIn=2)
    annotation (Placement(transformation(extent={{-40,-16},{-8,16}})));
protected
  Modelica.Blocks.Logical.Timer timer
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold timeDel(threshold=per.timeDelayStart)
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Blocks.Sources.BooleanExpression timDelMod(y=per.warmUpByTimeDelay)
    "Check if warm-up by time delay"
    annotation (Placement(transformation(extent={{0,-74},{38,-42}})));
  Modelica.Blocks.Sources.BooleanExpression engTemMod(y=not per.warmUpByTimeDelay)
    "Check if warm-up by engine temperature"
    annotation (Placement(transformation(extent={{0,-156},{36,-124}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=0.5, uHigh=1)
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Modelica.Blocks.Math.Add add(k2=-1)
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Modelica.Blocks.Sources.Constant const(k=per.TEngNom)
    "Nominal engine temperature"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
equation
  connect(warmUpState.active, timer.u) annotation (Line(points={{-24,-17.6},{-24,
          -30},{-2,-30}}, color={255,0,255}));
  connect(timer.y, timeDel.u)
    annotation (Line(points={{21,-30},{38,-30}}, color={0,0,255}));
  connect(inPort, warmUpState.inPort[1]) annotation (Line(points={{-160,0},{-88,
          0},{-88,0.8},{-41.6,0.8}}, color={0,0,0}));
  connect(warmUpState.outPort[1], outPort)
    annotation (Line(points={{-7.2,0},{155,0}}, color={0,0,0}));
  connect(inPort1, warmUpState.inPort[2]) annotation (Line(points={{-160,-80},{-130,
          -80},{-130,0},{-74,0},{-74,-0.8},{-41.6,-0.8}}, color={0,0,0}));
  connect(xor.y, y)
    annotation (Line(points={{141,-76},{160,-76}}, color={255,0,255}));
  connect(timeDel.y, and1.u1) annotation (Line(points={{61,-30},{72,-30},{72,-50},
          {78,-50}}, color={255,0,255}));
  connect(timDelMod.y, and1.u2)
    annotation (Line(points={{39.9,-58},{78,-58}}, color={255,0,255}));
  connect(and1.y, xor.u1) annotation (Line(points={{101,-50},{110,-50},{110,-76},
          {118,-76}}, color={255,0,255}));
  connect(hysteresis.y, and2.u1)
    annotation (Line(points={{61,-110},{78,-110}}, color={255,0,255}));
  connect(and2.u2, engTemMod.y) annotation (Line(points={{78,-118},{70,-118},{70,
          -140},{37.8,-140}}, color={255,0,255}));
  connect(and2.y, xor.u2) annotation (Line(points={{101,-110},{108,-110},{108,-84},
          {118,-84}}, color={255,0,255}));
  connect(add.y, hysteresis.u)
    annotation (Line(points={{21,-110},{38,-110}}, color={0,0,127}));
  connect(TEng, add.u1) annotation (Line(points={{-160,80},{-60,80},{-60,-104},{
          -2,-104}}, color={0,0,127}));
  connect(const.y, add.u2) annotation (Line(points={{-19,-130},{-10,-130},{-10,
          -116},{-2,-116}},
                      color={0,0,127}));
  annotation (defaultComponentName="warUp", Documentation(info="<html>
<p>
The model defines the warm-up operating mode. 
CHP will transition from the warm-up mode to the normal mode after the specified time delay (if <i>per.warmUpByTimeDelay = true</i>) 
or when <i>TEng</i> is higher than <i>per.TEngNom</i> (if <i>per.warmUpByTimeDelay = false</i>). 
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end WarmUp;
