block ControlSignals "Generate ramp signal" 
  parameter Integer NSig=4 "Number of signals";
  parameter Real h[NSig]={0.7*22.333, 0.7*8, -20/90, -30/90} "Height of ramps";
  parameter Real dur[NSig](min=Modelica.Constants.small) = 0.25 *{1, 1, 1, 1} 
    "Durations of ramp";
  parameter Real y0[NSig]={0.3*22.333, 0.3*8, 55/90, 55/90} 
    "Offset of output signal";
  parameter Modelica.SIunits.Time staTim[NSig]=0.25*{0, 0, 1, 2} 
    "Output = offset for time < startTime";
  output Real y[NSig] "Control signal";
  
  extends Modelica.Blocks.Interfaces.BlockIcon;
  
  annotation (
    Coordsys(
      extent=[-100, -100; 100, 100],
      grid=[1, 1],
      component=[20, 20]),
    Window(
      x=0.19,
      y=0.02,
      width=0.59,
      height=0.77),
    Icon(
      Line(points=[-80, 68; -80, -80], style(color=8)),
      Polygon(points=[-80, 90; -88, 68; -72, 68; -80, 90], style(color=8,
             fillColor=8)),
      Line(points=[-90, -70; 82, -70], style(color=8)),
      Polygon(points=[90, -70; 68, -62; 68, -78; 90, -70], style(
          color=8,
          fillColor=8,
          fillPattern=1)),
      Line(points=[-80, -70; -40, -70; 31, 38], style(color=0)),
      Line(points=[31, 38; 86, 38], style(color=0)),
      Text(
        extent=[69,75; 95,47],
        style(color=3, rgbcolor={0,0,255}),
        string="yFan"),
      Text(
        extent=[68,15; 94,-13],
        style(color=3, rgbcolor={0,0,255}),
        string="yOSA"),
      Text(
        extent=[70,-43; 96,-71],
        style(color=3, rgbcolor={0,0,255}),
        string="yVAV")),
    Diagram,
Documentation(info="<html>
</html>"));
  Modelica.Blocks.Interfaces.RealOutput ySupFan "Fan control signal" 
    annotation (extent=[100,80; 120,100]);
  Modelica.Blocks.Interfaces.RealOutput yOSA 
    "Outside air mixing box control signal" 
    annotation (extent=[100,-10; 120,10]);
  Modelica.Blocks.Interfaces.RealOutput yVAV "VAV damper control signal" 
    annotation (extent=[100,-70; 120,-50]);
  Modelica.Blocks.Interfaces.RealOutput yRetFan "Fan control signal" 
    annotation (extent=[100,40; 120,60]);
equation 
  for i in 1:NSig loop
  y[i] = y0[i] + (if time < staTim[i] then 0 else if time < (staTim[i] +
    dur[i]) then (time - staTim[i])*h[i]/dur[i] else h[i]);
  end for;
  ySupFan=y[1];
  yRetFan=y[2];
  yOSA=y[3];
  yVAV=y[4];
end ControlSignals;
