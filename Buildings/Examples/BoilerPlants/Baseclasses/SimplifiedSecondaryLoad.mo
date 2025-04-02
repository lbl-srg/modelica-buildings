within Buildings.Examples.BoilerPlants.Baseclasses;
model SimplifiedSecondaryLoad
  "Simplified load model for hot water secondary loop"

  replaceable package MediumW =Buildings.Media.Water
    "Water medium model";

  parameter Boolean have_priOnl = false
    "Is the primary loop primary-only? (Only allowed for condensing boilers)"
    annotation(Dialog(group="Plant parameters"));

  parameter Modelica.Units.SI.MassFlowRate mRad_flow_nominal=0.000604*1000
    "Radiator nominal mass flow rate"
    annotation(Dialog(group="Radiator"));

  parameter Modelica.Units.SI.PressureDifference dpRad_nominal = 0
    "Nominal pressure drop across radiator"
    annotation(Dialog(group="Radiator"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPum
    "Secondary pump enable"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatRet
    "Required hot water return temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHotWat_flow
    "Required hot water flowrate"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe
    "Secondary pump speed"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumEna
    "Pump proven on"
    annotation (Placement(transformation(extent={{100,10},{140,50}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nReq
    "Number of requests from end load valve"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dPSec
    "Differential pressure between secondary loop supply and return"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumSpe
    "Measured pump speed"
    annotation (Placement(transformation(extent={{100,-40},{140,0}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = MediumW)
    "HHW inlet port"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}}),
      iconTransformation(extent={{-50,-110},{-30,-90}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare package Medium = MediumW)
    "HHW outlet port"
    annotation (Placement(transformation(extent={{70,-110},{90,-90}}),
      iconTransformation(extent={{30,-110},{50,-90}})));

  Buildings.Fluid.HeatExchangers.SensibleCooler_T coo(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mRad_flow_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final dp_nominal=dpRad_nominal)
    "Ideal cooler for heating loads"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));

  Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y pum(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final allowFlowReversal=true,
    final addPowerToMedium=true,
    final riseTime=60,
    final m_flow_nominal=mRad_flow_nominal,
    final dp_nominal=dpRad_nominal)
    "Hot water secondary pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-20,-40})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val(
    redeclare final package Medium = MediumW,
    final m_flow_nominal=mRad_flow_nominal,
    final dpValve_nominal(displayUnit="Pa") = 0.1*dpRad_nominal,
    final dpFixed_nominal(displayUnit="Pa") = 1000)
    "Minimum flow bypass valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0)));

  Buildings.Controls.OBC.CDL.Reals.PID conPID
    "Cooler valve controller"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=5)
    "Multiply number of requests to represent requests from multiple zones"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real signal to required integer format"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert enable signal to real"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Operate pump at required speed only when enable signal is true"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = MediumW)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium = MediumW)
    "Differential pressure sensor"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=0.05,
    final uHigh=0.1)
    "Determine if pump is proven on"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

equation
  connect(port_b,coo. port_b) annotation (Line(points={{80,-100},{80,0},{70,0}},
        color={0,127,255}));
  connect(uHotWat_flow, conPID.u_s)
    annotation (Line(points={{-120,60},{-52,60}}, color={0,0,127}));
  connect(conPID.y, gai.u)
    annotation (Line(points={{-28,60},{18,60}}, color={0,0,127}));
  connect(gai.y, reaToInt.u)
    annotation (Line(points={{42,60},{58,60}}, color={0,0,127}));
  connect(conPID.y, val.y)
    annotation (Line(points={{-28,60},{0,60},{0,12}},      color={0,0,127}));
  connect(reaToInt.y, nReq)
    annotation (Line(points={{82,60},{120,60}}, color={255,127,0}));
  connect(uPum, booToRea.u)
    annotation (Line(points={{-120,-40},{-92,-40}}, color={255,0,255}));
  connect(mul.y, pum.y)
    annotation (Line(points={{-38,-60},{-36,-60},{-36,-40},{-32,-40}},
                                                   color={0,0,127}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{-68,-40},{-66,-40},{-66,
          -54},{-62,-54}}, color={0,0,127}));
  connect(uPumSpe, mul.u2) annotation (Line(points={{-120,-80},{-66,-80},{-66,
          -66},{-62,-66}}, color={0,0,127}));
  connect(THotWatRet, coo.TSet) annotation (Line(points={{-120,0},{-40,0},{-40,-14},
          {46,-14},{46,8},{48,8}},
                          color={0,0,127}));
  connect(senMasFlo.port_b, coo.port_a)
    annotation (Line(points={{40,0},{50,0}},     color={0,127,255}));
  connect(senMasFlo.m_flow, conPID.u_m) annotation (Line(points={{30,11},{30,20},
          {-40,20},{-40,48}},     color={0,0,127}));
  connect(senRelPre.port_a, pum.port_b) annotation (Line(points={{20,-30},{-20,-30}},
                                              color={0,127,255}));
  connect(senRelPre.port_b, coo.port_b) annotation (Line(points={{40,-30},{80,-30},
          {80,0},{70,0}},          color={0,127,255}));
  connect(senRelPre.p_rel, dPSec)
    annotation (Line(points={{30,-39},{30,-80},{120,-80}}, color={0,0,127}));
  connect(yPumEna, hys.y)
    annotation (Line(points={{120,30},{82,30}}, color={255,0,255}));
  connect(pum.y_actual, hys.u)
    annotation (Line(points={{-27,-29},{-27,-24},{-28,-24},{-28,30},{58,30}},
                                                          color={0,0,127}));
  connect(port_a, pum.port_a)
    annotation (Line(points={{-20,-100},{-20,-50}}, color={0,127,255}));
  connect(pum.y_actual, yPumSpe) annotation (Line(points={{-27,-29},{-27,-24},{-28,
          -24},{-28,30},{50,30},{50,16},{94,16},{94,-20},{120,-20}}, color={0,0,
          127}));
  connect(val.port_b, senMasFlo.port_a)
    annotation (Line(points={{10,0},{20,0}}, color={0,127,255}));
  connect(val.port_a, pum.port_b)
    annotation (Line(points={{-10,0},{-20,0},{-20,-30}}, color={0,127,255}));
  annotation (defaultComponentName="secLoo",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-100,140},{100,100}},
        textColor={0,0,255},
        textString="%name")}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
      <p>
      This is a simplified load model for a boiler plant secondary loop consisting of 
      a variable speed pump <code>pum</code>, a flow-control valve <code>val</code>
      and an ideal cooler <code>coo</code>. The heating load on the secondary loop
      is applied via the inputs for load flowrate <code>uHotWat_flow</code> and
      return temperature <code>THotWatRet</code>.
      <br>
      The flowrate through <code>val</code> is regulated at <code>uHotWat_flow</code>
      by the PID controller <code>conPID</code>. <code>coo</code> enforces the
      return temperature <code>THotWatRet</code>.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      March 25, 2025, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end SimplifiedSecondaryLoad;
