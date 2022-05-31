within Buildings.Fluid.HydronicConfigurations.Data;
record Generic "Record for hydronic configuration"
  extends Modelica.Icons.Record;

  extends Buildings.Fluid.HydronicConfigurations.Data.Configuration(have_ctl=
        true);

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(final min=0)=
    m2_flow_nominal
    "Mass flow rate in primary circuit at design conditions"
    annotation (Dialog(group="Nominal condition", enable=have_bypFix));

  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(final min=0)
    "Mass flow rate in consumer circuit at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dp2_nominal(displayUnit="Pa")
    "Consumer circuit pressure differential at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(displayUnit=
        "Pa")
    "Control valve pressure drop at design conditions"
    annotation (Dialog(group="Control valve"));

  parameter Modelica.Units.SI.PressureDifference dpBal1_nominal(displayUnit=
        "Pa")=0
    "Primary balancing valve pressure drop at design conditions"
    annotation (Dialog(group="Balancing valves"));

  parameter Modelica.Units.SI.PressureDifference dpBal2_nominal(displayUnit=
        "Pa")=0
    "Secondary balancing valve pressure drop at design conditions"
    annotation (Dialog(group="Balancing valves"));

  parameter Actuators.Valves.Data.Generic flowCharacteristics1(
    y={0,1},
    phi={0.0001,1})
    "Table with flow characteristics for direct flow path at port_1"
     annotation (
     Dialog(group="Control valve",
     enable=typCha==Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.Table),
     choicesAllMatching=true);
  parameter Actuators.Valves.Data.Generic flowCharacteristics3(
    y={0,1},
    phi={0.0001,1})
    "Table with flow characteristics for bypass flow path at port_3"
    annotation (
    Dialog(group="Control valve",
    enable=typCha==Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.Table),
    choicesAllMatching=true);

  replaceable parameter Movers.Data.Generic pum
    constrainedby Movers.Data.Generic(
      pressure(
        V_flow={0, 1, 2} * m2_flow_nominal / 996,
        dp={1.2, 1, 0.4} * dp2_nominal))
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
