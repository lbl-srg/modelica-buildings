within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Initial_WSE "Validate initial stage sequence for a plant with WSE"

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant lowAvaSta(k=1)
    "Lowest chiller stage that is available "
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Initial iniSta(hasWSE=true) "Tests option to initialize stage at WSE only"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  CDL.Integers.Sources.Constant                        lowAvaSta1(k=1)
    "Lowest chiller stage that is available "
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Initial iniSta1(hasWSE=true)
    "Tests option to initialize stage at lowest available stage"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  CDL.Continuous.Sources.Sine                        outTem(
    final amplitude=7.5,
    final freqHz=1/(24*3600),
    final offset=282.15) "Outdoor temperature"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  CDL.Continuous.Sources.Sine                        TOutWetSig1(
    final amplitude=2,
    final freqHz=1/28800,
    final offset=aveTWetBul - 10)
    "Measured outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-160,2},{-140,22}})));
  CDL.Continuous.Sources.Ramp                        ram(
    final offset=-0.2,
    final height=0.7,
    final duration=86400) "Ramp output"
    annotation (Placement(transformation(extent={{-160,-78},{-140,-58}})));
  CDL.Discrete.Sampler                        sam1(final samplePeriod=800)
    "Ideal sampler of a continuous signal"
    annotation (Placement(transformation(extent={{-120,-78},{-100,-58}})));
equation
  connect(lowAvaSta.y, iniSta.uUp)
    annotation (Line(points={{-58,-50},{-50,-50},{-50,0},{-42,0}},
                                              color={255,127,0}));
  connect(lowAvaSta1.y, iniSta1.uUp) annotation (Line(points={{42,-50},{50,-50},
          {50,0},{58,0}}, color={255,127,0}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Initial_noWSE.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Initial\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Initial</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 28, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-100,-80},{100,80}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})));
end Initial_WSE;
