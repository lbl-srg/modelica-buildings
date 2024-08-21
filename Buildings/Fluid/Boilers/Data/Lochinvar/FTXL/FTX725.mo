within Buildings.Fluid.Boilers.Data.Lochinvar.FTXL;
record FTX725 "Specifications for Lochinvar FTXL FTX725 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.FTXL.FTX400(
    Q_flow_nominal=206615.1044,
    VWat=0.064352,
    mDry=260.8156128,
    m_flow_nominal=4.479404,
    dp_nominal=14646.00);
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
end FTX725;
