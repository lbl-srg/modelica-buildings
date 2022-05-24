within Buildings.Fluid.Boilers.Data.Lochinvar.FTXL;
record FTX500 "Specifications for Lochinvar FTXL FTX500 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.FTXL.FTX400(
    Q_flow_nominal=143311.7532,
    VWat=0.045424941,
    mDry=228.6105545,
    m_flow_nominal=3.091420,
    dp_nominal=3.091420);
    annotation (
  defaultComponentName = "per",
  defaultComponentPrefixes = "parameter",
  Documentation(info="<html>
<p>
Performance data for boiler model.
See the documentation of
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar\">
Buildings.Fluid.Boilers.Data.Lochinvar</a>.
</p>
</html>"));
end FTX500;
