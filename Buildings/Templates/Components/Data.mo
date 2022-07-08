within Buildings.Templates.Components;
package Data "Records for design and operating parameters"
  extends Modelica.Icons.MaterialPropertiesPackage;

  record Coil "Record for coil model"
    extends Modelica.Icons.Record;

    parameter Buildings.Templates.Components.Types.Coil typ
      "Equipment type"
      annotation (Dialog(group="Configuration"));
    parameter Buildings.Templates.Components.Types.Valve typVal
      "Type of valve"
      annotation (Dialog(group="Configuration"));
    parameter Boolean have_sou
      "Set to true for fluid ports on the source side"
      annotation (Dialog(group="Configuration"));

    /*
  For evaporator coils this is also provided by the performance data record.
  The coil model shall generate a warning in case the design value exceeds
  the maximum value from the performance data record.
  */
    parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal(
      final min=0,
      start=if typ==Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage or
       typ==Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed then
       datCoi.sta[datCoi.nSta].nomVal.m_flow_nominal
      else 1)
      "Air mass flow rate"
      annotation (
        Dialog(group="Nominal condition",
        enable=typ<>Buildings.Templates.Components.Types.Coil.None and
        typ<>Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage and
        typ<>Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed));
    parameter Modelica.Units.SI.PressureDifference dpAir_nominal(
      final min=0,
      displayUnit="Pa",
      start=if typ==Buildings.Templates.Components.Types.Coil.None then 0 else
      100)
      "Air pressure drop"
      annotation (
        Dialog(group="Nominal condition",
          enable=typ<>Buildings.Templates.Components.Types.Coil.None));
    parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal(
      final min=0,
      start=if typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating then
       Q_flow_nominal / 4186 / 10 elseif
       typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling then
       -Q_flow_nominal / 4186 / 5 else
       0)
      "Liquid mass flow rate"
      annotation (
        Dialog(group="Nominal condition",
          enable=have_sou));
    parameter Modelica.Units.SI.PressureDifference dpWat_nominal(
      final min=0,
      displayUnit="Pa",
      start=if typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating then
      0.5e4 elseif typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling then
      3e4 else
      0)
      "Liquid pressure drop across coil"
      annotation(Dialog(group="Nominal condition",
        enable=have_sou));
    parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
      final min=0,
      displayUnit="Pa",
      start=if typVal==Buildings.Templates.Components.Types.Valve.None then 0
      else dpWat_nominal / 2)
      "Liquid pressure drop across fully open valve"
      annotation(Dialog(group="Nominal condition",
        enable=have_sou and typVal<>Buildings.Templates.Components.Types.Valve.None));
    parameter Modelica.Units.SI.HeatFlowRate cap_nominal(
      final min=0,
      start=if typ==Buildings.Templates.Components.Types.Coil.None then 0
      elseif typ==Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage or
       typ==Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed then
       abs(datCoi.sta[datCoi.nSta].nomVal.Q_flow_nominal)
      else 1e4)
      "Coil capacity"
      annotation(Dialog(group="Nominal condition",
        enable=typ<>Buildings.Templates.Components.Types.Coil.None and
        typ<>Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage and
        typ<>Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed));
    /*
  For evaporator coils this is also provided by the performance data record.
  The coil model shall generate a warning in case the design value exceeds
  the maximum value from the performance data record.
  */
    final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=
      if typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating or
         typ==Buildings.Templates.Components.Types.Coil.ElectricHeating then cap_nominal
      else -1 * cap_nominal
      "Nominal heat flow rate"
      annotation (Dialog(group="Nominal condition"));
    parameter Modelica.Units.SI.Temperature TWatEnt_nominal(
      final min=273.15,
      displayUnit="degC",
      start=if typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating then 50+273.15
      elseif typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling then 7+273.15
      else 273.15)
      "Nominal entering liquid temperature"
      annotation (Dialog(
        group="Nominal condition",
        enable=have_sou));
    parameter Modelica.Units.SI.Temperature TAirEnt_nominal(
      final min=273.15,
      displayUnit="degC",
      start=if typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling then 30+273.15
      else 273.15)
      "Nominal entering air temperature"
      annotation (Dialog(
        group="Nominal condition",
        enable=have_sou));
    parameter Modelica.Units.SI.MassFraction wAirEnt_nominal(
      final min=0,
      start=0.01)
      "Nominal entering air humidity ratio"
      annotation (Dialog(
        group="Nominal condition",
        enable=typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling));
    replaceable parameter
      Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.SingleSpeed.Carrier_Centurion_50PG06 datCoi
      constrainedby
      Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil
      "Performance data record of evaporator coil"
      annotation(choicesAllMatching=true, Dialog(
        enable=typ==Buildings.Templates.Components.Types.HeatExchanger.DXMultiStage or
        typ==Buildings.Templates.Components.Types.HeatExchanger.DXVariableSpeed));
  end Coil;

  record Damper "Record for damper model"
    extends Modelica.Icons.Record;

    parameter Buildings.Templates.Components.Types.Damper typ
      "Equipment type"
      annotation (Evaluate=true, Dialog(group="Configuration"));

    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(
      final min=0,
      start=if typ==Buildings.Templates.Components.Types.Damper.None then 0
      else 1)
      "Air mass flow rate"
      annotation (
        Dialog(group="Mechanical",
          enable=typ<>Buildings.Templates.Components.Types.Damper.None));
    parameter Modelica.Units.SI.PressureDifference dp_nominal(
      final min=0,
      displayUnit="Pa",
      start=if typ==Buildings.Templates.Components.Types.Damper.None then 0
      elseif typ==Buildings.Templates.Components.Types.Damper.PressureIndependent then 50
      else 15)
      "Air pressure drop"
      annotation (
        Dialog(group="Mechanical",
          enable=typ<>Buildings.Templates.Components.Types.Damper.None));
    parameter Modelica.Units.SI.PressureDifference dpFixed_nominal(
      final min=0,
      displayUnit="Pa")=0
      "Air pressure drop of fixed elements in series with damper"
      annotation (
        Dialog(group="Mechanical", enable=false));
  end Damper;

  record Fan "Record for fan model"
    extends Modelica.Icons.Record;

    parameter Buildings.Templates.Components.Types.Fan typ
      "Equipment type"
      annotation (Dialog(group="Configuration"));
    parameter Integer nFan(
      final min=0,
      start=1)
      "Number of fans"
      annotation (Dialog(group="Configuration",
        enable=typ==Buildings.Templates.Components.Types.Fan.ArrayVariable));
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(
      final min=0,
      start=if typ==Buildings.Templates.Components.Types.Fan.None then 0
      else 1)
      "Air mass flow rate"
      annotation (
        Dialog(group="Nominal condition",
          enable=typ <> Buildings.Templates.Components.Types.Fan.None));
    parameter Modelica.Units.SI.PressureDifference dp_nominal(
      final min=0,
      displayUnit="Pa",
      start=if typ==Buildings.Templates.Components.Types.Fan.None then 0
        else 500)
      "Total pressure rise"
      annotation (
      Dialog(group="Nominal condition",
      enable=typ <> Buildings.Templates.Components.Types.Fan.None));
    replaceable parameter Buildings.Fluid.Movers.Data.Generic per(
      pressure(
        V_flow={0, 1, 2} * m_flow_nominal / 1.2 / max(1, nFan),
        dp={1.5, 1, 0} * dp_nominal))
      constrainedby Buildings.Fluid.Movers.Data.Generic
      "Performance data"
      annotation (
        choicesAllMatching=true,
        Dialog(enable=typ <> Buildings.Templates.Components.Types.Fan.None),
        Placement(transformation(extent={{-90,-88},{-70,-68}})));
  end Fan;

  record Valve "Record for valve model"
    extends Modelica.Icons.Record;

    parameter Buildings.Templates.Components.Types.Valve typ
      "Equipment type"
      annotation (Evaluate=true, Dialog(group="Configuration"));

    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(
      final min=0,
      start=if typ==Buildings.Templates.Components.Types.Valve.None then 0
      else 1)
      "Nominal mass flow rate of fully open valve"
      annotation(Dialog(group="Nominal condition",
        enable=typ<>Buildings.Templates.Components.Types.Valve.None));
    parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
      final min=0,
      displayUnit="Pa",
      start=0)
      "Nominal pressure drop of fully open valve"
      annotation(Dialog(group="Nominal condition",
        enable=typ<>Buildings.Templates.Components.Types.Valve.None));
    parameter Modelica.Units.SI.PressureDifference dpFixed_nominal(
      final min=0,
      displayUnit="Pa")=0
      "Nominal pressure drop of pipes and other equipment in flow leg"
      annotation(Dialog(group="Nominal condition",
        enable=typ<>Buildings.Templates.Components.Types.Valve.None));
    parameter Modelica.Units.SI.PressureDifference dpFixedByp_nominal(
      final min=0,
      displayUnit="Pa")=dpFixed_nominal
      "Nominal pressure drop in the bypass line"
      annotation(Dialog(group="Nominal condition",
        enable=typ==Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition or
          typ==Buildings.Templates.Components.Types.Valve.ThreeWayModulating));

  end Valve;
annotation (Documentation(info="<html>
<p>
This package provides records for design and operating parameters.
</p>
</html>"));
end Data;
