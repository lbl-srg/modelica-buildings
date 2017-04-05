within Buildings.Fluid.FMI.Conversion.Validation;
model AirToOutlet "Validation model for air to outlet conversion"
  extends Modelica.Icons.Example;

  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Evaluate=true);

  Modelica.Blocks.Sources.Constant m_flow(k=0.2) "Mass flow rate"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Constant h(k=3E5) "Specific enthalpy"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant Xi[1](k={0.01}) "Water vapor concentration"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Constant C[1](k={1E-5}) "Trace substances"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Buildings.Fluid.FMI.Conversion.AirToOutlet conAirNoC(
    redeclare package Medium = Buildings.Media.Air,
    final allowFlowReversal=allowFlowReversal)
    "Converter for air without trace substances"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  Buildings.Fluid.FMI.Conversion.AirToOutlet conAirWithC(
    redeclare package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"}),
    final allowFlowReversal=allowFlowReversal)
    "Converter for air with trace substances"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Fluid.FMI.Conversion.AirToOutlet conDryAirNoC(
    redeclare package Medium = Modelica.Media.Air.SimpleAir,
    final allowFlowReversal=allowFlowReversal)
    "Converter for dry air without trace substances"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Fluid.FMI.Conversion.AirToOutlet conDryAirWithC(
    redeclare package Medium = Modelica.Media.Air.SimpleAir(extraPropertiesNames={"CO2"}),
    final allowFlowReversal=allowFlowReversal)
    "Converter for dry air with trace substances"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
equation
  connect(m_flow.y, conAirNoC.m_flow) annotation (Line(points={{-39,70},{-26,70},
          {-26,68},{-2,68}}, color={0,0,127}));
  connect(h.y, conAirNoC.h) annotation (Line(points={{-39,30},{-26.5,30},{-26.5,
          64},{-2,64}}, color={0,0,127}));
  connect(Xi.y, conAirNoC.Xi) annotation (Line(points={{-39,-10},{-20,-10},{-20,
          56},{-2,56}}, color={0,0,127}));
  connect(m_flow.y, conAirWithC.m_flow) annotation (Line(points={{-39,70},{-26,70},
          {-26,28},{-2,28}}, color={0,0,127}));
  connect(h.y, conAirWithC.h) annotation (Line(points={{-39,30},{-26.5,30},{-26.5,
          24},{-2,24}}, color={0,0,127}));
  connect(Xi.y, conAirWithC.Xi) annotation (Line(points={{-39,-10},{-20,-10},{-20,
          16},{-2,16}}, color={0,0,127}));
  connect(m_flow.y, conDryAirNoC.m_flow) annotation (Line(points={{-39,70},{-26,
          70},{-26,-22},{-2,-22}}, color={0,0,127}));
  connect(h.y, conDryAirNoC.h) annotation (Line(points={{-39,30},{-26.5,30},{-26.5,
          -26},{-2,-26}}, color={0,0,127}));
  connect(m_flow.y, conDryAirWithC.m_flow) annotation (Line(points={{-39,70},{-26,
          70},{-26,-62},{-2,-62}}, color={0,0,127}));
  connect(h.y, conDryAirWithC.h) annotation (Line(points={{-39,30},{-26.5,30},{-26.5,
          -66},{-2,-66}}, color={0,0,127}));
  connect(C.y, conAirWithC.C) annotation (Line(points={{-39,-50},{-14,-50},{-14,
          12},{-2,12}}, color={0,0,127}));
  connect(C.y, conDryAirWithC.C) annotation (Line(points={{-39,-50},{-14,-50},{
          -14,-78},{-2,-78}}, color={0,0,127}));
annotation (
    Documentation(info="<html>
<p>
This example validates the conversion model
<a href=\"modelica://Buildings.Fluid.FMI.Conversion.AirToOutlet\">
Buildings.Fluid.FMI.Conversion.AirToOutlet</a>
for the situation without reverse flow.
</p>
<p>
The conversion elements all have either a dry or
moist air medium, with our without trace substances,
in order to test all combinations of air.
</p>
</html>", revisions="<html>
<ul>
<li>
April 20, 2016 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Conversion/Validation/AirToOutlet.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=1.0));
end AirToOutlet;
