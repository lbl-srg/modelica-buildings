within Districts.Electrical.Interfaces;
model PartialConversion
  extends Districts.Electrical.Interfaces.PartialTwoPort;
  Modelica.SIunits.Voltage v_p "Voltage drop between the two positive pins";
  Modelica.SIunits.Voltage v_n "Voltage drop between the two negative pins";
  Modelica.SIunits.Current i_p "Current flowing through the positive pins";
  Modelica.SIunits.Current i_n "Current flowing through the negative pins";
equation

  i_p = PhaseSystem_p.systemCurrent(terminal_p.i);
  i_n = PhaseSystem_n.systemCurrent(terminal_n.i);

  v_p = PhaseSystem_p.systemVoltage(terminal_p.v);
  v_n = PhaseSystem_n.systemVoltage(terminal_n.v);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end PartialConversion;
