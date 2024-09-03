within Buildings.Fluid.FMI.Conversion.Validation;
model InletToAirMoistAir
  "Validation model for inlet to Buildings.Media.Air conversion without trace substances"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Air
     constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model";
  parameter Boolean use_p_in = false
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  Modelica.Blocks.Sources.Constant m_flow(k=0.2) "Mass flow rate"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.Constant T(k=295.13) "Room temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Fluid.FMI.Conversion.InletToAir conAir(
    redeclare package Medium = Medium, allowFlowReversal=false)
                                       "Converter for air"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Source_T sou(
    redeclare package Medium = Medium,
    use_p_in=use_p_in,
    allowFlowReversal=false)
    "Source for mass flow rate and pressure"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.Constant pIn(k=100000) "Inlet pressure"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Constant X_w_in(k=0.01) "Inlet mass fraction"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Constant C[Medium.nC](each k=0.01)
  if Medium.nC > 0 "Trace substances for forward flow"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Fluid.FMI.Conversion.InletToAir conAirRevFlo(redeclare package
      Medium = Medium, allowFlowReversal=true)
    "Converter for air with reverse flow"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Source_T souRev(
    redeclare package Medium = Medium,
    use_p_in=use_p_in,
    allowFlowReversal=true)
    "Source for mass flow rate and pressure with reverse flow"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Sources.Constant TRev(k=283.15)
    "Temperature for reverse flow"
    annotation (Placement(transformation(extent={{90,0},{70,20}})));
  Modelica.Blocks.Sources.Constant X_w(k=0.012)
    "Mass flow fraction for reverse flow"
    annotation (Placement(transformation(extent={{90,-40},{70,-20}})));
equation
  connect(m_flow.y, sou.m_flow_in) annotation (Line(points={{-59,80},{-40,80},{-40,
          40},{-22,40}}, color={0,0,127}));
  connect(sou.outlet, conAir.inlet)
    annotation (Line(points={{1,30},{1,30},{19,30}},  color={0,0,255}));
  connect(sou.T_in, T.y) annotation (Line(points={{-22,30},{-50,30},{-50,0},{-59,
          0}},  color={0,0,127}));
  connect(pIn.y, sou.p_in) annotation (Line(points={{-59,40},{-50,40},{-50,34.8},
          {-22,34.8}}, color={0,0,127}));
  connect(X_w_in.y, sou.X_w_in) annotation (Line(points={{-59,-40},{-40,-40},{-40,
          25},{-22,25}},
                       color={0,0,127}));
  connect(C.y, sou.C_in) annotation (Line(points={{-59,-80},{-44,-80},{-28,-80},
          {-28,20},{-22,20}},
                            color={0,0,127}));
  connect(m_flow.y, souRev.m_flow_in) annotation (Line(points={{-59,80},{-40,80},
          {-40,-20},{-22,-20}}, color={0,0,127}));
  connect(souRev.outlet, conAirRevFlo.inlet)
    annotation (Line(points={{1,-30},{1,-30},{19,-30}}, color={0,0,255}));
  connect(souRev.T_in, T.y) annotation (Line(points={{-22,-30},{-50,-30},{-50,0},
          {-59,0}}, color={0,0,127}));
  connect(pIn.y, souRev.p_in) annotation (Line(points={{-59,40},{-50,40},{-50,-25.2},
          {-22,-25.2}}, color={0,0,127}));
  connect(X_w_in.y, souRev.X_w_in) annotation (Line(points={{-59,-40},{-40,-40},
          {-40,-35},{-22,-35}}, color={0,0,127}));
  connect(C.y, souRev.C_in) annotation (Line(points={{-59,-80},{-59,-80},{-28,-80},
          {-28,-40},{-22,-40}}, color={0,0,127}));
  connect(TRev.y, conAirRevFlo.TAirZon) annotation (Line(points={{69,10},{60,10},
          {60,-56},{24,-56},{24,-42}}, color={0,0,127}));
  connect(X_w.y, conAirRevFlo.X_wZon) annotation (Line(points={{69,-30},{64,-30},
          {64,-52},{30,-52},{30,-42}}, color={0,0,127}));
annotation (
    Documentation(info="<html>
<p>
This example validates the conversion model
<a href=\"modelica://Buildings.Fluid.FMI.Conversion.InletToAir\">
Buildings.Fluid.FMI.Conversion.InletToAir
</a>.
The medium used is
<a href=\"modelica://Buildings.Media.Air\">
Buildings.Media.Air
</a>
without trace substances.
The top model has no reverse flow, whereas the
bottom model has reverse flow.
</p>
</html>", revisions="<html>
<ul>
<li>
June 29, 2016, by Michael Wetter:<br/>
Added validation test for reverse flow.
</li>
<li>
April 28, 2016 by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Conversion/Validation/InletToAirMoistAir.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=1.0));
end InletToAirMoistAir;
