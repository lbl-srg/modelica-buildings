within Buildings.Fluid.Actuators.Examples;
model ValveParameterization
  "Model to test and illustrate different parameterization for valves"
  extends Modelica.Icons.Example;
  import Buildings;

 package Medium = Buildings.Media.ConstantPropertyLiquidWater;

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valOPPoi(
    redeclare package Medium = Medium,
    m_flow_nominal=150/3600,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    dp_nominal(displayUnit="kPa") = 4500)
    "Valve model, linear opening characteristics"
         annotation (Placement(transformation(extent={{-10,30},{10,50}},
                                                                       rotation=
           0)));
    Modelica.Blocks.Sources.Constant y(k=1) "Control signal"
                 annotation (Placement(transformation(extent={{-60,60},{-40,80}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      = Medium,
    use_p_in=true,
    nPorts=4,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{-70,-10},{-50,10}},rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    nPorts=4,
    use_p_in=false,
    p=300000,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{80,-10},{60,10}},rotation=0)));
    Modelica.Blocks.Sources.Ramp PSou(
    duration=1,
    offset=3E5,
    height=1E5)
      annotation (Placement(transformation(extent={{-100,16},{-80,36}},
          rotation=0)));
  Valves.TwoWayLinear valKv(
    redeclare package Medium = Medium,
    CvData=Buildings.Fluid.Types.CvTypes.Kv,
    m_flow_nominal=150/3600,
    Kv=0.73,
    dp_nominal=450000) "Valve model, linear opening characteristics"
         annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                                                                       rotation=
           0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Valves.TwoWayLinear valCv(
    redeclare package Medium = Medium,
    m_flow_nominal=150/3600,
    CvData=Buildings.Fluid.Types.CvTypes.Cv,
    Cv=0.84,
    dp_nominal=450000) "Valve model, linear opening characteristics"
         annotation (Placement(transformation(extent={{-10,-50},{10,-30}},
                                                                       rotation=
           0)));
  Buildings.Fluid.Sensors.MassFlowRate senM_flowOpPoi(redeclare package Medium
      = Medium) annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Fluid.Sensors.MassFlowRate senM_flowKv(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Fluid.Sensors.MassFlowRate senM_flowCv(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Modelica.Fluid.Valves.ValveIncompressible valFlu(
    redeclare package Medium = Medium,
    dp_nominal(displayUnit="Pa") = 4500,
    m_flow_nominal=0.0416,
    CvData=Modelica.Fluid.Types.CvTypes.Cv,
    Cv=0.84) "Valve model, linear opening characteristics"
         annotation (Placement(transformation(extent={{-10,-90},{10,-70}},
                                                                       rotation=
           0)));
  Buildings.Fluid.Sensors.MassFlowRate senM_flowFlu(
                                                  redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Utilities.Diagnostics.AssertEquality equ1(threShold=0.01)
    annotation (Placement(transformation(extent={{70,60},{90,80}})));
  Buildings.Utilities.Diagnostics.AssertEquality equ2(threShold=0.01)
    annotation (Placement(transformation(extent={{72,-40},{92,-20}})));
equation
  connect(y.y, valOPPoi.y)
                         annotation (Line(
      points={{-39,70},{-20,70},{-20,54},{6.66134e-16,54},{6.66134e-16,48}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(PSou.y, sou.p_in)
    annotation (Line(points={{-79,26},{-74.5,26},{-74.5,8},{-72,8}},
                                                 color={0,0,127}));
  connect(y.y, valKv.y)  annotation (Line(
      points={{-39,70},{-20,70},{-20,14},{6.66134e-16,14},{6.66134e-16,8}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(valKv.port_a, sou.ports[2])  annotation (Line(
      points={{-10,6.10623e-16},{-30,6.10623e-16},{-30,1},{-50,1}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[3], valCv.port_a) annotation (Line(
      points={{-50,-1},{-40,-1},{-40,-40},{-10,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(y.y, valCv.y) annotation (Line(
      points={{-39,70},{-20,70},{-20,-26},{6.66134e-16,-26},{6.66134e-16,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], valOPPoi.port_a) annotation (Line(
      points={{-50,3},{-40,3},{-40,40},{-10,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valOPPoi.port_b, senM_flowOpPoi.port_a) annotation (Line(
      points={{10,40},{20,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valKv.port_b, senM_flowKv.port_a) annotation (Line(
      points={{10,6.10623e-16},{12.5,6.10623e-16},{12.5,1.22125e-15},{15,
          1.22125e-15},{15,6.10623e-16},{20,6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valCv.port_b, senM_flowCv.port_a) annotation (Line(
      points={{10,-40},{20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senM_flowCv.port_b, sin.ports[3]) annotation (Line(
      points={{40,-40},{50,-40},{50,-1},{60,-1}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senM_flowKv.port_b, sin.ports[2]) annotation (Line(
      points={{40,6.10623e-16},{50,6.10623e-16},{50,1},{60,1}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senM_flowOpPoi.port_b, sin.ports[1]) annotation (Line(
      points={{40,40},{50,40},{50,3},{60,3}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valFlu.port_b, senM_flowFlu.port_a)
                                            annotation (Line(
      points={{10,-80},{20,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[4],valFlu. port_a) annotation (Line(
      points={{-50,-3},{-44,-3},{-44,-80},{-10,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senM_flowFlu.port_b, sin.ports[4]) annotation (Line(
      points={{40,-80},{50,-80},{50,-3},{60,-3}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(y.y,valFlu. opening) annotation (Line(
      points={{-39,70},{-20,70},{-20,-68},{6.66134e-16,-68},{6.66134e-16,-72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senM_flowOpPoi.m_flow, equ1.u1) annotation (Line(
      points={{30,51},{30,76},{68,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senM_flowKv.m_flow, equ1.u2) annotation (Line(
      points={{30,11},{30,20},{60,20},{60,64},{68,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senM_flowCv.m_flow, equ2.u1) annotation (Line(
      points={{30,-29},{30,-24},{70,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senM_flowFlu.m_flow, equ2.u2) annotation (Line(
      points={{30,-69},{30,-60},{60,-60},{60,-36},{70,-36}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                        graphics),
             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Examples/ValveParameterization.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
Test model for two way valves. This model tests the
different parameterization of the valve model.
The top and bottom two valves need to have the same flow rates.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ValveParameterization;
