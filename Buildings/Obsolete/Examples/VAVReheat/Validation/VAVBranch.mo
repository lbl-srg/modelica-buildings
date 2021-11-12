within Buildings.Obsolete.Examples.VAVReheat.Validation;
model VAVBranch "Validation for the VAVBranch class"
  extends Modelica.Icons.Example;

  package MediumA = Buildings.Media.Air "Medium model for air";
  package MediumW = Buildings.Media.Water "Medium model for water";

  Buildings.Obsolete.Examples.VAVReheat.BaseClasses.VAVBranch vavBra(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    terHea(show_T=true),
    m_flow_nominal=45,
    VRoo=275) annotation (Placement(transformation(extent={{20,-20},{60,20}})));

  Buildings.Fluid.Sources.Boundary_ph sinAir(
    redeclare package Medium = MediumA,
    p(displayUnit="Pa") = 1E5,
    nPorts=1) "Sink for terminal reheat box outlet air" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={40,70})));
  Modelica.Blocks.Sources.Ramp TSupAir(
    y(final unit="K", displayUnit="degC"),
    height=5,
    duration(displayUnit="h") = 3600,
    offset=285,
    startTime(displayUnit="h") = 3600) "Supply Air Temperature"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Blocks.Sources.Ramp heaSig(
    height=1,
    duration(displayUnit="h") = 3600,
    offset=0,
    startTime(displayUnit="h") = 10800) "Signal to reheat coil valve"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Ramp damSig(
    height=0.4,
    duration(displayUnit="h") = 3600,
    offset=0.2,
    startTime(displayUnit="h") = 18000) "Signal to VAV Box Damper"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = MediumA,
    p(displayUnit="Pa") = 1E5 + 1500,
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(vavBra.port_b, sinAir.ports[1])
    annotation (Line(points={{30,20},{30,60},{40,60}}, color={0,127,255}));
  connect(heaSig.y, vavBra.yVal) annotation (Line(points={{-39,-10},{-20,-10},{
          -20,-8},{16,-8}},
                          color={0,0,127}));
  connect(damSig.y, vavBra.yVAV) annotation (Line(points={{-39,50},{-20,50},{
          -20,8},{16,8}},
                        color={0,0,127}));
  connect(bou.ports[1], vavBra.port_a)
    annotation (Line(points={{10,-60},{30,-60},{30,-20}}, color={0,127,255}));
  connect(TSupAir.y, bou.T_in) annotation (Line(points={{-39,-70},{-24,-70},{-24,
          -56},{-12,-56}},      color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{120,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            120,100}})),
    experiment(
      StopTime=25200,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model validates the obsolete model
<a href=\"modelica://Buildings.Obsolete.Examples.VAVReheat.BaseClasses.VAVBranch\">
Buildings.Obsolete.Examples.VAVReheat.BaseClasses.VAVBranch</a>.
</p>
</html>",
      revisions="<html>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Examples/VAVReheat/Validation/VAVBranch.mos"
        "Simulate and plot"));
end VAVBranch;
