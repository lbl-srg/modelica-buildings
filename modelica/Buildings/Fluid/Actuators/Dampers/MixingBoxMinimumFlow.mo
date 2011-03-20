within Buildings.Fluid.Actuators.Dampers;
model MixingBoxMinimumFlow
  "Outside air mixing box with parallel damper for minimum outside air flow rate"
 extends Buildings.Fluid.Actuators.Dampers.MixingBox;
  import Modelica.Constants;

  parameter Modelica.SIunits.Area AOutMin
    "Face area minimum outside air damper";

  parameter Modelica.SIunits.MassFlowRate mOutMin_flow_nominal
    "Mass flow rate minimum outside air damper"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dpOutMin_nominal(min=0, displayUnit="Pa")
    "Pressure drop minimum outside air leg"
     annotation (Dialog(group="Nominal condition"));

  Modelica.Fluid.Interfaces.FluidPort_a port_OutMin(redeclare package Medium =
        Medium, m_flow(start=0, min=if allowFlowReversal then -Constants.inf else
                0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}},rotation=
            0), iconTransformation(extent={{-110,90},{-90,110}})));
  Modelica.Blocks.Interfaces.RealInput yOutMin
    "Damper position minimum outside air (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
          rotation=270,
        origin={60,120})));

  VAVBoxExponential damOAMin(
    redeclare package Medium = Medium,
    dp_nominalIncludesDamper=dp_nominalIncludesDamper,
    from_dp=from_dp,
    linearized=linearized,
    use_deltaM=use_deltaM,
    deltaM=deltaM,
    use_v_nominal=use_v_nominal,
    v_nominal=v_nominal,
    roundDuct=roundDuct,
    ReC=ReC,
    m_flow_small=m_flow_small,
    a=a,
    b=b,
    yL=yL,
    yU=yU,
    k0=k0,
    k1=k1,
    use_constant_density=use_constant_density,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mOutMin_flow_nominal,
    dp_nominal=dpOutMin_nominal,
    A=AOutMin) "Damper for minimum outside air intake"
    annotation (Placement(transformation(extent={{20,70},{40,90}},     rotation=
           0)));
equation
  connect(port_OutMin, damOAMin.port_a) annotation (Line(
      points={{-100,100},{-46,100},{-46,90},{10,90},{10,80},{20,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(damOAMin.port_b, port_Sup) annotation (Line(
      points={{40,80},{60,80},{60,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(yOutMin, damOAMin.y) annotation (Line(
      points={{60,120},{60,96},{30,96},{30,88}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                      graphics),
                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,94},{0,86}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,66},{2,94}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-62,82},{-50,98},{-42,98},{-54,82},{-62,82}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{50,104},{76,82}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yMin")}),
defaultComponentName="eco",
Documentation(revisions="<html>
<ul>
<li>
February 24, 2010 by Michael Wetter:<br>
Changed implementation of flow resistance. Instead of using a
fixed resistance and a damper model in series, only one model is used
that internally adds these two resistances. This leads to smaller systems
of nonlinear equations. This new implementation extends 
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.MixingBox\">
Buildings.Fluid.Actuators.Dampers.MixingBox</a>.
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
end MixingBoxMinimumFlow;
