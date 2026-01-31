within Buildings.Examples.BoilerPlants.Baseclasses;
model SimplifiedSecondaryLoad
  "Simplified load model for hot water secondary loop"

  replaceable package MediumW =Buildings.Media.Water
    "Water medium model";

  parameter Modelica.Units.SI.MassFlowRate mRad_flow_nominal
    "Radiator nominal mass flow rate"
    annotation(Dialog(group="Radiator parameters"));

  parameter Modelica.Units.SI.PressureDifference dpRad_nominal
    "Nominal pressure drop across radiator"
    annotation(Dialog(group="Radiator parameters"));

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    final min=dpRad_nominal)=dpRad_nominal
    "Nominal pressure drop of fully open flow-modulation valve"
    annotation(Dialog(group="Secondary loop parameters"));

  parameter Modelica.Units.SI.Temperature THotWatRet_nominal(
    displayUnit="degC")=273.15+40
    "Hot water leaving temperature at design conditions"
    annotation(Dialog(group="Secondary loop parameters"));

  parameter Modelica.Units.SI.Temperature THotWatSup_nominal(
    displayUnit="degC")=273.15+60
    "Hot water leaving temperature at design conditions"
    annotation(Dialog(group="Secondary loop parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPum
    "Secondary pump enable"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput QLoa_flow "Heating load"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe
    "Secondary pump speed"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumEna
    "Pump proven on"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nReqPla
    "Number of plant requests from end load valve"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nReqRes
    "Number of reset requests from end load valve"
    annotation (Placement(transformation(extent={{100,80},{140,120}}),
      iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dPSec
    "Differential pressure between secondary loop supply and return"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumSpe
    "Measured pump speed"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = MediumW)
    "HHW inlet port"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
      iconTransformation(extent={{-50,-110},{-30,-90}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare package Medium = MediumW)
    "HHW outlet port"
    annotation (Placement(transformation(extent={{70,-110},{90,-90}}),
      iconTransformation(extent={{30,-110},{50,-90}})));

  Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y pum(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final allowFlowReversal=true,
    final addPowerToMedium=true,
    final riseTime=60,
    final m_flow_nominal=mRad_flow_nominal,
    dp_nominal=dpRad_nominal + dpValve_nominal)
    "Hot water secondary pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={0,-60})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Convert Boolean to required integer format"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert enable signal to real"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Operate pump at required speed only when enable signal is true"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium = MediumW)
    "Differential pressure sensor"
    annotation (Placement(transformation(extent={{30,-60},{50,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=0.05, final uHigh=0.075)
    "Determine if pump is proven on"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys2(uLow=0.1, uHigh=0.95)
    "Check if valve command exceeds threshold for sending plant requests"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys1(uLow=0.85, uHigh=0.95)
    "Check if valve exceeds threshold for generating reset requests"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Convert Boolean to required integer format"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));

  Templates.Components.Loads.LoadTwoWayValve
    loa(
    redeclare package MediumLiq = MediumW,
    final typ=Buildings.Fluid.HydronicConfigurations.Types.Control.Heating,
    final mLiq_flow_nominal=mRad_flow_nominal,
    final dpTer_nominal=dpRad_nominal,
    final dpValve_nominal=dpValve_nominal,
    final TLiqEnt_nominal=THotWatSup_nominal,
    final TLiqLvg_nominal=THotWatRet_nominal)
    "Heating end load assembly including heating coil and supply air temperature-regulating valve"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));

  Controls.OBC.CDL.Logical.Sources.Constant enaEquZon(final k=true)
    "Zone equipment enable signal"
    annotation (Placement(transformation(extent={{-50,-26},{-30,-6}})));

protected
  Controls.OBC.CDL.Reals.MultiplyByParameter           gai(final k=1/loa.Q_flow_nominal)
    "Normalize load"
    annotation (Placement(transformation(extent={{-68,50},{-48,70}})));
equation
  connect(booToInt.y, nReqPla)
    annotation (Line(points={{82,60},{120,60}}, color={255,127,0}));
  connect(uPum, booToRea.u)
    annotation (Line(points={{-120,-40},{-92,-40}}, color={255,0,255}));
  connect(mul.y, pum.y)
    annotation (Line(points={{-38,-60},{-12,-60}}, color={0,0,127}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{-68,-40},{-66,-40},{-66,
          -54},{-62,-54}}, color={0,0,127}));
  connect(uPumSpe, mul.u2) annotation (Line(points={{-120,-80},{-66,-80},{-66,
          -66},{-62,-66}}, color={0,0,127}));
  connect(senRelPre.port_a, pum.port_b) annotation (Line(points={{30,-50},{0,-50}},
                                              color={0,127,255}));
  connect(senRelPre.p_rel, dPSec)
    annotation (Line(points={{40,-59},{40,-80},{120,-80}}, color={0,0,127}));
  connect(yPumEna, hys.y)
    annotation (Line(points={{120,20},{82,20}}, color={255,0,255}));
  connect(pum.y_actual, hys.u)
    annotation (Line(points={{-7,-49},{-7,-40},{40,-40},{40,20},{58,20}},
                                                          color={0,0,127}));
  connect(port_a, pum.port_a)
    annotation (Line(points={{0,-100},{0,-70}},     color={0,127,255}));
  connect(pum.y_actual, yPumSpe) annotation (Line(points={{-7,-49},{-7,-40},{120,
          -40}},                                                     color={0,0,
          127}));
  connect(booToInt1.y, nReqRes)
    annotation (Line(points={{82,100},{120,100}}, color={255,127,0}));
  connect(hys1.y, booToInt1.u)
    annotation (Line(points={{42,100},{58,100}}, color={255,0,255}));
  connect(hys2.y, booToInt.u)
    annotation (Line(points={{42,60},{58,60}}, color={255,0,255}));
  connect(pum.port_b, loa.port_a)
    annotation (Line(points={{0,-50},{0,-20},{50,-20}},   color={0,127,255}));
  connect(loa.port_b, port_b) annotation (Line(points={{70,-20},{80,-20},{80,
          -100}},                            color={0,127,255}));
  connect(senRelPre.port_b, loa.port_b) annotation (Line(points={{50,-50},{80,
          -50},{80,-20},{70,-20}},                          color={0,127,255}));
  connect(loa.yVal_actual, hys1.u) annotation (Line(points={{72,-12},{86,-12},{
          86,46},{8,46},{8,100},{18,100}},
                             color={0,0,127}));
  connect(loa.yVal_actual, hys2.u) annotation (Line(points={{72,-12},{86,-12},{
          86,46},{8,46},{8,60},{18,60}},
                           color={0,0,127}));
  connect(enaEquZon.y, loa.u1)
    annotation (Line(points={{-28,-16},{48,-16}}, color={255,0,255}));
  connect(QLoa_flow, gai.u)
    annotation (Line(points={{-120,60},{-70,60}}, color={0,0,127}));
  connect(gai.y, loa.u) annotation (Line(points={{-46,60},{0,60},{0,-12},{48,
          -12}}, color={0,0,127}));
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
        extent={{-100,-100},{100,120}})),
    Documentation(info="<html>
      <p>
      This is a simplified model for a boiler plant secondary loop load consisting of 
      a variable speed pump <code>pum</code> and a load assembly <code>loa</code>
      (<a href=\"modelica://Buildings.Templates.Components.Loads.LoadTwoWayValve\">
      Buildings.Templates.Components.Loads.LoadTwoWayValve</a>)
      that mimics the operation of a hot-water heating coil.
      </p>
      <p>
      A few key points when using this class are as follows:
      <ul>
      <li>
      The parameter <code>dpValve_nominal</code> is set to be equal to
      <code>val.dpFixed_nominal</code> by default to ensure
      valve authority <code>&ge;50%</code>. The user is encouraged to increase the
      value as required for stable control.
      </li>
      <li>
      The hysteresis limits for plant request generation as well as reset request
      generation are both defined per the default values in G36, 2024. The user
      has the freedom to change those thresholds as required, though it is not
      mandatory.
      </li>
      </ul>
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
