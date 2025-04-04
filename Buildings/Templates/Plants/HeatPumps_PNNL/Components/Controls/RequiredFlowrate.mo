within Buildings.Templates.Plants.HeatPumps_PNNL.Components.Controls;
block RequiredFlowrate
  parameter Boolean has_minTemp = false;

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRetRef annotation (Placement(
        transformation(extent={{-140,0},{-100,40}}), iconTransformation(extent={{-140,20},
            {-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupRef annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}), iconTransformation(extent={{-140,60},
            {-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mRef_flow annotation (
      Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupMea annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs2
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mReq_flow annotation (
      Placement(transformation(extent={{100,-20},{140,20}}), iconTransformation(
          extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(p=273.15)
    annotation (Placement(transformation(extent={{-80,-54},{-60,-34}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(p=1e-6)
    if not has_minTemp
    annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TRet if has_minTemp
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMinRef if has_minTemp
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar2(p=273.15 + 2)
    if has_minTemp
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2 if has_minTemp
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2 if has_minTemp
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub3 if has_minTemp
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar3(p=1e-6) if has_minTemp
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
equation
  connect(TSupRef, sub.u1) annotation (Line(points={{-120,60},{-88,60},{-88,46},
          {-82,46}}, color={0,0,127}));
  connect(TRetRef, sub.u2) annotation (Line(points={{-120,20},{-88,20},{-88,34},
          {-82,34}}, color={0,0,127}));
  connect(sub.y, abs1.u)
    annotation (Line(points={{-58,40},{-52,40}}, color={0,0,127}));
  connect(abs1.y, mul.u1) annotation (Line(points={{-28,40},{-18,40},{-18,6},{
          -12,6}}, color={0,0,127}));
  connect(mRef_flow, mul.u2) annotation (Line(points={{-120,-20},{-18,-20},{-18,
          -6},{-12,-6}}, color={0,0,127}));
  connect(TSupMea, sub1.u2) annotation (Line(points={{-120,-60},{-50,-60},{-50,
          -56},{-52,-56}}, color={0,0,127}));
  connect(sub1.y, abs2.u)
    annotation (Line(points={{-28,-50},{-22,-50}}, color={0,0,127}));
  connect(mul.y, div1.u1)
    annotation (Line(points={{12,0},{30,0},{30,6},{38,6}}, color={0,0,127}));
  connect(TRetRef, addPar.u) annotation (Line(points={{-120,20},{-88,20},{-88,
          -44},{-82,-44}}, color={0,0,127}));
  connect(addPar.y, sub1.u1)
    annotation (Line(points={{-58,-44},{-52,-44}}, color={0,0,127}));
  connect(abs2.y, addPar1.u)
    annotation (Line(points={{2,-50},{8,-50}}, color={0,0,127}));
  connect(addPar1.y, div1.u2) annotation (Line(points={{32,-50},{34,-50},{34,-6},
          {38,-6}},                       color={0,0,127}));
  connect(max1.y, mReq_flow) annotation (Line(points={{94,0},{100,0},{100,0},{
          120,0}}, color={0,0,127}));
  connect(div1.y, max1.u1)
    annotation (Line(points={{62,0},{70,0},{70,6}}, color={0,0,127}));
  connect(mRef_flow, max1.u2) annotation (Line(points={{-120,-20},{64,-20},{64,
          -6},{70,-6}}, color={0,0,127}));
  connect(TMinRef, addPar2.u)
    annotation (Line(points={{-120,-100},{-88,-100},{-88,-120},{-82,-120}},
                                                      color={0,0,127}));
  connect(TSupMea, sub2.u1) annotation (Line(points={{-120,-60},{-68,-60},{-68,
          -84},{-62,-84}},
                      color={0,0,127}));
  connect(sub.y, sub2.u2) annotation (Line(points={{-58,40},{-58,-30},{-90,-30},
          {-90,-96},{-62,-96}}, color={0,0,127}));
  connect(sub2.y, max2.u1) annotation (Line(points={{-38,-90},{-32,-90},{-32,
          -94},{-22,-94}},
                 color={0,0,127}));
  connect(addPar2.y, max2.u2) annotation (Line(points={{-58,-120},{-28,-120},{
          -28,-106},{-22,-106}},
                            color={0,0,127}));
  connect(max2.y, sub3.u2) annotation (Line(points={{2,-100},{12,-100},{12,-86},
          {18,-86}},                   color={0,0,127}));
  connect(TSupMea, sub3.u1) annotation (Line(points={{-120,-60},{-54,-60},{-54,
          -66},{10,-66},{10,-74},{18,-74}},
                                         color={0,0,127}));
  connect(max2.y, TRet) annotation (Line(points={{2,-100},{90,-100},{90,-60},{
          120,-60}},
                 color={0,0,127}));
  connect(sub3.y, addPar3.u)
    annotation (Line(points={{42,-80},{48,-80}}, color={0,0,127}));
  connect(addPar3.y, div1.u2) annotation (Line(points={{72,-80},{78,-80},{78,
          -22},{34,-22},{34,-6},{38,-6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,140},{150,100}},
          textString="%name",
          textColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-160},{100,100}})));
end RequiredFlowrate;
