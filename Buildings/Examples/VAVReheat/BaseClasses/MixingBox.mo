within Buildings.Examples.VAVReheat.BaseClasses;
model MixingBox
  "Outside air mixing box with non-interlocked air dampers"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation (choicesAllMatching = true);
  import Modelica.Constants;

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean use_deltaM = true
    "Set to true to use deltaM for turbulent transition, else ReC is used";
  parameter Real deltaM = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
    annotation(Dialog(enable=use_deltaM));
  parameter Modelica.SIunits.Velocity v_nominal=1 "Nominal face velocity";

  parameter Boolean roundDuct = false
    "Set to true for round duct, false for square cross section"
    annotation(Dialog(enable=not use_deltaM));
  parameter Real ReC=4000
    "Reynolds number where transition to turbulent starts"
    annotation(Dialog(enable=not use_deltaM));

  parameter Boolean dp_nominalIncludesDamper=false
    "set to true if dp_nominal includes the pressure loss of the open damper"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate mOut_flow_nominal
    "Mass flow rate outside air damper"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpOut_nominal(min=0, displayUnit="Pa")
    "Pressure drop outside air leg"
     annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate mRec_flow_nominal
    "Mass flow rate recirculation air damper"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpRec_nominal(min=0, displayUnit="Pa")
    "Pressure drop recirculation air leg"
     annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate mExh_flow_nominal
    "Mass flow rate exhaust air damper"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpExh_nominal(min=0, displayUnit="Pa")
    "Pressure drop exhaust air leg"
     annotation (Dialog(group="Nominal condition"));

  parameter Boolean from_dp=true
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Advanced"));
  parameter Boolean linearized=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Advanced"));
  parameter Boolean use_constant_density=true
    "Set to true to use constant density for flow friction"
    annotation (Dialog(tab="Advanced"));
  parameter Real a=-1.51 "Coefficient a for damper characteristics"
    annotation (Dialog(tab="Damper coefficients"));
  parameter Real b=0.105*90 "Coefficient b for damper characteristics"
    annotation (Dialog(tab="Damper coefficients"));
  parameter Real yL=15/90 "Lower value for damper curve"
    annotation (Dialog(tab="Damper coefficients"));
  parameter Real yU=55/90 "Upper value for damper curve"
    annotation (Dialog(tab="Damper coefficients"));
  parameter Real k1=0.45
    "Flow coefficient for y=1, k1 = pressure drop divided by dynamic pressure"
    annotation (Dialog(tab="Damper coefficients"));

  parameter Modelica.SIunits.Time riseTime=15
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (Dialog(tab="Dynamics", group="Filtered opening"));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation (Dialog(tab="Dynamics", group="Filtered opening"));
  parameter Real y_start=1 "Initial value of output"
    annotation (Dialog(tab="Dynamics", group="Filtered opening"));

  Modelica.Blocks.Interfaces.RealInput yRet(
    min=0,
    max=1,
    final unit="1")
    "Return damper position (0: closed, 1: open)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-68,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-68,120})));
  Modelica.Blocks.Interfaces.RealInput yOut(
    min=0,
    max=1,
    final unit="1")
    "Outdoor air damper signal (0: closed, 1: open)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
  Modelica.Blocks.Interfaces.RealInput yExh(
    min=0,
    max=1,
    final unit="1")
    "Exhaust air damper signal (0: closed, 1: open)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={70,120})));

  Modelica.Fluid.Interfaces.FluidPort_a port_Out(redeclare package Medium =
        Medium, m_flow(start=0, min=if allowFlowReversal then -Constants.inf else
                0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_Exh(redeclare package Medium =
        Medium, m_flow(start=0, max=if allowFlowReversal then +Constants.inf else
                0))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_Ret(redeclare package Medium =
        Medium, m_flow(start=0, min=if allowFlowReversal then -Constants.inf else
                0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-70},{90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_Sup(redeclare package Medium =
        Medium, m_flow(start=0, max=if allowFlowReversal then +Constants.inf else
                0))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,50},{90,70}})));

  Fluid.Actuators.Dampers.Exponential damOut(
    redeclare package Medium = Medium,
    from_dp=from_dp,
    linearized=linearized,
    use_deltaM=use_deltaM,
    deltaM=deltaM,
    roundDuct=roundDuct,
    ReC=ReC,
    a=a,
    b=b,
    yL=yL,
    yU=yU,
    use_constant_density=use_constant_density,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mOut_flow_nominal,
    use_inputFilter=true,
    final riseTime=riseTime,
    final init=init,
    y_start=y_start,
    dpDamper_nominal=(k1)*1.2*(1)^2/2,
    dpFixed_nominal=if (dp_nominalIncludesDamper) then (dpOut_nominal) - (k1)*
        1.2*(1)^2/2 else (dpOut_nominal),
    k1=k1) "Outdoor air damper"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Fluid.Actuators.Dampers.Exponential damExh(
    redeclare package Medium = Medium,
    m_flow_nominal=mExh_flow_nominal,
    from_dp=from_dp,
    linearized=linearized,
    use_deltaM=use_deltaM,
    deltaM=deltaM,
    roundDuct=roundDuct,
    ReC=ReC,
    a=a,
    b=b,
    yL=yL,
    yU=yU,
    use_constant_density=use_constant_density,
    allowFlowReversal=allowFlowReversal,
    use_inputFilter=true,
    final riseTime=riseTime,
    final init=init,
    y_start=y_start,
    dpDamper_nominal=(k1)*1.2*(1)^2/2,
    dpFixed_nominal=if (dp_nominalIncludesDamper) then (dpExh_nominal) - (k1)*
        1.2*(1)^2/2 else (dpExh_nominal),
    k1=k1) "Exhaust air damper"
    annotation (Placement(transformation(extent={{-20,-70},{-40,-50}})));

  Fluid.Actuators.Dampers.Exponential damRet(
    redeclare package Medium = Medium,
    m_flow_nominal=mRec_flow_nominal,
    from_dp=from_dp,
    linearized=linearized,
    use_deltaM=use_deltaM,
    deltaM=deltaM,
    roundDuct=roundDuct,
    ReC=ReC,
    a=a,
    b=b,
    yL=yL,
    yU=yU,
    use_constant_density=use_constant_density,
    allowFlowReversal=allowFlowReversal,
    use_inputFilter=true,
    final riseTime=riseTime,
    final init=init,
    y_start=y_start,
    dpDamper_nominal=(k1)*1.2*(1)^2/2,
    dpFixed_nominal=if (dp_nominalIncludesDamper) then (dpRec_nominal) - (k1)*
        1.2*(1)^2/2 else (dpRec_nominal),
    k1=k1) "Return air damper" annotation (Placement(transformation(
        origin={80,0},
        extent={{-10,-10},{10,10}},
        rotation=90)));


protected
  parameter Medium.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid volume";
  parameter Medium.ThermodynamicState sta_default=
     Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default)
    "Default medium state";

equation
  connect(damOut.port_a, port_Out)
    annotation (Line(points={{-10,60},{-100,60}}, color={0,127,255}));
  connect(damExh.port_b, port_Exh) annotation (Line(
      points={{-40,-60},{-100,-60}},
      color={0,127,255}));
  connect(port_Sup, damOut.port_b)
    annotation (Line(points={{100,60},{10,60}}, color={0,127,255}));
  connect(damRet.port_b, port_Sup) annotation (Line(
      points={{80,10},{80,60},{100,60}},
      color={0,127,255}));
  connect(port_Ret, damExh.port_a) annotation (Line(
      points={{100,-60},{-20,-60}},
      color={0,127,255}));
  connect(port_Ret,damRet. port_a) annotation (Line(
      points={{100,-60},{80,-60},{80,-10}},
      color={0,127,255}));

  connect(damRet.y, yRet)
    annotation (Line(points={{68,8.88178e-16},{-68,8.88178e-16},{-68,120}},
                                                        color={0,0,127}));
  connect(yOut, damOut.y)
    annotation (Line(points={{0,120},{0,72}}, color={0,0,127}));
  connect(yExh, damExh.y) annotation (Line(points={{60,120},{60,20},{-30,20},{-30,
          -48}}, color={0,0,127}));
  annotation (                       Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-94,12},{90,0}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,-54},{96,-66}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,6},{6,-56}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-86,-12},{-64,24},{-46,24},{-70,-12},{-86,-12}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{48,12},{70,6},{48,0},{48,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{72,-58},{92,-62}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{72,-54},{48,-60},{72,-66},{72,-54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{28,8},{48,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-74,-76},{-52,-40},{-34,-40},{-58,-76},{-74,-76}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-40},{2,-4},{20,-4},{-4,-40},{-20,-40}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{78,66},{90,10}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,66},{-82,8}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,100},{0,60},{-54,60},{-54,24}},
          color={0,0,255}),  Text(
          extent={{-50,-84},{48,-132}},
          lineColor={0,0,255},
          textString=
               "%name"),
        Line(
          points={{-68,100},{-68,80},{-20,80},{-20,-22}},
          color={0,0,255}),
        Line(
          points={{70,100},{70,-84},{-60,-84}},
          color={0,0,255})}),
defaultComponentName="eco",
Documentation(revisions="<html>
<ul>
<li>
November 10, 2017, by Michael Wetter:<br/>
Changed default of <code>raiseTime</code> as air damper motors, such as from JCI
have a travel time of about 30 seconds.
Shorter travel time also makes control loops more stable.
</li>
<li>
March 24, 2017, by Michael Wetter:<br/>
Renamed <code>filteredInput</code> to <code>use_inputFilter</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">#665</a>.
</li>
<li>
March 22, 2017, by Michael Wetter:<br/>
Removed the assignments of <code>AOut</code>, <code>AExh</code> and <code>ARec</code> as these are done in the damper instance using
a final assignment of the parameter.
This allows scaling the model with <code>m_flow_nominal</code>,
which is generally known in the flow leg,
and <code>v_nominal</code>, for which a default value can be specified.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/544\">#544</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
February 14, 2012 by Michael Wetter:<br/>
Added filter to approximate the travel time of the actuator.
</li>
<li>
February 3, 2012, by Michael Wetter:<br/>
Removed assignment of <code>m_flow_small</code> as it is no
longer used in its base class.
</li>
<li>
February 23, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Model of an outside air mixing box with air dampers.
Set <code>y=0</code> to close the outside air and exhast air dampers.
</p>
<p>
If <code>dp_nominalIncludesDamper=true</code>, then the parameter <code>dp_nominal</code>
is equal to the pressure drop of the damper plus the fixed flow resistance at the nominal
flow rate.
If <code>dp_nominalIncludesDamper=false</code>, then <code>dp_nominal</code>
does not include the flow resistance of the air damper.
</p>
</html>"));
end MixingBox;
