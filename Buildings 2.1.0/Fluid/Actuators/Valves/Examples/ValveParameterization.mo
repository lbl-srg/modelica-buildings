within Buildings.Fluid.Actuators.Valves.Examples;
model ValveParameterization
  "Model to test and illustrate different parameterization for valves"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Water;

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valOPPoi(
    redeclare package Medium = Medium,
    m_flow_nominal=150/3600,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    dpValve_nominal(displayUnit="kPa") = 4500,
    filteredOpening=false) "Valve model, linear opening characteristics"
         annotation (Placement(transformation(extent={{-10,30},{10,50}})));
    Modelica.Blocks.Sources.Constant y(k=1) "Control signal"
                 annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      = Medium,
    use_p_in=true,
    nPorts=3,
    T=293.15) "Boundary condition for flow source"  annotation (Placement(
        transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    nPorts=3,
    use_p_in=false,
    p=300000,
    T=293.15) "Boundary condition for flow sink"    annotation (Placement(
        transformation(extent={{90,-10},{70,10}})));
    Modelica.Blocks.Sources.Ramp PSou(
    duration=1,
    offset=3E5,
    height=1E5)
      annotation (Placement(transformation(extent={{-100,16},{-80,36}})));
  Valves.TwoWayLinear valKv(
    redeclare package Medium = Medium,
    CvData=Buildings.Fluid.Types.CvTypes.Kv,
    m_flow_nominal=150/3600,
    Kv=0.73,
    filteredOpening=false) "Valve model, linear opening characteristics"
         annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Valves.TwoWayLinear valCv(
    redeclare package Medium = Medium,
    m_flow_nominal=150/3600,
    CvData=Buildings.Fluid.Types.CvTypes.Cv,
    Cv=0.84,
    filteredOpening=false) "Valve model, linear opening characteristics"
         annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Fluid.Sensors.MassFlowRate senM_flowOpPoi(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Fluid.Sensors.MassFlowRate senM_flowKv(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Fluid.Sensors.MassFlowRate senM_flowCv(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Utilities.Diagnostics.AssertEquality equ1(threShold=0.01)
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Utilities.Diagnostics.AssertEquality equ2(threShold=0.01)
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
equation
  connect(y.y, valOPPoi.y)
                         annotation (Line(
      points={{-39,70},{-20,70},{6.66134e-16,70},{6.66134e-16,52}},
      color={0,0,127}));
  connect(PSou.y, sou.p_in)
    annotation (Line(points={{-79,26},{-74.5,26},{-74.5,8},{-72,8}},
                                                 color={0,0,127}));
  connect(y.y, valKv.y)  annotation (Line(
      points={{-39,70},{-20,70},{-20,20},{6.66134e-16,20},{6.66134e-16,12}},
      color={0,0,127}));
  connect(valKv.port_a, sou.ports[2])  annotation (Line(
      points={{-10,6.10623e-16},{-30,6.10623e-16},{-30,5.55112e-16},{-50,5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[3], valCv.port_a) annotation (Line(
      points={{-50,-2.66667},{-40,-2.66667},{-40,-40},{-10,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(y.y, valCv.y) annotation (Line(
      points={{-39,70},{-20,70},{-20,-20},{6.66134e-16,-20},{6.66134e-16,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], valOPPoi.port_a) annotation (Line(
      points={{-50,2.66667},{-40,2.66667},{-40,40},{-10,40}},
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
      points={{40,-40},{60,-40},{60,-2.66667},{70,-2.66667}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senM_flowKv.port_b, sin.ports[2]) annotation (Line(
      points={{40,6.10623e-16},{50,6.10623e-16},{50,4.44089e-16},{70,4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senM_flowOpPoi.port_b, sin.ports[1]) annotation (Line(
      points={{40,40},{60,40},{60,2},{66,2},{66,2.66667},{70,2.66667}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senM_flowOpPoi.m_flow, equ1.u1) annotation (Line(
      points={{30,51},{30,76},{78,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senM_flowKv.m_flow, equ1.u2) annotation (Line(
      points={{30,11},{30,20},{46,20},{46,64},{78,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senM_flowKv.m_flow, equ2.u1) annotation (Line(
      points={{30,11},{30,20},{46,20},{46,36},{78,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senM_flowCv.m_flow, equ2.u2) annotation (Line(
      points={{30,-29},{30,-20},{50,-20},{50,24},{78,24}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Valves/Examples/ValveParameterization.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Test model for two way valves. This model tests the
different parameterization of the valve model.
All valves have approximately the same mass flow rates.
Small differences exist due to differences in the mass density that is used
to compute the parameters.
If the mass flow rates differ by more than 1%, then the assert blocks
will terminate the simulation with an error message.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2013, by Michael Wetter:<br/>
Removed the valve from <code>Modelica.Fluid</code> to allow a successful check
of the model in the pedantic mode in Dymola 2014.
</li>
<li>
March 1, 2013, by Michael Wetter:<br/>
Removed assignment of <code>dpValve_nominal</code> if
<code>CvData &lt;&gt; Buildings.Fluid.Types.CvTypes.OpPoint</code>,
as in this case, it is computed by the model.
</li>
<li>
February 18, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ValveParameterization;
