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
  Buildings.Obsolete.HysteresisLimitOld hysteresisLimit(TiHea=TimHea, TiCoo=
        TimCoo) annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Obsolete.HysteresisLimitOld hysteresisLimit1(TiHea=TimHea, TiCoo=
        TimCoo)
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Obsolete.HysteresisLimitOld hysteresisLimit2(TiHea=TimHea, TiCoo=
        TimCoo)
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Buildings.Obsolete.HysteresisLimitOld hysteresisLimit3(TiHea=TimHea, TiCoo=
        TimCoo)
    annotation (Placement(transformation(extent={{118,-60},{138,-40}})));
  Buildings.Obsolete.HysteresisLimitOld hysteresisLimit4(TiHea=TimHea, TiCoo=
        TimCoo)
    annotation (Placement(transformation(extent={{260,20},{280,40}})));
  Buildings.Obsolete.HysteresisLimitOld hysteresisLimit5(TiHea=TimHea, TiCoo=
        TimCoo)
    annotation (Placement(transformation(extent={{262,-58},{282,-38}})));
equation
  connect(booleanConstant.y, hysteresisLimit.heatingSignal) annotation (
     Line(points={{-59,50},{-52,50},{-52,37},{-46,37}}, color={255,0,
          255}));
  connect(booleanConstant1.y, hysteresisLimit.coolingSignal)
    annotation (Line(points={{-59,10},{-54,10},{-54,21},{-46,21}},
        color={255,0,255}));
  connect(booleanConstant3.y, hysteresisLimit1.heatingSignal)
    annotation (Line(points={{-59,-30},{-52,-30},{-52,-43},{-46,-43}},
        color={255,0,255}));
  connect(booleanConstant2.y, hysteresisLimit1.coolingSignal)
    annotation (Line(points={{-59,-70},{-52,-70},{-52,-59},{-46,-59}},
        color={255,0,255}));
  connect(booleanConstant6.y, hysteresisLimit3.heatingSignal)
    annotation (Line(points={{83,-34},{88,-34},{88,-43},{92,-43}},
        color={255,0,255}));
  connect(booleanConstant7.y, hysteresisLimit3.coolingSignal)
    annotation (Line(points={{83,-76},{88,-76},{88,-59},{92,-59}},
        color={255,0,255}));
  connect(booleanConstant4.y, hysteresisLimit2.heatingSignal)
    annotation (Line(points={{81,50},{88,50},{88,37},{94,37}}, color={
          255,0,255}));
  connect(booleanConstant5.y, hysteresisLimit2.coolingSignal)
    annotation (Line(points={{81,8},{86,8},{86,21},{94,21}}, color={255,
          0,255}));
  connect(booleanPulse.y, hysteresisLimit4.heatingSignal) annotation (
      Line(points={{221,48},{228,48},{228,37},{234,37}}, color={255,0,
          255}));
  connect(booleanPulse1.y, hysteresisLimit4.coolingSignal) annotation (
      Line(points={{221,8},{228,8},{228,21},{234,21}}, color={255,0,255}));
  connect(booleanPulse3.y, hysteresisLimit5.heatingSignal) annotation (
      Line(points={{221,-30},{226,-30},{226,-44},{236,-44},{236,-41}},
        color={255,0,255}));
  connect(booleanPulse2.y, hysteresisLimit5.coolingSignal) annotation (
      Line(points={{221,-70},{226,-70},{226,-57},{236,-57}}, color={255,
          0,255}));
  annotation (Documentation(info="<html>
<p>
Validates the hysteresis lockout. Validates that cooling is locked out if heating has been on within a user-specified amount of time, 
and that heating is locked out if cooling has been on within a user-specified amount of time. 
</p>
</html>"),experiment(StopTime=172800.0, Tolerance=1e-06),Icon(graphics={
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
