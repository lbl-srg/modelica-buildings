partial model PartialThreeWayResistance 
  "Flow splitter with partial resistance model at each port" 
    extends Buildings.BaseClasses.BaseIcon;
  annotation (Diagram, Icon,
    Documentation(info="<html>
<p>
Partial model for flow resistances with three ports such as a 
flow mixer/splitter or a three way valve.
</p>
</html>"),
revisions="<html>
<ul>
<li>
June 11, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium 
    "Fluid medium model" 
      annotation (choicesAllMatching=true);
  Modelica_Fluid.Interfaces.FluidPort_b port_1(
        redeclare package Medium = Medium,
        m_flow(start=0,min=if allowFlowReversal then -Modelica.Constants.inf else 0)) annotation (extent=[-120,-10; -100,10]);
  Modelica_Fluid.Interfaces.FluidPort_b port_2(
        redeclare package Medium = Medium,
        m_flow(start=0,max=if allowFlowReversal then +Modelica.Constants.inf else 0)) annotation (extent=[100,-10; 120,10]);
  // For port_3, allowFlowReversal must not be specified because the flow
  // direction is different for a mixer and splitter
  Modelica_Fluid.Interfaces.FluidPort_b port_3(redeclare package Medium = 
        Medium) annotation (extent=[-10,-110; 10,-90]);
  
  Medium.AbsolutePressure pMix "Pressure";
  Medium.SpecificEnthalpy hMix "Mixing enthalpy";
  Medium.MassFraction XiMix[Medium.nXi] 
    "Independent mixture mass fractions m_i/m";
  
  parameter Boolean from_dp = true 
    "= true, use m_flow = f(dp) else dp = f(m_flow)" 
    annotation (Evaluate=true, Dialog(tab="Advanced"));
 parameter Modelica_Fluid.Types.FlowDirection.Temp flowDirection=
                   Modelica_Fluid.Types.FlowDirection.Bidirectional 
    "Unidirectional (port_1 -> port_2) or bidirectional flow component" 
     annotation(Dialog(tab="Advanced"));
                                                                                                annotation (extent=[40,-10; 60,10]);
  Modelica_Fluid.Junctions.Splitter spl(redeclare package Medium=Medium)       annotation (extent=[-10,10;
        10,-10]);
  replaceable Modelica_Fluid.Interfaces.PartialTwoPortTransport res1(redeclare 
      package Medium = Medium) 
    "Partial model, to be replaced with a fluid component" 
    annotation (extent=[-60,-10; -40,10]);
  replaceable Modelica_Fluid.Interfaces.PartialTwoPortTransport res2(redeclare 
      package Medium = Medium) 
    "Partial model, to be replaced with a fluid component" 
    annotation (extent=[60,-10; 40,10]);
  replaceable Modelica_Fluid.Interfaces.PartialTwoPortTransport res3(redeclare 
      package Medium = Medium) 
    "Partial model, to be replaced with a fluid component" 
    annotation (extent=[10,-60; -10,-40],
                                        rotation=90);
protected 
    parameter Boolean allowFlowReversal=
     flowDirection == Modelica_Fluid.Types.FlowDirection.Bidirectional 
    "= false, if flow only from port_a to port_b, otherwise reversing flow allowed"
     annotation(Evaluate=true, Hide=true);
equation 
  pMix = spl.p;
  hMix = spl.hMix;
  XiMix   = spl.Xi;
  connect(port_1, res1.port_a) annotation (points=[-110,5.55112e-16; -86,
        5.55112e-16; -86,6.10623e-16; -60,6.10623e-16], style(color=69,
        rgbcolor={0,127,255}));
  connect(res1.port_b, spl.port_1) annotation (points=[-40,6.10623e-16; -26,
        -1.22125e-15; -26,-6.10623e-16; -11,-6.10623e-16],
                          style(color=69, rgbcolor={0,127,255}));
  connect(spl.port_2, res2.port_b) annotation (points=[11,-6.10623e-16; 26,
        -3.36456e-22; 26,6.10623e-16; 40,6.10623e-16],  style(color=69,
        rgbcolor={0,127,255}));
  connect(res2.port_a, port_2) annotation (points=[60,6.10623e-16; 88,
        6.10623e-16; 88,5.55112e-16; 110,5.55112e-16], style(color=69, rgbcolor=
         {0,127,255}));
  connect(spl.port_3, res3.port_b) annotation (points=[6.10623e-16,-11; 
        6.10623e-16,-25.5; -1.1119e-15,-25.5; -1.1119e-15,-40], style(color=69,
        rgbcolor={0,127,255}));
  connect(res3.port_a, port_3) annotation (points=[1.12703e-16,-60; 1.12703e-16,
        -79; 5.55112e-16,-79; 5.55112e-16,-100], style(color=69, rgbcolor={0,
          127,255}));
end PartialThreeWayResistance;
