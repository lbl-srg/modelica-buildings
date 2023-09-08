within Buildings.Fluid.CHPs.OrganicRankine;
model BottomingCycle
  "Organic Rankine cycle with heat exchangers as a bottoming cycle"

  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;

  parameter Buildings.Fluid.CHPs.OrganicRankine.Data.Generic pro
    "Property records of the working fluid"
    annotation(choicesAllMatching = true);

  // Input properties
  parameter Modelica.Units.SI.Temperature TEva
    "Evaporator temperature";
  parameter Modelica.Units.SI.Temperature TCon
    "Condenser temperature";
  parameter Modelica.Units.SI.TemperatureDifference dTSup = 0
    "Superheating differential temperature ";
  parameter Real etaExp "Expander efficiency";

  parameter Modelica.Units.SI.ThermalConductance UA
    "Thermal conductance of heat exchanger";

  Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.BottomingCycle ORC(
    final pro=pro,
    final TEva=TEva,
    final TCon=TCon,
    final dTSup=dTSup,
    final etaExp=etaExp)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.HeaterCooler_Q con(
    redeclare final package Medium = Medium2,
    allowFlowReversal=false,
    final m_flow_nominal=m2_flow_nominal,
    final from_dp=false,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Condenser"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.EvaporatorLimited eva(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    dp_nominal=0,
    final TWorFlu=TEva,
    final UA=UA) "Evaporator"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    min=0,
    final quantity="Power",
    final unit="W") "Power output of the expander"
                                   annotation (Placement(transformation(extent={{100,20},
            {120,40}}),            iconTransformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Interfaces.RealOutput etaThe(min=0, final unit="1")
                    "Thermal efficiency"
    annotation (Placement(
        transformation(extent={{100,-10},{120,10}}),  iconTransformation(extent={{100,-40},
            {120,-20}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(final quantity="Power",
      final unit="W") "Heat rejected through condensation"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-110},{120,-90}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(final quantity="Power",
      final unit="W") "Heat added through evaporation" annotation (Placement(
        transformation(extent={{100,82},{120,102}}), iconTransformation(extent=
            {{100,90},{120,110}})));
equation
  connect(con.port_a, port_a2)
    annotation (Line(points={{10,-60},{100,-60}}, color={0,127,255}));
  connect(con.port_b, port_b2)
    annotation (Line(points={{-10,-60},{-100,-60}}, color={0,127,255}));
  connect(ORC.QCon_flow, con.Q_flow) annotation (Line(points={{11,-6},{20,-6},{20,
          -54},{12,-54}}, color={0,0,127}));
  connect(eva.Q_flow, ORC.QEva_flow) annotation (Line(points={{11,54},{20,54},{
          20,30},{-20,30},{-20,6},{-12,6}},
                                         color={0,0,127}));
  connect(eva.port_b, port_b1)
    annotation (Line(points={{10,60},{100,60}}, color={0,127,255}));
  connect(eva.port_a, port_a1)
    annotation (Line(points={{-10,60},{-100,60}}, color={0,127,255}));
  connect(ORC.P, P) annotation (Line(points={{11,6},{80,6},{80,30},{110,30}},
        color={0,0,127}));
  connect(ORC.etaThe, etaThe)
    annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  connect(ORC.QCon_flow, QCon_flow) annotation (Line(points={{11,-6},{20,-6},{
          20,-90},{110,-90}}, color={0,0,127}));
  connect(eva.Q_flow, QEva_flow) annotation (Line(points={{11,54},{20,54},{20,
          92},{110,92}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end BottomingCycle;
