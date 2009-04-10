within Buildings.Fluids.FixedResistances.Examples;
model FixedResistancesSeries "Test of multiple resistances in series"

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics),
                       Commands(file=
          "FixedResistancesSeries.mos" "run"));
 package Medium = Modelica.Media.Air.SimpleAir;
  annotation (
    Diagram(Text(
        extent=[-20,58; 30,44],
        style(color=3, rgbcolor={0,0,255}),
        string="nRes resistances  in series")),
    experiment(
      Interval=0.0001,
      fixedstepsize=0.0001,
      Algorithm="Euler"),
    experimentSetupOutput);

    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (Placement(transformation(extent={{40,60},{60,80}}, rotation=0)));
   parameter Modelica.SIunits.Pressure dp_nominal = 5
    "Nominal pressure drop for each resistance";
    Modelica.Blocks.Sources.Ramp P(
      duration=1,
    height=2*dp_nominal*nRes,
    offset=101325 - dp_nominal*nRes) 
                 annotation (Placement(transformation(extent={{-80,60},{-60,80}},
          rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      =        Medium, T=273.15 + 20,
    use_p_in=true,
    nPorts=1)                         annotation (Placement(transformation(
          extent={{-40,20},{-20,40}}, rotation=0)));
  Modelica_Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      =        Medium, T=273.15 + 10,
    use_p_in=true,
    nPorts=1)                         annotation (Placement(transformation(
          extent={{56,20},{36,40}}, rotation=0)));
  parameter Integer nRes( min=2) = 3 "Number of resistances";
    Buildings.Fluids.FixedResistances.FixedResistanceDpM[
                       nRes] res(
    redeclare each package Medium = Medium,
    each dp_nominal=dp_nominal,
    each from_dp = false,
    each m_flow_nominal=2) 
             annotation (Placement(transformation(extent={{0,20},{20,40}},
          rotation=0)));
  inner Modelica_Fluid.System system(p_ambient=101325) 
                                   annotation (Placement(transformation(extent={{-80,-80},
            {-60,-60}},        rotation=0)));
equation
  for i in 1:nRes-1 loop
  connect(res[i].port_b, res[i+1].port_a) annotation (Line(points={{20,30},{26,
            30},{26,10},{-8,10},{-8,30},{0,30}},             color={0,127,255}));
  end for;
  connect(PAtm.y, sin.p_in) annotation (Line(points={{61,70},{70,70},{70,38},{
          58,38}}, color={0,0,127}));
  connect(P.y, sou.p_in) annotation (Line(points={{-59,70},{-52,70},{-52,38},{
          -42,38}}, color={0,0,127}));
  connect(sin.ports[1], res[nRes].port_b) annotation (Line(
      points={{36,30},{20,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[1], res[1].port_a) annotation (Line(
      points={{-20,30},{0,30}},
      color={0,127,255},
      smooth=Smooth.None));
end FixedResistancesSeries;
