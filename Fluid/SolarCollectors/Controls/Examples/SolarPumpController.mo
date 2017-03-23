within Buildings.Fluid.SolarCollectors.Controls.Examples;
model SolarPumpController "Example for the solar pump controller"
  extends Modelica.Icons.Example;
  Buildings.Fluid.SolarCollectors.Controls.SolarPumpController
        pumCon(per=
        Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_ThermaLiteHS20())
    "Model controlling the on/off status of the pump"
    annotation (Placement(transformation(extent={{-6,0},{14,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
     filNam="modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Weather data input file"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=20,
    freqHz=0.0001,
    offset=273.15 + 40) "Water inlet temperature"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(weaDat.weaBus, pumCon.weaBus)  annotation (Line(
      points={{-40,30},{-20,30},{-20,16},{-6.2,16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sine.y, pumCon.TIn)  annotation (Line(
      points={{-39,-10},{-20,-10},{-20,6},{-8,6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/Controls/Examples/SolarPumpController.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
      <p>
        This model illustrates the use of the 
        <a href=\"modelica://Buildings.Fluid.SolarCollectors.Controls.SolarPumpController\"> 
        Buildings.Fluid.SolarCollectors.Controls.SolarPumpController</a> model. 
        Based on weather data and inlet temperature, the controller switches the pump on 
        and off.
      </p>
    </html>",
    revisions="<html>
      <ul>
        <li>
          Mar 27, 2013 by Peter Grant:<br/>
          First implementation
        </li>
      </ul>
    </html>"));
end SolarPumpController;
