within Buildings.Applications.DHC.EnergyTransferStations.Examples;
model HeatpumpControllerBlock
  "Reverse heatpump controller operates in heating mode only"
  package Medium = Buildings.Media.Water "Medium model";

  Buildings.Applications.DHC.EnergyTransferStations.Control.HeatPumpController heaPumCon
    annotation (Placement(transformation(extent={{40,0},{60,18}})));

  Modelica.Blocks.Sources.BooleanPulse heaMod(width=50, period=500)
    "Step control"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Blocks.Sources.BooleanPulse cooMod(
                                              width=50,
                                              period=500,
                                              startTime=125)
    "Step control"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Sources.Constant TCooSet(k=7 + 273.15)
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Sources.Constant THeaSetMin(k=25 + 273.15)
    "Minimum heating set point temperature"
    annotation (Placement(transformation(extent={{-60,54},{-40,74}})));
  Modelica.Blocks.Sources.Constant THeaSetMax(k=50 + 273.15)
    "Maximum heating set point temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant TSouLvg(k=10 + 273.15)
    "Maximum heating set point temperature"
    annotation (Placement(transformation(extent={{-60,-84},{-40,-64}})));
  Modelica.Blocks.Sources.Constant THeaSet(k=30 + 273.15)
    "Heating set point temperature"
    annotation (Placement(transformation(extent={{-60,-16},{-40,4}})));
equation
  connect(heaPumCon.ReqHea, heaMod.y)
  annotation (Line(points={{38.6,17.1},{30,17.1},{30,70},{21,70}},
                              color={255,0,255}));
  connect(heaPumCon.ReqCoo,cooMod. y) annotation (Line(points={{38.6,14.4},{26,14.4},
          {26,40},{21,40}},     color={255,0,255}));
  connect(heaPumCon.TSetCoo, TCooSet.y) annotation (Line(points={{39,1.8},{16,1.8},
          {16,-40},{-39,-40}},        color={0,0,127}));
  connect(heaPumCon.TSetHeaMin, THeaSetMin.y) annotation (Line(points={{39,7.74},
          {-12,7.74},{-12,64},{-39,64}},color={0,0,127}));
  connect(THeaSetMax.y, heaPumCon.TSetHeaMax) annotation (Line(points={{-39,30},
          {-20,30},{-20,5.58},{39,5.58}}, color={0,0,127}));
  connect(TSouLvg.y,heaPumCon.TEvaLvg)  annotation (Line(points={{-39,-74},{22,-74},{22,0},{39,0}},
                                   color={0,0,127}));
  connect(THeaSet.y, heaPumCon.TSetHea) annotation (Line(points={{-39,-6},{-20,-6},
          {-20,3.6},{39,3.6}},     color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-98,-100},{98,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),  Diagram(coordinateSystem(preserveAspectRatio=false, extent={
            {-100,-140},{100,100}}),
        graphics={Line(points={{-22,22}}, color={28,108,200})}),
    experiment(StopTime=4500),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Control/HeatpumpControllerBlock.mos"
        "Simulate and plot"),
         experiment(Tolerance=1e-6, StopTime=2000),
Documentation(info="<html>
<p>
This model validates the controller block
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.HeatPumpController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.HeatPumpController</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
 <br/>
</li>
</ul>
</html>"));
end HeatpumpControllerBlock;
