within Buildings.Fluid.SolarCollectors.Controls.Examples;
model SolarPumpController
  "Example showing the use of CriticalSolarPumpController"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Fluid.SolarCollectors.Controls.SolarPumpController
                                                     pumCon(per=
        Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.SRCC2001002B(),conDel=
       0.01) "Model controlling the on/off status of the pump"
    annotation (Placement(transformation(extent={{-6,0},{14,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Weather data input file"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=20,
    offset=273.15 + 30,
    freqHz=0.0001) "Fake water inlet temperature"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(weaDat.weaBus, pumCon.weaBus)                      annotation (Line(
      points={{-40,30},{-20,30},{-20,16},{-6.2,16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sine.y, pumCon.TIn)                      annotation (Line(
      points={{-39,-10},{-20,-10},{-20,6},{-8,6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file=
          "Resources/Scripts/Dymola/Fluid/SolarCollector/Controls/Examples/CriticalSolarPumpController.mos"
        "Simulate and Plot"),
        Documentation(info="<html>
        <p>
        This model provides an example of how the SolarPumpController model is used. In it a SolarPumpController model reads weather data and inlet temperature data to determine
        whether the pump should be active or not.<br>
        </p>
        </html>",
        revisions="<html>
        <ul>
        <li>
        Mar 27, 2013 by Peter Grant:<br>
        First implementation
        </ul>
        </li>
        </html>"));
end SolarPumpController;
