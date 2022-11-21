within Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL;
record KBXdash0800 "Specifications for Lochinvar Knight XL KBX-0800 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.KBXdash0400(
    Q_flow_nominal = 227423.1503,
    VWat = 0.027633506,
    m_flow_nominal = 4.794855,
    dp_nominal = 50812.66);
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
end KBXdash0800;
