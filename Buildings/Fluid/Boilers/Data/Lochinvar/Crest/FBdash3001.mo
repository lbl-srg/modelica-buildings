within Buildings.Fluid.Boilers.Data.Lochinvar.Crest;
record FBdash3001 "Specifications for Lochinvar Crest FB-3001 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501(
    Q_flow_nominal = 844923.8948,
    VWat = 0.590524238,
    mDry = 1306.799618,
    m_flow_nominal = 18.169977,
    dp_nominal = 23911.84);
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
end FBdash3001;
