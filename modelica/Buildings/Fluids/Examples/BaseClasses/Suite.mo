within Buildings.Fluids.Examples.BaseClasses;
model Suite "Model of a suite consisting of five rooms of the MIT system model"
  extends Buildings.BaseClasses.BaseIconLow;

  replaceable package Medium = 
      Modelica.Media.Interfaces.PartialMedium "Medium in the component" 
             annotation (choicesAllMatching = true);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{400,200}}), graphics),
                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{400,200}}), graphics={
        Text(
          extent={{-140,146},{-108,106}},
          lineColor={0,0,255},
          textString="y"),
        Rectangle(
          extent={{-90,-38},{392,-42}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-90,122},{392,118}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-92,22},{390,18}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{18,118},{22,-38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,128,255}),
        Rectangle(
          extent={{78,118},{82,-38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,128,255}),
        Rectangle(
          extent={{140,118},{144,-38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,128,255}),
        Rectangle(
          extent={{198,118},{202,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,128,255}),
        Rectangle(
          extent={{258,120},{262,22}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,128,255}),
        Rectangle(
          extent={{258,-20},{262,-38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,128,255}),
        Rectangle(
          extent={{198,-8},{202,-38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,128,255}),
        Rectangle(
          extent={{258,10},{262,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,128,255}),
        Rectangle(
          extent={{198,10},{202,0}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,128,255}),
        Rectangle(
          extent={{200,4},{232,0}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{228,-18},{262,-22}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{198,-8},{262,-12}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{228,2},{232,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,128,255}),
        Text(
          extent={{-140,234},{-96,192}},
          lineColor={0,0,255},
          textString="PAtm"),
        Line(points={{-102,88},{240,88},{240,88}}, color={0,0,255}),
        Line(points={{-98,180},{228,180},{230,180}}, color={0,0,255}),
        Line(points={{230,180},{230,40},{260,20}}, color={0,0,255}),
        Rectangle(
          extent={{254,78},{268,58}},
          lineColor={0,0,255},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{194,78},{208,58}},
          lineColor={0,0,255},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{134,78},{148,58}},
          lineColor={0,0,255},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{72,78},{86,58}},
          lineColor={0,0,255},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,78},{26,58}},
          lineColor={0,0,255},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Line(points={{170,180},{170,40},{200,20}}, color={0,0,255}),
        Line(points={{110,180},{110,40},{140,20}}, color={0,0,255}),
        Line(points={{50,180},{50,40},{80,20}}, color={0,0,255}),
        Line(points={{-10,180},{-10,40},{20,20}}, color={0,0,255}),
        Line(points={{240,88},{256,76}}, color={0,0,255}),
        Line(points={{180,88},{196,76}}, color={0,0,255}),
        Line(points={{120,88},{136,76}}, color={0,0,255}),
        Line(points={{60,88},{76,76}}, color={0,0,255}),
        Line(points={{0,88},{16,76}}, color={0,0,255})}),
    Documentation(info="<html>
<p>
Model of a suite consisting of five rooms for the MIT system model.
</p></html>", revisions="<html>
<ul>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  Modelica.Blocks.Interfaces.RealInput p "Pressure" 
    annotation (Placement(transformation(extent={{-140,160},{-100,200}},
          rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_b port_aSup(redeclare package Medium = 
        Medium)                 annotation (Placement(transformation(extent={{
            -110,110},{-90,130}}, rotation=0)));
  parameter Modelica.SIunits.MassFlowRate m0Tot_flow = vav39.m0_flow+vav40.m0_flow+vav41.m0_flow+vav42.m0_flow+vav43.m0_flow;

  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM spl34(
                                              m0_flow=ones(3), dp0={0.176,0.844,
        0.0662},
    redeclare package Medium = Medium)                             annotation (Placement(
        transformation(extent={{10,110},{30,130}}, rotation=0)));
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM mix55(
                                              m0_flow=ones(3), dp0=1E3*{
        0.263200E-02,0.999990E-03,0.649000E-03},
    redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{10,-30},{30,-50}}, rotation=0)));
  Buildings.Fluids.Actuators.Dampers.VAVBoxExponential vav39(
    A=0.49,
    m0_flow=4.33*1.2,
    dp0=0.999E2,
    redeclare package Medium = Medium) 
    annotation (Placement(transformation(
        origin={20,60},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res13(
                                      m0_flow=1, dp0=0.1E3,
    redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{40,10},{60,30}}, rotation=0)));
  Buildings.Fluids.Actuators.Dampers.VAVBoxExponential vav40(
    A=0.245,
    m0_flow=2.369*1.2,
    dp0=0.999E2,
    redeclare package Medium = Medium) 
    annotation (Placement(transformation(
        origin={80,60},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Fluids.Actuators.Dampers.VAVBoxExponential vav41(
    dp0=0.999E2,
    A=0.128,
    m0_flow=0.837*1.2,
    redeclare package Medium = Medium) 
    annotation (Placement(transformation(
        origin={140,60},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Fluids.Actuators.Dampers.VAVBoxExponential vav42(
    dp0=0.999E2,
    A=0.128,
    m0_flow=0.801*1.2,
    redeclare package Medium = Medium) 
    annotation (Placement(transformation(
        origin={200,60},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Fluids.Actuators.Dampers.VAVBoxExponential vav43(
    dp0=0.999E2,
    A=0.0494,
    m0_flow=0.302*1.2,
    redeclare package Medium = Medium) 
    annotation (Placement(transformation(
        origin={260,58},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res14(
                                      m0_flow=1, dp0=0.1E3,
    redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{100,10},{120,30}}, rotation=0)));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res15(
                                      m0_flow=1, dp0=0.1E3,
    redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{160,10},{180,30}}, rotation=0)));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res16(
                                      m0_flow=1, dp0=0.1E3,
    redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{220,10},{240,30}}, rotation=0)));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM res17(
                                      m0_flow=1, dp0=0.1E3,
    redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{280,10},{300,30}}, rotation=0)));
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM spl35(
                                              m0_flow=ones(3), dp0=1E3*{
        0.371000E-04,0.259000E-02,0.131000E-02},
    redeclare package Medium = Medium)                             annotation (Placement(
        transformation(extent={{70,110},{90,130}}, rotation=0)));
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM spl36(
                                              m0_flow=ones(3), dp0=1E3*{
        0.211000E-03,0.128000E-01,0.223000E-02},
    redeclare package Medium = Medium)                             annotation (Placement(
        transformation(extent={{130,110},{150,130}}, rotation=0)));
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM spl37(
                                              m0_flow=ones(3), dp0=1E3*{
        0.730000E-03,0.128000E-01,0.938000E-02},
    redeclare package Medium = Medium)                             annotation (Placement(
        transformation(extent={{190,110},{210,130}}, rotation=0)));
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM spl38(
                                              m0_flow=ones(3), dp0=1E3*{
        0.731000E-02,0.895000E-01,0.942000E-01},
    redeclare package Medium = Medium)                             annotation (Placement(
        transformation(extent={{250,110},{270,130}}, rotation=0)));
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM mix54(
                                              m0_flow=ones(3), dp0=1E3*{
        0.653000E-02,0.271000E-03,0.402000E-04},
    redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{70,-30},{90,-50}}, rotation=0)));
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM mix53(
                                              m0_flow=ones(3), dp0=1E3*{
        0.566000E-01,0.541000E-02,0.749000E-04},
    redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{130,-30},{150,-50}}, rotation=
           0)));
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM mix52(
                                              m0_flow=ones(3), dp0=1E3*{
        0.353960,0.494000E-03,0.922000E-03},
    redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{190,-30},{210,-50}}, rotation=
           0)));
  Buildings.Fluids.FixedResistances.SplitterFixedResistanceDpM mix51(
                                              m0_flow=ones(3), dp0=1E3*{
        0.847600E-01,1.89750,0.150000E-02},
    redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{250,-30},{270,-50}}, rotation=
           0)));
  Buildings.Fluids.Examples.BaseClasses.RoomLeakage lea45(redeclare package
      Medium = 
        Medium) "Room leakage model" 
    annotation (Placement(transformation(
        origin={40,150},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Fluids.Examples.BaseClasses.RoomLeakage lea46(redeclare package
      Medium = 
        Medium) "Room leakage model" 
    annotation (Placement(transformation(
        origin={100,150},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Fluids.Examples.BaseClasses.RoomLeakage lea47(redeclare package
      Medium = 
        Medium) "Room leakage model" 
    annotation (Placement(transformation(
        origin={160,150},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Fluids.Examples.BaseClasses.RoomLeakage lea48(redeclare package
      Medium = 
        Medium) "Room leakage model" 
    annotation (Placement(transformation(
        origin={220,150},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Fluids.Examples.BaseClasses.RoomLeakage lea49(redeclare package
      Medium = 
        Medium) "Room leakage model" 
    annotation (Placement(transformation(
        origin={280,150},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Fluids.MixingVolumes.MixingVolume roo45(redeclare package Medium = Medium,
    V=10*5*2.5,
    nPorts=5)             annotation (Placement(transformation(extent={{10,20},
            {30,40}}, rotation=0)));
  Buildings.Fluids.MixingVolumes.MixingVolume roo46(redeclare package Medium = Medium,
    V=10*5*2.5,
    nPorts=5)             annotation (Placement(transformation(extent={{70,20},
            {90,40}}, rotation=0)));
  Buildings.Fluids.MixingVolumes.MixingVolume roo47(redeclare package Medium = Medium,
    V=10*5*2.5,
    nPorts=5)             annotation (Placement(transformation(extent={{130,20},
            {150,40}}, rotation=0)));
  Buildings.Fluids.MixingVolumes.MixingVolume roo48(redeclare package Medium = Medium,
    V=10*5*2.5,
    nPorts=5)             annotation (Placement(transformation(extent={{190,20},
            {210,40}}, rotation=0)));
  Buildings.Fluids.MixingVolumes.MixingVolume roo49(redeclare package Medium = Medium,
    V=10*5*2.5,
    nPorts=5)             annotation (Placement(transformation(extent={{250,20},
            {270,40}}, rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_b port_bSup(redeclare package Medium = 
        Medium)                 annotation (Placement(transformation(extent={{
            390,110},{410,130}}, rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_b port_bExh(redeclare package Medium = 
        Medium)                 annotation (Placement(transformation(extent={{
            -110,-50},{-90,-30}}, rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_b port_aExh(redeclare package Medium = 
        Medium)                 annotation (Placement(transformation(extent={{
            392,-50},{412,-30}}, rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_b port_aRoo(redeclare package Medium = 
        Medium)                 annotation (Placement(transformation(extent={{
            -110,10},{-90,30}}, rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_b port_bRoo(redeclare package Medium = 
        Medium)                 annotation (Placement(transformation(extent={{
            390,10},{410,30}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput yDam "Damper signal" 
    annotation (Placement(transformation(extent={{-140,68},{-100,108}},
          rotation=0)));
equation
  connect(spl34.port_3,vav39. port_a)                      annotation (Line(
        points={{20,110},{20,70},{20,70}},         color={0,127,255}));
  connect(vav39.port_b,roo45.ports[1]) annotation (Line(points={{20,50},{20,20},
          {16.8,20}},                 color={0,127,255}));
  connect(mix55.port_3,roo45.ports[2]) annotation (Line(points={{20,-30},{20,
          -10},{20,20},{18.4,20}},
                  color={0,127,255}));
  connect(roo45.ports[3],res13. port_a) 
                                       annotation (Line(points={{20,20},{20,20},
          {40,20}},
        color={0,0,255}));
  connect(res13.port_b,roo46.ports[1]) annotation (Line(points={{60,20},{76.8,
          20}},                 color={0,127,255}));
  connect(vav40.port_b,roo46.ports[2]) annotation (Line(points={{80,50},{80,30},
          {80,20},{78.4,20}},
                  color={0,127,255}));
  connect(vav41.port_b,roo47.ports[1]) annotation (Line(points={{140,50},{140,
          30},{140,20},{136.8,20}},
                  color={0,127,255}));
  connect(vav42.port_b,roo48.ports[1]) annotation (Line(points={{200,50},{200,
          30},{200,20},{196.8,20}},
                  color={0,127,255}));
  connect(vav43.port_b,roo49.ports[1]) annotation (Line(points={{260,48},{260,
          29},{260,20},{256.8,20}},
                  color={0,127,255}));
  connect(spl34.port_2,spl35. port_1) annotation (Line(points={{30,120},{70,120}},
        color={0,127,255}));
  connect(spl35.port_2,spl36. port_1) annotation (Line(points={{90,120},{130,
          120}}, color={0,127,255}));
  connect(spl36.port_2,spl37. port_1) annotation (Line(points={{150,120},{190,
          120}}, color={0,127,255}));
  connect(spl35.port_3,vav40. port_a) annotation (Line(points={{80,110},{80,70}},
        color={0,127,255}));
  connect(spl36.port_3,vav41. port_a) annotation (Line(points={{140,110},{140,
          70}}, color={0,127,255}));
  connect(spl37.port_3,vav42. port_a) annotation (Line(points={{200,110},{200,
          70}}, color={0,127,255}));
  connect(roo46.ports[3],mix54. port_3) 
    annotation (Line(points={{80,20},{80,-30}}, color={0,0,255}));
  connect(roo47.ports[2],mix53. port_3) 
    annotation (Line(points={{138.4,20},{138.4,-10},{140,-10},{140,-30}},
                                                    color={0,0,255}));
  connect(roo47.ports[3],res15. port_a) 
    annotation (Line(points={{140,20},{140,20},{160,20}},
                                                 color={0,0,255}));
  connect(res15.port_b,roo48.ports[2]) annotation (Line(points={{180,20},{198.4,
          20}},                       color={0,127,255}));
  connect(roo47.ports[4],res14. port_b) 
    annotation (Line(points={{141.6,20},{141.6,20},{120,20}},          color={0,
          0,255}));
  connect(res14.port_a,roo46.ports[4]) annotation (Line(points={{100,20},{81.6,
          20}},                 color={0,127,255}));
  connect(mix55.port_2,mix54. port_1) annotation (Line(points={{30,-40},{70,-40}},
        color={0,127,255}));
  connect(mix54.port_2,mix53. port_1) annotation (Line(points={{90,-40},{130,
          -40}}, color={0,127,255}));
  connect(mix53.port_2,mix52. port_1) annotation (Line(points={{150,-40},{190,
          -40}}, color={0,127,255}));
  connect(mix52.port_2,mix51. port_1) annotation (Line(points={{210,-40},{250,
          -40}}, color={0,127,255}));
  connect(roo48.ports[3],mix51. port_3) 
                                       annotation (Line(points={{200,20},{200,
          -12},{260,-12},{260,-30}}, color={0,0,255}));
  connect(roo48.ports[4],res16. port_a) 
    annotation (Line(points={{201.6,20},{201.6,20},{220,20}},          color={0,
          0,255}));
  connect(res16.port_b,roo49.ports[2]) 
                                  annotation (Line(points={{240,20},{258.4,20}},
                                 color={0,127,255}));
  connect(roo49.ports[3],mix52. port_3) 
                                       annotation (Line(points={{260,20},{260,
          -6},{232,-6},{232,-20},{200,-20},{200,-30}}, color={0,0,255}));
  connect(roo49.ports[4],res17. port_a) 
    annotation (Line(points={{261.6,20},{261.6,20},{280,20}},          color={0,
          0,255}));
  connect(spl37.port_2,spl38. port_1) annotation (Line(points={{210,120},{250,
          120}}, color={0,127,255}));
  connect(vav43.port_a,spl38. port_3) annotation (Line(points={{260,68},{260,
          110}}, color={0,127,255}));
  connect(lea45.port_b,roo45.ports[4]) 
                                      annotation (Line(points={{40,140},{40,20},
          {21.6,20}},       color={0,127,255}));
  connect(lea46.port_b,roo46.ports[5]) 
                                      annotation (Line(points={{100,140},{100,
          20},{83.2,20}},   color={0,127,255}));
  connect(lea47.port_b,roo47.ports[5]) 
                                      annotation (Line(points={{160,140},{160,
          20},{143.2,20}},   color={0,127,255}));
  connect(lea48.port_b,roo48.ports[5]) 
                                      annotation (Line(points={{220,140},{220,
          20},{203.2,20}},   color={0,127,255}));
  connect(lea49.port_b,roo49.ports[5]) 
                                      annotation (Line(points={{280,140},{280,
          20},{263.2,20}},   color={0,127,255}));
  connect(port_aSup, spl34.port_1) annotation (Line(points={{-100,120},{10,120}},
        color={0,127,255}));
  connect(port_bSup, spl38.port_2) annotation (Line(points={{400,120},{270,120}},
        color={0,127,255}));
  connect(port_bExh, mix55.port_1) annotation (Line(points={{-100,-40},{10,-40}},
        color={0,127,255}));
  connect(port_aExh, mix51.port_2) annotation (Line(points={{402,-40},{270,-40}},
        color={0,127,255}));
  connect(port_bRoo, res17.port_b) annotation (Line(points={{400,20},{300,20}},
        color={0,127,255}));
  connect(port_aRoo, roo45.ports[5]) 
                                    annotation (Line(points={{-100,20},{23.2,20}},
                                 color={0,127,255}));
  connect(yDam, vav39.y) annotation (Line(points={{-120,88},{28,88},{28,72}},
        color={0,0,127}));
  connect(yDam, vav40.y) annotation (Line(points={{-120,88},{88,88},{88,72}},
        color={0,0,127}));
  connect(yDam, vav42.y) annotation (Line(points={{-120,88},{208,88},{208,72}},
        color={0,0,127}));
  connect(yDam, vav43.y) annotation (Line(points={{-120,88},{268,88},{268,70}},
        color={0,0,127}));
  connect(p, lea45.p) annotation (Line(points={{-120,180},{40,180},{40,162}},
        color={0,0,127}));
  connect(p, lea46.p) annotation (Line(points={{-120,180},{100,180},{100,162}},
        color={0,0,127}));
  connect(p, lea47.p) annotation (Line(points={{-120,180},{160,180},{160,162}},
        color={0,0,127}));
  connect(p, lea48.p) annotation (Line(points={{-120,180},{220,180},{220,162}},
        color={0,0,127}));
  connect(p, lea49.p) annotation (Line(points={{-120,180},{280,180},{280,162}},
        color={0,0,127}));
  connect(yDam, vav41.y) annotation (Line(points={{-120,88},{148,88},{148,72}},
        color={0,0,127}));
end Suite;
