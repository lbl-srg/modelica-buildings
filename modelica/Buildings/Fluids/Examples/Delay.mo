model Delay 
  
    annotation (Diagram, Commands(file=
            "Delay.mos" "run"));
 package Medium = Buildings.Media.ConstantPropertyLiquidWater;
// package Medium = Modelica.Media.Air.SimpleAir;
  
// The package Buildings.Media.ConstantPropertyLiquidWater won't work 
// because it does not provide an implementation of the density function.
// package Medium = Buildings.Media.ConstantPropertyLiquidWater;
  
    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (extent=[62,36; 82,56]);
    Modelica.Blocks.Sources.Ramp P(
      duration=1,
    height=20,
    offset=101315) 
                 annotation (extent=[-94,30; -74,50]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res1(
    from_dp=true,
    m0_flow=5,
    dp0=5,
    redeclare package Medium = Medium) 
             annotation (extent=[-30,-4; -10,16]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou(
                T=293.15, redeclare package Medium = Medium) 
                          annotation (extent=[-58,-4; -38,16]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin(
                T=283.15, redeclare package Medium = Medium) 
                          annotation (extent=[78,-4; 58,16], rotation=0);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res2(
    from_dp=true,
    m0_flow=5,
    dp0=5,
    redeclare package Medium = Medium) 
             annotation (extent=[26,-4; 46,16]);
  Buildings.Fluids.Delays.DelayFirstOrder del(         m0_flow=5, redeclare 
      package Medium = Medium,
    T_start=283.15,
    initType=Modelica_Fluid.Types.Init.InitialValues) 
    annotation (extent=[-2,-4; 18,16]);
equation 
  connect(P.y, sou.p_in) annotation (points=[-73,40; -66,40; -66,12; -60,12],
      style(color=74, rgbcolor={0,0,127}));
  connect(PAtm.y, sin.p_in) annotation (points=[83,46; 90,46; 90,12; 80,12],
      style(color=74, rgbcolor={0,0,127}));
  connect(sou.port, res1.port_a) 
                                annotation (points=[-38,6; -36,6; -36,6; -34,6; 
        -34,6; -30,6],style(color=69, rgbcolor={0,127,255}));
  connect(res2.port_b, sin.port) 
    annotation (points=[46,6; 49,6; 49,6; 52,6; 52,6; 58,6],
                                     style(color=69, rgbcolor={0,127,255}));
  connect(del.port_b, res2.port_a) annotation (points=[18,6; 26,6], style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(del.port_a, res1.port_b) annotation (points=[-2.2,6; -10,6], style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
end Delay;
