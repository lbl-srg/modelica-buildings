within Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.Validation;
block SupplyAirTemperature
  "Validation model for supply air temperature setpoint subsequence"

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature TSupAir(
    final have_coolingCoil=true,
    final have_heatingCoil=true)
    "Instance demonstrating heating signal operation"
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature TSupAir3(
    final have_coolingCoil=true,
    final have_heatingCoil=false)
    "Instance demonstrating cooling signal operation when heating coil is absent"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature TSupAir2(
    final have_coolingCoil=false,
    final have_heatingCoil=true)
    "Instance demonstrating heating signal operation when cooling coil is absent"
    annotation (Placement(transformation(extent={{-50,-100},{-30,-80}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature TSupAir1(
    final have_coolingCoil=true,
    final have_heatingCoil=true)
    "Instance demonstrating cooling signal operation"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=20,
    final freqHz=1/50,
    final offset=273.15 + 23)
    "Supply air temperature signal"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin3(
    final amplitude=20,
    final freqHz=1/50,
    final offset=273.15 + 23)
    "Supply air temperature signal"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin5(
    final amplitude=0.5,
    final freqHz=1/100,
    final offset=0.5)
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin6(
    final amplitude=20,
    final freqHz=1/50,
    final offset=273.15 + 23)
    "Supply air temperature signal"
    annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin8(
    final amplitude=0.5,
    final freqHz=1/100,
    final offset=0.5)
    "Heating loop signal"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin4(
    final amplitude=20,
    final freqHz=1/50,
    final offset=273.15 + 23)
    "Supply air temperature signal"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=273.15 + 21)
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-90,120},{-70,140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=273.15 + 25)
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=273.15 + 21)
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=273.15 + 25)
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
    final k=273.15 + 21)
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con6(
    final k=273.15 + 25)
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con5(
    final k=0.25)
    "Heating loop signal"
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con7(
    final k=0)
    "Heating loop signal"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con8(
    final k=0)
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con9(
    final k=0.25)
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con10(
    final k=true)
    "Boolean fale signal"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));

equation
  connect(sin.y, TSupAir.TAirSup)
    annotation (Line(points={{-68,70},{-60,70},{-60,68.3333},{-52,68.3333}},
                                                 color={0,0,127}));

  connect(sin6.y, TSupAir2.TAirSup)
    annotation (Line(points={{-68,-90},{-60,-90},{-60,-91.6667},{-52,-91.6667}},
                                                   color={0,0,127}));

  connect(sin8.y, TSupAir2.uHea) annotation (Line(points={{-68,-60},{-60,-60},{
          -60,-88.3333},{-52,-88.3333}},
                               color={0,0,127}));

  connect(sin4.y,TSupAir1. TAirSup)
    annotation (Line(points={{62,70},{70,70},{70,68.3333},{78,68.3333}},
                                               color={0,0,127}));

  connect(con.y, TSupAir.TZonSetHea) annotation (Line(points={{-68,130},{-56,130},
          {-56,75},{-52,75}},      color={0,0,127}));

  connect(con1.y, TSupAir.TZonSetCoo) annotation (Line(points={{-68,10},{-56,10},
          {-56,61.6667},{-52,61.6667}},
                              color={0,0,127}));

  connect(con2.y, TSupAir1.TZonSetHea) annotation (Line(points={{62,130},{72,130},
          {72,75},{78,75}},      color={0,0,127}));

  connect(con3.y, TSupAir1.TZonSetCoo) annotation (Line(points={{62,10},{72,10},
          {72,61.6667},{78,61.6667}},
                            color={0,0,127}));

  connect(con4.y, TSupAir2.TZonSetHea) annotation (Line(points={{-68,-30},{-56,-30},
          {-56,-85},{-52,-85}},      color={0,0,127}));

  connect(con6.y, TSupAir3.TZonSetCoo) annotation (Line(points={{42,-120},{54,
          -120},{54,-78.3333},{58,-78.3333}},
                                    color={0,0,127}));

  connect(con5.y, TSupAir.uHea) annotation (Line(points={{-68,100},{-60,100},{
          -60,71.6667},{-52,71.6667}},
                             color={0,0,127}));

  connect(con7.y, TSupAir1.uHea) annotation (Line(points={{62,100},{68,100},{68,
          71.6667},{78,71.6667}},
                        color={0,0,127}));

  connect(con8.y, TSupAir.uCoo) annotation (Line(points={{-68,40},{-60,40},{-60,
          65},{-52,65}}, color={0,0,127}));

  connect(con9.y, TSupAir1.uCoo) annotation (Line(points={{62,40},{70,40},{70,65},
          {78,65}},     color={0,0,127}));

  connect(sin5.y, TSupAir3.uCoo) annotation (Line(points={{42,-90},{52,-90},{52,
          -75},{58,-75}}, color={0,0,127}));

  connect(sin3.y, TSupAir3.TAirSup) annotation (Line(points={{42,-60},{52,-60},
          {52,-71.6667},{58,-71.6667}},
                              color={0,0,127}));

  connect(con10.y, TSupAir.uFan) annotation (Line(points={{-98,-10},{-54,-10},{
          -54,78.3333},{-52,78.3333}},
                                   color={255,0,255}));
  connect(con10.y, TSupAir1.uFan) annotation (Line(points={{-98,-10},{74,-10},{
          74,78.3333},{78,78.3333}},
                                  color={255,0,255}));
  connect(con10.y, TSupAir2.uFan) annotation (Line(points={{-98,-10},{-54,-10},
          {-54,-81.6667},{-52,-81.6667}},color={255,0,255}));
  connect(con10.y, TSupAir3.uFan) annotation (Line(points={{-98,-10},{54,-10},{
          54,-61.6667},{58,-61.6667}},
                                    color={255,0,255}));
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
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/FanCoilUnit/Subsequences/Validation/SupplyAirTemperature.mos"
    "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature\">
      Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature</a>. 
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
      </html>"),
    experiment(
      StopTime=3600,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end SupplyAirTemperature;
