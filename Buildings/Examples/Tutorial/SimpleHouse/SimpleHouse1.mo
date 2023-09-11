within Buildings.Examples.Tutorial.SimpleHouse;
model SimpleHouse1 "Building wall model"
  extends SimpleHouseTemplate;

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor walCap(
    C=A_wall*d_wall*cp_wall*rho_wall, T(fixed=true))
    "Thermal mass of walls"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={150,0})));
equation
  connect(wallRes.port_b, walCap.port) annotation (Line(points={{100,0},{130,0},
          {130,1.77636e-15},{140,1.77636e-15}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -220},{200,200}})),
    experiment(Tolerance=1e-6, StopTime=1e+06),
    Documentation(revisions="<html>
<ul>
<li>
September 4, 2023, by Jelger Jansen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
A very simple building envelope model will be constructed manually using thermal resistors and heat capacitors.
The house consists of a wall represented by a single heat capacitor and a thermal resistor.
The thermal resistor and boundary temperature are already included in the template.
The wall has a surface area of <i>A<sub>wall</sub>=100 m<sup>2</i></sup>,
a thickness of <i>d<sub>wall</sub>=25 cm</i>,
a thermal conductivity of <i>k<sub>wall</sub>=0.04 W/(m K)</i>,
a density of <i>&rho;<sub>wall</sub>=2000 kg/m<sup>3</i></sup>,
and a specific heat capacity of <i>c<sub>p,wall</sub>= 1000 J/(kg K)</i>
</p>
<p>
These parameters are already declared in the equation section of
<a href=\"modelica://Buildings.Examples.Tutorial.SimpleHouse.SimpleHouseTemplate\">
Buildings.Examples.Tutorial.SimpleHouse.SimpleHouseTemplate.SimpleHouseTemplate</a>.
You can use this way of declaring parameters in the remainder of this exercise, but this is not required.
</p>
<p>
The conductive thermal resistance value of a wall may be computed as <i>R=d/(A*k)</i>.
The heat capacity value of a wall may be computed as <i>C=A*d*c_p*&rho;
</p>
<h4>Required models</h4>
<ul>
<li>
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.HeatCapacitor\">
Modelica.Thermal.HeatTransfer.Components.HeatCapacitor</a>
</li>
</ul>
<h4>Connection instructions</h4>
<p>
Connect the heat capacitor to the thermal resistor.
</p>
<h4>Reference result</h4>
<p>
If you correctly added the model of the heat capacitor,
connected it to the resistor and added the parameter values for <i>C</i>,
then you should be able to simulate the model.
To do this, press the <i>Simulation Setup</i> and set the model <i>Stop time</i> to 1e6 seconds.
You can now simulate the model by pressing the <i>Simulate</i> button.
</p>
<p>
You can plot individual variables values by clicking on their name in the variable browser on the left.
Now plot the wall capacitor temperature value <i>T</i>.
It should look like the figure below (1 Ms is around 12 days).
</p>
<p align=\"center\">
<img alt=\"Wall temperature as function of time.\"
src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/SimpleHouse/result1.png\" width=\"1000\"/>
</p>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/SimpleHouse/SimpleHouse1.mos"
        "Simulate and plot"));
end SimpleHouse1;
