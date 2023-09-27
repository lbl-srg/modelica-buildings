within Buildings.Templates.Components.Validation;
model Valves "Validation model for valve components"
  extends Modelica.Icons.Example;

  replaceable package MediumLiq=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Liquid medium";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Fluid.Sources.Boundary_pT bouLiqEnt(
    redeclare final package Medium = MediumLiq,
    p=bouLiqLvg.p + modThr.dat.dpValve_nominal + modThr.dat.dpFixed_nominal,
    nPorts=7) "Boundary conditions for entering liquid"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Fluid.Sources.Boundary_pT bouLiqLvg(
    redeclare final package Medium =MediumLiq, nPorts=5)
    "Boundary conditions for leaving liquid"
    annotation (Placement(transformation(extent={{110,70},{90,90}})));

  Actuators.Valve                                          modThr(
    redeclare final package Medium = MediumLiq,
    typ=Buildings.Templates.Components.Types.Valve.ThreeWayModulating,
    final energyDynamics=energyDynamics,
    dat(
      m_flow_nominal=1,
      dpValve_nominal=5000,
      dpFixed_nominal=5000))
    "Three-way modulating valve"
    annotation (Placement(transformation(extent={{10,90},{30,110}})));
  Interfaces.Bus bus
    "Control bus"
    annotation (Placement(
      iconVisible=false,
      transformation(extent={{-20,100},{20,140}}),
      iconTransformation(extent={{-250,-32},{-210,8}})));
  Controls.OBC.CDL.Reals.Sources.Ramp y(height=1,
    duration=10) "Damper control signal"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));

  Actuators.Valve                                           twoThr(
    redeclare final package Medium = MediumLiq,
    typ=Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition,
    final energyDynamics=energyDynamics,
    dat(
      m_flow_nominal=1,
      dpValve_nominal=5000,
      dpFixed_nominal=5000)) "Three-way two position valve"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  Interfaces.Bus bus1
    "Control bus"
    annotation (Placement(
      iconVisible=false,
      transformation(extent={{-20,-20},{20,20}}),
      iconTransformation(extent={{-250,-32},{-210,8}})));

  Actuators.Valve                                        modTwo(
    redeclare final package Medium = MediumLiq,
    typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    final energyDynamics=energyDynamics,
    dat(
      m_flow_nominal=1,
      dpValve_nominal=5000,
      dpFixed_nominal=5000)) "Two-way modulating valve"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Interfaces.Bus bus2
    "Control bus"
    annotation (Placement(
      iconVisible=false,
      transformation(extent={{-20,40},{20,80}}),
      iconTransformation(extent={{-250,-32},{-210,8}})));
  Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[0,0; 1,1],
    timeScale=10,
    period=200) "Damper control signal"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Actuators.Valve twoTwo(
    redeclare final package Medium = MediumLiq,
    typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    final energyDynamics=energyDynamics,
    dat(
      m_flow_nominal=1,
      dpValve_nominal=5000,
      dpFixed_nominal=5000)) "Two-way two-position valve"
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
  Interfaces.Bus bus3
    "Control bus"
    annotation (Placement(
      iconVisible=false,
      transformation(extent={{-20,-80},{20,-40}}),
      iconTransformation(extent={{-250,-32},{-210,8}})));
  Actuators.Valve non(
    redeclare final package Medium = MediumLiq,
    typ=Buildings.Templates.Components.Types.Valve.None)
    "No valve"
    annotation (Placement(transformation(extent={{10,-130},{30,-110}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=modTwo.m_flow_nominal,
    final dp_nominal=modTwo.dpValve_nominal + modTwo.dpFixed_nominal)
                                         "Flow resistance"
    annotation (Placement(transformation(extent={{-30,-130},{-10,-110}})));
equation
  connect(bouLiqEnt.ports[1], modThr.port_a)
    annotation (Line(points={{-70,78.2857},{-40,78.2857},{-40,100},{10,100}},
                                                  color={0,127,255}));
  connect(modThr.port_b,bouLiqLvg. ports[1])
    annotation (Line(points={{30,100},{60,100},{60,78.4},{90,78.4}},
                                                 color={0,127,255}));
  connect(y.y, bus.y) annotation (Line(points={{-68,120},{0,120}},
        color={0,0,127}));
  connect(bus, modThr.bus) annotation (Line(
      points={{0,120},{20,120},{20,110}},
      color={255,204,51},
      thickness=0.5));
  connect(bouLiqEnt.ports[3], twoThr.port_a) annotation (Line(points={{-70,
          79.4286},{-40,79.4286},{-40,-20},{10,-20}},
                                       color={0,127,255}));
  connect(twoThr.port_b, bouLiqLvg.ports[2]) annotation (Line(points={{30,-20},{
          60,-20},{60,79.2},{90,79.2}},
                                    color={0,127,255}));
  connect(bus1, twoThr.bus) annotation (Line(
      points={{0,0},{20,0},{20,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(bouLiqEnt.ports[2], modTwo.port_a) annotation (Line(points={{-70,
          78.8571},{-40,78.8571},{-40,40},{10,40}},
                                             color={0,127,255}));
  connect(modTwo.port_b, bouLiqLvg.ports[3]) annotation (Line(points={{30,40},{60,
          40},{60,80},{90,80}},     color={0,127,255}));
  connect(bus2, modTwo.bus) annotation (Line(
      points={{0,60},{20,60},{20,50}},
      color={255,204,51},
      thickness=0.5));
  connect(y.y, bus2.y)
    annotation (Line(points={{-68,120},{0,120},{0,60}},
                                                     color={0,0,127}));
  connect(y1.y[1], bus1.y1)
    annotation (Line(points={{-68,0},{0,0}},             color={255,0,255}));
  connect(bus3, twoTwo.bus) annotation (Line(
      points={{0,-60},{20,-60},{20,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(y1.y[1],bus3. y1)
    annotation (Line(points={{-68,0},{-20,0},{-20,-60},{0,-60}},
                                                         color={255,0,255}));
  connect(bouLiqEnt.ports[4], twoTwo.port_a) annotation (Line(points={{-70,80},{
          -40,80},{-40,-80},{10,-80}},                   color={0,127,255}));
  connect(twoTwo.port_b, bouLiqLvg.ports[4]) annotation (Line(points={{30,-80},{
          60,-80},{60,80.8},{90,80.8}},   color={0,127,255}));
  connect(bouLiqEnt.ports[5], modThr.portByp_a) annotation (Line(points={{-70,
          80.5714},{-36,80.5714},{-36,80},{20,80},{20,90}},
                                                  color={0,127,255}));
  connect(bouLiqEnt.ports[6], twoThr.portByp_a) annotation (Line(points={{-70,
          81.1429},{-40,81.1429},{-40,-40},{20,-40},{20,-30}}, color={0,127,255}));
  connect(non.port_b, bouLiqLvg.ports[5]) annotation (Line(points={{30,-120},{60,
          -120},{60,81.6},{90,81.6}}, color={0,127,255}));
  connect(bouLiqEnt.ports[7], res.port_a) annotation (Line(points={{-70,81.7143},
          {-70,80},{-40,80},{-40,-120},{-30,-120}}, color={0,127,255}));
  connect(res.port_b, non.port_a)
    annotation (Line(points={{-10,-120},{10,-120}}, color={0,127,255}));
annotation (
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/Valves.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=200),
  Diagram(coordinateSystem(extent={{-140,-140},{140,140}})),
    Documentation(info="<html>
<p>
This model validates the various configurations of the model
<a href=\"modelica://Buildings.Templates.Components.Actuators.Valve\">
Buildings.Templates.Components.Actuators.Valve</a>
by exposing this model to a fixed pressure difference
and a control signal varying from <i>0</i> to <i>1</i>.
</p>
</html>"));
end Valves;
