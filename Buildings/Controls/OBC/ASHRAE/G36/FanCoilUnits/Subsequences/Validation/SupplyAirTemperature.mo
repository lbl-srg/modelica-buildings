within Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Subsequences.Validation;
block SupplyAirTemperature
  "Validation model for supply air temperature setpoint subsequence"

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Subsequences.SupplyAirTemperature
    TSupAir(
    have_cooCoi=true,
    have_heaCoi=true)
    "Instance demonstrating heating signal operation"
    annotation (Placement(transformation(extent={{-50,60},{-30,84}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Subsequences.SupplyAirTemperature
    TSupAir3(
    have_cooCoi=true,
    have_heaCoi=false)
    "Instance demonstrating cooling signal operation when heating coil is absent"
    annotation (Placement(transformation(extent={{60,-80},{80,-56}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Subsequences.SupplyAirTemperature
    TSupAir2(
    have_cooCoi=false,
    have_heaCoi=true)
    "Instance demonstrating heating signal operation when cooling coil is absent"
    annotation (Placement(transformation(extent={{-50,-100},{-30,-76}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Subsequences.SupplyAirTemperature
    TSupAir1(
    have_cooCoi=true,
    have_heaCoi=true)
    "Instance demonstrating cooling signal operation"
    annotation (Placement(transformation(extent={{80,60},{100,84}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    amplitude=20,
    freqHz=1/50,
    offset=273.15 + 23)
    "Supply air temperature signal"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin3(
    amplitude=20,
    freqHz=1/50,
    offset=273.15 + 23)
    "Supply air temperature signal"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin5(
    amplitude=0.5,
    freqHz=1/100,
    offset=0.5)
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin6(
    amplitude=20,
    freqHz=1/50,
    offset=273.15 + 23)
    "Supply air temperature signal"
    annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin8(
    amplitude=0.5,
    freqHz=1/100,
    offset=0.5)
    "Heating loop signal"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin4(
    amplitude=20,
    freqHz=1/50,
    offset=273.15 + 23)
    "Supply air temperature signal"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    k=273.15 + 21)
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-90,120},{-70,140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    k=273.15 + 25)
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(
    k=273.15 + 21)
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(
    k=273.15 + 25)
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con4(
    k=273.15 + 21)
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con6(
    k=273.15 + 25)
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con5(
    k=0.25)
    "Heating loop signal"
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con7(
    k=0)
    "Heating loop signal"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con8(
    k=0)
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con9(
    k=0.25)
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con10(
    k=true)
    "Boolean fale signal"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));

equation
  connect(sin.y, TSupAir.TAirSup)
    annotation (Line(points={{-68,70},{-60,70},{-60,69.6},{-52,69.6}}, color={0,0,127}));
  connect(sin6.y, TSupAir2.TAirSup)
    annotation (Line(points={{-68,-90},{-60,-90},{-60,-90.4},{-52,-90.4}}, color={0,0,127}));
  connect(sin8.y, TSupAir2.uHea) annotation (Line(points={{-68,-60},{-60,-60},{-60,
          -85.6},{-52,-85.6}}, color={0,0,127}));
  connect(sin4.y,TSupAir1. TAirSup)
    annotation (Line(points={{62,70},{70,70},{70,69.6},{78,69.6}}, color={0,0,127}));
  connect(con.y,TSupAir.TZonHeaSet)  annotation (Line(points={{-68,130},{-56,130},
          {-56,78},{-52,78}}, color={0,0,127}));
  connect(con1.y,TSupAir.TZonCooSet)  annotation (Line(points={{-68,10},{-56,10},
          {-56,62.4},{-52,62.4}}, color={0,0,127}));
  connect(con2.y,TSupAir1.TZonHeaSet)  annotation (Line(points={{62,130},{72,130},
          {72,78},{78,78}}, color={0,0,127}));
  connect(con3.y,TSupAir1.TZonCooSet)  annotation (Line(points={{62,10},{72,10},
          {72,62.4},{78,62.4}}, color={0,0,127}));
  connect(con4.y,TSupAir2.TZonHeaSet)  annotation (Line(points={{-68,-30},{-56,-30},
          {-56,-82},{-52,-82}}, color={0,0,127}));
  connect(con6.y,TSupAir3.TZonCooSet)  annotation (Line(points={{42,-120},{54,-120},
          {54,-77.6},{58,-77.6}},   color={0,0,127}));
  connect(con5.y, TSupAir.uHea) annotation (Line(points={{-68,100},{-60,100},{-60,
          74.4},{-52,74.4}}, color={0,0,127}));
  connect(con7.y, TSupAir1.uHea) annotation (Line(points={{62,100},{68,100},{68,
          74.4},{78,74.4}}, color={0,0,127}));
  connect(con8.y, TSupAir.uCoo) annotation (Line(points={{-68,40},{-60,40},{-60,
          66},{-52,66}}, color={0,0,127}));
  connect(con9.y, TSupAir1.uCoo) annotation (Line(points={{62,40},{70,40},{70,66},
          {78,66}}, color={0,0,127}));
  connect(sin5.y, TSupAir3.uCoo) annotation (Line(points={{42,-90},{52,-90},{52,
          -74},{58,-74}}, color={0,0,127}));
  connect(sin3.y, TSupAir3.TAirSup) annotation (Line(points={{42,-60},{52,-60},{
          52,-70.4},{58,-70.4}}, color={0,0,127}));
  connect(con10.y, TSupAir.u1Fan) annotation (Line(points={{-98,-10},{-54,-10},{
          -54,81.6},{-52,81.6}},   color={255,0,255}));
  connect(con10.y, TSupAir1.u1Fan) annotation (Line(points={{-98,-10},{74,-10},{
          74,81.6},{78,81.6}},    color={255,0,255}));
  connect(con10.y, TSupAir2.u1Fan) annotation (Line(points={{-98,-10},{-54,-10},
          {-54,-78.4},{-52,-78.4}},      color={255,0,255}));
  connect(con10.y, TSupAir3.u1Fan) annotation (Line(points={{-98,-10},{54,-10},{
          54,-58.4},{58,-58.4}},    color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/FanCoilUnits/Subsequences/Validation/SupplyAirTemperature.mos"
    "Simulate and plot"),
experiment(StopTime=100, Tolerance=1e-06),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Subsequences.SupplyAirTemperature\">
Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Subsequences.SupplyAirTemperature</a>. 
Each of the four instances of the controller represents operation with different
inputs for heating and cooling loop signals, and different configuration
parameters of fan coil unit with presence or absence of heating and cooling
coils, as described in the instance comments.
</p>
</html>", revisions="<html>
<ul>
<li>
March 18, 2022, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end SupplyAirTemperature;
