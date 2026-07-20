within Buildings.Applications.DataCenters.DataHalls.Racks.Hybrid.LiquidCooledSinglePhase;
model LiquidCooledSinglePhase
  "Hybrid rack model combining liquid-cooled and air-cooled components"

  replaceable package MediumLiq = Modelica.Media.Interfaces.PartialMedium
    "Medium for liquid cooling loop"
      annotation (choices(
        choice(redeclare package MediumLiq = Buildings.Media.Water "Water"),
        choice(redeclare package MediumLiq =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=303.15,
              X_a=0.25)
              "Propylene glycol water, 25% mass fraction")));

  replaceable package MediumAir = Modelica.Media.Interfaces.PartialMedium
    "Medium for air cooling loop"
      annotation (choices(
        choice(redeclare package MediumAir = Buildings.Media.Air "Air")));

  replaceable parameter Buildings.Applications.DataCenters.DataHalls.Racks.Hybrid.Data.LiquidCooledSinglePhase.Generic dat
    "Performance data"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  // Liquid-cooled parameters
  parameter Modelica.Fluid.Types.Dynamics energyDynamicsLiq=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance for liquid-cooled component: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Liquid cooling"));

  parameter Modelica.Units.SI.Time tauLiq=2
    "Time constant of liquid outlet temperature at nominal flow"
    annotation(Dialog(tab="Dynamics", group="Liquid cooling"));

  parameter Modelica.Units.SI.Temperature TLiq_start = 293.15
    "Start value of liquid temperature"
    annotation(Dialog(tab = "Initialization", group="Liquid cooling"));

  parameter Modelica.Units.SI.VolumeFlowRate VColPla_flow_nominal=sum(dat.liq.theRes.V_flow)
      /size(dat.liq.theRes.V_flow, 1)
    "Design flow rate of one cold plate for liquid cooling"
    annotation (Dialog(group="Liquid cooling"));

  parameter Real nColPla(min=0)=dat.liq.PIT_nominal/
    (VColPla_flow_nominal*1000*4200*(dat.liq.PIT_nominal/
    (dat.liq.m_flow_nominal*4200)))
    "Number of cold plates for liquid cooling"
    annotation (Dialog(group="Liquid cooling"));

  parameter Boolean linearizedLiq = false
    "= true, use linear relation between m_flow and dp for liquid cooling"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Liquid cooling"));

  // Air-cooled parameters
  parameter Modelica.Fluid.Types.Dynamics energyDynamicsAir=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance for air-cooled component: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Air cooling"));

  parameter Modelica.Units.SI.Time tauAir=2
    "Time constant of air outlet temperature at nominal flow"
    annotation(Dialog(tab="Dynamics", group="Air cooling"));

  parameter Modelica.Units.SI.Temperature TAir_start = 293.15
    "Start value of air temperature"
    annotation(Dialog(tab = "Initialization", group="Air cooling"));

  // Fluid ports
  Modelica.Fluid.Interfaces.FluidPort_a portLiq_a(
    redeclare package Medium = MediumLiq)
    "Liquid cooling inlet port"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}}),
      iconTransformation(extent={{-110,30},{-90,50}})));

  Modelica.Fluid.Interfaces.FluidPort_b portLiq_b(
    redeclare package Medium = MediumLiq)
    "Liquid cooling outlet port"
    annotation (Placement(transformation(extent={{90,30},{110,50}}),
      iconTransformation(extent={{90,30},{110,50}})));

  Modelica.Fluid.Interfaces.FluidPort_a portAir_a(
    redeclare package Medium = MediumAir)
    "Air cooling inlet port"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}}),
      iconTransformation(extent={{-110,-50},{-90,-30}})));

  Modelica.Fluid.Interfaces.FluidPort_b portAir_b(
    redeclare package Medium = MediumAir)
    "Air cooling outlet port"
    annotation (Placement(transformation(extent={{92,-50},{112,-30}}),
      iconTransformation(extent={{92,-50},{112,-30}})));

  // Control inputs on the left
  Modelica.Blocks.Interfaces.RealInput PLiq(final unit="W", min=0)
    "Power consumed by for liquid-cooled IT"
    annotation (Placement(transformation(extent={{-140,52},{-100,92}}),
      iconTransformation(extent={{-120,72},{-100,92}})));

  Modelica.Blocks.Interfaces.RealInput PAir(final unit="W", min=0)
    "Power consumed by air-cooled IT"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));

  // Power outputs on the right
  Modelica.Blocks.Interfaces.RealOutput PLiqTot(final unit="W")
    "Electric power consumed by liquid-cooled IT" annotation (Placement(
        transformation(extent={{100,80},{120,100}}), iconTransformation(extent={{100,80},
            {120,100}})));

  Modelica.Blocks.Interfaces.RealOutput PAirTot(final unit="W")
    "Electric power consumed by air-cooled IT, including fan energy"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}}),
        iconTransformation(extent={{100,-80},{120,-60}})));

  Modelica.Blocks.Interfaces.RealOutput PAirFan(final unit="W")
    "Electric power consumed by fan for air-cooled IT" annotation (Placement(
        transformation(extent={{100,-100},{120,-80}}), iconTransformation(
          extent={{100,-100},{120,-80}})));

  // Component instances
  Buildings.Applications.DataCenters.DataHalls.Racks.LiquidCooledSinglePhase.ColdPlateR_P
    liq(
    redeclare package Medium = MediumLiq,
    dat=dat.liq,
    energyDynamics=energyDynamicsLiq,
    tau=tauLiq,
    T_start=TLiq_start,
    VColPla_flow_nominal=VColPla_flow_nominal,
    nColPla=nColPla,
    linearized=linearizedLiq)
    "Liquid-cooled rack component"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

  Buildings.Applications.DataCenters.DataHalls.Racks.AirCooled.Rack_u air(
    redeclare package Medium = MediumAir,
    dat=dat.air,
    energyDynamics=energyDynamicsAir,
    tau=tauAir,
    T_start=TAir_start)
    "Air-cooled rack component"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

equation
  connect(portLiq_a, liq.port_a)
    annotation (Line(points={{-100,40},{-10,40}}, color={0,127,255}));
  connect(liq.port_b, portLiq_b)
    annotation (Line(points={{10,40},{100,40}}, color={0,127,255}));
  connect(portAir_a, air.port_a)
    annotation (Line(points={{-100,-40},{-10,-40}}, color={0,127,255}));
  connect(air.port_b, portAir_b)
    annotation (Line(points={{10,-40},{102,-40}}, color={0,127,255}));

  connect(PLiq, PLiqTot) annotation (Line(points={{-120,72},{-40,72},{-40,90},{
          110,90}}, color={0,0,127}));
  connect(PAir, air.P) annotation (Line(points={{-120,-90},{-30,-90},{-30,-34},
          {-11,-34}}, color={0,0,127}));
  connect(air.PTot, PAirTot) annotation (Line(points={{11,-32},{60,-32},{60,-70},
          {110,-70}}, color={0,0,127}));
  connect(air.PFan, PAirFan) annotation (Line(points={{11,-35},{56,-35},{56,-90},
          {110,-90}}, color={0,0,127}));
  connect(liq.P, PLiq) annotation (Line(points={{-11,46},{-40,46},{-40,72},{
          -120,72}}, color={0,0,127}));
annotation (
  defaultComponentName="rac",
  Documentation(
    info="<html>
<p>
Model of a hybrid IT rack that combines liquid-cooled and air-cooled components.
This model integrates two separate cooling technologies in a single rack.
The liquid cooling component uses cold plates and is based on
<a href=\"modelica://Buildings.Applications.DataCenters.DataHalls.Racks.LiquidCooledSinglePhase.ColdPlateR_P\">
Buildings.Applications.DataCenters.DataHalls.Racks.LiquidCooledSinglePhase.ColdPlateR_P</a>,
while the air cooling component with integrated fans is based on
<a href=\"modelica://Buildings.Applications.DataCenters.DataHalls.Racks.AirCooled.Rack_u\">
Buildings.Applications.DataCenters.DataHalls.Racks.AirCooled.Rack_u</a>.
</p>
<p>
The model has separate fluid ports for each cooling loop.
For liquid cooling, <code>portLiq_a</code> and <code>portLiq_b</code> serve as the inlet and outlet ports.
For air cooling, <code>portAir_a</code> and <code>portAir_b</code> serve as the inlet and outlet ports.
Each cooling system has its own input for the electrical power consumption by the IT equipment.
The input <code>PLiq</code> specifies the power consumption for the liquid-cooled IT equipment,
and the input <code>PAir</code> specifies the power consumption for the air-cooled IT equipment.
Note that <code>PAir</code> does not include the power to operate the fan, as this is an output of the model.
</p>
<p>
The model provides three power consumption outputs on the right side.
The output <code>PLiqTot</code> is the electric power consumed by liquid-cooled IT.
The output <code>PAirTot</code> is the total electric power consumed by air-cooled IT, including fan energy.
The output <code>PAirFan</code> is the electric power consumed by the fan for air-cooled IT.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 14, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,62},{40,-58}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,50},{32,36}},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,-12},{32,-26}},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,8},{32,-6}},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,-34},{32,-48}},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,30},{32,16}},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,44},{100,36}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-106,44},{-40,36}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,-36},{100,-44}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-106,-36},{-40,-44}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-139,-104},{161,-144}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{58,100},{88,64}},
          textColor={0,0,127},
          textString="PLiqTot"),
        Text(
          extent={{60,-50},{90,-86}},
          textColor={0,0,127},
          textString="PAirTot"),
        Text(
          extent={{60,-70},{90,-106}},
          textColor={0,0,127},
          textString="PAirFan"),
        Text(
          extent={{-92,98},{-62,62}},
          textColor={0,0,127},
          textString="PLiq"),
        Text(
          extent={{-92,-62},{-62,-98}},
          textColor={0,0,127},
          textString="PAir")}));
end LiquidCooledSinglePhase;
