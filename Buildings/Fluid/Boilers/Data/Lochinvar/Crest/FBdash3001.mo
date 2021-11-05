within Buildings.Fluid.Boilers.Data.Lochinvar.Crest;
record FBdash3001 "Specifications for Lochinvar Crest FB-3001 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.Crest.Curves(
    Q_flow_nominal = 844923.8948,
    VWat = 0.590524238,
    mDry = 1306.799618,
    dT_nominal = 11.111111,
    m_flow_nominal = 18.169977,
    dp_nominal = 23911.84);
  annotation (Documentation(info="<html>
Performance data for boiler model.
See the documentation 
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar\">
Buildings.Fluid.Boilers.Data.Lochinvar</a>.
</html>"));
end FBdash3001;
