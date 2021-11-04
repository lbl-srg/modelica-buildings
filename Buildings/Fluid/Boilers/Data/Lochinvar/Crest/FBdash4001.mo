within Buildings.Fluid.Boilers.Data.Lochinvar.Crest;
record FBdash4001 "Specifications for Lochinvar Crest FB-4001 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.Crest.Curves(
    Q_flow_nominal = 1126272.122,
    VWat = 0.760867769,
    mDry = 1725.918968,
    dT_nominal = 11.111111,
    m_flow_nominal = 22.081569,
    dp_nominal = 32579.88);
  annotation (Documentation(info="<html>
Performance data for boiler model.
See the documentation 
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar\">
Buildings.Fluid.Boilers.Data.Lochinvar</a>
</html>"));
end FBdash4001;
