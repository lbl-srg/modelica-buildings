within Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL;
record KBXdash0650 "Specifications for Lochinvar Knight XL KBX-0650 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.KBXdash0400(
    Q_flow_nominal = 184781.3096,
    VWat = 0.023469553,
    m_flow_nominal = 3.911592,
    dp_nominal = 47823.68);
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
end KBXdash0650;
