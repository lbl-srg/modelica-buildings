within Buildings.Fluid.Storage.Ice.Examples.BaseClasses;
block ControlEfficiencyMode
  "Closed loop control for ice storage plant in efficiency mode"
 extends PartialControlMode;

  Controls.OBC.CDL.Integers.GreaterThreshold higDem(t=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.Normal))
    "Outputs true if operated in high demand"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Controls.OBC.CDL.Logical.Sources.Constant fal(k=false) "Outputs false"
    annotation (Placement(transformation(extent={{160,70},{180,90}})));
  Controls.OBC.CDL.Integers.LessThreshold allOff(t=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.Normal))
    "Outputs true if all should be off"
    annotation (Placement(transformation(extent={{-138,170},{-118,190}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-98,170},{-78,190}})));
equation
  connect(higDem.u, demLev) annotation (Line(points={{-102,130},{-220,130},{
          -220,180},{-260,180}}, color={255,127,0}));
  connect(yPumWatHex, higDem.y) annotation (Line(points={{260,-200},{80,-200},{
          80,130},{-78,130}}, color={255,0,255}));
  connect(fal.y, yStoByp)
    annotation (Line(points={{182,80},{260,80}}, color={255,0,255}));
  connect(fal.y, yStoOn) annotation (Line(points={{182,80},{200,80},{200,120},{
          260,120}}, color={255,0,255}));
  connect(fal.y, yPumSto) annotation (Line(points={{182,80},{200,80},{200,-80},
          {260,-80}}, color={255,0,255}));
  connect(higDem.y, yPumGlyChi) annotation (Line(points={{-78,130},{80,130},{80,
          -120},{260,-120}}, color={255,0,255}));
  connect(yGlyChi, higDem.y) annotation (Line(points={{260,-20},{80,-20},{80,
          130},{-78,130}}, color={255,0,255}));
  connect(demLev, allOff.u)
    annotation (Line(points={{-260,180},{-140,180}}, color={255,127,0}));
  connect(allOff.y, not1.u)
    annotation (Line(points={{-116,180},{-100,180}}, color={255,0,255}));
  connect(not1.y, yWatChi) annotation (Line(points={{-76,180},{20,180},{20,178},
          {114,178},{114,20},{260,20}}, color={255,0,255}));
  connect(yPumWatChi, yWatChi) annotation (Line(points={{260,-240},{114,-240},{
          114,20},{260,20}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false, extent={{-240,-260},{240,
            240}}),                                                                          graphics={  Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent={{-240,
              240},{240,-260}}),                                                                                                                                                                                       Text(lineColor = {0, 0, 127}, extent={{-50,282},
              {50,238}},                                                                                                                                                                                                        textString = "%name"),
                                                                                                                                                                                                        Text(lineColor={0,0,127},     extent={{-220,
              -122},{2,-320}},
          textString="Efficiency mode")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent={{-240,-260},{240,
            240}})),
    Documentation(info="<html>
<p>
Plant controller for efficiency mode.
</p>
<p>
Based on the demand level, this controller first runs the water chiller,
and then the glycol chiller.
The storage will be neither charged nor discharged.
</p>
</html>", revisions="<html>
<ul>
<li>
September 21, 2022, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControlEfficiencyMode;
