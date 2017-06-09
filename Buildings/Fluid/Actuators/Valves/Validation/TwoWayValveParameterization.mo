within Buildings.Fluid.Actuators.Valves.Validation;
model TwoWayValveParameterization
  "Model to test and illustrate different parameterization for valves"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Water;


  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.4
    "Design mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal = 4500
    "Design pressure drop";

  parameter Real Kv_SI = m_flow_nominal/sqrt(dp_nominal)
    "Flow coefficient for fully open valve in SI units, Kv=m_flow/sqrt(dp) [kg/s/(Pa)^(1/2)]";

  parameter Real Kv = Kv_SI/(rhoStd/3600/sqrt(1E5))
    "Kv (metric) flow coefficient [m3/h/(bar)^(1/2)]";
  parameter Real Cv = Kv_SI/(rhoStd*0.0631/1000/sqrt(6895))
    "Cv (US) flow coefficient [USG/min/(psi)^(1/2)]";
  parameter Modelica.SIunits.Area Av = Kv_SI/sqrt(rhoStd)
    "Av (metric) flow coefficient";

  parameter Modelica.SIunits.Density rhoStd=
   Medium.density_pTX(101325, 273.15+4, Medium.X_default)
   "Standard density";

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valOPPoi(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    dpValve_nominal(displayUnit="kPa") = dp_nominal,
    use_inputFilter=false) "Valve model, linear opening characteristics"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
    Modelica.Blocks.Sources.Ramp     y(duration=1)
                                            "Control signal"
                 annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Valves.TwoWayLinear valKv(
    redeclare package Medium = Medium,
    CvData=Buildings.Fluid.Types.CvTypes.Kv,
    m_flow_nominal=m_flow_nominal,
    Kv=Kv,
    use_inputFilter=false) "Valve model, linear opening characteristics"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Valves.TwoWayLinear valCv(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    CvData=Buildings.Fluid.Types.CvTypes.Cv,
    Cv=Cv,
    use_inputFilter=false) "Valve model, linear opening characteristics"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=4,
    p(displayUnit="Pa") = 300000 + 4500,
    T=293.15) "Boundary condition for flow source"  annotation (Placement(
        transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=4,
    use_p_in=false,
    p=300000,
    T=293.15) "Boundary condition for flow sink"    annotation (Placement(
        transformation(extent={{90,-10},{70,10}})));

  Buildings.Fluid.Sensors.MassFlowRate senM_flowOpPoi(
    redeclare package Medium = Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Fluid.Sensors.MassFlowRate senM_flowKv(
    redeclare package Medium = Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Fluid.Sensors.MassFlowRate senM_flowCv(
    redeclare package Medium = Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Valves.TwoWayLinear valAv(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    use_inputFilter=false,
    CvData=Buildings.Fluid.Types.CvTypes.Av,
    Av=Av) "Valve model, linear opening characteristics"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Fluid.Sensors.MassFlowRate senM_flowAv(redeclare package Medium =
        Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
equation
  connect(y.y, valOPPoi.y)
                         annotation (Line(
      points={{-39,70},{-20,70},{6.66134e-16,70},{6.66134e-16,52}},
      color={0,0,127}));
  connect(y.y, valKv.y)  annotation (Line(
      points={{-39,70},{-20,70},{-20,20},{6.66134e-16,20},{6.66134e-16,12}},
      color={0,0,127}));
  connect(valKv.port_a, sou.ports[2])  annotation (Line(
      points={{-10,6.10623e-16},{-30,6.10623e-16},{-30,1},{-50,1}},
      color={0,127,255}));
  connect(sou.ports[3], valCv.port_a) annotation (Line(
      points={{-50,-1},{-34,-1},{-34,-40},{-10,-40}},
      color={0,127,255}));
  connect(y.y, valCv.y) annotation (Line(
      points={{-39,70},{-20,70},{-20,-20},{6.66134e-16,-20},{6.66134e-16,-28}},
      color={0,0,127}));
  connect(sou.ports[1], valOPPoi.port_a) annotation (Line(
      points={{-50,3},{-40,3},{-40,40},{-10,40}},
      color={0,127,255}));
  connect(valOPPoi.port_b, senM_flowOpPoi.port_a) annotation (Line(
      points={{10,40},{20,40}},
      color={0,127,255}));
  connect(valKv.port_b, senM_flowKv.port_a) annotation (Line(
      points={{10,6.10623e-16},{12.5,6.10623e-16},{12.5,1.22125e-15},{15,
          1.22125e-15},{15,6.10623e-16},{20,6.10623e-16}},
      color={0,127,255}));
  connect(valCv.port_b, senM_flowCv.port_a) annotation (Line(
      points={{10,-40},{20,-40}},
      color={0,127,255}));
  connect(senM_flowCv.port_b, sin.ports[3]) annotation (Line(
      points={{40,-40},{56,-40},{56,-1},{70,-1}},
      color={0,127,255}));
  connect(senM_flowKv.port_b, sin.ports[2]) annotation (Line(
      points={{40,6.10623e-16},{50,6.10623e-16},{50,1},{70,1}},
      color={0,127,255}));
  connect(senM_flowOpPoi.port_b, sin.ports[1]) annotation (Line(
      points={{40,40},{60,40},{60,2},{66,2},{66,3},{70,3}},
      color={0,127,255}));
  connect(sou.ports[4], valAv.port_a) annotation (Line(points={{-50,-3},{-40,-3},
          {-40,-80},{-10,-80}}, color={0,127,255}));
  connect(valAv.port_b, senM_flowAv.port_a)
    annotation (Line(points={{10,-80},{20,-80}}, color={0,127,255}));
  connect(senM_flowAv.port_b, sin.ports[4]) annotation (Line(points={{40,-80},{
          60,-80},{60,-3},{70,-3}}, color={0,127,255}));
  connect(valAv.y, y.y) annotation (Line(points={{0,-68},{0,-60},{-20,-60},{-20,
          70},{-39,70}}, color={0,0,127}));
    annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Valves/Validation/TwoWayValveParameterization.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Test model for two way valves. This model tests the
different parameterization of the valve model.
All valves have the same mass flow rates.
</p>
</html>", revisions="<html>
<ul>
<li>
June 7, 2017, by Michael Wetter:<br/>
Removed assertion blocks, exposed common parameters,
and added a valve that uses <code>Av</code> as the parameter.
</li>
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
end TwoWayValveParameterization;
