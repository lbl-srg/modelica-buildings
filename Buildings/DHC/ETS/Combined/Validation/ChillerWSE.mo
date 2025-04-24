within Buildings.DHC.ETS.Combined.Validation;
model ChillerWSE
  "Validation of the ETS model with heat recovery chiller and waterside economizer"
  extends ChillerOnly(
    ets(
      have_WSE=true), TChiWatSupSet(k=12 + 273.15));
  Modelica.Blocks.Sources.CombiTimeTable TDisWatSup(
    tableName="tab1",
    table=[
      0,11;
      49,11;
      50,20;
      100,20],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600,
    offset={273.15},
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-330,-150},{-310,-130}})));
equation
  connect(loa.y[2],heaLoaNor.u)
    annotation (Line(points={{-309,160},{-300,160},{-300,60},{-252,60}},color={0,0,127}));
  connect(loa.y[1],loaCooNor.u)
    annotation (Line(points={{-309,160},{280,160},{280,60},{272,60}},color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/ETS/Combined/Validation/ChillerWSE.mos"
      "Simulate and plot"),
    experiment(
      StopTime=360000,
      Tolerance=1e-06),
    Documentation(
      revisions="<html>
<ul>
<li>
November 22, 2024, by Michael Wetter:<br/>
Removed duplicate connection.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.DHC.ETS.Combined.ChillerBorefield\">
Buildings.DHC.ETS.Combined.ChillerBorefield</a>
in a system configuration with no geothermal borefield.
</p>
<ul>
<li>
A fictitious load profile is used, consisting in the succession of five load
patterns.
</li>
<li>
Each load pattern is simulated with two values of the district water supply
temperature, corresponding to typical extreme values over a whole year
 of operation.
</li>
<li>
The other modeling assumptions are described in
<a href=\"modelica://Buildings.DHC.ETS.Combined.Validation.BaseClasses.PartialChillerBorefield\">
Buildings.DHC.ETS.Combined.Validation.BaseClasses.PartialChillerBorefield</a>.
</li>
</ul>
</html>"));
end ChillerWSE;
