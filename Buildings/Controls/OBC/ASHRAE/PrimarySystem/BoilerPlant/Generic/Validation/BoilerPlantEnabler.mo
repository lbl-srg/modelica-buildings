within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Validation;
model BoilerPlantEnabler "Validation model for BoilerPlantEnabler sequence"
  CDL.Continuous.Sources.Sine sin(
    amplitude=2,
    freqHz=1/(6*60),
    offset=2,
    startTime=1)
    annotation (Placement(transformation(extent={{-92,66},{-72,86}})));
  CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{-62,66},{-42,86}})));
  CDL.Continuous.Sources.Sine sin1(
    amplitude=2/1.8,
    freqHz=1/700,
    phase=3.1415926535898,
    offset=273 + (80 - 32)/1.8,
    startTime=1)
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  CDL.Continuous.Sources.Sine sin2(
    amplitude=2,
    freqHz=1/(6*60),
    offset=2,
    startTime=1)
    annotation (Placement(transformation(extent={{-92,-38},{-72,-18}})));
  CDL.Conversions.RealToInteger reaToInt1
    annotation (Placement(transformation(extent={{-62,-38},{-42,-18}})));
  CDL.Conversions.RealToInteger reaToInt2
    annotation (Placement(transformation(extent={{40,66},{60,86}})));
  CDL.Continuous.Sources.Sine sin5(
    amplitude=2/1.8,
    freqHz=1/700,
    phase=3.1415926535898,
    offset=273 + (80 - 32)/1.8,
    startTime=1)
    annotation (Placement(transformation(extent={{12,30},{32,50}})));
  CDL.Conversions.RealToInteger reaToInt3
    annotation (Placement(transformation(extent={{38,-38},{58,-18}})));
  CDL.Continuous.Sources.Constant con(k=3)
    annotation (Placement(transformation(extent={{10,66},{30,86}})));
  CDL.Continuous.Sources.Constant con1(k=273 + (75 - 32)/1.8)
    annotation (Placement(transformation(extent={{-92,-70},{-72,-50}})));
  CDL.Continuous.Sources.Constant con2(k=3)
    annotation (Placement(transformation(extent={{8,-38},{28,-18}})));
  CDL.Continuous.Sources.Constant con3(k=273 + (75 - 32)/1.8)
    annotation (Placement(transformation(extent={{8,-70},{28,-50}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.BoilerPlantEnabler
    boiPlaEna(
    nHotWatReqIgn=2,
              TLocOut(displayUnit="K"), boiPlaOffStaHolTimVal=10*60,
    boiEnaSchTab=[0,0; 1,1; 18,1; 23,1])
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.BoilerPlantEnabler
    boiPlaEna1(nHotWatReqIgn=2)
    annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.BoilerPlantEnabler
    boiPlaEna2(nHotWatReqIgn=2)
               annotation (Placement(transformation(extent={{70,40},{90,60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.BoilerPlantEnabler
    boiPlaEna3(nHotWatReqIgn=2, boiEnaSchTab=[0,0; 1,1; 18,1; 23,1])
    annotation (Placement(transformation(extent={{70,-60},{90,-40}})));
equation
  connect(sin.y, reaToInt.u)
    annotation (Line(points={{-70,76},{-64,76}}, color={0,0,127}));
  connect(sin2.y, reaToInt1.u)
    annotation (Line(points={{-70,-28},{-64,-28}}, color={0,0,127}));
  connect(con.y, reaToInt2.u)
    annotation (Line(points={{32,76},{38,76}}, color={0,0,127}));
  connect(reaToInt3.u, con2.y)
    annotation (Line(points={{36,-28},{30,-28}}, color={0,0,127}));
  connect(boiPlaEna.hotWatSupResReq, reaToInt.y) annotation (Line(points={{-32,55},
          {-38,55},{-38,76},{-40,76}}, color={255,127,0}));
  connect(boiPlaEna.TOut, sin1.y) annotation (Line(points={{-32,45},{-52,45},{-52,
          40},{-68,40}}, color={0,0,127}));
  connect(boiPlaEna1.hotWatSupResReq, reaToInt1.y) annotation (Line(points={{-32,
          -45},{-38,-45},{-38,-28},{-40,-28}}, color={255,127,0}));
  connect(boiPlaEna1.TOut, con1.y) annotation (Line(points={{-32,-55},{-52,-55},
          {-52,-60},{-70,-60}}, color={0,0,127}));
  connect(boiPlaEna2.hotWatSupResReq, reaToInt2.y) annotation (Line(points={{68,
          55},{66,55},{66,76},{62,76}}, color={255,127,0}));
  connect(boiPlaEna2.TOut, sin5.y) annotation (Line(points={{68,45},{52,45},{52,
          40},{34,40}}, color={0,0,127}));
  connect(boiPlaEna3.hotWatSupResReq, reaToInt3.y) annotation (Line(points={{68,
          -45},{64,-45},{64,-28},{60,-28}}, color={255,127,0}));
  connect(boiPlaEna3.TOut, con3.y) annotation (Line(points={{68,-55},{64,-55},{64,
          -60},{30,-60}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-72,26},{-24,18}},
          lineColor={28,108,200},
          textString="Combination of all inputs"),
        Text(
          extent={{32,26},{80,18}},
          lineColor={28,108,200},
          textString="Changing outdoor temperature"),
        Text(
          extent={{-80,-74},{-16,-82}},
          lineColor={28,108,200},
          textString="Changing number of hot-water requests"),
        Text(
          extent={{26,-74},{74,-82}},
          lineColor={28,108,200},
          textString="Changing boiler-enable schedule")}),
    experiment(
      StopTime=7200,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Generic/Validation/BoilerPlantEnabler.mos"
        "Simulate and plot"),
        Documentation(info="<html>
        <p>
        This example validates
        <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.BoilerPlantEnabler\">
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.BoilerPlantEnabler</a>.
        </p>
        </html>", revisions="<html>
        <ul>
        <li>
        April 17, 2020, by Karthik Devaprasad:<br/>
        First implementation.
        </li>
        </ul>
        </html>"));
end BoilerPlantEnabler;
