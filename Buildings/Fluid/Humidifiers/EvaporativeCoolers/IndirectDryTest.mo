within Buildings.Fluid.Humidifiers.EvaporativeCoolers;
model IndirectDryTest "Indirect dry evaporative cooler"
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
  parameter Real eps(
    final unit = "1")=0.8
    "Heat exchanger effectiveness";
  parameter Modelica.Units.SI.Pressure dp1_nominal
    "Nominal heat exchanger pressure drop of medium flow to be cooled";
  parameter Modelica.Units.SI.Pressure dp2_nominal
    "Nominal heat exchanger pressure drop of medium rejected to outdoor air";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal
    "Nominal heat exchanger mass flow rate of medium to be cooled";
  final parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=per.v_nominal*padAre*Medium2.dStp
    "Nominal heat exchanger mass flow rate of medium rejected to outdoor air";
  parameter Modelica.Units.SI.Area padAre
    "Area of the rigid media evaporative pad";
  replaceable parameter Buildings.Fluid.Humidifiers.EvaporativeCoolers.Data.Generic per
    constrainedby Buildings.Fluid.Humidifiers.EvaporativeCoolers.Data.Generic
    "Record with performance data for evaporative pads"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-40,-40},{-20,-20}})));

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
      iconTransformation(origin={90,0}, extent={{-20,-20},{20,20}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium =
        Medium1) annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-334,94},{-314,114}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare package Medium =
        Medium2) annotation (Placement(transformation(extent={{-110,-90},{-90,
            -70}}), iconTransformation(extent={{-334,94},{-314,114}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium =
        Medium1) annotation (Placement(transformation(extent={{230,50},{250,70}}),
        iconTransformation(extent={{-308,-12},{-288,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(redeclare package Medium =
        Medium2) annotation (Placement(transformation(extent={{230,-90},{250,
            -68}}), iconTransformation(extent={{-308,-12},{-288,10}})));
  Sensors.TemperatureTwoPort                 senTem(redeclare package Medium =
        Medium2)
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  FixedResistances.PressureDrop                 preDro(
    redeclare final package Medium = Medium2,
    final n=n,
    final m_flow_nominal=m_flow_nominal,
    final deltaM=deltaM,
    final allowFlowReversal=allowFlowReversal,
    final show_T=false,
    final from_dp=from_dp,
    final linearized=linearizeFlowResistance,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp_nominal) "Flow resistance"
    annotation (Placement(transformation(extent={{98,-70},{118,-50}})));
              MixingVolumes.MixingVolume                 vol(
    redeclare final package Medium = Medium2,
    nPorts=2,
    V=m_flow_nominal*tau/rho_default,
    final allowFlowReversal=allowFlowReversal,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    final energyDynamics=energyDynamics,
    final massDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start) "Volume for fluid stream"
     annotation (Placement(transformation(extent={{167,-60},{187,-80}})));
  Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium2)
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Controls.OBC.CDL.Interfaces.RealOutput           TLvg annotation (Placement(
        transformation(extent={{240,-10},{280,30}}), iconTransformation(extent=
            {{-2,-84},{38,-44}})));
  parameter HeatExchangers.CoolingTowers.Data.DryCooler.Generic
    dat(
    Q_flow_nominal=-m_flow_nominal*4200*(35 - 30),
    TCooIn_nominal=308.15,
    TCooOut_nominal=303.15,
    dp_nominal=6000,
    TAirIn_nominal=298.15) "Performance data for dry cooler"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
protected
  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Direct dirEvaCoo(
    redeclare final package Medium = Medium2,
    final padAre=padAre,
    per(final efficiency=per.efficiency,
      final v_nominal=per.v_nominal,
      final dp_nominal=per.dp_nominal,
      final n=per.n))
    "Direct evaporative cooler for representing the cooling effect on the secondary air"
    annotation (Placement(transformation(origin={-30,-60},
                                                         extent={{-10,-10},{10,10}})));
  DryCoil.DryCoil                                      dryCoil(redeclare
      package Medium = Medium1, dat=dat)
    "Heat exchanger for heat transfer between primary and secondary air"
    annotation (Placement(transformation(origin={110,60},
                                                       extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{128,10},{148,30}})));
  Modelica.Blocks.Sources.RealExpression Q_flow(y(
      final quantity="Power",
      final unit="W") = dryCoil.Q_flow*(-1))   "Heat transfer"
    annotation (Placement(transformation(extent={{88,10},{108,30}})));
equation
  connect(dirEvaCoo.dmWat_flow, dmWat_flow)
    annotation (Line(points={{-21,-56},{0,-56},{0,-30},{260,-30}},
                                                                 color={0,0,127}));
  connect(evaCooAct, dirEvaCoo.evaCooAct)
    annotation (Line(points={{-120,0},{-60,0},{-60,-64},{-39,-64}},
      color={255,0,255}));
  connect(port_a2, dirEvaCoo.port_a) annotation (Line(points={{-100,-80},{-56,
          -80},{-56,-60},{-40,-60}}, color={0,127,255}));
  connect(Q_flow.y,preHea. Q_flow) annotation (Line(points={{109,20},{128,20}},
                               color={0,0,127}));
  connect(preHea.port,vol. heatPort) annotation (Line(points={{148,20},{158,20},
          {158,-70},{167,-70}},      color={191,0,0}));
  connect(senTem.port_b, preDro.port_a)
    annotation (Line(points={{80,-60},{98,-60}}, color={0,127,255}));
  connect(preDro.port_b, vol.ports[1])
    annotation (Line(points={{118,-60},{176,-60}}, color={0,127,255}));
  connect(vol.ports[2], port_b2) annotation (Line(points={{178,-60},{200,-60},{
          200,-78},{240,-78},{240,-79}}, color={0,127,255}));
  connect(senTem.T, dryCoil.TDryBul)
    annotation (Line(points={{70,-49},{70,64},{98,64}}, color={0,0,127}));
  connect(port_a1, dryCoil.port_a)
    annotation (Line(points={{-100,60},{100,60}}, color={0,127,255}));
  connect(dryCoil.port_b, port_b1)
    annotation (Line(points={{120,60},{240,60}}, color={0,127,255}));
  connect(dirEvaCoo.port_b, senMasFlo.port_a)
    annotation (Line(points={{-20,-60},{20,-60}}, color={0,127,255}));
  connect(senMasFlo.port_b, senTem.port_a)
    annotation (Line(points={{40,-60},{60,-60}}, color={0,127,255}));
  connect(senMasFlo.m_flow, dryCoil.mAir_flow)
    annotation (Line(points={{30,-49},{30,68},{98,68}}, color={0,0,127}));
  connect(dryCoil.TLvg, TLvg) annotation (Line(points={{121,54},{220,54},{220,
          10},{260,10}}, color={0,0,127}));
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
(the evaporative pad is dry), no water vapor is added to the air.
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
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Humidifiers/EvaporativeCoolers/IndirectDryEvaporativeCooler.png\"/>
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
Icon(coordinateSystem(extent={{-100,-100},{240,100}}),
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
end IndirectDryTest;
