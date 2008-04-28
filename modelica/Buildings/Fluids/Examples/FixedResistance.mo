model FixedResistance 
  
    annotation (Diagram, Commands(file=
            "FixedResistance.mos" "run"));
 package Medium = 
        Modelica.Media.Water.ConstantPropertyLiquidWater;
    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (extent=[42,36; 62,56]);
    Modelica.Blocks.Sources.Ramp P(
      duration=1,
    height=20,
    offset=101315) 
                 annotation (extent=[-80,30; -60,50]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = Medium,
    from_dp=true,
    m0_flow=5,
    dp0=10)  annotation (extent=[-2,-4; 18,16]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou(redeclare package Medium = 
        Medium, T=293.15) annotation (extent=[-42,-4; -22,16]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin(redeclare package Medium = 
        Medium, T=283.15) annotation (extent=[60,-4; 40,16], rotation=0);
equation 
  connect(P.y, sou.p_in) annotation (points=[-59,40; -52,40; -52,12; -44,12],
      style(color=74, rgbcolor={0,0,127}));
  connect(PAtm.y, sin.p_in) annotation (points=[63,46; 70,46; 70,12; 62,12],
      style(color=74, rgbcolor={0,0,127}));
  connect(sou.port, res.port_a) annotation (points=[-22,6; -17,6; -17,6; -12,6;
        -12,6; -2,6], style(color=69, rgbcolor={0,127,255}));
  connect(sin.port, res.port_b) annotation (points=[40,6; 34.5,6; 34.5,6; 29,6;
        29,6; 18,6], style(color=69, rgbcolor={0,127,255}));
end FixedResistance;
