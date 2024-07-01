within Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL;
record KBXdash1000 "Specifications for Lochinvar Knight XL KBX-1000 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.KBXdash0400(
    Q_flow_nominal = 283994.659,
    VWat = 0.033311624,
    m_flow_nominal = 6.056659,
    dp_nominal = 53801.64);
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
end KBXdash1000;
