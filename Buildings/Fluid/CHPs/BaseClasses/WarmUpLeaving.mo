within Buildings.Fluid.CHPs.BaseClasses;
model WarmUpLeaving
  "Model evaluating the condition for transitioning from warm-up to normal mode"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Time timeDelayStart
    "Time delay between activation and power generation";
  parameter Modelica.SIunits.Temperature TEngNom
    "Nominal engine operating temperature";
  parameter Boolean warmUpByTimeDelay
    "If true, the plant will be in warm-up mode depending on the delay time,
    otherwise depending on engine temperature "
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEng(
    final unit="K",
    displayUnit="degC") if not warmUpByTimeDelay
    "Engine temperature"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y "Transition signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Controls.OBC.CDL.Interfaces.BooleanInput actWarUp
    "Warm-up state active signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Controls.OBC.CDL.Interfaces.RealInput PEle(final unit="W") if
    not warmUpByTimeDelay
    "Power demand"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Controls.OBC.CDL.Interfaces.RealInput PEleNet(final unit="W") if
    not warmUpByTimeDelay
    "Net power output"
    annotation (Placement(transformation(extent={{-140,-60},{
      -100,-20}}), iconTransformation(extent={{-140,-40},{-100,0}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Timer timer if warmUpByTimeDelay
    "Count the time since the warm-up mode is activated"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold timeDel(
    final threshold=timeDelayStart) if warmUpByTimeDelay
    "Check if it has been in warm-up mode by longer than specified time"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysteresis(
    uLow=-0.5,
    uHigh=0) if not warmUpByTimeDelay
    "Check if actual engine temperature is higher than norminal value"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add(final k2=-1) if
    not warmUpByTimeDelay
    "Difference between actual engine temperature and nominal value"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant temEngNom(
    y(final unit="K", displayUnit="degC"),
    final k=TEngNom)
    "Nominal engine temperature"
    annotation (Placement(transformation(extent={{-88,-30},{-68,-10}})));
  Controls.OBC.CDL.Continuous.Add add1(final k2=-1) if
    not warmUpByTimeDelay
    "Difference between actual power output and demand"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysteresis1(uLow=-5,
    uHigh=0) if not warmUpByTimeDelay
    "Check if actual power output is higher than demand"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Controls.OBC.CDL.Logical.Or or2 if not warmUpByTimeDelay "OR evaluation"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Controls.OBC.CDL.Logical.Pre pre if not warmUpByTimeDelay
    "Infinitesimal time delay to break algebraic loop related to power output computation"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
equation
  connect(add.y, hysteresis.u) annotation (Line(points={{-28,0},{-12,0}},
          color={0,0,127}));
  connect(TEng, add.u1) annotation (Line(points={{-120,20},{-80,20},{-80,6},{-52,
          6}},     color={0,0,127}));
  connect(temEngNom.y, add.u2) annotation (Line(points={{-66,-20},{-60,-20},{-60,
          -6},{-52,-6}},
                    color={0,0,127}));
  connect(actWarUp, timer.u)
    annotation (Line(points={{-120,60},{-82,60}},   color={255,0,255}));
  connect(timer.y, timeDel.u)
    annotation (Line(points={{-58,60},{-42,60}},   color={0,0,127}));
  connect(add1.y, hysteresis1.u)
    annotation (Line(points={{-28,-60},{-12,-60}}, color={0,0,127}));
  connect(PEle, add1.u2) annotation (Line(points={{-120,-80},{-80,-80},{-80,-66},
          {-52,-66}}, color={0,0,127}));
  connect(hysteresis.y, or2.u1) annotation (Line(points={{12,0},{20,0},{20,-20},
          {28,-20}}, color={255,0,255}));
  connect(hysteresis1.y, or2.u2) annotation (Line(points={{12,-60},{20,-60},{20,
          -28},{28,-28}}, color={255,0,255}));
  connect(timeDel.y, y) annotation (Line(points={{-18,60},{80,60},{80,0},{120,0}},
        color={255,0,255}));
  connect(or2.y, pre.u)
    annotation (Line(points={{52,-20},{58,-20}}, color={255,0,255}));
  connect(pre.y, y) annotation (Line(points={{82,-20},{90,-20},{90,0},{120,0}},
        color={255,0,255}));
  connect(PEleNet, add1.u1) annotation (Line(points={{-120,-40},{-80,-40},{-80,
          -54},{-52,-54}}, color={0,0,127}));
annotation (defaultComponentName="warUpCtr", Documentation(info="<html>
<p>
The model computes a boolean variable which is true when warm-up
is over.
CHP will transition from the warm-up mode to the normal mode after the specified
time delay (if <code>warmUpByTimeDelay</code> is true),
or when <code>TEng</code> is higher than <code>TEngNom</code>
(if <code>warmUpByTimeDelay</code> is false).
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end WarmUpLeaving;
