model RoomLeakage "Room leakage model" 
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium = 
      Modelica.Media.Interfaces.PartialMedium "Medium in the component" 
             annotation (choicesAllMatching = true);
  annotation (Diagram, Icon(
         Ellipse(extent=[-80,40; 0,-40],      style(
          color=69,
          gradient=3,
          fillColor=69)),
      Rectangle(extent=[20,12; 80,-12],      style(
          color=0,
          gradient=2,
          fillColor=8)),
      Rectangle(extent=[20,6; 80,-6],        style(
          color=69,
          gradient=2,
          fillColor=69)),
      Line(points=[-100,0; -80,0], style(color=3, rgbcolor={0,0,255})),
      Line(points=[0,0; 20,0], style(color=3, rgbcolor={0,0,255})),
      Line(points=[80,0; 90,0], style(color=3, rgbcolor={0,0,255})),
      Text(
        extent=[-136,54; -104,14],
        style(color=3, rgbcolor={0,0,255}),
        string="P")),
    Documentation(info="<html>
<p>
Room leakage used in the MIT system model.
</p></html>", revisions="<html>
<ul>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res(
    m0_flow=1,
    dp0=1000,
    redeclare package Medium = Medium) "Resistance model" 
                                      annotation (extent=[20,-10; 40,10]);
  
  Modelica.Blocks.Interfaces.RealInput p(redeclare type SignalType = 
        Modelica.SIunits.AbsolutePressure) "Pressure" 
    annotation (extent=[-140,-20; -100,20]);
  Modelica_Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = 
        Medium)                 annotation (extent=[90,-10; 110,10]);
  
  Buildings.Fluids.Sources.PrescribedBoundary_pTX amb(redeclare package Medium = Medium, p=101325, T=293.15) 
    annotation (extent=[-40,-10; -20,10]);
equation 
  connect(res.port_b, port_b) 
    annotation (points=[40,6.10623e-16; 55,6.10623e-16; 55,1.16573e-15; 70,
        1.16573e-15; 70,5.55112e-16; 100,5.55112e-16],
                                      style(color=69, rgbcolor={0,127,255}));
  connect(amb.port, res.port_a) annotation (points=[-20,6.10623e-16; 0,
        -3.36456e-22; 0,6.10623e-16; 20,6.10623e-16],
                                        style(color=69, rgbcolor={0,127,255}));
  connect(p, amb.p_in) annotation (points=[-120,1.11022e-15; -81,1.11022e-15;
        -81,6; -42,6], style(color=74, rgbcolor={0,0,127}));
end RoomLeakage;
