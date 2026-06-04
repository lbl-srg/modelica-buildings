within Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses;
block UpdateEnableState
  parameter Integer nEqu
    "Number of equipment"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nEqu]
    "Equipment available signal"
    annotation(Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta
    "Stage index"
    annotation(Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nEqu]
    "Equipment enable command"
    annotation(Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Detect stage index change"
    annotation(Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1Pre[nEqu]
    "Left limit of signal in discrete time"
    annotation(Placement(transformation(extent={{72,-90},{52,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nEqu]
    "Switch to newly computed value at stage change"
    annotation(Placement(transformation(extent={{50,10},{70,30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(
    final nout=nEqu)
    "Replicate signal"
    annotation(Placement(transformation(extent={{10,10},{30,30}})));
  Utilities.CountTrue nEnaAvaPre(nin=nEqu)
    "Count the number of previously enabled equipment that are available"
    annotation(Placement(transformation(extent={{-8,-90},{-28,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Equal   intEqu
    "Compare to required number of equipment"
    annotation(Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Or swiEna
    "Evaluate condition to switch to newly computed enable signal"
    annotation(Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Logical.And isEnaPreAva[nEqu]
    "Return true if equipment previously enabled and available"
    annotation(Placement(transformation(extent={{32,-90},{12,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1[nEqu]
    "Raw enable signal"
    annotation(Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput n
    "Number of equipment"
    annotation(Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not notEquReq
    "True if the number of enabled units differs from the required number"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
equation
  connect(y1Pre.y, logSwi.u3)
    annotation(Line(points={{50,-80},{40,-80},{40,12},{48,12}},
      color={255,0,255}));
  connect(booScaRep.y, logSwi.u2)
    annotation(Line(points={{32,20},{48,20}},
      color={255,0,255}));
  connect(swiEna.y, booScaRep.u)
    annotation(Line(points={{2,20},{8,20}},
      color={255,0,255}));
  connect(cha.y, swiEna.u1)
    annotation(Line(points={{-58,20},{-22,20}},
      color={255,0,255}));
  connect(isEnaPreAva.y, nEnaAvaPre.u1)
    annotation(Line(points={{10,-80},{-6,-80}},
      color={255,0,255}));
  connect(y1, y1Pre.u)
    annotation(Line(points={{120,0},{80,0},{80,-80},{74,-80}},
      color={255,0,255}));
  connect(logSwi.y, y1)
    annotation(Line(points={{72,20},{80,20},{80,0},{120,0}},
      color={255,0,255}));
  connect(u1, logSwi.u1)
    annotation(Line(points={{-120,60},{40,60},{40,28},{48,28}},
      color={255,0,255}));
  connect(uSta, cha.u)
    annotation(Line(points={{-120,0},{-90,0},{-90,20},{-82,20}},
      color={255,127,0}));
  connect(n,intEqu. u1)
    annotation(Line(points={{-120,-40},{-82,-40}},
      color={255,127,0}));
  connect(u1Ava, isEnaPreAva.u2)
    annotation(Line(points={{-120,-80},{-94,-80},{-94,-94},{40,-94},{40,-88},{
          34,-88}},
      color={255,0,255}));
  connect(y1Pre.y, isEnaPreAva.u1)
    annotation(Line(points={{50,-80},{34,-80}},
      color={255,0,255}));
  connect(nEnaAvaPre.y,intEqu. u2)
    annotation(Line(points={{-30,-80},{-90,-80},{-90,-48},{-82,-48}},
      color={255,127,0}));
  connect(intEqu.y, notEquReq.u)
    annotation (Line(points={{-58,-40},{-52,-40}}, color={255,0,255}));
  connect(notEquReq.y, swiEna.u2) annotation (Line(points={{-28,-40},{-24,-40},
          {-24,12},{-22,12}}, color={255,0,255}));
annotation(defaultComponentName="updEnaSta",
  Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
The enable signals are updated only at a stage change, 
or when the number of previously enabled units that are currently 
available differs from the number of units required to run.
<code>!!! Differs from master branch !!!</code>
</p>
<p>
For standard applications, this avoids hot swapping equipment, e.g., 
a unit would not be started and another stopped during operation 
just to fulfill the priority order. 
However, when a lead/lag alternate unit becomes unavailable 
and another lead/lag alternate unit can be enabled to  
satisfy the required count, the enable signals are updated accordingly.
</p>
<p>
For plants with polyvalent heat pumps, this allows a reversible unit 
to be disabled when a stage change for the opposite operating mode 
requires staging up a polyvalent unit into simultaneous heating and 
cooling (SHC) mode.
In that case, the number of reversible units required at that stage
is reduced without any stage change for the current mode.
The condition on the number of enabled units triggers the 
update of the enable signals.
</p>
</html>"));
end UpdateEnableState;
