within Buildings.Experimental.NatVentControl.VAV;
block TStatReset
  "Resets VAV thermostat if natural ventilation mode is on"
  Controls.OBC.CDL.Interfaces.BooleanInput natVenSig
    "True if natural ventilation is active; false if not" annotation (Placement(
        transformation(extent={{-140,10},{-100,50}}),  iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Controls.OBC.CDL.Interfaces.RealOutput htgStpVAV "VAV heating setpoint"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Controls.OBC.CDL.Interfaces.RealOutput clgStpVAV "Cooling setpoint for VAV"
    annotation (Placement(transformation(extent={{100,-90},{140,-50}}),
        iconTransformation(extent={{100,-30},{140,10}})));
  Controls.OBC.CDL.Interfaces.RealInput htgStp "Heating setpoint from VAV"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Controls.OBC.CDL.Interfaces.RealInput clgStp "Cooling setpoint" annotation (
      Placement(transformation(extent={{-140,-90},{-100,-50}}),
        iconTransformation(extent={{-142,-60},{-102,-20}})));
  Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Samples heating setpoint when natural ventilation mode comes on"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Controls.OBC.CDL.Discrete.TriggeredSampler triSam1
    "Samples cooling setpoint when natural ventilation mode comes on"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Controls.OBC.CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Controls.OBC.CDL.Continuous.Add add1
    annotation (Placement(transformation(extent={{58,-100},{78,-80}})));
  Controls.OBC.CDL.Continuous.ChangeSign chaSig
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Controls.OBC.CDL.Interfaces.RealOutput htgStpWin
    "Heating setpoint for window" annotation (Placement(transformation(extent={{
            100,60},{140,100}}), iconTransformation(extent={{100,50},{140,
            90}})));
  Controls.OBC.CDL.Interfaces.RealOutput clgStpWin
    "Cooling setpoint for window" annotation (Placement(transformation(extent={{
            100,20},{140,60}}), iconTransformation(extent={{100,12},{140,52}})));
  Modelica.Blocks.Sources.Constant htgStpRelAmt(k=HtgStpRel)
    "Amount heating setpoint is relaxed when natural ventilation mode is on"
    annotation (Placement(transformation(extent={{2,0},{22,20}})));
  Modelica.Blocks.Sources.Constant clgStpRelAmt(k=ClgStpRel)
    "Amount that cooling setpoint is relaxed"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
equation
  connect(htgStp, triSam.u) annotation (Line(points={{-120,-30},{-92,-30},{-92,10},
          {-62,10}}, color={0,0,127}));
  connect(clgStp, triSam1.u) annotation (Line(points={{-120,-70},{-92,-70},{-92,
          -50},{-62,-50}}, color={0,0,127}));
  connect(triSam.y, htgStpWin) annotation (Line(points={{-38,10},{-20,10},{-20,80},
          {120,80}}, color={0,0,127}));
  connect(triSam1.y, clgStpWin) annotation (Line(points={{-38,-50},{-6,-50},{-6,
          40},{120,40}}, color={0,0,127}));
  connect(htgStpWin, htgStpWin)
    annotation (Line(points={{120,80},{120,80}}, color={0,0,127}));
  connect(chaSig.y, add2.u1) annotation (Line(points={{62,10},{70,10},{70,-4},{46,
          -4},{46,-24},{58,-24}}, color={0,0,127}));
  connect(triSam.y, add2.u2) annotation (Line(points={{-38,10},{-20,10},{-20,-36},
          {58,-36}}, color={0,0,127}));
  connect(add2.y, htgStpVAV)
    annotation (Line(points={{82,-30},{120,-30}}, color={0,0,127}));
  connect(add1.y, clgStpVAV) annotation (Line(points={{80,-90},{82,-90},{82,-70},
          {120,-70}}, color={0,0,127}));
  connect(triSam1.y, add1.u2) annotation (Line(points={{-38,-50},{-6,-50},{-6,-96},
          {56,-96}}, color={0,0,127}));
  connect(htgStpRelAmt.y, chaSig.u)
    annotation (Line(points={{23,10},{38,10}}, color={0,0,127}));
  connect(clgStpRelAmt.y, add1.u1) annotation (Line(points={{21,-70},{50,-70},{50,
          -84},{56,-84}}, color={0,0,127}));
  connect(natVenSig, triSam.trigger) annotation (Line(points={{-120,30},{-88,30},
          {-88,-20},{-50,-20},{-50,-1.8}}, color={255,0,255}));
  connect(natVenSig, triSam1.trigger) annotation (Line(points={{-120,30},{-88,30},
          {-88,-80},{-50,-80},{-50,-61.8}}, color={255,0,255}));
  annotation (defaultComponentName = "TStatReset",Documentation(info="<html>
  This block determines the VAV temperature setpoint while natural ventilation mode is on. When natural ventilation mode turns on,
  the block samples the heating and cooling setpoint, and adds a user-specified setpoint relaxation amount (typically 20F) to produce relaxed VAV setpoints.
  This aims to prevent the VAV from attempting to condition the room while the windows are open. 
<p>
</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Polygon(
          points={{-80,60},{-80,-60},{34,-60},{94,60},{-52,60},{-80,60}},
          lineColor={0,140,72},
          lineThickness=1), Text(
          extent={{20,-52},{-36,58}},
          lineColor={0,140,72},
          lineThickness=1,
          textString="T")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TStatReset;
