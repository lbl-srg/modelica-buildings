within Buildings.Fluid.Actuators.Dampers;
model MixingBoxMinimumFlow
  "Outside air mixing box with parallel damper for minimum outside air flow rate"
  extends Buildings.BaseClasses.BaseIcon;
  outer Modelica.Fluid.System system "System wide properties";
  replaceable package Medium = 
      Modelica.Media.Interfaces.PartialMedium "Medium in the component" 
    annotation (choicesAllMatching = true);
   import Modelica.Constants;

  parameter Boolean allowFlowReversal = system.allowFlowReversal
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  VAVBoxExponential damOAMin(                            A=AOutMin,
    redeclare package Medium = Medium,
    m_flow_nominal=m0OutMin_flow,
    dp_nominal=dpOutMin_nominal,
    dp_nominalIncludesDamper=dp_nominalIncludesDamper)
    "Damper for minimum outside air supply" annotation (Placement(
        transformation(extent={{-42,28},{-22,48}}, rotation=0)));
  VAVBoxExponential damOA(                            A=AOut,
    redeclare package Medium = Medium,
    m_flow_nominal=m0Out_flow,
    dp_nominal=dpOut_nominal,
    dp_nominalIncludesDamper=dp_nominalIncludesDamper) 
    annotation (Placement(transformation(extent={{-42,-30},{-22,-10}}, rotation=
           0)));
  parameter Modelica.SIunits.Area AOutMin
    "Face area minimum outside air damper";
  parameter Modelica.SIunits.Area AOut "Face area outside air damper";
  VAVBoxExponential damExh(                            A=AExh,
    redeclare package Medium = Medium,
    m_flow_nominal=m0Exh_flow,
    dp_nominal=dpExh_nominal,
    dp_nominalIncludesDamper=dp_nominalIncludesDamper) "Exhaust air damper" 
    annotation (Placement(transformation(extent={{-22,-90},{-42,-70}}, rotation=
           0)));
  parameter Modelica.SIunits.Area AExh "Face area exhaust air damper";
  VAVBoxExponential damRec(                            A=ARec,
    redeclare package Medium = Medium,
    m_flow_nominal=m0Rec_flow,
    dp_nominal=dpRec_nominal,
    dp_nominalIncludesDamper=dp_nominalIncludesDamper)
    "Recirculation air damper" annotation (Placement(transformation(
        origin={28,-10},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  parameter Modelica.SIunits.Area ARec "Face area recirculation air damper";

  parameter Boolean dp_nominalIncludesDamper=false
    "set to true if dp_nominal includes the pressure loss of the open damper" 
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m0OutMin_flow
    "Mass flow rate minimum outside air damper" 
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dpOutMin_nominal(min=0, displayUnit="Pa")
    "Pressure drop minimum outside air leg (without damper)" 
     annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m0Out_flow
    "Mass flow rate outside air damper" 
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dpOut_nominal(min=0, displayUnit="Pa")
    "Pressure drop outside air leg (without damper)" 
     annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m0Rec_flow
    "Mass flow rate recirculation air damper" 
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dpRec_nominal(min=0, displayUnit="Pa")
    "Pressure drop recirculation air leg (without damper)" 
     annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m0Exh_flow
    "Mass flow rate exhaust air damper" 
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dpExh_nominal(min=0, displayUnit="Pa")
    "Pressure drop exhaust air leg (without damper)" 
     annotation (Dialog(group="Nominal condition"));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                      graphics),
                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-96,-14},{-26,-28}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,28},{92,14}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-96,22},{-26,16}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,-74},{96,-86}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,28},{18,-74}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,28},{-26,-26}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-82,6},{-64,32},{-56,32},{-74,6},{-82,6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-84,-34},{-66,-8},{-58,-8},{-76,-34},{-84,-34}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-54,-92},{-36,-66},{-28,-66},{-46,-92},{-54,-92}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-2,-42},{16,-16},{24,-16},{6,-42},{-2,-42}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{66,28},{88,20},{66,14},{66,28}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{48,22},{68,20}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{74,-80},{94,-82}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{76,-74},{52,-80},{76,-86},{76,-74}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-102,72},{-76,50}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y"),
        Text(
          extent={{-96,110},{-70,88}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yMin")}),
    Documentation(revisions="<html>
<ul>
<li>
February 24, 2010 by Michael Wetter:<br>
Changed implementation of flow resistance. Instead of using a
fixed resistance and a damper model in series, only one model is used
that internally adds these two resistances. This leads to smaller systems
of nonlinear equations.
</li>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Model of an outside air mixing box with air dampers and a flow path for the minimum outside air flow rate.
</p>
<p>
If <code>dp_nominalIncludesDamper=true</code>, then the parameter <code>dp_nominal</code>
is equal to the pressure drop of the damper plus the fixed flow resistance at the nominal
flow rate.
If <code>dp_nominalIncludesDamper=false</code>, then <code>dp_nominal</code>
does not include the flow resistance of the air damper.
</p>
</html>"));
  Modelica.Fluid.Interfaces.FluidPort_a port_Out(redeclare package Medium = 
        Medium, m_flow(start=0, min=if allowFlowReversal then -Constants.inf else 
                0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-112,-30},{-92,-10}},
          rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_OutMin(redeclare package Medium = 
        Medium, m_flow(start=0, min=if allowFlowReversal then -Constants.inf else 
                0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-112,10},{-92,30}}, rotation=
            0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_Exh(redeclare package Medium = 
        Medium, m_flow(start=0, max=if allowFlowReversal then +Constants.inf else 
                0))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-92,-90},{-112,-70}},
          rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_Ret(redeclare package Medium = 
        Medium, m_flow(start=0, min=if allowFlowReversal then -Constants.inf else 
                0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-90},{90,-70}}, rotation=
            0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_Sup(redeclare package Medium = 
        Medium, m_flow(start=0, max=if allowFlowReversal then +Constants.inf else 
                0))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{108,10},{88,30}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput y "Damper position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}, rotation=
           0)));
  Modelica.Blocks.Interfaces.RealInput yOutMin
    "Damper position minimum outside air (0: closed, 1: open)" 
    annotation (Placement(transformation(extent={{-140,80},{-100,120}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant uni(k=1) "Unity signal" 
    annotation (Placement(transformation(extent={{-20,80},{0,100}}, rotation=0)));

  Modelica.Blocks.Math.Add add(k2=-1) 
                             annotation (Placement(transformation(extent={{40,
            60},{60,80}}, rotation=0)));
protected
  Modelica.Fluid.Interfaces.FluidPort_b port_Ret1(redeclare package Medium = 
        Medium) annotation (Placement(transformation(extent={{27,-81},{29,-79}},
          rotation=0)));
protected
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium = 
        Medium) annotation (Placement(transformation(extent={{27,19},{29,21}},
          rotation=0)));
equation
  connect(yOutMin, damOAMin.y) annotation (Line(points={{-120,100},{-32,100},{
          -32,48},{-32,46}}, color={0,0,127}));
  connect(y, damOA.y) annotation (Line(points={{-120,60},{-60,60},{-60,0},{-32,
          0},{-32,-12}},
                     color={0,0,127}));
  connect(y, damExh.y) annotation (Line(points={{-120,60},{-60,60},{-60,-60},{
          -32,-60},{-32,-72}},         color={0,0,127}));
  connect(uni.y, add.u1) annotation (Line(points={{1,90},{20,90},{20,76},{38,76}},
        color={0,0,127}));
  connect(y, add.u2) annotation (Line(points={{-120,60},{-42,60},{-42,64},{38,
          64}}, color={0,0,127}));
  connect(add.y, damRec.y) annotation (Line(points={{61,70},{70,70},{70,48},{12,
          48},{12,-10},{20,-10}},
                             color={0,0,127}));
  connect(port_Ret, port_Ret1) annotation (Line(points={{100,-80},{28,-80}},
        color={0,127,255}));
  connect(damExh.port_a, port_Ret1) annotation (Line(points={{-22,-80},{28,-80}},
        color={0,127,255}));
  connect(damOAMin.port_b, port_b1) annotation (Line(points={{-22,38},{28,38},{
          28,20}}, color={0,127,255}));
  connect(port_Sup, port_b1) 
    annotation (Line(points={{98,20},{28,20}}, color={0,127,255}));
  connect(damRec.port_b, port_b1) 
    annotation (Line(points={{28,5.55112e-16},{28,20}},  color={0,127,255}));
  connect(damOA.port_b, port_b1) annotation (Line(points={{-22,-20},{4,-20},{4,
          20},{28,20}}, color={0,127,255}));
  connect(port_OutMin, damOAMin.port_a) annotation (Line(
      points={{-102,20},{-80,20},{-80,38},{-42,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_Out, damOA.port_a) annotation (Line(
      points={{-102,-20},{-42,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_Exh, damExh.port_b) annotation (Line(
      points={{-102,-80},{-42,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(damRec.port_a, port_Ret1) annotation (Line(
      points={{28,-20},{28,-80}},
      color={0,127,255},
      smooth=Smooth.None));
end MixingBoxMinimumFlow;
