within Buildings.Fluid.Storage.Ice.Examples.BaseClasses;
block ControlLowPowerMode
  "Closed loop control for ice storage plant in low power mode"
  extends PartialControlMode;
  Controls.OBC.CDL.Integers.GreaterThreshold higDem(t=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.None))
    "Outputs true if operated in high demand"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Controls.OBC.CDL.Logical.And andPumSto "Output true to enable storage pump"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysSOC(uLow=0.01, uHigh=0.02)
    "Hysteresis for state of charge"
    annotation (Placement(transformation(extent={{-60,-192},{-40,-172}})));
  Controls.OBC.CDL.Logical.And andPumGly
    "Output true to enable glycol chiller pump"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Controls.OBC.CDL.Logical.Sources.Constant fal(k=false) "Outputs false"
    annotation (Placement(transformation(extent={{160,70},{180,90}})));
  Controls.OBC.CDL.Logical.Not not2
    "Negation for enabling glycol chiller based on SOC"
    annotation (Placement(transformation(extent={{0,-190},{20,-170}})));
  Controls.OBC.CDL.Interfaces.RealInput SOC(final unit="1")
                    "State of charge of ice tank"
    annotation (Placement(transformation(extent={{-280,-204},{-240,-164}}),
        iconTransformation(extent={{-280,-200},{-240,-160}})));
  Controls.OBC.CDL.Integers.LessThreshold allOff(t=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.Elevated))
    "Outputs true if all should be off"
    annotation (Placement(transformation(extent={{-166,168},{-146,188}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-126,168},{-106,188}})));
equation
  connect(higDem.u, demLev) annotation (Line(points={{-102,130},{-214,130},{
          -214,180},{-260,180}}, color={255,127,0}));
  connect(yPumSto, andPumSto.y)
    annotation (Line(points={{260,-80},{62,-80}}, color={255,0,255}));
  connect(andPumSto.u1, higDem.y) annotation (Line(points={{38,-80},{0,-80},{0,
          130},{-78,130}}, color={255,0,255}));
  connect(andPumGly.y, yPumGlyChi)
    annotation (Line(points={{62,-120},{260,-120}}, color={255,0,255}));
  connect(andPumGly.u1, higDem.y) annotation (Line(points={{38,-120},{0,-120},{
          0,130},{-78,130}}, color={255,0,255}));
  connect(yPumWatHex, higDem.y) annotation (Line(points={{260,-200},{80,-200},{
          80,130},{-78,130}}, color={255,0,255}));
  connect(yGlyChi, andPumGly.y) annotation (Line(points={{260,-20},{200,-20},{
          200,-120},{62,-120}}, color={255,0,255}));
  connect(fal.y, yStoByp)
    annotation (Line(points={{182,80},{260,80}}, color={255,0,255}));
  connect(andPumSto.y, yStoOn) annotation (Line(points={{62,-80},{140,-80},{140,
          120},{260,120}}, color={255,0,255}));
  connect(andPumSto.u2, hysSOC.y) annotation (Line(points={{38,-88},{-20,-88},{
          -20,-182},{-38,-182}}, color={255,0,255}));
  connect(hysSOC.y, not2.u)
    annotation (Line(points={{-38,-182},{-20,-182},{-20,-180},{-2,-180}},
                                                    color={255,0,255}));
  connect(andPumGly.u2, not2.y) annotation (Line(points={{38,-128},{30,-128},{
          30,-180},{22,-180}}, color={255,0,255}));
  connect(SOC, hysSOC.u) annotation (Line(points={{-260,-184},{-258,-184},{-258,
          -182},{-62,-182}}, color={0,0,127}));
  connect(allOff.u, demLev) annotation (Line(points={{-168,178},{-194,178},{
          -194,180},{-260,180}}, color={255,127,0}));
  connect(allOff.y, not1.u)
    annotation (Line(points={{-144,178},{-128,178}}, color={255,0,255}));
  connect(not1.y, yWatChi) annotation (Line(points={{-104,178},{102,178},{102,
          20},{260,20}}, color={255,0,255}));
  connect(yPumWatChi, yWatChi) annotation (Line(points={{260,-240},{104,-240},{
          104,20},{260,20}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false, extent={{-240,-260},{240,
            240}}),                                                                          graphics={  Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent={{-240,
              240},{240,-260}}),                                                                                                                                                                                       Text(lineColor = {0, 0, 127}, extent={{-50,282},
              {50,238}},                                                                                                                                                                                                        textString = "%name"),
                                                                                                                                                                                                        Text(lineColor={0,0,127},     extent={{-214,
              -120},{8,-318}},
          textString="Low power mode")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent={{-240,-260},{240,
            240}})),
    Documentation(info="<html>
<p>
Plant controller for low power mode.
</p>
<p>
Based on the demand level, this controller first runs the water chiller,
and then the glycol plant.
If the ice tank has a sufficient state of charge, it will be discharged,
and afterwards the glycol chiller will be operated to serve the cooling load.
The ice tank will not be charged in this mode.
</p>
</html>", revisions="<html>
<ul>
<li>
September 21, 2022, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControlLowPowerMode;
