within Districts.Electrical.DC.Interfaces;
partial model TwoPortConv
  "Partial class with two DC connectors ('positive' and 'negative') for DC converters"
  extends Districts.Electrical.DC.Interfaces.TwoPort;
  Modelica.SIunits.Voltage v_p "Voltage drop between the two positive pins";
  Modelica.SIunits.Voltage v_n "Voltage drop between the two negative pins";
  Modelica.SIunits.Current i_p "Current flowing through the positive pins";
  Modelica.SIunits.Current i_n "Current flowing through the negative pins";
protected
  Modelica.Blocks.Interfaces.RealOutput Pow_p;
  Modelica.Blocks.Interfaces.RealOutput Pow_n;
equation

  i_p = term_p.PhaseSystem.systemCurrent(term_p.i);
  i_n = term_n.PhaseSystem.systemCurrent(term_n.i);

  v_p = term_p.PhaseSystem.systemVoltage(term_p.v);
  v_n = term_n.PhaseSystem.systemVoltage(term_n.v);

  Pow_p = term_p.PhaseSystem.activePower(term_p.v,term_p.i);
  Pow_n = term_n.PhaseSystem.activePower(term_n.v,term_n.i);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end TwoPortConv;
