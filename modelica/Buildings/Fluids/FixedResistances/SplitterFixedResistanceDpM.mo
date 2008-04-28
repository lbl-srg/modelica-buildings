model SplitterFixedResistanceDpM 
  "Flow splitter with fixed resistance at each port" 
    extends Buildings.BaseClasses.BaseIconLow;
  annotation (Diagram, Icon(
      Rectangle(extent=[-58,96; 62,66], style(
          pattern=0,
          fillColor=7,
          rgbfillColor={255,255,255})),
                   Polygon(points=[-100,60; -24,50; -24,100; 22,100; 22,48; 100,
            38; 100,-26; -100,-42; -100,60], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=9,
          rgbfillColor={175,175,175},
          fillPattern=1)), Polygon(points=[-100,40; -14,40; -14,100; 14,100; 14,
            40; 100,26; 100,-16; -100,-30; -100,40], style(
          color=0,
          rgbcolor={0,0,0},
          gradient=2,
          fillColor=69,
          rgbfillColor={0,128,255}))),
    Documentation(revisions="<html>
<ul>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Model of a flow splitter (or mixer) with a fixed resistance in each flow leg.
</p>
</html>"));
  
  import SI = Modelica.SIunits;
  
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium 
    "Fluid medium model" 
      annotation (choicesAllMatching=true);
  
  Modelica_Fluid.Interfaces.FluidPort_b port_1(redeclare package Medium = 
        Medium) annotation (extent=[-120,-10; -100,10]);
  Modelica_Fluid.Interfaces.FluidPort_b port_2(redeclare package Medium = 
        Medium) annotation (extent=[100,-10; 120,10]);
  Modelica_Fluid.Interfaces.FluidPort_b port_3(redeclare package Medium = 
        Medium) annotation (extent=[-10,100; 10,120]);
  
  Medium.AbsolutePressure pMix "Pressure";
  Medium.SpecificEnthalpy hMix "Mixing enthalpy";
  Medium.MassFraction XiMix[Medium.nXi] 
    "Independent mixture mass fractions m_i/m";
  
  parameter Boolean from_dp = true 
    "= true, use m_flow = f(dp) else dp = f(m_flow)" 
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter SI.MassFlowRate[3] m0_flow(each min=0) "Mass flow rate" annotation(Dialog(group = "Nominal Condition"));
  parameter SI.Pressure[3] dp0(each min=0) "Pressure" annotation(Dialog(group = "Nominal Condition"));
  parameter SI.Length[3] dh={1, 1, 1} "Hydraulic diameter";
  parameter Real[3] ReC={4000, 4000, 4000} 
    "Reynolds number where transition to laminar starts";
  
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res1(
                          from_dp=from_dp, m0_flow=m0_flow[1], dp0=dp0[1], ReC=ReC[1],
    redeclare package Medium=Medium) "Resistance 1"       annotation (extent=[-40,-10; -60,10]);
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res2(
                          from_dp=from_dp, m0_flow=m0_flow[2], dp0=dp0[2], ReC=ReC[2],
     redeclare package Medium=Medium) "Resistance 2"      annotation (extent=[40,-10; 60,10]);
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res3(
                          from_dp=from_dp, m0_flow=m0_flow[3], dp0=dp0[3], ReC=ReC[3],
     redeclare package Medium=Medium) "Resistance 3"      annotation (extent=[-10,32; 10,52],
      rotation=90);
  
  Modelica_Fluid.Junctions.Splitter spl(redeclare package Medium=Medium) annotation (extent=[-10,-10; 10,10]);
equation 
  pMix = spl.p;
  hMix = spl.hMix;
  XiMix   = spl.Xi;
  connect(port_1, res1.port_b) annotation (points=[-110,5.55112e-16; -97.5,
        5.55112e-16; -97.5,1.16573e-15; -85,1.16573e-15; -85,6.10623e-16; -60,
        6.10623e-16],                                              style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=7,
      rgbfillColor={255,255,255},
      fillPattern=1));
  connect(res2.port_b, port_2) annotation (points=[60,6.10623e-16; 72.5,
        6.10623e-16; 72.5,1.16573e-15; 85,1.16573e-15; 85,5.55112e-16; 110,
        5.55112e-16],                                            style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=7,
      rgbfillColor={255,255,255},
      fillPattern=1));
  connect(res3.port_b, port_3) annotation (points=[1.1119e-15,52; 1.1119e-15,76;
        5.55112e-16,76; 5.55112e-16,110],
                                       style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=7,
      rgbfillColor={255,255,255},
      fillPattern=1));
  connect(spl.port_2, res2.port_a) 
    annotation (points=[11,6.10623e-16; 18.25,6.10623e-16; 18.25,1.22125e-15;
        25.5,1.22125e-15; 25.5,6.10623e-16; 40,6.10623e-16],
                                     style(color=69, rgbcolor={0,127,255}));
  connect(res1.port_a, spl.port_1) 
    annotation (points=[-40,6.10623e-16; -32.75,6.10623e-16; -32.75,1.22125e-15;
        -25.5,1.22125e-15; -25.5,6.10623e-16; -11,6.10623e-16],
                                       style(color=69, rgbcolor={0,127,255}));
  connect(spl.port_3, res3.port_a) annotation (points=[6.10623e-16,11;
        6.10623e-16,32; -1.12703e-16,32],
                           style(color=69, rgbcolor={0,127,255}));
end SplitterFixedResistanceDpM;
