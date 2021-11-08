within Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL;
record KBXdash0400 "Specifications for Lochinvar Knight XL KBX-0400 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.Curves(
    Q_flow_nominal = 113427.2962,
    VWat = 0.016655812,
    dT_nominal =  11.111111,
    m_flow_nominal= 2.397427,
    dp_nominal = 29889.80);
  annotation (Documentation(info="<html>
<p>
Performance data for boiler model.
See the documentation 
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar\">
Buildings.Fluid.Boilers.Data.Lochinvar</a>.
</p>
</html>"));
end KBXdash0400;
