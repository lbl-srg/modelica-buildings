within Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL;
record KBXdash1000 "Specifications for Lochinvar Knight XL KBX-1000 boiler"
  extends Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.Curves(
    Q_flow_nominal = 283994.659,
    VWat = 0.033311624,
    dT_nominal =  11.111111,
    m_flow_nominal = 6.056659,
    dp_nominal = 53801.64);
  annotation (Documentation(info="<html>
Performance data for boiler model.
See the documentation 
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar\">
Buildings.Fluid.Boilers.Data.Lochinvar</a>
</html>"));
end KBXdash1000;
