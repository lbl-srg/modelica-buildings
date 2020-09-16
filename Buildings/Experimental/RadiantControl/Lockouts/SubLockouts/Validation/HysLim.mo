within Buildings.Experimental.RadiantControl.Lockouts.SubLockouts.Validation;
model HysLim "Validation model for hysteresis lockout"
  final parameter Real TimHea(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which heating is locked out after cooling concludes";
  final parameter Real TimCoo(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which cooling is locked out after heating concludes";
  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant2(k=false)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant3(k=false)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant4
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant5(k=false)
    annotation (Placement(transformation(extent={{60,-2},{80,18}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant6(k=true)
    annotation (Placement(transformation(extent={{62,-44},{82,-24}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant7(k=true)
    annotation (Placement(transformation(extent={{62,-86},{82,-66}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=1800)
    annotation (Placement(transformation(extent={{200,38},{220,58}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse1(period=1800)
    annotation (Placement(transformation(extent={{200,-2},{220,18}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse2(period=43000)
    annotation (Placement(transformation(extent={{200,-80},{220,-60}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse3(period=43000)
    annotation (Placement(transformation(extent={{200,-40},{220,-20}})));
  HysteresisLimit hysteresisLimit
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  HysteresisLimit hysteresisLimit1
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  HysteresisLimit hysteresisLimit2
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  HysteresisLimit hysteresisLimit3
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  HysteresisLimit hysteresisLimit4
    annotation (Placement(transformation(extent={{260,20},{280,40}})));
  HysteresisLimit hysteresisLimit5
    annotation (Placement(transformation(extent={{262,-60},{282,-40}})));
equation
  connect(booleanConstant.y, hysteresisLimit.heaSig) annotation (Line(points={{-59,
          50},{-40,50},{-40,34.2},{-22.2,34.2}}, color={255,0,255}));
  connect(booleanConstant1.y, hysteresisLimit.cooSig) annotation (Line(points={{
          -59,10},{-42,10},{-42,22},{-22,22}}, color={255,0,255}));
  connect(booleanPulse.y, hysteresisLimit4.heaSig) annotation (Line(points={{221,
          48},{240,48},{240,34.2},{257.8,34.2}}, color={255,0,255}));
  connect(booleanPulse1.y, hysteresisLimit4.cooSig) annotation (Line(points={{221,
          8},{238,8},{238,22},{258,22}}, color={255,0,255}));
  connect(booleanPulse3.y, hysteresisLimit5.heaSig) annotation (Line(points={{221,
          -30},{240,-30},{240,-45.8},{259.8,-45.8}}, color={255,0,255}));
  connect(booleanPulse2.y, hysteresisLimit5.cooSig) annotation (Line(points={{221,
          -70},{240,-70},{240,-58},{260,-58}}, color={255,0,255}));
  connect(booleanConstant4.y, hysteresisLimit3.heaSig) annotation (Line(points={
          {81,50},{100,50},{100,34.2},{117.8,34.2}}, color={255,0,255}));
  connect(booleanConstant5.y, hysteresisLimit3.cooSig) annotation (Line(points={
          {81,8},{100,8},{100,22},{118,22}}, color={255,0,255}));
  connect(booleanConstant6.y, hysteresisLimit2.heaSig) annotation (Line(points={
          {83,-34},{100,-34},{100,-45.8},{117.8,-45.8}}, color={255,0,255}));
  connect(booleanConstant7.y, hysteresisLimit2.cooSig) annotation (Line(points={
          {83,-76},{100,-76},{100,-58},{118,-58}}, color={255,0,255}));
  connect(booleanConstant3.y, hysteresisLimit1.heaSig) annotation (Line(points={
          {-59,-30},{-42,-30},{-42,-45.8},{-22.2,-45.8}}, color={255,0,255}));
  connect(booleanConstant2.y, hysteresisLimit1.cooSig) annotation (Line(points={
          {-59,-70},{-40,-70},{-40,-58},{-22,-58}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
Validates the hysteresis lockout. 
This model validates that cooling is locked out if heating has been on within a user-specified amount of time, 
and that heating is locked out if cooling has been on within a user-specified amount of time. 
</p>
</html>"),experiment(StopTime=172800.0, Tolerance=1e-06),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/RadiantControl/Lockouts/SubLockouts/Validation/HysLim.mos"
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
end HysLim;
