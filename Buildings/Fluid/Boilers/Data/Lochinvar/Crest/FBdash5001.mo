within Buildings.Fluid.Boilers.Data.Lochinvar.Crest;
record FBdash5001 "Specifications for Lochinvar Crest FB-5001 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501(
    Q_flow_nominal = 1407913.42,
    VWat = 0.961494593,
    mDry = 1860.182309,
    m_flow_nominal = 30.283294,
    dp_nominal = 41546.82);
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
end FBdash5001;
