within Buildings.Applications.DataCenters.DataHalls.Validation;
model ChillerWSEDesignConditionsWater
  "Validation model that tests the component configurations at design conditions, using water in all fluid loops"
  extends Buildings.Applications.DataCenters.DataHalls.Validation.ChillerWSEDesignConditionsGlycol(
    redeclare package MediumTow = Buildings.Media.Water,
    redeclare package MediumRac = Buildings.Media.Water,
    datCDU(
      medRac=Buildings.Applications.DataCenters.DataHalls.Types.Media.Water,
      phiGlyRac=0)
    );

  annotation (Diagram(coordinateSystem(extent={{-580,-120},{540,780}})),
    Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
      __Dymola_Commands(
       file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/DataHalls/Validation/ChillerWSEDesignConditionsWater.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation model that simulates
<a href=\"modelica://Buildings.Applications.DataCenters.DataHalls.Examples.ChillerWSE\">
Buildings.Applications.DataCenters.DataHalls.Examples.ChillerWSE</a>
at design conditions.
The model is identical to
<a href=\"modelica://Buildings.Applications.DataCenters.DataHalls.Validation.ChillerWSEDesignConditionsGlycol\">
Buildings.Applications.DataCenters.DataHalls.Validation.ChillerWSEDesignConditionsGlycol</a>
except that the media is set to water.
</p>
<p>
This model verifies that the media conversions are implemented correctly.
</p>
</html>", revisions="<html>
<ul>
<li>
June 24, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerWSEDesignConditionsWater;
