model DryBulbTemperatureDynamic "Ideal temperature sensor" 
  extends Modelica_Fluid.Sensors.BaseClasses.PartialFlowSensor;
annotation (
  Diagram,
    Icon(
      Ellipse(extent=[-20,-88; 20,-50],   style(
          color=0,
          thickness=2,
          fillColor=42)),
      Rectangle(extent=[-12,50; 12,-58],   style(color=42, fillColor=42)),
      Line(points=[0,-70; 0,-100], style(rgbcolor={0,0,127})),
      Polygon(points=[-12,50; -12,90; -10,96; -6,98; 0,100; 6,98; 10,96; 12,
            90; 12,50; -12,50],        style(color=0, thickness=2)),
      Line(points=[-12,50; -12,-54],   style(color=0, thickness=2)),
      Line(points=[12,50; 12,-54],   style(color=0, thickness=2)),
      Line(points=[-40,-10; -12,-10],   style(color=0)),
      Line(points=[-40,30; -12,30],   style(color=0)),
      Line(points=[-40,70; -12,70],   style(color=0)),
      Text(
        extent=[120,-40; 0,-90],
        style(color=0),
        string="T"),
      Text(extent=[-126,160; 138,98],   string="%name"),
      Line(points=[-100,0; -14,0], style(color=69, rgbcolor={0,128,255})),
      Line(points=[14,0; 100,0],   style(color=69, rgbcolor={0,128,255})),
      Text(
        extent=[14,116; 108,20],
        style(color=74, rgbcolor={0,0,127}),
        string="tau=10"),
      Line(points=[20,10; 24,26; 34,40; 54,52; 78,54; 96,54], style(color=74,
            rgbcolor={0,0,127}))),
    Documentation(info="<HTML>
<p>
This component monitors the temperature of the medium in the flow
between fluid ports. The sensor does not influence the fluid. Its output
is computed using a first order differential equation.
</p>
</HTML>
"),
revisions="<html>
<ul>
<li>
September 10, 2008 by Michael Wetter:<br>
First implementation based on 
<a href=\"Modelica:Modelica_Fluid.Sensors.Temperature\">Modelica_Fluid.Sensors.Temperature</a>.
</li>
</ul>
</html>");
  
  Medium.BaseProperties medium;
  parameter Modelica.SIunits.Time tau(min=0) = 10 "Time constant";
  Modelica.Blocks.Interfaces.RealOutput T(redeclare type SignalType = 
       Modelica.SIunits.Temperature(start=T_start)) 
    "Temperature in port medium" 
    annotation (extent=[-10,-120; 10,-100], rotation=-90);
  parameter Modelica.Blocks.Types.Init.Temp initType=Modelica.Blocks.Types.Init.NoInit 
    "Type of initialization (InitialState and InitialOutput are identical)"         annotation(Evaluate=true,
      Dialog(group="Initialization"));
  parameter Modelica.SIunits.Temperature T_start=Medium.T_default 
    "Initial or guess value of output (= state)" 
    annotation (Dialog(group="Initialization"));
  
initial equation 
  if initType == Modelica.Blocks.Types.Init.SteadyState then
    der(T) = 0;
  elseif initType == Modelica.Blocks.Types.Init.InitialState or 
         initType == Modelica.Blocks.Types.Init.InitialOutput then
    T = T_start;
  end if;
equation 
  port_a.p = medium.p;
  h  = medium.h;
  Xi = medium.Xi;
  der(T)  = (medium.T-T)/tau;
end DryBulbTemperatureDynamic;
