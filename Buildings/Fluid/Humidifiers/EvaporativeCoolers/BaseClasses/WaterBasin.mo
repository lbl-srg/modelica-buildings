within Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses;
partial model WaterBasin
                 "Water basin"

  parameter Modelica.Units.SI.Height height=0.5 "Height of the tank";
  parameter Modelica.Units.SI.Area crossArea=2 "Cross-sectional area of the tank";
  parameter Modelica.Units.SI.Height level_target(min=0, max=height)=0.15 "Target water level in the tank";
  parameter Modelica.Units.SI.MassFlowRate mMakUp_flow_nominal=0.5
    "Make up water mass flow nominal";
  final parameter Modelica.Units.SI.MassFlowRate mRec_flow_nominal=if perRecPum.havePressureCurve
       then perRecPum.V_flow_max*rhoRecWat_default else 2
    "Recirculation water mass flow nominal";
  parameter Real cycCon=4
    "Cycle of concentration for blowdown";
  replaceable package MediumRecWat =
    Buildings.Media.Water "Recirculation water medium";
  Modelica.Fluid.Vessels.OpenTank tan(
    redeclare final package Medium = MediumRecWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    height=height,
    crossArea=crossArea,
    level_start=level_target,
    use_portsData=false,
    nPorts=3) "Open tank"
    annotation (Placement(transformation(extent={{-50,-270},{-30,-250}})));
  Movers.FlowControlled_m_flow mov(
    redeclare package Medium = MediumRecWat,
    per=perRecPum,
    addPowerToMedium=true,
    m_flow_nominal=mRec_flow_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-240})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perRecPum
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance record for the recirculation pump" annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-60,-180},{-40,
            -160}})));
  FixedResistances.PressureDrop                 preDro1(
    redeclare package Medium = MediumRecWat,
    m_flow_nominal=mRec_flow_nominal,
    dp_nominal=20000)         "Pressure drop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,-250})));
  FixedResistances.Junction                 junBloDow(
    redeclare package Medium = MediumRecWat,
    m_flow_nominal={mRec_flow_nominal,-mRec_flow_nominal,-mRec_flow_nominal},
    dp_nominal={25,-25,-25}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,-150})));
  Sources.MassFlowSource_T                 MakUpWat(
    redeclare package Medium = MediumRecWat,
    use_m_flow_in=true,
    T=288.15,
    nPorts=1) "Make up water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-280})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=tan.level)
    annotation (Placement(transformation(extent={{-100,-320},{-80,-300}})));
  Controls.OBC.CDL.Reals.MultiplyByParameter           gai(k=
        mMakUp_flow_nominal)
    annotation (Placement(transformation(extent={{40,-320},{60,-300}})));
  FixedResistances.Junction                 junEva(
    redeclare package Medium = MediumRecWat,
    m_flow_nominal={mRec_flow_nominal,-mRec_flow_nominal,-mRec_flow_nominal},
    dp_nominal={25,-25,-25}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,-190})));
  Modelica.Fluid.Sources.MassFlowSource_T sinEva(
    redeclare package Medium = MediumRecWat,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1) "Mass flow sink for evaporative water" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-190})));
  Modelica.Fluid.Sources.MassFlowSource_T sinBloDow(
    redeclare package Medium = MediumRecWat,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1) "Mass flow sink for blowdown water" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-150})));
  Controls.OBC.CDL.Reals.MultiplyByParameter           gai1(k=1/(cycCon - 1))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-150})));
  Controls.OBC.CDL.Conversions.BooleanToReal           booToRea
    annotation (Placement(transformation(extent={{0,-320},{20,-300}})));
  Controls.OBC.CDL.Reals.Hysteresis           hys(
    uLow=level_target - 0.05,
    uHigh=level_target + 0.05,
    pre_y_start=true)
    annotation (Placement(transformation(extent={{-60,-320},{-40,-300}})));
  Controls.OBC.CDL.Logical.Not           not1
    annotation (Placement(transformation(extent={{-30,-320},{-10,-300}})));
  Controls.OBC.CDL.Reals.MultiplyByParameter gai2(k=-1)
    annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
protected
  parameter MediumRecWat.Density rhoRecWat_default=MediumRecWat.density(staRecWat_default)
    "Density, used to compute fluid volume";
  parameter MediumRecWat.ThermodynamicState staRecWat_default=
     MediumRecWat.setState_pTX(T=MediumRecWat.T_default, p=MediumRecWat.p_default, X=MediumRecWat.X_default)
    "Default medium state";
equation
  connect(tan.ports[1], mov.port_a) annotation (Line(points={{-41.3333,-270},{
          -41.3333,-280},{-70,-280},{-70,-250}},
                                        color={0,127,255}));
  connect(preDro1.port_b, tan.ports[2]) annotation (Line(points={{-10,-260},{-10,
          -272},{-40,-272},{-40,-270}}, color={0,127,255}));
  connect(MakUpWat.ports[1], tan.ports[3]) annotation (Line(points={{60,-280},{
          -38.6667,-280},{-38.6667,-270}},
                                  color={0,127,255}));
  connect(gai.y,MakUpWat. m_flow_in)
    annotation (Line(points={{62,-310},{90,-310},{90,-288},{82,-288}},
                                                             color={0,0,127}));
  connect(junEva.port_3,sinEva. ports[1])
    annotation (Line(points={{0,-190},{20,-190}},color={0,127,255}));
  connect(junBloDow.port_3,sinBloDow. ports[1])
    annotation (Line(points={{0,-150},{20,-150}},
                                               color={0,127,255}));
  connect(gai1.y,sinBloDow. m_flow_in) annotation (Line(points={{58,-150},{50,-150},
          {50,-158},{40,-158}},
                            color={0,0,127}));
  connect(booToRea.y,gai. u)
    annotation (Line(points={{22,-310},{38,-310}}, color={0,0,127}));
  connect(realExpression.y,hys. u) annotation (Line(points={{-79,-310},{-62,-310}},
                       color={0,0,127}));
  connect(hys.y,not1. u) annotation (Line(points={{-38,-310},{-32,-310}},
                       color={255,0,255}));
  connect(not1.y,booToRea. u) annotation (Line(points={{-8,-310},{-2,-310}},
                 color={255,0,255}));
  connect(gai2.y,sinEva. m_flow_in) annotation (Line(points={{82,-110},{100,-110},
          {100,-198},{40,-198}}, color={0,0,127}));
  connect(gai2.y,gai1. u) annotation (Line(points={{82,-110},{100,-110},{100,-150},
          {82,-150}},  color={0,0,127}));
  connect(mov.port_b,junBloDow. port_1) annotation (Line(points={{-70,-230},{-70,
          -120},{-10,-120},{-10,-140}},          color={0,127,255}));
  connect(junBloDow.port_2,junEva. port_1)
    annotation (Line(points={{-10,-160},{-10,-180}},
                                                   color={0,127,255}));
  connect(junEva.port_2,preDro1. port_a)
    annotation (Line(points={{-10,-200},{-10,-240}},
                                                   color={0,127,255}));
  annotation (defaultComponentName="watBas",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,100},{100,-100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2},
        extent={{-100,-340},{100,-100}})),
    Documentation(revisions="<html>
<ul>
<li>
July 15, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
</html>"));
end WaterBasin;
