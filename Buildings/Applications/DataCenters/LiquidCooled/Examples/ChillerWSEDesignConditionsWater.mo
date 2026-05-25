within Buildings.Applications.DataCenters.LiquidCooled.Examples;
model ChillerWSEDesignConditionsWater
  "Validation model that tests the component configurations at design conditions, using water in all fluid loops"
  extends ChillerWSE(
    redeclare package MediumRac = Buildings.Media.Water,
    break weaDat,
    break weaBus,
    uti(k=1),
    fraWSE=0.9999,
    datCDU(
      medRac=Buildings.Applications.DataCenters.LiquidCooled.Types.Media.Water,
      phiGlyRac=0),
    yPumChi(realTrue=0)
    );
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDryBul_nominal(
    y(final unit="K",
      displayUnit="degC"), k(
      final unit="K",
      displayUnit="degC") = datCooTow.TAirIn_nominal)
                                    "Design dry bulb temperature"
    annotation (Placement(transformation(extent={{-80,658},{-60,678}})));
equation
  connect(TDryBul_nominal.y, cooTow.TDryBul) annotation (Line(points={{-58,668},
          {-48,668},{-48,623.3},{-11.9,623.3}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-580,-120},{540,780}})),
    Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
      __Dymola_Commands(
       file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/LiquidCooled/Examples/ChillerWSEDesignConditions.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation model that simulates
<a href=\"modelica://Buildings.Applications.DataCenters.LiquidCooled.Examples.ChillerWSE\">
Buildings.Applications.DataCenters.LiquidCooled.Examples.ChillerWSE</a>
at design conditions, with all media set to water.
</p>
<p>
This model verifies the design conditions if the media were water,
the system is designed for full economizer use,
and the IT utilization is 100%.
</p>
</html>", revisions="<html>
<ul>
<li>
May 22, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerWSEDesignConditionsWater;
