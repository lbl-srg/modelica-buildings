within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeometricData;
record c8x8_h110_b5_d600_T283
  "Square configuration of 64 boreholes of 110 meter with a spacing of 5.5 meter from each other. Initial temperature is 283K and the discretization is 600 seconds"
  extends Records.General(
    pathMod="IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeometricData.c8x8_h110_b5",
    pathCom = Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/GeometricData/c8x8_h110_b5.mo"),
    m_flow_nominal_bh=0.3,
    T_start=283.15,
    rBor=0.055,
    hBor=110,
    nbBh=64,
    cooBh={{0,0},{5.5,0},{11,0},{16.5,0},{22,0},{27.5,0},{33,0},{38.5,0},
           {0,5.5},{5.5,5.5},{11,5.5},{16.5,5.5},{22,5.5},{27.5,5.5},{33,5.5},{38.5,5.5},
           {0,11},{5.5,11},{11,11},{16.5,11},{22,11},{27.5,11},{33,11},{38.5,11},
           {0,16.5},{5.5,16.5},{11,16.5},{16.5,16.5},{22,16.5},{27.5,16.5},{33,16.5},{38.5,16.5},
           {0,22},{5.5,22},{11,22},{16.5,22},{22,22},{27.5,22},{33,22},{38.5,22},
           {0,27.5},{5.5,27.5},{11,27.5},{16.5,27.5},{22,27.5},{27.5,27.5},{33,27.5},{38.5,27.5},
           {0,33},{5.5,33},{11,33},{16.5,33},{22,33},{27.5,33},{33,33},{38.5,33},
           {0,38.5},{5.5,38.5},{11,38.5},{16.5,38.5},{22,38.5},{27.5,38.5},{33,38.5},{38.5,38.5}},
    rTub=0.02,
    kTub=0.5,
    eTub=0.002,
    xC=0.05,
    tStep=600,
    q_ste=21.99,
    nHor=10,
    rExt=3);
end c8x8_h110_b5_d600_T283;
