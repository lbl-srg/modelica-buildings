model HumidityRatioPressure 
  "Relation between humidity ratio and water vapor pressure" 
  extends Buildings.BaseClasses.BaseIcon;
  annotation (
    Diagram,
    Documentation(info="<html>
<p>
Model to compute the relation between humidity ratio and water vapor partial pressure
of moist air.</p>
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
      Rectangle(extent=[-100,100; 100,-100], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=7,
          rgbfillColor={255,255,255})),
      Text(
        extent=[-62,134; 60,10],
        style(color=0, rgbcolor={0,0,0}),
        string="p_w"),
      Text(
        extent=[-22,-16; 26,-84],
        string="X",
        style(color=0, rgbcolor={0,0,0})),
      Line(points=[-4,26; -4,-16], style(color=0, rgbcolor={0,0,0})),
      Polygon(points=[-4,-16; 0,0; -8,0; -4,-16], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Polygon(points=[-4,30; 0,12; -8,12; -4,30], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0}))));
  parameter Modelica.SIunits.Pressure pAtm = 101325 "Fixed value of pressure" 
          annotation (Evaluate = true,
                Dialog(enable = (cardinality(p)==0)));
  Modelica.Blocks.Interfaces.RealSignal p(redeclare type SignalType = 
        Modelica.SIunits.Pressure (start=101325, nominal=100000)) "Pressure" 
    annotation (extent=[-100,-10; -80,10], style(fillColor=0, rgbfillColor={0,0,
          0}));
  Modelica.Blocks.Interfaces.RealSignal XWat(redeclare type SignalType = 
        Modelica.SIunits.MassFraction (start=0.01)) 
    "Species concentration at dry bulb temperature" 
    annotation (extent=[-100,-80; -80,-60], style(fillColor=0, rgbfillColor={0,
          0,0}));
  Modelica.Blocks.Interfaces.RealSignal p_w(redeclare type SignalType = 
        Modelica.SIunits.Pressure (
        start=10000,
        nominal=10000,
        min=0)) "Water vapor pressure" 
    annotation (extent=[-100,60; -80,80], style(fillColor=0, rgbfillColor={0,0,
          0}));
  
  annotation (Diagram, Icon);
  Modelica.SIunits.MassFraction X_dryAir 
    "Water mass fraction per mass of dry air";
equation 
  if cardinality(p)==0 then
    p = pAtm;
  end if;
  X_dryAir = (XWat/(1-XWat));
 ( p - p_w)   * X_dryAir = 0.62198 * p_w;
end HumidityRatioPressure;
