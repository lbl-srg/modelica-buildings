partial model PartialStaticTwoPortCoolingTower 
 package Medium_W = Buildings.Media.ConstantPropertyLiquidWater;
  
  parameter Modelica.SIunits.MassFlowRate mWat0_flow = 0.15 
    "Design air flow rate" 
      annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mAir0_flow = 1.64*1.2 
    "Design air flow rate" 
      annotation (Dialog(group="Nominal condition"));
  
  Modelica.Blocks.Sources.Constant TWat(k=273.15 + 35) "Water temperature" 
    annotation (extent=[-100,-60; -80,-40]);
  replaceable 
    Buildings.HeatExchangers.CoolingTowers.BaseClasses.PartialStaticTwoPortCoolingTower
    tow(   redeclare package Medium = Medium_W) "Cooling tower" 
    annotation (extent=[-18,-60; 2,-40]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin_1(T=283.15, redeclare 
      package Medium = Medium_W,
    p=101325)             annotation (extent=[80,-60; 60,-40],
                                                             rotation=0);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou_1(
    T=293.15,
    p=101335,
    redeclare package Medium = Medium_W) 
                          annotation (extent=[-56,-60; -36,-40]);
    Fluids.FixedResistances.FixedResistanceDpM res_1(
    from_dp=true,
    dp0=10,
    redeclare package Medium = Medium_W,
    m0_flow=mWat0_flow,
    dh=0.005) 
             annotation (extent=[20,-60; 40,-40]);
    Modelica.Blocks.Sources.Constant PWatIn(k=101335) 
      annotation (extent=[-100,-20; -80,0]);
  Modelica.Blocks.Sources.Sine TOut(amplitude=10, offset=293.15) 
    "Outside air temperature" annotation (extent=[-60,80; -40,100]);
equation 
  connect(TWat.y, sou_1.T_in) 
                             annotation (points=[-79,-50; -58,-50],
                                                                  style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sin_1.port, res_1.port_b) annotation (points=[60,-50; 40,-50],
             style(
      color=69,
      rgbcolor={0,127,255},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  annotation (Diagram);
  connect(PWatIn.y, sou_1.p_in) annotation (points=[-79,-10; -70,-10; -70,-44;
        -58,-44],
             style(color=74, rgbcolor={0,0,127}));
  connect(tow.port_a, sou_1.port) annotation (points=[-18,-50; -36,-50], style(
        color=69, rgbcolor={0,127,255}));
  connect(res_1.port_a, tow.port_b) 
    annotation (points=[20,-50; 2,-50], style(color=69, rgbcolor={0,127,255}));
end PartialStaticTwoPortCoolingTower;
