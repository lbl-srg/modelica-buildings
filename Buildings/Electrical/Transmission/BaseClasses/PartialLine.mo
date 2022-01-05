within Buildings.Electrical.Transmission.BaseClasses;
partial model PartialLine "Partial cable line dispersion model"
  extends Buildings.Electrical.Interfaces.PartialTwoPort;
  extends Buildings.Electrical.Transmission.BaseClasses.PartialBaseLine;
  Real VoltageLosses(unit = "1") = abs(PhaseSystem_p.systemVoltage(terminal_p.v) -
    PhaseSystem_n.systemVoltage(terminal_n.v))/
    Buildings.Utilities.Math.Functions.smoothMax(
      PhaseSystem_p.systemVoltage(terminal_p.v),
      PhaseSystem_n.systemVoltage(terminal_n.v),
      1.0) "Percentage of voltage losses across the line";
protected
  parameter Integer n_ = size(terminal_n.i,1) "Number of cables";
  parameter Real nominal_i_ = P_nominal / V_nominal
    "Nominal current flowing through the line";
  parameter Real nominal_v_ = V_nominal "Nominal voltage of the line";

  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Text(
            extent={{-150,-19},{150,-59}},
            textColor={0,0,0},
          textString="%name")}),
    Documentation(revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>", info="<html>
<p>
This partial model extends the model <a href=\"modelica://Buildings.Electrical.Transmission.BaseClasses.PartialBaseLine\">
Buildings.Electrical.Transmission.BaseClasses.PartialBaseLine</a>.
It adds two generalized electric connectors.
</p>
<h4>Note:</h4>
<p>
See <a href=\"modelica://Buildings.Electrical.Transmission.BaseClasses.PartialBaseLine\">
Buildings.Electrical.Transmission.BaseClasses.PartialBaseLine</a> for more information.
</p>
</html>"));
end PartialLine;
