within Buildings.Fluid.Actuators.Dampers;
model MixingBox "Outside air mixing box with interlocked air dampers"
  extends Buildings.Fluid.Actuators.BaseClasses.ActuatorSignal;

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
    annotation (choicesAllMatching = true);
  import Modelica.Constants;

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  VAVBoxExponential damOA(
    redeclare package Medium = Medium,
    dp_nominal=dpOut_nominal,
    dp_nominalIncludesDamper=dp_nominalIncludesDamper,
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
    k0=k0,
    k1=k1,
    use_constant_density=use_constant_density,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mOut_flow_nominal,
    final use_inputFilter=false)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
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

  VAVBoxExponential damExh(
    redeclare package Medium = Medium,
    m_flow_nominal=mExh_flow_nominal,
    dp_nominal=dpExh_nominal,
    dp_nominalIncludesDamper=dp_nominalIncludesDamper,
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
    k0=k0,
    k1=k1,
    use_constant_density=use_constant_density,
    allowFlowReversal=allowFlowReversal,
    final use_inputFilter=false) "Exhaust air damper"
    annotation (Placement(transformation(extent={{-20,-70},{-40,-50}})));

  VAVBoxExponential damRec(
    redeclare package Medium = Medium,
    m_flow_nominal=mRec_flow_nominal,
    dp_nominal=dpRec_nominal,
    dp_nominalIncludesDamper=dp_nominalIncludesDamper,
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
    k0=k0,
    k1=k1,
    use_constant_density=use_constant_density,
    allowFlowReversal=allowFlowReversal,
    final use_inputFilter=false) "Recirculation air damper" annotation (
      Placement(transformation(
        origin={30,0},
        extent={{-10,-10},{10,10}},
        rotation=90)));

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
  parameter Real k0=1E6
    "Flow coefficient for y=0, k0 = pressure drop divided by dynamic pressure"
    annotation (Dialog(tab="Damper coefficients"));
  parameter Real k1=0.45
    "Flow coefficient for y=1, k1 = pressure drop divided by dynamic pressure"
    annotation (Dialog(tab="Damper coefficients"));

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
  Modelica.Blocks.Sources.Constant uni(k=1) "Unity signal"
    annotation (Placement(transformation(extent={{-90,-4},{-70,16}})));

  Modelica.Blocks.Math.Add add(k2=-1) "Adder"
                             annotation (Placement(transformation(extent={{-40,-10},
            {-20,10}})));

protected
  parameter Medium.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid volume";
  parameter Medium.ThermodynamicState sta_default=
     Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default)
    "Default medium state";
equation
  connect(uni.y, add.u1) annotation (Line(points={{-69,6},{-42,6},{-42,6}},
        color={0,0,127}));
  connect(add.y, damRec.y) annotation (Line(points={{-19,6.10623e-16},{-19,0},{
          18,0},{18,1.4009e-15}},
                             color={0,0,127}));
  connect(damOA.port_a, port_Out) annotation (Line(
      points={{-40,30},{-70,30},{-70,60},{-100,60}},
      color={0,127,255}));
  connect(damExh.port_b, port_Exh) annotation (Line(
      points={{-40,-60},{-100,-60}},
      color={0,127,255}));
  connect(port_Sup, damOA.port_b) annotation (Line(
      points={{100,60},{80,60},{80,30},{-20,30}},
      color={0,127,255}));
  connect(damRec.port_b, port_Sup) annotation (Line(
      points={{30,10},{30,30},{80,30},{80,60},{100,60}},
      color={0,127,255}));
  connect(port_Ret, damExh.port_a) annotation (Line(
      points={{100,-60},{-20,-60}},
      color={0,127,255}));
  connect(port_Ret, damRec.port_a) annotation (Line(
      points={{100,-60},{30,-60},{30,-10}},
      color={0,127,255}));
  connect(y_actual, add.u2) annotation (Line(
      points={{50,70},{60,70},{60,60},{0,60},{0,-20},{-60,-20},{-60,-6},{-42,-6}},
      color={0,0,127}));

  connect(y_actual, damOA.y) annotation (Line(
      points={{50,70},{60,70},{60,60},{-30,60},{-30,42}},
      color={0,0,127}));
  connect(y_actual, damExh.y) annotation (Line(
      points={{50,70},{60,70},{60,60},{0,60},{0,-20},{-30,-20},{-30,-48}},
      color={0,0,127}));
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
        Text(
          extent={{22,132},{48,110}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y"),
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
          points={{0,40},{0,10},{0,12}},
          color={0,0,255}),  Text(
          extent={{-50,-84},{48,-132}},
          lineColor={0,0,255},
          textString=
               "%name")}),
defaultComponentName="eco",
Documentation(revisions="<html>
<ul>
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
