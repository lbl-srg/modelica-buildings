within Buildings.Fluids.BaseClasses;
partial model PartialThreeWayResistance
  "Flow splitter with partial resistance model at each port"
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                      graphics),
                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                            graphics),
    Documentation(info="<html>
<p>
Partial model for flow resistances with three ports such as a 
flow mixer/splitter or a three way valve.
</p>
</html>"),
revisions="<html>
<ul>
<li>
September 18, 2008 by Michael Wetter:<br>
Replaced splitter model with a fluid port since the 
splitter model in Modelica_Fluid 1.0 beta does not transport
<tt>mC_flow</tt>.
<li>
June 11, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Fluid medium model" 
      annotation (choicesAllMatching=true);

  Modelica_Fluid.Interfaces.FluidPort_a port_1(redeclare package Medium = 
        Medium, m_flow(min=if (portFlowDirection_1 == Modelica_Fluid.Types.PortFlowDirection.Entering) then 
                0.0 else -Modelica.Constants.inf, max=if (portFlowDirection_1
           == Modelica_Fluid.Types.PortFlowDirection.Leaving) then 0.0 else Modelica.Constants.inf)) 
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
          rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_b port_2(redeclare package Medium = 
        Medium, m_flow(min=if (portFlowDirection_2 == Modelica_Fluid.Types.PortFlowDirection.Entering) then 
                0.0 else -Modelica.Constants.inf, max=if (portFlowDirection_2
           == Modelica_Fluid.Types.PortFlowDirection.Leaving) then 0.0 else Modelica.Constants.inf)) 
    annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=
           0)));
  Modelica_Fluid.Interfaces.FluidPort_a port_3(
    redeclare package Medium=Medium,
    m_flow(min=if (portFlowDirection_3==Modelica_Fluid.Types.PortFlowDirection.Entering) then 0.0 else -Modelica.Constants.inf,
    max=if (portFlowDirection_3==Modelica_Fluid.Types.PortFlowDirection.Leaving) then 0.0 else Modelica.Constants.inf)) 
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}},
                                                                     rotation=
           0)));

 parameter Boolean from_dp = true
    "= true, use m_flow = f(dp) else dp = f(m_flow)" 
    annotation (Evaluate=true, Dialog(tab="Advanced"));
                                                                                                annotation (extent=[40,-10; 60,10]);
  replaceable Modelica_Fluid.Interfaces.PartialTwoPortTransport res1(redeclare
      package Medium = Medium)
    "Partial model, to be replaced with a fluid component" 
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}}, rotation=
            0)));
  replaceable Modelica_Fluid.Interfaces.PartialTwoPortTransport res2(redeclare
      package Medium = Medium)
    "Partial model, to be replaced with a fluid component" 
    annotation (Placement(transformation(extent={{40,-10},{60,10}}, rotation=0)));
  replaceable Modelica_Fluid.Interfaces.PartialTwoPortTransport res3(redeclare
      package Medium = Medium)
    "Partial model, to be replaced with a fluid component" 
    annotation (Placement(transformation(
        origin={0,-50},
        extent={{-10,10},{10,-10}},
        rotation=90)));

protected
  parameter Modelica_Fluid.Types.PortFlowDirection portFlowDirection_1=Modelica_Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_1" 
   annotation(Dialog(tab="Advanced"));
  parameter Modelica_Fluid.Types.PortFlowDirection portFlowDirection_2=Modelica_Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_2" 
   annotation(Dialog(tab="Advanced"));
  parameter Modelica_Fluid.Types.PortFlowDirection portFlowDirection_3=Modelica_Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_3" 
   annotation(Dialog(tab="Advanced"));

equation
  connect(port_1, res1.port_a) annotation (Line(points={{-100,0},{-100,0},{-60,
          0}},                                                      color={0,
          127,255}));
  connect(res2.port_b, port_2) annotation (Line(points={{60,0},{60,0},{100,0}},
                                                               color={0,127,255}));
  connect(res3.port_a, port_3) annotation (Line(points={{-6.12323e-016,-60},{
          -6.12323e-016,-79},{0,-79},{0,-100}},                      color={0,
          127,255}));
  connect(res1.port_b, res2.port_a) annotation (Line(
      points={{-40,0},{40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, res3.port_b) annotation (Line(
      points={{-40,0},{6.12323e-016,0},{6.12323e-016,-40}},
      color={0,127,255},
      smooth=Smooth.None));
end PartialThreeWayResistance;
