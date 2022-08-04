within Buildings.Fluid.Boilers.Data.Lochinvar.Crest;
record FBdash6001 "Specifications for Lochinvar Crest FB-6001 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501(
    Q_flow_nominal = 1689847.79,
    VWat = 1.150765182,
    mDry = 2136.873655,
    m_flow_nominal = 36.339953,
    dp_nominal = 51410.46);
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
end FBdash6001;
