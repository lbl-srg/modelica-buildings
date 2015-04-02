within Buildings.Fluid.Actuators.Dampers.Examples;
model MixingBox
  "Mixing box with constant pressure difference and varying control signal"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Air
    "Medium in the component"
         annotation (choicesAllMatching = true);

  Dampers.MixingBox mixBox(
    AOut=0.7,
    AExh=1,
    ARec=1,
    mOut_flow_nominal=1,
    dpOut_nominal=20,
    mRec_flow_nominal=1,
    dpRec_nominal=20,
    mExh_flow_nominal=1,
    dpExh_nominal=20,
    redeclare package Medium = Medium) "mixing box"
                            annotation (Placement(transformation(extent={{14,
            -22},{34,-2}})));
    Buildings.Fluid.Sources.Boundary_pT bouIn(             redeclare package
      Medium = Medium, T=273.15 + 10,
    use_p_in=true,
    nPorts=2)                                             annotation (Placement(
        transformation(extent={{-60,2},{-40,22}})));
    Buildings.Fluid.Sources.Boundary_pT bouSup(             redeclare package
      Medium = Medium, T=273.15 + 26,
    use_p_in=true,
    nPorts=1)                                                                       annotation (Placement(
        transformation(extent={{68,-10},{48,10}})));
    Buildings.Fluid.Sources.Boundary_pT bouRet(             redeclare package
      Medium = Medium, T=273.15 + 20,
    use_p_in=true,
    nPorts=1)                                                         annotation (Placement(
        transformation(extent={{68,-90},{48,-70}})));
    Modelica.Blocks.Sources.Constant PAtm(k=101325)
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    Modelica.Blocks.Sources.Ramp PSup(
    offset=101320,
    height=-10,
    startTime=0,
    duration=20) annotation (Placement(transformation(extent={{60,40},{80,60}})));
    Modelica.Blocks.Sources.Ramp PRet(
    height=10,
    offset=101330,
    duration=20,
    startTime=20)
                 annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
    Modelica.Blocks.Sources.Step yDam(
    height=1,
    offset=0,
    startTime=60)
                 annotation (Placement(transformation(extent={{-40,40},{-20,60}})));


equation
  connect(yDam.y, mixBox.y) annotation (Line(points={{-19,50},{24,50},{24,
          6.66134e-16}},
                   color={0,0,127}));
  connect(bouIn.p_in, PAtm.y) annotation (Line(points={{-62,20},{-72,20},{-79,
          20}},          color={0,0,127}));
  connect(PRet.y, bouRet.p_in) annotation (Line(points={{81,-40},{90,-40},{90,
          -72},{70,-72}}, color={0,0,127}));
  connect(bouSup.p_in, PSup.y) annotation (Line(points={{70,8},{92,8},{92,50},{
          81,50}}, color={0,0,127}));
  connect(bouIn.ports[1], mixBox.port_Out) annotation (Line(
      points={{-40,14},{-16,14},{-16,-6},{14,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouIn.ports[2], mixBox.port_Exh) annotation (Line(
      points={{-40,10},{-18,10},{-18,-18},{14,-18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouSup.ports[1], mixBox.port_Sup) annotation (Line(
      points={{48,6.66134e-16},{42,6.66134e-16},{42,-6},{34,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouRet.ports[1], mixBox.port_Ret) annotation (Line(
      points={{48,-80},{42,-80},{42,-18},{34,-18}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Dampers/Examples/MixingBox.mos"
        "Simulate and plot"),
    experiment(StopTime=240),
Documentation(info="<html>
<p>
Test model for the economizer mixing box.
The economizer mixing box is exposed to time varying pressure boundary
conditions and input signals.
</p>
</html>", revisions="<html>
<ul>
<li>
February 23, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MixingBox;
