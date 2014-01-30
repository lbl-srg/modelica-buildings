within Buildings.Electrical.Transmission.Base;
partial model PartialLine "Cable line dispersion model"
  extends Buildings.Electrical.Interfaces.PartialTwoPort(terminal_n(i(nominal=
            nominal_i_), v(nominal=nominal_v_)), terminal_p(i(nominal=
            nominal_i_), v(nominal=nominal_v_)));
  extends Buildings.Electrical.Transmission.Base.PartialBaseLine;
  Real VoltageLosses = 100*abs(PhaseSystem_p.systemVoltage(terminal_p.v) - PhaseSystem_n.systemVoltage(terminal_n.v))/max(PhaseSystem_p.systemVoltage(terminal_p.v), PhaseSystem_n.systemVoltage(terminal_n.v))
    "Percentage of voltage losses across the line";
protected
  parameter Integer n_ = size(terminal_n.i,1);
  parameter Real nominal_i_ = P_nominal / V_nominal;
  parameter Real nominal_v_ = V_nominal;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Text(
            extent={{-150,-19},{150,-59}},
            lineColor={0,0,0},
          textString="%name")}));
end PartialLine;
