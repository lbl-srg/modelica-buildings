within Buildings.Fluid.HydronicConfigurations.Data;
record Generic "Record for hydronic configuration"
  extends Modelica.Icons.Record;

  extends Buildings.Fluid.HydronicConfigurations.Data.Configuration;

  parameter Boolean use_lumFloRes = false
    "Set to true to lump secondary and valve flow resistance (typical of single served unit)";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(final min=0)
    "Mass flow rate at design conditions" annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpSec_nominal(
    final min=0,
    displayUnit="Pa")
    "Secondary pressure differential at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    final min=Modelica.Constants.eps,
    displayUnit="Pa")
    "Control valve pressure drop at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpBal1_nominal(
    final min=0,
    displayUnit="Pa") = 0
    "Primary balancing valve pressure drop at design conditions "
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpBal2_nominal(
    final min=0,
    displayUnit="Pa") = 0
    "Secondary balancing valve pressure drop at design conditions "
    annotation (Dialog(group="Nominal condition"));

  replaceable parameter Movers.Data.Generic pum
    constrainedby Movers.Data.Generic(
      pressure(
        V_flow={0, 1, 2} * m_flow_nominal / 996,
        dp={1.2, 1, 0.4} * dpSec_nominal))
    "Pump parameters"
    annotation (
    Dialog(group="Pump", enable=have_pum));

  parameter Controls ctl
    "Control parameters"
    annotation (
    Dialog(group="Controls", enable=have_ctl));

  annotation (defaultComponentName="dat", Documentation(info="<html>
<p>
Default pump characteristic based on design operating pump
</p>
</html>"));
end Generic;
