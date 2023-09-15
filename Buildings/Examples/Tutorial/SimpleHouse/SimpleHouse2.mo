within Buildings.Examples.Tutorial.SimpleHouse;
model SimpleHouse2 "Building window model"
  extends SimpleHouse1;

  parameter Modelica.Units.SI.Area AWin=2 "Window area";

  Modelica.Blocks.Math.Gain gaiWin(k=AWin)
    "Gain for solar irradiance through the window"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow win
    "Very simple window model"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
equation
  connect(gaiWin.y, win.Q_flow)
    annotation (Line(points={{21,-20},{40,-20}},   color={0,0,127}));
  connect(win.port, walCap.port) annotation (Line(points={{60,-20},{130,-20},{
          130,1.77636e-15},{140,1.77636e-15}},
                                           color={191,0,0}));
  connect(gaiWin.u, weaBus.HDirNor) annotation (Line(points={{-2,-20},{-150,-20},
          {-150,-10}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
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
The window has a surface area of <i>2 m<sup>2</sup></i>.
In this simple model we will therefore assume that
two times the outdoor solar irradiance is injected as heat onto the inside of the wall.
</p>
<h4>Required models</h4>
<ul>
<li>
<a href=\"modelica://Modelica.Blocks.Math.Gain\">
Modelica.Blocks.Math.Gain</a>
</li>
<li>
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>
</li>
</ul>
<h4>Connection instructions</h4>
<p>
To be able to use the value of the outdoor solar irradiance
you will need to access the weather data reader.
To do this, make a connection to the <code>weaBus</code>.
In the dialog box select <i>&lt;New Variable&gt;</i> and here type <i>HDirNor</i>,
which is the direct solar irradiance on a surface of <i>1 m<sup>2</sup></i>,
perpendicular to the sun rays.
Set the gain factor <i>k</i> to 2,
in order to get the solar irradiance through the window of <i>2 m<sup>2</sup></i>.
</p>
<p>
Make a connection with the <code>PrescribedHeatFlow</code> as well.
This block makes the connection between the heat flow from the gain, represented as a real value,
and a heat port that is compatible with the connectors of the thermal capacitance and resistance.
</p>
<h4>Reference result</h4>
<p>
The result with and without the window model is plotted in the figure below.
</p>
<p align=\"center\">
<img alt=\"Wall temperature as function of time, with (blue) and without (red) window.\"
src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/SimpleHouse/result2.png\" width=\"1000\"/>
</p>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/SimpleHouse/SimpleHouse2.mos"
        "Simulate and plot"));
end SimpleHouse2;
