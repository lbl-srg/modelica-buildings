within Buildings.Fluid.Storage.Ice.Examples.BaseClasses;
block ControlHighPowerMode "Closed loop controller"
  extends PartialControlMode;
  Controls.OBC.CDL.Continuous.LessThreshold lesThr(t=0.88, h=0.1)
    annotation (Placement(transformation(extent={{-196,-118},{-176,-98}})));
  Controls.OBC.CDL.Logical.And andPumSto "Output true to enable storage pump"
    annotation (Placement(transformation(extent={{-106,-110},{-86,-90}})));
  Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(t=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.Normal))
    annotation (Placement(transformation(extent={{-198,-50},{-178,-30}})));
  Controls.OBC.CDL.Logical.Switch logSwi
    annotation (Placement(transformation(extent={{-46,-30},{-26,-50}})));
  Modelica.Blocks.Sources.BooleanConstant onSig(k=true)
    annotation (Placement(transformation(extent={{-102,-20},{-82,0}})));
  Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{58,-210},{78,-190}})));
  Controls.OBC.CDL.Interfaces.RealInput SOC(final unit="1")
                    "State of charge of ice tank"
    annotation (Placement(transformation(extent={{-286,-130},{-246,-90}}),
        iconTransformation(extent={{-280,-200},{-240,-160}})));
  Controls.OBC.CDL.Integers.LessThreshold allOff(t=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.Normal))
    "Outputs true if all should be off"
    annotation (Placement(transformation(extent={{-190,170},{-170,190}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-134,168},{-114,188}})));
equation
  connect(lesThr.y, andPumSto.u2)
    annotation (Line(points={{-174,-108},{-108,-108}}, color={255,0,255}));
  connect(demLev, intLesEquThr.u) annotation (Line(points={{-260,180},{-206,180},
          {-206,-40},{-200,-40}}, color={255,127,0}));
  connect(intLesEquThr.y, andPumSto.u1) annotation (Line(points={{-176,-40},{
          -118,-40},{-118,-100},{-108,-100}}, color={255,0,255}));
  connect(andPumSto.y, logSwi.u1) annotation (Line(points={{-84,-100},{-62,-100},
          {-62,-48},{-48,-48}}, color={255,0,255}));
  connect(intLesEquThr.y, logSwi.u2)
    annotation (Line(points={{-176,-40},{-48,-40}}, color={255,0,255}));
  connect(onSig.y, logSwi.u3) annotation (Line(points={{-81,-10},{-60,-10},{-60,
          -32},{-48,-32}}, color={255,0,255}));
  connect(logSwi.y, yPumGlyChi) annotation (Line(points={{-24,-40},{82,-40},{82,
          -120},{260,-120}}, color={255,0,255}));
  connect(andPumSto.y, yPumSto) annotation (Line(points={{-84,-100},{-62,-100},
          {-62,-80},{260,-80}}, color={255,0,255}));
  connect(logSwi.y, yGlyChi) annotation (Line(points={{-24,-40},{82,-40},{82,
          -20},{260,-20}}, color={255,0,255}));
  connect(andPumSto.y, yStoOn) annotation (Line(points={{-84,-100},{0,-100},{0,
          120},{260,120}}, color={255,0,255}));
  connect(andPumSto.y, yStoByp) annotation (Line(points={{-84,-100},{20,-100},{
          20,80},{260,80}}, color={255,0,255}));
  connect(not2.y, yPumWatHex)
    annotation (Line(points={{80,-200},{260,-200}}, color={255,0,255}));
  connect(intLesEquThr.y, not2.u) annotation (Line(points={{-176,-40},{-142,-40},
          {-142,-202},{56,-202},{56,-200}}, color={255,0,255}));
  connect(SOC, lesThr.u) annotation (Line(points={{-266,-110},{-264,-110},{-264,
          -108},{-198,-108}}, color={0,0,127}));
  connect(allOff.y, not1.u) annotation (Line(points={{-168,180},{-166,180},{
          -166,178},{-136,178}}, color={255,0,255}));
  connect(allOff.u, intLesEquThr.u) annotation (Line(points={{-192,180},{-192,
          178},{-206,178},{-206,-40},{-200,-40}}, color={255,127,0}));
  connect(not1.y, yWatChi) annotation (Line(points={{-112,178},{52,178},{52,20},
          {260,20}}, color={255,0,255}));
  connect(yPumWatChi, yWatChi) annotation (Line(points={{260,-240},{52,-240},{
          52,20},{260,20}}, color={255,0,255}));
  annotation (Icon(graphics={                                                                                                                                                                           Text(lineColor={0,0,127},     extent={{-228,
              -94},{-6,-292}},
          textString="High power mode")}), Documentation(revisions="<html>
<ul>
<li>
November 10, 2022, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControlHighPowerMode;
