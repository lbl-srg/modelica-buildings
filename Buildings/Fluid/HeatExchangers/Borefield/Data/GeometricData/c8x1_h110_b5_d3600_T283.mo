within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeometricData;
record c8x1_h110_b5_d3600_T283
  "Line configuration of 8 boreholes of 110 meter with a spacing of 5.5 meter from each other. Initial temperature is 283K and the discretization is 3600 seconds"
  extends Records.General(
    pathMod="IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeometricData.c8x1_h110_b5",
    pathCom = Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/GeometricData/c8x1_h110_b5.mo"),
    m_flow_nominal_bh=0.3,
    T_start=283.15,
    rBor=0.055,
    hBor=110,
    nbBh=8,
    cooBh={{0,0},{5.5,0},{11,0},{16.5,0},{22,0},{27.5,0},{33,0},{38.5,0}},
    rTub=0.02,
    kTub=0.5,
    eTub=0.002,
    xC=0.05,
    tStep=3600,
    q_ste=21.99,
    nHor=10,
    rExt=3);
end c8x1_h110_b5_d3600_T283;
