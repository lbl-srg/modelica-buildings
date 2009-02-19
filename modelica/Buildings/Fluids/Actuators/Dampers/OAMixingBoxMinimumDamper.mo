within Buildings.Fluids.Actuators.Dampers;
model OAMixingBoxMinimumDamper
  "Outside air mixing box with parallel damper for minimum outside air flow rate"
  extends Buildings.BaseClasses.BaseIcon;
  outer Modelica_Fluid.System system "System wide properties";
  replaceable package Medium = 
      Modelica.Media.Interfaces.PartialMedium "Medium in the component" 
    annotation (choicesAllMatching = true);
   import Modelica.Constants;

  parameter Boolean allowFlowReversal = system.allowFlowReversal
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Buildings.Fluids.Actuators.Dampers.Exponential damOAMin(
                                                         A=AOutMin,
    redeclare package Medium = Medium,
    m0_flow=m0OutMin_flow) "Damper for minimum outside air supply" 
                                            annotation (Placement(
        transformation(extent={{-42,28},{-22,48}}, rotation=0)));
  Buildings.Fluids.Actuators.Dampers.Exponential damOA(
                                                      A=AOut,
    redeclare package Medium = Medium,
    m0_flow=m0Out_flow) 
    annotation (Placement(transformation(extent={{-42,-30},{-22,-10}}, rotation=
           0)));
  parameter Modelica.SIunits.Area AOutMin
    "Face area minimum outside air damper";
  parameter Modelica.SIunits.Area AOut "Face area outside air damper";
  Buildings.Fluids.Actuators.Dampers.Exponential damExh(
                                                       A=AExh,
    redeclare package Medium = Medium,
    m0_flow=m0Exh_flow) "Exhaust air damper" 
    annotation (Placement(transformation(extent={{-22,-90},{-42,-70}}, rotation=
           0)));
  parameter Modelica.SIunits.Area AExh "Face area exhaust air damper";
  Buildings.Fluids.Actuators.Dampers.Exponential damRec(
                                                       A=ARec,
    redeclare package Medium = Medium,
    m0_flow=m0Rec_flow) "Recirculation air damper" 
                               annotation (Placement(transformation(
        origin={28,-10},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  parameter Modelica.SIunits.Area ARec "Face area recirculation air damper";

  parameter Modelica.SIunits.MassFlowRate m0OutMin_flow
    "Mass flow rate minimum outside air damper" 
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dp0OutMin
    "Pressure drop minimum outside air leg (without damper)" 
     annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m0Out_flow
    "Mass flow rate outside air damper" 
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dp0Out
    "Pressure drop outside air leg (without damper)" 
     annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m0Rec_flow
    "Mass flow rate recirculation air damper" 
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dp0Rec
    "Pressure drop recirculation air leg (without damper)" 
     annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m0Exh_flow
    "Mass flow rate exhaust air damper" 
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dp0Exh
    "Pressure drop exhaust air leg (without damper)" 
     annotation (Dialog(group="Nominal condition"));

  Buildings.Fluids.FixedResistances.FixedResistanceDpM preDroOutMin(
                                                              m0_flow=
        m0OutMin_flow, dp0=dp0OutMin, redeclare package Medium = Medium)
    "Pressure drop for minimum outside air branch" 
    annotation (Placement(transformation(extent={{-82,28},{-62,48}}, rotation=0)));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM preDroOut(
                                                           m0_flow=
        m0Out_flow, dp0=dp0Out, redeclare package Medium = Medium)
    "Pressure drop for outside air branch" annotation (Placement(transformation(
          extent={{-82,-30},{-62,-10}}, rotation=0)));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM preDroExh(
                                                           m0_flow=
        m0Exh_flow, dp0=dp0Exh, redeclare package Medium = Medium)
    "Pressure drop for exhaust air branch" 
    annotation (Placement(transformation(extent={{-62,-90},{-82,-70}}, rotation=
           0)));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM preDroRec(
                                                           m0_flow=
        m0Rec_flow, dp0=dp0Rec, redeclare package Medium = Medium)
    "Pressure drop for recirculation air branch" 
    annotation (Placement(transformation(
        origin={28,-50},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
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
          lineColor={0,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y"),
        Text(
          extent={{-96,110},{-70,88}},
          lineColor={0,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yMin")}),
    Documentation(revisions="<html>
<ul>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Model of an outside air mixing box with air dampers and a flow path for the minimum outside air flow rate.
</p>
</html>"));
  Modelica_Fluid.Interfaces.FluidPort_a port_Out(redeclare package Medium = 
        Medium, m_flow(start=0, min=if allowFlowReversal then -Constants.inf else 
                0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-112,-30},{-92,-10}},
          rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_a port_OutMin(redeclare package Medium = 
        Medium, m_flow(start=0, min=if allowFlowReversal then -Constants.inf else 
                0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-112,10},{-92,30}}, rotation=
            0)));
  Modelica_Fluid.Interfaces.FluidPort_b port_Exh(redeclare package Medium = 
        Medium, m_flow(start=0, max=if allowFlowReversal then +Constants.inf else 
                0))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-92,-90},{-112,-70}},
          rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_a port_Ret(redeclare package Medium = 
        Medium, m_flow(start=0, min=if allowFlowReversal then -Constants.inf else 
                0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-90},{90,-70}}, rotation=
            0)));
  Modelica_Fluid.Interfaces.FluidPort_b port_Sup(redeclare package Medium = 
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
  Modelica_Fluid.Interfaces.FluidPort_b port_Ret1(redeclare package Medium = 
        Medium) annotation (Placement(transformation(extent={{27,-81},{29,-79}},
          rotation=0)));
protected
  Modelica_Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium = 
        Medium) annotation (Placement(transformation(extent={{27,19},{29,21}},
          rotation=0)));
equation
  connect(preDroOutMin.port_b, damOAMin.port_a)    annotation (Line(points={{
          -62,38},{-42,38}}, color={0,127,255}));
  connect(preDroOut.port_b, damOA.port_a)    annotation (Line(points={{-62,-20},
          {-42,-20}}, color={0,127,255}));
  connect(yOutMin, damOAMin.y) annotation (Line(points={{-120,100},{-54,100},{
          -54,46},{-44,46}}, color={0,0,127}));
  connect(y, damOA.y) annotation (Line(points={{-120,60},{-58,60},{-58,-12},{
          -44,-12}}, color={0,0,127}));
  connect(y, damExh.y) annotation (Line(points={{-120,60},{-58,60},{-58,-64},{
          -6,-64},{-6,-72},{-20,-72}}, color={0,0,127}));
  connect(damExh.port_b, preDroExh.port_a) annotation (Line(points={{-42,-80},{
          -62,-80}}, color={0,127,255}));
  connect(preDroExh.port_b, port_Exh) annotation (Line(points={{-82,-80},{-102,
          -80}}, color={0,127,255}));
  connect(preDroOut.port_a, port_Out) annotation (Line(points={{-82,-20},{-102,
          -20}}, color={0,127,255}));
  connect(port_OutMin, preDroOutMin.port_a) annotation (Line(points={{-102,20},
          {-93,20},{-93,38},{-82,38}}, color={0,127,255}));
  connect(uni.y, add.u1) annotation (Line(points={{1,90},{20,90},{20,76},{38,76}},
        color={0,0,127}));
  connect(y, add.u2) annotation (Line(points={{-120,60},{-42,60},{-42,64},{38,
          64}}, color={0,0,127}));
  connect(add.y, damRec.y) annotation (Line(points={{61,70},{68,70},{68,-28},{
          20,-28},{20,-22}}, color={0,0,127}));
  connect(port_Ret, port_Ret1) annotation (Line(points={{100,-80},{28,-80}},
        color={0,127,255}));
  connect(preDroRec.port_a, port_Ret1) annotation (Line(points={{28,-60},{28,
          -80}}, color={0,127,255}));
  connect(damExh.port_a, port_Ret1) annotation (Line(points={{-22,-80},{28,-80}},
        color={0,127,255}));
  connect(damOAMin.port_b, port_b1) annotation (Line(points={{-22,38},{28,38},{
          28,20}}, color={0,127,255}));
  connect(port_Sup, port_b1) 
    annotation (Line(points={{98,20},{28,20}}, color={0,127,255}));
  connect(damRec.port_b, port_b1) 
    annotation (Line(points={{28,0},{28,20}},            color={0,127,255}));
  connect(damOA.port_b, port_b1) annotation (Line(points={{-22,-20},{4,-20},{4,
          20},{28,20}}, color={0,127,255}));
  connect(preDroRec.port_b, damRec.port_a) annotation (Line(points={{28,-40},{
          28,-20}}, color={0,127,255}));
end OAMixingBoxMinimumDamper;
