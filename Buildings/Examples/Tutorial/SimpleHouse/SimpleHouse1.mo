within Buildings.Examples.Tutorial.SimpleHouse;
model SimpleHouse1 "Building wall model"
  extends SimpleHouse0;

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor walCap(
    C=AWall*dWall*cpWall*rhoWall,
    T(fixed=true))
    "Thermal mass of wall"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={170,0})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor walRes(
    R=dWall/AWall/kWall) "Thermal resistor for wall: 25 cm of rockwool"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(walRes.port_b, walCap.port) annotation (Line(points={{80,0},{100,0},{100,
          1.77636e-15},{160,1.77636e-15}},      color={191,0,0}));
  connect(TOut.port, walRes.port_a)
    annotation (Line(points={{-60,0},{60,0}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,
            -220},{220,220}})),
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
The boundary temperature are already included in
<a href=\"modelica://Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse0\">
Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse0</a>.
The wall has a surface area of <i>A<sub>wall</sub>=100 m<sup>2</sup></i>,
a thickness of <i>d<sub>wall</sub>=25 cm</i>,
a thermal conductivity of <i>k<sub>wall</sub>=0.04 W/(m K)</i>,
a density of <i>&rho;<sub>wall</sub>=2000 kg/m<sup>3</sup></i>,
and a specific heat capacity of <i>c<sub>p,wall</sub>= 1000 J/(kg K)</i>
</p>
<p>
These parameters are already declared in the equation section of
<a href=\"modelica://Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse0\">
Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse0</a>.
You can use this way of declaring parameters in the remainder of this exercise, but this is not required.
</p>
<p>
The conductive thermal resistance value of a wall may be computed as <i>R=d/(A*k)</i>.
The heat capacity value of a wall may be computed as <i>C=A*d*c<sub>p</sub>*&rho;</i>
</p>
<h4>Required models</h4>
<ul>
<li>
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.HeatCapacitor\">
Modelica.Thermal.HeatTransfer.Components.HeatCapacitor</a>
</li>
<li>
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.ThermalResistor\">
Modelica.Thermal.HeatTransfer.Components.ThermalResistor</a>
</li>
</ul>
<h4>Connection instructions</h4>
<p>
Connect one side of the thermal resistor to the output of <code>PrescribedTemperature</code>
and the other side of the thermal resistor to the heat capacitor.
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
