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
  Modelica.Blocks.Interfaces.RealInput uLiq(final unit="1", min=0)
    "Normalized utilization for liquid-cooled IT"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
      iconTransformation(extent={{-120,70},{-100,90}})));

  Modelica.Blocks.Interfaces.RealInput uAir(final unit="1", min=0)
    "Normalized utilization for air-cooled IT"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));

  // Power outputs on the right
  Controls.OBC.CDL.Interfaces.RealOutput PLiq(final unit="W")
    "Electric power consumed by liquid-cooled IT"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
        iconTransformation(extent={{100,60},{140,100}})));

  Controls.OBC.CDL.Interfaces.RealOutput PAir(final unit="W")
    "Electric power consumed by air-cooled IT, including fan energy"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}}),
        iconTransformation(extent={{100,-80},{120,-60}})));

  Controls.OBC.CDL.Interfaces.RealOutput PFan(final unit="W")
    "Electric power consumed by fan for air-cooled IT"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

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
  connect(uLiq, liq.u)
    annotation (Line(points={{-120,70},{-60,70},{-60,46},{-11,46}},
        color={0,0,127}));
  connect(uAir, air.u)
    annotation (Line(points={{-120,-90},{-60,-90},{-60,-34},{-11,-34}},
        color={0,0,127}));
  connect(liq.P, PLiq)
    annotation (Line(points={{11,48},{80,48},{80,80},{120,80}}, color={0,0,127}));
  connect(air.P, PAir)
    annotation (Line(points={{11,-32},{88,-32},{88,-70},{110,-70}},
                                                                color={0,0,127}));
  connect(air.PFan, PFan)
    annotation (Line(points={{12,-35},{80,-35},{80,-90},{110,-90}}, color={0,0,127}));

annotation (
  defaultComponentName="rac",
  Documentation(
    info="<html>
<p>
Model of a hybrid IT rack that combines liquid-cooled and air-cooled components.
This model integrates two separate cooling technologies in a single rack.
The liquid cooling component (<code>liq</code>) uses cold plates and is based on
<a href=\"modelica://Buildings.Applications.DataCenters.DataHalls.Racks.LiquidCooledSinglePhase.ColdPlateR_P\">
Buildings.Applications.DataCenters.DataHalls.Racks.LiquidCooledSinglePhase.ColdPlateR_P</a>,
while the air cooling component (<code>air</code>) with integrated fans is based on
<a href=\"modelica://Buildings.Applications.DataCenters.DataHalls.Racks.AirCooled.Rack_u\">
Buildings.Applications.DataCenters.DataHalls.Racks.AirCooled.Rack_u</a>.
</p>
<p>
The model has separate fluid ports for each cooling loop.
For liquid cooling, <code>portLiq_a</code> and <code>portLiq_b</code> serve as the inlet and outlet ports.
For air cooling, <code>portAir_a</code> and <code>portAir_b</code> serve as the inlet and outlet ports.
Each cooling system has its own utilization input on the left side of the model.
The input <code>uLiq</code> specifies the normalized utilization (0 to 1) for liquid-cooled IT equipment,
and the input <code>uAir</code> specifies the normalized utilization (0 to 1) for air-cooled IT equipment.
</p>
<p>
The model provides three power consumption outputs on the right side.
The output <code>PLiq</code> is the electric power consumed by liquid-cooled IT.
The output <code>PAir</code> is the total electric power consumed by air-cooled IT, including fan energy.
The output <code>PFan</code> is the electric power consumed by the fan for air-cooled IT.
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
          textString="%name")}));
end LiquidCooledSinglePhase;
