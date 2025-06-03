within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
block StageChangeCondition
  "Evaluate stage change condition based on load criteria"
  parameter Polarity pol
    "Application";
  parameter Real SPLR(
    max=1,
    min=0)=0.9
    "Staging part load ratio";
  parameter Real dtMea(
    min=0,
    unit="s")=300
    "Duration for computing load moving average";
  type Polarity = enumeration(
    Heating "Heating",
    Cooling "Cooling");
  constant Real deltaX = 1E-4
    "Small number guarding against numerical residuals influencing stage transitions";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QSet_flow(final unit="J/s")
    "Total load" annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Q_flow(final unit="J/s")
    "Single module capacity" annotation (Placement(transformation(extent={{-140,
            -20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nUni
    "Number of active modules at current stage" annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal nUniRea
    "Cast to real value"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(k=if pol == Polarity.Heating
         then 1 else -1) "Apply polarity"
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(k=if pol ==
        Polarity.Heating then 1 else -1) "Apply polarity"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage QSetAve(final delta=dtMea)
    "Compute moving average"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai3(final k=deltaX)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,20})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai2(final k=SPLR)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,50})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai4(final k=-SPLR)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-20})));
  Buildings.Controls.OBC.CDL.Reals.Multiply nUniTimQ
    "Capacity of all active modules at current stage"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre "Apply polarity"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Reals.Less les "Apply polarity"
    annotation (Placement(transformation(extent={{62,-50},{82,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Up "Stage up condition"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Dow
    "Stage down condition" annotation (Placement(transformation(extent={{100,-62},
            {140,-22}}),iconTransformation(extent={{100,-80},{140,-40}})));
equation
  connect(nUni, nUniRea.u)
    annotation (Line(points={{-120,-60},{-92,-60}}, color={255,127,0}));
  connect(QSet_flow, QSetAve.u)
    annotation (Line(points={{-120,80},{-92,80}}, color={0,0,127}));
  connect(QSetAve.y, gai1.u)
    annotation (Line(points={{-68,80},{-66,80},{-66,60},{-62,60}},
                                                 color={0,0,127}));
  connect(nUniRea.y, nUniTimQ.u2) annotation (Line(points={{-68,-60},{-56,-60},{
          -56,-6},{-52,-6}}, color={0,0,127}));
  connect(nUniTimQ.y, gai2.u) annotation (Line(points={{-28,0},{-20,0},{-20,50},
          {-12,50}}, color={0,0,127}));
  connect(gai2.y, add2.u1) annotation (Line(points={{12,50},{14,50},{14,46},{18,
          46}}, color={0,0,127}));
  connect(gai3.y, add2.u2) annotation (Line(points={{12,20},{14,20},{14,34},{18,
          34}}, color={0,0,127}));
  connect(Q_flow, gai.u)
    annotation (Line(points={{-120,0},{-90,0}}, color={0,0,127}));
  connect(gai.y, nUniTimQ.u1) annotation (Line(points={{-66,0},{-60,0},{-60,6},{
          -52,6}}, color={0,0,127}));
  connect(gai.y, gai3.u) annotation (Line(points={{-66,0},{-60,0},{-60,20},{-12,
          20}}, color={0,0,127}));
  connect(gai.y, gai4.u) annotation (Line(points={{-66,0},{-60,0},{-60,-20},{-12,
          -20}}, color={0,0,127}));
  connect(add2.y, add1.u1) annotation (Line(points={{42,40},{50,40},{50,0},{14,0},
          {14,-14},{18,-14}}, color={0,0,127}));
  connect(gai4.y, add1.u2) annotation (Line(points={{12,-20},{14,-20},{14,-26},{
          18,-26}}, color={0,0,127}));
  connect(gai1.y, gre.u1)
    annotation (Line(points={{-38,60},{54,60},{54,40},{58,40}},
                                                color={0,0,127}));
  connect(add2.y, gre.u2) annotation (Line(points={{42,40},{50,40},{50,32},{58,
          32}},
        color={0,0,127}));
  connect(gai1.y, les.u1) annotation (Line(points={{-38,60},{54,60},{54,-40},{
          60,-40}},
        color={0,0,127}));
  connect(add1.y, les.u2) annotation (Line(points={{42,-20},{54,-20},{54,-48},{
          60,-48}},
                color={0,0,127}));
  connect(gre.y, y1Up) annotation (Line(points={{82,40},{120,40}},
        color={255,0,255}));
  connect(les.y, y1Dow)
    annotation (Line(points={{84,-40},{102,-40},{102,-42},{120,-42}},
                                              color={255,0,255}));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end StageChangeCondition;
