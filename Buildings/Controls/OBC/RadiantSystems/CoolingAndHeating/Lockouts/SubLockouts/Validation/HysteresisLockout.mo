within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.Validation;
model HysteresisLockout "Validation model for hysteresis lockout"
  final parameter Real heaLocDurAftCoo(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which heating is locked out after cooling concludes";
  final parameter Real cooLocDurAftHea(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which cooling is locked out after heating concludes";
  Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.HysteresisLimit hysLim
    "Hysteresis limit"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.HysteresisLimit hysLim1
    "Hysteresis limit"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.HysteresisLimit hysLim2
    "Hysteresis limit"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.HysteresisLimit hysLim3
    "Hysteresis limit"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.HysteresisLimit hysLim4
    "Hysteresis limit"
    annotation (Placement(transformation(extent={{260,20},{280,40}})));
  Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.HysteresisLimit hysLim5
    "Hysteresis limit"
    annotation (Placement(transformation(extent={{262,-60},{282,-40}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=1800)
    "Varying heating signal"
    annotation (Placement(transformation(extent={{200,40},{220,60}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul1(period=1800)
    "Varying cooling signal"
    annotation (Placement(transformation(extent={{200,0},{220,20}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul2(period=43000)
    "Varying heating signal"
    annotation (Placement(transformation(extent={{200,-40},{220,-20}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul3(period=43000)
    "Varying cooling signal"
    annotation (Placement(transformation(extent={{200,-80},{220,-60}})));
  Controls.OBC.CDL.Logical.Sources.Constant con(k=true)
    "Constant cooling signal"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Controls.OBC.CDL.Logical.Sources.Constant con1(k=true)
    "Constant heating signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Controls.OBC.CDL.Logical.Sources.Constant con2(k=false)
    "Constant cooling signal"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Controls.OBC.CDL.Logical.Sources.Constant con3(k=false)
    "Constant heating signal"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Controls.OBC.CDL.Logical.Sources.Constant con4(k=true)
    "Constant heating signal"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Controls.OBC.CDL.Logical.Sources.Constant con5(k=false)
    "Constant cooling signal"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Controls.OBC.CDL.Logical.Sources.Constant con6(k=false)
    "Constant heating signal"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Controls.OBC.CDL.Logical.Sources.Constant con7(k=true)
    "Constant cooling signal"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
equation
  connect(booPul2.y, hysLim5.uHea) annotation (Line(points={{222,-30},{242,
          -30},{242,-45.8},{259.8,-45.8}}, color={255,0,255}));
  connect(booPul3.y, hysLim5.uCoo) annotation (Line(points={{222,-70},{242,
          -70},{242,-58},{260,-58}}, color={255,0,255}));
  connect(booPul1.y, hysLim4.uCoo) annotation (Line(points={{222,10},{240,10},
          {240,22},{258,22}}, color={255,0,255}));
  connect(booPul.y, hysLim4.uHea) annotation (Line(points={{222,50},{240,50},
          {240,34.2},{257.8,34.2}}, color={255,0,255}));
  connect(con1.y, hysLim.uHea) annotation (Line(points={{-58,50},{-42,50},{
          -42,34.2},{-22.2,34.2}}, color={255,0,255}));
  connect(con.y, hysLim.uCoo) annotation (Line(points={{-58,10},{-40,10},{-40,
          22},{-22,22}}, color={255,0,255}));
  connect(con2.y, hysLim1.uCoo) annotation (Line(points={{-58,-70},{-40,-70},
          {-40,-58},{-22,-58}}, color={255,0,255}));
  connect(con3.y, hysLim1.uHea) annotation (Line(points={{-58,-30},{-40,-30},
          {-40,-45.8},{-22.2,-45.8}}, color={255,0,255}));
  connect(con4.y, hysLim3.uHea) annotation (Line(points={{82,50},{100,50},{
          100,34.2},{117.8,34.2}}, color={255,0,255}));
  connect(con5.y, hysLim3.uCoo) annotation (Line(points={{82,10},{102,10},{
          102,22},{118,22}}, color={255,0,255}));
  connect(con6.y, hysLim2.uHea) annotation (Line(points={{82,-30},{102,-30},{
          102,-45.8},{117.8,-45.8}}, color={255,0,255}));
  connect(con7.y, hysLim2.uCoo) annotation (Line(points={{82,-70},{100,-70},{
          100,-58},{118,-58}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
Validates the hysteresis lockout. 
This model validates that cooling is locked out if heating has been on within a user-specified amount of time, 
and that heating is locked out if cooling has been on within a user-specified amount of time. 
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation.
</li>
</ul>
</html>"),experiment(StopTime=172800.0, Tolerance=1e-06),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RadiantSystems/CoolingAndHeating/Lockouts/SubLockouts/Validation/HysteresisLockout.mos"
        "Simulate and plot"),Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{340,100}})));
end HysteresisLockout;
