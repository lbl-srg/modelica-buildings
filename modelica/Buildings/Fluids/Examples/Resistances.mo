model Resistances "Test of multiple resistances" 
  annotation (Diagram, Commands(file=
          "Resistances.mos" "run"));
 package Medium = Buildings.Media.IdealGases.SimpleAir;
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
      annotation (extent=[40,60; 60,80]);
   parameter Modelica.SIunits.Pressure dp0 = 5 
    "Nominal pressure drop for each resistance";
    Modelica.Blocks.Sources.Ramp P(
      duration=1,
    height=2*dp0*nRes,
    offset=101325 - dp0*nRes) 
                 annotation (extent=[-80,60; -60,80]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou(redeclare package Medium = 
               Medium, T=273.15 + 20) annotation (extent=[-40,20;
        -20,40]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin(redeclare package Medium = 
               Medium, T=273.15 + 10) annotation (extent=[56,20;
        36,40]);
  parameter Integer nRes( min=2) = 3 "Number of resistances";
    Buildings.Fluids.FixedResistances.FixedResistanceDpM[
                       nRes] res(
    redeclare each package Medium = Medium,
    each dp0=dp0,
    each from_dp = false,
    each m0_flow=2) 
             annotation (extent=[0,20; 20,40]);
equation 
  connect(sou.port, res[1].port_a) 
    annotation (points=[-20,30; -5.55112e-16,30],
                                       style(color=69, rgbcolor={0,127,255}));
  connect(res[nRes].port_b, sin.port) 
    annotation (points=[20,30; 36,30], style(color=69, rgbcolor={0,127,255}));
  for i in 1:nRes-1 loop
  connect(res[i].port_b, res[i+1].port_a) annotation (points=[20,30; 26,30; 26,
          10; -8,10; -8,30; -5.55112e-16,30],
                   style(color=69, rgbcolor={0,127,255}));
  end for;
  connect(PAtm.y, sin.p_in) annotation (points=[61,70; 70,70; 70,36; 58,36],
      style(color=74, rgbcolor={0,0,127}));
  connect(P.y, sou.p_in) annotation (points=[-59,70; -52,70; -52,36; -42,36],
      style(color=74, rgbcolor={0,0,127}));
end Resistances;
