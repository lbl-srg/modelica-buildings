within Buildings.Fluid.Boilers.Data.Lochinvar.Crest;
record FBdash5001 "Specifications for Lochinvar Crest FB-5001 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.Crest.Curves(
    Q_flow_nominal = 1407913.42,
    VWat = 0.961494593,
    mDry = 1860.182309,
    dT_nominal = 11.111111,
    m_flow_nominal = 30.283294,
    dp_nominal = 41546.82);
  annotation (Documentation(info="<html>
Performance data for boiler model.
See the documentation 
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar\">
Buildings.Fluid.Boilers.Data.Lochinvar</a>
</html>"));
end FBdash5001;
