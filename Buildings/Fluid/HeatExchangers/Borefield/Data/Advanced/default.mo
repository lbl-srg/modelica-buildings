within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Advanced;
record default
  extends Records.Advanced(
    nHor=10,
    m_flow_nominal=0.3,
    z0=10,
    dT_dz=0,
    rExt=3,
    TExt0_start=283.15,
    pathMod="IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Advanced.default",
    pathCom = Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/Advanced/default.mo"));
end default;
