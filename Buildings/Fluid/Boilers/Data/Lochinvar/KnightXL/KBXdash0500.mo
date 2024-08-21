within Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL;
record KBXdash0500 "Specifications for Lochinvar Knight XL KBX-0500 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.KBXdash0400(
    Q_flow_nominal = 142139.469,
    VWat = 0.018548518,
    m_flow_nominal = 3.028329,
    dp_nominal = 41845.72);
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
end KBXdash0500;
