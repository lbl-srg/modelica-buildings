block DewPointTemperature 
  "Model to compute the dew point temperature of moist air" 
 extends Modelica.Blocks.Interfaces.BlockIcon;
    annotation (
    Diagram,
    Documentation(info="<html>
<p>
Dew point temperature calculation for moist air above freezing temperature.
</p>
<p>
The correlation used in this model is valid for dew point temperatures between 
<tt>0 degC</tt> and <tt>200 degC</tt>. It is the correlation from 2005
ASHRAE Handbook, p. 6.2. In an earlier version of this model, the equation from
Peppers has been used, but this equation yielded about 15 Kelvin lower dew point 
temperatures.
</p>
</html>", revisions="<html>
<ul>
<li>
August 7, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      Text(
        extent=[104,44; 142,-2],
        style(color=3, rgbcolor={0,0,255}),
        string="p_w"),
      Text(
        extent=[-124,46; -86,0],
        style(color=3, rgbcolor={0,0,255}),
        string="TDP"),
      Line(points=[70,86; 70,-72], style(color=0, rgbcolor={0,0,0})),
      Line(points=[82,-72; -66,-72], style(color=0, rgbcolor={0,0,0})),
      Line(points=[-68,-46; -54,-42; -24,-30; 8,-2; 20,22; 28,54; 32,74], style(color=0, rgbcolor={
              0,0,0})),
      Line(points=[42,-32; -28,-32], style(
          color=1,
          rgbcolor={255,0,0},
          thickness=2)),
      Polygon(points=[-28,-32; -14,-30; -14,-34; -28,-32], style(
          color=1,
          rgbcolor={255,0,0},
          fillColor=1,
          rgbfillColor={255,0,0})),
      Polygon(points=[84,-72; 74,-70; 74,-74; 84,-72], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0},
          fillPattern=1)),
      Polygon(points=[70,86; 72,72; 68,72; 70,86], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0},
          fillPattern=1)),
      Text(
        extent=[74,84; 96,66],
        string="X",
        style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Text(
        extent=[82,-80; 92,-96],
        style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0}),
        string="T")));
  Modelica.Blocks.Interfaces.RealOutput p_w(redeclare type SignalType = 
        Modelica.SIunits.Pressure (
        min=0,
        start=10000,
        nominal=10000)) "Water vapor partial pressure" 
    annotation (extent=[100,-10; 120,10]);
  Modelica.Blocks.Interfaces.RealInput T(redeclare type SignalType = 
        Modelica.SIunits.Temperature (
        min=200,
        max=400,
        start=283.15,
        nominal=100)) "Dew point temperature" 
    annotation (extent=[-120,-10; -100,10]);
protected 
  constant Real C8 = -5.800226E3;
  constant Real C9 =  1.3914993E0;
  constant Real C10= -4.8640239E-2;
  constant Real C11 = 4.1764768E-5;
  constant Real C12= -1.4452093E-8;
  constant Real C13 = 6.5459673E0;
equation 
 p_w = Modelica.Math.exp(C8/T + C9 + T * ( C10
           + T * ( C11 + T * C12))  + C13 * Modelica.Math.log(T));
end DewPointTemperature;
