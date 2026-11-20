within Buildings.Fluid.Humidifiers.EvaporativeCoolers;
model IndirectDry "Indirect dry evaporative cooler"
  //extends Buildings.Fluid.Interfaces.PartialFourPortParallel;

  replaceable package Medium1 =
    Modelica.Media.Interfaces.PartialMedium
    "Medium to be cooled"
    annotation (choices(
      choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
      choice(redeclare package Medium = Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
        property_T=293.15,
        X_a=0.40)
        "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium2 =
    Modelica.Media.Interfaces.PartialMedium
    "Medium rejected to outdoor air"
    annotation (choices(
      choice(redeclare package Medium = Buildings.Media.Air "Moist air")));
  parameter Modelica.Units.SI.Pressure dp1_nominal
    "Nominal heat exchanger pressure drop of medium flow to be cooled";
  parameter Modelica.Units.SI.Pressure dpInlFil_nominal
    "Nominal  pressure drop of the inlet filter";
  parameter Modelica.Units.SI.Pressure dpMoiEli_nominal
    "Nominal  pressure drop of the moisture eliminator";
  parameter Modelica.Units.SI.Pressure dpPle_nominal
    "Nominal  pressure drop of the plenum due to the air flow turn";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal
    "Nominal heat exchanger mass flow rate of medium to be cooled";
  final parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=perPad.v_nominal
      *padAre*Medium2.dStp
    "Nominal heat exchanger mass flow rate of medium rejected to outdoor air";
  parameter Modelica.Units.SI.Area padAre
    "Area of the rigid media pad";
  replaceable parameter
    Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.Data.Generic perPad
    constrainedby
    Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.Data.Generic
    "Record with performance data for rigid media pads" annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-20,-40},{0,-20}})));
  parameter Buildings.Fluid.Humidifiers.EvaporativeCoolers.DryCoil.Data.Generic
    dat(
    Q_flow_nominal=-m1_flow_nominal*4200*(35 - 30),
    TCooIn_nominal=308.15,
    TCooOut_nominal=303.15,
    dp_nominal=dp1_nominal,
    TAirIn_nominal=298.15) "Performance data for dry cooler"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput evaCooAct
    "True: the evaporative cooling is active"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-110,-20},{-70,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dmWat_flow(
    final unit="kg/s",
    final quantity="MassFlowRate")
    "Water vapor mass flow rate difference between inlet and outlet of secondary air"
    annotation (Placement(transformation(origin={260,-30},
                                                         extent={{-20,-20},{20,20}}),
      iconTransformation(origin={90,-20},
                                        extent={{-20,-20},{20,20}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium1) annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium1) annotation (Placement(transformation(extent={{230,50},{250,70}}),
        iconTransformation(extent={{90,50},{110,70}})));
  Controls.OBC.CDL.Interfaces.RealOutput           TLvg annotation (Placement(
        transformation(extent={{240,-10},{280,30}}), iconTransformation(extent={{70,0},{
            110,40}})));
  Controls.OBC.CDL.Interfaces.RealInput uFan annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-80,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-100})));
  Sources.Outside sou(redeclare final package Medium = Medium2, final nPorts=1)
    "Source for secondary airflow" annotation (Placement(transformation(
        origin={-90,-60},
        extent={{10,-10},{-10,10}},
        rotation=180)));
  Sources.Outside sin(redeclare final package Medium = Medium2, final nPorts=1)
    "Sink for secondary airflow" annotation (Placement(transformation(
        origin={170,-80},
        extent={{10,-10},{-10,10}},
        rotation=0)));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-170,-80},{-130,-40}}), iconTransformation(
          extent={{-120,-70},{-100,-50}})));
  Movers.SpeedControlled_y fan(
    redeclare package Medium = Medium2,
    per=perFan,
    addPowerToMedium=false)
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perFan
    constrainedby Buildings.Fluid.Movers.Data.Generic
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{120,-60},{140,-40}})));
  FixedResistances.PressureDrop inlFil(redeclare package Medium = Medium2,
      m_flow_nominal=m2_flow_nominal,
    n=1.8,
    dp_nominal=dpInlFil_nominal) "Inlet filter"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  FixedResistances.PressureDrop moiEli(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal,
    n=1.8,
    dp_nominal=dpMoiEli_nominal) "Moisture eliminator"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  FixedResistances.PressureDrop ple(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal,
    n=1.7,
    dp_nominal=dpPle_nominal)    "Plenum"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Controls.OBC.CDL.Reals.Sources.Constant mRecPum_flow(k=2)
    "Mass flow setpoint of the recirculation pump"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perRecPum
  constrainedby
    Buildings.Fluid.Movers.Data.Generic
    "Performance record for the recirculation pump"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-20,0},{0,20}})));
protected
  RigidMediaPad.PadWithBasin padWitBas(
    redeclare final package Medium = Medium2,
    final padAre=padAre,
    perPad(
      final efficiency=perPad.efficiency,
      final dp_nominal=perPad.dp_nominal,
      final v_nominal=perPad.v_nominal,
      final n=perPad.n),
    perRecPum=perRecPum)
    "Direct evaporative cooler for representing the cooling effect on the secondary air"
    annotation (Placement(transformation(origin={-10,-60}, extent={{-10,-10},{10,
            10}})));
  DryCoil.DryCoil                                      dryCoil(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
                                dat=dat)
    "Heat exchanger for heat transfer between primary and secondary air"
    annotation (Placement(transformation(origin={70,60},
                                                       extent = {{-10, -10}, {10, 10}})));
equation
  connect(padWitBas.dmWat_flow, dmWat_flow)
    annotation (Line(points={{2,-54},{10,-54},{10,-30},{260,-30}},
                                                                 color={0,0,127}));
  connect(evaCooAct,padWitBas. evaCooAct)
    annotation (Line(points={{-120,0},{-30,0},{-30,-54},{-22,-54}},
      color={255,0,255}));
  connect(dryCoil.TLvg, TLvg) annotation (Line(points={{78,60},{140,60},{140,10},
          {260,10}},     color={0,0,127}));
  connect(weaBus, sin.weaBus) annotation (Line(
      points={{-150,-60},{-120,-60},{-120,-160},{200,-160},{200,-79.8},{180,-79.8}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, sou.weaBus) annotation (Line(
      points={{-150,-60},{-125,-60},{-125,-60.2},{-100,-60.2}},
      color={255,204,51},
      thickness=0.5));
  connect(fan.port_b, sin.ports[1])
    annotation (Line(points={{140,-80},{160,-80}}, color={0,127,255}));
  connect(uFan, fan.y) annotation (Line(points={{-80,-120},{110,-120},{110,-68},
          {130,-68}}, color={0,0,127}));
  connect(port_a, dryCoil.port_a1) annotation (Line(points={{-100,60},{0,60},{0,
          66},{60,66}},  color={0,127,255}));
  connect(dryCoil.port_b1, port_b) annotation (Line(points={{80,66},{220,66},{220,
          60},{240,60}},     color={0,127,255}));
  connect(dryCoil.port_b2, fan.port_a) annotation (Line(points={{60,54},{50,54},
          {50,-80},{120,-80}},                     color={0,127,255}));
  connect(sou.ports[1], inlFil.port_a)
    annotation (Line(points={{-80,-60},{-60,-60}}, color={0,127,255}));
  connect(moiEli.port_b, ple.port_a)
    annotation (Line(points={{40,-60},{60,-60}}, color={0,127,255}));
  connect(ple.port_b, dryCoil.port_a2) annotation (Line(points={{80,-60},{100,-60},
          {100,54},{80,54}}, color={0,127,255}));
  connect(mRecPum_flow.y,padWitBas. mRecPum_flow) annotation (Line(points={{-38,
          -90},{-30,-90},{-30,-66},{-22,-66}}, color={0,0,127}));
  connect(inlFil.port_b, padWitBas.port_a)
    annotation (Line(points={{-40,-60},{-20,-60}}, color={0,127,255}));
  connect(padWitBas.port_b, moiEli.port_a)
    annotation (Line(points={{0,-60},{20,-60}}, color={0,127,255}));
annotation (defaultComponentName="indDryEva",
Documentation(info="<html>
<p>
Model for an indirect dry evaporative cooler.
</p>
<p>
This model contains two components, a direct evaporative cooler 
(<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.Direct\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.Direct</a>) 
and a heat exchanger with constant effectiveness
(<a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectiveness</a>). 
The secondary air travels through the evaporative cooler and enters the heat
exchanger where it cools the primary fluid flowing through the heat exchanger tubes.
</p>
<p>
The input variable <code>evaCooAct</code> determines whether evaporative cooling is
active for the direct evaporative cooler. When evaporative cooling is not active
(the rigid media pad is dry), no water vapor is added to the air.
</p>
<p>
<b>Note:</b> The model works correctly only when the ports a1 and a2 are used as
inlet ports, and ports b1 and b2 are used as outlet ports, for the primary and
secondary flow respectively.
</p>
<p>
A diagram for this model is shown below:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Humidifiers/EvaporativeCoolers/IndirectDryEvaporativeCooler.svg\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
July 21, 2026, by Weiping Huang:<br/>
Added a Modelica data record to calculate saturation efficiency and pressure drop,
as well as added a flag to turn on and off the evaporative cooling for the
evaporative cooler.
</li>
<li>
September 20, 2023 by Cerrina Mouchref, Karthikeya Devaprasad, Lingzhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
     graphics={Rectangle(lineColor = {0, 0, 255}, fillColor = {95, 95, 95}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent={{-70,60},{70,-60}}),
  Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent={{-102,65},{98,56}}),
  Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
          fillPattern = FillPattern.Solid,
          points={{42,42},{54,34},{54,34},{42,28},{42,30},{50,34},{50,34},{42,40},{42,42}}),
  Rectangle(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern = FillPattern.Solid, extent={{58,-54},{54,52}}),
  Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
          fillPattern = FillPattern.Solid,
          points={{42,10},{54,2},{54,2},{42,-4},{42,-2},{50,2},{50,2},{42,8},{42,10}}),
  Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
          fillPattern = FillPattern.Solid,
          points={{42,-26},{54,-34},{54,-34},{42,-40},{42,-38},{50,-34},{50,-34},{42,-28},{42,-26}}),
  Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent={{-100,-55},{100,-64}}),
  Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 62, 0}, pattern = LinePattern.None,
            fillPattern = FillPattern.Solid, extent={{-70,68},{70,-66}}),
  Rectangle(extent={{10,40},{20,-40}},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
  Rectangle(extent={{20,40},{30,-40}},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
  Rectangle(extent={{30,40},{40,-40}},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
  Rectangle(extent={{40,40},{50,-40}},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
  Rectangle(extent={{50,40},{60,-40}},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
  Rectangle(lineColor={255, 255, 255}, fillColor={255,236,32},
            fillPattern=FillPattern.Solid, extent={{-20,52},{-60,56}}),
  Rectangle(lineColor={255, 255, 255}, fillColor={255,236,32},
            fillPattern=FillPattern.Solid, extent={{-56,-52},{-60,52}}),
  Polygon(points={{-46,38},{-48,28},{-42,24},{-34,28},{-36,38},{-42,50},{-46,38}},
          lineColor={0,255,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
  Polygon(points={{-46,2},{-48,-8},{-42,-12},{-34,-8},{-36,2},{-42,14},{-46,2}},
          lineColor={0,255,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
  Polygon(points={{-46,-32},{-48,-42},{-42,-46},{-34,-42},{-36,-32},{-42,-20},{
              -46,-32}},
          lineColor={0,255,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
  Rectangle(lineColor={255, 255, 255}, fillColor={255,236,32},
            fillPattern=FillPattern.Solid, extent={{-20,-56},{-60,-52}}),
  Rectangle(lineColor={255, 255, 255}, fillColor={255,236,32},
            fillPattern=FillPattern.Solid, extent={{-20,-52},{-24,52}})}),
    Diagram(coordinateSystem(extent={{-100,-100},{240,100}})));
end IndirectDry;
