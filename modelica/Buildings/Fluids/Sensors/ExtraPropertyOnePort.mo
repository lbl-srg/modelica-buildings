model ExtraPropertyOnePort "Ideal wet bulb temperature sensor" 
  extends Modelica_Fluid.Sensors.BaseClasses.PartialAbsoluteSensor;
  
annotation (
  Diagram,
    Icon(
      Rectangle(extent=[-12,50; 12,-80], style(
          color=58,
          rgbcolor={0,127,0},
          pattern=0,
          fillColor=58,
          rgbfillColor={0,127,0})),
      Line(points=[0,-70; 0,-100], style(rgbcolor={0,0,127})),
      Polygon(points=[-12,50; -12,90; -10,96; -6,98; 0,100; 6,98; 10,96; 12,
            90; 12,50; -12,50],        style(color=0, thickness=2)),
      Line(points=[-12,50; -12,-80],   style(color=0, thickness=2)),
      Line(points=[12,50; 12,-80],   style(color=0, thickness=2)),
      Line(points=[-40,-10; -12,-10],   style(color=0)),
      Line(points=[-40,30; -12,30],   style(color=0)),
      Line(points=[-40,70; -12,70],   style(color=0)),
      Text(
        extent=[144,-42; 24,-92],
        style(pattern=0),
        string="C"),
      Text(extent=[-126,160; 138,98],   string="%name"),
      Line(points=[14,0; 100,0], style(color=0, rgbcolor={0,0,0})),
      Line(points=[-12,-80; 12,-80], style(color=0, thickness=2))),
    Documentation(info="<HTML>
<p>
This component monitors the concentration of a species defined in the vector
<tt>Medium.C</tt>. The sensor is ideal, i.e., it does not influence the fluid.
</p>
</HTML>
",
revisions="<html>
<ul>
<li>
September 22, 2008 by Michael Wetter:<br>
First implementation based on 
<a href=\"Modelica:Modelica_Fluid.Sensors.Temperature\">Modelica_Fluid.Sensors.Temperature</a>.
</li>
</ul>
</html>"));
  
  Modelica.Blocks.Interfaces.RealOutput C(
    redeclare type SignalType = Modelica.SIunits.MassFraction) 
    "Mass fraction of auxiliary component in the fluid" 
    annotation (extent=[100,-10; 120,10],   rotation=0);
  parameter String substanceName = "CO2" 
    "Name of species in vector of auxiliary substances";
//  constant Real con = 28.97/44.01*1E6 
//    "Conversion from mass fraction CO2 to part per million";
protected 
  parameter Integer ind(fixed=false) 
    "Index of species in vector of auxiliary substances";
  
initial algorithm 
  ind:= -1;
  for i in 1:Medium.nC loop
   if ( Modelica.Utilities.Strings.isEqual(Medium.extraPropertiesNames[i], substanceName)) then
    ind := i;
   end if;
  end for;
  assert(ind > 0, "Substance '" + substanceName + "' is not present in medium '"
           + Medium.mediumName + "'.\n"
           + "Check sensor parameter and medium model.");
  
equation 
  C = port.C[ind];
  ///////////////////////////////////////////////////////////////////////////////////
  // Extra species flow. This may be removed when upgrading to the new Modelica.Fluid. 
  port.mC_flow = zeros(Medium.nC);
  ///////////////////////////////////////////////////////////////////////////////////
end ExtraPropertyOnePort;
