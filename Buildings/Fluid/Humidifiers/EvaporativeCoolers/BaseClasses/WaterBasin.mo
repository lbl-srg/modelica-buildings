within Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses;
model WaterBasin "Water basin"

  parameter Modelica.Units.SI.Height height "Height of the tank";
  parameter Modelica.Units.SI.Area crossArea "Cross-sectional area of the tank";
  parameter Modelica.Units.SI.Height level_target(min=0, max=height) "Target water level in the tank";
  parameter Modelica.Units.SI.MassFlowRate mMakUp_flow_nominal
    "Make up water mass flow nominal";
  final parameter Modelica.Units.SI.MassFlowRate mRec_flow_nominal=if perRecPum.havePressureCurve
       then perRecPum.V_flow_max*rhoRecWat_default else 2
    "Recirculation water mass flow nominal";
  parameter Real cycCon
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
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Movers.FlowControlled_m_flow mov(
    redeclare package Medium = MediumRecWat,
    per=perRecPum,
    addPowerToMedium=true,
    m_flow_nominal=mRec_flow_nominal) "Recirculation pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-20})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perRecPum
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance record for the recirculation pump" annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-60,40},{-40,60}})));
  FixedResistances.PressureDrop preDro(
    redeclare package Medium = MediumRecWat,
    m_flow_nominal=mRec_flow_nominal,
    dp_nominal=20000) "Pressure drop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,-30})));
  FixedResistances.Junction                 junBloDow(
    redeclare package Medium = MediumRecWat,
    m_flow_nominal={mRec_flow_nominal,-mRec_flow_nominal,-mRec_flow_nominal},
    dp_nominal={25,-25,-25}) "Junction for blowdown water flow" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,70})));
  Sources.MassFlowSource_T                 MakUpWat(
    redeclare package Medium = MediumRecWat,
    use_m_flow_in=true,
    T=288.15,
    nPorts=1) "Make up water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-60})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=tan.level)
    "Water level of the tank"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Controls.OBC.CDL.Reals.MultiplyByParameter           gai(k=
        mMakUp_flow_nominal)
    "Make-up water mass flow rate"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  FixedResistances.Junction                 junEva(
    redeclare package Medium = MediumRecWat,
    m_flow_nominal={mRec_flow_nominal,-mRec_flow_nominal,-mRec_flow_nominal},
    dp_nominal={25,-25,-25}) "Junction for evaporated water flow" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,30})));
  Modelica.Fluid.Sources.MassFlowSource_T sinEva(
    redeclare package Medium = MediumRecWat,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1) "Mass flow sink for evaporative water" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,30})));
  Modelica.Fluid.Sources.MassFlowSource_T sinBloDow(
    redeclare package Medium = MediumRecWat,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1) "Mass flow sink for blowdown water" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,70})));
  Controls.OBC.CDL.Reals.MultiplyByParameter           gai1(k=1/(cycCon - 1))
    "Blowdown water mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,70})));
  Controls.OBC.CDL.Conversions.BooleanToReal           booToRea
    "Convert make-up water enable signal to real"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Controls.OBC.CDL.Reals.Hysteresis           hys(
    uLow=level_target - 0.05,
    uHigh=level_target + 0.05,
    pre_y_start=true)
    "Hysteresis for the water level control"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Controls.OBC.CDL.Logical.Not           not1
    "Negation of the hysteresis output"
    annotation (Placement(transformation(extent={{-30,-100},{-10,-80}})));
  Controls.OBC.CDL.Reals.MultiplyByParameter gai2(k=-1)
    "Negation of the evaporation mass flow rate"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  inner Modelica.Fluid.System system(p_ambient=101325, T_ambient=293.15)
    "System-wide properties"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Controls.OBC.CDL.Interfaces.RealOutput mMakUp_flow "Makeup water flow"
    annotation (Placement(transformation(extent={{100,-30},{140,10}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Controls.OBC.CDL.Interfaces.RealInput mWatEva_flow
    "Mass flow of water evaporation that leaves the water recirculation loop"
    annotation (Placement(transformation(extent={{-180,80},{-140,120}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Controls.OBC.CDL.Interfaces.BooleanInput wetMod
    "True: the basin is operating on the wet mode; false: the basin is operating on the dry mode"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(realTrue=
        mRec_flow_nominal)
    "The recirculation pump is operating at the nominal water flow during the wet mode and at zero flow during the dry mode"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Controls.OBC.CDL.Reals.Sources.Constant con(k=0)
    "Zero mass flow of water evaporation during the dry mode"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
protected
  parameter MediumRecWat.Density rhoRecWat_default=MediumRecWat.density(staRecWat_default)
    "Density, used to compute fluid volume";
  parameter MediumRecWat.ThermodynamicState staRecWat_default=
     MediumRecWat.setState_pTX(T=MediumRecWat.T_default, p=MediumRecWat.p_default, X=MediumRecWat.X_default)
    "Default medium state";
equation
  connect(tan.ports[1], mov.port_a) annotation (Line(points={{-41.3333,-50},{-41.3333,
          -60},{-70,-60},{-70,-30}},    color={0,127,255}));
  connect(preDro.port_b, tan.ports[2]) annotation (Line(points={{-10,-40},{-10,-52},
          {-40,-52},{-40,-50}}, color={0,127,255}));
  connect(MakUpWat.ports[1], tan.ports[3]) annotation (Line(points={{60,-60},{-38.6667,
          -60},{-38.6667,-50}},   color={0,127,255}));
  connect(gai.y,MakUpWat. m_flow_in)
    annotation (Line(points={{62,-90},{90,-90},{90,-68},{82,-68}},
                                                             color={0,0,127}));
  connect(junEva.port_3,sinEva. ports[1])
    annotation (Line(points={{0,30},{20,30}},    color={0,127,255}));
  connect(junBloDow.port_3,sinBloDow. ports[1])
    annotation (Line(points={{0,70},{20,70}},  color={0,127,255}));
  connect(gai1.y,sinBloDow. m_flow_in) annotation (Line(points={{58,70},{50,70},
          {50,62},{40,62}}, color={0,0,127}));
  connect(booToRea.y,gai. u)
    annotation (Line(points={{22,-90},{38,-90}},   color={0,0,127}));
  connect(realExpression.y,hys. u) annotation (Line(points={{-79,-90},{-62,-90}},
                       color={0,0,127}));
  connect(hys.y,not1. u) annotation (Line(points={{-38,-90},{-32,-90}},
                       color={255,0,255}));
  connect(not1.y,booToRea. u) annotation (Line(points={{-8,-90},{-2,-90}},
                 color={255,0,255}));
  connect(gai2.y,sinEva. m_flow_in) annotation (Line(points={{82,110},{100,110},
          {100,22},{40,22}},     color={0,0,127}));
  connect(gai2.y,gai1. u) annotation (Line(points={{82,110},{100,110},{100,70},{
          82,70}},     color={0,0,127}));
  connect(mov.port_b,junBloDow. port_1) annotation (Line(points={{-70,-10},{-70,
          100},{-10,100},{-10,80}},              color={0,127,255}));
  connect(junBloDow.port_2,junEva. port_1)
    annotation (Line(points={{-10,60},{-10,40}},   color={0,127,255}));
  connect(junEva.port_2, preDro.port_a)
    annotation (Line(points={{-10,20},{-10,-20}}, color={0,127,255}));
  connect(gai.y, mMakUp_flow) annotation (Line(points={{62,-90},{90,-90},{90,-10},
          {120,-10}},  color={0,0,127}));
  connect(wetMod, booToRea1.u)
    annotation (Line(points={{-160,-20},{-122,-20}}, color={255,0,255}));
  connect(booToRea1.y, mov.m_flow_in)
    annotation (Line(points={{-98,-20},{-82,-20}}, color={0,0,127}));
  connect(mWatEva_flow, swi.u1) annotation (Line(points={{-160,100},{-120,100},{
          -120,138},{-62,138}}, color={0,0,127}));
  connect(con.y, swi.u3) annotation (Line(points={{-78,110},{-70,110},{-70,122},
          {-62,122}}, color={0,0,127}));
  connect(swi.y, gai2.u) annotation (Line(points={{-38,130},{40,130},{40,110},{58,
          110}}, color={0,0,127}));
  connect(wetMod, swi.u2) annotation (Line(points={{-160,-20},{-130,-20},{-130,130},
          {-62,130}}, color={255,0,255}));
  annotation (defaultComponentName="watBas",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
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
        extent={{-140,-120},{100,140}})),
    Documentation(revisions="<html>
<ul>
<li>
November 27, 2026, by Weiping Huang:<br/>
Revised the documentation.
</li>
<li>
November 20, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This is a model of a water basin for evaporative coolers.
The water basin is represented by an open tank and consists of
a recirculation loop and a make-up water control loop.
This model is used in the rigid media pad with basin model
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.PadWithBasin\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.PadWithBasin</a>.
</p>
<h4>Water recirculation loop</h4>
<p>
Water is drawn from the bottom of the tank by a recirculation pump
<code>mov</code>, which is parameterized by the performance data
<code>perRecPum</code>. The boolean input <code>wetMod</code> switches
between the wet and the dry mode: In the wet mode
(<code>wetMod = true</code>), the pump circulates water at the nominal
recirculation mass flow rate <code>mRec_flow_nominal</code>, which should
be set to the flow needed for water distribution over the wetted media.
In the dry mode (<code>wetMod = false</code>), the pump is off.
The water flows back to the tank through
a pressure drop element that models the pressure loss of the water
distribution network. The nominal recirculation mass flow rate
<code>mRec_flow_nominal</code> is computed from the maximum volume
flow rate of the pump performance data, converted using the
default water density of <code>MediumRecWat</code>.
</p>
<h4>Evaporation and blowdown</h4>
<p>
The input <code>mWatEva_flow</code> is the mass flow rate of water
that evaporates and leaves the recirculation loop. In the dry mode,
this mass flow rate is forced to zero. To avoid the
accumulation of dissolved solids in the recirculating water, a
blowdown flow is removed from the loop. The blowdown mass flow rate
is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775;<sub>bloDow</sub> = m&#775;<sub>eva</sub> / (cycCon - 1),
</p>
<p>
where <code>cycCon</code> is the cycle of concentration, i.e., the
ratio of dissolved solids in the recirculating water to that in the
make-up water. With this formulation, the cycle of concentration of
the recirculating water equals <code>cycCon</code> in steady state.
Both the evaporated water and the blowdown water are removed at
constant temperature by ideal mass flow sources.
</p>
<h4>Make-up water control</h4>
<p>
The water level of the tank is controlled with a hysteresis:
When the level falls below <code>level_target - 0.05</code> m,
the make-up water flow is enabled and water is supplied at
<code>mMakUp_flow_nominal</code>. When the level rises above
<code>level_target + 0.05</code> m, the make-up water flow is
disabled. The output <code>mMakUp_flow</code> returns the actual
make-up water mass flow rate.
</p>
<h4>Assumptions and limitations</h4>
<ul>
<li>
The medium of the recirculation water is liquid water.
</li>
<li>
The tank is initialized at the water level <code>level_target</code>
using fixed initial conditions for the energy and mass balances.
</li>
<li>
The hysteresis band of the water level control is fixed to
<i>&plusmn;0.05</i> m around <code>level_target</code>.
</li>
</ul>
<p>
See
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses.Validation.WaterBasin\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses.Validation.WaterBasin</a>
for a validation model.
</p>
</html>"));
end WaterBasin;
