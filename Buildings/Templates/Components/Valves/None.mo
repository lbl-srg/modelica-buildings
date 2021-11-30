within Buildings.Templates.Components.Valves;
model None "No valve"
  extends Buildings.Templates.Components.Valves.Interfaces.PartialValve(
    final typ=Buildings.Templates.Components.Types.Valve.None);

equation

  connect(port_aRet, port_bRet)
    annotation (Line(points={{-40,100},{-40,-100}}, color={0,127,255}));
  connect(port_aSup, port_bSup)
    annotation (Line(points={{40,-100},{40,100}}, color={0,127,255}));
end None;
