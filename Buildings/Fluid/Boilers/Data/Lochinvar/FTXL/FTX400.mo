within Buildings.Fluid.Boilers.Data.Lochinvar.FTXL;
record FTX400 "Specifications for Lochinvar FTXL FTX400 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.FTXL.Curves(
    Q_flow_nominal=114883.8594,
    VWat=0.049210353,
    mDry=216.8171529,
    dT_nominal=11.111111,
    m_flow_nominal=2.460518,
    dp_nominal=10461.43);
  annotation (Documentation(info="<html>
Performance data for boiler model.
See the documentation 
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar\">
Buildings.Fluid.Boilers.Data.Lochinvar</a>
</html>"));
end FTX400;
